//
//  board.m
//  life
//
//  Created by Dan Baker on 5/9/13.
//  Copyright (c) 2013 BakerCrew. All rights reserved.
//

#import "LifeBoard.h"

#define BIT_CURRENT 0x01        // board state for the current tick (or the one being built)
#define BIT_LASTTICK 0x02       // board state for the previous tick

@interface LifeBoard ()
//@property (nonatomic, retain) NSMutableDictionary *board;
@property (nonatomic, assign) int theBoardWidth;
@property (nonatomic, assign) int theBoardHeight;
@end

@implementation LifeBoard {
    char* theBoard;
    char cellOffBoard;
}

- (void)setSize:(CGSize)size
{
    _size = size;
    self.theBoardWidth = size.width + 2;
    self.theBoardHeight = size.height + 2;
    [self buildBoard];
}

- (void)fillBoardRandomly
{
    [self buildBoard];
    [self everyCellPerformBlock:^(int x, int y) {
        int v = (arc4random() & 1)? BIT_CURRENT : 0;
        char* pCell = [self calculateBoardPointerAtX:x Y:y];
        *pCell = (char)v;
        
    }];
}

- (BOOL)isCellAliveAtX:(int)x Y:(int)y
{
    NSInteger v = [self valueForX:x Y:y];
    return v & BIT_CURRENT;
}
- (BOOL)isCellChangedAtX:(int)x Y:(int)y
{
    NSInteger v = [self valueForX:x Y:y];
    v = v & 3;
    if (v == 1 || v == 2) return YES;
//    if ((v & BIT_CURRENT) && !(v & BIT_LASTTICK))
//    {
//        return YES;
//    }
//    if (!(v & BIT_CURRENT) && (v & BIT_LASTTICK))
//    {
//        return YES;
//    }
    return NO;
}

- (NSInteger)valueForX:(int)x Y:(int)y
{
    char* pCell = [self calculateBoardPointerAtX:x Y:y];
    return *pCell;
}

- (void)tick
{
    [self advanceCycle];
    [self everyCellPerformBlock:^(int x, int y) {
        NSInteger newValue = [self cellNewStateAtX:x Y:y];
        if (newValue & BIT_CURRENT)
        {   // Opimization Note: only need to set the board value IF the cell is alive
            char *pCell = [self calculateBoardPointerAtX:x Y:y];
            *pCell = (char)newValue;
        }
    }];
}

- (NSInteger) cellNewStateAtX:(int)x Y:(int)y
{
    BOOL cellWasAlive = [self wasCellAliveAtX:x Y:y];
    int aliveNeighbors = [self countLiveNeighborsAtX:x Y:y];
    BOOL cellIsAlive = [self checkAliveWasAlive:cellWasAlive liveNeighbors:aliveNeighbors];
    NSInteger v = [self valueForX:x Y:y];
    if (cellIsAlive)
    {
        v |= BIT_CURRENT;
    }
    return v;
}

- (BOOL) checkAliveWasAlive:(BOOL)cellWasAlive liveNeighbors:(int)neighbors
{   // http://en.wikipedia.org/wiki/Conway's_Game_of_Life
    if (cellWasAlive)
    {
        if (neighbors < 2) return NO;                           // die from underpopulation
        if (neighbors == 2 || neighbors == 3) return YES;       // live on
        if (neighbors > 3) return NO;                           // die from overcrowding
    }
    else
    {
        if (neighbors == 3) return YES;                         // new cell from reproduction
    }
    return NO;
}

- (BOOL)wasCellAliveAtX:(int)x Y:(int)y
{
    NSInteger v = [self valueForX:x Y:y];
    return v & BIT_LASTTICK;
}

- (NSInteger)countLiveNeighborsAtX:(int)x Y:(int)y
{
    NSInteger count = 0;
    for(int dy=-1; dy<=1; dy++)
    {
        char* pCell = [self calculateBoardPointerAtX:x Y:y+dy];
        for(int dx=-1; dx<=1; dx++)
        {
            if (dx == 0 && dy == 0)
            {   // ignore cell
            } else {
                char v = *(pCell + dx);     // Note: Need to handle board wrapping
                if (v & BIT_LASTTICK) {
                    count++;
                }
            }
        }
    }
    return count;
}


- (void)advanceCycle
{
    [self everyCellPerformBlock:^(int x, int y) {
        char* pCell = [self calculateBoardPointerAtX:x Y:y];
        char cellValue = *pCell;
        cellValue = (cellValue << 1) & 0x7f;
        *pCell = cellValue;
    }];
}

- (void)everyCellPerformBlock:(void (^)(int x, int y))block
{
    for(int y=0; y<self.size.height; y++)
    {
        for(int x=0; x<self.size.width; x++)
        {
            block(x,y);
        }
    }
}

- (void) dealloc
{
    [self destroyBoard];
}

#pragma mark - Board Memory Management

- (void)buildBoard
{
    [self destroyBoard];
    theBoard = (char*)calloc(self.theBoardWidth * self.theBoardHeight, 1);
}
- (void)destroyBoard
{
    if (theBoard)
    {
        free(theBoard);
        theBoard = NULL;
    }
}
- (char*)calculateBoardPointerAtX:(int)x Y:(int)y
{   // Note: we have an empty row above and below and on each side of the board
    if (x >= 0 && x < self.size.width && y >= 0 && y < self.size.height)
    {
        int ofs = (y+1) * self.theBoardWidth + x;
        return &theBoard[ofs];
    }
    cellOffBoard = 0;
    return &cellOffBoard;
}

- (void)debugLogBoard
{
    __block int lastY = -123;
    NSMutableString *oneRow = [[NSMutableString alloc] init];
    [self everyCellPerformBlock:^(int x, int y) {
        if (lastY != y) {
            NSLog(@"%@", oneRow);
            [oneRow setString:@""];
            lastY = y;
        }
        BOOL v = [self isCellAliveAtX:x Y:y];
        [oneRow appendFormat:@"%@ ", (v? @"X" : @".")];
    }];
    NSLog(@"%@", oneRow);
}
@end

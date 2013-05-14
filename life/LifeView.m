//
//  LifeView.m
//  life
//
//  Created by Dan Baker on 5/10/13.
//  Copyright (c) 2013 BakerCrew. All rights reserved.
//

#import "LifeView.h"
#import "LifeBoard.h"

@interface LifeView ()
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, retain) NSMutableDictionary *allViews;
@end


@implementation LifeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setBoardSize:(CGSize)boardSize
{
    _boardSize = boardSize;
    // calculate size of each cell
    int w = self.bounds.size.width / boardSize.width;
    int h = self.bounds.size.height / boardSize.height;
    int siz = MIN(w,h);
    self.cellSize = CGSizeMake(siz,siz);
    [self buildAllCellViews];
}

- (void)buildAllCellViews
{
    self.allViews = [[NSMutableDictionary alloc] init];
    UIView *v;
    for(v in self.subviews)
    {
        [v removeFromSuperview];
    }
    for(int y=0; y<self.boardSize.height; y++)
    {
        for(int x=0; x<self.boardSize.width; x++)
        {
            CGRect f = CGRectMake(x*self.cellSize.width,y*self.cellSize.height, self.cellSize.width-1,self.cellSize.height-1);
            v = [[UIView alloc] initWithFrame:f];
            NSInteger nTag = [self viewTagFromX:x Y:y];
            [self.allViews setObject:v forKey:[NSNumber numberWithInteger:nTag]];
            v.tag = nTag;
            [self addSubview:v];
            v.backgroundColor = [UIColor redColor];
            v.alpha = 0;
        }
    }
}

- (NSInteger) viewTagFromX:(int)x Y:(int)y
{
    return y * self.boardSize.width + x + 123;
}

- (void)changeViaBoard:(LifeBoard *)board overTime:(CGFloat)seconds
{
    [board everyCellPerformBlock:^(int x, int y) {
        if ([board isCellChangedAtX:x Y:y])
        {
            NSInteger tag = [self viewTagFromX:x Y:y];
//            UIView *v = [self viewWithTag:tag];  // Note: REALLY slow
            UIView *v = [self.allViews objectForKey:[NSNumber numberWithInteger:tag]];
            BOOL isAlive = [board isCellAliveAtX:x Y:y];
            if (isAlive && v.alpha == 1) {
                
            } else if (!isAlive && v.alpha == 0) {
                
            } else {
//                [UIView animateWithDuration:seconds animations:^{
                    v.alpha = (isAlive? 1 : 0);
//                }];
            }
        }
    }];
}

@end

//
//  board.h
//  life
//
//  Created by Dan Baker on 5/9/13.
//  Copyright (c) 2013 BakerCrew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LifeBoard : NSObject

@property (nonatomic, assign) CGSize size;

- (void)fillBoardRandomly;
- (BOOL)isCellAliveAtX:(int)x Y:(int)y;
- (BOOL)isCellChangedAtX:(int)x Y:(int)y;

- (void)tick;
- (void)everyCellPerformBlock:(void (^)(int x, int y))block;
- (void)debugLogBoard;

@end

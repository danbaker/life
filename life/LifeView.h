//
//  LifeView.h
//  life
//
//  Created by Dan Baker on 5/10/13.
//  Copyright (c) 2013 BakerCrew. All rights reserved.
//
#import <UIKit/UIKit.h>
@class LifeBoard;

@interface LifeView : UIView

@property (nonatomic, assign) CGSize boardSize;

- (void)changeViaBoard:(LifeBoard*)board overTime:(CGFloat)seconds;

@end

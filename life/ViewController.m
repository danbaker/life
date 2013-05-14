//
//  ViewController.m
//  life
//
//  Created by Dan Baker on 5/9/13.
//  Copyright (c) 2013 BakerCrew. All rights reserved.
//

#import "ViewController.h"
#import "LifeBoard.h"
#import "LifeView.h"

@interface ViewController ()
@property (nonatomic, retain) LifeView* LifeView;
@property (nonatomic, retain) LifeBoard* board;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.board = [[LifeBoard alloc] init];
    self.board.size = CGSizeMake(300,300);
    
    CGRect frame = self.view.bounds;
    self.LifeView = [[LifeView alloc] initWithFrame:frame];
    self.LifeView.boardSize = self.board.size;
    [self.view addSubview:self.LifeView];
    self.LifeView.backgroundColor = [UIColor yellowColor];
    
    [self.board fillBoardRandomly];
    [self.LifeView changeViaBoard:self.board overTime:0];
    [self runOnce];
}

- (void)runOnce
{
    CGFloat seconds = 0.002;
    [self.board tick];
    [self.LifeView changeViaBoard:self.board overTime:seconds * 0.9];
    [self performSelector:@selector(runOnce) withObject:nil afterDelay:seconds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

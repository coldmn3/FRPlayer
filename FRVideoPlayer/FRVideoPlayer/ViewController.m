//
//  ViewController.m
//  FRVideoPlayer
//
//  Created by coldmn3 on 2017/8/15.
//  Copyright © 2017年 WFR. All rights reserved.
//

#import "ViewController.h"
#import "FRVideoView.h"

@interface ViewController ()
@property (nonatomic, strong) FRVideoView *videoView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videoView = [[FRVideoView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 240)];
    [self.view addSubview:self.videoView];
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end

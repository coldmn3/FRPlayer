//
//  FRVideoView.m
//  FRVideoPlayer
//
//  Created by coldmn3 on 2017/8/15.
//  Copyright © 2017年 WFR. All rights reserved.
//

#import "FRVideoView.h"

#import <IJKMediaFramework/IJKMediaFramework.h>
@import Masonry;


#import "FRVideoControlView.h"
#import "UIView+FRFrame.h"

@interface FRVideoView () <FRVideoControlViewDelegate>

@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;

@property (nonatomic, strong) IJKFFMoviePlayerController *ijkPlayer;

@end

@implementation FRVideoView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self _initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)_initialize {
    self.backgroundColor = [UIColor greenColor];
    self.controlView = [[FRVideoControlView alloc] init];
    self.controlView.delegate = self;
    
    [self addSubview:self.controlView];
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


#pragma mark - Logics

- (void)switchFullScreen {
    if (self.fullScreen) {
        [self switchToOrientation:UIInterfaceOrientationPortrait];
        self.fullScreen = NO;
    } else {
        [self switchToOrientation:UIInterfaceOrientationLandscapeRight];
        self.fullScreen = YES;
    }
}

#pragma mark - Orientation

- (void)switchToOrientation:(UIInterfaceOrientation)orientation {
    // 获取到当前状态条的方向
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    // 判断如果当前方向和要旋转的方向一致,那么不做任何操作
    if (currentOrientation == orientation) { return; }
    
    // 根据要旋转的方向,使用Masonry重新修改限制
    if (orientation != UIInterfaceOrientationPortrait) {//
        // 这个地方加判断是为了从全屏的一侧,直接到全屏的另一侧不用修改限制,否则会出错;
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            NSLog(@"after%@", NSStringFromCGRect([UIApplication sharedApplication].keyWindow.bounds));
            CGFloat height = [[UIScreen mainScreen] bounds].size.width;
            CGFloat width = [[UIScreen mainScreen] bounds].size.height;
            
            CGRect frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);
            
            self.frame = frame;
            
        }
    } else {
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsZero);
        }];
    }
    // iOS6.0之后,设置状态条的方法能使用的前提是shouldAutorotate为NO,也就是说这个视图控制器内,旋转要关掉;
    // 也就是说在实现这个方法的时候-(BOOL)shouldAutorotate返回值要为NO
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
    // 获取旋转状态条需要的时间:
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    // 更改了状态条的方向,但是设备方向UIInterfaceOrientation还是正方向的,这就要设置给你播放视频的视图的方向设置旋转
    // 给你的播放视频的view视图设置旋转
    self.transform = CGAffineTransformIdentity;
    self.transform = [self getTransformRotationAngle];
    // 开始旋转
    [UIView commitAnimations];
}

- (CGAffineTransform)getTransformRotationAngle {
    // 状态条的方向已经设置过,所以这个就是你想要旋转的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 根据要进行旋转的方向来计算旋转的角度
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

#pragma mark - FRVideoControlViewDelegate

- (void)fr_controlViewSwitchFullScreen:(UIView<FRVideoControlView> *)controlView {
    [self switchFullScreen];
}

@end

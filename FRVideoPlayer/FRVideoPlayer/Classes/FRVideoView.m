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

#pragma mark - Lifecycle

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
    self.viewState = FRVideoViewStateWindowed;
    self.toggleAnimationDuration = 0.35;
    self.backgroundColor = [UIColor greenColor];
    self.controlView = [[FRVideoControlView alloc] init];
    self.controlView.delegate = self;
    
    [self addNotifications];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onStatusBarOrientationChange)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

#pragma mark - Notifications

- (void)onDeviceOrientationChange {
    UIDeviceOrientation newOrientation = [UIDevice currentDevice].orientation;
    
    NSLog(@"onDeviceOrientationChange new Orientation -> %@", @(newOrientation));
    if (newOrientation == UIDeviceOrientationUnknown ||
        newOrientation == UIDeviceOrientationFaceUp ||
        newOrientation == UIDeviceOrientationFaceDown) {
        return;
    }
    
    switch (newOrientation) {
        case UIDeviceOrientationPortraitUpsideDown: {
            
        }
            break;
        case UIDeviceOrientationPortrait: {
            if (self.viewState == FRVideoViewStateFullscreen) {
                [self toggleView];
            }
        }
            break;
        case UIDeviceOrientationLandscapeLeft: {
            if (self.viewState == FRVideoViewStateWindowed) {
                [self toggleView];
            }
        }
            break;
        case UIDeviceOrientationLandscapeRight: {
            if (self.viewState == FRVideoViewStateWindowed) {
                [self toggleView];
            }
        }
            break;
        default:
            break;
    }
    
}

- (void)onStatusBarOrientationChange {
}

#pragma mark - Logics

- (void)toggleView {
    if (self.viewState == FRVideoViewStateWindowed) {
        [self enterFullscreen];
    } else if (self.viewState == FRVideoViewStateFullscreen) {
        [self exitFullscreen];
    }
}

#pragma mark - Toggle

- (void)enterFullscreen {
    if (self.viewState != FRVideoViewStateWindowed) {
        return;
    }
    
    self.viewState = FRVideoViewStateToggling;
    
    // TODO NSAssert superView
    // 记录进入全屏前的parentView & frame
    self.viewParentView = self.superview;
    self.windowedFrame = self.frame;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect rectInWindow = [self convertRect:self.bounds toView:keyWindow];
    
    [self removeFromSuperview];
    self.frame = rectInWindow;
    [keyWindow addSubview:self];
    
    [UIView animateWithDuration:self.toggleAnimationDuration animations:^{
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.bounds = CGRectMake(0, 0, CGRectGetHeight(self.superview.bounds), CGRectGetWidth(self.superview.bounds));
        self.center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));
    } completion:^(BOOL finished) {
        self.viewState = FRVideoViewStateFullscreen;
    }];
    
    [self refreshStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
}

- (void)exitFullscreen {
    if (self.viewState != FRVideoViewStateFullscreen) {
        return;
    }
    
    self.viewState = FRVideoViewStateToggling;
    
    CGRect frame = [self.viewParentView convertRect:self.windowedFrame toView:[UIApplication sharedApplication].keyWindow];
    [UIView animateWithDuration:self.toggleAnimationDuration animations:^{
        self.transform = CGAffineTransformIdentity;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.frame = self.windowedFrame;
        [self.viewParentView addSubview:self];
        self.viewState = FRVideoViewStateWindowed;
    }];
    
    [self refreshStatusBarOrientation:UIInterfaceOrientationPortrait];
}

- (void)refreshStatusBarOrientation:(UIInterfaceOrientation)interfaceOrientation {
    [[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation animated:NO];
}

#pragma mark - Orientation

#pragma mark - FRVideoControlViewDelegate

- (void)fr_controlViewSwitchFullScreen:(UIView<FRVideoControlView> *)controlView {
    [self toggleView];
}

@end

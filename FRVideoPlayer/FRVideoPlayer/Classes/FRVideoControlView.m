//
//  FRVideoControlView.m
//  FRVideoPlayer
//
//  Created by coldmn3 on 2017/8/16.
//  Copyright © 2017年 WFR. All rights reserved.
//

#import "FRVideoControlView.h"

#import "UIView+FRFrame.h"

#import "FRVideoPlayer.h"
@import Masonry;

const CGFloat kBottomViewHeight = 50;

@interface FRVideoControlView ()

@property (nonatomic, strong) UIImageView *bottomView;

@property (nonatomic, strong) UIButton *fullscreenButton;

@end

@implementation FRVideoControlView
@synthesize delegate = _delegate;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor redColor];
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.fullscreenButton];
        
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
        }];
        
        [self.fullscreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bottomView);
            make.right.equalTo(self.bottomView).offset(-16);
        }];
    }
    return self;
}


#pragma mark - Actions

- (void)fullscreenAction:(UIButton *)sender {
    sender.selected = !sender.selected;

    if ([self.delegate respondsToSelector:@selector(fr_controlViewSwitchFullScreen:)]) {
        [self.delegate fr_controlViewSwitchFullScreen:self];
    }
}

#pragma mark - Getters

- (id<FRVideoControlViewDelegate>)delegate {
    return _delegate;
}

- (UIImageView *)bottomView {
	if (!_bottomView) {
        _bottomView = [[UIImageView alloc] initWithImage:FRBundleImage(@"overlay_bottom_shadow")];
        _bottomView.userInteractionEnabled = YES;
	}
	return _bottomView;
}

- (UIButton *)fullscreenButton {
	if (!_fullscreenButton) {
        _fullscreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullscreenButton.adjustsImageWhenHighlighted = NO;
        [_fullscreenButton setImage:FRBundleImage(@"ic_fullscreen") forState:UIControlStateNormal];
        [_fullscreenButton setImage:FRBundleImage(@"ic_fullscreen_exit") forState:UIControlStateSelected];
        [_fullscreenButton addTarget:self action:@selector(fullscreenAction:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _fullscreenButton;
}
@end

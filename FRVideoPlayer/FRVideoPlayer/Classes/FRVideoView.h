//
//  FRVideoView.h
//  FRVideoPlayer
//
//  Created by coldmn3 on 2017/8/15.
//  Copyright © 2017年 WFR. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FRVideoControlViewProtocol.h"

typedef NS_ENUM(NSInteger, FRVideoViewState) {
    FRVideoViewStateWindowed,
    FRVideoViewStateFullscreen,
    FRVideoViewStateToggling
};

@interface FRVideoView : UIView

@property (nonatomic, strong) UIView<FRVideoControlView> *controlView;

@property (nonatomic, assign) FRVideoViewState viewState;

@property (nonatomic, weak) UIView *viewParentView;

@property (nonatomic, assign) CGRect windowedFrame;

@property (nonatomic, assign) CGFloat toggleAnimationDuration;

- (void)toggleView;

@end

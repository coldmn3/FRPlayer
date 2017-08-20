//
//  FRVideoControlViewDelegate.h
//  FRVideoPlayer
//
//  Created by coldmn3 on 2017/8/15.
//  Copyright © 2017年 WFR. All rights reserved.
//

@protocol FRVideoControlView;
@protocol FRVideoControlViewDelegate <NSObject>

@optional

- (void)fr_controlViewSwitchFullScreen:(UIView<FRVideoControlView> *)controlView;

@end

//
//  FRVideoView.h
//  FRVideoPlayer
//
//  Created by coldmn3 on 2017/8/15.
//  Copyright © 2017年 WFR. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FRVideoControlViewProtocol.h"

@interface FRVideoView : UIView

@property (nonatomic, strong) UIView<FRVideoControlView> *controlView;

@end

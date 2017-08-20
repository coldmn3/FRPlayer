//
//  FRVideoControlViewProtocol.h
//  FRVideoPlayer
//
//  Created by coldmn3 on 2017/8/16.
//  Copyright © 2017年 WFR. All rights reserved.
//

#import "FRVideoControlViewDelegate.h"

@protocol FRVideoControlView <NSObject>

@optional

@property (nonatomic, weak) id<FRVideoControlViewDelegate> delegate;

@end

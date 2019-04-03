//
//  DirtyView.h
//  Wukong
//
//  Created by apple on 2018/5/20.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RobotSwitchView.h"
#import "VoiceBroadcastView.h"

typedef void(^dirtyReloadViewBlock)(NSString *title);

@interface DirtyView : UIView

@property (nonatomic, strong) UIViewController *controller;

@property (nonatomic, strong) UIImageView *circleImage;
@property (nonatomic, strong) UILabel *nowDateLabel;
@property (nonatomic, strong) NSTimer *timer;

//开启机器人
@property (nonatomic, strong) UIButton *openRobotBtn;
//语音播报
@property (nonatomic, strong) UIButton *audioSetBtn;

@property (nonatomic, copy) dirtyReloadViewBlock dirtyReloadViewBlock;

@end

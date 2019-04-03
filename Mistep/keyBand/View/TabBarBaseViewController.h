//
//  TabBarBaseViewController.h
//  Mistep
//
//  Created by 迈诺科技 on 2016/9/24.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "PZBaseViewController.h"

#define KONEDAYSECONDS 86400


@interface TabBarBaseViewController : PZBaseViewController

@property (strong, nonatomic) UIView *navView;

@property (strong, nonatomic) UIView *alphaNavView;

@property (strong, nonatomic) UIView *backNavView;

@property (strong, nonatomic) UIButton *datePickBtn;

@property (strong, nonatomic) UIView *backView;

@property (strong, nonatomic) UIDatePicker *datePicker;

@property (strong, nonatomic) UIView *animationView;

@property (assign, nonatomic) BOOL haveTabBar;

- (NSMutableAttributedString *)makeAttributedStringWithnumBer:(NSString *)number Unit:(NSString *)unit WithFont:(int)font;

- (BOOL)isToday;

- (void)timeSecondsChanged;//秒数改变时。就动这个方法

- (void)shareButtonClick:(UIButton *)button;

@end

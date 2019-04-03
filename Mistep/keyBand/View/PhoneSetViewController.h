//
//  PhoneSetViewController.h
//  Wukong
//
//  Created by 迈诺科技 on 16/5/17.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "PZBaseViewController.h"

@interface PhoneSetViewController : PZBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UISwitch *phoneSwitch;

@property (strong, nonatomic) UITableView *timeTableView;

@property (strong, nonatomic) NSArray *dataArray;

@property (strong, nonatomic) UIView *shadowView;

@property (weak, nonatomic) IBOutlet UIView *choseTimeView;

@property (weak, nonatomic) IBOutlet UILabel *kChooseTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *kPhoneAlarmLabel;

@end

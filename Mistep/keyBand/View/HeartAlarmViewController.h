//
//  HeartAlarmViewController.h
//  Mistep
//
//  Created by 迈诺科技 on 15/12/25.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import "PZBaseViewController.h"

@interface HeartAlarmViewController : PZBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *maxTF;

@property (weak, nonatomic) IBOutlet UITextField *minTF;

@property (assign, nonatomic) BOOL state;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UILabel *leftWarningLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightWarningLabel;

@property (assign, nonatomic) int min;

@property (assign, nonatomic) int max;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *introducLabel;

@property (weak, nonatomic) IBOutlet UILabel *referenceLabel;


@property (weak, nonatomic) IBOutlet UILabel *fillInLabel;

@property (weak, nonatomic) IBOutlet UILabel *maxHRLabel;

@property (weak, nonatomic) IBOutlet UILabel *minHRLabel;

@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

@property (weak, nonatomic) IBOutlet UILabel *kNormalAreaLabel;


@end

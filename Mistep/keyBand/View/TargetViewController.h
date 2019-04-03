//
//  TargetViewController.h
//  keyBand
//
//  Created by 迈诺科技 on 15/11/11.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import "PZBaseViewController.h"

@interface TargetViewController : PZBaseViewController

@property (weak, nonatomic) IBOutlet UIView *dayView;


@property (weak, nonatomic) IBOutlet UIView *nightView;

@property (weak, nonatomic) IBOutlet UILabel *dayTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *nightTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *introducLabel;

@property (weak, nonatomic) IBOutlet UILabel *stepLabel;

@property (weak, nonatomic) IBOutlet UILabel *sleepLabel;

@property (weak, nonatomic) IBOutlet UIButton *completionBtn;

@end

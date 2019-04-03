//
//  BMIViewController.h
//  Wukong
//
//  Created by 迈诺科技 on 16/5/3.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PZBaseViewController.h"
@class EditPersonInformationViewController;




@interface BMIViewController : PZBaseViewController

typedef void(^BMIBlock)();

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *BMIButton;

@property (copy, nonatomic)  BMIBlock backBlock;

@property (copy, nonatomic)  BMIBlock okBlock;






@property (weak, nonatomic) IBOutlet UILabel *fanweiLabel;


@property (weak, nonatomic) IBOutlet UILabel *weightArea;


@property (assign , nonatomic) float height;

@property (assign, nonatomic) float weight;


@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@property (nonatomic,assign) BOOL isRegister;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *backButtonBig;

@end

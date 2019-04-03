//
//  EditPswViewController.h
//  keyBand
//
//  Created by 迈诺科技 on 15/12/15.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import "EditPersonInformationViewController.h"

@interface EditPswViewController : PZBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *oldPSW;

@property (weak, nonatomic) IBOutlet UITextField *twicePSW;


@property (weak, nonatomic) IBOutlet UITextField *reSurePSW;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *oldPSWLabel;

@property (weak, nonatomic) IBOutlet UILabel *twicePSWLabel;

@property (weak, nonatomic) IBOutlet UILabel *confirmLabel;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

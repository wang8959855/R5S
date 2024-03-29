//
//  RgistViewController.h
//  keyband
//
//  Created by 迈诺科技 on 15/10/28.
//  Copyright © 2015年 mainuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RgistViewController : PZBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;

@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@property (weak, nonatomic) IBOutlet UITextField *passWordSureTF;

@property (weak, nonatomic) IBOutlet UITextField *emailTF;




@property (copy, nonatomic) NSMutableDictionary *userCacheInfo;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *verificationButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *kUserNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *kPasswordLabel;
@property (weak, nonatomic) IBOutlet UILabel *kPassworkSureLabel;

@property (weak, nonatomic) IBOutlet UILabel *kEmailLabel;


@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

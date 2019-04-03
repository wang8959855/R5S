//
//  AboutViewController.h
//  keyBand
//
//  Created by 迈诺科技 on 15/11/17.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import "PZBaseViewController.h"

@interface AboutViewController : PZBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *khardVersionLabel;

@property (weak, nonatomic) IBOutlet UILabel *hardVersionLabel;

@property (strong, nonatomic) NSString *dataURL;

@property (strong, nonatomic) NSString *dataCacheURL;

@property (strong, nonatomic) NSDictionary *mcuDic;

@property (strong, nonatomic) MBProgressHUD *hud;

@property (strong, nonatomic) UIButton *updateButton;

@property (weak, nonatomic) IBOutlet UILabel *softVersionLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *introductLabel;

@property (weak, nonatomic) IBOutlet UILabel *softLabel;

@property (weak, nonatomic) IBOutlet UILabel *kHelpLabel;




@end

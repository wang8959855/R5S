//
//  EditPersonalInformationTwoViewController.h
//  Wukong
//
//  Created by apple on 2018/5/15.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "PZBaseViewController.h"
#import "EditPersonalInformationOneViewController.h"

@interface EditPersonalInformationTwoViewController : PZBaseViewController

//上传的字典
@property (strong, nonatomic) NSMutableDictionary *uploadInfoDic;

@property (assign, nonatomic) PickerViewName PickerViewType;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIView *animationView;

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

//冠心病
@property (weak, nonatomic) IBOutlet UITextField *CHDTF;
//
@property (weak, nonatomic) IBOutlet UITextField *heightTF;
@property (weak, nonatomic) IBOutlet UITextField *weightTF;
//高血压
@property (weak, nonatomic) IBOutlet UITextField *HypertensionTF;

//基准高压值
@property (weak, nonatomic) IBOutlet UITextField *SystolicPressureTF;
//基准低压值
@property (weak, nonatomic) IBOutlet UITextField *DiastolicPressureTF;
//餐后血糖值
@property (weak, nonatomic) IBOutlet UITextField *GluTF;

@end

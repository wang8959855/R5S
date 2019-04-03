//
//  EditPersonalInformationOneViewController.h
//  Wukong
//
//  Created by apple on 2018/5/15.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

typedef enum{
    PickerViewBirthday = 0,
    PickerViewHeight,
    PickerViewWeight,
    PickerViewSex,
    PickerViewCHD,//冠心病
    PickerViewHypertension,//高血压
    PickerViewSystolicPressure,//基准高压
    PickerViewDiastolicPressure,//基准低压
    PickerViewDiabetes,//糖尿病
    PickerViewPPBS,//餐后血糖值
}PickerViewName;

#import "PZBaseViewController.h"

@interface EditPersonalInformationOneViewController : PZBaseViewController

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *sexTF;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;

@property (strong, nonatomic) NSMutableDictionary *userCacheInfo;

//上传的字典
@property (strong, nonatomic) NSMutableDictionary *uploadInfoDic;

@property (assign, nonatomic) PickerViewName PickerViewType;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIView *animationView;

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

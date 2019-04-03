//
//  EditPersonInformationViewController.h
//  keyband
//
//  Created by 迈诺科技 on 15/10/28.
//  Copyright © 2015年 mainuo. All rights reserved.
//

#import "PZBaseViewController.h"




@interface EditPersonInformationViewController : PZBaseViewController

typedef enum{
    PickerViewBirthday1 = 0,
    PickerViewHeight2,
    PickerViewWeight3,
}PickerViewName1;

//typedef enum {
//    UnitStateNone = 1,
//    UnitStateBritishSystem,
//    UnitStateMetric,
//}UnitState;


@property (assign, nonatomic) PickerViewName1 PickerViewType;

@property (weak, nonatomic) IBOutlet UITextField *birthdayTF;

@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;


@property (weak, nonatomic) IBOutlet UITextField *heightTF;

@property (weak, nonatomic) IBOutlet UITextField *weightTF;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

@property (strong, nonatomic) NSMutableDictionary *userInfo;

@property (strong, nonatomic) UIPickerView *pickerView;

@property (assign, nonatomic) BOOL sex;

@property (strong, nonatomic) NSString *imageFilePath;

@property (assign, nonatomic) BOOL isEdit;

@property (assign, nonatomic) EditPersonState EditState;

@property (strong, nonatomic) NSMutableDictionary *userCacheInfo;

@property (strong, nonatomic) HCHCommonManager *commonManager;

@property (weak, nonatomic) IBOutlet UILabel *heightUnitLabel;

@property (weak, nonatomic) IBOutlet UILabel *weightUnitLabel;


@property (weak, nonatomic) IBOutlet UIImageView *tipImageView;

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@property (weak, nonatomic) IBOutlet UIButton *headBtn;

@property (strong, nonatomic) UIView *animationView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *sexsegument;

@property (weak, nonatomic) IBOutlet UISegmentedControl *unitSegument;

@property (nonatomic,assign) BOOL isRegister;

@property (weak, nonatomic) IBOutlet UITextField *text1;//低压 舒张压
@property (weak, nonatomic) IBOutlet UITextField *text2;//高压  收缩压
@property (weak, nonatomic) IBOutlet UIView *surfaceView;//是手表就显示这个界面
//@property ()
@property (weak, nonatomic) IBOutlet UILabel *correctLabel;

@end


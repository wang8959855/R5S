//
//  AlertUserInfomationViewController.h
//  Wukong
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "PZBaseViewController.h"
#import "EditPersonalInformationOneViewController.h"

@interface AlertUserInfomationViewController : PZBaseViewController

//上传的字典
@property (strong, nonatomic) NSMutableDictionary *uploadInfoDic;

@property (assign, nonatomic) PickerViewName PickerViewType;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIView *animationView;

@property (strong, nonatomic) NSString *imageFilePath;
@property (nonatomic, strong) UIImage *selectImage;

@end


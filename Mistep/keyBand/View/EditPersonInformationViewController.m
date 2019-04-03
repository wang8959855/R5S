//
//  EditPersonInformationViewController.m
//  keyband
//
//  Created by 迈诺科技 on 15/10/28.
//  Copyright © 2015年 mainuo. All rights reserved.
//

#import "EditPersonInformationViewController.h"
#import "UIImage+ForceDecode.h"
#import "RgistViewController.h"
#import "EditPswViewController.h"
#import "ViewController.h"
#import "BMIViewController.h"
#import "XueyaCorrectView.h"

#define kHEADER @"header"
#define kNICK @"user.nick"
#define kSEX @"user.gender"
#define kMAIL @"user.email"
#define kBIRTHDAY @"user.birthdate"
#define kHEIGHT @"user.height"
#define kWEIGHT @"user.weight"
#define kHEIGHTOFFSET 40
#define kWEIGHTOFFSET 30
#define heightCMtoINCH  0.3937008
#define weightKGtoLB  2.2046226


#define kState [[[NSUserDefaults standardUserDefaults] objectForKey:kUnitStateKye] intValue]

@interface EditPersonInformationViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,XueyaCorrectViewDelegate>
{
    UIView *_backView;
    BOOL keyBoard;
}
@property (strong, nonatomic)NSDate *datePickerDate;
@property (strong, nonatomic)UIDatePicker *datePicker;
@property (assign, nonatomic)BOOL  isChange;

@end

@implementation EditPersonInformationViewController

- (void)dealloc
{
    [self.commonManager removeObserver:self forKeyPath:@"state"];
    self.userInfo = nil;
    self.pickerView = nil;
    self.userCacheInfo = nil;
    self.commonManager = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}
//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:YES];
//
//}
- (void)setupView
{
    [self setXibLabel];
    _heightTF.userInteractionEnabled = NO;
    _weightTF.userInteractionEnabled = NO;
    _heightTF.enabled = false;
    _weightTF.enabled = false;
    _birthdayTF.enabled = false;
    _isChange = NO;
    // Do any additional setup after loading the view from its nib.
    _sex = 0 ;
    [self setHeaderView];
    
    [self canEditInfo];
    if (_userCacheInfo.allKeys.count != 0)
    {
        [self uploadView];
    }
    else
    {
        _userCacheInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginCache"];
        _userCacheInfo = [HCHCommonManager getInstance].userInfoDictionAry;
        if (_userCacheInfo && _userCacheInfo.count != 0)
        {
            [self uploadView];
        }
    }
    
    if (_EditState == EditPersonStateRegist)
    {
        _accountLabel.text =  _userInfo[@"user.account"];
    }
    else
    {
        _accountLabel.text = [HCHCommonManager getInstance].UserAcount;
    }
    
    self.commonManager = [HCHCommonManager getInstance];
    [self.commonManager addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    [self canEditInfo];
    _text1.keyboardType = UIKeyboardTypeNumberPad;
    _text2.keyboardType = UIKeyboardTypeNumberPad;
    _text1.placeholder = NSLocalizedString(@"舒张压", nil);
    _text2.placeholder = NSLocalizedString(@"收缩压", nil);
    _text1.layer.borderWidth = 0.5;
    _text2.layer.borderWidth = 0.5;
    _text1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _text2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _text1.layer.cornerRadius = 5;
    _text2.layer.cornerRadius = 5;
    uint supportNum = [[ADASaveDefaluts objectForKey:SUPPORTPAGEMANAGER] doubleValue];
    if (supportNum >> 7 & 1)
    {
        _surfaceView.hidden = YES;
    }
    else
    {
        _surfaceView.hidden = NO;
    }
    _text1.text = [ADASaveDefaluts objectForKey:BLOODPRESSURELOW];
    _text2.text = [ADASaveDefaluts objectForKey:BLOODPRESSUREHIGH];
}
- (void)setXibLabel
{
    if (kState == UnitStateBritishSystem)
    {
        _heightUnitLabel.text = @"inch";
        _weightUnitLabel.text = @"lb";
        [_unitSegument setSelectedSegmentIndex:1];
        
    }
    else
    {
        _heightUnitLabel.text = @"cm";
        _weightUnitLabel.text = @"kg";
        [self.unitSegument setSelectedSegmentIndex:0];
    }
    _correctLabel.text = NSLocalizedString(@"校正血压值", nil);
    _titleLabel.text = NSLocalizedString(@"个人资料", nil);
    _birthdayTF.placeholder = NSLocalizedString(@"请选择出生日期", nil);
    _heightTF.placeholder = NSLocalizedString(@"请输入身高", nil);
    _weightTF.placeholder = NSLocalizedString(@"请输入体重", nil);
    _informationLabel.text = NSLocalizedString(@"这些信息有助于设备采取更准确的信息！", nil);
    _nickNameTF.placeholder = NSLocalizedString(@"输入昵称", nil);
    
    NSDictionary * unSelectedTextAttr = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor grayColor]};
    [self.sexsegument setTitleTextAttributes:unSelectedTextAttr forState:UIControlStateNormal];
    NSDictionary * unselectedTextAttr = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.sexsegument setTitleTextAttributes:unselectedTextAttr forState:UIControlStateSelected];
    
    self.sexsegument.layer.borderColor = [UIColor grayColor].CGColor;
    self.sexsegument.layer.borderWidth = 1;
    self.sexsegument.layer.cornerRadius = 3;
    [self.sexsegument setTitle:NSLocalizedString(@"男", nil) forSegmentAtIndex:0];
    [self.sexsegument setTitle:NSLocalizedString(@"女", nil) forSegmentAtIndex:1];
    
    NSDictionary * unSelectedTextAttr1 = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor grayColor]};
    [self.unitSegument setTitleTextAttributes:unSelectedTextAttr1 forState:UIControlStateNormal];
    NSDictionary * unselectedTextAttr1 = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.unitSegument setTitleTextAttributes:unselectedTextAttr1 forState:UIControlStateSelected];
    
    self.unitSegument.layer.borderColor = [UIColor grayColor].CGColor;
    self.unitSegument.layer.borderWidth = 1;
    self.unitSegument.layer.cornerRadius = 3;
    [self.unitSegument setTitle:NSLocalizedString(@" 公制", nil) forSegmentAtIndex:0];
    [self.unitSegument setTitle:NSLocalizedString(@" 英制", nil) forSegmentAtIndex:1];
    
    UIImageView *nameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    nameImageView.contentMode = UIViewContentModeScaleAspectFit;
    _nickNameTF.leftView = nameImageView;
    _nickNameTF.leftViewMode = UITextFieldViewModeAlways;
    nameImageView.image = [UIImage imageNamed:@"头像拷贝"];
    
    UIImageView *birthDayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    birthDayImageView.contentMode = UIViewContentModeScaleAspectFit;
    _birthdayTF.leftView = birthDayImageView;
    _birthdayTF.leftViewMode = UITextFieldViewModeAlways;
    birthDayImageView.image = [UIImage imageNamed:@"日期"];
    
    
    UIImageView *heightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    heightImageView.contentMode = UIViewContentModeScaleAspectFit;
    _heightTF.leftView = heightImageView;
    _heightTF.leftViewMode = UITextFieldViewModeAlways;
    heightImageView.image = [UIImage imageNamed:@"身高"];
    
    UIImageView *weightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    weightImageView.contentMode = UIViewContentModeScaleAspectFit;
    _weightTF.leftView = weightImageView;
    _weightTF.leftViewMode = UITextFieldViewModeAlways;
    weightImageView.image = [UIImage imageNamed:@"体重"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    int state = [change[@"new"] intValue];
    NSString *heightUnit = @"cm";
    NSString *weightUnit = @"kg";
    int heightValue = [[_userCacheInfo objectForKey:@"height"] intValue];
    int weightValue = [[_userCacheInfo objectForKey:@"weight"] intValue];
    if (state  == UnitStateBritishSystem)
    {
        heightUnit = @"inch";
        weightUnit = @"lb";
        heightValue = (int)roundf(heightValue * heightCMtoINCH);
        weightValue = (int)roundf(weightValue * weightKGtoLB);
    }
    else
    {
        heightUnit = @"cm";
        weightUnit = @"kg";
        
    }
    _heightUnitLabel.text = heightUnit;
    _weightUnitLabel.text = weightUnit;
    //    if (_EditState != EditPersonStateRegist)
    //    {
    if (heightValue != 0 && weightValue != 0)
    {
        _heightTF.text = [NSString stringWithFormat:@"%d",heightValue];
        _weightTF.text = [NSString stringWithFormat:@"%d",weightValue];
    }
    //    }
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSNumber *state = nil;
    if (buttonIndex == 0)
    {
        return;
    }
    if (buttonIndex == 1)
    {
        state = [NSNumber numberWithInt:UnitStateBritishSystem];
    }
    else if (buttonIndex == 2)
    {
        state = [NSNumber numberWithInt:UnitStateMetric];
    }
    [[NSUserDefaults standardUserDefaults] setObject:state forKey:kUnitStateKye];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.commonManager.state = [state intValue];
}


- (void)uploadView
{
    int state = kState;
    NSString *heightUnit = @"cm";
    NSString *weightUnit = @"kg";
    int heightValue = [[[HCHCommonManager getInstance].userInfoDictionAry objectForKey:@"height"] intValue];
    int weightValue = [[[HCHCommonManager getInstance].userInfoDictionAry objectForKey:@"weight"] intValue];
    //    _informationLabel.text = [NSString stringWithFormat:@"BMI=%.1f",weightValue*10000.0/heightValue/heightValue];
    //    _tipImageView.hidden = YES;
    
    if (state  == UnitStateBritishSystem)
    {
        heightUnit = @"inch";
        weightUnit = @"lb";
        heightValue = (int)roundf(heightValue * heightCMtoINCH);
        weightValue = (int)roundf(weightValue * weightKGtoLB);
    }
    else
    {
        heightUnit = @"cm";
        weightUnit = @"kg";
    }
    
    _heightUnitLabel.text = heightUnit;
    _weightUnitLabel.text = weightUnit;
    
    if (_userCacheInfo[@"nick"]) _nickNameTF.text = _userCacheInfo[@"nick"];
    if ([_userCacheInfo[@"gender"] intValue] -1 >= 0) self.sex = [_userCacheInfo[@"gender"] intValue] -1;
    if (heightValue) self.heightTF.text =[NSString stringWithFormat:@"%d", heightValue];
    if (weightValue) self.weightTF.text = [NSString stringWithFormat:@"%d",weightValue];
    if (_userCacheInfo[@"birthdate"]) self.birthdayTF.text = [NSString stringWithFormat:@"%@",_userCacheInfo[@"birthdate"]];
    
    NSString *name = [[HCHCommonManager getInstance].userInfoDictionAry objectForKey:@"header"] ;
    if (name && (NSNull *)name != [NSNull null]) {
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:name];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (path && [fileManager fileExistsAtPath:path]) {
            
            [_headBtn setBackgroundImage:[[HCHCommonManager getInstance] getHeadImageWithFile:path] forState:UIControlStateNormal];
            
            [_headBtn setImage:nil forState:UIControlStateNormal];
        }
    }
    
}

- (void)canEditInfo
{
    if (!_isEdit)
    {
        for (UIView *view in self.view.subviews)
        {
            if (view.tag == 0)
            {
                view.userInteractionEnabled = NO;
            }
        }
        int heightValue = [[[HCHCommonManager getInstance].userInfoDictionAry objectForKey:@"height"] intValue];
        int weightValue = [[[HCHCommonManager getInstance].userInfoDictionAry objectForKey:@"weight"] intValue];
        _informationLabel.text = [NSString stringWithFormat:@"BMI=%.1f",weightValue*10000.0/heightValue/heightValue];
        _tipImageView.hidden = YES;
    }
    else
    {
        for (UIView *view in self.view.subviews)
        {
            view.userInteractionEnabled = YES;
        }
        _informationLabel.text = NSLocalizedString(@"这些信息有助于设备采取更准确的信息！", nil);
        _tipImageView.hidden = NO;
    }
    
    UIView *view = [self.view viewWithTag:102];
    [view removeFromSuperview];
    if (!_isEdit)
    {
        _userCacheInfo = [HCHCommonManager getInstance].userInfoDictionAry;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"..." forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:40];
        button.titleLabel.textAlignment = NSTextAlignmentRight;
        [button addTarget:self action:@selector(editPersonInformation) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button.tag = 102;
        button.sd_layout.rightSpaceToView(self.view,8)
        .topSpaceToView(self.view,15)
        .widthIs (50)
        .heightIs(30);
    }
    else
    {
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [okBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        [okBtn sizeToFit];
        [okBtn addTarget:self action:@selector(completeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:okBtn];
        [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        okBtn.tag = 102;
        okBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        okBtn.sd_layout.rightSpaceToView(self.view,3)
        .topSpaceToView(self.view,25)
        .widthIs(okBtn.width+15)
        .heightIs(30);
    }
}

- (NSMutableDictionary*)userInfo
{
    if (!_userInfo) {
        _userInfo = [[NSMutableDictionary alloc]init];
    }
    return _userInfo;
}

- (void)setHeaderView
{
    _headBtn.layer.cornerRadius = 40;
    _headBtn.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TF绑定方法

- (IBAction)editBegin:(UITextField *)sender
{
    if (!keyBoard) {
        
        CGPoint center = self.view.center;
        center.y -= 160;
        [UIView animateWithDuration:0.27 animations:^{
            self.view.center = center;
        }];
        keyBoard = YES;
    }
}

- (IBAction)editEnd:(UITextField *)sender
{
    
    [UIView animateWithDuration:0.27 animations:^{
        self.view.center = CurrentDeviceCenter;
    }];
    keyBoard = NO;
}

- (IBAction)TFClickReturnKey:(UITextField *)sender
{
    [self.view endEditing:YES];
}


- (void)setSex:(BOOL)sex
{
    if (_sex != sex)
    {
        _sex = sex;
        if (_sex)
        {
            [_sexsegument setSelectedSegmentIndex:1];
        }
        else
        {
            [_sexsegument setSelectedSegmentIndex:0];
        }
    }
}

#pragma mark - 按钮点击

// 修改个人资料
- (void)editPersonInformation
{
    UIActionSheet *actionSheet = nil;
    if ( [HCHCommonManager getInstance].isLogin && ![HCHCommonManager getInstance].isThirdPartLogin )
    {
        actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString (@"修改资料",nil),NSLocalizedString(@"修改密码",nil), nil];
    }
    else
    {
        actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString (@"修改资料",nil), nil];
    }
    
    //    表示是修改资料的的action
    actionSheet.tag = 110;
    [actionSheet showInView:self.view];
}

//返回按钮
- (IBAction)gobackClick:(id)sender
{
    if(_EditState == EditPersonStateRegist)
    {
        RgistViewController *registVC = self.navigationController.viewControllers[self.navigationController.viewControllers.count -2];
        registVC.userCacheInfo = _userCacheInfo;
        [self.view endEditing:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    //    else if (_EditState == EditPersonStateEdit)
    //    {
    //        [self backToHome];
    //    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        
        //        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        ViewController *welVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"main"];
        //        [self popToViewController:welVC animationType:nil];
    }
}

//  选择头像
- (IBAction)headBtnClick:(UIButton *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"请选择获取方式", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"拍摄新的照片",nil),NSLocalizedString(@"从相册获取",nil), nil];
    [self.view endEditing:YES];
    [actionSheet showInView:self.view];
}

- (IBAction)sexValueChanged:(UISegmentedControl *)sender {
    [self.view endEditing:YES];
    
    if (sender.selectedSegmentIndex == 0)
    {
        self.sex = 0;
    }
    else
    {
        self.sex = 1;
    }
}


//性别选择

- (IBAction)unitSegmentValueChanged:(UISegmentedControl *)sender {
    NSNumber *state = nil;
    if (sender.selectedSegmentIndex == 0)
    {
        state = [NSNumber numberWithInt:UnitStateMetric];
    }else{
        state = [NSNumber numberWithInt:UnitStateBritishSystem];
    }
    [[NSUserDefaults standardUserDefaults] setObject:state forKey:kUnitStateKye];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.commonManager.state = [state intValue];
}



- (void)completeAction:(UIButton *)sender
{
    if ([self checkUserInfo])
    {
        
        if (_EditState == EditPersonStateEdit && [HCHCommonManager getInstance].isLogin)
        {
            
            NSMutableDictionary *infoDic = [[NSMutableDictionary alloc]init];
            _userCacheInfo = [HCHCommonManager getInstance].userInfoDictionAry;
            
            NSDateFormatter *formater = [NSDateFormatter new];
            [formater setDateFormat:@"yyyy-MM-dd"];
            NSString *string = [formater stringFromDate:_datePickerDate];
            int height = [_heightTF.text intValue];
            int weight = [_weightTF.text intValue];
            if (kState == UnitStateBritishSystem)
            {
                height = (int)roundf([_heightTF.text intValue]*2.54);
                weight = (int)roundf([_weightTF.text intValue]*0.4535924);
            }
            if (![_userCacheInfo[@"_nickNameTF"] isEqualToString:_nickNameTF.text])
            {
                [infoDic setObject:_nickNameTF.text forKey:kNICK];
            }
            if (![_userCacheInfo[@"birthdate"] isEqualToString:_birthdayTF.text])
            {
                [infoDic setObject:string forKey:kBIRTHDAY];
            }
            if ([_userCacheInfo[@"gender"] intValue] != _sex + 1)
            {
                [infoDic setObject:[NSNumber numberWithInt:_sex + 1] forKey:kSEX];
            }
            [infoDic setObject:[NSNumber numberWithInt:height] forKey:kHEIGHT];
            [infoDic setObject:[NSNumber numberWithInt:weight] forKey:kWEIGHT];
            if ([HCHCommonManager getInstance].isThirdPartLogin)
            {
                NSString *name = [[HCHCommonManager getInstance].userInfoDictionAry objectForKey:@"header"] ;
                if (name && (NSNull *)name != [NSNull null]) {
                    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
                    if (!_imageFilePath) {
                        _imageFilePath = [cacheDir stringByAppendingPathComponent:name];
                    }
                }
            }
            
            //            if (infoDic[kWEIGHT] || infoDic[kHEIGHT])
            if(_isChange)
            {
                __weak EditPersonInformationViewController *weakSelf = self;
                BMIViewController *bmiVC = [[BMIViewController alloc] init];
                bmiVC.height = [_heightTF.text floatValue];
                bmiVC.weight = [_weightTF.text floatValue];
                bmiVC.okBlock = ^{
                    [weakSelf addActityIndicatorInView:weakSelf.view labelText:NSLocalizedString(@"正在修改...", nil) detailLabel:NSLocalizedString(@"正在修改...", nil)];
                    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:@"user_updateInfor" fileUrl:_imageFilePath params:infoDic Block:^(id responseObject, NSError *error) {
                        //adaLog(@"responseObject[msg] - %@",responseObject[@"msg"]);
                        if (error)
                        {
                            [weakSelf removeActityIndicatorFromView:weakSelf.view];
                            [weakSelf addActityTextInView:self.view text:NSLocalizedString(@"网络连接错误", ni) deleyTime:1.5f];//@"服务器异常"
                        }else
                        {
                            
                            int code = [[responseObject objectForKey:@"code"] intValue];
                            if (code != 9001)
                            {
                                [weakSelf removeActityIndicatorFromView:weakSelf.view];
                                
                            }
                            if (code == 100)
                            {
                                [weakSelf addActityTextInView:weakSelf.view text:NSLocalizedString(@"服务器异常", nil) deleyTime:1.5f];
                            }else if(code == 9003)
                            {
                                int height = [_heightTF.text intValue];
                                int weight = [_weightTF.text intValue];
                                if (kState == UnitStateBritishSystem)
                                {
                                    height = (int)roundf([_heightTF.text intValue]*2.54);
                                    weight = (int)roundf([_weightTF.text intValue]*0.4535924);
                                }
                                [self addActityTextInView:weakSelf.view text:NSLocalizedString(@"修改成功", nil) deleyTime:1.5f];
                                _imageFilePath = [[HCHCommonManager getInstance] saveImageFromCache];
                                [[HCHCommonManager getInstance] setUserHeaderWith:[_imageFilePath lastPathComponent]];
                                [[HCHCommonManager getInstance] setUserNickWith:_nickNameTF.text];
                                [[HCHCommonManager getInstance] setUserBirthdateWith:_birthdayTF.text];
                                [[HCHCommonManager getInstance] setUserHeightWith:[NSString stringWithFormat:@"%d",height]];
                                [[HCHCommonManager getInstance] setUserWeightWith:[NSString stringWithFormat:@"%d",weight]];
                                [[HCHCommonManager getInstance] setUserNickWith:_nickNameTF.text];
                                [[HCHCommonManager getInstance] setUserGenderWith:[NSString stringWithFormat:@"%d",_sex+1]];
                                _isEdit = NO;
                                
                                [[NSUserDefaults standardUserDefaults] setObject:[HCHCommonManager getInstance].userInfoDictionAry forKey:@"loginCache"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                  [[PZBlueToothManager sharedInstance] setBindDatepz];//发送页面的配置信息
                                [weakSelf canEditInfo];
                                if ([HCHCommonManager getInstance].isFirstLogin)
                                {
                                    [weakSelf loginHome];
                                }
                                
                            } else if (code == 9004){
                                [weakSelf addActityTextInView:self.view text:NSLocalizedString(@"服务器异常", nil) deleyTime:1.5f];
                            } else if (code == 9001){
                                
                                [weakSelf loginStateTimeOutWithBlock:^(BOOL state) {
                                    if (state)
                                    {
                                        [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:@"user_updateInfor" fileUrl:_imageFilePath params:infoDic Block:^(id responseObject, NSError *error) {
                                            [weakSelf removeActityIndicatorFromView:weakSelf.view];
                                            if (error) {
                                                [weakSelf addActityTextInView:weakSelf.view text:NSLocalizedString(@"网络连接错误", nil) deleyTime:1.5f];
                                            }else {
                                                int code = [[responseObject objectForKey:@"code"] intValue];
                                                if (code == 100) {
                                                    [weakSelf addActityTextInView:weakSelf.view text:NSLocalizedString(@"服务器异常", nil) deleyTime:1.5f];
                                                }else if(code == 9003) {
                                                    [weakSelf addActityTextInView:weakSelf.view text:NSLocalizedString(@"修改成功", nil) deleyTime:1.5f];
                                                    int height = [_heightTF.text intValue];
                                                    int weight = [_weightTF.text intValue];
                                                    if (kState == UnitStateBritishSystem)
                                                    {
                                                        height = (int)roundf([_heightTF.text intValue]*2.54);
                                                        weight = (int)roundf([_weightTF.text intValue]*0.4535924);
                                                    }
                                                    _imageFilePath = [[HCHCommonManager getInstance] saveImageFromCache];
                                                    
                                                    [[HCHCommonManager getInstance] setUserHeaderWith:[_imageFilePath lastPathComponent]];
                                                    [[HCHCommonManager getInstance] setUserNickWith:_nickNameTF.text];
                                                    _isEdit = NO;
                                                    [[HCHCommonManager getInstance] setUserBirthdateWith:_birthdayTF.text];
                                                    [[HCHCommonManager getInstance] setUserHeightWith:[NSString stringWithFormat:@"%d",height]];
                                                    [[HCHCommonManager getInstance] setUserWeightWith:[NSString stringWithFormat:@"%d",weight]];
                                                    [[HCHCommonManager getInstance] setUserNickWith:_nickNameTF.text];
                                                    [[HCHCommonManager getInstance] setUserGenderWith:[NSString stringWithFormat:@"%d",_sex+1]];
                                                    [weakSelf canEditInfo];
                                                    //为了改本地配置文件。保存本地
                                                    [[NSUserDefaults standardUserDefaults] setObject:[HCHCommonManager getInstance].userInfoDictionAry forKey:@"loginCache"];
                                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                                    [[PZBlueToothManager sharedInstance] setBindDatepz];//发送页面的配置信息
                                                } else if (code == 9004) {
                                                    [weakSelf addActityTextInView:weakSelf.view text:NSLocalizedString(@"服务器异常", nil) deleyTime:1.5f];
                                                }else {
                                                    [weakSelf addActityTextInView:weakSelf.view text:NSLocalizedString(@"修改失败", nil) deleyTime:1.5f];
                                                }
                                            }
                                        }];
                                    }
                                }];
                            }
                        }
                    }];
                };
                [self presentViewController:bmiVC animated:YES completion:nil];
                return;
            }
            [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"正在修改...", nil) detailLabel:NSLocalizedString(@"正在修改...", nil)];
            
            [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:@"user_updateInfor" fileUrl:_imageFilePath params:infoDic Block:^(id responseObject, NSError *error) {
                if (error)
                {
                    [self removeActityIndicatorFromView:self.view];
                    [self addActityTextInView:self.view text:NSLocalizedString(@"网络连接错误", ni) deleyTime:1.5f];
                }
                else
                {
                    int code = [[responseObject objectForKey:@"code"] intValue];
                    if (code != 9001)
                    {
                        [self removeActityIndicatorFromView:self.view];
                        
                    }
                    if (code == 100)
                    {
                        [self addActityTextInView:self.view text:NSLocalizedString(@"服务器异常", nil) deleyTime:1.5f];
                    }else if(code == 9003)
                    {
                        int height = [_heightTF.text intValue];
                        int weight = [_weightTF.text intValue];
                        if (kState == UnitStateBritishSystem)
                        {
                            height = (int)roundf([_heightTF.text intValue]*2.54);
                            weight = (int)roundf([_weightTF.text intValue]*0.4535924);
                        }
                        [self addActityTextInView:self.view text:NSLocalizedString(@"修改成功", nil) deleyTime:1.5f];
                        _imageFilePath = [[HCHCommonManager getInstance] saveImageFromCache];
                        
                        [[HCHCommonManager getInstance] setUserHeaderWith:[_imageFilePath lastPathComponent]];
                        [[HCHCommonManager getInstance] setUserNickWith:_nickNameTF.text];
                        [[HCHCommonManager getInstance] setUserBirthdateWith:_birthdayTF.text];
                        [[HCHCommonManager getInstance] setUserHeightWith:[NSString stringWithFormat:@"%d",height]];
                        [[HCHCommonManager getInstance] setUserWeightWith:[NSString stringWithFormat:@"%d",weight]];
                        [[HCHCommonManager getInstance] setUserNickWith:_nickNameTF.text];
                        [[HCHCommonManager getInstance] setUserGenderWith:[NSString stringWithFormat:@"%d",_sex+1]];
                        //为了改本地配置文件。保存本地
                        [[NSUserDefaults standardUserDefaults] setObject:[HCHCommonManager getInstance].userInfoDictionAry forKey:@"loginCache"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [[PZBlueToothManager sharedInstance] setBindDatepz];//发送页面的配置信息
                        _isEdit = NO;
                        [self canEditInfo];
                        
                    } else if (code == 9004)
                    {
                        [self addActityTextInView:self.view text:NSLocalizedString(@"服务器异常", nil) deleyTime:1.5f];
                    } else if (code == 9001)
                    {
                        
                        [self loginStateTimeOutWithBlock:^(BOOL state) {
                            if (state)
                            {
                                [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:@"user_updateInfor" fileUrl:_imageFilePath params:infoDic Block:^(id responseObject, NSError *error) {
                                    [self removeActityIndicatorFromView:self.view];
                                    if (error) {
                                        [self addActityTextInView:self.view text:NSLocalizedString(@"网络连接错误", nil) deleyTime:1.5f];
                                    }else {
                                        int code = [[responseObject objectForKey:@"code"] intValue];
                                        if (code == 100) {
                                            [self addActityTextInView:self.view text:NSLocalizedString(@"服务器异常", nil) deleyTime:1.5f];
                                        }else if(code == 9003) {
                                            [self addActityTextInView:self.view text:NSLocalizedString(@"修改成功", nil) deleyTime:1.5f];
                                            int height = [_heightTF.text intValue];
                                            int weight = [_weightTF.text intValue];
                                            if (kState == UnitStateBritishSystem)
                                            {
                                                height = (int)roundf([_heightTF.text intValue]*2.54);
                                                weight = (int)roundf([_weightTF.text intValue]*0.4535924);
                                            }
                                            
                                            _imageFilePath = [[HCHCommonManager getInstance] saveImageFromCache];
                                            
                                            [[HCHCommonManager getInstance] setUserHeaderWith:[_imageFilePath lastPathComponent]];
                                            [[HCHCommonManager getInstance] setUserNickWith:_nickNameTF.text];
                                            _isEdit = NO;
                                            [[HCHCommonManager getInstance] setUserBirthdateWith:_birthdayTF.text];
                                            [[HCHCommonManager getInstance] setUserHeightWith:[NSString stringWithFormat:@"%d",height]];
                                            [[HCHCommonManager getInstance] setUserWeightWith:[NSString stringWithFormat:@"%d",weight]];
                                            [[HCHCommonManager getInstance] setUserNickWith:_nickNameTF.text];
                                            [[HCHCommonManager getInstance] setUserGenderWith:[NSString stringWithFormat:@"%d",_sex+1]];
                                            //为了改本地配置文件。保存本地
                                            [[NSUserDefaults standardUserDefaults] setObject:[HCHCommonManager getInstance].userInfoDictionAry forKey:@"loginCache"];
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                            [[PZBlueToothManager sharedInstance] setBindDatepz];//发送页面的配置信息
                                            [self canEditInfo];
                                            
                                        } else if (code == 9004) {
                                            [self addActityTextInView:self.view text:NSLocalizedString(@"服务器异常", nil) deleyTime:1.5f];
                                        }else {
                                            [self addActityTextInView:self.view text:NSLocalizedString(@"修改失败", nil) deleyTime:1.5f];
                                        }
                                    }
                                }];
                            }
                        }];
                    }
                }
            }];
        }
        else if (_EditState == EditPersonStateRegist)
        {
            [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"正在注册...", nil) detailLabel:NSLocalizedString(@"正在注册...", nil)];
            [_userInfo setObject:_nickNameTF.text forKey:kNICK];
            
            NSString *string = _birthdayTF.text;
            int height = [_heightTF.text intValue];
            int weight = [_weightTF.text intValue];
            if (kState == UnitStateBritishSystem)
            {
                height = (int)roundf([_heightTF.text intValue]*2.54);
                weight = (int)roundf([_weightTF.text intValue]*0.4535924);
            }
            
            
            
            [_userInfo setObject: string forKey:kBIRTHDAY];
            [_userInfo setObject:[NSNumber numberWithInt:(_sex+1)] forKey:kSEX];
            [_userInfo setObject:[NSNumber numberWithInt:height] forKey:kHEIGHT];
            [_userInfo setObject:[NSNumber numberWithInt:weight] forKey:kWEIGHT];
            
            self.userCacheInfo = nil;
            _userCacheInfo = [[NSMutableDictionary alloc] init];
            //            [_userCacheInfo setObject:_eMailTF.text forKey:@"email"];
            [_userCacheInfo setObject:_nickNameTF.text forKey:@"nick"];
            [_userCacheInfo setObject:string forKey:@"birthdate"];
            [_userCacheInfo setObject:[NSNumber numberWithInt:(_sex +1)] forKey:@"gender"];
            [_userCacheInfo setObject:[NSNumber numberWithInt:height] forKey:@"height"];
            [_userCacheInfo setObject:[NSNumber numberWithInt:weight] forKey:@"weight"];
            
            //            [HCHCommonManager getInstance].userInfoDictionAry = [[NSMutableDictionary alloc]initWithDictionary:_userCacheInfo];
            [[HCHCommonManager getInstance] setUserBirthdateWith:string];
            [[HCHCommonManager getInstance] setUserHeightWith:[NSString stringWithFormat:@"%d",height]];
            [[HCHCommonManager getInstance] setUserWeightWith:[NSString stringWithFormat:@"%d",weight]];
            [[HCHCommonManager getInstance] setUserNickWith:_nickNameTF.text];
            [[HCHCommonManager getInstance] setUserGenderWith:[NSString stringWithFormat:@"%d",_sex+1]];
            [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:@"user_register" fileUrl:_imageFilePath params:_userInfo Block:^(id responseObject, NSError *error) {
                
                [self removeActityIndicatorFromView:self.view];
                
                if (error) {
                    [self addActityTextInView:self.view text:NSLocalizedString(@"网络连接错误", nil) deleyTime:1.5f];
                    adaLog(@"error  ===== %@",error);
                }else {
                    int code = [[responseObject objectForKey:@"code"] intValue];
                    if (code == 100) {
                        [self addActityTextInView:self.view text:NSLocalizedString(@"此帐号已注册", nil) deleyTime:1.5f];
                        
                    }else if(code == 9003) {
                        NSDictionary *loginDic = [NSDictionary dictionaryWithObjectsAndKeys:_userInfo[@"user.account"],@"account",_userInfo[@"user.password"] ,@"password", nil];
                        
                        [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"正在登录", nil) detailLabel:NSLocalizedString(@"正在登录", nil)];
                        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"user_login" ParametersDictionary:loginDic Block:^(id responseObject, NSError *error,NSURLSessionDataTask *task)
                         {
                             [self removeActityIndicatorFromView:self.view];
                             if (error)
                             {
                                 [self addActityTextInView:self.view text:NSLocalizedString(@"网络连接错误", nil) deleyTime:1.5f];
                             }
                             else
                             {
                                 int code = [[responseObject objectForKey:@"code"] intValue];
                                 if (code == 9003)
                                 {
                                     
                                     [ADASaveDefaluts setObject:@"1" forKey:LOGINTYPE];
                                     [self addActityTextInView:self.view text:NSLocalizedString(@"登录成功", nil) deleyTime:1.5f];
                                     [AllTool startUpData];
                                     NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                                     NSString *name = [tempDic objectForKey:@"header"] ;
                                     if ((NSNull *)name == [NSNull null]) {
                                         [tempDic setValue:nil forKey:@"header"];
                                     }
                                     NSString *account = [tempDic objectForKey:@"account"];
                                     if ((NSNull *)account == [NSNull null])
                                     {
                                         [tempDic setValue:nil forKey:@"account"];
                                     }
                                     
                                     [[NSUserDefaults standardUserDefaults] setObject:tempDic forKey:@"loginCache"];
                                     [[NSUserDefaults standardUserDefaults] synchronize];
                                     [[PZBlueToothManager sharedInstance] setBindDatepz];//发送页面的配置信息
                                     int timeSeconds = [[TimeCallManager getInstance] getSecondsOfCurDay];
                                     NSDictionary *dic = [[SQLdataManger getInstance]getTotalDataWith:timeSeconds];
                                     if (!dic) {
                                         NSString *macAddress = [AllTool amendMacAddressGetAddress];
                                         //                                         NSString *macAddress = [ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
                                         //                                         if (!macAddress)
                                         //                                         {
                                         //                                             macAddress = DEFAULTDEVICEID;
                                         //                                         }
                                         dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [[HCHCommonManager getInstance]UserAcount],CurrentUserName_HCH,
                                                [NSNumber numberWithInt:timeSeconds],  DataTime_HCH,
                                                [NSNumber numberWithInt:0], TotalSteps_DayData_HCH,
                                                [NSNumber numberWithInt:0], TotalMeters_DayData_HCH,
                                                [NSNumber numberWithInt:0], TotalCosts_DayData_HCH,
                                                [NSNumber numberWithInt:[HCHCommonManager getInstance].sleepPlan ], Sleep_PlanTo_HCH,
                                                [NSNumber numberWithInt:[HCHCommonManager getInstance].stepsPlan], Steps_PlanTo_HCH,
                                                [NSNumber numberWithInt:0],TotalDeepSleep_DayData_HCH,
                                                [NSNumber numberWithInt:0],TotalLittleSleep_DayData_HCH,
                                                [NSNumber numberWithInt:0],TotalWarkeSleep_DayData_HCH,
                                                [NSNumber numberWithInt:0],TotalSleepCount_DayData_HCH,
                                                [NSNumber numberWithInt:testEventCount],TotalDayEventCount_DayData_HCH,
                                                [NSNumber numberWithInt:0],TotalDataActivityTime_DayData_HCH,
                                                [NSNumber numberWithInt:[[TimeCallManager getInstance] getWeekIndexInYearWith:timeSeconds]], TotalDataWeekIndex_DayData_HCH,
                                                [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]],DEVICETYPE,
                                                macAddress,DEVICEID,
                                                @"0",ISUP,
                                                nil];
                                         [[SQLdataManger getInstance]insertSignalDataToTable:DayTotalData_Table withData:dic];
                                     }
                                     [[NSUserDefaults standardUserDefaults] setObject:loginDic forKey:LastLoginUser_Info];
                                     [[NSUserDefaults standardUserDefaults] synchronize];
                                     
                                     [HCHCommonManager getInstance].userInfoDictionAry = [NSMutableDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                                     [[HCHCommonManager getInstance] setUserAcountName:loginDic[@"account"]];
                                     
                                     [HCHCommonManager getInstance].isLogin = YES;
                                     
                                     BMIViewController *bmiVC = [[BMIViewController alloc] init];
                                     bmiVC.height = [_heightTF.text floatValue];
                                     bmiVC.weight = [_weightTF.text floatValue];
                                     __weak EditPersonInformationViewController *weakSelf = self;
                                     bmiVC.okBlock = ^{
                                         [weakSelf loginHome];
                                     };
                                     bmiVC.isRegister = _isRegister;
                                     [self presentViewController:bmiVC animated:YES completion:nil];
                                 }
                                 else if(code == 9004){
                                     [self addActityTextInView:self.view text:NSLocalizedString(@"用户名或密码错误", nil) deleyTime:1.5f];
                                 }else {
                                     [self addActityTextInView:self.view text:NSLocalizedString(@"登录失败", nil)  deleyTime:1.5f];
                                 }
                             }
                         }];
                        
                    } else if (code == 9004) {
                        [self addActityTextInView:self.view text:NSLocalizedString(@"服务器异常",nil) deleyTime:1.5f];
                    }
                }
            }];
        }
        if (_EditState == EditPersonStateFirst || (_EditState == EditPersonStateEdit && ![HCHCommonManager getInstance].isLogin))
        {
            
            int height = [_heightTF.text intValue];
            int weight = [_weightTF.text intValue];
            if (kState == UnitStateBritishSystem)
            {
                height = (int)roundf([_heightTF.text intValue]*2.54);
                weight = (int)roundf([_weightTF.text intValue]*0.4535924);
            }
            
            _userCacheInfo = [[NSMutableDictionary alloc] init];
            //            [_userCacheInfo setObject:_eMailTF.text forKey:@"email"];
            if (_imageFilePath)
            {
                _imageFilePath = [[HCHCommonManager getInstance] saveImageFromCache];
                
                [[HCHCommonManager getInstance] setUserHeaderWith:[_imageFilePath lastPathComponent]];
            }
            [_userCacheInfo setObject:_nickNameTF.text forKey:@"nick"];
            [_userCacheInfo setObject:_birthdayTF.text forKey:@"birthdate"];
            [_userCacheInfo setObject:[NSNumber numberWithInt:(_sex +1)] forKey:@"gender"];
            [_userCacheInfo setObject:[NSNumber numberWithInt:height] forKey:@"height"];
            [_userCacheInfo setObject:[NSNumber numberWithInt:weight] forKey:@"weight"];
            if ([HCHCommonManager getInstance].UserHeader)
            {
                [_userCacheInfo setObject:[HCHCommonManager getInstance].UserHeader forKey:@"header"];
            }
            [HCHCommonManager getInstance].userInfoDictionAry = [[NSMutableDictionary alloc]initWithDictionary:_userCacheInfo];
            
            [[NSUserDefaults standardUserDefaults] setObject:[HCHCommonManager getInstance].userInfoDictionAry forKey:@"loginCache"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[PZBlueToothManager sharedInstance] setBindDatepz];//发送页面的配置信息
            [self addActityTextInView:self.view text:NSLocalizedString(@"修改成功", nil) deleyTime:1.5];
            BMIViewController *bmiVC = [[BMIViewController alloc] init];
            bmiVC.height = [_heightTF.text floatValue];
            bmiVC.weight = [_weightTF.text floatValue];
            WeakSelf;
            bmiVC.okBlock = ^{
                _isEdit = NO;
                [weakSelf canEditInfo];
                if (self.EditState == EditPersonStateFirst) {
                    [weakSelf loginHome];
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            };
            [self presentViewController:bmiVC animated:YES completion:nil];
        }
    }
    else return;
}

- (int)getAge
{
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy-MM-dd"];
    NSDate *assignDate = [formates dateFromString:_birthdayTF.text];
    int time = fabs([assignDate timeIntervalSinceNow]);
    int age = trunc(time/(60*60*24))/365;
    return age;
}

- (BOOL)checkUserInfo
{
    if (_nickNameTF.text.length == 0)
    {
        [self showAlertView:NSLocalizedString(@"昵称不能为空，请输入昵称", nil)];
        return NO;
    }
    else if (_nickNameTF.text.length > 32)
    {
        [self showAlertView:NSLocalizedString(@"昵称长度不能超过32个字符", nil)];
        return NO;
    }
    //    else if (![self isEmail:_eMailTF.text])
    //    {
    //        return NO;
    //    }
    else if (_birthdayTF.text.length == 0)
    {
        [self showAlertView:NSLocalizedString(@"出生日期不能为空，请选择出生日期", nil)];
        return NO;
    }
    else if (_heightTF.text.length == 0)
    {
        [self showAlertView:NSLocalizedString(@"身高不能为空，请选择身高", nil)];
        return NO;
    }
    else if (_weightTF.text.length == 0)
    {
        [self showAlertView:NSLocalizedString(@"体重不能为空，请选择体重", nil)];
        return NO;
    }
    else
    {
        int height = [_heightTF.text intValue];
        int weight = [_weightTF.text intValue];
        if (kState == UnitStateBritishSystem)
        {
            height = (int)roundf([_heightTF.text intValue]*2.54);
            weight = (int)roundf([_weightTF.text intValue]*0.4535924);
        }
        
        NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] init];
        if (_imageFilePath)
        {
            [mutDic setValue:_imageFilePath forKey:HeadImageURL_PersonInfo_HCH];
        }
        [mutDic setValue:[NSNumber numberWithInt:0] forKey:Key_PersonInfo_HCH];
        [mutDic setValue:_birthdayTF.text forKey:BornDate_PersonInfo_HCH];
        [mutDic setValue:[NSString stringWithFormat:@"%d",height] forKey:High_PersonInfo_HCH];
        [mutDic setValue:[NSString stringWithFormat:@"%d",weight] forKey:Weight_PersonInfo_HCH];
        //        [mutDic setValue:[NSNumber numberWithBool:![BlueToothManager getInstance].isConnected] forKey:PersonInfo_IsNeedTosend_HCH];
        [mutDic setObject:[NSString stringWithFormat:@"%d",_sex] forKey:Male_PersonInfo_HCH];
        [[SQLdataManger getInstance] insertSignalDataToTable:PersonInfo_Table withData:mutDic];
        
        return YES;
    }
    return YES;
}

//选择出生日期
- (IBAction)ChooseBirthdayClick:(id)sender
{
    [self.view endEditing:YES];
    _PickerViewType = PickerViewBirthday1;
    [self setPickerView];
    
}

- (IBAction)chooseHeight:(id)sender
{
    [self.view endEditing:YES];
    
    _PickerViewType = PickerViewHeight2;
    [self setPickerView];
}

- (IBAction)chooseWeight:(id)sender
{
    [self.view endEditing:YES];
    
    _PickerViewType = PickerViewWeight3;
    [self setPickerView];
}
#pragma mark    --   校正血压
- (IBAction)bloodPressTouch:(id)sender
{
    XueyaCorrectView *view = [XueyaCorrectView showXueyaCorrectView];
    view.delegate = self;
}
-(void)callbackChange
{
    _text1.text = [ADASaveDefaluts objectForKey:BLOODPRESSURELOW];
    _text2.text = [ADASaveDefaluts objectForKey:BLOODPRESSUREHIGH];
    [[CositeaBlueTooth sharedInstance] setupCorrectNumber];
}

- (void)setHeightPickerView
{
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30,CurrentDeviceWidth, 216)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    if (kState == UnitStateBritishSystem)
    {
        if (_PickerViewType == PickerViewHeight2)
        {
            [_pickerView selectRow:55 inComponent:0 animated:NO];
        }
        else
        {
            [_pickerView selectRow:74 inComponent:0 animated:NO];
        }
    }
    else
    {
        if (_PickerViewType == PickerViewHeight2)
        {
            [_pickerView selectRow:130 inComponent:0 animated:NO];
        }
        else
        {
            [_pickerView selectRow:20 inComponent:0 animated:NO];
        }
    }
    [_animationView addSubview:_pickerView];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 110)
    {
        if (buttonIndex == 3)
        {
            return;
        }
        else if (buttonIndex == 0)
        {
            self.isEdit = YES;
            [self canEditInfo];
            [_nickNameTF becomeFirstResponder];
        }
        else if (buttonIndex == 1)
        {
            if ([HCHCommonManager getInstance].isLogin && ![HCHCommonManager getInstance].isThirdPartLogin)
            {
                EditPswViewController *editPSWVC = [[EditPswViewController alloc]init];
                [self.navigationController pushViewController:editPSWVC animated:YES];
            }
            else
            {
                return;
            }
        }
    }
    else
    {
        //        选择头像的Action
        if (buttonIndex == 2) {
            return;
        }
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        if(buttonIndex == 0)
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            else
            {
                [self showAlertView:NSLocalizedString(@"相机不可用", nil)];
            }
        }
        else if (buttonIndex == 1)
        {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    [self.headBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.headBtn setImage:nil forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       UIImage *locImage = [UIImage decodedImageWithImage:image withSize:CGSizeMake(95, 95)];
                       if( !locImage )
                       {
                           
                       }
                       _imageFilePath = [[HCHCommonManager getInstance] storeHeadImageWithImage:locImage];
                       //adaLog(@"_imageFilePath - %@",_imageFilePath);
                       //        [[HCHCommonManager getInstance] setUserHeaderWith:[_imageFilePath lastPathComponent]];
                   });
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (kState == UnitStateBritishSystem)
    {
        if (_PickerViewType == PickerViewHeight2)
        {
            return 84;
        }
        else
        {
            return 265;
        }
    }
    else
    {
        if (_PickerViewType ==  PickerViewHeight2)
        {
            return 211;
        }
        else
        {
            return 141;
        }
    }
}

#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (kState == UnitStateBritishSystem)
    {
        if (_PickerViewType == PickerViewHeight2)
        {
            return [NSString stringWithFormat:@"%ld",row + 15];
        }
        else
        {
            return [NSString stringWithFormat:@"%ld",row + 66];
        }
    }
    else
    {
        if (_PickerViewType ==  PickerViewHeight2)
        {
            return [NSString stringWithFormat:@"%ld",row + 40];
        }
        else
        {
            return [NSString stringWithFormat:@"%ld",row + 30];
        }
    }
}

#pragma mark - 创建pickerView的背景View
- (void)setPickerView
{
    _backView = [[UIView alloc] initWithFrame:CurrentDeviceBounds];
    _backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_backView];
    
    _animationView  = [[UIView alloc] initWithFrame:CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, 246)];
    [_backView addSubview:_animationView];
    
    if (_PickerViewType == PickerViewBirthday1)
    {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30,CurrentDeviceWidth, 216)];
        NSString* string = @"19000101";
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyyMMdd"];
        NSDate* minDate = [formatter dateFromString:string];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.backgroundColor = [UIColor whiteColor];
        NSDate *maxDate = [NSDate date];
        _datePicker.maximumDate = maxDate;
        _datePicker.minimumDate = minDate;
        [_animationView addSubview:_datePicker];
    }else
    {
        [self setHeightPickerView];
    }
    UIView *buttonView = [[UIView alloc] init];
    buttonView.backgroundColor = [UIColor whiteColor];
    [_animationView addSubview:buttonView];
    buttonView.sd_layout.leftEqualToView(_backView)
    .rightEqualToView(_backView)
    .heightIs(30)
    .topEqualToView(_animationView);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonView addSubview:button];
    button.frame = CGRectMake(CurrentDeviceWidth-80, 0, 80, 40);
    [button addTarget:self action:@selector(dateSureClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *btnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    btnImageView.image = [UIImage imageNamed:@"hook"];
    btnImageView.center = button.center;
    [buttonView addSubview:btnImageView];
    
    [UIView animateWithDuration:0.23 animations:^{
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _animationView.frame = CGRectMake(0, CurrentDeviceHeight-246,CurrentDeviceWidth, 246);
    }];
}

//取消选择出生日期
- (void)dateCancleButtonClick
{
    [self hiddenDateBackView];
}

// 选择出生日期完毕

- (void)dateSureClick
{
    [self hiddenDateBackView];
    if (_PickerViewType == PickerViewBirthday1)
    {
        int seconds = [_datePickerDate timeIntervalSince1970];
        [[TimeCallManager getInstance] getYYYYMMDDSecondsSince1970With:seconds];
        _datePickerDate = _datePicker.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        _birthdayTF.text = [formatter stringFromDate:_datePickerDate];
    }
    else
    {
        NSInteger row = [_pickerView selectedRowInComponent:0];
        if (kState == UnitStateBritishSystem)
        {
            _isChange = YES;
            if (_PickerViewType == PickerViewHeight2)
            {
                _heightTF.text = [NSString stringWithFormat:@"%ld",row + 15];
                [[HCHCommonManager getInstance]  setUserHeightWith:[NSString stringWithFormat:@"%.0f",([_heightTF.text integerValue]/heightCMtoINCH)]];
                
                [self.userCacheInfo  setObject:[NSString stringWithFormat:@"%.0f",([_heightTF.text integerValue]/heightCMtoINCH)] forKey:@"height"];
                
            }
            else if (_PickerViewType == PickerViewWeight3)
            {
                _weightTF.text = [NSString stringWithFormat:@"%ld",row + 66];
                [[HCHCommonManager getInstance]  setUserWeightWith:[NSString stringWithFormat:@"%.0f",([_weightTF.text integerValue]/weightKGtoLB)]];
                [self.userCacheInfo  setObject:[NSString stringWithFormat:@"%.0f",([_weightTF.text integerValue]/weightKGtoLB)] forKey:@"weight"];
                
                
                
            }
            
        }
        else
        {
            _isChange = YES;
            if (_PickerViewType == PickerViewHeight2)
            {
                _heightTF.text = [NSString stringWithFormat:@"%ld",row + kHEIGHTOFFSET];
                [[HCHCommonManager getInstance]  setUserHeightWith:_heightTF.text];
                [self.userCacheInfo  setObject:_heightTF.text forKey:@"height"];
            }
            else if (_PickerViewType == PickerViewWeight3)
            {
                _weightTF.text = [NSString stringWithFormat:@"%ld",row + kWEIGHTOFFSET];
                [[HCHCommonManager getInstance]  setUserWeightWith:_weightTF.text];
                [self.userCacheInfo  setObject:_weightTF.text forKey:@"weight"];
            }
        }
    }
}

// 隐藏DatePicker
- (void)hiddenDateBackView
{
    [UIView animateWithDuration:0.23 animations:^{
        _animationView.frame = CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, 246);
    } completion:^(BOOL finished) {
        
        [_backView removeFromSuperview];
        _backView = nil;
        [_datePicker removeFromSuperview];
        _datePicker = nil;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    if (_backView)
    {
        [self hiddenDateBackView];
    }
}
-(NSMutableDictionary *)userCacheInfo
{
    if (!_userCacheInfo) {
        _userCacheInfo = [NSMutableDictionary dictionary];
    }
    return _userCacheInfo;
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
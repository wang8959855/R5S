//
//  EditPersonalInformationTwoViewController.m
//  Wukong
//
//  Created by apple on 2018/5/15.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "EditPersonalInformationTwoViewController.h"
#import "EditPersonalInformationThreeViewController.h"

#define kHEIGHTOFFSET 40
#define kWEIGHTOFFSET 30
#define heightCMtoINCH  0.3937008
#define weightKGtoLB  2.2046226
@interface EditPersonalInformationTwoViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    UIView *_backView;
}

@end

@implementation EditPersonalInformationTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.versionLabel.text = showAppVersion;
    [self setSubViews];
}

- (void)delayMask{
    self.nextButton.layer.mask = [AllTool getCornerRoundWithSelfView:self.nextButton byRoundingCorners:UIRectCornerBottomLeft |UIRectCornerBottomRight cornerRadii:CGSizeMake(8,8)];
}

- (void)setSubViews{
    [self performSelector:@selector(delayMask) withObject:nil afterDelay:0.1];
    
    self.heightTF.userInteractionEnabled = NO;
    self.weightTF.userInteractionEnabled = NO;
    self.CHDTF.userInteractionEnabled = NO;
    self.HypertensionTF.userInteractionEnabled = NO;
    self.GluTF.keyboardType = UIKeyboardTypeDecimalPad;
    self.GluTF.delegate = self;
    [self loadData];
}

- (void)loadData{
    if ([[self.uploadInfoDic allKeys] containsObject:@"height"]) {
        _heightTF.text = self.uploadInfoDic[@"height"];
    }
    if ([[self.uploadInfoDic allKeys] containsObject:@"weight"]) {
        _weightTF.text = self.uploadInfoDic[@"weight"];
    }
    if ([[self.uploadInfoDic allKeys] containsObject:@"is_CHD"]) {
        if ([self.uploadInfoDic[@"is_CHD"] boolValue]) {
            _CHDTF.text = @"有";
        }else{
            _CHDTF.text = @"无";
        }
    }
    if ([[self.uploadInfoDic allKeys] containsObject:@"is_hypertension"]) {
        if ([self.uploadInfoDic[@"is_hypertension"] boolValue]) {
            _HypertensionTF.text = @"有";
        }else{
            _HypertensionTF.text = @"无";
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击事件
//身高
- (IBAction)heightClick:(UIButton *)sender {
    _PickerViewType = PickerViewHeight;
    [self setPickerView];
}

//体重
- (IBAction)weightClick:(UIButton *)sender {
    _PickerViewType = PickerViewWeight;
    [self setPickerView];
}

//高血压
- (IBAction)CHDClick:(UIButton *)sender {
    _PickerViewType = PickerViewHypertension;
    [self setPickerView];
}

//冠心病
- (IBAction)HypertensionClick:(UIButton *)sender {
    _PickerViewType = PickerViewCHD;
    [self setPickerView];
}

//基准高压值
- (IBAction)systolicPressureAction:(UIButton *)sender {
    _PickerViewType = PickerViewSystolicPressure;
    [self setPickerView];
}

//基准低压值
- (IBAction)diastolicPressureAction:(UIButton *)sender {
    _PickerViewType = PickerViewDiastolicPressure;
    [self setPickerView];
}

//返回
- (IBAction)goBackClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//下一步
- (IBAction)nextClick:(UIButton *)sender {
    if ([self.heightTF.text length] == 0) {
        [self showAlertView:@"请选择身高"];
        return;
    }else if ([self.weightTF.text length] == 0){
        [self showAlertView:@"请选择体重"];
        return;
    }else if ([self.HypertensionTF.text length] == 0){
        [self showAlertView:@"请选择是否有高血压病史"];
        return;
    }else if ([self.CHDTF.text length] == 0){
        [self showAlertView:@"请选择是否有冠心病史"];
        return;
    }
    if (self.GluTF.text.length == 0){
        //餐后血糖值
        [self.uploadInfoDic setObject:@"6" forKey:@"Glu"];
    }
    if (self.SystolicPressureTF.text.length == 0){
        //基准高压
        NSString *SystolicPressure = [AllTool calcSWithBirthday:self.uploadInfoDic[@"birthday"] sex:self.uploadInfoDic[@"sex"]][0];
        [self.uploadInfoDic setObject:SystolicPressure forKey:@"systolicP"];
    }
    if (self.DiastolicPressureTF.text.length == 0){
        //基准低压
        NSString *DiastolicPressure = [AllTool calcSWithBirthday:self.uploadInfoDic[@"birthday"] sex:self.uploadInfoDic[@"sex"]][1];
        [self.uploadInfoDic setObject:DiastolicPressure forKey:@"diastolicP"];
    }
    EditPersonalInformationThreeViewController *three = [[UIStoryboard storyboardWithName:@"EditPersonalInformationViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"EditPersonalThree"];
    three.uploadInfoDic = self.uploadInfoDic;
    [self.navigationController pushViewController:three animated:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    //血糖
    [self.uploadInfoDic setObject:textField.text forKey:@"Glu"];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (_PickerViewType == PickerViewHeight){
        return 211;
    }else if (_PickerViewType == PickerViewWeight){
        return 141;
    }else if (_PickerViewType == PickerViewDiastolicPressure){
        return 190;
    }else if (_PickerViewType == PickerViewSystolicPressure){
        return 200;
    }else{
        return 2;
    }
}

#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (_PickerViewType == PickerViewHeight){
        return [NSString stringWithFormat:@"%ld",row + 40];
    }else if (_PickerViewType == PickerViewWeight){
        return [NSString stringWithFormat:@"%ld",row + 30];
    }else if (_PickerViewType == PickerViewSystolicPressure){
        return [NSString stringWithFormat:@"%ld",row + 50];
    }else if (_PickerViewType == PickerViewDiastolicPressure){
        return [NSString stringWithFormat:@"%ld",row + 30];
    }else{
        if (row == 0) {
            return @"有";
        }else{
            return @"无";
        }
    }
}

#pragma mark - 创建pickerView的背景View
- (void)setPickerView{
    _backView = [[UIView alloc] initWithFrame:CurrentDeviceBounds];
    _backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_backView];
    
    _animationView  = [[UIView alloc] initWithFrame:CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, 246)];
    [_backView addSubview:_animationView];
    
    [self setHeightPickerView];
    
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

- (void)setHeightPickerView{
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30,CurrentDeviceWidth, 216)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    if (_PickerViewType == PickerViewHeight){
        [_pickerView selectRow:110 inComponent:0 animated:NO];
    }
    else if (_PickerViewType == PickerViewWeight){
        [_pickerView selectRow:20 inComponent:0 animated:NO];
    }else if (_PickerViewType == PickerViewSystolicPressure){
        //基准高压
        [_pickerView selectRow:100 inComponent:0 animated:NO];
    }else if (_PickerViewType == PickerViewDiastolicPressure){
        //基准低压
        [_pickerView selectRow:100 inComponent:0 animated:NO];
    }else{
        [_pickerView selectRow:0 inComponent:0 animated:NO];
    }
    [_animationView addSubview:_pickerView];
}

//取消选择器
- (void)dateCancleButtonClick
{
    [self hiddenDateBackView];
}

// 选择出生日期完毕
- (void)dateSureClick{
    [self hiddenDateBackView];
    NSInteger row = [_pickerView selectedRowInComponent:0];
    if (_PickerViewType == PickerViewHeight){
            _heightTF.text = [NSString stringWithFormat:@"%ld",row + 40];
            [[HCHCommonManager getInstance]  setUserHeightWith:[NSString stringWithFormat:@"%.0f",([_heightTF.text integerValue]/heightCMtoINCH)]];
        [self.uploadInfoDic setObject:_heightTF.text forKey:@"height"];
    }else if (_PickerViewType == PickerViewWeight){
        _weightTF.text = [NSString stringWithFormat:@"%ld",row + 30];
        [[HCHCommonManager getInstance]  setUserWeightWith:[NSString stringWithFormat:@"%.0f",([_weightTF.text integerValue]/weightKGtoLB)]];
        [self.uploadInfoDic setObject:_weightTF.text forKey:@"weight"];
    }else if (_PickerViewType == PickerViewCHD){
        if (row == 0) {
            _CHDTF.text = @"有";
            [self.uploadInfoDic setObject:@(true) forKey:@"is_CHD"];
        }else{
          _CHDTF.text = @"无";
            [self.uploadInfoDic setObject:@(false) forKey:@"is_CHD"];
        }
    }else if (_PickerViewType == PickerViewHypertension){
        if (row == 0) {
            _HypertensionTF.text = @"有";
            [self.uploadInfoDic setObject:@(true) forKey:@"is_hypertension"];
        }else{
            _HypertensionTF.text = @"无";
            [self.uploadInfoDic setObject:@(false) forKey:@"is_hypertension"];
        }
    }else if (_PickerViewType == PickerViewSystolicPressure){
        self.SystolicPressureTF.text = [NSString stringWithFormat:@"%ld",row+50];
        [self.uploadInfoDic setObject:[NSString stringWithFormat:@"%ld",row+50] forKey:@"SystolicPressure"];
    }else if (_PickerViewType == PickerViewDiastolicPressure){
        self.DiastolicPressureTF.text = [NSString stringWithFormat:@"%ld",row+30];
        [self.uploadInfoDic setObject:[NSString stringWithFormat:@"%ld",row+30] forKey:@"DiastolicPressure"];
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

- (NSMutableDictionary *)uploadInfoDic
{
    if (!_uploadInfoDic) {
        _uploadInfoDic = [NSMutableDictionary dictionary];
    }
    return _uploadInfoDic;
    
}

@end

//
//  EditPersonalInformationOneViewController.m
//  Wukong
//
//  Created by apple on 2018/5/15.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "EditPersonalInformationOneViewController.h"
#import "EditPersonalInformationTwoViewController.h"
#import "ChooseLocationView.h"
#import "CitiesDataTool.h"

@interface EditPersonalInformationOneViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,NSURLSessionDelegate,UIGestureRecognizerDelegate>
{
    UIView *_backView;
    BOOL keyBoard;
}
@property (nonatomic,strong) ChooseLocationView *chooseLocationView;
@property (nonatomic,strong) UIView  *cover;
@property (strong, nonatomic)NSDate *datePickerDate;
@property (strong, nonatomic)UIDatePicker *datePicker;

@end

@implementation EditPersonalInformationOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setSubViews];
    [[CitiesDataTool sharedManager] requestGetData];
    [self.view addSubview:self.cover];
    self.versionLabel.text = showAppVersion;
}

- (void)delayMask{
    self.nextButton.layer.mask = [AllTool getCornerRoundWithSelfView:self.nextButton byRoundingCorners:UIRectCornerBottomLeft |UIRectCornerBottomRight cornerRadii:CGSizeMake(8,8)];
}

- (void)setSubViews{
    self.navigationController.navigationBar.hidden = YES;
    [self performSelector:@selector(delayMask) withObject:nil afterDelay:0.1];
    _sexTF.userInteractionEnabled = NO;
    _birthdayTF.userInteractionEnabled = NO;
    _addressTF.userInteractionEnabled = NO;
    
    _sexTF.enabled = false;
    _birthdayTF.enabled = false;
    _addressTF.enabled = false;
    
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
}

- (void)uploadView{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击事件
//下一步
- (IBAction)nextClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([self.nameTF.text length] == 0) {
        [self showAlertView:@"姓名不能为空"];
        return;
    }else if ([self.sexTF.text length] == 0){
        [self showAlertView:@"请选择性别"];
        return;
    }else if ([self.birthdayTF.text length] == 0){
        [self showAlertView:@"请选择生日"];
        return;
    }else if ([self.addressTF.text length] == 0){
        [self showAlertView:@"请选择地址"];
        return;
    }
    
    [self.uploadInfoDic setObject:self.nameTF.text forKey:@"userName"];
    
    EditPersonalInformationTwoViewController *two = [[UIStoryboard storyboardWithName:@"EditPersonalInformationViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"EditPersonalTwo"];
    two.uploadInfoDic = self.uploadInfoDic;
    [self.navigationController pushViewController:two animated:YES];
}

//性别
- (IBAction)sexClick:(UIButton *)sender {
    [self.view endEditing:YES];
    _PickerViewType = PickerViewSex;
    [self setPickerView];
}

//生日
- (IBAction)brithdayClick:(UIButton *)sender {
    [self.view endEditing:YES];
    _PickerViewType = PickerViewBirthday;
    [self setPickerView];
}

//所在地
- (IBAction)addressClick:(UIButton *)sender {
    [self.view endEditing:YES];
    self.cover.hidden = !self.cover.hidden;
    self.chooseLocationView.hidden = self.cover.hidden;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}

#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (row == 0) {
        return @"男";
    }
    return @"女";
}

#pragma mark - 创建pickerView的背景View
- (void)setPickerView{
    _backView = [[UIView alloc] initWithFrame:CurrentDeviceBounds];
    _backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_backView];
    
    _animationView  = [[UIView alloc] initWithFrame:CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, 246)];
    [_backView addSubview:_animationView];
    
    if (_PickerViewType == PickerViewBirthday)
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
    }else{
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
- (void)dateCancleButtonClick{
    [self hiddenDateBackView];
}

// 选择出生日期完毕
- (void)dateSureClick
{
    [self hiddenDateBackView];
    if (_PickerViewType == PickerViewBirthday)
    {
        int seconds = [_datePickerDate timeIntervalSince1970];
        [[TimeCallManager getInstance] getYYYYMMDDSecondsSince1970With:seconds];
        _datePickerDate = _datePicker.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        _birthdayTF.text = [formatter stringFromDate:_datePickerDate];
        [self.uploadInfoDic setObject:_birthdayTF.text forKey:@"birthday"];
    }else{
        NSInteger row = [_pickerView selectedRowInComponent:0];
        if (row == 0) {
            _sexTF.text = @"男";
        }else{
            _sexTF.text = @"女";
        }
        [self.uploadInfoDic setObject:[NSString stringWithFormat:@"%ld",row+1] forKey:@"sex"];
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

#pragma mark - 选择城市
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(_chooseLocationView.frame, point)){
        return NO;
    }
    return YES;
}


- (void)tapCover:(UITapGestureRecognizer *)tap{
    if (_chooseLocationView.chooseFinish) {
        _chooseLocationView.chooseFinish();
    }
}

- (ChooseLocationView *)chooseLocationView{
    if (!_chooseLocationView) {
        _chooseLocationView = [[ChooseLocationView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 350, [UIScreen mainScreen].bounds.size.width, 350)];
    }
    return _chooseLocationView;
}

- (UIView *)cover{
    if (!_cover) {
        _cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [_cover addSubview:self.chooseLocationView];
        __weak typeof (self) weakSelf = self;
        _chooseLocationView.chooseFinish = ^{
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.addressTF.text = weakSelf.chooseLocationView.address;
                [weakSelf.uploadInfoDic setObject:weakSelf.chooseLocationView.address forKey:@"address"];
                weakSelf.view.transform = CGAffineTransformIdentity;
                weakSelf.cover.hidden = YES;
            }];
        };
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCover:)];
        [_cover addGestureRecognizer:tap];
        tap.delegate = self;
        _cover.hidden = YES;
    }
    return _cover;
}

#pragma mark - 选择性别
- (void)setHeightPickerView
{
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30,CurrentDeviceWidth, 216)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [_pickerView selectRow:0 inComponent:0 animated:NO];
    [_animationView addSubview:_pickerView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    if (_backView){
        [self hiddenDateBackView];
    }
}

- (NSMutableDictionary *)userCacheInfo
{
    if (!_userCacheInfo) {
        _userCacheInfo = [NSMutableDictionary dictionary];
    }
    return _userCacheInfo;
    
}

- (NSMutableDictionary *)uploadInfoDic {
    if (!_uploadInfoDic) {
        _uploadInfoDic = [NSMutableDictionary dictionary];
    }
    return _uploadInfoDic;
    
}

@end

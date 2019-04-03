//
//  ZIDingYiViewController.m
//  keyBand
//
//  Created by 迈诺科技 on 15/11/20.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import "ZIDingYiViewController.h"
#import "TimeViewController.h"

@interface ZIDingYiViewController ()
{
    bool day[7];
}
@property (nonatomic,assign) NSInteger  textFieldTextLength;
@end

@implementation ZIDingYiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setXibLabel];
    
    // Do any additional setup after loading the view from its nib.
    
    [self setButtonWithButton:_confirmBtn andTitle:NSLocalizedString(@"确定", nil)];
    
    _weekArray = @[NSLocalizedString(@"周日", nil),NSLocalizedString (@"周一",nil),NSLocalizedString (@"周二", nil),NSLocalizedString (@"周三", nil),NSLocalizedString(@"周四", nil),NSLocalizedString(@"周五",nil),NSLocalizedString(@"周六",nil),NSLocalizedString(@"仅一次", nil),NSLocalizedString(@"每天",nil),NSLocalizedString (@"工作日", nil),NSLocalizedString (@"周末", nil)];
    
    if (_isEdit)
    {
        _typeLabel.text = _contentDic[@"0"];
        _dateLabel.text = _contentDic[@"1"];
        _repeatLabel.text = _contentDic[@"2"];
        _dateArray = [_dateLabel.text componentsSeparatedByString:@"/"];
        
        NSArray *repeatArray = _contentDic[@"4"];
        for (int i = 0; i < 7; i ++)
        {
            day[i] = [repeatArray[i] boolValue];
        }
    }
    [_typeTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setXibLabel
{
    _titleLabel.text = NSLocalizedString(@"自定义", nil);
    _selectTypeLabel.text = NSLocalizedString(@"选择类型", nil);
    _typeLabel.text = NSLocalizedString(@"未选择", nil);
    _timeLabel.text = NSLocalizedString(@"时间", nil);
    _dateLabel.text = NSLocalizedString(@"未选择", nil);
    _repeatNameLabel.text = NSLocalizedString(@"重复", nil);
    _repeatLabel.text = NSLocalizedString(@"仅一次", nil);
    _textLabel.text = NSLocalizedString(@"开启闹铃提醒后，手环会在浅睡眠状态下轻微振动唤醒您，您这一天将会更加有活力。", nil);
}

//限制string 的长度
- (void)textFieldDidChange:(UITextField *)textField
{
    NSString *string = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@" "];
    
    if (textField == self.typeTF) {
        NSData *strData = [BlueToothManager utf8ToUnicode:string];
        int alarmLength = [[ADASaveDefaluts objectForKey:CUSTOMREMINDLENGTH] intValue];
        if (strData.length > alarmLength) {
            textField.text = [textField.text substringToIndex:self.textFieldTextLength];
        }
        self.textFieldTextLength = textField.text.length;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)repeatView
{
    if (!_repeatView)
    {
        _repeatView = [[UIView alloc]init];
        
    }
    return _repeatView;
}


#pragma mark - 日期数组set方法
- (void)setDateArray:(NSArray *)dateArray
{
    if (dateArray.count == 0)
    {
        self.dateLabel.text = NSLocalizedString(@"未选择", nil);
        return;
    }
    if (_dateArray != dateArray)
    {
        _dateArray = dateArray;
        NSMutableString *dateString = [[NSMutableString alloc]init];
        for (int i = 0; i < _dateArray.count; i ++)
        {
            NSString *string = _dateArray[i];
            if (string.length != 0)
            {
                [dateString appendFormat:@"%@/",string];
            }
        }
        if (dateString.length > 0)
        {
            _dateLabel.text = [dateString substringToIndex:dateString.length-1];
        }
    }
}

#pragma mark - 按钮事件

- (IBAction)TFendEdit:(UITextField *)sender
{
    [sender resignFirstResponder];
}


//点击确定
- (IBAction)completAction:(id)sender
{
    int alarmType = [self getAlarmTypeWith:_typeLabel.text];
    
    
    if ([_typeLabel.text isEqualToString:NSLocalizedString(@"未选择", nil)]) {
        [self addActityTextInView:self.view text:NSLocalizedString(@"请选择提醒类型", nil) deleyTime:1.5f];
        return;
    }else if (_typeLabel.text.length == 0 && _typeTF.text.length == 0)
    {
        [self addActityTextInView:self.view text:NSLocalizedString(@"请输入提醒类型", nil) deleyTime:1.5f];
        return;
    }else if ([_dateLabel.text isEqualToString:NSLocalizedString(@"未选择", nil)]) {
        [self addActityTextInView:self.view text:NSLocalizedString(@"请选择提醒时间", nil) deleyTime:1.5f];
        return;
    }
    
    
    NSString *noticStr = @"";
    
    if (alarmType == 6) {
        noticStr = _typeTF.text;
    }
    int alarmIndex = [self getAvaiableAlarmIndex];
    if (alarmIndex > 7)
    {
        [self addActityTextInView:self.view text:NSLocalizedString(@"提醒不可超过8个", nil) deleyTime:1.5];
        return;
    }
    if (_isEdit)
    {
        if (alarmType == 6 && _typeTF.text.length == 0)
        {
            noticStr = _typeLabel.text;
        }
        CustomAlarmModel *model = [[CustomAlarmModel alloc] init];
        model.index = [_contentDic[@"3"] intValue];
        model.type = alarmType;
        model.timeArray = _dateArray;
        model.repeatArray = [self getRepeatArray];
        [[CositeaBlueTooth sharedInstance] setAlarmWithAlarmModel:model];
    }
    else
    {
        if (alarmIndex != -1)
        {
            CustomAlarmModel *model = [[CustomAlarmModel alloc] init];
            model.index = alarmIndex;
            model.type = alarmType;
            model.timeArray = _dateArray;
            model.noticeString = noticStr;
            model.repeatArray = [self getRepeatArray];
            [[CositeaBlueTooth sharedInstance] setAlarmWithAlarmModel:model];
            //            [[BlueToothManager getInstance] setCustomAlarmWithStatus:1 alarmIndex:alarmIndex alarmType:alarmType alarmCount:(int)_dateArray.count alarmtimeArray:_dateArray  repeat:repeateStatus noticeString:noticStr];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (int)getAlarmTypeWith:(NSString *)alarmName
{
    NSArray *array = [NSArray arrayWithObjects:
                      NSLocalizedString(@"运动", nil),NSLocalizedString(@"约会",nil),NSLocalizedString(@"喝水",nil),NSLocalizedString(@"吃药",nil),NSLocalizedString(@"睡眠", nil),nil];
    int alarmType = 6;
    for (int index = 0; index < array.count; index++) {
        if ([alarmName isEqualToString:array[index] ]) {
            alarmType = index + 1;
            break;
        }
    }
    return alarmType;
}

- (int)getAvaiableAlarmIndex {
    int alarmIndex = -1;
    for (int index = 0; index < _exitArray.count; index++) {
        if ([_exitArray[index] isEqualToString:@""]) {
            alarmIndex = index;
            break;
        }
    }
    return alarmIndex;
}

- (NSArray *)getRepeatArray
{
    NSArray *array = @[[NSNumber numberWithBool:day[0]],
                       [NSNumber numberWithBool:day[1]],
                       [NSNumber numberWithBool:day[2]],
                       [NSNumber numberWithBool:day[3]],
                       [NSNumber numberWithBool:day[4]],
                       [NSNumber numberWithBool:day[5]],
                       [NSNumber numberWithBool:day[6]],
                       ];
    return array;
}

- (IBAction)dateAction:(id)sender
{
    [self.view endEditing:YES];
    TimeViewController *timeVC = [[TimeViewController alloc]init];
    if (self.dateArray.count != 0)
    {
        timeVC.dateArray = [[NSMutableArray alloc]initWithArray:self.dateArray];
    }
    [self.navigationController pushViewController:timeVC animated:YES];
}

- (IBAction)repeatAction:(id)sender
{
    [self.view endEditing:YES];
    NSArray *array = @[NSLocalizedString(@"日", nil),NSLocalizedString(@"一", nil),NSLocalizedString (@"二",nil),NSLocalizedString(@"三", nil),NSLocalizedString(@"四",nil),NSLocalizedString (@"五",nil),NSLocalizedString(@"六", nil)];
    UIButton *button = (UIButton *)sender;
    if (button.selected == NO)
    {
        _botomConstant.constant = 67;
        _tip.transform = CGAffineTransformMakeRotation(M_PI/2.);
        button.selected = !button.selected;
        [self.view addSubview:self.repeatView];
        
        int viewWidth = CurrentDeviceWidth - 50;
        _repeatView.sd_layout.topSpaceToView(_lineLabel,54)
        .widthIs(viewWidth)
        .heightIs(54)
        .leftSpaceToView(self.view,50);
        for (int i = 0; i < 7; i ++)
        {
            UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_repeatView addSubview:imageButton];
            imageButton.tag = 1000 + i;
            imageButton.backgroundColor = [UIColor greenColor];
            imageButton.layer.cornerRadius = 16;
            imageButton.clipsToBounds = YES;
            if ([HCHCommonManager getInstance].LanuguageIndex_SRK != ChinesLanguage_Enum)
            {
                imageButton.titleLabel.font = [UIFont systemFontOfSize:14];
            }
            if (day [i])
            {
                imageButton.backgroundColor = [UIColor colorWithRed:224/255.0 green:69/255.0 blue:74/255.0 alpha:1];
            }
            else
            {
                [imageButton setBackgroundColor:[UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1]];
            }
            [imageButton setTitle:array[i] forState:UIControlStateNormal];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [_repeatView addSubview:button];
            button.tag = 100 + i;
            [button addTarget:self action:@selector(daybuttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.sd_layout.leftSpaceToView(_repeatView,viewWidth/7.*i)
            .topSpaceToView(_repeatView,0)
            .widthIs(viewWidth/7.)
            .heightIs(54);
            
            imageButton.sd_layout.centerXEqualToView(button)
            .centerYEqualToView(button)
            .widthIs(32)
            .heightIs(32);
        }
    }
    else
    {
        [self.repeatView removeFromSuperview];
        self.repeatView = nil;
        _botomConstant.constant = 13;
        _tip.transform = CGAffineTransformMakeRotation(0);
        button.selected = !button.selected;
        
    }
}

- (void)daybuttonClick:(UIButton *)button
{
    long i = button.tag - 100;
    UIButton *btn = (UIButton *)[_repeatView viewWithTag:button.tag + 900];
    if ([btn isKindOfClass:[UIButton class]])
    {
        day[i] = !day[i];
        if (day[i] != YES)
        {
            btn.backgroundColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
        }
        else
        {
            btn.backgroundColor = [UIColor colorWithRed:224/255.0 green:69/255.0 blue:74/255.0 alpha:1];
        }
    }
    
    NSMutableArray *dayArray = [NSMutableArray array];
    for (int i = 0; i < 7 ; i ++)
    {
        BOOL isSelected = day[i];
        if ( isSelected == YES )
        {
            [dayArray addObject:_weekArray[i]];
        }
    }
    if (dayArray.count == 0)
    {
        _repeatLabel.text = _weekArray[7];
        return;
    }
    else if (dayArray.count == 2 && [dayArray containsObject:_weekArray[0]] && [dayArray containsObject:_weekArray[6]])
    {
        _repeatLabel.text = _weekArray[10];
    }
    else if (dayArray.count == 5 && ![dayArray containsObject:_weekArray[0]] && ![dayArray containsObject:_weekArray[6]] )
    {
        _repeatLabel.text = _weekArray[9];
    }
    else if (dayArray.count == 7)
    {
        _repeatLabel.text = _weekArray[8];
    }
    else
    {
        NSMutableString *textString = [NSMutableString new];
        for (NSString * string in dayArray)
        {
            [textString appendFormat:@"%@ ",string];
        }
        _repeatLabel.text = textString;
    }
}

- (IBAction)typeAction:(id)sender
{
    if (!_backView)
    {
        [self setPickerView];
    }
}


- (void)setPickerView
{
    if (!_typeArray)
    {
        _typeArray = [[NSArray alloc]initWithObjects:NSLocalizedString(@"运动", nil),@"ZDY_运动",NSLocalizedString(@"约会", nil),@"约会",NSLocalizedString (@"喝水", nil),@"喝水",NSLocalizedString (@"吃药",nil),@"吃药",NSLocalizedString(@"睡眠", nil),@"ZDY_睡眠",NSLocalizedString (@"编辑",nil),@"编辑", nil];
    }
    
    [self.view endEditing:YES];
    _backView = [[UIView alloc] initWithFrame:CurrentDeviceBounds];
    _backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_backView];
    
    
    _animationView  = [[UIView alloc] initWithFrame:CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, CurrentDeviceHeight)];
    [_backView addSubview:_animationView];
    
    for (int i = 0; i < 8 ; i ++)
    {
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(CurrentDeviceWidth/4. * (i%4), CurrentDeviceHeight - ((~(i/4 + 1) & 3)) * (CurrentDeviceWidth/4.), CurrentDeviceWidth/4., CurrentDeviceWidth/4.)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [_animationView addSubview:whiteView];
        if (i < 6)
        {
            //            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, 7, 30, 30)];
            //            imageView.image = [UIImage imageNamed:_typeArray[2*i+1]];
            //            [whiteView addSubview:imageView];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, whiteView.width, whiteView.height);
            button.tag = 100 + i;
            [button addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:_typeArray[2 * i + 1]] forState:UIControlStateNormal];
            [whiteView addSubview:button];
            button.imageEdgeInsets = UIEdgeInsetsMake(- 10, 0, 10, 0);
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, whiteView.height - 30, whiteView.width, 30)];
            label.text = _typeArray[2*i];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = Font_Normal_String(13);
            label.textColor = kColor(31, 31, 31);
            [whiteView addSubview:label];
            
        }
    }
    
    [UIView animateWithDuration:0.23 animations:^{
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _animationView.frame = CGRectMake(0, 0,CurrentDeviceWidth, CurrentDeviceHeight);
    }];
}

- (void)typeButtonAction:(UIButton *)button
{
    [self hiddenDateBackView];
    if (button.tag < 105)
    {
        _typeLabel.text = _typeArray[2 * (button.tag - 100)];
        _typeTF.text = nil;
    }
    else
    {
        _typeLabel.text = nil;
        [_typeTF becomeFirstResponder];
    }
    
}

- (void)hiddenDateBackView
{
    [UIView animateWithDuration:0.23 animations:^{
        _animationView.frame = CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, CurrentDeviceHeight);
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        _backView = nil;
        [_animationView removeFromSuperview];
        _animationView = nil;
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hiddenDateBackView];
    [self.view endEditing:YES];
}

- (IBAction)goBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

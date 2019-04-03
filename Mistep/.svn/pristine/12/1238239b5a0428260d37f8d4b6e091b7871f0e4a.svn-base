//
//  TimeViewController.m
//  keyBand
//
//  Created by 迈诺科技 on 15/11/23.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import "TimeViewController.h"
#import "ZIDingYiViewController.h"

@interface TimeViewController ()

@end
static NSString *reuseID = @"cell";
@implementation TimeViewController

- (void)dealloc
{
    self.dateArray = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setXibLabel];

    if (!_dateArray)
    {
        _dateArray =[[NSMutableArray alloc]init];
    }
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)setXibLabel
{
    _titleLabel.text = NSLocalizedString(@"自定义", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮点击事件

- (IBAction)backAction:(id)sender
{
    ZIDingYiViewController *zidingyiVC = self.navigationController.viewControllers[self.navigationController.viewControllers.count -2];
    zidingyiVC.dateArray = self.dateArray;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveDateAction
{
    
}

#pragma mark - UITableViewDelegate
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [_dateArray removeObjectAtIndex:indexPath.row];
        [_tableView beginUpdates];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];

    }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dateArray.count;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    cell.textLabel.text = _dateArray[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CurrentDeviceWidth, 100)];
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    lineLabel.frame = CGRectMake(15, 0, CurrentDeviceWidth, 0.5);
    [view addSubview:lineLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 210, 35);
//    if ([HCHCommonManager getInstance].LanuguageIndex_SRK == ChinesLanguage_Enum)
//    {
//        [button setBackgroundImage:[UIImage imageNamed:@"tianjiashijian"] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [button setBackgroundImage:[UIImage imageNamed:@"tianjiashijian_en"] forState:UIControlStateNormal];
//    }
    [self setButtonWithButton:button andTitle:NSLocalizedString(@"添加时间", nil)];
    button.center = view.center;
    button.tag = 10086;
    [button addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return view;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == _dateArray.count - 1)
//    {
//        if (!_backView)
//        {
//        }
//    }
//}

- (void)addBtnAction
{
    if(_dateArray.count >= 6)
    {
        [self showAlertView:NSLocalizedString(@"最多可添加6个时间", nil)];
        return;
    }
    if (!_backView)
    {
        [self setPickerView];
    }
}

- (void)setPickerView
{
    [self.view endEditing:YES];
    _backView = [[UIView alloc] initWithFrame:CurrentDeviceBounds];
    _backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_backView];
    
    _animationView  = [[UIView alloc] initWithFrame:CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, 246)];
    [_backView addSubview:_animationView];
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30,CurrentDeviceWidth, 216)];
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.datePickerMode = UIDatePickerModeTime;
    [_animationView addSubview:_datePicker];

    
    UIView *buttonView = [[UIView alloc] init];
    buttonView.backgroundColor = [UIColor whiteColor];
    [_animationView addSubview:buttonView];
    buttonView.sd_layout.leftEqualToView(_backView)
    .rightEqualToView(_backView)
    .heightIs(30)
    .bottomSpaceToView(_datePicker,0);
    
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



- (void)dateSureClick
{
    NSDate *pickDate = _datePicker.date;
    NSDateFormatter *formates = [[NSDateFormatter alloc]init];
    [formates setDateFormat:@"HH:mm"];
    NSString *dayString = [formates stringFromDate:pickDate];
    if ([_dateArray containsObject:dayString])
    {
        [self addActityTextInView:self.view text:NSLocalizedString(@"此时间已存在", nil) deleyTime:1.5];
    }
    else
    {
        [_dateArray insertObject:dayString atIndex:_dateArray.count];
        [_tableView reloadData];
    }
    [self hiddenDateBackView];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    [self hiddenDateBackView];
}

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  PhoneSetViewController.m
//  Wukong
//
//  Created by 迈诺科技 on 16/5/17.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "PhoneSetViewController.h"
#import "SMTabbedSplitViewController.h"

@interface PhoneSetViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PhoneSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setXibLabels];
    [_phoneSwitch setOn:NO];
    self.choseTimeView.hidden = YES;
}

- (void)setXibLabels
{
    _kPhoneAlarmLabel.text = NSLocalizedString(@"来电提醒", nil);
    _kChooseTimeLabel.text = NSLocalizedString(@"选择来电提醒时间:", nil);
}

- (void)dealloc
{
    
}

- (void)phoneAlarmStateChanged:(BOOL)state
{
    [self.phoneSwitch setOn:state animated:YES];
    self.choseTimeView.hidden = !state;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self checkPhoneAlarmState];

    [self queryPhoneDelay];
    if (_shadowView)
    {
        self.shadowView.hidden = YES;
        [_shadowView removeFromSuperview];
        self.shadowView = nil;
        self.timeTableView = nil;
    }
}

- (void)setPhoneDelayWithSeconds:(int)seconds
{
    [[CositeaBlueTooth sharedInstance] setPhoneDelayWithDelaySeconds:seconds];
    [self queryPhoneDelay];
}

- (void)queryPhoneDelay
{

    WeakSelf;
    [[CositeaBlueTooth sharedInstance] checkPhoneDealayWithBlock:^(int number) {
        weakSelf.timeLabel.text = [NSString stringWithFormat:@"%d",number];
        if (number == 255 || number == 0)
        {
            weakSelf.timeLabel.text = NSLocalizedString(@"立即提醒", nil);
        }
        else
        {
            weakSelf.timeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"延时%d秒", nil),number];
        }
    }];
}

- (IBAction)selectTimeAction:(id)sender
{
    [self.view addSubview:self.shadowView];
    _shadowView.sd_layout.topSpaceToView(self.choseTimeView,-15)
    .rightSpaceToView(self.view,20)
    .leftSpaceToView(self.view,50)
    .heightIs(132);
    _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    _shadowView.layer.shadowOffset = CGSizeMake(3, 3);
    _shadowView.layer.shadowOpacity = 0.6;
    _shadowView.layer.shadowRadius = 4;
}

- (UIView *)shadowView
{
    if (!_shadowView)
    {
        _shadowView = [[UIView alloc] init];
        _shadowView.hidden = NO;
        _timeTableView = [[UITableView alloc] init];
        _timeTableView.dataSource = self;
        _timeTableView.delegate = self;
        _timeTableView.showsVerticalScrollIndicator = NO;
        [_shadowView addSubview:_timeTableView];
        _timeTableView.sd_layout.leftSpaceToView(_shadowView,0)
        .topSpaceToView(_shadowView,0)
        .bottomSpaceToView(_shadowView,0)
        .rightSpaceToView(_shadowView,0);
    }
    return _shadowView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeShadowView];
}

- (void)removeShadowView
{
    if (self.shadowView)
    {
        self.shadowView.hidden = YES;
        [self.shadowView removeFromSuperview];
        self.shadowView = nil;
        self.timeTableView = nil;
    }
}

- (NSArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = @[NSLocalizedString(@"立即提醒", nil),@"4",@"10",];
    }
    return  _dataArray;
}

- (IBAction)swithValueChanged:(UISwitch *)sender
{
    [self removeShadowView];
    [[CositeaBlueTooth sharedInstance] setSystemAlarmWithType:SystemAlarmType_Phone State:sender.isOn];
    [self checkPhoneAlarmState];
}

#pragma mark -- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"reuseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    if (indexPath.row == 0)
    {
        cell.textLabel.text = self.dataArray[indexPath.row];
    }
    else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",self.dataArray[indexPath.row],NSLocalizedString( @"秒", nil)];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        [self setPhoneDelayWithSeconds:0];
    }
    else
    {
        [self setPhoneDelayWithSeconds:[_dataArray[indexPath.row] intValue]];
    }
    [self removeShadowView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 内部调用方法

- (void)checkPhoneAlarmState
{
    WeakSelf;
    [[CositeaBlueTooth sharedInstance] checkSystemAlarmWithType:SystemAlarmType_Phone StateBlock:^(int index, int state) {
        if (index == SystemAlarmType_Phone)
        {
            [weakSelf phoneAlarmStateChanged:state];
        }
    }];
}
@end

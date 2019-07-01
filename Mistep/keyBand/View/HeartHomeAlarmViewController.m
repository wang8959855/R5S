//
//  HeartHomeAlarmViewController.m
//  Wukong
//
//  Created by 迈诺科技 on 16/5/20.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "HeartHomeAlarmViewController.h"
#import "SMTabbedSplitViewController.h"
#import "HeartAlarmViewController.h"

@interface HeartHomeAlarmViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;


@end

@implementation HeartHomeAlarmViewController

- (void)dealloc
{
    //    [BlueToothData getInstance].heartAndTiredBlock = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    self.topHeight.constant = SafeAreaTopHeight;
}
-(void)setupView
{
    [self setXibLabels];
    // Do any additional setup after loading the view from its nib.
    if([[ADASaveDefaluts objectForKey:HEARTCONTINUITY] intValue] == 1)
    {
        self.dataArray = @[@"连续监测",@10,@30];// @[@10,@20,@30,@60];
    }
    else
    {
        self.dataArray = @[@10,@30];// @[@10,@20,@30,@60];
    }
    
    
    [_heartHZSwitch setOn:NO];
    [_heartAlarmSwitch setOn:NO];
    _hidenView.hidden = YES;
    
}
- (void)setXibLabels
{
    _heartHZLabel.text = NSLocalizedString(@"心率监测", nil);
    _heartAlarmLabel.text = NSLocalizedString(@"心率预警", nil);
    _kAlarmAreaLabel.text = NSLocalizedString(@"预警范围", nil);
    _kMaxLabel.text = NSLocalizedString(@"最大心率", nil);
    _kMinLabel.text = NSLocalizedString(@"最小心率", nil);
}

- (void)heartHZStateChanged:(BOOL)state
{
    if (!state)
    {
        self.durationView.hidden = !state;
    }
    [UIView animateWithDuration:0.15 animations:^{
        _labelDIstanceLayout.constant = state?45:0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (state) {
            self.durationView.hidden = !state;
        }
    }];
}

- (IBAction)setBtnAction:(UIButton *)sender
{
    HeartAlarmViewController *setHeartVC = [HeartAlarmViewController new];
    setHeartVC.max = [self.MaxLabel.text intValue];
    setHeartVC.min = [self.MinLabel.text intValue];
    setHeartVC.state = self.heartAlarmSwitch.isOn;
    UIResponder *responder = [self checkNextResponderIsKindOfViewController:[SMTabbedSplitViewController class]];
    if (responder) {
        SMTabbedSplitViewController *split = (SMTabbedSplitViewController *)responder;
        
        [split.navigationController pushViewController:setHeartVC animated:YES];
    }
}

- (IBAction)switchValueChanged:(UISwitch *)sender
{
    int max = [self.MaxLabel.text intValue];
    int min = [self.MinLabel.text intValue];
    int state = sender.isOn;
    [[CositeaBlueTooth sharedInstance] setHeartRateAlarmWithState:state MaxHeartRate:max MinHeartRate:min];
    [self chekHeartRateAlarm];
}

- (IBAction)heartHZValueChanged:(UISwitch *)sender
{
    _heartHZSwitch.userInteractionEnabled = NO;
    [self performSelector:@selector(heartHZSwitchCan) withObject:nil afterDelay:1.f];
    [[CositeaBlueTooth sharedInstance] changeHeartRateMonitorStateWithState:sender.isOn];
    [[CositeaBlueTooth sharedInstance] checkHeartTateMonitorwithBlock:nil];
    [self removeShadowView];
}
//一秒后让这个按钮可以使用
- (void)heartHZSwitchCan
{
    _heartHZSwitch.userInteractionEnabled = YES;
}
//一秒后让这个按钮可以使用
- (void)selfViewCan
{
    self.view.userInteractionEnabled = YES;
}
- (void)chooseDurationAction
{
    [self.view addSubview:self.shadowView];
    
    
    if([[ADASaveDefaluts objectForKey:HEARTCONTINUITY] intValue] == 1)
    {
        _shadowView.sd_layout.topSpaceToView(_durationView,1)
        .rightSpaceToView(self.view,20)
        .widthIs(180)
        .heightIs(170/4*3);
        _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        _shadowView.layer.shadowOffset = CGSizeMake(3, 3);
        _shadowView.layer.shadowOpacity = 0.6;
        _shadowView.layer.shadowRadius = 4;
    }
    else
    {
        _shadowView.sd_layout.topSpaceToView(_durationView,1)
        .rightSpaceToView(self.view,20)
        .widthIs(180)
        .heightIs(170/2);
        _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        _shadowView.layer.shadowOffset = CGSizeMake(3, 3);
        _shadowView.layer.shadowOpacity = 0.6;
        _shadowView.layer.shadowRadius = 4;
    }
    
    
}

- (UIView *)shadowView
{
    if (!_shadowView)
    {
        _shadowView = [[UIView alloc] init];
        
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
    _shadowView.hidden = NO;
    return _shadowView;
}

- (UIView*)durationView
{
    if (!_durationView)
    {
        _durationView = [[UIView alloc] init];
        [self.view addSubview:_durationView];
        _durationView.sd_layout.leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .topSpaceToView(_heartHZLabel,0)
        .heightIs(45);
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.text = NSLocalizedString(@"监测频率", nil);
        label.textColor = kColor(74, 126, 227);
        [label sizeToFit];
        [_durationView addSubview:label];
        label.sd_layout.leftSpaceToView(_durationView,30)
        .topSpaceToView(_durationView,0)
        .bottomSpaceToView(_durationView,0)
        .widthIs(label.width);
        [_durationView addSubview:self.heartDurationLabel];
        
        _heartDurationLabel.sd_layout.leftSpaceToView(label,12)
        .rightSpaceToView(_durationView,12)
        .topSpaceToView(_durationView,0)
        .bottomSpaceToView(_durationView,0);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_durationView addSubview:button];
        [button addTarget:self action:@selector(chooseDurationAction) forControlEvents:UIControlEventTouchUpInside];
        button.sd_layout.leftEqualToView(_heartDurationLabel)
        .rightEqualToView(_heartDurationLabel)
        .topEqualToView(_heartDurationLabel)
        .bottomEqualToView(_heartDurationLabel);
        
        UILabel *lineLabel = [[UILabel alloc] init];
        [_durationView addSubview:lineLabel];
        lineLabel.backgroundColor = kColor(218, 218, 218);
        lineLabel.sd_layout.leftSpaceToView(_durationView,20)
        .rightSpaceToView(_durationView,12)
        .bottomEqualToView(_durationView)
        .heightIs(1);
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"right.png"];
        [_durationView addSubview:imageView];
        imageView.sd_layout.rightSpaceToView(_durationView,12)
        .centerYEqualToView(label)
        .widthIs(10)
        .heightIs(10);
    }
    
    return _durationView;
}

- (UILabel *)heartDurationLabel
{
    if (!_heartDurationLabel)
    {
        _heartDurationLabel = [[UILabel alloc] init];
        _heartDurationLabel.font = [UIFont systemFontOfSize:14];
        _heartDurationLabel.textAlignment = NSTextAlignmentCenter;
        _heartDurationLabel.textColor = kColor(74, 126, 227);
    }
    return _heartDurationLabel;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"reuseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    ////adaLog(@"_dataArray[indexPath.row] -- %@",_dataArray[indexPath.row]);
    if ([[ADASaveDefaluts objectForKey:HEARTCONTINUITY] intValue] == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = _dataArray[indexPath.row];
        }else{
            int time = [_dataArray[indexPath.row] intValue];
            cell.textLabel.text = [NSString stringWithFormat:@"%d %@",time,NSLocalizedString(@"分钟", nil)];
        }
    }else{
        int time = [_dataArray[indexPath.row] intValue];
        cell.textLabel.text = [NSString stringWithFormat:@"%d %@",time,NSLocalizedString(@"分钟", nil)];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#warning mark  需要修改
//    _heartHZSwitch.userInteractionEnabled = NO;
//    [self performSelector:@selector(heartHZSwitchCan) withObject:nil afterDelay:1.f];
    
    NSString *title = @"";
    
    if ([[ADASaveDefaluts objectForKey:HEARTCONTINUITY] intValue] == 1) {
        if (indexPath.row == 0)
        {
            title = @"监测时间变更为连续监测，APP将自动重启";
        } else {
            title = [NSString stringWithFormat:@"监测时间变更为%@分钟，APP将自动重启",_dataArray[indexPath.row]];
            
        }
    }else{
        title = [NSString stringWithFormat:@"监测时间变更为%@分钟，APP将自动重启",_dataArray[indexPath.row]];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([[ADASaveDefaluts objectForKey:HEARTCONTINUITY] intValue] == 1) {
            if (indexPath.row == 0)
            {
                [[CositeaBlueTooth sharedInstance] setHeartRateMonitorDurantionWithTime:62];
            } else {
                [[CositeaBlueTooth sharedInstance] setHeartRateMonitorDurantionWithTime:[self->_dataArray[indexPath.row] intValue]];
            }
        }else{
            [[CositeaBlueTooth sharedInstance] setHeartRateMonitorDurantionWithTime:[self->_dataArray[indexPath.row] intValue]];
        }
        //关闭app
        exit(1);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    [[CositeaBlueTooth sharedInstance] checkHeartTateMonitorwithBlock:nil];
    
    [self removeShadowView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeShadowView];
}

- (void)removeShadowView
{
    if(_shadowView)
    {
        _shadowView.hidden = YES;
//        [_shadowView removeFromSuperview];
//        _shadowView = nil;
    }
    //_timeTableView = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(selfViewCan) withObject:nil afterDelay:1.f];
    WeakSelf;
    [[CositeaBlueTooth sharedInstance] checkHeartTateMonitorwithBlock:^(int index, int state) {
        [weakSelf.heartHZSwitch setOn:state animated:YES];
        [weakSelf heartHZStateChanged:state];
        if (index == 1) {
            weakSelf.heartDurationLabel.text = NSLocalizedString(@"连续监测", nil);
        } else {
            weakSelf.heartDurationLabel.text = [NSString stringWithFormat:@"%d%@",index,NSLocalizedString(@"分钟/次", nil)];
        }
        
    }];
    [weakSelf chekHeartRateAlarm];
    
}

- (void)chekHeartRateAlarm {
    WeakSelf;
    [[PZBlueToothManager sharedInstance] checkHeartRateAlarmWithHeartRateAlarmBlock:^(int state, int max, int min) {
        [weakSelf.heartAlarmSwitch setOn:state animated:YES];
        weakSelf.hidenView.hidden = !state;
        weakSelf.MaxLabel.text = [NSString stringWithFormat:@"%d",max];
        weakSelf.MinLabel.text = [NSString stringWithFormat:@"%d",min];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

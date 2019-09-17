//
//  WorkOutView.m
//  Wukong
//
//  Created by apple on 2018/5/22.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "WorkOutView.h"
#import "SportModelMap.h"
#import "SportMapTableViewCell.h"
#import "MapSportTypeViewController.h"
#import "SportDetailMapTwoViewController.h"
#import "MapSportTypeSelectViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SheBeiViewController.h"
#import "ConnectStateView.h"
#import "SelectStepTypeViewController.h"
#import "NSAttributedString+appendAttributedString.h"

@interface WorkOutView ()<BlutToothManagerDelegate,MapSportTypeSelectViewControllerDelegate,SportMapTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong)UITableView *sportTabelView;  //下半部的运动数组展示
@property (nonatomic,strong)NSMutableArray *sportArray;  //下半部数据
@property (nonatomic,strong)UIAlertView *alert;//不支持这个设备
@property (nonatomic,strong)UIButton *startButton;//开始按钮

@property (nonatomic,strong)UIView *backALLView; //背后的所有视图

@property (nonatomic, strong) UIButton *targetBtn;

//步数
@property (nonatomic, strong) UILabel *sportLabel;
//卡路里
@property (nonatomic, strong) UILabel *calouiesLabel;
//心率
@property (nonatomic, strong) UILabel *heartRateLabel;

/*
 *
 *目标时间选择器
 */
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSArray * hourArray;
@property (strong, nonatomic) NSArray * minuteArray;
@property (strong, nonatomic) UIButton *SubBackView;
@property (strong, nonatomic) UIView *SubAnimationView;
@property (strong, nonatomic) NSString * pickerViewMinute;
@property (strong, nonatomic) NSString * pickerViewHour;
@property (nonatomic, strong) NSString *targetTime;//运动的目标时间的字符串

@end

@implementation WorkOutView

- (void)layoutSubviews{
    [super layoutSubviews];
    [self childrenTimeSecondChanged];
    CGFloat backImageX = 0;
    CGFloat backImageY = 0;
    CGFloat backImageW = CurrentDeviceWidth;
    CGFloat backImageH = self.frame.size.height;
    [self addSubview:_backALLView];
    _backALLView.frame = CGRectMake(backImageX, backImageY, backImageW, backImageH);
    
    CGFloat UpViewH = 275*HeightProportion;
    CGFloat  downViewH = backImageH - UpViewH;//279*HeightProportion;
    CGFloat  downViewX = 8*WidthProportion;
    CGFloat  downViewW = CurrentDeviceWidth - 2*downViewX;
    CGFloat sportTabelViewX = 0;
    CGFloat sportTabelViewY = 12.5*HeightProportion;
    CGFloat sportTabelViewW = downViewW;
    CGFloat sportTabelViewH = downViewH - sportTabelViewY-30;
    _sportTabelView.frame = CGRectMake(sportTabelViewX, sportTabelViewY, sportTabelViewW, sportTabelViewH);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = allColorWhite;
        [self setupView];
        [self SPOremindView];
        [[PSDrawerManager instance] beginDragResponse];
        [BlueToothManager getInstance].delegate = self;
        [self setSportBlocks];
        [self SPOrefreshAlertView];    //连接的 提示界面
    }
    return self;
}

- (void)childrenTimeSecondChanged
{
    [self reloadDataALL];//换日期，就刷新界面
}
-(void)setupView
{
    [self initView];
    // 一、背景图
    CGFloat backImageX = 0;
    CGFloat backImageY = 0;
    CGFloat backImageW = CurrentDeviceWidth;
    CGFloat backImageH = self.height;
    UIImageView *backImageView = [[UIImageView alloc]init];
    [self addSubview:backImageView];
    backImageView.userInteractionEnabled = YES;
    backImageView.backgroundColor = kMainColor;
    backImageView.frame = CGRectMake(backImageX, backImageY, backImageW, backImageH);
    
    _backALLView = [[UIView alloc]init];
    [self addSubview:_backALLView];
    _backALLView.frame = CGRectMake(backImageX, backImageY, backImageW, backImageH);
    
    //上层视图
    UIView *UpView = [[UIView alloc]init];
    [_backALLView addSubview:UpView];
    //        UpView.backgroundColor = allColorRed;
    CGFloat UpViewX = 0;
    CGFloat UpViewY = 0;
    CGFloat UpViewW = CurrentDeviceWidth;
    CGFloat UpViewH = 275*HeightProportion;
    UpView.frame = CGRectMake(UpViewX, UpViewY, UpViewW, UpViewH);
    
    // 二、开始按钮   图   +   按钮
    CGFloat startImageViewX = UpView.width/2-(165*WidthProportion)/2;
    CGFloat startImageViewY = 5*HeightProportion;
    CGFloat startImageViewW = 178*WidthProportion;
    CGFloat startImageViewH = 155*WidthProportion;
    UIImageView *startImageView = [[UIImageView alloc]init];
    [UpView addSubview:startImageView];
    startImageView.userInteractionEnabled = YES;
    startImageView.image = [UIImage imageNamed:@"start"];
    startImageView.frame = CGRectMake(startImageViewX, startImageViewY, startImageViewW, startImageViewH);
    
    CGFloat startButtonX = 0;
    CGFloat startButtonY = 0;
    CGFloat startButtonW = startImageViewW;
    CGFloat startButtonH = startImageViewH;
    UIButton *startButton = [[UIButton alloc]init];
    [startImageView addSubview:startButton];
    startButton.frame = CGRectMake(startButtonX, startButtonY, startButtonW, startButtonH);
    startButton.backgroundColor = [UIColor clearColor];//allColorRed;
    [startButton addTarget:self action:@selector(startButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _startButton = startButton;
    
    //
    self.targetBtn = [[UIButton alloc] init];
    self.targetBtn.size = CGSizeMake(130*kX, 35*kDY);
    self.targetBtn.center = CGPointMake(CurrentDeviceWidth/2., startImageView.bottom+15*kDY);
    [UpView addSubview:self.targetBtn];
//    self.targetBtn.layer.borderColor = kMainColor.CGColor;
//    self.targetBtn.layer.borderWidth = 1;
//    self.targetBtn.layer.cornerRadius = self.targetBtn.height/2.;
    self.pickerViewHour = @"00";
    self.pickerViewMinute = @"30";
    [self.targetBtn setImage:[UIImage imageNamed:@"target1"] forState:UIControlStateNormal];
    NSAttributedString *attrString = [NSAttributedString getAttributedText:16 pickerViewHour:self.pickerViewHour pickerViewMinute:self.pickerViewMinute];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:attrString.string attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.targetBtn setAttributedTitle:att forState:UIControlStateNormal];
//    self.targetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.targetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.targetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.targetBtn addTarget:self action:@selector(targetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //
    NSArray *imageArr = @[@"bushuPeople",@"kalulineww",@"lanxinlv"];
    for (int i = 0; i < imageArr.count; i++) {
        UIView *bView = [[UIView alloc] init];
        bView.backgroundColor = [UIColor clearColor];
        bView.frame = CGRectMake(ScreenWidth/3*i, self.targetBtn.bottom, ScreenWidth/3, UpView.height - self.targetBtn.bottom);
        [UpView addSubview:bView];
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.image = [UIImage imageNamed:imageArr[i]];
        imageV.frame = CGRectMake(bView.width/2-(28*WidthProportion)/2, 0, 28*WidthProportion, 31*WidthProportion);
        [imageV setContentMode:UIViewContentModeScaleAspectFill];
        [bView addSubview:imageV];
        
        NSMutableAttributedString *string;
        if (i == 0) {
            string = [self makeAttributedStringWithnumBer:@"0" Unit:kLOCAL(@"步") WithFont:17];
            _sportLabel = [[UILabel alloc] init];
            _sportLabel.frame = CGRectMake(0, imageV.bottom, bView.width, bView.height-imageV.height);
            _sportLabel.textAlignment = NSTextAlignmentCenter;
            _sportLabel.attributedText = string;
            _sportLabel.textColor = allColorWhite;
            [bView addSubview:_sportLabel];
        }else if (i == 1){
            string = [self makeAttributedStringWithnumBer:@"0" Unit:kLOCAL(@"卡路里") WithFont:17];
            _calouiesLabel = [[UILabel alloc] init];
            _calouiesLabel.frame = CGRectMake(0, imageV.bottom, bView.width, bView.height-imageV.height);
            _calouiesLabel.textAlignment = NSTextAlignmentCenter;
            _calouiesLabel.attributedText = string;
            _calouiesLabel.textColor = allColorWhite;
            [bView addSubview:_calouiesLabel];
        }else{
            string = [self makeAttributedStringWithnumBer:@"0" Unit:kLOCAL(@"次/分") WithFont:17];
            _heartRateLabel = [[UILabel alloc] init];
            _heartRateLabel.frame = CGRectMake(0, imageV.bottom, bView.width, bView.height-imageV.height);
            _heartRateLabel.textAlignment = NSTextAlignmentCenter;
            _heartRateLabel.attributedText = string;
            _heartRateLabel.textColor = allColorWhite;
            [bView addSubview:_heartRateLabel];
        }
        
    }
    
    // 三、下层view   tableview  - -显示
    CGFloat  downViewX = 0;
    CGFloat  downViewY = UpViewH;//(startImageViewY + startImageViewH + startImageViewY);
    CGFloat  downViewW = CurrentDeviceWidth;
    CGFloat  downViewH = CurrentDeviceHeight - UpViewH;//279*HeightProportion;
    UIView *downView = [[UIView alloc]init];
    [_backALLView addSubview:downView];
    downView.frame = CGRectMake(downViewX, downViewY, downViewW, downViewH);
    downView.backgroundColor = allColorWhite;//[UIColor clearColor];
    //    downView.alpha = 0.1;
    
    CGFloat sportTabelViewX = 0;
    CGFloat sportTabelViewY = 12.5*HeightProportion;
    CGFloat sportTabelViewW = downViewW;
    CGFloat sportTabelViewH = downViewH - sportTabelViewY;
    
    _sportTabelView = [[UITableView alloc]init];
    _sportTabelView.tableFooterView = [[UIView alloc]init];
    [downView addSubview:_sportTabelView];
    _sportTabelView.backgroundColor = [UIColor whiteColor];
    _sportTabelView.delegate = self;
    _sportTabelView.dataSource = self;
    _sportTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _sportTabelView.frame = CGRectMake(sportTabelViewX, sportTabelViewY, sportTabelViewW, sportTabelViewH);
}
//开始按钮的开始事件
-(void)startButtonAction
{
    _startButton.userInteractionEnabled = NO;
    
    MapSportTypeViewController *sportTypeVC = [[MapSportTypeViewController alloc]init];
    [sportTypeVC setHidesBottomBarWhenPushed:YES];
    sportTypeVC.navigationController.navigationBar.hidden = YES;
    sportTypeVC.pickerViewHour = self.pickerViewHour;
    sportTypeVC.pickerViewMinute = self.pickerViewMinute;
    [self.controller.navigationController pushViewController:sportTypeVC animated:YES];
    
//    SelectStepTypeViewController *step = [SelectStepTypeViewController new];
//    step.hidesBottomBarWhenPushed = YES;
//    [self.controller.navigationController pushViewController:step animated:YES];
//    WeakSelf;
//    step.backStepType = ^(NSString *type) {
//        //开始运动
//    };
    
    _startButton.userInteractionEnabled = YES;
}

-(void)initView
{
    WeakSelf
    [[PZBlueToothManager sharedInstance] recieveOffLineDataWithBlock:^(SportModelMap *model) {
        [weakSelf reloadDataALL];
    }];
    
}
- (void)setSportBlocks
{
    WeakSelf;
    
    [[PZBlueToothManager sharedInstance] checkBandPowerWithPowerBlock:^(int number) {
        if ([CositeaBlueTooth sharedInstance].isConnected)
        {
            [self SPOConnected];
            [weakSelf performSelector:@selector(SPOsubmitIsConnect) withObject:nil afterDelay:2.0f];
        }
    }];
    
    [[CositeaBlueTooth sharedInstance] checkConnectTimeAlert:^(int number) {
        if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
        {
            [weakSelf SPOconnectionFailedAction:number];
        }
    }];
    
    [[CositeaBlueTooth sharedInstance]checkCBCentralManagerState:^(CBCentralManagerState state) {
        [weakSelf SPOrefreshAlertView];
    }];
    
    [BlueToothManager getInstance].delegate = self;
    
    //解除绑定要回调事件
    SheBeiViewController *shebei = [SheBeiViewController sharedInstance];
    [shebei changRemoveBinding:^(int number) {
        //adaLog(@"number2 == sport == %d",number);
        if (number) {
            //[weakSelf SPOsubmitIsConnect];
            [weakSelf SPOrefreshAlertView];
        }
    }];
    
}
- (void)reloadDataALL;
{
    NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:kHCH.selectTimeSeconds andFormat:@"yyyy-MM-dd"];
    NSArray * array = [[SQLdataManger getInstance] queryHeartRateDataWithDate:timeStr];
    
    _sportArray = [NSMutableArray arrayWithArray:array];
    _sportArray = [self sortSport:_sportArray];
    [self.sportTabelView reloadData];
    
    NSInteger allBpmAvg = 0;
    NSInteger allStep = 0;
    NSInteger allKcal = 0;
    for (SportModelMap *sport in _sportArray) {
        NSString *bpm = [AllTool  getMean:sport.heartRateArray];
        allBpmAvg += bpm.integerValue;
        allStep += sport.stepNumber.integerValue;
        allKcal += sport.kcalNumber.integerValue;
    }
    self.sportLabel.attributedText = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%ld",allStep] Unit:kLOCAL(@"步") WithFont:17];
    self.calouiesLabel.attributedText = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%ld",allKcal] Unit:kLOCAL(@"卡路里") WithFont:17];
    self.heartRateLabel.attributedText = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%ld",allBpmAvg/_sportArray.count] Unit:kLOCAL(@"次/分") WithFont:17];
    
}
#pragma mark    ---  私有方法
-(void)openHeartRateFail
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"运动开启失败", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
    //alert.tag = 103;
    [alert show];
    
}
-(void)dimissAlert:(UIAlertView *)alert {
    if(alert)
    {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}


//#pragma mark  --  tableView -- delegate
//
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_sportArray.count <=0){
        [self  addTwoFalseData];//添加假数据
        //return _sportArray.count;
    }
    return _sportArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SportMapTableViewCell *cell = [SportMapTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    if (_sportArray.count > 0)
    {
        SportModelMap *model = _sportArray[indexPath.row];
        cell.sport = model;     //模型
        cell.arrayIndex = (NSInteger)indexPath.row; //数组的下标
    }
    cell.backBlock = ^(int aa)
    {
        [self selectCell:aa];
    };
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)selectCell:(int)row
{
    //adaLog(@"row == %d",row);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self tableView:self.sportTabelView didSelectRowAtIndexPath:indexPath];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 118*HeightProportion;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    SportModelMap * sportM = _sportArray[indexPath.row];
    if([sportM.sportType integerValue] < 1000)
    {
        SportDetailMapTwoViewController *detailView = [[SportDetailMapTwoViewController alloc]init];
        [detailView setHidesBottomBarWhenPushed:YES];
        detailView.navigationController.navigationBar.hidden = YES;
        detailView.mapSport = (SportModelMap*)sportM;
        [self.controller.navigationController pushViewController:detailView animated:YES];
        
        
    }
    else
    {
        MapSportTypeSelectViewController *sportTypeVC = [[MapSportTypeSelectViewController alloc]init];
        sportTypeVC.sport = sportM;
        sportTypeVC.delegate = self;
        [sportTypeVC setHidesBottomBarWhenPushed:YES];
        sportTypeVC.navigationController.navigationBar.hidden = YES;
        [self.controller.navigationController pushViewController:sportTypeVC animated:YES];
        
    }
}

#pragma mark -
- (void)targetBtnAction:(UIButton *)button{
    if (_SubBackView == nil) [self setPickerViewTwo];
}

#pragma mark   - - - 排序 各个运动
-(NSMutableArray *)sortSport:(NSMutableArray *)array
{
    for (NSInteger i = 0; i<array.count; i++) {
        for (NSInteger j= i+1; j<array.count ; j++) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date1 = [formatter dateFromString:[(SportModelMap *)array[i] toTime]];
            NSDate *date2 = [formatter dateFromString:[(SportModelMap *)array[j] toTime]];
            NSTimeInterval aTimer = [date2 timeIntervalSinceDate:date1];
            if (aTimer > 0) {
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    return array;
}
#pragma mark ---   alertView   delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{  if (alertView.tag == 66)
{
    if([CLLocationManager locationServicesEnabled]){
        //adaLog(@"请允许位置服务");
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL: url];
        }
    }
}
}

-(void)addTwoFalseData
{
    SportModelMap *sport1 = [[SportModelMap alloc]init];
    NSString *currentDateStr = [[[NSDate alloc]init] GetCurrentDateStr];
    
    sport1.sportID = @"0";
    sport1.sportType = @"100";
    sport1.sportDate = currentDateStr;
    sport1.fromTime = [NSString stringWithFormat:@"%@ 00:00:00",currentDateStr];
    sport1.toTime =  [NSString stringWithFormat:@"%@ 00:00:00",currentDateStr];
    sport1.stepNumber = @"0";
    sport1.kcalNumber = @"0";
    sport1.sportName = NSLocalizedString(@"徒步",nil);
    sport1.falseData = @"1";
    
    SportModelMap *sport2 = [[SportModelMap alloc]init];
    sport2.sportID = @"1";
    sport2.sportType = @"102";
    sport2.sportDate = currentDateStr;
    sport2.fromTime = [NSString stringWithFormat:@"%@ 00:00:00",currentDateStr];
    sport2.toTime =  [NSString stringWithFormat:@"%@ 00:00:00",currentDateStr];
    sport2.stepNumber = @"0";
    sport2.kcalNumber = @"0";
    sport2.sportName = NSLocalizedString(@"登山",nil);
    sport2.falseData = @"1";
    //    SportModelMap *sport3 = [[SportModelMap alloc]init];
    //    sport3.sportID = @"1";
    //    sport3.sportType = @"102";
    //    sport3.sportDate = currentDateStr;
    //    sport3.fromTime = [NSString stringWithFormat:@"%@ 00:00:00",currentDateStr];
    //    sport3.toTime =  [NSString stringWithFormat:@"%@ 00:00:00",currentDateStr];
    //    sport3.stepNumber = @"0";
    //    sport3.kcalNumber = @"0";
    [_sportArray addObject:sport1];
    [_sportArray addObject:sport2];
    //    [_sportArray addObject:sport3];
}

#pragma mark -   SportTableViewCellDelegate   delete   cell
-(void)deleteSportWithID:(NSString *)sportID
{
    [[SQLdataManger getInstance]deleteDataWithColumns:@{@"sportID":sportID,CurrentUserName_HCH:[[HCHCommonManager getInstance]UserAcount]} fromTableName:@"ONLINESPORT"];
    
    [self childrenTimeSecondChanged];
}
#pragma mark    -- SportModelTableViewControllerDelegate       代理

-(void)callbackSelected:(int)sportType  andSportModel:(SportModelMap *)sport  andSportName:(NSString *)SportName
{
    
    SportDetailMapTwoViewController *detail = [[SportDetailMapTwoViewController alloc]init];
    
    [detail setHidesBottomBarWhenPushed:YES];
    detail.navigationController.navigationBar.hidden = YES;
    [self.controller.navigationController pushViewController:detail animated:YES];
    detail.mapSport = sport;
}

#pragma mark    ----- 连接状态的提示
-(void)SPOremindView
{
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(SPOconnectionFailedAction:) name:@"ConnectTimeout" object:nil];
    [center addObserver:self selector:@selector(SPOrefreshAlertView) name:@"didDisconnectDevice" object:nil];
    
}

//初始化提醒的view  的 刷新
-(void)SPOrefreshAlertView
{
    
}

-(void)SPOconnectionFailedAction:(int)isSeek
{
    
}

-(void)SPOconnectButtonToshebei
{
    SheBeiViewController *shebeiVC = [SheBeiViewController sharedInstance];
    shebeiVC.hidesBottomBarWhenPushed = YES;
    [self.controller.navigationController pushViewController:shebeiVC animated:YES];
}
-(void)refreshConnect
{
    WeakSelf;
    if ([CositeaBlueTooth sharedInstance].isConnected)
    {   [self SPOConnected];
        [weakSelf performSelector:@selector(SPOsubmitIsConnect) withObject:nil afterDelay:2.0f];
    }
}
#pragma mark --  代理。监测连接状态
- (void)BlueToothIsConnected:(BOOL)isconnected
{
    if (isconnected)
    {
        [self SPOConnected];
        [self performSelector:@selector(SPOsubmitIsConnect) withObject:nil afterDelay:2.0f];
    }
}
-(void)SPOConnected
{
}
-(void)SPOsubmitIsConnect
{
}

#pragma mark   - -- 蓝牙状态的回调   --- delegate

-(void)callbackCBCentralManagerState:(CBCentralManagerState)state
{
    [self performSelector:@selector(SPOrefreshAlertView) withObject:nil afterDelay:1.f];
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//获取属性字符串
- (NSMutableAttributedString *)makeAttributedStringWithnumBer:(NSString *)number Unit:(NSString *)unit WithFont:(int)font
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:number];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, attributeString.length)];
    NSMutableAttributedString *unitString = [[NSMutableAttributedString alloc] initWithString:unit];
    [unitString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font - 5] range:NSMakeRange(0, unitString.length)];
    [attributeString appendAttributedString:unitString];
    return attributeString;
}

#pragma mark  --  UIDatePicker --
- (void)setPickerViewTwo
{
    _SubBackView = [[UIButton alloc] initWithFrame:CurrentDeviceBounds];
    _SubBackView.backgroundColor = [UIColor clearColor];
    [self.controller.view addSubview:_SubBackView];
    [_SubBackView addTarget:self action:@selector(dateSureClickTwo) forControlEvents:UIControlEventTouchUpInside];
    
    
    _SubAnimationView  = [[UIView alloc] initWithFrame:CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, 246)];
    [_SubBackView addSubview:_SubAnimationView];
    _SubAnimationView.backgroundColor = [UIColor whiteColor];
    
    //弹出的pickerView
    CGFloat pickerViewX = 0;
    CGFloat pickerViewY = 50;
    CGFloat pickerViewW = CurrentDeviceWidth;
    CGFloat pickerViewH = 246 - pickerViewY;
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(pickerViewX,pickerViewY, pickerViewW, pickerViewH)];
    [_SubAnimationView addSubview:self.pickerView];
    //设置选择器的水平的阴影效果
    self.pickerView.showsSelectionIndicator = YES;
    
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [_SubAnimationView addSubview:self.pickerView];
    [self.pickerView reloadAllComponents];//刷新UIPickerView
    
    UILabel * hourLabel = [[UILabel alloc]init];
    [self.pickerView addSubview:hourLabel];
    hourLabel.text = @"h";
    hourLabel.backgroundColor = [UIColor clearColor];
    CGFloat hourLabelX = CurrentDeviceWidth / 3;
    CGFloat hourLabelW = CurrentDeviceWidth / 4;
    CGFloat hourLabelH = 25;
    CGFloat hourLabelY = pickerViewH/ 2 - hourLabelH * 0.7;
    hourLabel.frame = CGRectMake(hourLabelX, hourLabelY, hourLabelW, hourLabelH);
    
    UILabel * minuteLabel = [[UILabel alloc]init];
    [self.pickerView addSubview:minuteLabel];
    minuteLabel.text = @"min";
    minuteLabel.backgroundColor = [UIColor clearColor];
    CGFloat minuteLabelX = CurrentDeviceWidth / 3 * 2;
    CGFloat minuteLabelW = CurrentDeviceWidth / 4;
    CGFloat minuteLabelH = hourLabelH;
    CGFloat minuteLabelY = pickerViewH/ 2 - minuteLabelH * 0.7;
    minuteLabel.frame = CGRectMake(minuteLabelX, minuteLabelY, minuteLabelW, minuteLabelH);
    NSInteger row1 = 0;
    NSInteger row2 = 0;
    if(self.targetBtn.titleLabel.attributedText)
    {
        row1 = self.hourArray.count/2 + [self.pickerViewHour integerValue];
        row2 = self.minuteArray.count/2 + [self.pickerViewMinute integerValue];
    }
    else
    {
        row1 = self.hourArray.count/2;
        row2 = self.minuteArray.count/2;
    }
    [self.pickerView selectRow:row1 inComponent:0 animated:NO];
    [self.pickerView selectRow:row2 inComponent:1 animated:NO];
    
    //右上角的选择按钮
    UIView *buttonView = [[UIView alloc] init];
    [_SubAnimationView addSubview:buttonView];
    CGFloat buttonViewX = 50;
    CGFloat buttonViewY = 50;
    buttonView.sd_layout
    .topSpaceToView(_SubAnimationView,10)
    .rightSpaceToView(_SubAnimationView,10)
    .heightIs(buttonViewX)
    .widthIs(buttonViewY);
    
    UIImageView *btnImageView = [[UIImageView alloc] init];
    btnImageView.image = [UIImage imageNamed:@"xuanze"];
    [buttonView addSubview:btnImageView];
    btnImageView.userInteractionEnabled = YES;
    
    btnImageView.sd_layout
    .topSpaceToView(buttonView,0)
    .rightSpaceToView(buttonView,10)
    .heightIs(buttonViewX - 20)
    .widthIs(buttonViewY - 20);
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonView addSubview:button];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(dateSureClickTwo) forControlEvents:UIControlEventTouchUpInside];
    button.sd_layout
    .topSpaceToView(buttonView,0)
    .rightSpaceToView(buttonView,0)
    .heightIs(buttonViewX)
    .widthIs(buttonViewY);
    
    
    
    [UIView animateWithDuration:0.23 animations:^{
        _SubBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _SubAnimationView.frame = CGRectMake(0, CurrentDeviceHeight - 246,CurrentDeviceWidth, 246);
    }];
}

- (void)hiddenPickerView
{
    [UIView animateWithDuration:0.23 animations:^{
        _SubAnimationView.frame = CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, 246);
        _SubBackView.frame = CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, 246);
    } completion:^(BOOL finished) {
        [self.pickerView removeFromSuperview];
        self.pickerView = nil;
        [_SubAnimationView removeFromSuperview];
        _SubAnimationView = nil;
        [_SubBackView removeFromSuperview];
        _SubBackView = nil;
        
    }];
}

- (void)dateSureClickTwo
{
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSAttributedString getAttributedText:16 pickerViewHour:self.pickerViewHour pickerViewMinute:self.pickerViewMinute].string attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.targetBtn setAttributedTitle:att forState:UIControlStateNormal];
    //    [ADASaveDefaluts setObject:[NSString stringWithFormat:@"%@H%@min",self.pickerViewHour,self.pickerViewMinute] forKey:MAPSPORTTARGET];//保存地图运动目标
    
    if (self.pickerViewHour == 0) {
        self.targetTime = [NSString stringWithFormat:@"%@min",self.pickerViewMinute];
    }else{
        self.targetTime = [NSString stringWithFormat:@"%@H%@min",self.pickerViewHour,self.pickerViewMinute];
    }
    [self hiddenPickerView];
    
}

#pragma mark - pickerView Delegate DataSource

//返回有几列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
//返回指定列的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component==0){
        
        return  self.hourArray.count;
    }
    return self.minuteArray.count;
}
//返回指定列，行的高度，就是自定义行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 130.0f * HEIGHT_PROPORTION;
}
//返回指定列的宽度
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    //    //adaLog(@"CurrentDeviceWidth / 6 = %f",[UIScreen mainScreen].bounds.size.width / 6);
    return  [UIScreen mainScreen].bounds.size.width / 3;
}

// 自定义指定列的每行的视图，即指定列的每行的视图行为一致
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }
    if(component == 0){
        UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 20)];
        text.textAlignment = NSTextAlignmentCenter;
        text.text = [self.hourArray objectAtIndex:row];
        [view addSubview:text];
    }else{
        
        UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,80, 20)];
        text.textAlignment = NSTextAlignmentCenter;
        text.text = [self.minuteArray objectAtIndex:row];
        [view addSubview:text];
    }
    
    return view;
}
//显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    //    if (component == 0) {
    //        return     @"H";
    //    } else if(component == 1){
    //        return     @"min";
    //
    //    }
    return @"H";
}
//显示的标题字体、颜色等属性
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if(component == 0){
        NSString *str = self.hourArray[row];
        NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:str];
        [AttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:54 * ZITI_PROPORTION], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [AttributedString  length])];
        
        return AttributedString;
    }
    
    NSString *str = self.minuteArray[row];
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:54 * ZITI_PROPORTION], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [AttributedString  length])];
    
    return AttributedString;
}

//PickerView被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if(component == 0){
        self.pickerViewHour = [self.hourArray objectAtIndex:row];
        //adaLog(@"hour  = %@",[self.hourArray objectAtIndex:row]);
    }else if(component == 1){
        self.pickerViewMinute = [self.minuteArray objectAtIndex:row];
        //adaLog(@"minute  = %@",[self.minuteArray objectAtIndex:row]);
    }
    
}

#pragma mark   -    懒加载

-(NSArray *)hourArray
{
    if (!_hourArray) {
        _hourArray = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
    }
    return _hourArray;
}
-(NSArray *)minuteArray
{
    if (!_minuteArray) {
        _minuteArray = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
    }
    
    return _minuteArray;
}

@end

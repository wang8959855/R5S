////
////  TodaySportViewController.m
////  Mistep
////
////  Created by 迈诺科技 on 2016/9/24.
////  Copyright © 2016年 huichenghe. All rights reserved.
////
//#define  upDownMargin 10
//#define  leadingSpace 5
//#define  UIPickerViewHeight 246
//
//#import "TodaySportViewController.h"
//#import "SportTableViewCell.h"
//#import "SportModelTableViewController.h"
//#import "SportModel.h"
//#import "sportView.h"
//#import "TodaySportDetailViewController.h"
//#import "UIViewController+MMDrawerController.h"
//#import "TimingUploadData.h"
//
//
//@interface TodaySportViewController ()<PZBlueToothManagerDelegate,SportTableViewCellDelegate,SportModelTableViewControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource>
//@property (nonatomic,strong)UITableView *sportTabelView;  //下半部的运动数组展示
//@property (nonatomic,strong)NSMutableArray *sportArray;  //下半部数据
////@property (nonatomic,strong)UILabel *targetLabel;//目标设置，有目标时间时。隐藏
//@property (nonatomic,strong)UIButton *timeViewButton;//目标设置
//@property (nonatomic,strong)UILabel *startLabel;//开始运动
//@property (strong, nonatomic) UIScrollView *backScrollView;//背景。用于下拉刷新
///*
// *
// *目标时间选择器
// */
//@property (strong, nonatomic) UIPickerView *pickerView;
//@property (strong, nonatomic) NSArray * hourArray;
//@property (strong, nonatomic) NSArray * minuteArray;
//@property (strong, nonatomic) NSString * pickerViewMinute;
//@property (strong, nonatomic) NSString * pickerViewHour;
////显示时间的lable
//@property (strong, nonatomic) UILabel *timeLabel;
//@property (nonatomic,assign) sportType sportType;
//@property (nonatomic,strong)NSString *sportName;
//
////开始的uiimageView
//@property (nonatomic,strong)UIImageView *startImageView;
////端点小圆
//@property (nonatomic,strong)UIImageView *yuanImageView;
//@property (nonatomic,strong) UIButton *startButton; //开始的button
//@property (nonatomic,strong)UILabel *timingLabel;//计时label
////暂停按钮的标记
//@property (nonatomic,strong) UIButton *pauseButton;
//@property (strong, nonatomic) NSTimer *timerGetheartRate;//定时获取心率
////注意＊＊这里不需要✳️号 可以理解为dispatch_time_t 已经包含了
////@property (nonatomic, strong) dispatch_source_t GetheartRateTimer;//定时获取心率
//@property (strong, nonatomic) SportModel *initialSport;//在线运动。开始的数据
//@property (strong, nonatomic) UILabel *stepLabel;
//@property (strong, nonatomic) UILabel *kcalLabel;
//@property (strong, nonatomic) UILabel *bpmLabel;
//@property (assign, nonatomic) NSInteger targetSecond;
//@property (strong, nonatomic) NSString *sportDate;  //保存运动时间
//@property (strong, nonatomic) NSString *fromTime;   //保存运动时间
//@property (strong, nonatomic) NSString *toTime; //保存运动时间
////@property (strong, nonatomic) NSDate *date;
//@property (strong, nonatomic) sportView *sp;//进度的跳动图
//@property (assign, nonatomic) NSInteger progress;
//@property (strong, nonatomic) NSMutableArray *heartArray;//心律数组。用于求平均值    又用于存储
//
//@property (assign,nonatomic) BOOL pauseFlag;//用于暂停的计算
//@property (strong,nonatomic) SportModel *realtimeSport;//实时运动。开始的数据
//@property (assign,nonatomic) NSInteger  stepNumberPlus; //用于保存步数
//@property (assign,nonatomic) NSInteger  kcalNumberPlus;//用于保存kcal
//@property (assign,nonatomic) NSInteger  heartRateNumberPlus;//用于保存heartRate
//@property (strong,nonatomic) UIAlertView *alert;//自动消失的提示框
//@property (nonatomic,strong)UIView *connectView;//提示连接的view
//@end
//
//@implementation TodaySportViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    //    [[SQLdataManger getInstance] deleteDataWithTableName:@"ONLINESPORT"];
//    
//    self.view.backgroundColor = kColor(234, 243, 250);
//    [self.view addSubview:self.navView];
//    [self setupView];
//}
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [self childrenTimeSecondChanged];
//    [self.tabBarController.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
//}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:YES];
//}
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self.tabBarController.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
//    //    if (_timerGetheartRate.isValid) {
//    //        [self.timerGetheartRate setFireDate:[NSDate distantFuture]];
//    //        _pauseFlag = YES;
//    //        [_pauseButton setImage:[UIImage imageNamed:@"开始小"] forState:UIControlStateNormal];
//    //        _pauseButton.tag = 60;
//    //    }
//    //    [_timer invalidate];
//    //    _timer = nil;
//    //    [self unableHeart];
//    //    [self.tabBarController.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
//}
//
//- (void)childrenTimeSecondChanged
//{
//    [self reloadDataALL];//换日期，就刷新界面
//}
//- (void)reloadDataALL;
//{
//    NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:kHCH.selectTimeSeconds andFormat:@"yyyy-MM-dd"];
//    NSArray * array = [[SQLdataManger getInstance] queryHeartRateDataWithDate:timeStr];
//    
//    if ([CositeaBlueTooth sharedInstance].isConnected)
//    {
//        
//        if(array.count>0)
//        {
//            _sportArray = [NSMutableArray arrayWithArray:array];
//            _sportArray = [self sortSport:_sportArray];
//            [self.sportTabelView reloadData];
//        }
//        else
//        {
//            [self performSelector:@selector(reloadTableViewData) withObject:nil afterDelay:0.5f];
//            //蓝牙没有连接就查询服务器
//            if(![CositeaBlueTooth sharedInstance].isConnected)
//            {
//                [TimingUploadData downDayOnlinesport:^(NSArray *array) {
//                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadTableViewData) object:nil];
//                    _sportArray = [NSMutableArray arrayWithArray:array];
//                    _sportArray = [self sortSport:_sportArray];
//                    [self.sportTabelView reloadData];
//                } date:kHCH.selectTimeSeconds];
//            }
//        }
//    }
//    else
//    {
//        [self performSelector:@selector(reloadTableViewData) withObject:nil afterDelay:0.5f];
//        [TimingUploadData downDayOnlinesport:^(NSArray *array) {
//            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadTableViewData) object:nil];
//            _sportArray = [NSMutableArray arrayWithArray:array];
//            _sportArray = [self sortSport:_sportArray];
//            [self.sportTabelView reloadData];
//        } date:kHCH.selectTimeSeconds];
//        
//    }
//    
//    
//}
//
//-(void)reloadTableViewData
//{
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadTableViewData) object:nil];
//    _sportArray = [NSMutableArray array];
//    [self.sportTabelView reloadData];
//}
//-(void)setupView
//{
//    [self initView];
//    //    CGFloat backScrollViewX = 0;
//    CGFloat backScrollViewY = 64;
//    CGFloat backScrollViewW = CurrentDeviceWidth;
//    CGFloat backScrollViewH = CurrentDeviceHeight - 64 - 49;
//    self.backScrollView = [[UIScrollView alloc] init];
//    self.backScrollView.frame = CGRectMake(0,backScrollViewY,backScrollViewW,backScrollViewH);
//    [self.view addSubview:self.backScrollView];
//    self.backScrollView.backgroundColor = kColor(234, 243, 250);
//    self.backScrollView.contentSize = CGSizeMake(self.backScrollView.width, self.backScrollView.height+0.5);
//    self.backScrollView.showsVerticalScrollIndicator = NO;
//    //    self.backScrollView.scrollEnabled = NO;
//    self.backScrollView.contentSize =  CGSizeMake(CurrentDeviceWidth, 0);
//    //上层的view
//    [self setupUpView:self.backScrollView];
//    //下层的view
//    [self setupDownView:self.backScrollView];
//    
//    /*[UIView animateWithDuration:0.2f animations:^{
//     self.backScrollView.frame = CGRectMake(0,backScrollViewY+connectViewH, backScrollViewW,backScrollViewH);
//     }];*/
//    //    WeakSelf;
//    //    [[PZBlueToothManager sharedInstance] checkBandPowerWithPowerBlock:^(int number) {
//    //        if (![CositeaBlueTooth sharedInstance].isConnected)
//    //        {
//    //            [weakSelf refreshAlertView];
//    //        }
//    //    }];
//}
//-(void)initView
//{    _stepNumberPlus =0;
//    _kcalNumberPlus =0;
//    _heartRateNumberPlus =0;
//    _pauseFlag = NO;
//    _heartArray = [NSMutableArray array];
//    self.haveTabBar = YES;
//    [PZBlueToothManager sharedInstance].delegate = self;
//    WeakSelf
//    [[PZBlueToothManager sharedInstance] recieveOffLineDataWithBlock:^(SportModel *model) {
//        [weakSelf reloadDataALL];
//    }];
//    //    [[CositeaBlueTooth sharedInstance]checkCBCentralManagerState:^(CBCentralManagerState state) {
//    //        if (state!=CBManagerStatePoweredOn)
//    //        {
//    //            [weakSelf refreshAlertView];
//    //        }
//    //    }];
//}
//-(void)setupUpView:(UIScrollView *)scrollView
//{
//    //上层的view
//    
//    UIView *UpView = [[UIView alloc]init];
//    [scrollView addSubview:UpView];
//    UpView.backgroundColor = [UIColor orangeColor];
//    
//    CGFloat  UpViewX = 0;
//    CGFloat  UpViewY = 0;
//    CGFloat  UpViewW = CurrentDeviceWidth;
//    CGFloat  UpViewH = (CurrentDeviceMiddleHeight / 2);
//    UpView.frame = CGRectMake(UpViewX, UpViewY, UpViewW, UpViewH);
//    
//    //上层图的背景
//    UIImageView *backImageView = [[UIImageView alloc]init];
//    [UpView addSubview:backImageView];
//    backImageView.image = [UIImage imageNamed:@"运动背景"];
//    backImageView.userInteractionEnabled = YES;
//    
//    CGFloat  backImageViewX = 0;
//    CGFloat  backImageViewY = 0;
//    CGFloat  backImageViewW = UpViewW;
//    CGFloat  backImageViewH = UpViewH;
//    backImageView.frame = CGRectMake(backImageViewX, backImageViewY, backImageViewW, backImageViewH);
//    
//    
//    //端点小圆
//    UIImageView *yuanImageView = [[UIImageView alloc]init];
//    [UpView addSubview:yuanImageView];
//    _yuanImageView=yuanImageView;
//    yuanImageView.image = [UIImage imageNamed:@"111"];
//    yuanImageView.userInteractionEnabled = YES;
//    //    yuanImageView.backgroundColor = [UIColor lightGrayColor];
//    
//    CGFloat  yuanImageViewW = 181 * kX;//182;
//    CGFloat  yuanImageViewH = 166 * kSY;//167;
//    CGFloat  yuanImageViewX = (CurrentDeviceWidth - yuanImageViewW) * 0.5 ;
//    CGFloat  yuanImageViewY = 30;
//    yuanImageView.frame = CGRectMake(yuanImageViewX, yuanImageViewY, yuanImageViewW, yuanImageViewH);
//    yuanImageView.centerX = CurrentDeviceWidth * 0.5;
//    
//    
//    
//    
//    //开始的uiimageView
//    UIImageView *startImageView = [[UIImageView alloc]init];
//    _startImageView = startImageView;
//    [yuanImageView addSubview:startImageView];
//    startImageView.image = [UIImage imageNamed:@"开始"];
//    startImageView.userInteractionEnabled = YES;
//    
//    CGFloat  startImageViewW = 40;//182;
//    CGFloat  startImageViewH = 50;//167;
//    CGFloat  startImageViewX = (yuanImageViewW - startImageViewW) * 0.5 + 10 ;
//    CGFloat  startImageViewY = (yuanImageViewH - startImageViewH) * 0.5 - 10;
//    startImageView.frame = CGRectMake(startImageViewX, startImageViewY, startImageViewW, startImageViewH);
//    
//    
//    //开始的startLabel
//    UILabel *startLabel = [[UILabel alloc]init];
//    [yuanImageView addSubview:startLabel];
//    _startLabel=startLabel;
//    startLabel.textAlignment = NSTextAlignmentCenter;
//    startLabel.text = @"Start";
//    startLabel.font = [UIFont systemFontOfSize:14];
//    CGFloat  startLabelW = 120;//182;
//    CGFloat  startLabelH = 20;//167;
//    CGFloat  startLabelX = startImageViewX - 50;
//    CGFloat  startLabelY = CGRectGetMaxY(startImageView.frame) + 5;
//    startLabel.frame = CGRectMake(startLabelX, startLabelY, startLabelW, startLabelH);
//    
//    
//    
//    
//    
//    //定时的button ---  timeView  --  timeViewButton
//    //选择目标时间的按钮
//    //其他都是显示的东西。这个是按钮  - -- 目标设置按钮
//    UIButton *timeViewButton = [[UIButton alloc]init];
//    [yuanImageView addSubview:timeViewButton];
//    self.timeViewButton = timeViewButton;
//    timeViewButton.backgroundColor = allColorWhite;
//    
//    CGFloat  hengdingNumber = 90;
//    CGFloat  timeViewButtonW = yuanImageViewW * 0.5 > hengdingNumber ? (yuanImageViewW * 0.5) : hengdingNumber;
//    CGFloat  timeViewButtonH = 24;
//    CGFloat  timeViewButtonX = yuanImageViewW / 4 + 9;
//    CGFloat  timeViewButtonY = CGRectGetMaxY(yuanImageView.frame) - timeViewButtonH * 2;
//    timeViewButton.frame = CGRectMake(timeViewButtonX, timeViewButtonY, timeViewButtonW, timeViewButtonH);
//    timeViewButton.layer.cornerRadius = timeViewButtonH * 0.5;
//    timeViewButton.layer.masksToBounds=YES;
//    timeViewButton.centerX = yuanImageView.width * 0.5;
//    timeViewButton.layer.borderWidth = 0.5;
//    timeViewButton.layer.borderColor = [UIColor blackColor].CGColor;
//    [timeViewButton setImage:[UIImage imageNamed:@"目标"] forState:UIControlStateNormal];
//    self.pickerViewHour = @"00";
//    self.pickerViewMinute = @"30";
//    //返回目标时间
//    [timeViewButton setAttributedTitle:[self getAttributedText:18] forState:UIControlStateNormal];
//    [timeViewButton addTarget:self action:@selector(timeTarget) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    //开始的button  startButton
//    UIButton *startButton = [[UIButton alloc]init];
//    [yuanImageView addSubview:startButton];
//    _startButton = startButton;
//    startButton.backgroundColor = [UIColor clearColor]; //startButton.alpha = 0.8;
//    
//    [startButton addTarget:self action:@selector(startSportLoad:) forControlEvents:UIControlEventTouchUpInside];
//    CGFloat  startButtonW = 110 * WidthProportion;
//    CGFloat  startButtonH = 110 * HeightProportion;
//    CGFloat  startButtonX = (yuanImageView.size.width - startButtonW)*0.5;
//    CGFloat  startButtonY = (yuanImageView.size.width - startButtonH)*0.5;
//    startButton.frame = CGRectMake(startButtonX, startButtonY, startButtonW, startButtonH);
//    //    startButton.sd_layout.bottomSpaceToView(timeViewButton,0);
//    
//    //显示步数等等的bar
//    UIView *barView = [[UIView alloc]init];
//    [UpView addSubview:barView];
//    CGFloat  barViewX = 0;
//    CGFloat  barViewW = CurrentDeviceWidth;
//    CGFloat  barViewH = 60 * kSY;
//    CGFloat  barViewY = UpViewH - barViewH;
//    barView.frame = CGRectMake(barViewX, barViewY, barViewW, barViewH);
//    [self setupCustViewStep:barView];
//    [self setupCustViewKcal:barView];
//    [self setupCustViewBpm:barView];
//}
//
//
//-(void)setupCustViewStep:(UIView *)barView
//{
//    UIImageView *imageView = [[UIImageView alloc]init];
//    [barView addSubview:imageView];
//    
//    CGFloat imageViewX = 0;
//    CGFloat imageViewY = 0;
//    CGFloat imageViewW = 35 * CurrentDeviceWidth/375;
//    CGFloat imageViewH = 35 * CurrentDeviceHeight/667;
//    imageView.image = [UIImage imageNamed:@"步数"];
//    imageView.frame =  CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
//    imageView.centerX = CurrentDeviceWidth / 6;
//    
//    UILabel *stepLabel = [[UILabel alloc]init];
//    [barView addSubview:stepLabel];
//    _stepLabel= stepLabel;
//    stepLabel.textAlignment =NSTextAlignmentCenter;
//    stepLabel.attributedText = [self makeAttributedStringWithnumBer:@"0" Unit:@"steps" WithFont:18];
//    
//    CGFloat stepLabelX = 0;
//    CGFloat stepLabelY = CGRectGetMaxY(imageView.frame);
//    CGFloat stepLabelW =  CurrentDeviceWidth / 3;
//    CGFloat stepLabelH =  barView.frame.size.height - CGRectGetMaxY(imageView.frame);
//    stepLabel.frame =  CGRectMake(stepLabelX, stepLabelY, stepLabelW, stepLabelH);
//    //    stepLabel.centerX = CurrentDeviceWidth / 6;
//    
//    
//}
//-(void)setupCustViewKcal:(UIView *)barView
//{
//    UIImageView *imageView = [[UIImageView alloc]init];
//    [barView addSubview:imageView];
//    
//    CGFloat imageViewX = 0;
//    CGFloat imageViewY = 0;
//    CGFloat imageViewW = 35 * CurrentDeviceWidth/375;
//    CGFloat imageViewH = 35 * CurrentDeviceHeight/667;
//    imageView.image = [UIImage imageNamed:@"卡路里"];
//    imageView.frame =  CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
//    imageView.centerX = CurrentDeviceWidth / 2;
//    imageView.backgroundColor = [UIColor clearColor];
//    
//    
//    UILabel *kcalLabel = [[UILabel alloc]init];
//    [barView addSubview:kcalLabel];
//    _kcalLabel = kcalLabel;
//    kcalLabel.textAlignment =NSTextAlignmentCenter;
//    kcalLabel.attributedText = [self makeAttributedStringWithnumBer:@"0" Unit:@"kcal" WithFont:18];
//    
//    CGFloat kcalLabelX = CurrentDeviceWidth / 3;
//    CGFloat kcalLabelY = CGRectGetMaxY(imageView.frame);
//    CGFloat kcalLabelW =  CurrentDeviceWidth / 3;
//    CGFloat kcalLabelH =  barView.frame.size.height - CGRectGetMaxY(imageView.frame);
//    kcalLabel.frame =  CGRectMake(kcalLabelX, kcalLabelY, kcalLabelW, kcalLabelH);
//}
//-(void)setupCustViewBpm:(UIView *)barView
//{
//    UIImageView *imageView = [[UIImageView alloc]init];
//    [barView addSubview:imageView];
//    
//    CGFloat imageViewX = 0;
//    CGFloat imageViewY = 0;
//    CGFloat imageViewW = 35 * CurrentDeviceWidth/375;
//    CGFloat imageViewH = 35 * CurrentDeviceHeight/667;
//    imageView.image = [UIImage imageNamed:@"心率"];
//    imageView.frame =  CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
//    imageView.centerX = CurrentDeviceWidth / 6 * 5;
//    
//    UILabel *bpmLabel = [[UILabel alloc]init];
//    [barView addSubview:bpmLabel];
//    _bpmLabel = bpmLabel;
//    bpmLabel.textAlignment =NSTextAlignmentCenter;
//    bpmLabel.attributedText = [self makeAttributedStringWithnumBer:@"0" Unit:@"bpm" WithFont:18];
//    
//    CGFloat bpmLabelX = CurrentDeviceWidth / 3 * 2;
//    CGFloat bpmLabelY = CGRectGetMaxY(imageView.frame);
//    CGFloat bpmLabelW =  CurrentDeviceWidth / 3;
//    CGFloat bpmLabelH =  barView.frame.size.height - CGRectGetMaxY(imageView.frame);
//    bpmLabel.frame =  CGRectMake(bpmLabelX, bpmLabelY, bpmLabelW, bpmLabelH);
//    
//    
//}
//
//#pragma mark - 弹出HUD
//- (void)addActityTextInView : (UIView *)view text : (NSString *)textString deleyTime : (float)times {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    // Configure for text only and offset down
//    hud.mode = MBProgressHUDModeText;
//    //    hud.labelText = textString ;
//    hud.label.text = textString;
//    hud.margin = 10.f;
//    //    	hud.yOffset = 150.f;
//    hud.removeFromSuperViewOnHide = YES;
//    hud.square = YES;
//    //    [hud hide:YES afterDelay:times];
//    [hud hideAnimated:YES afterDelay:times];
//}
//#pragma mark --  alertView
//-(void)refreshAlertView
//{
//    //记录定时器40秒后，连接了吗
//    if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
//    {
//        CGFloat connectViewX = 0 ;
//        CGFloat connectViewW = CurrentDeviceWidth;
//        //CGFloat connectViewH = 50*HeightProportion;
//        CGFloat connectViewY = - connectViewH;
//        UIView *connectView = [[UIView alloc]initWithFrame:CGRectMake(connectViewX, connectViewY, connectViewW, connectViewH)];
//        _connectView = connectView;
//        //    [self.view addSubview:connectView];
//        connectView.backgroundColor = [UIColor clearColor];
//        //    [[UIApplication sharedApplication].keyWindow addSubview:connectView];
//        //        connectView.tag = NavsubTag;
//        //        [self.tabBarController.view addSubview:connectView];
//        [self.view addSubview:connectView];
//        
//        CGFloat connectLabelW = 30*WidthProportion;
//        CGFloat connectLabelH = 30*HeightProportion;
//        CGFloat connectLabelY = (connectViewH - connectLabelH)/2;
//        CGFloat connectLabelX = (connectViewW - connectLabelW)/2;
//        
//        UILabel *connectLabel = [[UILabel alloc]init];
//        [connectView addSubview:connectLabel];
//        connectLabel.backgroundColor = [UIColor clearColor];
//        if ([HCHCommonManager getInstance].BlueToothState!=CBManagerStatePoweredOn)
//        {
//            connectLabel.text = NSLocalizedString(@"请打开蓝牙",nil);}
//        else
//        {connectLabel.text = NSLocalizedString(@"连接中...", nil);}
//        [connectLabel sizeToFit];
//        connectLabelW = connectLabel.width;
//        connectLabelX = (connectViewW - connectLabelW)/2;
//        connectLabel.frame=CGRectMake(connectLabelX, connectLabelY, connectLabelW, connectLabelH);
//        
//        
//        [UIView animateWithDuration:0.2f animations:^{
//            connectView.frame = CGRectMake(connectViewX,54, connectViewW, connectViewH);
//        }];
//    }
//}
//#pragma mark --  代理。监测连接状态
//- (void)BlueToothIsConnected:(BOOL)isconnected
//{
//    if (isconnected)
//    {
//        //        [self performSelector:@selector(submitIsConnect) withObject:nil afterDelay:2.0f];
//    }
//}
////-(void)submitIsConnect
////{
////    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(submitIsConnect) object:nil];
////    CGFloat connectViewX = 0 ;
////    CGFloat connectViewW = CurrentDeviceWidth;
////    //CGFloat connectViewH = 50*HeightProportion;
////    CGFloat connectViewY = - connectViewH;
////
////    [UIView animateWithDuration:1.0f animations:^{
////        _connectView.frame = CGRectMake(connectViewX, connectViewY, connectViewW, connectViewH);
////        //self.backScrollView.frame = CGRectMake(0,64, CurrentDeviceWidth,CurrentDeviceHeight - 64- 48);
////    }];
////}
//#pragma mark    -- SportModelTableViewControllerDelegate       代理
//
//-(void)callbackSelected:(int)sportType  andSportModel:(SportModel *)sport  andSportName:(NSString *)SportName
//{
//    
//    if (sportType >= 100)
//    {
//        //        self.view.userInteractionEnabled = NO;
//        //        _startButton.enabled = NO;
//        self.sportType = sportType;
//        self.sportName = SportName;
//        
//        [self.timeViewButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        self.timeViewButton.layer.borderColor = [UIColor redColor].CGColor;
//        [self.timeViewButton setTitle:@"End" forState:UIControlStateNormal];
//        [self.timeViewButton setImage:nil forState:UIControlStateNormal];
//        [self.timeViewButton setAttributedTitle:nil forState:UIControlStateNormal];
//        _startLabel.hidden = YES;
//        _startImageView.hidden = YES;
//        
//        //累计时间
//        UILabel *timingLabel = [[UILabel alloc]init];
//        _timingLabel =timingLabel;
//        
//        timingLabel.textAlignment = NSTextAlignmentCenter;
//        [self.yuanImageView addSubview:timingLabel];
//        CGFloat timingLabelX =0;
//        CGFloat timingLabelW = self.yuanImageView.bounds.size.width * 2 /3;
//        CGFloat timingLabelH = 30;
//        CGFloat timingLabelY =self.yuanImageView.centerY - 1.5 * timingLabelH;
//        timingLabel.frame = CGRectMake(timingLabelX, timingLabelY, timingLabelW, timingLabelH);
//        
//        timingLabel.sd_layout.centerXEqualToView(self.yuanImageView);
//        timingLabel.text = @"00:00:00";//self.pickerViewHour
//        
//        //转化为秒数
//        [self  targetTimeToSecond];
//        //保存时期和 运动时间
//        [self  saveTarget];
//        timingLabel.font = [UIFont systemFontOfSize:18];
//        //暂停按钮的标记
//        UIButton *pauseButton = [[UIButton alloc]init];
//        _pauseButton=pauseButton;
//        
//        [self.yuanImageView addSubview:pauseButton];
//        [pauseButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
//        _pauseButton.tag = 600;
//        
//        CGFloat pauseButtonX =0;
//        CGFloat pauseButtonW = self.yuanImageView.bounds.size.width / 4;
//        CGFloat pauseButtonH = timingLabelH;
//        CGFloat pauseButtonY =CGRectGetMaxY(timingLabel.frame);
//        pauseButton.frame = CGRectMake(pauseButtonX, pauseButtonY, pauseButtonW, pauseButtonH);
//        pauseButton.sd_layout.centerXEqualToView(timingLabel);
//        
//        
//        CGFloat  spX = 0;
//        CGFloat  spY = 0;
//        CGFloat  spW = _yuanImageView.width;//182;
//        CGFloat  spH = _yuanImageView.height;//167;
//        sportView *sp= [[sportView alloc]initWithFrame:CGRectMake(spX, spY,spW, spH)];
//        _sp = sp;
//        sp.backgroundColor =  [UIColor clearColor];
//        [_yuanImageView addSubview:sp];
//        [_yuanImageView sendSubviewToBack:sp];
//        sp.minValue = 0;
//        sp.maxValue = _targetSecond;
//        _progress = 0;
//        sp.progress = _progress;
//        _yuanImageView.image = nil;
//        
//        [_yuanImageView bringSubviewToFront:_startButton];
//        //对蓝牙打开开关。
//        if ([CositeaBlueTooth sharedInstance].isConnected)
//        {
//            WeakSelf
//            [[CositeaBlueTooth sharedInstance] openHeartRate:^(BOOL flag) {
//                //adaLog(@" 在线运动， 开启成功   flag = = %d",flag);
//                [weakSelf  startRefreshUPView];
//            }];
//        }
//        else
//        {[self addActityTextInView:self.view text:NSLocalizedString(@"手环未连接", nil) deleyTime:2.];
//        }
//    }
//    else
//    {
//        TodaySportDetailViewController *detail = [[TodaySportDetailViewController alloc]init];
//        //        [self presentViewController:detail animated:YES completion:nil];
//        [detail setHidesBottomBarWhenPushed:YES];
//        detail.navigationController.navigationBar.hidden = YES;
//        [self.navigationController pushViewController:detail animated:YES];
//        detail.sport = sport;
//    }
//}
//
//
//
//
////下层的tableview
//-(void)setupDownView:(UIScrollView *)scrollView
//{
//    UIView *downView = [[UIView alloc]init];
//    [scrollView addSubview:downView];
//    
//    downView.backgroundColor = [UIColor orangeColor];
//    CGFloat downViewX = leadingSpace;
//    CGFloat downViewY = (CurrentDeviceHeight - 64 - 49) * 0.5 + upDownMargin;
//    CGFloat downViewW = CurrentDeviceWidth - 10;
//    CGFloat downViewH = (CurrentDeviceHeight - 64 - 49) * 0.5 - upDownMargin;
//    downView.frame = CGRectMake(downViewX, downViewY, downViewW, downViewH);
//    //adaLog(@"frame = %@",NSStringFromCGRect(downView.frame));
//    
//    UITableView *sportTabelView = [[UITableView alloc]init];
//    [downView addSubview:sportTabelView];
//    sportTabelView.delegate = self;
//    sportTabelView.dataSource = self;
//    
//    sportTabelView.separatorStyle = NO;
//    
//    CGFloat sportTabelViewX = 0;
//    CGFloat sportTabelViewY = 0;
//    CGFloat sportTabelViewW = downViewW;
//    CGFloat sportTabelViewH = downViewH;
//    sportTabelView.frame = CGRectMake(sportTabelViewX, sportTabelViewY, sportTabelViewW, sportTabelViewH);
//    self.sportTabelView = sportTabelView;
//    sportTabelView.tableFooterView = [[UIView alloc]init];
//    _sportArray = [NSMutableArray array];
//    ////adaLog(@"hehe == %02ld",[[SQLdataManger getInstance] queryHeartRateDataWithAll]);
//    
//    //    NSString *currentDateStr = [[[NSDate alloc]init] GetCurrentDateStr];
//    
//    //    NSArray *array = [[SQLdataManger getInstance]queryHeartRateDataWithDate:currentDateStr];
//    //    _sportArray = [NSMutableArray arrayWithArray:array];
//    //    _sportArray = [self sortSport:_sportArray];
//}
//#pragma mark  --  刷新数据
//- (void)reloadBlueToothData
//{
//    if ([CositeaBlueTooth sharedInstance].isConnected)
//    {
//        WeakSelf;
//        [[PZBlueToothManager sharedInstance] chekCurDayAllDataWithBlock:^(NSDictionary *dic) {
//            if (![weakSelf isToday])
//            {
//                return;
//            }
//            //            [weakSelf upDataUIWithDic:dic];
//        }];
//    }
//}
//
////返回目标时间
//-(NSAttributedString *)getAttributedText:(CGFloat)font
//{
//    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]init];
//    if(![self.pickerViewHour isEqualToString:@"00"])
//    {
//        NSMutableAttributedString *hour =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%02ldH",[self.pickerViewHour integerValue]]];
//        [hour addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, hour.length - 1)];
//        [hour addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font/2] range:NSMakeRange(hour.length - 1,1)];
//        [attributedText appendAttributedString:hour];
//        //adaLog(@"hour == %@",hour.string);
//    }
//    
//    if(![self.pickerViewMinute isEqualToString:@"00"])
//    {
//        NSMutableAttributedString *minute =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%02ldmin",[self.pickerViewMinute integerValue]]];
//        [minute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, minute.length - 3)];
//        [minute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font/2] range:NSMakeRange(minute.length - 3,3)];
//        [attributedText appendAttributedString:minute];
//        //adaLog(@"minute == %@",minute.string);
//    }
//    return attributedText;
//}
//
//#pragma mark  --  工具方法
////获取属性字符串
//- (NSMutableAttributedString *)makeAttributedStringWithnumBer:(NSString *)string Unit:(NSString *)unit WithFont:(int)font
//{
//    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
//    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, attributeString.length)];
//    NSMutableAttributedString *unitString = [[NSMutableAttributedString alloc] initWithString:unit];
//    [unitString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font - 5] range:NSMakeRange(0, unitString.length)];
//    [attributeString appendAttributedString:unitString];
//    return attributeString;
//}
//#pragma mark  --  私有方法
//
////开始运动的事件 .. 运动类型
//-(void)startSportLoad:(UIButton *)sender
//{
//    _startButton.userInteractionEnabled = NO;
//    
//    if (self.sportType < 100)
//    {
//        if ([CositeaBlueTooth sharedInstance].isConnected)
//        {
//            //            WeakSelf;
//            [[PZBlueToothManager sharedInstance] checkVerSionWithBlock:^(int firstHardVersion, int secondHardVersion, int softVersion, int blueToothVersion) {
//                int8_t soft;
//                int8_t hard;
//                int8_t hardTwo;
//                int8_t blue;
//                BOOL isCan = YES;
//                if (secondHardVersion == 161616) {
//                    hard = [HCHCommonManager getInstance].curHardVersion;
//                    soft = [HCHCommonManager getInstance].softVersion;
//                    blue = [HCHCommonManager getInstance].blueVersion;
//                    isCan = [AllTool checkVersionWithHard:hard HardTwo:161616  Soft:soft Blue:blue];
//                }
//                else
//                {
//                    hard = [HCHCommonManager getInstance].curHardVersion;
//                    hardTwo = [HCHCommonManager getInstance].curHardVersionTwo;
//                    soft = [HCHCommonManager getInstance].softVersion;
//                    blue = [HCHCommonManager getInstance].blueVersion;
//                    isCan = [AllTool checkVersionWithHard:hard HardTwo:hardTwo Soft:soft Blue:blue];
//                }
//                if (!isCan) {
//                    //                    [self addActityTextInView:self.view text:NSLocalizedString(@"当前设备不支持此功能,请升级设备固件", nil) deleyTime:2.];
//                    self.alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"当前设备不支持此功能,请升级设备固件", nil) delegate:nil
//                                                  cancelButtonTitle:nil otherButtonTitles:nil];
//                    [self.alert show];
//                    [self performSelector:@selector(dimissAlert:) withObject:self.alert afterDelay:2.0];
//                    return;
//                }
//                else
//                {
//                    //adaLog(@"开始运动");
//                    SportModelTableViewController *sportTypeVC = [[SportModelTableViewController alloc]init];
//                    sportTypeVC.delegate = self;
//                    [sportTypeVC setHidesBottomBarWhenPushed:YES];
//                    sportTypeVC.navigationController.navigationBar.hidden = YES;
//                    [self.navigationController pushViewController:sportTypeVC animated:YES];
//                    //[self presentViewController:sportTypeVC animated:YES completion:nil];
//                    
//                }
//                
//            }];
//        }
//        else
//        {
//            [self addActityTextInView:self.view text:NSLocalizedString(@"手环未连接", nil) deleyTime:2.];
//        }
//    }
//    else
//    {
//        //adaLog(@"暂停。或从新开始");
//        if (_pauseButton.tag == 600) {
//            _pauseButton.tag = 60;
//            _pauseFlag = YES;
//            //关闭定时器
//            [self.timerGetheartRate setFireDate:[NSDate distantFuture]];
//            //            if (self.GetheartRateTimer) {
//            //                dispatch_suspend(self.GetheartRateTimer);
//            //            }
//            [_pauseButton setImage:[UIImage imageNamed:@"开始小"] forState:UIControlStateNormal];
//            
//        }
//        else
//        {
//            //开启定时器
//            [self.timerGetheartRate setFireDate:[NSDate distantPast]];
//            //            if (self.GetheartRateTimer) {
//            //                dispatch_resume(self.GetheartRateTimer); }
//            [_pauseButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
//            _pauseButton.tag = 600;
//        }
//    }
//    
//    //    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayed:) object:sender];
//    [self performSelector:@selector(delayed) withObject:nil afterDelay:2.0f];
//    
//}
//-(void)delayed
//{
//    _startButton.userInteractionEnabled = YES;
//    //     _startButton.enabled = YES;
//}
//
//-(void) dimissAlert:(UIAlertView *)alert {
//    if(alert)
//    {
//        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
//    }
//}
////选择目标运动的时间
//-(void)timeTarget
//{
//    if (self.sportType < 100)
//    {
//        //adaLog(@"选择运动时间");
//        if (_SubBackView == nil) [self setPickerViewTwo];
//    }
//    else
//    {
//        //        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayed:) object:nil];
//        if(!_pauseFlag)
//        {
//            [self.timerGetheartRate setFireDate:[NSDate distantFuture]];
//            _pauseFlag = YES;
//            // if (self.GetheartRateTimer) {
//            // dispatch_suspend(self.GetheartRateTimer);}
//        }
//        
//        [self allRestore]; //回到原来的样子
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"是否保存数据", nil) preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"否", nil)  style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            //adaLog(@"取消保存");
//            [self saveAndNotsave];
//        }];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"是", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self storage];//保存数据
//            //            [self allRestore];//回到原来的样子
//            
//        }];
//        [alertController addAction:cancelAction];
//        [alertController addAction:okAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//        
//        [[CositeaBlueTooth sharedInstance] closeHeartRate:^(int number) {
//            if (number)   //adaLog(@"  成功关闭在线运动 number  - -  %d",number);
//        }];
//    }
//}
//-(void)storage
//{
//    
//    
//    NSMutableDictionary *dictionary  =[NSMutableDictionary dictionary];
//    NSInteger  count= [[SQLdataManger getInstance] queryHeartRateDataWithAll];
//    if (count>0)
//        [dictionary setValue:[NSString stringWithFormat:@"%02ld",count] forKey:@"sportID"];
//    else
//        [dictionary setValue:@"0" forKey:@"sportID"];
//    //    NSString *step = [_stepLabel.attributedText attributedSubstringFromRange:NSMakeRange(0, _stepLabel.attributedText.length - 5)].string;
//    //    NSString *kcal = [_kcalLabel.attributedText attributedSubstringFromRange:NSMakeRange(0, _kcalLabel.attributedText.length - 4)].string;
//    NSString *step = [NSString stringWithFormat:@"%ld",_stepNumberPlus];
//    NSString *kcal = [NSString stringWithFormat:@"%ld",_kcalNumberPlus];
//    NSData *heartData = [NSKeyedArchiver archivedDataWithRootObject:[AllTool seconedTominute:_heartArray]];//在线运动的心率转到分钟再存储。
//    [dictionary setValue:[[HCHCommonManager getInstance]UserAcount] forKey:CurrentUserName_HCH];
//    [dictionary setValue:[NSString stringWithFormat:@"%d",self.sportType] forKey:@"sportType"];
//    [dictionary setValue:self.sportName forKey:@"sportName"];
//    [dictionary setValue:_sportDate forKey:@"sportDate"];
//    [dictionary setValue:_fromTime forKey:@"fromTime"];
//    
//    //     //adaLog(@"self.sportType = %d",self.sportType);
//    NSString *toActualTime = [[[NSDate alloc]init] dateWithYMDHMS];//[self getToActualTime];
//    _toTime = toActualTime;
//    [dictionary setValue:_toTime forKey:@"toTime"];
//    [dictionary setValue:step forKey:@"stepNumber"];
//    [dictionary setValue:kcal forKey:@"kcalNumber"];
//    [dictionary setValue:heartData forKey:@"heartRate"];
//    NSString *deviceType =  [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
//    NSString *deviceId = [AllTool amendMacAddressGetAddress];
//    
//    //    NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
//    //    if (!deviceId) {
//    //        deviceId =  DEFAULTDEVICEID;
//    //    }
//    [dictionary setValue:deviceId forKey:DEVICEID];
//    [dictionary setValue:deviceType forKey:DEVICETYPE];
//    [dictionary setValue:@"0" forKey:ISUP];
//    SportModel *sportNow = [SportModel setValueWithDictionary:dictionary];
//    TodaySportDetailViewController *detail = [[TodaySportDetailViewController alloc]init];
//    //    [self presentViewController:detail animated:YES completion:nil];
//    [detail setHidesBottomBarWhenPushed:YES];
//    detail.navigationController.navigationBar.hidden = YES;
//    [self.navigationController pushViewController:detail animated:YES];
//    if (sportNow) {
//        detail.sport = sportNow;
//    }
//    [_heartArray removeAllObjects];
//    [[SQLdataManger getInstance] insertDataWithColumns:dictionary toTableName:@"ONLINESPORT"];
//    
//    //刷新tableview
//    [self  reloadDataALL];
//    //adaLog(@"保存数据");
//    //用后，归零
//    [self saveAndNotsave];
//}
//-(void)saveAndNotsave
//{
//    _stepNumberPlus = 0;
//    _kcalNumberPlus = 0;
//    self.sportType =  0;
//    self.sportName = @"";
//    
//}
//-(void)allRestore
//{
//    //    //adaLog(@"_pauseFlag = %@",[NSString stringWithFormat:@"%d",_pauseFlag]);
//    //    if (_pauseFlag) {
//    //        if (self.GetheartRateTimer) {
//    //            dispatch_resume(self.GetheartRateTimer);
//    //            dispatch_cancel(self.GetheartRateTimer);
//    //            if(self.GetheartRateTimer)
//    //            {self.GetheartRateTimer = nil;}
//    //        }
//    //    } else {
//    //        if (self.GetheartRateTimer) {
//    //            dispatch_cancel(self.GetheartRateTimer);
//    //            if(self.GetheartRateTimer)
//    //            {self.GetheartRateTimer = nil;
//    //            }
//    //
//    //        }
//    //    }
//    
//    if (self.timerGetheartRate.isValid) {
//        [self.timerGetheartRate invalidate];
//        self.timerGetheartRate = nil;
//    }
//    
//    
//    //    self.sportType = 0;
//    _progress = 0;
//    _initialSport = nil;
//    _bpmLabel.attributedText = [self makeAttributedStringWithnumBer:@"0" Unit:@"bpm" WithFont:18];
//    _stepLabel.attributedText = [self makeAttributedStringWithnumBer:@"0" Unit:@"steps" WithFont:18];
//    _kcalLabel.attributedText = [self makeAttributedStringWithnumBer:@"0" Unit:@"kcal" WithFont:18];
//    //    [self.timeViewButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    //    self.timeViewButton.layer.borderColor = [UIColor redColor].CGColor;
//    [self.timeViewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.timeViewButton.titleLabel.textColor = [UIColor blackColor];
//    self.timeViewButton.layer.borderColor = [UIColor blackColor].CGColor;
//    
//    [_timeViewButton setImage:[UIImage imageNamed:@"目标"] forState:UIControlStateNormal];
//    self.pickerViewHour = @"00";
//    self.pickerViewMinute = @"30";
//    
//    
//    //返回目标时间
//    [_timeViewButton setAttributedTitle:[self getAttributedText:18] forState:UIControlStateNormal];
//    [self.timeViewButton setImage:[UIImage imageNamed:@"目标"] forState:UIControlStateNormal];
//    
//    _startLabel.hidden = NO;
//    _startImageView.hidden = NO;
//    
//    _timingLabel.hidden = YES;
//    _pauseButton.hidden = YES;
//    [_timeLabel removeFromSuperview];
//    _timeLabel  = nil;
//    [_pauseButton removeFromSuperview];
//    _pauseButton  = nil;
//    
//    
//    if(_sp)
//    {
//        _sp.hidden = YES;
//        [_sp removeFromSuperview];
//        _sp = nil;
//    }
//    //    _yuanImageView.hidden = NO;
//    _yuanImageView.backgroundColor = [UIColor clearColor];
//    _yuanImageView.image = [UIImage imageNamed:@"111"];
//    //    if (!self.GetheartRateTimer)
//    //    { _pauseFlag = NO; }
//    _pauseFlag = NO;
//    
//}
////开始刷新界面
//-(void)startRefreshUPView
//{
//    //对蓝牙打开开关。 定时取数
//    if ([CositeaBlueTooth sharedInstance].isConnected)
//    {
//        self.timerGetheartRate = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//        //        [[NSRunLoop currentRunLoop] run];
//        //获得队列
//        //        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//        //创建一个定时器
//        //        if(!self.GetheartRateTimer)
//        //        {
//        //        self.GetheartRateTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//        //        }
//        //
//        //        //设置开始时间
//        //        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
//        //        //设置时间间隔
//        //        uint64_t interval = (uint64_t)(1.0* NSEC_PER_SEC);
//        //        //设置定时器
//        //        dispatch_source_set_timer(self.GetheartRateTimer, start, interval, 0);
//        //        //设置回调
//        //        WeakSelf;
//        //        dispatch_source_set_event_handler(self.GetheartRateTimer, ^{
//        //            dispatch_sync(dispatch_get_main_queue(), ^{
//        //                [weakSelf timerAction];
//        //            });
//        //        });
//        //        if(self.GetheartRateTimer)
//        //        {
//        //           dispatch_resume(self.GetheartRateTimer);
//        //        }
//        //
//    }
//    
//}
////定时器对蓝牙索取数据
//-(void)timerAction
//{
//    //对蓝牙打开开关。
//    if ([CositeaBlueTooth sharedInstance].isConnected)
//    {
//        WeakSelf
//        [[CositeaBlueTooth sharedInstance] timerGetHeartRateData:^(SportModel *sport) {
//            //            //adaLog(@"sport ==      -      -------- %@",sport);
//            [weakSelf RefreshUPView:sport];
//        }];
//    }
//    _progress++;
//    _sp.progress = _progress;
//    if (_targetSecond > 0) {
//        _timingLabel.text =  [self getTimingLabelText];
//    }
//    else
//    {
//        _timingLabel.text = @"00:00:00";
//    }
//}
//-(void)RefreshUPView:(SportModel *)sport
//{
//    if(!_initialSport){
//        _initialSport = sport;
//        return;
//    }
//    if (_pauseFlag)
//    {    _realtimeSport = sport;
//        _pauseFlag = !_pauseFlag;
//    }
//    else
//    {
//        if (_realtimeSport) {
//            
//            NSInteger stepNum  = [_initialSport.stepNumber integerValue] + [sport.stepNumber integerValue]  - [_realtimeSport.stepNumber integerValue];
//            _initialSport.stepNumber = [NSString stringWithFormat:@"%ld",stepNum];
//            NSInteger mileage  = [_initialSport.mileageNumber integerValue] + [sport.mileageNumber integerValue] - [_realtimeSport.mileageNumber integerValue];
//            _initialSport.mileageNumber = [NSString stringWithFormat:@"%ld",mileage];
//            NSInteger kcal  = [_initialSport.kcalNumber integerValue] + [sport.kcalNumber integerValue] - [_realtimeSport.kcalNumber integerValue];
//            _initialSport.kcalNumber = [NSString stringWithFormat:@"%ld",kcal];
//            _realtimeSport = nil;
//        }
//    }
//    
//    
//    _stepNumberPlus = [sport.stepNumber integerValue]- [self.initialSport.stepNumber integerValue];
//    _kcalNumberPlus = [sport.kcalNumber integerValue] - [self.initialSport.kcalNumber integerValue];
//    _heartRateNumberPlus = [sport.heartRate integerValue];
//    if (_stepNumberPlus <=0)
//    {
//        _initialSport.stepNumber =[NSString stringWithFormat:@"%ld",([_initialSport.stepNumber integerValue] - labs(_stepNumberPlus))];
//        
//    }
//    if( _kcalNumberPlus <= 0)
//    {
//        
//        _initialSport.kcalNumber =[NSString stringWithFormat:@"%ld",([_initialSport.kcalNumber integerValue] - labs(_kcalNumberPlus))];
//    }
//    
//    NSString * stepNumber = [NSString stringWithFormat:@"%ld",_stepNumberPlus];
//    NSString * kcalNumber = [NSString stringWithFormat:@"%ld",_kcalNumberPlus];
//    NSString * heartRate = [NSString stringWithFormat:@"%ld",_heartRateNumberPlus];
//    [_heartArray addObject:sport.heartRate];
//    
//    _stepLabel.attributedText = [self makeAttributedStringWithnumBer:stepNumber Unit:@"steps" WithFont:18];
//    _kcalLabel.attributedText = [self makeAttributedStringWithnumBer:kcalNumber Unit:@"kcal" WithFont:18];
//    _bpmLabel.attributedText = [self makeAttributedStringWithnumBer:heartRate Unit:@"bpm" WithFont:18];
//    
//    _timingLabel.text = [self getTimingLabelText];
//    
//}
//
//#pragma mark  --  UIDatePicker --
//- (void)setPickerViewTwo
//{
//    [self.view endEditing:YES];
//    _SubBackView = [[UIButton alloc] initWithFrame:CurrentDeviceBounds];
//    _SubBackView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:_SubBackView];
//    [_SubBackView addTarget:self action:@selector(dateSureClickTwo) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    _SubAnimationView  = [[UIView alloc] initWithFrame:CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, UIPickerViewHeight)];
//    [_SubBackView addSubview:_SubAnimationView];
//    _SubAnimationView.backgroundColor = [UIColor whiteColor];
//    
//    //弹出的pickerView
//    CGFloat pickerViewX = 0;
//    CGFloat pickerViewY = 50;
//    CGFloat pickerViewW = CurrentDeviceWidth;
//    CGFloat pickerViewH = UIPickerViewHeight - pickerViewY;
//    
//    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(pickerViewX,pickerViewY, pickerViewW, pickerViewH)];
//    [_SubAnimationView addSubview:self.pickerView];
//    //设置选择器的水平的阴影效果
//    self.pickerView.showsSelectionIndicator = YES;
//    
//    self.pickerView.backgroundColor = [UIColor whiteColor];
//    self.pickerView.delegate = self;
//    self.pickerView.dataSource = self;
//    [_SubAnimationView addSubview:self.pickerView];
//    [self.pickerView reloadAllComponents];//刷新UIPickerView
//    
//    UILabel * hourLabel = [[UILabel alloc]init];
//    [self.pickerView addSubview:hourLabel];
//    hourLabel.text = @"h";
//    hourLabel.backgroundColor = [UIColor clearColor];
//    CGFloat hourLabelX = CurrentDeviceWidth / 3;
//    CGFloat hourLabelW = CurrentDeviceWidth / 4;
//    CGFloat hourLabelH = 25;
//    CGFloat hourLabelY = pickerViewH/ 2 - hourLabelH * 0.7;
//    hourLabel.frame = CGRectMake(hourLabelX, hourLabelY, hourLabelW, hourLabelH);
//    
//    UILabel * minuteLabel = [[UILabel alloc]init];
//    [self.pickerView addSubview:minuteLabel];
//    minuteLabel.text = @"min";
//    minuteLabel.backgroundColor = [UIColor clearColor];
//    CGFloat minuteLabelX = CurrentDeviceWidth / 3 * 2;
//    CGFloat minuteLabelW = CurrentDeviceWidth / 4;
//    CGFloat minuteLabelH = hourLabelH;
//    CGFloat minuteLabelY = pickerViewH/ 2 - minuteLabelH * 0.7;
//    minuteLabel.frame = CGRectMake(minuteLabelX, minuteLabelY, minuteLabelW, minuteLabelH);
//    NSInteger row1 = 0;
//    NSInteger row2 = 0;
//    if(!_timeLabel.attributedText)
//    {
//        row1 = self.hourArray.count/2 + [self.pickerViewHour integerValue];
//        row2 = self.minuteArray.count/2 + [self.pickerViewMinute integerValue];
//    }
//    else
//    {
//        row1 = self.hourArray.count/2;
//        row2 = self.minuteArray.count/2;
//    }
//    [self.pickerView selectRow:row1 inComponent:0 animated:NO];
//    [self.pickerView selectRow:row2 inComponent:1 animated:NO];
//    
//    //右上角的选择按钮
//    UIView *buttonView = [[UIView alloc] init];
//    [_SubAnimationView addSubview:buttonView];
//    CGFloat buttonViewX = 50;
//    CGFloat buttonViewY = 50;
//    buttonView.sd_layout
//    .topSpaceToView(_SubAnimationView,10)
//    .rightSpaceToView(_SubAnimationView,10)
//    .heightIs(buttonViewX)
//    .widthIs(buttonViewY);
//    
//    UIImageView *btnImageView = [[UIImageView alloc] init];
//    btnImageView.image = [UIImage imageNamed:@"xuanze"];
//    [buttonView addSubview:btnImageView];
//    btnImageView.userInteractionEnabled = YES;
//    
//    btnImageView.sd_layout
//    .topSpaceToView(buttonView,0)
//    .rightSpaceToView(buttonView,10)
//    .heightIs(buttonViewX - 20)
//    .widthIs(buttonViewY - 20);
//    
//    
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [buttonView addSubview:button];
//    button.backgroundColor = [UIColor clearColor];
//    [button addTarget:self action:@selector(dateSureClickTwo) forControlEvents:UIControlEventTouchUpInside];
//    button.sd_layout
//    .topSpaceToView(buttonView,0)
//    .rightSpaceToView(buttonView,0)
//    .heightIs(buttonViewX)
//    .widthIs(buttonViewY);
//    
//    
//    
//    [UIView animateWithDuration:0.23 animations:^{
//        _SubBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//        _SubAnimationView.frame = CGRectMake(0, CurrentDeviceHeight - UIPickerViewHeight - 49,CurrentDeviceWidth, UIPickerViewHeight);
//    }];
//    
//}
//
//
//
//- (void)dateSureClickTwo
//{
//    
//    
//    //    NSDate *pickDate = _SubDatePicker.date;
//    //    NSDateFormatter *formates = [[NSDateFormatter alloc]init];
//    //    [formates setDateFormat:@"HH:mm"];
//    //
//    //    NSString *dayString = [formates stringFromDate:pickDate];
//    ////    //adaLog(@"dayString = %@",dayString);
//    //    if (dayString) {
//    //        NSString *hour = [dayString substringToIndex:2];
//    //        //adaLog(@"截取的值为：%@",hour);
//    //        NSString *minute = [dayString substringFromIndex:3];
//    //        //adaLog(@"截取的值为：%@",minute);
//    //    }
//    //    self.targetLabel.hidden = YES;
//    [self.timeViewButton setAttributedTitle:[self getAttributedText:18] forState:UIControlStateNormal];
//    
//    [self hiddenPickerView];
//    
//}
//
//
//- (void)hiddenPickerView
//{
//    [UIView animateWithDuration:0.23 animations:^{
//        _SubAnimationView.frame = CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, UIPickerViewHeight);
//        _SubBackView.frame = CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, UIPickerViewHeight);
//    } completion:^(BOOL finished) {
//        [self.pickerView removeFromSuperview];
//        self.pickerView = nil;
//        [_SubAnimationView removeFromSuperview];
//        _SubAnimationView = nil;
//        [_SubBackView removeFromSuperview];
//        _SubBackView = nil;
//        
//    }];
//}
////转化为秒数.用于倒计时
//-(void)targetTimeToSecond
//{
//    _targetSecond = [self.pickerViewHour integerValue] * 3600 + [self.pickerViewMinute integerValue] * 60;
//}
//-(void)saveTarget
//{
//    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    //    NSDate *date = [NSDate date];
//    //    NSString *currentDateStr = [dateFormatter stringFromDate:date];
//    
//    NSString *currentDateStr = [[[NSDate alloc]init] dateWithYMDHMS];
//    _sportDate = [currentDateStr substringToIndex:10];
//    _fromTime = currentDateStr; //[currentDateStr substringFromIndex:(currentDateStr.length - 8)];
//    //    _toTime =[self getToTime];
//    
//}
//-(NSString *)getToTime
//{
//    NSString * time;
//    NSInteger hour;
//    NSInteger minute = [[_fromTime substringWithRange:NSMakeRange(3,2)] integerValue] + [_pickerViewMinute integerValue];
//    if (minute<60)
//    {
//        hour = [[_fromTime substringToIndex:2] integerValue] + [_pickerViewHour integerValue];
//    }
//    else
//    {
//        hour = [[_fromTime substringToIndex:2] integerValue] + [_pickerViewHour integerValue] + 1;
//        minute = minute - 60;
//    }
//    NSString * seconed = [_fromTime substringFromIndex:6];
//    time = [NSString stringWithFormat:@"%ld:%ld:%@",hour,minute,seconed];
//    //    //adaLog(@"hour = %ld",hour);
//    //    //adaLog(@"minute = %ld",minute);
//    //    //adaLog(@"seconed = %@",seconed);
//    return time;
//}
//-(NSString *)getToActualTime
//{
//    NSString *ToActualTime;
//    
//    //    if ()
//    //    {
//    NSInteger hour = 0;
//    NSInteger minute = 0;
//    NSInteger seconed = 0;
//    hour = _progress / 3600;
//    minute = _progress % 3600 / 60;
//    seconed = _progress % 60;
//    //adaLog(@"%@:%@:%@",[_fromTime substringToIndex:2],[_fromTime substringWithRange:NSMakeRange(_fromTime.length - 5, 2)],[_fromTime substringFromIndex:_fromTime.length - 2]);
//    hour += [[_fromTime substringToIndex:2] integerValue];
//    minute += [[_fromTime substringWithRange:NSMakeRange(_fromTime.length - 5, 2)] integerValue];
//    seconed += [[_fromTime substringFromIndex:_fromTime.length - 2] integerValue];
//    ToActualTime = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hour,minute,seconed];
//    //    }
//    //    else
//    //    {
//    //
//    //    }
//    
//    return ToActualTime;
//    
//}
//-(NSString *)getTimingLabelText
//{
//    NSString *targetString;
//    targetString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",_progress / 3600,_progress  % 3600 / 60 ,_progress % 60];
//    //adaLog(@"_progress =     - - %02ld",_progress);
//    return targetString;
//}
//
//#pragma mark   - - - 排序 各个运动
//-(NSMutableArray *)sortSport:(NSMutableArray *)array
//{
//    //    TimeCallManager * manager = [TimeCallManager getInstance];
//    //    NSTimeInterval one;
//    //    NSTimeInterval two;
//    //    NSString *format = @"yyyy-MM-dd HH:mm:ss";
//    for (NSInteger i = 0; i<array.count; i++) {
//        for (NSInteger j= i+1; j<array.count ; j++) {
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            NSDate *date1 = [formatter dateFromString:[(SportModel *)array[i] toTime]];
//            NSDate *date2 = [formatter dateFromString:[(SportModel *)array[j] toTime]];
//            NSTimeInterval aTimer = [date2 timeIntervalSinceDate:date1];
//            if (aTimer > 0) {
//                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
//            }
//        }
//    }
//    return array;
//}
//#pragma mark -   SportTableViewCellDelegate   delete   cell
//-(void)deleteSportWithID:(NSString *)sportID
//{
//    if (kHCH.networkStatus<=0)
//    {
//        [[TodayStepsViewController sharedInstance] remindNotReachable];
//        return;
//    }
//    if (sportID) {
//        for (int i=0; i<_sportArray.count; i++)
//        {
//            SportModel *model = (SportModel *)_sportArray[i];
//            if ([sportID isEqualToString:model.sportID])
//            {
//                NSString *deviceType = model.deviceType;
//                if (!deviceType) {
//                    deviceType = [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
//                }
//                __block  NSString *deviceId = model.deviceId;
//                if (deviceId) {
//                    
//                    deviceId = [AllTool macToMacString:deviceId];
//                }
//                else
//                {
//                    deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
//                }
//                int start=[[TimeCallManager getInstance] getSecondsWithTimeString:model.fromTime andFormat:@"yyyy-MM-dd HH:mm:ss"];
//                int end=[[TimeCallManager getInstance] getSecondsWithTimeString:model.toTime andFormat:@"yyyy-MM-dd HH:mm:ss"];
//                NSString *key =[NSString stringWithFormat:@"%d-%d",start,end];
//                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:deviceType,@"deviceType",deviceId,@"deviceId",model.sportDate,@"time",@"deleteOffline",@"dataType",key,@"uploadData",nil];
//                [[TimingUploadData sharedInstance] deleteSportDataWithDictionary:dict];
//            }
//        }
//        [[SQLdataManger getInstance]deleteDataWithColumns:@{@"sportID":sportID,CurrentUserName_HCH:[[HCHCommonManager getInstance]UserAcount]} fromTableName:@"ONLINESPORT"];
//        
//        //        NSString *currentDateStr = [[[NSDate alloc]init] GetCurrentDateStr];
//        //        NSArray *array = [[SQLdataManger getInstance]queryHeartRateDataWithDate:currentDateStr];
//        //        _sportArray = [NSMutableArray arrayWithArray:array];
//        //        _sportArray = [self sortSport:_sportArray];
//        //        [self.sportTabelView reloadData];
//    }
//    [self childrenTimeSecondChanged];
//}
//
//#pragma mark - pickerView Delegate DataSource
//
////返回有几列
//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 2;
//}
////返回指定列的行数
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    if(component==0){
//        
//        return  self.hourArray.count;
//    }
//    return self.minuteArray.count;
//}
////返回指定列，行的高度，就是自定义行的高度
//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
//    return 130.0f * HEIGHT_PROPORTION;
//}
////返回指定列的宽度
//- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
//    
//    //    //adaLog(@"CurrentDeviceWidth / 6 = %f",[UIScreen mainScreen].bounds.size.width / 6);
//    return  [UIScreen mainScreen].bounds.size.width / 3;
//}
//
//// 自定义指定列的每行的视图，即指定列的每行的视图行为一致
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    if (!view){
//        view = [[UIView alloc]init];
//    }
//    if(component == 0){
//        UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 20)];
//        text.textAlignment = NSTextAlignmentCenter;
//        text.text = [self.hourArray objectAtIndex:row];
//        [view addSubview:text];
//    }else{
//        
//        UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,80, 20)];
//        text.textAlignment = NSTextAlignmentCenter;
//        text.text = [self.minuteArray objectAtIndex:row];
//        [view addSubview:text];
//    }
//    
//    return view;
//}
////显示的标题
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    
//    //    if (component == 0) {
//    //        return     @"H";
//    //    } else if(component == 1){
//    //        return     @"min";
//    //
//    //    }
//    return @"H";
//}
////显示的标题字体、颜色等属性
//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    
//    if(component == 0){
//        NSString *str = self.hourArray[row];
//        NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:str];
//        [AttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:54 * ZITI_PROPORTION], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [AttributedString  length])];
//        
//        return AttributedString;
//    }
//    
//    NSString *str = self.minuteArray[row];
//    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:str];
//    [AttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:54 * ZITI_PROPORTION], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [AttributedString  length])];
//    
//    return AttributedString;
//}
//
////PickerView被选择的行
//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//    
//    if(component == 0){
//        self.pickerViewHour = [self.hourArray objectAtIndex:row];
//        //adaLog(@"hour  = %@",[self.hourArray objectAtIndex:row]);
//    }else if(component == 1){
//        self.pickerViewMinute = [self.minuteArray objectAtIndex:row];
//        //adaLog(@"minute  = %@",[self.minuteArray objectAtIndex:row]);
//    }
//    
//}
//
//#pragma mark  --  tableView -- delegate
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if(_sportArray.count <=0){
//        [self  addTwoFalseData];//添加假数据
//        return 2;
//    }
//    return _sportArray.count;
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    SportTableViewCell *cell = [SportTableViewCell cellWithTableView:tableView];
//    cell.delegate = self;
//    if (_sportArray.count > 0) {
//        SportModel *model = _sportArray[indexPath.row];
//        cell.sport = model;
//        cell.arrayIndex = (NSInteger)indexPath.row;
//    }
//    cell.backBlock = ^(int aa)
//    {
//        [self selectCell:aa];
//    };
//    
//    cell.backgroundColor = [UIColor whiteColor];
//    return cell;
//}
//-(void)selectCell:(int)row
//{
//    //adaLog(@"row == %d",row);
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//    [self tableView:self.sportTabelView didSelectRowAtIndexPath:indexPath];
//    
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //    if(indexPath.row == 0){
//    //        return 138;
//    //    }
//    return 138;
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.selected = NO;
//    SportModel * sportM = _sportArray[indexPath.row];
//    if([sportM.sportType integerValue] >=100)
//    {
//        TodaySportDetailViewController *detailView = [[TodaySportDetailViewController alloc]init];
//        //        [self presentViewController:detailView animated:YES completion:nil];
//        [detailView setHidesBottomBarWhenPushed:YES];
//        detailView.navigationController.navigationBar.hidden = YES;
//        if (sportM) {
//            detailView.sport = sportM;
//        }
//        [self.navigationController pushViewController:detailView animated:YES];
//        
//    }
//    else
//    {
//        SportModelTableViewController *sportTypeVC = [[SportModelTableViewController alloc]init];
//        //        sportTypeVC.delegate = self;
//        sportTypeVC.sport = sportM;
//        sportTypeVC.delegate = self;
//        //        [self presentViewController:sportTypeVC animated:YES completion:nil];
//        [sportTypeVC setHidesBottomBarWhenPushed:YES];
//        sportTypeVC.navigationController.navigationBar.hidden = YES;
//        [self.navigationController pushViewController:sportTypeVC animated:YES];
//        //        if (self.sportType < 100)
//        
//    }
//    
//    
//    
//}
//- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}
//-(void)dealloc
//{
//    if (self.timerGetheartRate.isValid) {
//        [self.timerGetheartRate invalidate];
//        self.timerGetheartRate = nil;
//    }
//    //    if (_pauseFlag) {
//    //        if (self.GetheartRateTimer) {
//    //            dispatch_resume(self.GetheartRateTimer);
//    //            dispatch_cancel(self.GetheartRateTimer);
//    //            if(self.GetheartRateTimer)
//    //            {self.GetheartRateTimer = nil;
//    //            }
//    //        }
//    //    } else {
//    //        if (self.GetheartRateTimer) {
//    //            dispatch_cancel(self.GetheartRateTimer);
//    //            if(self.GetheartRateTimer)
//    //            {self.GetheartRateTimer = nil;
//    //            }
//    //        }
//    //    }
//    
//    //adaLog(@"----------------dealloc");
//    
//}
//#pragma mark   -    懒加载
//
//-(NSArray *)hourArray
//{
//    if (!_hourArray) {
//        _hourArray = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
//    }
//    return _hourArray;
//}
//-(NSArray *)minuteArray
//{
//    if (!_minuteArray) {
//        _minuteArray = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
//    }
//    
//    return _minuteArray;
//}
//-(void)addTwoFalseData
//{
//    SportModel *sport1 = [[SportModel alloc]init];
//    NSString *currentDateStr = [[[NSDate alloc]init] GetCurrentDateStr];
//    
//    sport1.sportID = @"0";
//    sport1.sportType = @"100";
//    sport1.sportDate = currentDateStr;
//    sport1.fromTime = [NSString stringWithFormat:@"%@ 00:00:00",currentDateStr];
//    sport1.toTime =  [NSString stringWithFormat:@"%@ 00:00:00",currentDateStr];
//    sport1.stepNumber = @"0";
//    sport1.kcalNumber = @"0";
//    
//    SportModel *sport2 = [[SportModel alloc]init];
//    sport2.sportID = @"1";
//    sport2.sportType = @"102";
//    sport2.sportDate = currentDateStr;
//    sport2.fromTime = [NSString stringWithFormat:@"%@ 00:00:00",currentDateStr];
//    sport2.toTime =  [NSString stringWithFormat:@"%@ 00:00:00",currentDateStr];
//    sport2.stepNumber = @"0";
//    sport2.kcalNumber = @"0";
//    [_sportArray addObject:sport1];
//    [_sportArray addObject:sport2];
//}
//@end


#define TEXTCOLOR @"13ecf5"
#define DETAILTEXTSIZE 25*WidthProportion
#define QIANSPACE 10*WidthProportion
#define ZHONGSPACE 5*WidthProportion
#define SPORTTYPENUMBER  @"SPORTTYPENUMBER"
#define SPORTTYPETITLE  @"SPORTTYPETIME"

#define IMAGEstep @"Step_map"
#define IMAGEheartRate @"Heart_rate_map"
#define IMAGEMatch @"Match_map"
#define IMAGElicheng @"licheng_map"
#define IMAGEclock @"Clock_Map"

#define isZhHans [[[NSLocale preferredLanguages] firstObject] hasPrefix:@"zh-Hans"] //是中文为YES其他为NO

//1.key 2.图 - image 3.数值 - number 4.单位 - unit 5.名称 - name
//DICKEY  -- 1 - 时长- 2 - 计步- 3 - 心率- 4 - 配速- 5 - 里程
#define DICKEY @"key"
#define DICIMAGE @"image"
#define DICNUMBER @"number"
#define DICUNIT @"unit"
#define DICNAME @"name"
#define LATRANGE 0.005029
#define LONRANGE 0.003181

//spacing
#import "SportingMapViewController.h"
#import "CircleViewMap.h"
#import "ColorTool.h"
//导入定位和地图的两个框架
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "SportDetailMapViewController.h"
#import "SportModelMap.h"
#import "WGS84TOGCJ02.h"
#import <AVFoundation/AVFoundation.h>
#import "ZCChinaLocation.h"

//签订定位和地图的代理协议
@interface SportingMapViewController ()<CLLocationManagerDelegate,MKMapViewDelegate,AVAudioPlayerDelegate>

@property (nonatomic, strong) UIView *timerView;         //全部颜色的背景
@property (nonatomic, strong) UILabel *speedLabel;       //速度
@property (nonatomic, strong) UILabel *mileageLabel;     //里程
@property (nonatomic, strong) UILabel *stepLabel;        //步数
@property (nonatomic, strong) UILabel *heartRateLabel;   //心率

@property (nonatomic, strong) UIImageView *speedImageView;       //速度  imageView
@property (nonatomic, strong) UIImageView *mileageImageView;     //里程  imageView
@property (nonatomic, strong) UIImageView *stepImageView;        //步数  imageView
@property (nonatomic, strong) UIImageView *heartRateImageView;   //心率  imageView
@property (nonatomic, strong) NSTimer *time;               //按钮动画的定时器

//运动时的按钮
@property (nonatomic, strong) UIImageView *btnImage;      //按钮的图片
@property (nonatomic, strong) UIButton *btning;           //按钮的点击效果
@property (nonatomic, strong) UIScrollView *scrollView;  //滚动的view；
//@property (nonatomic,strong) BMKMapView *mapView;           //百度地图
@property (nonatomic, strong) CircleViewMap *btnCircle;   //按钮旁边的圆圈

//@property (nonatomic,strong) BMKLocationService* locService;   //定位服务
//@property (nonatomic,assign)  CLLocationCoordinate2D coor;  /** 记录上一次的位置 */
@property (nonatomic, strong) NSMutableArray *sportNodeArray;    /** 位置数组 */
//@property (nonatomic,strong) BMKPolyline *polyLine; /** 轨迹线 */

//逻辑的添加
@property (strong, nonatomic) NSString *sportDate;  //保存运动时间
@property (strong, nonatomic) NSString *fromTime;   //保存运动时间
@property (strong, nonatomic) NSString *toTime; //保存运动时间
@property (strong, nonatomic) NSTimer *timerGetheartRate;   //定时获取实时数据
@property (assign, nonatomic) NSInteger progress;   //秒数的正数，进度
@property (assign, nonatomic) NSInteger proWarpLoc;  //记录进度，每隔五秒就定位到用户位置一次

@property (assign, nonatomic) UILabel *timeLabel;   //显示时长的label     大标题的数字
@property (assign, nonatomic) UILabel *timeUnitLabel;   //显示时长的label 的名称  大标题的名称
@property (strong, nonatomic) SportModelMap *initialSport; //在线运动。开始的数据
@property (assign,nonatomic) BOOL pauseFlag;    //用于暂停的计算
@property (strong,nonatomic) SportModelMap *realtimeSport; //实时运动。开始的数据

@property (assign,nonatomic) NSInteger  stepNumberPlus;     //用于保存步数
@property (assign,nonatomic) NSInteger  kcalNumberPlus;   //用于保存kcal
@property (assign,nonatomic) NSInteger  heartRateNumberPlus;    //用于保存heartRate
@property (assign,nonatomic) NSInteger  mileageNumberPlus;  //用于保存heartRate
@property (strong, nonatomic) NSString * avgPace;   //平均配速
//@property (assign,nonatomic) NSInteger  speedNumberPlus;    //用于保存步速
@property (strong, nonatomic) NSMutableArray *heartArray;   //心律数组。用于求平均值    又用于存储

@property (assign,nonatomic) CGFloat mapImageViewX; //地图按钮的坐标 x
@property (assign,nonatomic) CGFloat mapImageViewW; //地图按钮的坐标 w
@property (assign,nonatomic) CGFloat mapImageViewH; //地图按钮的坐标 h
@property (assign,nonatomic) CGFloat mapImageViewY; //地图按钮的坐标 y
@property (strong,nonatomic) UIView * viewMapPack;  //装地图的view

@property (strong,nonatomic) UIImageView *back;     //页面的背景图
@property (strong,nonatomic) UIImageView *suspendImage;      //暂停  的图
@property (strong,nonatomic) UIButton *suspendBtning;        //暂停  的按钮
@property (strong,nonatomic) UIImageView *ContinueImage;        //继续  的图
@property (strong,nonatomic) UIButton *ContinueBtning;      //继续  的按钮

//地图上的label   时长的label
@property (strong,nonatomic) UILabel *timelength;//时长
@property (strong,nonatomic) UILabel *downStepLabel;//步数
@property (strong,nonatomic) UILabel *downStepSLabel;//步 速度
@property (strong,nonatomic) UILabel *downmileageLabel;//  下面的  里程
//用这个数组记录每个字典，1.时长 2.步数 3.心率 4.步数 5.里程
@property (nonatomic,strong) NSMutableArray *dictionaryArray;

//系统地图
//位置管理者
@property (nonatomic, strong) CLLocationManager *localManager;
//地图
@property (nonatomic, strong) MKMapView *mapView;
//存放用户位置的数组
@property (nonatomic, strong) NSMutableArray *locationMutableArray;
//存放用户位置的数组 --- 存三个就开始把最后一个值放到值中
@property (nonatomic, strong) NSMutableArray *startLocArray;
//用于定位的属性
@property (nonatomic, assign) NSInteger locInt;
//用于定位的属性,地图出现一次就定位，设置一次
@property (nonatomic, assign) NSInteger locIntUse;
//取地图数据，暂停
@property (nonatomic, assign) BOOL mapSuspen;

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//播放音乐
@property (nonatomic,strong) AVAudioSession *audioSession;//播放声音后恢复音乐
@property (nonatomic,strong) UIImageView *voiceImageView;//声音按钮  的图
@property (nonatomic,strong) UIButton *voiceBtn;//声音按钮

@end

@implementation SportingMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}
//处理地图
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[PSDrawerManager instance] cancelDragResponse];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}
- (void)dealloc {
}
#pragma mark --- 主要的view的开启
-(void)setupView
{
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    UIView *timerView = [[UIView alloc]init];
    [self.navigationController.view addSubview:timerView];
    
    CGFloat timerViewX = 0;
    CGFloat timerViewY = 0;
    CGFloat timerViewW = CurrentDeviceWidth;
    CGFloat timerViewH = CurrentDeviceHeight;
    timerView.frame = CGRectMake(timerViewX, timerViewY, timerViewW, timerViewH);
    timerView.backgroundColor = [ColorTool getColor:TEXTCOLOR];
    _timerView = timerView;
    
    
    [self saveTarget];          //保存时期和 运动时间
    [self setupProperty];       //属性
    [self setupViewContent];    //运动内容
    [self setupMapView];        //地图
    
    [self playMusic];//播放音乐的初始化
    [self playMusicStart];//播放音乐
    [self countDown:3];//3
    
}
//播放音乐的初始化
-(void)playMusic
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    _audioSession = audioSession;
}
-(void)playMusicStart
{
    // 1.获取要播放音频文件的URL
    NSURL * fileURL;
    if (isZhHans) {
        fileURL = [[NSBundle mainBundle]URLForResource:@"start" withExtension:@".mp3"];
    } else {
        fileURL = [[NSBundle mainBundle]URLForResource:@"startEn" withExtension:@".mp3"];
    }
    [_audioSession setActive:YES error:nil];
    // 2.创建 AVAudioPlayer 对象
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
    [self isMute]; //禁音与否
    // 3.打印歌曲信息
    // 4.设置循环播放
    self.audioPlayer.numberOfLoops = 0;
    self.audioPlayer.delegate = self;
    // 5.开始播放
    [self.audioPlayer play];
}
-(void)playMusicSuspen
{
    // 1.获取要播放音频文件的URL
    NSURL * fileURL;
    if (isZhHans) {
        fileURL = [[NSBundle mainBundle]URLForResource:@"suspen" withExtension:@".mp3"];
    } else {
        fileURL = [[NSBundle mainBundle]URLForResource:@"suspenEn" withExtension:@".mp3"];
    }
    [_audioSession setActive:YES error:nil];
    // 2.创建 AVAudioPlayer 对象
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
    [self isMute]; //禁音与否
    // 3.打印歌曲信息
    // 4.设置循环播放
    self.audioPlayer.numberOfLoops = 0;
    self.audioPlayer.delegate = self;
    // 5.开始播放
    [self.audioPlayer play];
    
}
-(void)playMusicRenew
{
    // 1.获取要播放音频文件的URL
    NSURL * fileURL;
    if (isZhHans) {
        fileURL = [[NSBundle mainBundle]URLForResource:@"renew" withExtension:@".mp3"];
    } else {
        fileURL = [[NSBundle mainBundle]URLForResource:@"renewEn" withExtension:@".mp3"];
    }
    [_audioSession setActive:YES error:nil];
    // 2.创建 AVAudioPlayer 对象
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
    [self isMute]; //禁音与否
    // 3.打印歌曲信息
    // 4.设置循环播放
    self.audioPlayer.numberOfLoops = 0;
    self.audioPlayer.delegate = self;
    // 5.开始播放
    [self.audioPlayer play];
    
}
-(void)isMute
{
    NSInteger voiceNum = [[ADASaveDefaluts objectForKey:MAPVOICEISOPEN] integerValue];
    if (voiceNum!=2)
    {
        self.audioPlayer.volume = 1;
    }
    else
    {
        self.audioPlayer.volume = 0;
    }
}
-(void)sportingAction
{
    //保存时期和 运动时间
    //    [self  saveTarget];
    
    self.timerGetheartRate = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerActionMap) userInfo:nil repeats:YES];
}
-(void)setupProperty
{
    
    // 1.key 2.图 - image 3.数值 - number 4.单位 - unit 5.名称 - name
    // DICKEY  -- 1 - 时长- 2 - 计步- 3 - 心率- 4 - 步速- 5 - 里程
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",DICKEY,IMAGEclock,DICIMAGE,@"00:00:00",DICNUMBER,@"hehe",DICUNIT,NSLocalizedString(@"时长", nil),DICNAME, nil];
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"2",DICKEY,IMAGEstep,DICIMAGE,@"--",DICNUMBER,@"steps",DICUNIT,NSLocalizedString(@"计步", nil),DICNAME, nil];
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"3",DICKEY,IMAGEheartRate,DICIMAGE,@"--",DICNUMBER,@"bpm",DICUNIT,NSLocalizedString(@"心率", nil),DICNAME, nil];
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"4",DICKEY,IMAGEMatch,DICIMAGE,@"0'0\"",DICNUMBER,@"hehe",DICUNIT,NSLocalizedString( @"配速", nil),DICNAME, nil];
    NSMutableDictionary *dic5 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"5",DICKEY,IMAGElicheng,DICIMAGE,@"--",DICNUMBER,@"m",DICUNIT,NSLocalizedString(@"里程", nil),DICNAME, nil];
    self.dictionaryArray = [NSMutableArray arrayWithArray:@[dic1,dic2,dic3,dic4,dic5]];
    _stepNumberPlus =0;
    _kcalNumberPlus =0;
    
    _heartRateNumberPlus =0;
    _mileageNumberPlus = 0;
    //    _speedNumberPlus = 0;
    _pauseFlag = NO;
    _heartArray = [NSMutableArray array];
    //创建存放位置的数组
    _locationMutableArray = [[NSMutableArray alloc] init];
    _startLocArray = [[NSMutableArray alloc] init];
    _locInt = 1;
    _locIntUse = 0;
    _mapSuspen = NO;
    //    self.haveTabBar = YES;
}
-(void)setupViewContent
{
    //左右两个界面的实体，左边是数据，右边是地图
    //    UIScrollView *scrollView = [[UIScrollView alloc]init];
    ////    [self.view addSubview:scrollView];
    //    _scrollView = scrollView;
    //    CGFloat scrollViewX = 0;
    //    CGFloat scrollViewY = 0;
    //    CGFloat scrollViewW = CurrentDeviceWidth;
    //    CGFloat scrollViewH = CurrentDeviceHeight;
    //    scrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH);
    //    scrollView.showsHorizontalScrollIndicator = NO;
    //    scrollView.showsVerticalScrollIndicator = NO;
    //    scrollView.contentSize = CGSizeMake(0,0);;//CGSizeMake(CurrentDeviceWidth * 2,0);
    //    scrollView.scrollEnabled = NO;
    //    scrollView.backgroundColor = allColorWhite;
    //    AI_ALL
    
    UIImageView *back = [[UIImageView alloc]init];
    _back = back;
    [self.view addSubview:back];
    back.userInteractionEnabled = YES;
    CGFloat backX = 0;
    CGFloat backY = 0;
    CGFloat backW = CurrentDeviceWidth;
    CGFloat backH = CurrentDeviceHeight;
    back.frame = CGRectMake(backX, backY, backW, backH);
    back.image = [UIImage imageNamed:@"Group_ninth_map"];
    
    UILabel *countdownLabel = [[UILabel alloc]init];
    [back addSubview:countdownLabel];
    //    countdownLabel.font = [UIFont fontWithName:CUSTOMFONT size:20*HeightProportion];
    countdownLabel.font = [UIFont systemFontOfSize:18*HeightProportion];
    CGFloat countdownLabelX = 0;
    CGFloat countdownLabelY = 64*HeightProportion;
    CGFloat countdownLabelW = CurrentDeviceWidth;
    CGFloat countdownLabelH = 26*HeightProportion;
    countdownLabel.frame = CGRectMake(countdownLabelX, countdownLabelY, countdownLabelW, countdownLabelH);
    countdownLabel.text = NSLocalizedString(@"运动目标", nil);
    countdownLabel.textColor = [ColorTool getColor:@"dfdfdf"];//allColorWhite;
    countdownLabel.backgroundColor = [UIColor clearColor];//allColorRed;
    countdownLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *countdownLabelNum = [[UILabel alloc]init];
    [back addSubview:countdownLabelNum];
    //    countdownLabelNum.font = [UIFont fontWithName:CUSTOMFONT size:40*HeightProportion];
    countdownLabelNum.font = [UIFont systemFontOfSize:38*HeightProportion];
    //                           fontWithName:CUSTOMFONT size:40*HeightProportion];
    CGFloat countdownLabelNumX = 0;
    CGFloat countdownLabelNumY = CGRectGetMaxY(countdownLabel.frame) + 8*HeightProportion;
    CGFloat countdownLabelNumW = CurrentDeviceWidth;
    CGFloat countdownLabelNumH = 35*HeightProportion;
    countdownLabelNum.frame = CGRectMake(countdownLabelNumX, countdownLabelNumY, countdownLabelNumW, countdownLabelNumH);
    countdownLabelNum.text = self.targetTime;
    //    [NSString stringWithFormat:@"%@",[AllTool getSportTargetTime]];//@"00:03:29";
    countdownLabelNum.textColor = allColorWhite;
    countdownLabelNum.backgroundColor = [UIColor clearColor];//allColorRed;
    countdownLabelNum.textAlignment = NSTextAlignmentCenter;
    
    
    UILabel *timeLabel = [[UILabel alloc]init];
    [back addSubview:timeLabel];
    //    timeLabel.font = [UIFont fontWithName:CUSTOMFONT size:95*HeightProportion];
    timeLabel.font = [UIFont systemFontOfSize:86*HeightProportion];//fontWithName:CUSTOMFONT size:95*HeightProportion];
    CGFloat timeLabelX = 0;
    CGFloat timeLabelY = CGRectGetMaxY(countdownLabelNum.frame) + 20*HeightProportion;
    CGFloat timeLabelW = CurrentDeviceWidth;
    CGFloat timeLabelH = 70*HeightProportion;
    timeLabel.frame = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    timeLabel.text = @"00:00:00";
    timeLabel.textColor = [ColorTool getColor:TEXTCOLOR];
    timeLabel.backgroundColor = [UIColor clearColor];//allColorRed;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel = timeLabel;
    
    
    UILabel *timeUnitLabel = [[UILabel alloc]init];
    [back addSubview:timeUnitLabel];
    //    timeUnitLabel.font = [UIFont fontWithName:CUSTOMFONT size:20*HeightProportion];
    timeUnitLabel.font = [UIFont systemFontOfSize:18*HeightProportion];
    //                          fontWithName:CUSTOMFONT size:20*HeightProportion];
    CGFloat timeUnitLabelX = 0;
    CGFloat timeUnitLabelY = CGRectGetMaxY(timeLabel.frame) + 10*HeightProportion;
    CGFloat timeUnitLabelW = CurrentDeviceWidth;
    CGFloat timeUnitLabelH = 25*HeightProportion;
    timeUnitLabel.frame = CGRectMake(timeUnitLabelX, timeUnitLabelY, timeUnitLabelW, timeUnitLabelH);
    timeUnitLabel.text = NSLocalizedString(@"时长", nil);
    timeUnitLabel.textColor = countdownLabel.textColor;
    timeUnitLabel.backgroundColor = [UIColor clearColor];//allColorRed;
    timeUnitLabel.textAlignment = NSTextAlignmentCenter;
    _timeUnitLabel = timeUnitLabel;
    
    //用于请求手环的数据并且显示
    //    设置下方4个view
    //    NSArray *array = @[@"配速-地图",@"licheng-地图",@"计步-地图",@"心率--地图"];
    NSArray *array = @[IMAGEstep,IMAGEheartRate,IMAGEMatch,IMAGElicheng];
    for (int i = 0; i < 4; i ++)
    {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        //[UIColor colorWithRed:1 green:1 blue:1 alpha:0.58];
        CGFloat viewX = (8 + i % 2 * 181) *kX;
        CGFloat viewY = 230*kDY+ (84 + 3)*kDY * (i/2 + 1);//back.height - (244 * kDY)
        CGFloat viewW = 178 * kX;
        CGFloat viewH = 84*kDY;
        //CGRectGetMaxY(timeUnitLabel.frame)+122*HeightProportion
        view.frame = CGRectMake(viewX,viewY,viewW,viewH);
        [back addSubview:view];
        
        //        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(QIANSPACE, ((view.height-29)/2)*HeightProportion, 37*WidthProportion,29*HeightProportion)];
        //        imageView.contentMode = UIViewContentModeScaleAspectFit;
        //        imageView.image = [UIImage imageNamed:array[i]];
        //        [view addSubview:imageView];
        NSMutableAttributedString *string;
        switch (i)
        {
            case 0:
            {
                self.stepImageView = [[UIImageView alloc] initWithFrame:CGRectMake(QIANSPACE, ((view.height-29)/2)*HeightProportion, 37*WidthProportion,29*HeightProportion)];
                self.stepImageView.contentMode = UIViewContentModeScaleAspectFit;
                self.stepImageView.image = [UIImage imageNamed:array[i]];
                [view addSubview:self.stepImageView];
                string = [self makeAttributedStringWithnumBer:@"--" Unit:@"steps" WithFont:DETAILTEXTSIZE];
                _stepLabel = [[UILabel alloc] init];
                _stepLabel.frame = CGRectMake(self.stepImageView.right +ZHONGSPACE, self.stepImageView.top, view.width - self.stepImageView.right-3, 30);
                _stepLabel.attributedText = string;
                //                _stepLabel.textAlignment = NSTextAlignmentLeft;
                _stepLabel.textAlignment = NSTextAlignmentCenter;
                _stepLabel.textColor = allColorWhite;
                //                _stepLabel.font = [UIFont systemFontOfSize:30];
                //                _stepLabel.text = @"12523";
                [view addSubview:_stepLabel];
            }
                break;
            case 1:
            {
                self.heartRateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(QIANSPACE, ((view.height-29)/2)*HeightProportion, 37*WidthProportion,29*HeightProportion)];
                self.heartRateImageView.contentMode = UIViewContentModeScaleAspectFit;
                self.heartRateImageView.image = [UIImage imageNamed:array[i]];
                [view addSubview:self.heartRateImageView];
                string = [self makeAttributedStringWithnumBer:@"--" Unit:@"bpm" WithFont:DETAILTEXTSIZE];
                _heartRateLabel = [[UILabel alloc] init];
                _heartRateLabel.frame = CGRectMake(self.heartRateImageView.right +ZHONGSPACE,self.heartRateImageView.top, view.width - self.heartRateImageView.right-3, 30);
                _heartRateLabel.attributedText = string;
                //                _heartRateLabel.textAlignment = NSTextAlignmentLeft;
                _heartRateLabel.textAlignment = NSTextAlignmentCenter;
                _heartRateLabel.textColor = allColorWhite;
                [view addSubview:_heartRateLabel];
            }
                break;
            case 2:
            {
                self.speedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(QIANSPACE, ((view.height-29)/2)*HeightProportion, 37*WidthProportion,29*HeightProportion)];
                self.speedImageView.contentMode = UIViewContentModeScaleAspectFit;
                self.speedImageView.image = [UIImage imageNamed:array[i]];
                [view addSubview:self.speedImageView];
                string = [self makeAttributedStringWithnumBer:@"--" Unit:@"step/s" WithFont:DETAILTEXTSIZE];
                //                [string appendAttributedString:[self makeAttributedStringWithnumBer:@"0" Unit:@"\"" WithFont:DETAILTEXTSIZE]];
                _speedLabel = [[UILabel alloc] init];
                _speedLabel.frame = CGRectMake(_speedImageView.right + ZHONGSPACE, _speedImageView.top, view.width - _speedImageView.right-3, 30);
                _speedLabel.attributedText = string;
                _speedLabel.textAlignment = NSTextAlignmentLeft;
                _speedLabel.textAlignment = NSTextAlignmentCenter;
                _speedLabel.textColor = allColorWhite;
                [view addSubview:_speedLabel];
            }
                break;
            case 3:
            {
                self.mileageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(QIANSPACE, ((view.height-29)/2)*HeightProportion, 37*WidthProportion,29*HeightProportion)];
                self.mileageImageView.contentMode = UIViewContentModeScaleAspectFit;
                self.mileageImageView.image = [UIImage imageNamed:array[i]];
                [view addSubview:self.mileageImageView];
                string =  [self makeAttributedStringWithnumBer:@"--" Unit:@"m" WithFont:DETAILTEXTSIZE];
                //                [string appendAttributedString:[self makeAttributedStringWithnumBer:@"0" Unit:@"min" WithFont:18]];
                _mileageLabel = [[UILabel alloc] init];
                _mileageLabel.frame = CGRectMake(_mileageImageView.right +ZHONGSPACE, _mileageImageView.top, view.width - _mileageImageView.right-3, 30);
                _mileageLabel.attributedText = string;
                _mileageLabel.textAlignment = NSTextAlignmentLeft;
                _mileageLabel.textAlignment = NSTextAlignmentCenter;
                _mileageLabel.textColor = allColorWhite
                [view addSubview:_mileageLabel];
                
            }
                break;
            default:
                break;
        }
        switch (i)
        {
            case 0:
            {
                UIButton *swapBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
                [view addSubview:swapBtn1];
                // swapBtn1.backgroundColor = allColorRed;
                swapBtn1.backgroundColor = [UIColor clearColor];
                [swapBtn1 addTarget:self action:@selector(swapBtn1Action) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case 1:
            {
                UIButton *swapBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
                [view addSubview:swapBtn2];
                // swapBtn2.backgroundColor = allColorRed;
                swapBtn2.backgroundColor = [UIColor clearColor];
                [swapBtn2 addTarget:self action:@selector(swapBtn2Action) forControlEvents:UIControlEventTouchUpInside];
                
            }
                break;
            case 2:
            {
                UIButton *swapBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
                [view addSubview:swapBtn3];
                //swapBtn3.backgroundColor = allColorRed;
                swapBtn3.backgroundColor = [UIColor clearColor];
                [swapBtn3 addTarget:self action:@selector(swapBtn3Action) forControlEvents:UIControlEventTouchUpInside];
                
            }
                break;
            case 3:
            {
                UIButton *swapBtn4 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
                [view addSubview:swapBtn4];
                // swapBtn4.backgroundColor = allColorRed;
                swapBtn4.backgroundColor = [UIColor clearColor];
                [swapBtn4 addTarget:self action:@selector(swapBtn4Action) forControlEvents:UIControlEventTouchUpInside];
                
            }
                break;
            default:
                break;
        }
        
    }
    
    //下面的按钮  运行中   第一：
    UIImageView *btnImage = [[UIImageView alloc]init];
    [back addSubview:btnImage];
    btnImage.image = [UIImage imageNamed:@"Rectangle_sive_map"];
    btnImage.userInteractionEnabled = YES;
    CGFloat btnImageX = 0;
    CGFloat btnImageY = 520*HeightProportion;
    CGFloat btnImageW = 90*WidthProportion;
    CGFloat btnImageH = btnImageW;
    btnImage.frame = CGRectMake(btnImageX, btnImageY, btnImageW, btnImageH);
    btnImage.centerX = back.centerX;
    _btnImage = btnImage;
    
    CircleViewMap *btnCircle = [CircleViewMap getObject:CGRectMake(0, btnImageY, btnImageW+6*WidthProportion, btnImageH+6*WidthProportion)];
    [back addSubview:btnCircle];
    btnCircle.percent = 0;
    _btnCircle = btnCircle;
    btnCircle.center = btnImage.center;
    
    UIButton *btning = [[UIButton alloc]init];
    [back addSubview:btning];
    _btning = btning;
    btning.backgroundColor = [UIColor clearColor];
    //colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.3];
    btning.frame = CGRectMake(btnImageX, btnImageY, btnImageW+10, btnImageH+10);
    btning.center = btnImage.center;
    [btning addTarget:self action:@selector(buttonAction:forEvent:) forControlEvents:UIControlEventAllTouchEvents];
    
    //下面的按钮 暂停 继续    第二：
    //暂停
    UIImageView *suspendImage = [[UIImageView alloc]init];
    [back addSubview:suspendImage];
    suspendImage.image = [UIImage imageNamed:@"Stop_map"];
    suspendImage.userInteractionEnabled = YES;
    CGFloat suspendImageX = 80*WidthProportion;
    CGFloat suspendImageY = 520*HeightProportion;
    CGFloat suspendImageW = 90*WidthProportion;
    CGFloat suspendImageH = suspendImageW;
    suspendImage.frame = CGRectMake(suspendImageX, suspendImageY, suspendImageW, suspendImageH);
    suspendImage.hidden = YES;
    [back sendSubviewToBack:suspendImage];
    _suspendImage = suspendImage;
    
    //        suspendImage.centerX = back.centerX;
    //        _suspendImage = suspendImage;
    
    UIButton *suspendBtning = [[UIButton alloc]init];
    [back addSubview:suspendBtning];
    //        _suspendBtning = suspendBtning;
    suspendBtning.backgroundColor = [UIColor clearColor];
    //colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.3];
    suspendBtning.frame = CGRectMake(suspendImageX, suspendImageY, suspendImageW+10*WidthProportion, suspendImageH+10*WidthProportion);
    suspendBtning.center = suspendImage.center;
    [suspendBtning addTarget:self action:@selector(suspendBtningAction) forControlEvents:UIControlEventTouchUpInside];
    suspendBtning.hidden = YES;
    [back sendSubviewToBack:suspendBtning];
    _suspendBtning = suspendBtning;
    
    
    UIImageView *ContinueImage = [[UIImageView alloc]init];
    [back addSubview:ContinueImage];
    ContinueImage.image = [UIImage imageNamed:@"Group_One"];
    ContinueImage.userInteractionEnabled = YES;
    CGFloat ContinueImageX = 40*WidthProportion + CGRectGetMaxX(suspendImage.frame);
    CGFloat ContinueImageY = 520*HeightProportion;
    CGFloat ContinueImageW = 90*WidthProportion;
    CGFloat ContinueImageH = ContinueImageW;
    ContinueImage.frame = CGRectMake(ContinueImageX, ContinueImageY, ContinueImageW, ContinueImageH);
    ContinueImage.hidden = YES;
    [back sendSubviewToBack:ContinueImage];
    _ContinueImage = ContinueImage;
    
    //继续
    UIButton *ContinueBtning = [[UIButton alloc]init];
    [back addSubview:ContinueBtning];
    //        _ContinueBtning = ContinueBtning;
    ContinueBtning.backgroundColor = [UIColor clearColor];
    //colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.3];
    ContinueBtning.frame = CGRectMake(ContinueImageX, ContinueImageY, ContinueImageW+10*WidthProportion, ContinueImageH+10*WidthProportion);
    ContinueBtning.center = ContinueImage.center;
    [ContinueBtning addTarget:self action:@selector(ContinueBtningAction) forControlEvents:UIControlEventTouchUpInside];
    ContinueBtning.hidden = YES;
    [back sendSubviewToBack:ContinueBtning];
    _ContinueBtning = ContinueBtning;
    
    //下面的按钮,地图按钮    第三：
    UIImageView *mapImageView = [[UIImageView alloc]init];
    [back addSubview:mapImageView];
    mapImageView.image = [UIImage imageNamed:@"Shape_dian_map"];
    mapImageView.userInteractionEnabled = YES;
    _mapImageViewX = 38*WidthProportion;
    _mapImageViewW = 30*WidthProportion;
    _mapImageViewH = 37*HeightProportion;
    _mapImageViewY = CurrentDeviceHeight-50*HeightProportion-_mapImageViewH/2;
    
    mapImageView.frame = CGRectMake(_mapImageViewX, _mapImageViewY, _mapImageViewW,_mapImageViewH);
    //
    UIButton *mapBtn = [[UIButton alloc]init];
    [back addSubview:mapBtn];
    //        _mapBtn = mapBtn;
    mapBtn.backgroundColor = [UIColor clearColor];//allColorRed;
    //[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.3];
    //clearColor];
    mapBtn.frame = CGRectMake(_mapImageViewX, _mapImageViewY,40*WidthProportion,40*WidthProportion);
    mapBtn.center = mapImageView.center;
    [mapBtn addTarget:self action:@selector(mapBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    //右上角的按钮,声音按钮    第四：
    
    UIImageView *voiceImageView = [[UIImageView alloc]init];
    [back addSubview:voiceImageView];
    _voiceImageView = voiceImageView;
    voiceImageView.image = [UIImage imageNamed:@"map_voiceOpen"];
    NSInteger voiceNum = [[ADASaveDefaluts objectForKey:MAPVOICEISOPEN] integerValue];
    if (voiceNum==2)
    {
        voiceImageView.image = [UIImage imageNamed:@"map_voiceClose"];
    }
    voiceImageView.userInteractionEnabled = YES;
    
    CGFloat  voiceImageViewW = 35*WidthProportion;
    CGFloat  voiceImageViewH = 27*HeightProportion;
    CGFloat  voiceImageViewX = CurrentDeviceWidth-38*WidthProportion-voiceImageViewW;
    CGFloat  voiceImageViewY = 40*HeightProportion;
    
    voiceImageView.frame = CGRectMake(voiceImageViewX, voiceImageViewY, voiceImageViewW,voiceImageViewH);
    
    UIButton *voiceBtn = [[UIButton alloc]init];
    [back addSubview:voiceBtn];
    _voiceBtn = voiceBtn;
    //        _mapBtn = mapBtn;
    voiceBtn.backgroundColor = [UIColor clearColor];//allColorRed;
    //[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.3];
    //clearColor];
    voiceBtn.frame = CGRectMake(voiceImageViewX, voiceImageViewY,40*WidthProportion,40*WidthProportion);
    voiceBtn.center = voiceImageView.center;
    [voiceBtn addTarget:self action:@selector(voiceBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}

//把百度地图加载到view中

-(void)setupMapView
{
    //    CGFloat viewMapPackX = _mapImageViewX;
    //    CGFloat viewMapPackY = _mapImageViewY+7*HeightProportion;
    //    CGFloat viewMapPackW = _mapImageViewW;
    //    CGFloat viewMapPackH = _mapImageViewW;
    
    CGFloat viewMapPackX = 0;
    CGFloat viewMapPackY = 20;
    CGFloat viewMapPackW = CurrentDeviceWidth;
    CGFloat viewMapPackH = CurrentDeviceHeight;
    UIView * viewMapPack =[[UIView alloc]init];
    viewMapPack.frame=CGRectMake(viewMapPackX,viewMapPackY,viewMapPackW,viewMapPackH);
    [self.view addSubview:viewMapPack];
    _viewMapPack = viewMapPack;
    //_viewMapPack.hidden = YES;
    [self.view sendSubviewToBack:_viewMapPack];
    _viewMapPack.layer.masksToBounds = YES;
    _viewMapPack.layer.cornerRadius = _mapImageViewW/2;
    _viewMapPack.backgroundColor = allColorWhite;//[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];
    
    
    
    //全屏显示地图并设置地图的代理
    _mapView = [[MKMapView alloc] init];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.mapType = MKMapTypeStandard;
    [viewMapPack addSubview:_mapView];
    //        [self.view addSubview:_mapView];
    
    CGFloat mapViewX = 0;//CurrentDeviceWidth;
    CGFloat mapViewY = 0;
    CGFloat mapViewW = CurrentDeviceWidth;//CurrentDeviceWidth;
    CGFloat mapViewH = CurrentDeviceHeight - 20;
    _mapView.frame = CGRectMake(mapViewX, mapViewY, mapViewW, mapViewH);
    //是否启用定位服务
    if ([CLLocationManager locationServicesEnabled])
    {
        //adaLog(@"开始定位");
        //调用 startUpdatingLocation 方法后,会对应进入 didUpdateLocations 方法
        [self.localManager startUpdatingLocation];
    }
    else
    { //adaLog(@"定位服务为关闭状态,无法使用定位服务");
    }
    
    //用户位置追踪
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    _mapView.mapType = MKMapTypeStandard;
    
  
    //定位按钮  testguge
    
    UIImageView *LocView = [[UIImageView alloc]init];
    //    [self.scrollView addSubview:LocView];
    [viewMapPack addSubview:LocView];
    LocView.image = [UIImage imageNamed:@"map_dingwei1"];
    LocView.userInteractionEnabled = YES;
    LocView.backgroundColor = [UIColor clearColor];//allColorRed;
    CGFloat LocViewW = 43*WidthProportion;
    CGFloat LocViewH = LocViewW;
    CGFloat LocViewX = 15*WidthProportion;
    CGFloat LocViewY = CurrentDeviceHeight-20-113*HeightProportion-LocViewH;
    LocView.frame = CGRectMake(LocViewX, LocViewY, LocViewW, LocViewH);
    
    UIButton *LocBtn = [[UIButton alloc]init];
    //    [self.scrollView addSubview:LocBtn];
    [viewMapPack addSubview:LocBtn];
    
    LocBtn.backgroundColor = [UIColor clearColor];//allColorRed;
    
    //    [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.6];
    [LocBtn addTarget:self action:@selector(startLocationAction) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat LocBtnW = 43*WidthProportion;
    CGFloat LocBtnH = LocBtnW;
    CGFloat LocBtnX = 15*WidthProportion;//CurrentDeviceWidth + 15*WidthProportion;
    CGFloat LocBtnY =  CurrentDeviceHeight-20-113*HeightProportion-LocBtnH;
    LocBtn.frame = CGRectMake(LocBtnX,LocBtnY,LocBtnW,LocBtnH);
    LocBtn.center = LocView.center;
    
    //关闭地图，移动到左边    第四：
    
    UIImageView *closeMapView = [[UIImageView alloc]init];
    //    [self.scrollView addSubview:closeMapView];
    [viewMapPack addSubview:closeMapView];
    closeMapView.image = [UIImage imageNamed:@"Shape_cha_map"];
    closeMapView.userInteractionEnabled = YES;
    closeMapView.backgroundColor = [UIColor clearColor];//allColorRed;
    CGFloat closeMapViewW = 43*WidthProportion;
    CGFloat closeMapViewH = closeMapViewW;
    CGFloat closeMapViewX = CurrentDeviceWidth - 15*WidthProportion - closeMapViewW;//CurrentDeviceWidth +CurrentDeviceWidth - 15*WidthProportion - closeMapViewW;//
    CGFloat closeMapViewY = CurrentDeviceHeight-20-113*HeightProportion-closeMapViewH;
    closeMapView.frame = CGRectMake(closeMapViewX, closeMapViewY, closeMapViewW, closeMapViewH);
    
    UIButton *closeMapBtn = [[UIButton alloc]init];
    //    [self.scrollView addSubview:closeMapBtn];
    [viewMapPack addSubview:closeMapBtn];
    //        _closeMapBtn = closeMapBtn;
    closeMapBtn.backgroundColor = [UIColor clearColor];//colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.3];
    //clearColor];
    CGFloat closeMapImageViewX = 0;
    CGFloat closeMapImageViewY = 0;
    CGFloat closeMapImageViewW = 40*WidthProportion;
    CGFloat closeMapImageViewH = 40*WidthProportion;
    closeMapBtn.frame = CGRectMake(closeMapImageViewX, closeMapImageViewY,closeMapImageViewW,closeMapImageViewH);
    closeMapBtn.center = closeMapView.center;
    [closeMapBtn addTarget:self action:@selector(closeMapBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    //底层的view
    [self setupMapDownView];
}
-(void)setupMapDownView
{
    UIView *mapDownView = [[UIView alloc]init];
    //    [self.view addSubview:mapDownView];
    [_viewMapPack addSubview:mapDownView];
    mapDownView.backgroundColor = [UIColor blackColor];
    
    CGFloat mapDownViewX = 0;
    CGFloat mapDownViewW = CurrentDeviceWidth;
    CGFloat mapDownViewH = 88*HeightProportion;
    CGFloat mapDownViewY = CurrentDeviceHeight - mapDownViewH - 20;
    mapDownView.frame = CGRectMake(mapDownViewX, mapDownViewY, mapDownViewW, mapDownViewH);
    
    //时长
    UILabel *timelength = [[UILabel alloc]init];
    [mapDownView addSubview:timelength];
    timelength.textColor = [UIColor whiteColor];
    timelength.text = @"00:00:00";
    timelength.font = [UIFont systemFontOfSize:26*WidthProportion];
    //    timelength.backgroundColor = [UIColor orangeColor];
    timelength.textAlignment = NSTextAlignmentCenter;
    CGFloat timelengthX = 0;
    CGFloat timelengthH = 30*HeightProportion;
    CGFloat timelengthY = (mapDownViewH-2*timelengthH)/2;// 14*HeightProportion;
    CGFloat timelengthW = 0.4*CurrentDeviceWidth-10*WidthProportion;// 100*WidthProportion;
    
    timelength.frame = CGRectMake(timelengthX, timelengthY, timelengthW, timelengthH);
    _timelength = timelength;
    
    UILabel *timelengthUnit = [[UILabel alloc]init];
    [mapDownView addSubview:timelengthUnit];
    timelengthUnit.textColor = [UIColor whiteColor];
    timelengthUnit.text = NSLocalizedString(@"时长", nil);
    timelengthUnit.font = [UIFont systemFontOfSize:18*WidthProportion];
    timelengthUnit.textAlignment = NSTextAlignmentCenter;
    CGFloat timelengthUnitX = 0;//20*WidthProportion;
    CGFloat timelengthUnitY = CGRectGetMaxY(timelength.frame);
    CGFloat timelengthUnitW = timelengthW;
    CGFloat timelengthUnitH = timelengthH;//30*HeightProportion;
    timelengthUnit.frame = CGRectMake(timelengthUnitX, timelengthUnitY, timelengthUnitW, timelengthUnitH);
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    [mapDownView addSubview:lineView];
    lineView.backgroundColor = [UIColor whiteColor];
    CGFloat lineViewX = 0.4*CurrentDeviceWidth;
    CGFloat lineViewY = mapDownViewH/4;
    CGFloat lineViewW = 1;
    CGFloat lineViewH = mapDownViewH/2;
    lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
    
    //步数
    UILabel *downStepLabel = [[UILabel alloc]init];
    [mapDownView addSubview:downStepLabel];
    downStepLabel.textColor = [UIColor whiteColor];
    downStepLabel.text = @"--";
    downStepLabel.font = [UIFont systemFontOfSize:16*WidthProportion];
    //    downStepLabel.backgroundColor = [UIColor orangeColor];
    downStepLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat downStepLabelX = lineViewX+10*WidthProportion;
    CGFloat downStepLabelW = (CurrentDeviceWidth-downStepLabelX)/3;
    CGFloat downStepLabelH = 22*HeightProportion;
    CGFloat downStepLabelY = (mapDownViewH - downStepLabelH*2)/2;//10*HeightProportion;
    downStepLabel.frame = CGRectMake(downStepLabelX, downStepLabelY, downStepLabelW, downStepLabelH);
    _downStepLabel = downStepLabel;
    
    
    UILabel *downStepLabelUnit = [[UILabel alloc]init];
    [mapDownView addSubview:downStepLabelUnit];
    downStepLabelUnit.textColor = [UIColor whiteColor];
    downStepLabelUnit.text = NSLocalizedString(@"步数", nil);
    downStepLabelUnit.font = downStepLabel.font;// [UIFont systemFontOfSize:16*WidthProportion];
    //    downStepLabelUnit.backgroundColor = [UIColor orangeColor];
    downStepLabelUnit.textAlignment = NSTextAlignmentCenter;
    CGFloat downStepLabelUnitX = downStepLabelX;
    CGFloat downStepLabelUnitY = CGRectGetMaxY(downStepLabel.frame);
    CGFloat downStepLabelUnitW = downStepLabelW;
    CGFloat downStepLabelUnitH = downStepLabelH;
    downStepLabelUnit.frame = CGRectMake(downStepLabelUnitX, downStepLabelUnitY, downStepLabelUnitW, downStepLabelUnitH);
    
    //步 速度
    UILabel *downStepSLabel = [[UILabel alloc]init];
    [mapDownView addSubview:downStepSLabel];
    downStepSLabel.textColor = [UIColor whiteColor];
    downStepSLabel.text = @"0'0\"";
    downStepSLabel.font = downStepLabelUnit.font;//[UIFont systemFontOfSize:16*WidthProportion];
    //    downStepSLabel.backgroundColor = [UIColor orangeColor];
    downStepSLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat downStepSLabelX = CGRectGetMaxX(downStepLabel.frame);
    CGFloat downStepSLabelW = downStepLabelW;
    CGFloat downStepSLabelH = downStepLabelH;
    CGFloat downStepSLabelY = downStepLabelY;
    downStepSLabel.frame = CGRectMake(downStepSLabelX, downStepSLabelY, downStepSLabelW, downStepSLabelH);
    _downStepSLabel = downStepSLabel;
    
    UILabel *downStepSLabelUnit = [[UILabel alloc]init];
    [mapDownView addSubview:downStepSLabelUnit];
    downStepSLabelUnit.textColor = [UIColor whiteColor];
    downStepSLabelUnit.text = NSLocalizedString(@"配速", nil);
    downStepSLabelUnit.font = downStepSLabel.font;//[UIFont systemFontOfSize:16*WidthProportion];
    //    downStepSLabelUnit.backgroundColor = [UIColor orangeColor];
    downStepSLabelUnit.textAlignment = NSTextAlignmentCenter;
    CGFloat downStepSLabelUnitX = downStepSLabelX;
    CGFloat downStepSLabelUnitY = downStepSLabelY+downStepSLabelH;
    CGFloat downStepSLabelUnitW = downStepSLabelW;
    CGFloat downStepSLabelUnitH = downStepSLabelH;
    downStepSLabelUnit.frame = CGRectMake(downStepSLabelUnitX, downStepSLabelUnitY, downStepSLabelUnitW, downStepSLabelUnitH);
    
    
    //  下面的  里程
    UILabel *downmileageLabel = [[UILabel alloc]init];
    [mapDownView addSubview:downmileageLabel];
    downmileageLabel.textColor = [UIColor whiteColor];
    downmileageLabel.text = @"--";
    downmileageLabel.font = downStepSLabelUnit.font;//[UIFont systemFontOfSize:16*WidthProportion];
    //    downmileageLabel.backgroundColor = [UIColor orangeColor];
    downmileageLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat downmileageLabelX = CGRectGetMaxX(downStepSLabel.frame);
    CGFloat downmileageLabelW = downStepLabelW;
    CGFloat downmileageLabelH = downStepLabelH;
    CGFloat downmileageLabelY = downStepLabelY;
    downmileageLabel.frame = CGRectMake(downmileageLabelX, downmileageLabelY, downmileageLabelW, downmileageLabelH);
    _downmileageLabel = downmileageLabel;
    
    UILabel *downmileageLabelUnit = [[UILabel alloc]init];
    [mapDownView addSubview:downmileageLabelUnit];
    downmileageLabelUnit.textColor = [UIColor whiteColor];
    downmileageLabelUnit.text = NSLocalizedString(@"里程", nil);
    downmileageLabelUnit.font = downmileageLabel.font;//[UIFont systemFontOfSize:16*WidthProportion];
    //    downmileageLabelUnit.backgroundColor = [UIColor orangeColor];
    downmileageLabelUnit.textAlignment = NSTextAlignmentCenter;
    CGFloat downmileageLabelUnitX = downmileageLabelX;
    CGFloat downmileageLabelUnitY = downmileageLabelY+downmileageLabelH;
    CGFloat downmileageLabelUnitW = downmileageLabelW;
    CGFloat downmileageLabelUnitH = downmileageLabelH;
    downmileageLabelUnit.frame = CGRectMake(downmileageLabelUnitX, downmileageLabelUnitY, downmileageLabelUnitW, downmileageLabelUnitH);
    
}
-(void)hiddenView
{
    
    if (_timerView) {
        [UIView animateWithDuration:0.6f animations:^{
            
            _timerView.frame = _btnImage.frame;
            _timerView.layer.cornerRadius = _btnImage.width/2;
            
        } completion:^(BOOL finished) {
            _timerView.hidden = YES;
            [_timerView removeFromSuperview];
            _timerView = nil;
        }];
        
    }
}
-(void)countDown:(int)count
{
    if(count <=0){
        //倒计时已到，作需要作的事吧。
        [[CositeaBlueTooth sharedInstance] openHeartRate:^(BOOL flag) {  }];
        //adaLog(@" 在线运动， 开启成功   flag = = ");
        
        [self sportingAction];
        [self hiddenView];
        
        return;
    }
    UILabel* lblCountDown = [[UILabel alloc] initWithFrame:CGRectMake(375/4, 0, 375, 667)];
    lblCountDown.textColor = [UIColor whiteColor];
    lblCountDown.font = [UIFont boldSystemFontOfSize:300];
    lblCountDown.backgroundColor = [UIColor clearColor];
    lblCountDown.text = [NSString stringWithFormat:@"%d",count];
    //    [self.view addSubview:lblCountDown];
    [self.navigationController.view addSubview:lblCountDown];
    [UIView animateWithDuration:1.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         lblCountDown.alpha = 0;
                         lblCountDown.transform =CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
                     }
                     completion:^(BOOL finished) {
                         [lblCountDown removeFromSuperview];
                         //递归调用，直到计时为零
                         [self countDown:count -1];
                     }
     ];
}
#pragma mark    ---    系统地图


#pragma mark   ---  私有方法

//按钮事件  - swapBtn1Action
-(void)swapBtn1Action
{
    //adaLog(@"btn1Action");
    NSMutableArray *arr = _dictionaryArray;
    [arr exchangeObjectAtIndex:0 withObjectAtIndex:1];
    [self setDictionaryArray:arr];
    
}
//按钮事件  - swapBtn2Action
-(void)swapBtn2Action
{
    //adaLog(@"btn2Action");
    NSMutableArray *arr = _dictionaryArray;
    [arr exchangeObjectAtIndex:0 withObjectAtIndex:2];
    [self setDictionaryArray:arr];
}
//按钮事件  - swapBtn3Action
-(void)swapBtn3Action
{
    //adaLog(@"btn3Action");
    NSMutableArray *arr = _dictionaryArray;
    [arr exchangeObjectAtIndex:0 withObjectAtIndex:3];
    [self setDictionaryArray:arr];
}
//按钮事件  - swapBtn4Action
-(void)swapBtn4Action
{
    //adaLog(@"btn4Action");
    NSMutableArray *arr = _dictionaryArray;
    [arr exchangeObjectAtIndex:0 withObjectAtIndex:4];
    [self setDictionaryArray:arr];
}
-(void)setDictionaryArray:(NSMutableArray *)dictionaryArray
{
    _dictionaryArray = dictionaryArray;
    [UIView animateWithDuration:2.f animations:^{
        [self refreshPane:dictionaryArray];
    }];
    
}
//   刷新界面的数据
-(void)refreshPane:(NSMutableArray *)array
{
    NSMutableAttributedString *string;
    for (int i=0; i<array.count; i++)
    {
        NSDictionary *dic = array[i];
        switch (i)
        {
            case 0:
            {
                _timeLabel.text = [dic objectForKey:DICNUMBER];
                _timeUnitLabel.text = [dic objectForKey:DICNAME];
                _timelength.text = [dic objectForKey:DICNUMBER];
            }
                break;
            case 1:
            {
                self.stepImageView.image = [UIImage imageNamed:[dic objectForKey:DICIMAGE]];
                string = [self makeAttributedStringWithnumBer:[dic objectForKey:DICNUMBER] Unit:[dic objectForKey:DICUNIT] WithFont:DETAILTEXTSIZE];
                _stepLabel.attributedText = string;
                _downStepLabel.text = [dic objectForKey:DICNUMBER];
            }
                break;
            case 2:
            {
                self.heartRateImageView.image = [UIImage imageNamed:[dic objectForKey:DICIMAGE]];
                string = [self makeAttributedStringWithnumBer:[dic objectForKey:DICNUMBER] Unit:[dic objectForKey:DICUNIT] WithFont:DETAILTEXTSIZE];
                _heartRateLabel.attributedText = string;
                
                
            }
                break;
            case 3:
            {
                self.speedImageView.image = [UIImage imageNamed:[dic objectForKey:DICIMAGE]];
                string = [self makeAttributedStringWithnumBer:[dic objectForKey:DICNUMBER] Unit:[dic objectForKey:DICUNIT] WithFont:DETAILTEXTSIZE];
                _speedLabel.attributedText = string;
                _downStepSLabel.text = [dic objectForKey:DICNUMBER];
            }
                break;
            case 4:
            {
                self.mileageImageView.image = [UIImage imageNamed:[dic objectForKey:DICIMAGE]];
                string = [self makeAttributedStringWithnumBer:[dic objectForKey:DICNUMBER] Unit:[dic objectForKey:DICUNIT] WithFont:DETAILTEXTSIZE];
                _mileageLabel.attributedText = string;
                _downmileageLabel.text = [dic objectForKey:DICNUMBER];
            }
                break;
            default:
                break;
        }
    }
    [self refreshMapDown:array];
}
//刷新界面的数据
-(void)refreshPaneSimple:(NSMutableArray *)array
{
    NSMutableAttributedString *string;
    for (int i=0; i<array.count; i++)
    {
        NSDictionary *dic = array[i];
        switch (i)
        {
            case 0:
            {
                _timeLabel.text = [dic objectForKey:DICNUMBER];
                _timelength.text = [dic objectForKey:DICNUMBER];
                //                _timeUnitLabel.text = [dic objectForKey:DICNAME];
            }
                break;
            case 1:
            {
                //                self.stepImageView.image = [UIImage imageNamed:[dic objectForKey:DICIMAGE]];
                string = [self makeAttributedStringWithnumBer:[dic objectForKey:DICNUMBER] Unit:[dic objectForKey:DICUNIT] WithFont:DETAILTEXTSIZE];
                _stepLabel.attributedText = string;
                _downStepLabel.text = [dic objectForKey:DICNUMBER];
            }
                break;
            case 2:
            {
                //                self.heartRateImageView.image = [UIImage imageNamed:[dic objectForKey:DICIMAGE]];
                string = [self makeAttributedStringWithnumBer:[dic objectForKey:DICNUMBER] Unit:[dic objectForKey:DICUNIT] WithFont:DETAILTEXTSIZE];
                _heartRateLabel.attributedText = string;
            }
                break;
            case 3:
            {
                //                self.speedImageView.image = [UIImage imageNamed:[dic objectForKey:DICIMAGE]];
                string = [self makeAttributedStringWithnumBer:[dic objectForKey:DICNUMBER] Unit:[dic objectForKey:DICUNIT] WithFont:DETAILTEXTSIZE];
                _speedLabel.attributedText = string;
                _downStepSLabel.text = [dic objectForKey:DICNUMBER];
            }
                break;
            case 4:
            {
                //                self.mileageImageView.image = [UIImage imageNamed:[dic objectForKey:DICIMAGE]];
                string = [self makeAttributedStringWithnumBer:[dic objectForKey:DICNUMBER] Unit:[dic objectForKey:DICUNIT] WithFont:DETAILTEXTSIZE];
                _mileageLabel.attributedText = string;
                _downmileageLabel.text = [dic objectForKey:DICNUMBER];
            }
                break;
            default:
                break;
        }
    }
    [self refreshMapDown:array];
}

//刷新地图中，下面的view的数据
-(void)refreshMapDown:(NSMutableArray *)array
{
    //NSMutableAttributedString *string;
    for (int i=0; i<array.count; i++)
    {
        NSDictionary *dic = array[i];
        int dex = [dic[DICKEY] intValue];
        switch (dex)
        {
            case 1:
            {
                //                _timeLabel.text = [dic objectForKey:DICNUMBER];
                _timelength.text = [dic objectForKey:DICNUMBER];
                //                _timeUnitLabel.text = [dic objectForKey:DICNAME];
            }
                break;
            case 2:
            {
                //                self.stepImageView.image = [UIImage imageNamed:[dic objectForKey:DICIMAGE]];
                //                string = [self makeAttributedStringWithnumBer:[dic objectForKey:DICNUMBER] Unit:[dic objectForKey:DICUNIT] WithFont:DETAILTEXTSIZE];
                //                _stepLabel.attributedText = string;
                _downStepLabel.text = [dic objectForKey:DICNUMBER];
            }
                break;
            case 3:
            {
                //                self.heartRateImageView.image = [UIImage imageNamed:[dic objectForKey:DICIMAGE]];
                //                string = [self makeAttributedStringWithnumBer:[dic objectForKey:DICNUMBER] Unit:[dic objectForKey:DICUNIT] WithFont:DETAILTEXTSIZE];
                //                _heartRateLabel.attributedText = string;
            }
                break;
            case 4:
            {
                //                self.speedImageView.image = [UIImage imageNamed:[dic objectForKey:DICIMAGE]];
                //                string = [self makeAttributedStringWithnumBer:[dic objectForKey:DICNUMBER] Unit:[dic objectForKey:DICUNIT] WithFont:DETAILTEXTSIZE];
                //                _speedLabel.attributedText = string;
                _downStepSLabel.text = [dic objectForKey:DICNUMBER];
            }
                break;
            case 5:
            {
                //                self.mileageImageView.image = [UIImage imageNamed:[dic objectForKey:DICIMAGE]];
                //                string = [self makeAttributedStringWithnumBer:[dic objectForKey:DICNUMBER] Unit:[dic objectForKey:DICUNIT] WithFont:DETAILTEXTSIZE];
                //                _mileageLabel.attributedText = string;
                _downmileageLabel.text = [dic objectForKey:DICNUMBER];
            }
                break;
            default:
                break;
        }
    }
}


-(NSString *)getTimeLabelText
{
    NSString *targetString;
    targetString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",_progress / 3600,_progress  % 3600 / 60 ,_progress % 60];
    //adaLog(@"_progress =     - - %02ld",_progress);
    return targetString;
}

#pragma mark  --  定时器对蓝牙索取数据
-(void)timerActionMap
{
    _progress++;
    for (int i=0; i<_dictionaryArray.count; i++)
    {
        NSMutableDictionary *dic = _dictionaryArray[i];
        int key = [[dic objectForKey:DICKEY] intValue];
        switch (key)
        {
            case 1:
            {
                [dic setValue:[self getTimeLabelText] forKey:DICNUMBER];
            }
        }
    }
    [self refreshPaneSimple:_dictionaryArray];
    //   __block SportModel *spo = [[SportModel alloc]init];
    //对蓝牙打开开关。
    if (!self.isStoreMap)
    {
        if ([CositeaBlueTooth sharedInstance].isConnected)
        {
            WeakSelf
            [[CositeaBlueTooth sharedInstance] timerGetHeartRateData:^(SportModelMap *sport) {
    
                [weakSelf RefreshMapView:sport];
            }];
        }
    }
    else
    {
        //adaLog(@"取出地图数据");
    }
}
-(void)RefreshMapView:(SportModelMap *)sport
{
    if(!_initialSport){
        _initialSport = sport;
        return;
    }
    if (_pauseFlag)
    {    _realtimeSport = sport;
        _pauseFlag = !_pauseFlag;
    }
    else
    {
        if (_realtimeSport)
        {
            NSInteger stepNum  = [_initialSport.stepNumber integerValue] + [sport.stepNumber integerValue]  - [_realtimeSport.stepNumber integerValue];
            _initialSport.stepNumber = [NSString stringWithFormat:@"%ld",stepNum];
            NSInteger mileage  = [_initialSport.mileageNumber integerValue] + [sport.mileageNumber integerValue] - [_realtimeSport.mileageNumber integerValue];
            _initialSport.mileageNumber = [NSString stringWithFormat:@"%ld",mileage];
            NSInteger kcal  = [_initialSport.kcalNumber integerValue] + [sport.kcalNumber integerValue] - [_realtimeSport.kcalNumber integerValue];
            _initialSport.kcalNumber = [NSString stringWithFormat:@"%ld",kcal];
            _realtimeSport = nil;
        }
        
        
        
        _stepNumberPlus = [sport.stepNumber integerValue]- [self.initialSport.stepNumber integerValue];
        _kcalNumberPlus = [sport.kcalNumber integerValue] - [self.initialSport.kcalNumber integerValue];
        _heartRateNumberPlus = [sport.heartRate integerValue];
        if (_stepNumberPlus <=0)
        {
            _initialSport.stepNumber =[NSString stringWithFormat:@"%ld",([_initialSport.stepNumber integerValue] - labs(_stepNumberPlus))];
            
        }
        if( _kcalNumberPlus <= 0)
        {
            _initialSport.kcalNumber =[NSString stringWithFormat:@"%ld",([_initialSport.kcalNumber integerValue] - labs(_kcalNumberPlus))];
        }
        _mileageNumberPlus = [sport.mileageNumber integerValue]- [self.initialSport.mileageNumber integerValue];
        //    _speedNumberPlus = [sport.stepSpeed integerValue]- [self.initialSport.stepSpeed integerValue];
        
        NSString * stepNumber = [NSString stringWithFormat:@"%ld",_stepNumberPlus];
        //NSString * kcalNumber = [NSString stringWithFormat:@"%ld",_kcalNumberPlus];
        NSString * heartRate = [NSString stringWithFormat:@"%ld",_heartRateNumberPlus];
        [_heartArray addObject:sport.heartRate];
        //    NSString * speed = [NSString stringWithFormat:@"%ld",_speedNumberPlus];
        
        NSString * mileageNumber = [NSString stringWithFormat:@"%ld",_mileageNumberPlus];
        _avgPace = [AllTool pacewithTime:_progress andRice:_mileageNumberPlus];
        
        for (int i=0; i<_dictionaryArray.count; i++)
        {
            NSMutableDictionary *dic = _dictionaryArray[i];
            int key = [[dic objectForKey:DICKEY] intValue];
            switch (key)
            {
                case 1:
                {
                    [dic setValue:[self getTimeLabelText] forKey:DICNUMBER];
                }
                    break;
                case 2:
                {
                    [dic setValue:stepNumber forKey:DICNUMBER];
                }
                    break;
                case 3:
                {
                    [dic setValue:heartRate forKey:DICNUMBER];
                }
                    break;
                case 4:
                {
                    [dic setValue:_avgPace forKey:DICNUMBER];
                }
                    break;
                case 5:
                {
                    [dic setValue:mileageNumber forKey:DICNUMBER];
                }
                    break;
                default:
                {
                }
                    break;
            }
        }
        [self refreshPaneSimple:_dictionaryArray];
    }
}
//保存时期和 运动时间
-(void)saveTarget
{
    NSString *currentDateStr = [[[NSDate alloc]init] dateWithYMDHMS];
    _sportDate = [currentDateStr substringToIndex:10];
    _fromTime = currentDateStr;
    //adaLog(@"currentDateStr - %@",currentDateStr);
}
//定位方法，定位  回到原来的位置
-(void)startLocationAction
{
    //    _locInt = 3;
    
    [_mapView setCenterCoordinate:_mapView.userLocation.location.coordinate animated:YES];
    MKCoordinateRegion region ;//表示范围的结构体
    region.center = self.mapView.centerCoordinate;//中心点
    region.span.latitudeDelta = 0.005029;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region.span.longitudeDelta = 0.003181;//纬度范围
    [self.mapView setRegion:region animated:YES];
    
}

//关闭地图 的界面
-(void)closeMapBtnAction
{
    [UIView animateWithDuration:1.0 animations:^{
        _viewMapPack.frame = CGRectMake(_mapImageViewX,_mapImageViewY+7*HeightProportion,_mapImageViewW,_mapImageViewW);
        _viewMapPack.layer.cornerRadius = _mapImageViewW/2;
        //        CGFloat mapViewX = 0;//CurrentDeviceWidth;
        //        CGFloat mapViewY = 20;
        //        CGFloat mapViewW = _mapImageViewW;//CurrentDeviceWidth;
        //        CGFloat mapViewH = _mapImageViewH;//CurrentDeviceHeight - 20;
        //        _mapView.frame = CGRectMake(mapViewX, mapViewY, mapViewW, mapViewH);
    } completion:^(BOOL finished) {
        [self.view sendSubviewToBack:_viewMapPack];
        _viewMapPack.hidden = YES;
    }];
    
}

//移动到地图的界面
-(void)mapBtnAction
{
    if (_viewMapPack.width==CurrentDeviceWidth)
    {
        CGFloat viewMapPackX = _mapImageViewX;
        CGFloat viewMapPackY = _mapImageViewY+7*HeightProportion;
        CGFloat viewMapPackW = _mapImageViewW;
        CGFloat viewMapPackH = _mapImageViewW;
        
        _viewMapPack.frame=CGRectMake(viewMapPackX,viewMapPackY,viewMapPackW,viewMapPackH);
    }
    //_locInt = 1;
    _locIntUse = 1;
    _viewMapPack.hidden = NO;
    [self.view bringSubviewToFront:_viewMapPack];
    [UIView animateWithDuration:1.0f animations:^{
        _viewMapPack.frame = CGRectMake(0,20,CurrentDeviceWidth,CurrentDeviceHeight-20);
        //        CGFloat mapViewX = 0;//CurrentDeviceWidth;
        //        CGFloat mapViewY = 20;
        //        CGFloat mapViewW = CurrentDeviceWidth;
        //        CGFloat mapViewH = CurrentDeviceHeight - 20;
        //        _mapView.frame = CGRectMake(mapViewX, mapViewY, mapViewW, mapViewH);
    }completion:^(BOOL finished) {
        _viewMapPack.layer.cornerRadius = 0;
    }];
    
    [self startLocationAction];
}
-(void)voiceBtnAction
{
    _voiceBtn.userInteractionEnabled = NO;
    [self performSelectorOnMainThread:@selector(voiceBtnActionDelay) withObject:nil waitUntilDone:YES];
    NSInteger voiceNum = [[ADASaveDefaluts objectForKey:MAPVOICEISOPEN] integerValue];
    if (voiceNum!=2)
    {
        [ADASaveDefaluts setObject:@"2" forKey:MAPVOICEISOPEN];
        _voiceImageView.image = [UIImage imageNamed:@"map_voiceClose"];
    }
    else
    {
        [ADASaveDefaluts setObject:@"1" forKey:MAPVOICEISOPEN];
        _voiceImageView.image = [UIImage imageNamed:@"map_voiceOpen"];
    }
    
}
-(void)voiceBtnActionDelay
{
    _voiceBtn.userInteractionEnabled = YES;
}
-(void)suspendBtningAction
{
    //adaLog(@"  -- -- 暂停");
    // [self.navigationController popViewControllerAnimated:YES];
    // [_locationMutableArray addObjectsFromArray:@[@"22.58928,113.98515",@"22.7,113.98515"]];
    [self.localManager stopUpdatingLocation];
    [[CositeaBlueTooth sharedInstance] closeHeartRate:^(int number) {
//        if (number)//adaLog(@"  成功关闭在线运动 number  - -  %d",number);
    }];
    
    SportDetailMapViewController *detail = [[SportDetailMapViewController alloc]init];
    detail.locationMutableArray = _locationMutableArray;
    detail.dictionaryArray = _dictionaryArray;
    detail.heartArray = _heartArray;
    detail.kcalNumberPlus= _kcalNumberPlus;
    detail.progressDet = _progress;
    detail.fromTime = _fromTime;
    detail.isStoreMap =  _isStoreMap;
    detail.sportTypeDic = _sportTypeDic;
    [self.navigationController pushViewController:detail animated:YES];
    _mapView.showsUserLocation = NO;
    [self storage];     // 保存 运动 数据
}
// 保存 运动 数据
-(void)storage
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//    NSInteger  count= [[SQLdataManger getInstance] queryHeartRateDataWithAll];
//    if (count>0)
//    {[dictionary setValue:[NSString stringWithFormat:@"%02ld",count] forKey:@"sportID"];}
//    else
//    {
//        [dictionary setValue:@"0" forKey:@"sportID"];
//    }
    NSString *count = [AllTool getSportIDMax:[[SQLdataManger getInstance] queryMaxSportID]];
    [dictionary setValue:count forKey:@"sportID"];
    
    NSString *step = [NSString stringWithFormat:@"%ld",_stepNumberPlus];
    NSString *kcal = [NSString stringWithFormat:@"%ld",_kcalNumberPlus];
    NSData *heartData = [NSKeyedArchiver archivedDataWithRootObject:[AllTool seconedTominute:_heartArray]];//在线运动的心率转到分钟再存储。
    [dictionary setValue:[[HCHCommonManager getInstance]UserAcount] forKey:CurrentUserName_HCH];
    
    [dictionary setValue:[_sportTypeDic objectForKey:SPORTTYPENUMBER] forKey:@"sportType"];
    [dictionary setValue:[_sportTypeDic objectForKey:SPORTTYPETITLE] forKey:@"sportName"];
    [dictionary setValue:_sportDate forKey:@"sportDate"];
    [dictionary setValue:_fromTime forKey:@"fromTime"];
    _toTime = [[TimeCallManager getInstance] timeAdditionWithTimeString:_fromTime andSeconed:_progress];
    [dictionary setValue:_toTime forKey:@"toTime"];
    [dictionary setValue:step forKey:@"stepNumber"];
    [dictionary setValue:kcal forKey:@"kcalNumber"];
    [dictionary setValue:heartData forKey:@"heartRate"];
    NSString *deviceType =  [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
    NSString *deviceId = [AllTool amendMacAddressGetAddress];
    
    [dictionary setValue:deviceId forKey:DEVICEID];
    [dictionary setValue:deviceType forKey:DEVICETYPE];
    [dictionary setValue:@"0" forKey:ISUP];
    
    NSData *trail = [NSKeyedArchiver archivedDataWithRootObject:_locationMutableArray];//轨迹
    [dictionary setValue:@"1" forKey:HAVETRAIL];
    [dictionary setValue:trail forKey:TRAILARRAY];
    [dictionary setValue:_targetTime forKey:MOVETARGET];
    [dictionary setValue:[NSString stringWithFormat:@"%ld",_mileageNumberPlus] forKey:MILEAGEM];
    [dictionary setValue:@"0" forKey:MILEAGEM_MAP];
    [dictionary setValue:_avgPace forKey:SPORTPACE];
    [dictionary setValue:[NSString stringWithFormat:@"%ld",_progress] forKey:WHENLONG];
    
    [[SQLdataManger getInstance] insertDataWithColumns:dictionary toTableName:@"ONLINESPORT"];
}
-(void)ContinueBtningAction
{
    //adaLog(@"  -- -- 继续");
    if (self.isStoreMap)
    {
        _pauseFlag = NO;
    }
    [self playMusicRenew];//播放音乐- - - 暂停
    //开启定时器
    [self.timerGetheartRate setFireDate:[NSDate distantPast]];
    [UIView animateWithDuration:1.0f animations:^{
        _suspendImage.hidden = YES;
        _suspendBtning.hidden = YES;
        _ContinueImage.hidden = YES;
        _ContinueBtning.hidden = YES;
        [_back sendSubviewToBack:_suspendImage];
        [_back sendSubviewToBack:_suspendBtning];
        [_back sendSubviewToBack:_ContinueImage];
        [_back sendSubviewToBack:_ContinueBtning];
    } completion:^(BOOL finished) {
        _btnImage.hidden = NO;
        _btnCircle.hidden = NO;
        _btning.hidden = NO;
        [_back bringSubviewToFront:_btnImage];
        [_back bringSubviewToFront:_btnCircle];
        [_back bringSubviewToFront:_btning];
    }];
    
}
#pragma mark   --- 按钮的各种事件
- (void)buttonAction:(id)sender forEvent:(UIEvent *)event{
    UITouchPhase phase = event.allTouches.anyObject.phase;
    if (phase == UITouchPhaseBegan)
    {
        if(!self.time)
        {
            //adaLog(@"press");
            self.time = [NSTimer scheduledTimerWithTimeInterval:0.001f target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
            //        _pro.percent = 0;
            _btnCircle.percent = 0;
        }
        else
        {
            if (self.time.isValid){
                [self.time invalidate];   self.time = nil;
                //                _pro.percent = 0;
                _btnCircle.percent = 0;
            }
            //adaLog(@"press");
            self.time = [NSTimer scheduledTimerWithTimeInterval:0.001f target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
            //        _pro.percent = 0;
            _btnCircle.percent = 0;
        }
    }
    else if(phase == UITouchPhaseStationary)
    {
        //adaLog(@"Station");
    }
    else if(phase == UITouchPhaseEnded)
    {
        //adaLog(@"release");
        if (self.time) {
            if (self.time.isValid){
                [self.time invalidate];   self.time = nil;
                //                _pro.percent = 0;
                _btnCircle.percent = 0;
            }
        }
    }
    else if(phase == UITouchPhaseCancelled)
    {
        //adaLog(@"PhaseCancel");
    }
    else if(phase == UITouchPhaseMoved)
    {
        //adaLog(@"PhaseMove");
    }
}
-(void)timeAction
{
    if (_btnCircle.percent >1)
    {
        _btnCircle.percent = 1;
        if (self.time)
        {
            //adaLog(@"可以在这里触发事件了。");
            [self playMusicSuspen];//播放音乐- - - 暂停
            if (self.time.isValid){
                [self.time invalidate];   self.time = nil;
            }
            [UIView animateWithDuration:1.0f animations:^{
                _btnImage.hidden = YES;
                _btnCircle.hidden = YES;
                _btning.hidden = YES;
                [_back sendSubviewToBack:_btnImage];
                [_back sendSubviewToBack:_btnCircle];
                [_back sendSubviewToBack:_btning];
                _btnCircle.percent = 0;
            } completion:^(BOOL finished) {
                _suspendImage.hidden = NO;
                _suspendBtning.hidden = NO;
                _suspendBtning.userInteractionEnabled = NO;
                _ContinueImage.hidden = NO;
                _ContinueBtning.hidden = NO;
                _ContinueBtning.userInteractionEnabled = NO;
                [_back bringSubviewToFront:_suspendImage];
                [_back bringSubviewToFront:_suspendBtning];
                [_back bringSubviewToFront:_ContinueImage];
                [_back bringSubviewToFront:_ContinueBtning];
            }];
            
            _pauseFlag = YES;
            //关闭定时器
            [self.timerGetheartRate setFireDate:[NSDate distantFuture]];
            [self timerActionMap];
        }
        
        return;
    }
    //    _pro.percent = _pro.percent + 1.0/9.0;
    _btnCircle.percent = _btnCircle.percent  + 1.0/900.0;
    
}

//获取属性字符串
- (NSMutableAttributedString *)makeAttributedStringWithnumBer:(NSString *)number Unit:(NSString *)unit WithFont:(int)font
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:number];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, attributeString.length)];
    if(![unit isEqualToString:@"hehe"])
    {
        NSMutableAttributedString *unitString = [[NSMutableAttributedString alloc] initWithString:unit];
        [unitString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font/2] range:NSMakeRange(0, unitString.length)];
        [attributeString appendAttributedString:unitString];
    }
    return attributeString;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --  AVAudioPlayer  --  播放完毕
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //adaLog(@"  ===  = 播放完毕");
    
    if (!_suspendBtning.userInteractionEnabled)
    {
        _suspendBtning.userInteractionEnabled = YES;
        _ContinueBtning.userInteractionEnabled = YES;
        
        
        //adaLog(@"暂停开始使用、");
    }
    else
    {
    }
    [_audioSession setActive:NO error:nil];
}
#pragma mark -- 后台播放被打断, 继续恢复播放 (比如打电话...)
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    [self.audioPlayer play];
}

#pragma mark - MKMapViewDelegate   -- 自带地图
/**
 更新用户位置，只要用户改变则调用此方法（包括第一次定位到用户位置）
 第一种画轨迹的方法:我们使用在地图上的变化来描绘轨迹,这种方式不用考虑从 CLLocationManager 取出的经纬度在 mapView 上显示有偏差的问题
 */
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    NSString *locationString;
    if (_locationMutableArray.count<=0)
    {
        // NSString *latitude = [NSString stringWithFormat:@"%3.05f",userLocation.coordinate.latitude];
        // NSString *longitude = [NSString stringWithFormat:@"%3.05f",userLocation.coordinate.longitude];
        //adaLog(@"mapView == 更新的用户位置:纬度:%@, 经度:%@",latitude,longitude);
        
        //存放位置的数组,如果数组包含的对象个数为0,那么说明是第一次进入,将当前的位置添加到位置数组
        locationString  = [NSString stringWithFormat:@"%3.05f,%3.05f",userLocation.coordinate.latitude, userLocation.coordinate.longitude];
        [_startLocArray addObject:locationString];
        
        if (_startLocArray.count>=3)
        {
            if (_locationMutableArray.count == 0)
            {
                [_locationMutableArray addObject:locationString];
            }
            
        }
        if (_progress >= 3)
        {
            if (_locationMutableArray.count == 0)
            {
                [_locationMutableArray addObject:locationString];
            }
            
        }
        
    }
}


-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    
    if ([overlay isKindOfClass:[MKPolyline class]]){
#pragma clang diagnostic
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        MKPolylineView *polyLineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        polyLineView.lineWidth = 10; //折线宽度
        polyLineView.strokeColor = [UIColor blueColor]; //折线颜色
        //        polyLineView.lineDashPhase = 2;
        //        overlayView.lineDashPattern = ;
        //        polyLineView.lineJoin = kCGLineJoinBevel;
        return (MKOverlayRenderer *)polyLineView;
#pragma clang diagnostic pop
    }
    return nil;
}


#pragma mark - CLLocationManagerDelegate
/**
 *  当前定位授权状态发生改变时调用
 *
 *  @param manager 位置管理者
 *  @param status  授权的状态
 */
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:{
            //adaLog(@"用户还未进行授权");
            break;
        }
        case kCLAuthorizationStatusDenied:{
            // 判断当前设备是否支持定位和定位服务是否开启
            if([CLLocationManager locationServicesEnabled]){
                //adaLog(@"用户不允许程序访问位置信息或者手动关闭了位置信息的访问，帮助跳转到设置界面");
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL: url];
                }
            }else{
                //adaLog(@"定位服务关闭,弹出系统的提示框,点击设置可以跳转到定位服务界面进行定位服务的开启");
            }
            break;
        }
        case kCLAuthorizationStatusRestricted:{
            //adaLog(@"受限制的");
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:{
            //adaLog(@"授权允许在前台和后台均可使用定位服务");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:{
            //adaLog(@"授权允许在前台可使用定位服务");
            break;
        }
        default:
            break;
    }
}
/**
 我们并没有把从 CLLocationManager 取出来的经纬度放到 mapView 上显示
 原因:
 我们在此方法中取到的经纬度依据的标准是地球坐标,但是国内的地图显示按照的标准是火星坐标
 MKMapView 不用在做任何的处理,是因为 MKMapView 是已经经过处理的
 也就导致此方法中获取的坐标在 mapView 上显示是有偏差的
 解决的办法有很多种,可以上网就行查询,这里就不再多做赘述
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    // 说明:由于开启了“无限后台”的外挂模式(^-^)所以可以直接写操作代码，然后系统默认在任何情况执行，但是为了已读，规划代码如下
    // 1、活跃状态
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        //adaLog(@"UIApplicationStateActive  == state");
    }else if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
        // 2、后台模式
    {
        //adaLog(@"UIApplicationStateBackground  == state");
    }
    // 3、不活跃模式
    else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
    {
        //adaLog(@"UIApplicationStateInactive  == state");
    }
    
    //adaLog(@"locationManager     = = =位置更新");
    
    // 设备的当前位置
    CLLocation *currLocation = [locations lastObject];
//    NSString *latitude = [NSString stringWithFormat:@"纬度:%3.05f",currLocation.coordinate.latitude];
//    NSString *longitude = [NSString stringWithFormat:@"经度:%3.05f",currLocation.coordinate.longitude];
    //adaLog(@"位置发生改变:纬度:%@,经度:%@",latitude,longitude);
    //adaLog(@"_locInt = %ld",_locInt);
    
    
    //判断是不是属于国内范围
    BOOL ischina = [[ZCChinaLocation shared]isInsideChina:[currLocation coordinate]];
    //adaLog(@"ischina == %d",ischina);
    //    ![WGS84TOGCJ02 isLocationOutOfChina:[currLocation coordinate]]
    if (ischina)
    {
        //转换后的coord
        CLLocationCoordinate2D coordGCJ = [WGS84TOGCJ02 transformFromWGSToGCJ:[currLocation coordinate]];
        if (_locInt>0)
        {
            _locInt--;
            CLLocationCoordinate2D center = coordGCJ;
            MKCoordinateSpan span = MKCoordinateSpanMake(0.005029,0.003181);//(0.2509, 0.2256);
            MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
            [self.mapView setRegion:region animated:YES];
            return;
        }
        if (_locIntUse>0)
        {
            _locIntUse--;
            CLLocationCoordinate2D center = coordGCJ;
            MKCoordinateSpan span = MKCoordinateSpanMake(0.005029,0.003181);//(0.2509, 0.2256);
            MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
            [self.mapView setRegion:region animated:YES];
        }
        
        if(_progress - _proWarpLoc>5)
        {
            _proWarpLoc = _progress;
            CLLocationCoordinate2D center = coordGCJ;
            MKCoordinateSpan span = MKCoordinateSpanMake(0.005029,0.003181);//(0.2509, 0.2256);
            MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
            [self.mapView setRegion:region animated:YES];
        }
        if (_locationMutableArray.count != 0)
        {
            
            //从位置数组中取出最新的位置数据
            NSString *locationStr = _locationMutableArray.lastObject;
            NSArray *temp = [locationStr componentsSeparatedByString:@","];
            NSString *latitudeStr = temp[0];
            NSString *longitudeStr = temp[1];
            CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake([latitudeStr doubleValue], [longitudeStr doubleValue]);
            
            //当前确定到的位置数据
            CLLocationCoordinate2D endCoordinate;
            endCoordinate.latitude = coordGCJ.latitude;
            endCoordinate.longitude = coordGCJ.longitude;
            
            //移动距离的计算
            //            double meters = [self calculateDistanceWithStart:startCoordinate end:endCoordinate];
            CLLocation *startLoc = [[CLLocation alloc] initWithLatitude:[latitudeStr doubleValue] longitude:[longitudeStr doubleValue]];
            CLLocation *endLoc = [[CLLocation alloc] initWithLatitude:coordGCJ.latitude longitude:coordGCJ.longitude];
            double meters = [startLoc distanceFromLocation:endLoc];
            //adaLog(@"移动的距离为%f米",meters);
            
            //为了美化移动的轨迹,移动的位置超过10米,方可添加进位置的数组
            if (meters >= 10)
            {
                
                //adaLog(@"添加进位置数组");
                [self takeMapData:meters];
                NSString *locationString = [NSString stringWithFormat:@"%3.05f,%3.05f",coordGCJ.latitude,coordGCJ.longitude];
                [_locationMutableArray addObject:locationString];
                
                //开始绘制轨迹
                CLLocationCoordinate2D pointsToUse[2];
                pointsToUse[0] = startCoordinate;
                pointsToUse[1] = endCoordinate;
                //调用 addOverlay 方法后,会进入 rendererForOverlay 方法,完成轨迹的绘制
                MKPolyline *lineOne = [MKPolyline polylineWithCoordinates:pointsToUse count:2];
                [_mapView addOverlay:lineOne];
                
            }
            else
            {
                //adaLog(@"不添加进位置数组");
            }
        }
        else
        {
            if(_progress>5)
            {
                if (_locationMutableArray.count == 0)
                {
                    //存放位置的数组,如果数组包含的对象个数为0,那么说明是第一次进入,将当前的位置添加到位置数组
                    NSString *locationString = [NSString stringWithFormat:@"%3.05f,%3.05f",currLocation.coordinate.latitude,currLocation.coordinate.longitude];
                    [_locationMutableArray addObject:locationString];
                }
            }
        }
        
    }
    else
    {
        if (_locInt>0)
        {
            _locInt--;
            CLLocationCoordinate2D center = currLocation.coordinate;
            MKCoordinateSpan span = MKCoordinateSpanMake(0.005029,0.003181);//(0.2509, 0.2256);
            MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
            [self.mapView setRegion:region animated:YES];
            return;
        }
        if (_locIntUse>0)
        {
            _locIntUse--;
            CLLocationCoordinate2D center = currLocation.coordinate;
            MKCoordinateSpan span = MKCoordinateSpanMake(0.005029,0.003181);//(0.2509, 0.2256);
            MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
            [self.mapView setRegion:region animated:YES];
        }
        if(_progress - _proWarpLoc>5)
        {
            _proWarpLoc = _progress;
            CLLocationCoordinate2D center = currLocation.coordinate;
            MKCoordinateSpan span = MKCoordinateSpanMake(0.005029,0.003181);//(0.2509, 0.2256);
            MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
            [self.mapView setRegion:region animated:YES];
        }
        
        if (_locationMutableArray.count != 0)
        {
            
            //从位置数组中取出最新的位置数据
            NSString *locationStr = _locationMutableArray.lastObject;
            NSArray *temp = [locationStr componentsSeparatedByString:@","];
            NSString *latitudeStr = temp.firstObject;
            NSString *longitudeStr = temp.lastObject;
            CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake([latitudeStr doubleValue], [longitudeStr doubleValue]);
            
            //当前确定到的位置数据
            CLLocationCoordinate2D endCoordinate;
            endCoordinate.latitude = currLocation.coordinate.latitude;
            endCoordinate.longitude = currLocation.coordinate.longitude;
            
            //移动距离的计算
            CLLocation *startLoc = [[CLLocation alloc] initWithLatitude:[latitudeStr doubleValue] longitude:[longitudeStr doubleValue]];
            CLLocation *endLoc = [[CLLocation alloc] initWithLatitude:currLocation.coordinate.latitude longitude:currLocation.coordinate.longitude];
            double meters = [startLoc distanceFromLocation:endLoc];
            
            //            double meters = [self calculateDistanceWithStart:startCoordinate end:endCoordinate];
            //adaLog(@"移动的距离为%f米",meters);
            
            //为了美化移动的轨迹,移动的位置超过10米,方可添加进位置的数组
            if (meters >= 10)
            {
                [self takeMapData:meters];
                //adaLog(@"添加进位置数组");
                NSString *locationString = [NSString stringWithFormat:@"%3.05f,%3.05f",currLocation.coordinate.latitude, currLocation.coordinate.longitude];
                [_locationMutableArray addObject:locationString];
                
                //开始绘制轨迹
                CLLocationCoordinate2D pointsToUse[2];
                pointsToUse[0] = startCoordinate;
                pointsToUse[1] = endCoordinate;
                //调用 addOverlay 方法后,会进入 rendererForOverlay 方法,完成轨迹的绘制
                MKPolyline *lineOne = [MKPolyline polylineWithCoordinates:pointsToUse count:2];
                [_mapView addOverlay:lineOne];
                
            }
            else
            {
                //adaLog(@"不添加进位置数组");
            }
        }
        else
        {
            if(_progress>5)
            {
                if (_locationMutableArray.count == 0)
                {
                    //存放位置的数组,如果数组包含的对象个数为0,那么说明是第一次进入,将当前的位置添加到位置数组
                    NSString *locationString = [NSString stringWithFormat:@"%3.05f,%3.05f",currLocation.coordinate.latitude,currLocation.coordinate.longitude];
                    [_locationMutableArray addObject:locationString];
                }
            }
        }
        
    }
}
-(void)takeMapData:(NSInteger)mileage
{
    if (self.isStoreMap)
    {
        //adaLog(@"取出地图数据");
        if(!_pauseFlag)
        {
            for (int i=0; i<_dictionaryArray.count; i++)
            {
                NSMutableDictionary *dic = _dictionaryArray[i];
                int key = [[dic objectForKey:DICKEY] intValue];
                switch (key)
                {
                    case 5:
                    {
                        NSInteger milea = [[dic objectForKey:DICNUMBER] integerValue];
                        NSInteger mi = milea+mileage;
                        [dic setValue:[NSString stringWithFormat:@"%ld",mi] forKey:DICNUMBER];
                        _mileageNumberPlus = mi;
                        _avgPace = [AllTool pacewithTime:_progress andRice:_mileageNumberPlus];
                    }
                        break;
                    default:
                    {
                    }
                        break;
                }
            }
            for (int i=0; i<_dictionaryArray.count; i++)
            {
                NSMutableDictionary *dic = _dictionaryArray[i];
                int key = [[dic objectForKey:DICKEY] intValue];
                switch (key)
                {
                    case 4:
                    {
                        [dic setValue:_avgPace forKey:DICNUMBER];
                    }
                        break;
                    default:
                    {
                    }
                        break;
                }
            }
        }
    }
}
//定位失败的回调方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //adaLog(@"无法获取当前位置 error : %@",error.localizedDescription);
}


#pragma mark - 距离测算
- (double)calculateDistanceWithStart:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end
{
    double meter = 0;
    
    double startLongitude = start.longitude;
    double startLatitude = start.latitude;
    double endLongitude = end.longitude;
    double endLatitude = end.latitude;
    
    double radLatitude1 = startLatitude * M_PI / 180.0;
    double radLatitude2 = endLatitude * M_PI / 180.0;
    double a = fabs(radLatitude1 - radLatitude2);
    double b = fabs(startLongitude * M_PI / 180.0 - endLongitude * M_PI / 180.0);
    
    double s = 2 * asin(sqrt(pow(sin(a/2),2) + cos(radLatitude1) * cos(radLatitude2) * pow(sin(b/2),2)));
    s = s * 6378137;
    meter = round(s * 10000) / 10000;
    //    CLLocation *lastLocation = [[CLLocation alloc] initWithLatitude:0 longitude:0];
    //    CLLocation *nowLocation = [[CLLocation alloc] initWithLatitude:0 longitude:0];
    //    int distanceMeters = [lastLocation distanceFromLocation:nowLocation];
    return meter;
}



#pragma  -- mark  -- 懒加载

-(NSMutableArray *)sportNodeArray
{
    if (!_sportNodeArray)
    {
        _sportNodeArray = [NSMutableArray array];
    }
    return _sportNodeArray;
}

#pragma mark - 位置管理者懒加载
- (CLLocationManager *)localManager
{
    if (_localManager == nil)
    {
        _localManager = [[CLLocationManager alloc]init];
        //设置定位的精度
        [_localManager setDesiredAccuracy:kCLLocationAccuracyBest];
        //位置信息更新最小距离
        _localManager.distanceFilter = 10;
        //设置代理
        _localManager.delegate = self;
        //如果没有授权则请求用户授权,
        //因为 requestAlwaysAuthorization 是 iOS8 后提出的,需要添加一个是否能响应的条件判断,防止崩溃
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined && [_localManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_localManager requestAlwaysAuthorization];
        }
        
    }
    return _localManager;
}
@end

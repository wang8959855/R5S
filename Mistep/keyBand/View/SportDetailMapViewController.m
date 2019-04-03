//定义颜色
#define HEARTCHARTBLUE @"0639f6"
#define HEARTCHARTRED @"ff3930"
#define HEARTCHARTZITI @"333333"
#define SPORTTYPENUMBER  @"SPORTTYPENUMBER"
#define SPORTTYPETITLE  @"SPORTTYPETIME"


#define kColor(x,y,z) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1]
//#define CurrentDeviceWidth  [UIScreen mainScreen].bounds.size.width
//#define CurrentDeviceHeight [UIScreen mainScreen].bounds.size.height
//#define WidthProportion  CurrentDeviceWidth / 375
//#define HeightProportion  CurrentDeviceHeight / 667
#define downBackColor  UIColorFromHexAlpha(0xf4f4f4,0.6) //kColor(230, 230, 230)
#define fontNumber   13
#define fontNumberDa   27
#define calculateHeart 220
// 1.key 2.图 - image 3.数值 - number 4.单位 - unit 5.名称 - name
// DICKEY  -- 1 - 时长- 2 - 计步- 3 - 心率- 4 - 步速- 5 - 里程
#define DICKEY @"key"
#define DICIMAGE @"image"
#define DICNUMBER @"number"
#define DICUNIT @"unit"
#define DICNAME @"name"


#import "SportDetailMapViewController.h"
#import "ADAChart.h"
#import "SectorView.h"
//导入定位和地图的两个框架
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MapTool.h"
#import "NSAttributedString+appendAttributedString.h"

@interface SportDetailMapViewController ()<UIScrollViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate>


@property (nonatomic,strong)UIButton *trailViewButton;//轨迹 按钮
@property (nonatomic,strong)UIButton *detailViewButton;//详情 按钮
@property (nonatomic,strong)UIButton *chartViewButton;//图表 按钮
@property (nonatomic,strong)UIScrollView *scrollView;//总的滚动的图 按钮
@property (nonatomic,strong)UIScrollView *chartScrollView;

//@property (nonatomic,strong)NSArray *heartArray;
//@property (nonatomic,strong) NSMutableArray *heartArray;
@property (strong,nonatomic) UIScrollView *heartScrollView;
@property (strong,nonatomic) ADAChart *heartChart;
//@property (assign, nonatomic) NSInteger progress;//进度  -- 秒数
@property (nonatomic,strong)UILabel *labelTwoSeconed;//心率区间  label

@property (nonatomic,strong)UILabel *labelTwoThird;
@property (nonatomic,strong)UILabel *labelTwoFourth;
@property (nonatomic,strong)UILabel *labelTwoFifth;
@property (nonatomic,strong)UILabel *labelTwoSixth;
@property (nonatomic,strong)UILabel *labelThirdSeconed;//时长label

@property (nonatomic,strong)UILabel *labelThirdThird;
@property (nonatomic,strong)UILabel *labelThirdFourth;
@property (nonatomic,strong)UILabel *labelThirdFifth;
@property (nonatomic,strong)UILabel *labelThirdSixth;
@property (nonatomic,strong)UILabel *labelFourthSeconed;//百分比  label

@property (nonatomic,strong)UILabel *labelFourthThird;
@property (nonatomic,strong)UILabel *labelFourthFourth;
@property (nonatomic,strong)UILabel *labelFourthFifth;
@property (nonatomic,strong)UILabel *labelFourthSixth;

@property (nonatomic,assign) NSInteger limit;   //时长  number
@property (nonatomic,assign) NSInteger anaerobic;
@property (nonatomic,assign) NSInteger aerobic;
@property (nonatomic,assign) NSInteger fatBurning;
@property (nonatomic,assign) NSInteger warmUp;

@property (nonatomic, strong) MKMapView *mapViewDetail; //地图
@property (nonatomic, strong) CLLocationManager *localManage;//位置管理者
@property (nonatomic,assign) int locint;//定位三次

@property (nonatomic, strong) UILabel *timelength;//时长
@property (nonatomic, strong) UILabel *downStepLabel;//步数
@property (nonatomic, strong) UILabel *downStepSLabel;//步 速度
@property (nonatomic, strong) UILabel *downmileageLabel;//  下面的  里程

@property (nonatomic, strong) UILabel *stepNumberLab;   //步数
@property (nonatomic, strong) UILabel *paceLab;   //配速
@property (nonatomic, strong) UILabel *kcalLab;   //热量
@property (nonatomic, strong) UILabel *stepsLab;   //步频
@property (nonatomic, strong) UILabel *speedLab;   //速度
@property (nonatomic, strong) UILabel *mileageLab;   //里程
@property (nonatomic, strong) UILabel *heartRateLab;   //心率
@property (nonatomic, strong) UILabel *stepLengthLab;   //步长
@property (nonatomic, strong) UILabel *ClimbLab;   //累计爬升
@property (nonatomic, strong) SectorView *sector;//饼图

@end

@implementation SportDetailMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViewTotal];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[PSDrawerManager instance] cancelDragResponse];
}
-(void)setupViewTotal
{
    [self setupProperty];
    [self setupView];//视图
    [self setupMapDownView];//地图
    [self setupDetailView];//详细
    [self setupChartView];//图表
    
    //    [self chartViewAction];//图表按钮事件
    [self setupDaohang];//导航条
    
    
}
- (void)setupDaohang
{
    CGFloat headImageViewX = 0;
    CGFloat headImageViewY = 20;
    CGFloat headImageViewW = CurrentDeviceWidth;
    CGFloat headImageViewH = 44;
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(headImageViewX, headImageViewY, headImageViewW, headImageViewH)];
    
    [self.view addSubview:headImageView];
    headImageView.backgroundColor = [UIColor whiteColor];
    headImageView.userInteractionEnabled = YES;
    //    headImageView.image = [UIImage imageNamed:@"导航条阴影"];
    headImageView.backgroundColor = allColorWhite;
    
    
    UIButton *buttonBack = [[UIButton alloc]init];
    [headImageView addSubview:buttonBack];
    
    CGFloat buttonBackX = 0;
    CGFloat buttonBackY = 0;
    CGFloat buttonBackW = 44;
    CGFloat buttonBackH = buttonBackW;
    buttonBack.frame = CGRectMake(buttonBackX, buttonBackY, buttonBackW, buttonBackH);
    [buttonBack setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    //    buttonBack.backgroundColor = [UIColor redColor];
    [buttonBack addTarget:self action:@selector(backSportDetail) forControlEvents:UIControlEventTouchUpInside];
    
    //head  title
    UILabel *headLabel = [[UILabel alloc]init];
    [headImageView addSubview:headLabel];
    
    CGFloat headLabelW = 200;
    CGFloat headLabelH = 30;
    CGFloat headLabelX = (CurrentDeviceWidth - headLabelW)/2.0;
    CGFloat headLabelY = (44 - headLabelH)/2.0;
    headLabel.frame = CGRectMake(headLabelX, headLabelY, headLabelW, headLabelH);
    headLabel.textAlignment = NSTextAlignmentCenter;
    headLabel.text = NSLocalizedString(@"运动详情", nil);
    
    headLabel.text = [_sportTypeDic objectForKey:SPORTTYPETITLE];
}
-(void)setupProperty
{
    
    _heartArray = [AllTool seconedTominute:_heartArray];
    
    //    _heartArray = [NSMutableArray array];
    //    NSArray *array = @[@50,@100,@150,@50,@100,@150,@50,@100,@150,@50];
    //
    //    for (int i=0; i<6; i++)
    //    {
    //        [_heartArray addObjectsFromArray:array];
    //    }
    
    //    for (int i=0; i<6; i++)
    //    {
    //        [_heartArray addObjectsFromArray:array];
    //    }
    //
    //    for (int i=0; i<6; i++)
    //    {
    //        [_heartArray addObjectsFromArray:array];
    //    }
    //
    //    for (int i=0; i<6; i++)
    //    {
    //        [_heartArray addObjectsFromArray:array];
    //    }
    //    for (int i=0; i<6; i++)
    //    {
    //        [_heartArray addObjectsFromArray:array];
    //    }
    
}
-(void)setupView
{
    self.view.backgroundColor = [UIColor blackColor];
    
    UIView *totalView = [[UIView alloc]init];
    [self.view addSubview:totalView];
    CGFloat totalViewX = 0;
    CGFloat totalViewY = 64;
    CGFloat totalViewW = CurrentDeviceWidth;
    CGFloat totalViewH = CurrentDeviceHeight -totalViewY;
    totalView.frame = CGRectMake(totalViewX, totalViewY, totalViewW, totalViewH);
    totalView.backgroundColor =[UIColor whiteColor];
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = CurrentDeviceWidth/3.0;
    CGFloat btnH = 38*HeightProportion;
    for (int i=0; i<3; i++)
    {
        btnX = i*btnW;
        
        UIButton *btn = [[UIButton alloc]init];
        [totalView addSubview:btn];
        btn.backgroundColor = [UIColor whiteColor];
        //        [btn setBackgroundColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 0.5*WidthProportion;
        //btn.titleLabel.textColor = [UIColor blackColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"greenB"] forState:UIControlStateSelected];
        
        switch (i) {
                // trail  detail   chart
            case 0:
            {
                [btn setTitle:NSLocalizedString(@"轨迹", nil) forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(trailViewAction) forControlEvents:UIControlEventTouchUpInside];
                btn.selected = YES;
                _trailViewButton = btn;
            }
                break;
            case 1:
            {
                [btn setTitle:NSLocalizedString(@"详情", nil) forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(detailViewAction) forControlEvents:UIControlEventTouchUpInside];
                _detailViewButton = btn;
            }
                break;
            case 2:
            {
                [btn setTitle:NSLocalizedString(@"图表", nil) forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(chartViewAction) forControlEvents:UIControlEventTouchUpInside];
                _chartViewButton = btn;
            }
                break;
            default:
                break;
        }
        
    }
    
    self.scrollView = [[UIScrollView alloc]init];
    [totalView addSubview:self.scrollView];
    CGFloat  scrollViewX = 0;
    CGFloat  scrollViewY =  btnH;
    CGFloat  scrollViewW = CurrentDeviceWidth;
    CGFloat  scrollViewH = totalViewH -scrollViewY;
    self.scrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH);
    self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.delegate = self;
    // 设置内容大小
    self.scrollView.contentSize = CGSizeMake(CurrentDeviceWidth*3.0,0);
    // 是否反弹
    self.scrollView.bounces = NO;
    // 是否分页
    self.scrollView.pagingEnabled = YES;
    // 是否滚动
    self.scrollView.scrollEnabled = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
}
//轨迹按钮事件
-(void)trailViewAction
{
    _trailViewButton.selected = YES;
    _detailViewButton.selected = NO;
    _chartViewButton.selected = NO;
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
//详情按钮事件
-(void)detailViewAction
{
    _trailViewButton.selected = NO;
    _detailViewButton.selected = YES;
    _chartViewButton.selected = NO;
    [self.scrollView setContentOffset:CGPointMake(CurrentDeviceWidth, 0) animated:YES];
    
}
//图表按钮事件
-(void)chartViewAction
{
    _trailViewButton.selected = NO;
    _detailViewButton.selected = NO;
    _chartViewButton.selected = YES;
    [self.scrollView setContentOffset:CGPointMake(CurrentDeviceWidth*2.0, 0) animated:YES];
    
}

-(void)setupChartView
{
    UIView *chartView = [[UIView alloc]init];
    [self.scrollView addSubview:chartView];
    chartView.backgroundColor = [UIColor whiteColor];
    
    CGFloat  chartViewX = CurrentDeviceWidth*2.0;
    CGFloat  chartViewY = self.scrollView.bounds.origin.y;
    CGFloat  chartViewW = CurrentDeviceWidth;
    CGFloat  chartViewH = self.scrollView.bounds.size.height;
    chartView.frame = CGRectMake(chartViewX, chartViewY, chartViewW, chartViewH);
    
    
    
    self.chartScrollView = [[UIScrollView alloc]init];
    [chartView addSubview:self.chartScrollView];
    //    CGFloat  chartScrollViewX = CurrentDeviceWidth*2;
    //    CGFloat  chartScrollViewY = self.scrollView.bounds.origin.y;
    //    CGFloat  chartScrollViewW = CurrentDeviceWidth;
    //    CGFloat  chartScrollViewH = self.scrollView.bounds.size.height;
    CGFloat  chartScrollViewX = 0;
    CGFloat  chartScrollViewY = 0;
    CGFloat  chartScrollViewW = CurrentDeviceWidth;
    CGFloat  chartScrollViewH = self.scrollView.bounds.size.height;
    self.chartScrollView.frame = CGRectMake(chartScrollViewX, chartScrollViewY, chartScrollViewW, chartScrollViewH);
    self.chartScrollView.backgroundColor = [UIColor cyanColor];
    self.chartScrollView.delegate = self;
    // 设置内容大小
    self.chartScrollView.contentSize = CGSizeMake(0,chartScrollViewH);
    // 是否反弹
    self.chartScrollView.bounces = NO;
    // 是否分页
    self.chartScrollView.pagingEnabled = NO;
    // 是否滚动
    self.chartScrollView.scrollEnabled = YES;
    self.chartScrollView.showsHorizontalScrollIndicator = NO;
    //    self.chartScrollView.showsVerticalScrollIndicator = NO;
    
    [self setupSportHeart];
    
}
-(void)setupSportHeart
{
    
    //第一  心率曲线
    
    UIView *sportHeartPack = [[UIView alloc]init];
    [self.chartScrollView  addSubview:sportHeartPack];
    CGFloat sportHeartPackX = 0;
    CGFloat sportHeartPackY = 0;
    CGFloat sportHeartPackW = CurrentDeviceWidth;
    CGFloat sportHeartPackH = 230.0*HeightProportion;
    sportHeartPack.frame = CGRectMake(sportHeartPackX, sportHeartPackY, sportHeartPackW, sportHeartPackH);
    sportHeartPack.backgroundColor = [UIColor whiteColor];
    
    UIView *sportHeart = [[UIView alloc]init];
    [sportHeartPack  addSubview:sportHeart];
    CGFloat sportHeartX = 20*WidthProportion;
    CGFloat sportHeartY = 10*HeightProportion;
    CGFloat sportHeartW = CurrentDeviceWidth-sportHeartX*2;
    CGFloat sportHeartH = sportHeartPackH - sportHeartY;
    sportHeart.frame = CGRectMake(sportHeartX, sportHeartY, sportHeartW, sportHeartH);
    sportHeart.backgroundColor = UIColorFromHexAlpha(0xf4f4f4,0.6);//[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:0.2];//[UIColor lightGrayColor];
    
    //运动心率
    UILabel *heartRateName = [[UILabel alloc]init];
    [sportHeart addSubview:heartRateName];
    
    heartRateName.backgroundColor = [ColorTool getColor:HEARTCHARTBLUE];//[UIColor blueColor];
    heartRateName.text = NSLocalizedString(@"运动心率", nil);
    heartRateName.textColor = [UIColor whiteColor];
    heartRateName.layer.cornerRadius = 5;
    heartRateName.layer.masksToBounds = YES;
    heartRateName.font = [UIFont systemFontOfSize:13*WidthProportion];
    heartRateName.textAlignment = NSTextAlignmentCenter;
    
    CGFloat heartRateNameX = 10*WidthProportion;
    CGFloat heartRateNameY = 16*HeightProportion;
    CGFloat heartRateNameW = 70*WidthProportion;
    CGFloat heartRateNameH = 22*HeightProportion;
    heartRateName.frame = CGRectMake(heartRateNameX, heartRateNameY, heartRateNameW, heartRateNameH);
    
    //平均心率
    UILabel *AverageHeartLabel = [[UILabel alloc]init];
    [sportHeart addSubview:AverageHeartLabel];
    
    AverageHeartLabel.backgroundColor = [UIColor clearColor];
    AverageHeartLabel.text = NSLocalizedString(@"平均心率", nil);
    AverageHeartLabel.font = [UIFont systemFontOfSize:12*WidthProportion];
    AverageHeartLabel.textAlignment = NSTextAlignmentRight;
    
    CGFloat AverageHeartLabelX = 150*WidthProportion;
    CGFloat AverageHeartLabelY = 8*HeightProportion;
    CGFloat AverageHeartLabelW = 120*WidthProportion;
    CGFloat AverageHeartLabelH = 20*HeightProportion;
    AverageHeartLabel.frame = CGRectMake(AverageHeartLabelX, AverageHeartLabelY, AverageHeartLabelW, AverageHeartLabelH);
    
    UILabel *AverageHeartNumLabel = [[UILabel alloc]init];
    [sportHeart addSubview:AverageHeartNumLabel];
    AverageHeartNumLabel.backgroundColor = [UIColor clearColor];
    AverageHeartNumLabel.text = @"--";
    AverageHeartNumLabel.textColor = [ColorTool getColor:HEARTCHARTBLUE];//[UIColor blueColor];
    AverageHeartNumLabel.font = [UIFont systemFontOfSize:20*WidthProportion];
    AverageHeartNumLabel.textAlignment = NSTextAlignmentLeft;
    
    CGFloat AverageHeartNumLabelX = CGRectGetMaxX(AverageHeartLabel.frame)+5*WidthProportion;
    CGFloat AverageHeartNumLabelY = AverageHeartLabelY;
    CGFloat AverageHeartNumLabelW = sportHeartW - AverageHeartLabelX-AverageHeartLabelW;
    CGFloat AverageHeartNumLabelH = 30*HeightProportion;
    AverageHeartNumLabel.frame = CGRectMake(AverageHeartNumLabelX, AverageHeartNumLabelY, AverageHeartNumLabelW, AverageHeartNumLabelH);
    AverageHeartNumLabel.centerY = AverageHeartLabel.centerY;
    
    //  最高心率
    UILabel *highestHeartLabel = [[UILabel alloc]init];
    [sportHeart addSubview:highestHeartLabel];
    
    highestHeartLabel.backgroundColor = [UIColor clearColor];
    highestHeartLabel.text = NSLocalizedString(@"最高心率", nil);
    highestHeartLabel.font = [UIFont systemFontOfSize:12*WidthProportion];
    highestHeartLabel.textAlignment = NSTextAlignmentRight;
    
    CGFloat highestHeartLabelX = AverageHeartLabelX;
    CGFloat highestHeartLabelY = 35*HeightProportion;
    CGFloat highestHeartLabelW = AverageHeartLabelW;
    CGFloat highestHeartLabelH = AverageHeartLabelH;
    highestHeartLabel.frame = CGRectMake(highestHeartLabelX, highestHeartLabelY, highestHeartLabelW, highestHeartLabelH);
    
    UILabel *highestHeartNumLabel = [[UILabel alloc]init];
    [sportHeart addSubview:highestHeartNumLabel];
    highestHeartNumLabel.backgroundColor = [UIColor clearColor];
    highestHeartNumLabel.text = @"--";
    highestHeartNumLabel.textColor = [ColorTool getColor:HEARTCHARTRED];//[UIColor redColor];
    highestHeartNumLabel.font = [UIFont systemFontOfSize:20*WidthProportion];
    highestHeartNumLabel.textAlignment = NSTextAlignmentLeft;
    
    CGFloat highestHeartNumLabelX = CGRectGetMaxX(highestHeartLabel.frame)+5*WidthProportion;
    CGFloat highestHeartNumLabelY = highestHeartLabelY;
    CGFloat highestHeartNumLabelW = sportHeartW - highestHeartLabelX-highestHeartLabelW;
    CGFloat highestHeartNumLabelH = 30*HeightProportion;
    highestHeartNumLabel.frame = CGRectMake(highestHeartNumLabelX, highestHeartNumLabelY, highestHeartNumLabelW, highestHeartNumLabelH);
    highestHeartNumLabel.centerY = highestHeartLabel.centerY;
    
    
    AverageHeartNumLabel.text = [AllTool getMean:_heartArray];
    highestHeartNumLabel.text = [AllTool getMax:_heartArray];
#pragma mark  --- 线条的高度
    
    //设置预警区    --   调整线条的高度
    NSArray *HRAlarmArray = [[NSUserDefaults standardUserDefaults] objectForKey:kHeartRateAlarm];
    int maxHR = 160;
    int minHR = 40;
    if (HRAlarmArray)
    {
        maxHR = [HRAlarmArray[1] intValue];
        minHR = [HRAlarmArray[0] intValue];
    }
    
    //开始建设     线条
    UIImageView *lineImageView220 = [[UIImageView alloc] init];
    [sportHeart addSubview:lineImageView220];
    lineImageView220.image = [UIImage imageNamed:@"XQ_pointLine"];
    lineImageView220.contentMode = UIViewContentModeScaleToFill;
    CGFloat lineImageView220X = 30*WidthProportion;
    CGFloat lineImageView220Y = 70*HeightProportion;
    CGFloat lineImageView220W = sportHeartW-lineImageView220X-5*WidthProportion;
    CGFloat lineImageView220H = 1;
    lineImageView220.frame = CGRectMake(lineImageView220X,lineImageView220Y,lineImageView220W, lineImageView220H);
    //    130   220
    CGFloat countNumber = (130.0*HeightProportion)/220.0;
    
    UIImageView *lineImageView200 = [[UIImageView alloc] init];
    [sportHeart addSubview:lineImageView200];
    lineImageView200.image = [UIImage imageNamed:@"XQ_pointLine"];
    lineImageView200.contentMode = UIViewContentModeScaleToFill;
    CGFloat lineImageView200X = lineImageView220X;
    CGFloat lineImageView200Y = lineImageView220Y+(220-maxHR)*countNumber;
    CGFloat lineImageView200W = lineImageView220W;//sportHeartW-lineImageView200X-5*WidthProportion;
    CGFloat lineImageView200H = 1;
    lineImageView200.frame = CGRectMake(lineImageView200X,lineImageView200Y,lineImageView200W, lineImageView200H);
    
    //    UIImageView *lineImageView150 = [[UIImageView alloc] init];
    //    [sportHeart addSubview:lineImageView150];
    //    lineImageView150.image = [UIImage imageNamed:@"XQ_pointLine"];
    //    lineImageView150.contentMode = UIViewContentModeScaleToFill;
    //    CGFloat lineImageView150X = lineImageView220X;
    //    CGFloat lineImageView150Y = lineImageView220Y+70*countNumber;
    //    CGFloat lineImageView150W = lineImageView220W;//sportHeartW-lineImageView150X-5*WidthProportion;
    //    CGFloat lineImageView150H = 1;
    //    lineImageView150.frame = CGRectMake(lineImageView150X,lineImageView150Y,lineImageView150W, lineImageView150H);
    
    
    UIImageView *lineImageView100 = [[UIImageView alloc] init];
    [sportHeart addSubview:lineImageView100];
    lineImageView100.image = [UIImage imageNamed:@"XQ_pointLine"];
    lineImageView100.contentMode = UIViewContentModeScaleToFill;
    CGFloat lineImageView100X = lineImageView220X;
    CGFloat lineImageView100Y = lineImageView220Y+120*countNumber;
    CGFloat lineImageView100W = lineImageView220W;//sportHeartW-lineImageView100X-5*WidthProportion;
    CGFloat lineImageView100H = 1;
    lineImageView100.frame = CGRectMake(lineImageView100X,lineImageView100Y,lineImageView100W, lineImageView100H);
    
    UIImageView *lineImageView50 = [[UIImageView alloc] init];
    [sportHeart addSubview:lineImageView50];
    lineImageView50.image = [UIImage imageNamed:@"XQ_pointLine"];
    lineImageView50.contentMode = UIViewContentModeScaleToFill;
    CGFloat lineImageView50X = lineImageView220X;
    CGFloat lineImageView50Y = lineImageView220Y+(220-minHR)*countNumber;
    CGFloat lineImageView50W = lineImageView220W;//sportHeartW-lineImageView50X-5*WidthProportion;
    CGFloat lineImageView50H = 1;
    lineImageView50.frame = CGRectMake(lineImageView50X,lineImageView50Y,lineImageView50W, lineImageView50H);
    
    UIImageView *lineImageView0 = [[UIImageView alloc] init];
    [sportHeart addSubview:lineImageView0];
    lineImageView0.image = [UIImage imageNamed:@"XQ_pointLine"];
    lineImageView0.contentMode = UIViewContentModeScaleToFill;
    CGFloat lineImageView0X = lineImageView220X;
    CGFloat lineImageView0Y = lineImageView220Y+220*countNumber;
    CGFloat lineImageView0W = lineImageView220W;//sportHeartW-lineImageView0X-5*WidthProportion;
    CGFloat lineImageView0H = 1;
    lineImageView0.frame = CGRectMake(lineImageView0X,lineImageView0Y,lineImageView0W, lineImageView0H);
    
    
    //对线条值的标注
    UILabel *heart220 = [[UILabel alloc] init];
    [sportHeart addSubview:heart220];
    heart220.textColor = [UIColor grayColor];
    heart220.text = @"220";
    heart220.font = [UIFont systemFontOfSize:10*WidthProportion];
    heart220.textAlignment = NSTextAlignmentCenter;
    CGFloat heart220X = 0;
    CGFloat heart220W = lineImageView220X;
    CGFloat heart220H = 20*HeightProportion;
    CGFloat heart220Y = lineImageView220Y-heart220H/2.0;
    heart220.frame = CGRectMake(heart220X,heart220Y,heart220W,heart220H);
    
    UILabel *heart200 = [[UILabel alloc] init];
    [sportHeart addSubview:heart200];
    heart200.textColor = [UIColor grayColor];
    heart200.text = [NSString stringWithFormat:@"%d",maxHR];//@"200";
    heart200.font = [UIFont systemFontOfSize:10*WidthProportion];
    heart200.textAlignment = NSTextAlignmentCenter;
    CGFloat heart200X = 0;
    CGFloat heart200W = heart220W;
    CGFloat heart200H = heart220H;
    CGFloat heart200Y = lineImageView200Y-heart200H/2.0;
    heart200.frame = CGRectMake(heart200X,heart200Y,heart200W,heart200H);
    
    //    UILabel *heart150 = [[UILabel alloc] init];
    //    [sportHeart addSubview:heart150];
    //    heart150.textColor = [UIColor grayColor];
    //    heart150.text = @"150";
    //    heart150.font = [UIFont systemFontOfSize:10*WidthProportion];
    //    heart150.textAlignment = NSTextAlignmentCenter;
    //    CGFloat heart150X = 0;
    //    CGFloat heart150W = heart220W;
    //    CGFloat heart150H = heart220H;
    //    CGFloat heart150Y = lineImageView150Y-heart150H/2;
    //    heart150.frame = CGRectMake(heart150X,heart150Y,heart150W,heart150H);
    
    
    UILabel *heart100 = [[UILabel alloc] init];
    [sportHeart addSubview:heart100];
    heart100.textColor = [UIColor grayColor];
    heart100.text = @"100";
    heart100.font = [UIFont systemFontOfSize:10*WidthProportion];
    heart100.textAlignment = NSTextAlignmentCenter;
    CGFloat heart100X = 0;
    CGFloat heart100W = heart220W;
    CGFloat heart100H = heart220H;
    CGFloat heart100Y = lineImageView100Y-heart100H/2;
    heart100.frame = CGRectMake(heart100X,heart100Y,heart100W,heart100H);
    
    
    UILabel *heart50 = [[UILabel alloc] init];
    [sportHeart addSubview:heart50];
    heart50.textColor = [UIColor grayColor];
    heart50.text = [NSString stringWithFormat:@"%d",minHR];//@"50";
    heart50.font = [UIFont systemFontOfSize:10*WidthProportion];
    heart50.textAlignment = NSTextAlignmentCenter;
    CGFloat heart50X = 0;
    CGFloat heart50W = heart220W;
    CGFloat heart50H = heart220H;
    CGFloat heart50Y = lineImageView50Y-heart50H/2.0;
    heart50.frame = CGRectMake(heart50X,heart50Y,heart50W,heart50H);
    
    
    UILabel *heart0 = [[UILabel alloc] init];
    [sportHeart addSubview:heart0];
    heart0.textColor = [UIColor grayColor];
    heart0.text = @"0";
    heart0.font = [UIFont systemFontOfSize:10*WidthProportion];
    heart0.textAlignment = NSTextAlignmentCenter;
    CGFloat heart0X = 0;
    CGFloat heart0W = heart220W;
    CGFloat heart0H = heart220H;
    CGFloat heart0Y = lineImageView0Y-heart0H/2.0;
    heart0.frame = CGRectMake(heart0X,heart0Y,heart0W,heart0H);
    
    
    //    heart220.centerX = lineImageView220.centerX;
    self.heartScrollView = [[UIScrollView alloc] init];
    self.heartScrollView.frame = CGRectMake(0, 0,sportHeart.bounds.size.width,sportHeart.bounds.size.height);
    self.heartScrollView.showsHorizontalScrollIndicator = NO;
    self.heartScrollView.bounces = NO;
    [sportHeart addSubview:self.heartScrollView];
    
    self.heartScrollView.backgroundColor = [UIColor clearColor];
    //[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2];
    self.heartScrollView.scrollEnabled = YES;
    //    self.heartScrollView.contentSize = CGSizeMake(sportHeartW, sportHeartH);
    
    self.heartChart = [[ADAChart alloc] initWithFrame:CGRectMake(0, 0,0, _heartScrollView.frame.size.height)];//_heartScrollView.bounds.size.width
    [self.heartScrollView addSubview:self.heartChart];
    
    self.heartChart.heartArray = _heartArray;
    self.heartScrollView.contentSize=CGSizeMake(_heartArray.count*1.25*WidthProportion, 200*HeightProportion);
    
    //    aa
    //    int hourCount = (int)_heartArray.count / 60;
    //    _progress = 3600;
    int hourCount = (int)_progressDet/3600;
    NSString *timeNum = [NSString string];
    timeNum = [self getTimingLabelText];
    NSString *startTime = [_fromTime substringWithRange:NSMakeRange(11,5)];
    //    @"09:00";
    CGFloat labelX = lineImageView0X;
    CGFloat labelW = lineImageView0W/3;
    CGFloat labelH = 12*HeightProportion;
    CGFloat labelY = lineImageView0Y+5*HeightProportion;
    for (int i=0 ; i<hourCount+1; i++)
    {
        UILabel *label = [[UILabel alloc]init];
        labelX = 30*WidthProportion + lineImageView0W/4*i;
        label.frame = CGRectMake(labelX,labelY,labelW,labelH);
        label.font = [UIFont systemFontOfSize:10*WidthProportion];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];//orangeColor
        if (i==0)
        {
            label.text = startTime;
        }
        else
        {
            NSInteger hour = [[startTime substringToIndex:2] integerValue]+1;
            NSInteger min = [[startTime substringFromIndex:3] integerValue]+1;
            label.text = [NSString stringWithFormat:@"%ld:%ld",hour,min];
        }
        [self.heartScrollView addSubview:label];
    }
    
    
    UILabel *dayWarningLabel1 = [[UILabel alloc] init];
    dayWarningLabel1.text = NSLocalizedString(@"预警区", nil);
    dayWarningLabel1.font = [UIFont systemFontOfSize:12*WidthProportion];
    dayWarningLabel1.textColor = [ColorTool getColor:HEARTCHARTRED];
    //[UIColor colorWithRed:254/255.0 green:40/255.0 blue:42/255.0 alpha:0.6];
    [sportHeart addSubview:dayWarningLabel1];
    
    CGFloat lab1X = 30*WidthProportion;
    CGFloat lab1Y = lineImageView220Y;
    CGFloat lab1W = sportHeart.width-lab1X;
    CGFloat lab1H = (220-maxHR)*countNumber;
    dayWarningLabel1.frame = CGRectMake(lab1X,lab1Y,lab1W,lab1H);
    
    
    UILabel *dayWarningLabel2 = [[UILabel alloc] init];
    dayWarningLabel2.text = NSLocalizedString(@"预警区", nil);
    dayWarningLabel2.textColor = [ColorTool getColor:HEARTCHARTRED];
    //[UIColor colorWithRed:254/255.0 green:40/255.0 blue:42/255.0 alpha:0.6];
    dayWarningLabel2.font = [UIFont systemFontOfSize:12*WidthProportion];
    [sportHeart addSubview:dayWarningLabel2];
    
    CGFloat lab2X = lab1X;
    CGFloat lab2Y = lineImageView220Y + (220-minHR)*countNumber;
    CGFloat lab2W = sportHeart.width-lab2X;
    CGFloat lab2H = minHR*countNumber;
    dayWarningLabel2.frame = CGRectMake(lab2X,lab2Y,lab2W,lab2H);
    
    
    //第二   饼图
    UIView *sectorView = [[UIView alloc]init];
    sectorView.backgroundColor = [UIColor whiteColor];
    [self.chartScrollView  addSubview:sectorView];
    
    CGFloat sectorViewX = 0;
    CGFloat sectorViewY = sportHeartPackH;
    CGFloat sectorViewW = CurrentDeviceWidth;
    CGFloat sectorViewH = 210*HeightProportion;
    sectorView.frame = CGRectMake(sectorViewX,sectorViewY,sectorViewW,sectorViewH);
    
    SectorView *sector = [[SectorView alloc]init];
    _sector = sector;
    [sectorView addSubview:sector];
    CGFloat sectorX = 0;
    CGFloat sectorY = 0;
    CGFloat sectorW = CurrentDeviceWidth;
    CGFloat sectorH = sectorViewH;
    sector.frame = CGRectMake(sectorX,sectorY,sectorW,sectorH);
    //    sector.sectorArray = @[@0.1,@0.2,@0.3,@0.2,@0.2];
    
    [self setupDownView];
}

-(void)setupDownView
{
    UIView *DownView = [[UIView alloc]init];
    [self.chartScrollView addSubview:DownView];
    DownView.backgroundColor = [UIColor whiteColor];
    
    CGFloat DownViewX = 0;
    CGFloat DownViewW = CurrentDeviceWidth;
    CGFloat DownViewH = 250*HeightProportion;
    CGFloat DownViewY = 440*HeightProportion;
    DownView.frame = CGRectMake(DownViewX, DownViewY, DownViewW, DownViewH);
    
    CGFloat marginX = 10;
    CGFloat marginY = 5;
    
    //第一条
    UIView *oneView = [[UIView alloc]init];
    [DownView addSubview:oneView];
    oneView.backgroundColor = downBackColor;
    //[UIColor whiteColor];
    
    CGFloat imageVW = 28;
    CGFloat marginDuo = 20;
    
    
    CGFloat oneViewX = marginX;
    CGFloat oneViewY = 0;
    CGFloat oneViewW = CurrentDeviceWidth - 2 * oneViewX;
    CGFloat oneViewH = (DownViewH - 10 - 25) / 6;
    oneView.frame = CGRectMake(oneViewX, oneViewY, oneViewW, oneViewH);
    
    UILabel *labelOne = [[UILabel alloc]init];
    [oneView addSubview:labelOne];
    labelOne.backgroundColor = [UIColor clearColor];
    labelOne.textAlignment = NSTextAlignmentCenter;
    labelOne.text = NSLocalizedString(@"运动类型", nil);
    labelOne.font = [UIFont systemFontOfSize:fontNumber];
    
    CGFloat labelOneX = imageVW;
    CGFloat labelOneY = 0;
    CGFloat labelOneW = (oneView.bounds.size.width  - imageVW)/ 4;
    CGFloat labelOneH = oneView.bounds.size.height;
    labelOne.frame = CGRectMake(labelOneX, labelOneY, labelOneW, labelOneH);
    
    UILabel *labelTwo = [[UILabel alloc]init];
    [oneView addSubview:labelTwo];
    //    labelTwo.backgroundColor = [UIColor greenColor];
    labelTwo.textAlignment = NSTextAlignmentCenter;
    labelTwo.text = NSLocalizedString(@"心率区间", nil);
    labelTwo.font = [UIFont systemFontOfSize:fontNumber];
    
    CGFloat labelTwoX = CGRectGetMaxX(labelOne.frame);
    CGFloat labelTwoY = 0;
    CGFloat labelTwoW = labelOneW + marginDuo;
    CGFloat labelTwoH = oneView.bounds.size.height;
    labelTwo.frame = CGRectMake(labelTwoX, labelTwoY, labelTwoW, labelTwoH);
    
    UILabel *labelThird = [[UILabel alloc]init];
    [oneView addSubview:labelThird];
    labelThird.backgroundColor = [UIColor clearColor];
    labelThird.textAlignment = NSTextAlignmentCenter;
    labelThird.text = NSLocalizedString(@"时长", nil);
    labelThird.font = [UIFont systemFontOfSize:fontNumber];
    
    CGFloat labelThirdX = CGRectGetMaxX(labelTwo.frame);
    CGFloat labelThirdY = 0;
    CGFloat labelThirdW = (oneView.bounds.size.width  - CGRectGetMaxX(labelTwo.frame)) / 2;
    CGFloat labelThirdH = oneView.bounds.size.height;
    labelThird.frame = CGRectMake(labelThirdX, labelThirdY, labelThirdW, labelThirdH);
    
    UILabel *labelFourth = [[UILabel alloc]init];
    [oneView addSubview:labelFourth];
    labelFourth.backgroundColor = [UIColor clearColor];
    labelFourth.textAlignment = NSTextAlignmentCenter;
    labelFourth.text = NSLocalizedString(@"百分比", nil);
    labelFourth.font = [UIFont systemFontOfSize:fontNumber];
    
    CGFloat labelFourthX = CGRectGetMaxX(labelThird.frame);
    CGFloat labelFourthY = 0;
    CGFloat labelFourthW = labelThirdW;
    CGFloat labelFourthH = oneView.bounds.size.height;
    labelFourth.frame = CGRectMake(labelFourthX, labelFourthY, labelFourthW, labelFourthH);
    
    //第二条
    UIView *seconedView = [[UIView alloc]init];
    [DownView addSubview:seconedView];
    seconedView.backgroundColor = downBackColor;
    
    CGFloat seconedViewX = oneViewX;
    CGFloat seconedViewY = CGRectGetMaxY(oneView.frame) + marginY;
    CGFloat seconedViewW = oneViewW;
    CGFloat seconedViewH = oneViewH;
    seconedView.frame = CGRectMake(seconedViewX, seconedViewY, seconedViewW, seconedViewH);
    
    //第二条  前图
    UIImageView *imageV = [[UIImageView alloc]init];
    [seconedView addSubview:imageV];
    imageV.image = [UIImage imageNamed:@"map_warmup"];//热身
    imageV.backgroundColor = [UIColor clearColor];
    CGFloat imageVX = 0;
    //    CGFloat imageVW = 28;
    CGFloat imageVH = 23;
    CGFloat imageVY = (seconedViewH - imageVH)/2;
    imageV.frame = CGRectMake(imageVX, imageVY, imageVW, imageVH);
    
    
    UILabel *labelOneSeconed = [[UILabel alloc]init];
    [seconedView addSubview:labelOneSeconed];
    labelOneSeconed.backgroundColor = [UIColor clearColor];
    labelOneSeconed.textAlignment = NSTextAlignmentCenter;
    labelOneSeconed.text = NSLocalizedString(@"热身", nil);
    labelOneSeconed.font = [UIFont systemFontOfSize:fontNumber];
    CGFloat labelOneSeconedX = imageVW;
    CGFloat labelOneSeconedY = 0;
    CGFloat labelOneSeconedW = (seconedViewW - imageVW) / 4 ;
    CGFloat labelOneSeconedH = oneView.bounds.size.height;
    labelOneSeconed.frame = CGRectMake(labelOneSeconedX, labelOneSeconedY, labelOneSeconedW, labelOneSeconedH);
    
    UILabel *labelTwoSeconed = [[UILabel alloc]init];
    [seconedView addSubview:labelTwoSeconed];
    _labelTwoSeconed = labelTwoSeconed;
    //    labelTwoSeconed.backgroundColor = [UIColor greenColor];
    labelTwoSeconed.textAlignment = NSTextAlignmentCenter;
    labelTwoSeconed.text = @"<=150bpm";
    labelTwoSeconed.font = [UIFont systemFontOfSize:fontNumber];
    CGFloat labelTwoSeconedX = CGRectGetMaxX(labelOneSeconed.frame);
    CGFloat labelTwoSeconedY = 0;
    CGFloat labelTwoSeconedW = labelTwoW;
    CGFloat labelTwoSeconedH = oneView.bounds.size.height;
    labelTwoSeconed.frame = CGRectMake(labelTwoSeconedX, labelTwoSeconedY, labelTwoSeconedW, labelTwoSeconedH);
    
    UILabel *labelThirdSeconed = [[UILabel alloc]init];
    [seconedView addSubview:labelThirdSeconed];
    _labelThirdSeconed = labelThirdSeconed;
    labelThirdSeconed.backgroundColor = [UIColor clearColor];
    labelThirdSeconed.textAlignment = NSTextAlignmentCenter;
    labelThirdSeconed.text = @"0min";
    labelThirdSeconed.font = [UIFont systemFontOfSize:fontNumber];
    CGFloat labelThirdSeconedX = labelThirdX;
    CGFloat labelThirdSeconedY = 0;
    CGFloat labelThirdSeconedW = labelThirdW;
    CGFloat labelThirdSeconedH = oneView.bounds.size.height;
    labelThirdSeconed.frame = CGRectMake(labelThirdSeconedX, labelThirdSeconedY, labelThirdSeconedW, labelThirdSeconedH);
    
    UILabel *labelFourthSeconed = [[UILabel alloc]init];
    [seconedView addSubview:labelFourthSeconed];
    _labelFourthSeconed = labelFourthSeconed;
    labelFourthSeconed.backgroundColor = [UIColor clearColor];
    labelFourthSeconed.textAlignment = NSTextAlignmentCenter;
    labelFourthSeconed.text = @"0%";
    labelFourthSeconed.font = [UIFont systemFontOfSize:fontNumber];
    CGFloat labelFourthSeconedX = CGRectGetMaxX(labelThirdSeconed.frame);
    CGFloat labelFourthSeconedY = 0;
    CGFloat labelFourthSeconedW = labelThirdSeconedW;
    CGFloat labelFourthSeconedH = oneView.bounds.size.height;
    labelFourthSeconed.frame = CGRectMake(labelFourthSeconedX, labelFourthSeconedY, labelFourthSeconedW, labelFourthSeconedH);
    
    
    //第三条
    UIView *thirdView = [[UIView alloc]init];
    [DownView addSubview:thirdView];
    thirdView.backgroundColor = downBackColor;
    CGFloat thirdViewX = seconedViewX;
    CGFloat thirdViewY = CGRectGetMaxY(seconedView.frame) + marginY;
    CGFloat thirdViewW = seconedViewW;
    CGFloat thirdViewH = seconedViewH;
    thirdView.frame = CGRectMake(thirdViewX, thirdViewY, thirdViewW, thirdViewH);
    
    //第三条  前图
    UIImageView *imageVthird = [[UIImageView alloc]init];
    [thirdView addSubview:imageVthird];
    imageVthird.image = [UIImage imageNamed:@"FatBurning_map"];
    imageVthird.backgroundColor = [UIColor clearColor];
    CGFloat imageVthirdX = 0;
    CGFloat imageVthirdW = imageVW;
    CGFloat imageVthirdH = imageVH;
    CGFloat imageVthirdY = (thirdViewH - imageVthirdH)/2;
    imageVthird.frame = CGRectMake(imageVthirdX, imageVthirdY, imageVthirdW, imageVthirdH);
    
    
    UILabel *labelOneThird = [[UILabel alloc]init];
    [thirdView addSubview:labelOneThird];
    labelOneThird.backgroundColor = [UIColor clearColor];
    labelOneThird.textAlignment = NSTextAlignmentCenter;
    labelOneThird.text = NSLocalizedString(@"燃脂", nil);
    labelOneThird.font = [UIFont systemFontOfSize:fontNumber];
    CGFloat labelOneThirdX = imageVW;
    CGFloat labelOneThirdY = 0;
    CGFloat labelOneThirdW = (thirdViewW - imageVthirdW) / 4 ;
    CGFloat labelOneThirdH = oneView.bounds.size.height;
    labelOneThird.frame = CGRectMake(labelOneThirdX, labelOneThirdY, labelOneThirdW, labelOneThirdH);
    
    UILabel *labelTwoThird = [[UILabel alloc]init];
    [thirdView addSubview:labelTwoThird];
    _labelTwoThird = labelTwoThird;
    //    labelTwoThird.backgroundColor = [UIColor greenColor];
    labelTwoThird.textAlignment = NSTextAlignmentCenter;
    labelTwoThird.text = @"115-130bpm";
    labelTwoThird.font = [UIFont systemFontOfSize:fontNumber];
    CGFloat labelTwoThirdX = CGRectGetMaxX(labelOneThird.frame);
    CGFloat labelTwoThirdY = 0;
    CGFloat labelTwoThirdW = labelTwoW;
    CGFloat labelTwoThirdH = oneView.bounds.size.height;
    labelTwoThird.frame = CGRectMake(labelTwoThirdX, labelTwoThirdY, labelTwoThirdW, labelTwoThirdH);
    
    UILabel *labelThirdThird = [[UILabel alloc]init];
    [thirdView addSubview:labelThirdThird];
    _labelThirdThird = labelThirdThird;
    labelThirdThird.backgroundColor = [UIColor clearColor];
    labelThirdThird.textAlignment = NSTextAlignmentCenter;
    labelThirdThird.text = @"0min";
    labelThirdThird.font = [UIFont systemFontOfSize:fontNumber];
    CGFloat labelThirdThirdX =  labelThirdX;
    CGFloat labelThirdThirdY = 0;
    CGFloat labelThirdThirdW = labelThirdW;
    CGFloat labelThirdThirdH = oneView.bounds.size.height;
    labelThirdThird.frame = CGRectMake(labelThirdThirdX, labelThirdThirdY, labelThirdThirdW, labelThirdThirdH);
    
    UILabel *labelFourthThird = [[UILabel alloc]init];
    [thirdView addSubview:labelFourthThird];
    _labelFourthThird = labelFourthThird;
    labelFourthThird.backgroundColor = [UIColor clearColor];
    labelFourthThird.textAlignment = NSTextAlignmentCenter;
    labelFourthThird.text = @"0%";
    labelFourthThird.font = [UIFont systemFontOfSize:fontNumber];
    CGFloat labelFourthThirdX = CGRectGetMaxX(labelThirdThird.frame);
    CGFloat labelFourthThirdY = 0;
    CGFloat labelFourthThirdW = labelThirdThirdW;
    CGFloat labelFourthThirdH = oneView.bounds.size.height;
    labelFourthThird.frame = CGRectMake(labelFourthThirdX, labelFourthThirdY, labelFourthThirdW, labelFourthThirdH);
    
    
    //第四条
    UIView *fourthView = [[UIView alloc]init];
    [DownView addSubview:fourthView];
    fourthView.backgroundColor = downBackColor;
    CGFloat fourthViewX = thirdViewX;
    CGFloat fourthViewY = CGRectGetMaxY(thirdView.frame) + marginY;
    CGFloat fourthViewW = thirdViewW;
    CGFloat fourthViewH = thirdViewH;
    fourthView.frame = CGRectMake(fourthViewX, fourthViewY, fourthViewW, fourthViewH);
    
    //第四条  前图
    UIImageView *imageVFourth = [[UIImageView alloc]init];
    [fourthView addSubview:imageVFourth];
    imageVFourth.image = [UIImage imageNamed:@"map_youyang"];
    imageVFourth.backgroundColor = [UIColor clearColor];
    CGFloat imageVFourthX = 0;
    CGFloat imageVFourthW = imageVW;
    CGFloat imageVFourthH = imageVH;
    CGFloat imageVFourthY = (fourthViewH - imageVFourthH)/2;
    imageVFourth.frame = CGRectMake(imageVFourthX, imageVFourthY, imageVFourthW, imageVFourthH);
    
    
    UILabel *labelOneFourth = [[UILabel alloc]init];
    [fourthView addSubview:labelOneFourth];
    labelOneFourth.backgroundColor = [UIColor clearColor];
    labelOneFourth.textAlignment = NSTextAlignmentCenter;
    labelOneFourth.text = NSLocalizedString(@"有氧", nil);
    labelOneFourth.font = [UIFont systemFontOfSize:fontNumber];
    CGFloat labelOneFourthX = imageVW;
    CGFloat labelOneFourthY = 0;
    CGFloat labelOneFourthW = (fourthViewW - imageVFourthW) / 4 ;
    CGFloat labelOneFourthH = oneView.bounds.size.height;
    labelOneFourth.frame = CGRectMake(labelOneFourthX, labelOneFourthY, labelOneFourthW, labelOneFourthH);
    
    UILabel *labelTwoFourth = [[UILabel alloc]init];
    [fourthView addSubview:labelTwoFourth];
    _labelTwoFourth = labelTwoFourth;
    labelTwoFourth.backgroundColor = [UIColor clearColor];
    labelTwoFourth.textAlignment = NSTextAlignmentCenter;
    labelTwoFourth.text = @"130-150bpm";
    labelTwoFourth.font = [UIFont systemFontOfSize:fontNumber];
    CGFloat labelTwoFourthX = CGRectGetMaxX(labelOneFourth.frame);
    CGFloat labelTwoFourthY = 0;
    CGFloat labelTwoFourthW = labelTwoW;
    CGFloat labelTwoFourthH = oneView.bounds.size.height;
    labelTwoFourth.frame = CGRectMake(labelTwoFourthX, labelTwoFourthY, labelTwoFourthW, labelTwoFourthH);
    
    UILabel *labelThirdFourth = [[UILabel alloc]init];
    [fourthView addSubview:labelThirdFourth];
    _labelThirdFourth = labelThirdFourth;
    labelThirdFourth.backgroundColor = [UIColor clearColor];
    labelThirdFourth.textAlignment = NSTextAlignmentCenter;
    labelThirdFourth.text = @"0min";
    labelThirdFourth.font = [UIFont systemFontOfSize:fontNumber];
    CGFloat labelThirdFourthX = labelThirdX;
    CGFloat labelThirdFourthY = 0;
    CGFloat labelThirdFourthW = labelThirdW;
    CGFloat labelThirdFourthH = oneView.bounds.size.height;
    labelThirdFourth.frame = CGRectMake(labelThirdFourthX, labelThirdFourthY, labelThirdFourthW, labelThirdFourthH);
    
    UILabel *labelFourthFourth = [[UILabel alloc]init];
    [fourthView addSubview:labelFourthFourth];
    _labelFourthFourth = labelFourthFourth;
    labelFourthFourth.backgroundColor = [UIColor clearColor];
    labelFourthFourth.textAlignment = NSTextAlignmentCenter;
    labelFourthFourth.text = @"0%";
    labelFourthFourth.font = [UIFont systemFontOfSize:fontNumber];
    CGFloat labelFourthFourthX = CGRectGetMaxX(labelThirdThird.frame);
    CGFloat labelFourthFourthY = 0;
    CGFloat labelFourthFourthW = labelThirdFourthW;
    CGFloat labelFourthFourthH = oneView.bounds.size.height;
    labelFourthFourth.frame = CGRectMake(labelFourthFourthX, labelFourthFourthY, labelFourthFourthW, labelFourthFourthH);
    
    
    //第五条
    UIView * fifthView = [[UIView alloc]init];
    [DownView addSubview: fifthView];
    fifthView.backgroundColor = downBackColor;
    
    CGFloat fifthViewX = fourthViewX;
    CGFloat fifthViewY = CGRectGetMaxY(fourthView.frame) + marginY;
    CGFloat fifthViewW = fourthViewW;
    CGFloat fifthViewH = fourthViewH;
    fifthView.frame = CGRectMake(fifthViewX, fifthViewY, fifthViewW, fifthViewH);
    
    
    //第五条  前图
    UIImageView *imageVFifth = [[UIImageView alloc]init];
    [fifthView addSubview:imageVFifth];
    imageVFifth.image = [UIImage imageNamed:@"No_oxygen_map"];
    imageVFifth.backgroundColor = [UIColor clearColor];
    CGFloat imageVFifthX = 0;
    CGFloat imageVFifthW = imageVW;
    CGFloat imageVFifthH = imageVH;
    CGFloat imageVFifthY = (fifthViewH - imageVFifthH)/2;
    imageVFifth.frame = CGRectMake(imageVFifthX, imageVFifthY, imageVFifthW, imageVFifthH);
    
    
    UILabel *labelOneFifth = [[UILabel alloc]init];
    [fifthView addSubview:labelOneFifth];
    labelOneFifth.backgroundColor = [UIColor clearColor];
    labelOneFifth.textAlignment = NSTextAlignmentCenter;
    labelOneFifth.text = NSLocalizedString(@"无氧", nil);
    labelOneFifth.font = [UIFont systemFontOfSize:fontNumber];
    CGFloat labelOneFifthX = imageVW;
    CGFloat labelOneFifthY = 0;
    CGFloat labelOneFifthW = (fifthViewW - imageVFourthW) / 4 ;
    CGFloat labelOneFifthH = oneView.bounds.size.height;
    labelOneFifth.frame = CGRectMake(labelOneFifthX, labelOneFifthY, labelOneFifthW, labelOneFifthH);
    
    UILabel *labelTwoFifth = [[UILabel alloc]init];
    [fifthView addSubview:labelTwoFifth];
    _labelTwoFifth = labelTwoFifth;
    labelTwoFifth.backgroundColor = [UIColor clearColor];
    labelTwoFifth.textAlignment = NSTextAlignmentCenter;
    labelTwoFifth.text = @"150-170bpm";
    labelTwoFifth.font = [UIFont systemFontOfSize:fontNumber];
    CGFloat labelTwoFifthX = CGRectGetMaxX(labelOneFourth.frame);
    CGFloat labelTwoFifthY = 0;
    CGFloat labelTwoFifthW = labelTwoW;
    CGFloat labelTwoFifthH = oneView.bounds.size.height;
    labelTwoFifth.frame = CGRectMake(labelTwoFifthX, labelTwoFifthY, labelTwoFifthW, labelTwoFifthH);
    
    UILabel *labelThirdFifth = [[UILabel alloc]init];
    [fifthView addSubview:labelThirdFifth];
    _labelThirdFifth = labelThirdFifth;
    labelThirdFifth.backgroundColor = [UIColor clearColor];
    labelThirdFifth.textAlignment = NSTextAlignmentCenter;
    labelThirdFifth.text = @"0min";
    labelThirdFifth.font = [UIFont systemFontOfSize:fontNumber];
    CGFloat labelThirdFifthX = labelThirdX;
    CGFloat labelThirdFifthY = 0;
    CGFloat labelThirdFifthW = labelThirdW;
    CGFloat labelThirdFifthH = oneView.bounds.size.height;
    labelThirdFifth.frame = CGRectMake(labelThirdFifthX, labelThirdFifthY, labelThirdFifthW, labelThirdFifthH);
    
    UILabel *labelFourthFifth = [[UILabel alloc]init];
    [fifthView addSubview:labelFourthFifth];
    _labelFourthFifth = labelFourthFifth;
    labelFourthFifth.backgroundColor = [UIColor clearColor];
    labelFourthFifth.textAlignment = NSTextAlignmentCenter;
    labelFourthFifth.text = @"0%";
    labelFourthFifth.font = [UIFont systemFontOfSize:fontNumber];
    CGFloat labelFourthFifthX = CGRectGetMaxX(labelThirdThird.frame);
    CGFloat labelFourthFifthY = 0;
    CGFloat labelFourthFifthW = labelThirdThirdW;
    CGFloat labelFourthFifthH = oneView.bounds.size.height;
    labelFourthFifth.frame = CGRectMake(labelFourthFifthX, labelFourthFifthY, labelFourthFifthW, labelFourthFifthH);
    
    //第六条
    UIView *Sixth = [[UIView alloc]init];
    [DownView addSubview:Sixth];
    Sixth.backgroundColor = downBackColor;
    CGFloat SixthX = fifthViewX;
    CGFloat SixthY = CGRectGetMaxY(fifthView.frame) + marginY;
    CGFloat SixthW = fifthViewW;
    CGFloat SixthH = fifthViewH;
    Sixth.frame = CGRectMake(SixthX, SixthY, SixthW, SixthH);
    //第六条  前图
    UIImageView *imageVSixth = [[UIImageView alloc]init];
    [Sixth addSubview:imageVSixth];
    imageVSixth.image = [UIImage imageNamed:@"Limit_map"];
    imageVSixth.backgroundColor = [UIColor clearColor];
    CGFloat imageVSixthX = 0;
    CGFloat imageVSixthW = imageVW;
    CGFloat imageVSixthH = imageVH;
    CGFloat imageVSixthY = (SixthH - imageVSixthH)/2;
    imageVSixth.frame = CGRectMake(imageVSixthX, imageVSixthY, imageVSixthW, imageVSixthH);
    
    
    UILabel *labelOneSixth = [[UILabel alloc]init];
    [Sixth addSubview:labelOneSixth];
    labelOneSixth.backgroundColor = [UIColor clearColor];
    labelOneSixth.textAlignment = NSTextAlignmentCenter;
    labelOneSixth.text = NSLocalizedString(@"极限", nil);
    labelOneSixth.font = [UIFont systemFontOfSize:fontNumber];
    CGFloat labelOneSixthX = imageVW;
    CGFloat labelOneSixthY = 0;
    CGFloat labelOneSixthW = (SixthW - imageVFourthW) / 4 ;
    CGFloat labelOneSixthH = oneView.bounds.size.height;
    labelOneSixth.frame = CGRectMake(labelOneSixthX, labelOneSixthY, labelOneSixthW, labelOneSixthH);
    
    UILabel *labelTwoSixth = [[UILabel alloc]init];
    [Sixth addSubview:labelTwoSixth];
    _labelTwoSixth = labelTwoSixth;
    labelTwoSixth.backgroundColor = [UIColor clearColor];
    labelTwoSixth.textAlignment = NSTextAlignmentCenter;
    labelTwoSixth.text = @"170-190bpm";
    labelTwoSixth.font = [UIFont systemFontOfSize:fontNumber];
    CGFloat labelTwoSixthX = CGRectGetMaxX(labelOneFourth.frame);
    CGFloat labelTwoSixthY = 0;
    CGFloat labelTwoSixthW = labelTwoW;
    CGFloat labelTwoSixthH = oneView.bounds.size.height;
    labelTwoSixth.frame = CGRectMake(labelTwoSixthX, labelTwoSixthY, labelTwoSixthW, labelTwoSixthH);
    
    UILabel *labelThirdSixth = [[UILabel alloc]init];
    [Sixth addSubview:labelThirdSixth];
    _labelThirdSixth = labelThirdSixth;
    labelThirdSixth.backgroundColor = [UIColor clearColor];
    labelThirdSixth.textAlignment = NSTextAlignmentCenter;
    labelThirdSixth.text = @"0min";
    labelThirdSixth.font = [UIFont systemFontOfSize:fontNumber];
    CGFloat labelThirdSixthX = labelThirdX;
    CGFloat labelThirdSixthY = 0;
    CGFloat labelThirdSixthW = labelThirdW;
    CGFloat labelThirdSixthH = oneView.bounds.size.height;
    labelThirdSixth.frame = CGRectMake(labelThirdSixthX, labelThirdSixthY, labelThirdSixthW, labelThirdSixthH);
    
    UILabel *labelFourthSixth = [[UILabel alloc]init];
    [Sixth addSubview:labelFourthSixth];
    _labelFourthSixth = labelFourthSixth;
    labelFourthSixth.backgroundColor = [UIColor clearColor];
    labelFourthSixth.textAlignment = NSTextAlignmentCenter;
    labelFourthSixth.text = @"0%";
    labelFourthSixth.font = [UIFont systemFontOfSize:fontNumber];
    CGFloat labelFourthSixthX = CGRectGetMaxX(labelThirdThird.frame);
    CGFloat labelFourthSixthY = 0;
    CGFloat labelFourthSixthW = labelThirdSixthW;
    CGFloat labelFourthSixthH = oneView.bounds.size.height;
    labelFourthSixth.frame = CGRectMake(labelFourthSixthX, labelFourthSixthY, labelFourthSixthW, labelFourthSixthH);
    
    self.chartScrollView.contentSize = CGSizeMake(0,CGRectGetMaxY(DownView.frame));
    //    self.scrollView.contentSize = CGSizeMake(0,CGRectGetMaxY(DownView.frame));
    [self  setupHeartSection];//心率区间 setupintervalWithDate
}
//心率区间

//心率区间 setup  %02ld
-(void)setupHeartSection
{
    //    _seconedLabeltwo.attributedText = [NSAttributedString  makeAttributedStringWithnumBer:_sport.kcalNumber Unit:@"kcal" WithFont:fontNumberDa];
    /**
     *心率区间
     */
    NSInteger maxHeart,maxHeartOno,maxHeartTwo,maxHeartThree,maxHeartFour;
    maxHeart = calculateHeart - [[HCHCommonManager getInstance]getAge];
    
    maxHeartOno = maxHeart * 90 /100;
    maxHeartTwo = maxHeart * 80 /100;
    maxHeartThree = maxHeart * 70 /100;
    maxHeartFour = maxHeart * 60 /100;
    _labelTwoSixth.attributedText = [NSMutableAttributedString  makeAttributedStringWithnumBer:[NSString stringWithFormat:@">%ld",maxHeartOno] Unit:@"bpm" WithFont:fontNumber];
    _labelTwoFifth.attributedText = [NSMutableAttributedString  makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%ld-%ld",maxHeartTwo,maxHeartOno] Unit:@"bpm" WithFont:fontNumber];
    _labelTwoFourth.attributedText = [NSMutableAttributedString  makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%ld-%ld",maxHeartThree,maxHeartTwo] Unit:@"bpm" WithFont:fontNumber];
    _labelTwoThird.attributedText = [NSMutableAttributedString  makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%ld-%ld",maxHeartFour,maxHeartThree] Unit:@"bpm" WithFont:fontNumber];
    _labelTwoSeconed.attributedText = [NSMutableAttributedString  makeAttributedStringWithnumBer:[NSString stringWithFormat:@"<%ld",maxHeartFour] Unit:@"bpm" WithFont:fontNumber];
    //    //adaLog(@" - %ld _ %ld-%ld _ %ld -%ld",maxHeart,maxHeartOno,maxHeartTwo,maxHeartThree,maxHeartFour);
    
    //从心率数组中取出心率  [AllTool seconedTominute:_sport.heartRateArray];
    //    NSMutableArray *minuteArray =  [NSMutableArray arrayWithArray:_sport.heartRateArray];
    //平均心率  ping jun
    //    _fisrtLabeltwo.attributedText = [NSAttributedString  makeAttributedStringWithnumBer:[AllTool getMean:minuteArray] Unit:NSLocalizedString(@"次/分钟", nil) WithFont:fontNumberDa];
    
//    if ([_mapSport.stepNumber integerValue]==0&&[_mapSport.kcalNumber integerValue]==0)
//    {
//        return;
//    }
    if (_isStoreMap) {
        return;
    }
    
    //   时长
    NSInteger  heartNum = 0;
    for (NSString *heart in _heartArray)
    {
        heartNum = [heart integerValue];
        if(!(heartNum == 20)){
            if(heartNum > maxHeartOno)
            {
                ++_limit;
            }
            else if (heartNum > maxHeartTwo)
            {
                ++_anaerobic;
            }
            else if (heartNum > maxHeartThree)
            {
                ++_aerobic;
            }
            else if (heartNum > maxHeartFour)
            {
                ++_fatBurning;
            }
            else
            {
                ++_warmUp;
            }
        }
    }
    //    NSInteger minZhong =  _progressDet/60.0;
    CGFloat timeTime = (CGFloat)_progressDet/60.0;
    if (timeTime>0&&timeTime<1)
    {
        timeTime = 1;
    }
    NSInteger minZhong =  round(timeTime);
    NSInteger zongshi = _limit+_anaerobic+_aerobic+_fatBurning+_warmUp;
    if (zongshi<minZhong)
    {
        _warmUp += minZhong - zongshi;
    }
    //    else if(zongshi>minZhong)
    //    {
    //        _warmUp -= (zongshi - minZhong);
    //    }
    zongshi = _limit+_anaerobic+_aerobic+_fatBurning+_warmUp;
    
    NSString *text1 = [NSString string];//
    NSString *text2 = [NSString string];// stringWithFormat:@"%ld ",_fatBurning / seconed];
    NSString *text3 = [NSString string];// stringWithFormat:@"%ld ",_aerobic / seconed];
    NSString *text4 = [NSString string];// stringWithFormat:@"%ld ",_anaerobic / seconed];
    NSString *text5 = [NSString string];// stringWithFormat:@"%ld ",_limit / seconed];
    text1 = [NSString stringWithFormat:@"%ld ",_warmUp];
    text2 = [NSString stringWithFormat:@"%ld ",_fatBurning];
    text3 = [NSString stringWithFormat:@"%ld ",_aerobic];
    text4 = [NSString stringWithFormat:@"%ld ",_anaerobic];
    text5 = [NSString stringWithFormat:@"%ld ",_limit];
    
    _labelThirdSeconed.attributedText = [NSMutableAttributedString  makeAttributedStringWithnumBer:text1 Unit:@"min" WithFont:fontNumber];
    _labelThirdThird.attributedText = [NSMutableAttributedString  makeAttributedStringWithnumBer:text2 Unit:@"min" WithFont:fontNumber];
    _labelThirdFourth.attributedText = [NSMutableAttributedString  makeAttributedStringWithnumBer:text3 Unit:@"min" WithFont:fontNumber];
    _labelThirdFifth.attributedText = [NSMutableAttributedString  makeAttributedStringWithnumBer:text4  Unit:@"min" WithFont:fontNumber];
    _labelThirdSixth.attributedText = [NSMutableAttributedString  makeAttributedStringWithnumBer:text5  Unit:@"min" WithFont:fontNumber];
    
    
    //百分比
    CGFloat warmUpRadio = 0;
    CGFloat fatBurningRadio = 0;
    CGFloat aerobicRadio = 0;
    CGFloat anaerobicRadio = 0;
    CGFloat limitRadio = 0;
    CGFloat radioCount = 0;
    CGFloat number = 100;
    radioCount = _warmUp + _fatBurning + _aerobic + _anaerobic + _limit;
    
    warmUpRadio = (CGFloat)_warmUp / radioCount * number;
    fatBurningRadio = (CGFloat)_fatBurning / radioCount * number;
    aerobicRadio = (CGFloat)_aerobic / radioCount * number;
    anaerobicRadio = (CGFloat)_anaerobic / radioCount * number;
    limitRadio = (CGFloat)_limit / radioCount * number;
    if (radioCount == 0) {
        warmUpRadio = 0;
        fatBurningRadio = 0;
        aerobicRadio = 0;
        anaerobicRadio = 0;
        limitRadio = 0;
        
        //        NSString *str1 = [NSString stringWithFormat:@"%f",limitRadio/radioCount];
        //        NSString *str2 = [NSString stringWithFormat:@"%f",anaerobicRadio/radioCount];
        //        NSString *str3 = [NSString stringWithFormat:@"%f",aerobicRadio/radioCount];
        //        NSString *str4 = [NSString stringWithFormat:@"%f",fatBurningRadio/radioCount];
        //        NSString *str5 = [NSString stringWithFormat:@"%f",warmUpRadio/radioCount];
        NSArray *arrBing = @[@"1",@"0",@"0",@"0",@"0"];
        _sector.sectorArray = arrBing;
    }
    else
    {
        NSString *str1 = [NSString stringWithFormat:@"%f",_limit/radioCount];
        NSString *str2 = [NSString stringWithFormat:@"%f",_anaerobic/radioCount];
        NSString *str3 = [NSString stringWithFormat:@"%f",_aerobic/radioCount];
        NSString *str4 = [NSString stringWithFormat:@"%f",_fatBurning/radioCount];
        NSString *str5 = [NSString stringWithFormat:@"%f",_warmUp/radioCount];
        NSArray *arrBing = @[str5,str4,str3,str2,str1];
        _sector.sectorArray = arrBing;
    }
    _labelFourthSeconed.text = [NSString stringWithFormat:@"%2.0f%%",warmUpRadio];
    _labelFourthThird.text = [NSString stringWithFormat:@"%2.0f%%",fatBurningRadio];
    _labelFourthFourth.text = [NSString stringWithFormat:@"%2.0f%%",aerobicRadio];
    _labelFourthFifth.text = [NSString stringWithFormat:@"%2.0f%%",anaerobicRadio];
    _labelFourthSixth.text = [NSString stringWithFormat:@"%2.0f%%",limitRadio];
    
}

-(NSString *)getTimingLabelText
{
    NSString *targetString;
    targetString = [NSString stringWithFormat:@"%02ld:%02ld",_progressDet / 3600,_progressDet  % 3600 / 60];//:%02ld  ,_progress % 60
    //adaLog(@"_progress =     - - %02ld",_progressDet);
    return targetString;
}

-(void)setupDetailView
{
    UIView *detaiView=[[UIView alloc]init];
    [self.scrollView addSubview:detaiView];
    detaiView.backgroundColor = [UIColor yellowColor];
    CGFloat detaiViewX = CurrentDeviceWidth;
    CGFloat detaiViewY = 0;
    CGFloat detaiViewW = CurrentDeviceWidth;
    CGFloat detaiViewH = self.scrollView.bounds.size.height;
    detaiView.frame = CGRectMake(detaiViewX, detaiViewY, detaiViewW, detaiViewH);
    
    UIImageView *imageViewBack = [[UIImageView alloc]init];
    [detaiView addSubview:imageViewBack];
    
    CGFloat imageViewBackX = 0;
    CGFloat imageViewBackY = -1;
    CGFloat imageViewBackW = detaiViewW;
    CGFloat imageViewBackH = detaiViewH+1;
    imageViewBack.frame = CGRectMake(imageViewBackX, imageViewBackY, imageViewBackW, imageViewBackH);
    imageViewBack.image = [UIImage imageNamed:@"Rectangle_two_map"];
    //矩形-21-地图
    //时长
    UILabel *timelengthDetail = [[UILabel alloc]init];
    [imageViewBack addSubview:timelengthDetail];
    timelengthDetail.textColor = [UIColor whiteColor];
    timelengthDetail.text = @"00:00:00";
    timelengthDetail.font = [UIFont systemFontOfSize:70*WidthProportion];
    //    timelengthDetail.backgroundColor = [UIColor orangeColor];
    timelengthDetail.textAlignment = NSTextAlignmentCenter;
    CGFloat timelengthDetailX = 0;
    CGFloat timelengthDetailH = 70*HeightProportion;
    CGFloat timelengthDetailY = 70*HeightProportion;
    CGFloat timelengthDetailW = CurrentDeviceWidth;// 100*WidthProportion;
    
    timelengthDetail.frame = CGRectMake(timelengthDetailX, timelengthDetailY, timelengthDetailW, timelengthDetailH);
    //    _timelengthDetail = timelengthDetail;
    
    UILabel *timelengthDetailUnit = [[UILabel alloc]init];
    [imageViewBack addSubview:timelengthDetailUnit];
    timelengthDetailUnit.textColor = [UIColor whiteColor];
    timelengthDetailUnit.text = NSLocalizedString(@"时长", nil);
    timelengthDetailUnit.font = [UIFont systemFontOfSize:18*WidthProportion];
    //    timelengthDetailUnit.backgroundColor = [UIColor orangeColor];
    timelengthDetailUnit.textAlignment = NSTextAlignmentCenter;
    CGFloat timelengthDetailUnitX = 0;//20*WidthProportion;
    CGFloat timelengthDetailUnitY = CGRectGetMaxY(timelengthDetail.frame);
    CGFloat timelengthDetailUnitW = timelengthDetailW;
    CGFloat timelengthDetailUnitH = 25*HeightProportion;//30*HeightProportion;
    timelengthDetailUnit.frame = CGRectMake(timelengthDetailUnitX, timelengthDetailUnitY, timelengthDetailUnitW, timelengthDetailUnitH);
    
    
    UIView *downView = [[UIView alloc]init];
    [detaiView addSubview:downView];
    //    downView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.6];
    downView.backgroundColor = [UIColor clearColor];
    
    CGFloat downViewX = 0;
    CGFloat downViewY = 210*HeightProportion;
    CGFloat downViewW = CurrentDeviceWidth;
    CGFloat downViewH = imageViewBackH - downViewY;
    downView.frame = CGRectMake(downViewX, downViewY, downViewW, downViewH);
    
    //    UIView *cellView = [[UIView alloc]init];
    //    [downView addSubview:cellView];
    //    cellView.layer.borderWidth = 0.5*WidthProportion;
    //    cellView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //    cellView.backgroundColor = [UIColor greenColor];
    //    //            cellViewX = i*cellViewW;
    //    //            cellViewH = j*cellViewW;
    //    //            cellView.frame = CGRectMake(cellViewX, cellViewY, cellViewW, cellViewH);
    //    cellView.frame = CGRectMake(0,0, 10, 10);
    
    CGFloat cellViewX = 0;
    CGFloat cellViewY = 0;
    CGFloat cellViewW = downViewW/3.0;
    CGFloat cellViewH = downViewH/3.0;
    
    UILabel * stepNumber;
    UILabel * stepNumberUnit;
    
    
    CGFloat stepNumberX = 0;
    CGFloat stepNumberW = cellViewW;
    CGFloat stepNumberH = 30*HeightProportion;
    CGFloat stepNumberUnitH = 20*HeightProportion;
    
    CGFloat stepNumberY = 0;
    CGFloat stepNumberUnitX = 0;
    CGFloat stepNumberUnitY = 0;
    CGFloat stepNumberUnitW = cellViewW;
    
    int tagNum = 1;
    for (int i=0; i<3; i++)
    {
        for (int j=0; j<3; j++)
        {
            UIView *cellView = [[UIView alloc]init];
            [downView addSubview:cellView];
            cellView.layer.borderWidth = 0.5*WidthProportion;
            cellView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            cellView.backgroundColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
            //            cellView.alpha = 0.1;
            
            cellViewX = i*cellViewW;
            cellViewY = j*cellViewH;
            cellView.frame = CGRectMake(cellViewX, cellViewY, cellViewW, cellViewH);
            //cellView.frame = CGRectMake(0,0, cellViewW, cellViewH);
            
            stepNumber = [[UILabel alloc]init];
            
            stepNumberUnit = [[UILabel alloc]init];
            stepNumber.tag = tagNum++;
            //adaLog(@"tagNum = %d",tagNum);
            stepNumber.textAlignment = NSTextAlignmentCenter;
            stepNumberUnit.textAlignment = NSTextAlignmentCenter;
            //stepNumber.backgroundColor = [UIColor yellowColor];
            //stepNumberUnit.backgroundColor = [UIColor redColor];
            stepNumber.font = [UIFont systemFontOfSize:22*WidthProportion];
            stepNumberUnit.font = [UIFont systemFontOfSize:15*WidthProportion];
            stepNumber.textColor = [UIColor whiteColor];
            stepNumberUnit.textColor = [ColorTool getColor:@"ababab"];//[UIColor lightGrayColor];
            
            stepNumberY = (cellViewH - stepNumberUnitH - stepNumberH)/2;
            stepNumber.frame = CGRectMake(stepNumberX, stepNumberY, stepNumberW, stepNumberH);
            [cellView addSubview:stepNumber];
            stepNumberUnitY = CGRectGetMaxY(stepNumber.frame);
            stepNumberUnit.frame = CGRectMake(stepNumberUnitX, stepNumberUnitY, stepNumberUnitW, stepNumberUnitH);
            [cellView addSubview:stepNumberUnit];
            switch (j)
            {
                case 0:
                {
                    switch (i)
                    {
                        case 0:
                        {
                            _stepNumberLab = stepNumber;
                            stepNumber.text = @"--";
                            stepNumberUnit.text = NSLocalizedString(@"步数", nil);
                            
                        }
                            break;
                        case 1:
                        {
                            _paceLab = stepNumber;
                            stepNumber.text = @"0'0\"";
                            stepNumberUnit.text = [NSString stringWithFormat:@"%@(min/km)",NSLocalizedString(@"配速", nil)];
                            
                        }
                            break;
                        case 2:
                        {
                            _kcalLab = stepNumber;
                            stepNumber.text = @"--";
                            stepNumberUnit.text = [NSString stringWithFormat:@"%@(kcal)",NSLocalizedString(@"热量", nil)];
                            
                        }
                            break;
                            
                        default:
                            break;
                    }
                    
                }
                    break;
                case 1:
                {
                    switch (i)
                    {
                        case 0:
                        {
                            _stepsLab = stepNumber;
                            stepNumber.text = @"--";
                            stepNumberUnit.text = [NSString stringWithFormat:@"%@(steps/min)",NSLocalizedString(@"步频", nil)];
                            
                        }
                            break;
                        case 1:
                        {
                            _speedLab = stepNumber;
                            stepNumber.text = @"--";
                            stepNumberUnit.text = [NSString stringWithFormat:@"%@(km/h)",NSLocalizedString(@"速度", nil)];
                            
                        }
                            break;
                        case 2:
                        {
                            _mileageLab = stepNumber;
                            stepNumber.text = @"--";
                            stepNumberUnit.text = [NSString stringWithFormat:@"%@(m)",NSLocalizedString(@"里程", nil)];
                            
                        }
                            break;
                            
                        default:
                            break;
                    }
                    
                }
                    break;
                case 2:
                {
                    switch (i)
                    {
                        case 0:
                        {
                            _heartRateLab = stepNumber;
                            stepNumber.text = @"--";
                            stepNumberUnit.text = NSLocalizedString(@"心率", nil);
                            
                        }
                            break;
                        case 1:
                        {
                            _stepLengthLab = stepNumber;
                            stepNumber.text = @"--";
                            stepNumberUnit.text = [NSString stringWithFormat:@"%@(cm)",NSLocalizedString(@"步长", nil)];
                            
                        }
                            break;
                        case 2:
                        {
                            _ClimbLab = stepNumber;
                            stepNumber.text = @"--";
                            stepNumberUnit.text = NSLocalizedString(@"累计爬升", nil);
                        }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                default:
                    break;
            }
        }
    }
    
    
    //放数据上去
    _kcalLab.text = [NSString stringWithFormat:@"%ld",_kcalNumberPlus];
    _heartRateLab.text = [AllTool getMean:_heartArray];
    
    NSInteger stepnumber = 0;
    NSInteger lilu =0;
    for (int i=0; i<_dictionaryArray.count; i++)
    {
        NSDictionary *dic = _dictionaryArray[i];
        int dex = [dic[DICKEY] intValue];
        switch (dex)
        {
            case 1:
            {
                NSString *timeL = [dic objectForKey:DICNUMBER];
                timelengthDetail.text = timeL;
                
            }
                break;
            case 2:
            {
                NSString *step =  [dic objectForKey:DICNUMBER];
                _stepNumberLab.text = step;
                stepnumber = [step integerValue];
            }
                break;
            case 3:
            {
                
            }
                break;
            case 4:
            {
                
                _paceLab.text = [dic objectForKey:DICNUMBER];
                //_downStepSLabel.text = [dic objectForKey:DICNUMBER];
            }
                break;
            case 5:
            {
                NSString *lilu1 = [dic objectForKey:DICNUMBER];
                _mileageLab.text = lilu1;
                lilu = [lilu1 integerValue];
            }
                break;
            default:
                break;
        }
    }
    
    //    _speedLab.text = [NSString stringWithFormat:@"%ld",([_mileageLab.text integerValue]/1000)/(_progressDet/3600)];
    if (_progressDet<=0)
    {
        _stepsLab.text = @"0";
        _speedLab.text =@"0";
    }
    else
    {
        NSInteger bupin = stepnumber/(_progressDet/60.0);
        //adaLog(@"bupin - %ld",bupin);
        
        _stepsLab.text = [NSString stringWithFormat:@"%ld",bupin];
        CGFloat sudu = (CGFloat)lilu/1000.0/(_progressDet/3600.0);
        _speedLab.text = [NSString stringWithFormat:@"%.2f",sudu];
    }
    
    if (stepnumber<=0)
    {
        _stepLengthLab.text = @"0";
        //  _speedLab.text =@"0";
    }
    else
    {
        //        NSInteger bupin = stepnumber/_progressDet/60;
        //        _stepsLab.text = [NSString stringWithFormat:@"%ld",bupin];
        NSInteger buchang = (lilu*100.0)/stepnumber;
        _stepLengthLab.text = [NSString stringWithFormat:@"%ld",buchang];
    }
    
    //如果取地图数据就是没有这些值的
    if(_isStoreMap)
    {
        _kcalLab.text = @"--";
        _heartRateLab.text = @"--";
        _stepsLab.text = @"--";
        _stepLengthLab.text = @"--";
    }
    
}
-(void)setupMapDownView
{
    //上半部分   -  地图
    
    CGFloat mapViewDetailX = 0;
    CGFloat mapViewDetailY = 0;//38*HeightProportion
    CGFloat mapViewDetailW = CurrentDeviceWidth;
    CGFloat mapViewDetailH = self.scrollView.height - mapViewDetailY;
    self.mapViewDetail = [[MKMapView alloc]init];
    self.mapViewDetail.delegate = self;
    self.mapViewDetail.showsUserLocation = YES;
    self.mapViewDetail.mapType = MKMapTypeStandard;
    [self.scrollView addSubview:self.mapViewDetail];
    self.mapViewDetail.frame = CGRectMake(mapViewDetailX, mapViewDetailY, mapViewDetailW, mapViewDetailH);
    if (_locationMutableArray.count != 0)
    {
        NSInteger arrCount = _locationMutableArray.count;
        //开始绘制轨迹
        CLLocationCoordinate2D pointsToUse[arrCount];
        for (int i=0; i<arrCount; i++)
        {
            NSArray *arr = [AllTool getLatLonDegree:_locationMutableArray[i]];
            pointsToUse[i] = CLLocationCoordinate2DMake([arr[0] doubleValue], [arr[1] doubleValue]);
        }
        //调用 addOverlay 方法后,会进入 rendererForOverlay 方法,完成轨迹的绘制
        MKPolyline *lineOne = [MKPolyline polylineWithCoordinates:pointsToUse count:arrCount];
        [_mapViewDetail addOverlay:lineOne];
        [self  configPolyline];
        
    }
    else
    {
        
    }
    //是否启用定位服务
    if ([CLLocationManager locationServicesEnabled])
    {
        //adaLog(@"开始定位");
        //调用 startUpdatingLocation 方法后,会对应进入 didUpdateLocations 方法
        [self.localManage startUpdatingLocation];
    }
    else
    { //adaLog(@"定位服务为关闭状态,无法使用定位服务");
    }
    
    
    
    
    
    //下半部分   -  底盘
    UIView *mapDownView = [[UIView alloc]init];
    [self.scrollView addSubview:mapDownView];
    mapDownView.backgroundColor = [UIColor blackColor];
    
    CGFloat mapDownViewX = 0;
    CGFloat mapDownViewW = CurrentDeviceWidth;
    CGFloat mapDownViewH = 88*HeightProportion;
    CGFloat mapDownViewY = self.scrollView.bounds.size.height - mapDownViewH;
    mapDownView.frame = CGRectMake(mapDownViewX, mapDownViewY, mapDownViewW, mapDownViewH);
    
    //时长
    UILabel *timelength = [[UILabel alloc]init];
    [mapDownView addSubview:timelength];
    _timelength = timelength;
    timelength.textColor = [UIColor whiteColor];
    timelength.text = @"00:00:00";
    timelength.font = [UIFont systemFontOfSize:22*WidthProportion];
    //    timelength.backgroundColor = [UIColor orangeColor];
    timelength.textAlignment = NSTextAlignmentCenter;
    
    CGFloat timelengthX = 0;
    CGFloat timelengthH = 30*HeightProportion;
    CGFloat timelengthY = (mapDownViewH-2*timelengthH)/2;// 14*HeightProportion;
    CGFloat timelengthW = 0.4*CurrentDeviceWidth-10*WidthProportion;// 100*WidthProportion;
    timelength.frame = CGRectMake(timelengthX, timelengthY, timelengthW, timelengthH);
    
    UILabel *timelengthUnit = [[UILabel alloc]init];
    [mapDownView addSubview:timelengthUnit];
    timelengthUnit.textColor = [ColorTool getColor:@"dddcdc"];
    timelengthUnit.text = NSLocalizedString(@"时长", nil);
    timelengthUnit.font = timelength.font;//[UIFont systemFontOfSize:22*WidthProportion];
    //    timelengthUnit.backgroundColor = [UIColor orangeColor];
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
    CGFloat lineViewY = mapDownViewH/4.0;
    CGFloat lineViewW = 1;
    CGFloat lineViewH = mapDownViewH/2.0;
    lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
    
    //步数
    UILabel *downStepLabel = [[UILabel alloc]init];
    _downStepLabel = downStepLabel;
    [mapDownView addSubview:downStepLabel];
    downStepLabel.textColor = [UIColor whiteColor];
    downStepLabel.text = @"--";
    downStepLabel.font = [UIFont systemFontOfSize:16*WidthProportion];
    //    downStepLabel.backgroundColor = [UIColor orangeColor];
    downStepLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat downStepLabelX = lineViewX+10*WidthProportion;
    CGFloat downStepLabelW = (CurrentDeviceWidth-downStepLabelX)/3.0;
    CGFloat downStepLabelH = 22*HeightProportion;
    CGFloat downStepLabelY = (mapDownViewH - downStepLabelH*2)/2.0;//10*HeightProportion;
    downStepLabel.frame = CGRectMake(downStepLabelX, downStepLabelY, downStepLabelW, downStepLabelH);
    
    UILabel *downStepLabelUnit = [[UILabel alloc]init];
    [mapDownView addSubview:downStepLabelUnit];
    downStepLabelUnit.textColor = [ColorTool getColor:@"dddcdc"];
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
    _downStepSLabel = downStepSLabel;
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
    
    UILabel *downStepSLabelUnit = [[UILabel alloc]init];
    [mapDownView addSubview:downStepSLabelUnit];
    downStepSLabelUnit.textColor = [ColorTool getColor:@"dddcdc"];
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
    _downmileageLabel = downmileageLabel;
    [mapDownView addSubview:downmileageLabel];
    downmileageLabel.textColor = [ColorTool getColor:@"dddcdc"];
    downmileageLabel.text = @"--";
    downmileageLabel.font = downStepSLabelUnit.font;//[UIFont systemFontOfSize:16*WidthProportion];
    //    downmileageLabel.backgroundColor = [UIColor orangeColor];
    downmileageLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat downmileageLabelX = CGRectGetMaxX(downStepSLabel.frame);
    CGFloat downmileageLabelW = downStepLabelW;
    CGFloat downmileageLabelH = downStepLabelH;
    CGFloat downmileageLabelY = downStepLabelY;
    downmileageLabel.frame = CGRectMake(downmileageLabelX, downmileageLabelY, downmileageLabelW, downmileageLabelH);
    
    UILabel *downmileageLabelUnit = [[UILabel alloc]init];
    [mapDownView addSubview:downmileageLabelUnit];
    downmileageLabelUnit.textColor = [ColorTool getColor:@"dddcdc"];
    downmileageLabelUnit.text = NSLocalizedString(@"里程", nil);
    downmileageLabelUnit.font = downmileageLabel.font;//[UIFont systemFontOfSize:16*WidthProportion];
    //    downmileageLabelUnit.backgroundColor = [UIColor orangeColor];
    downmileageLabelUnit.textAlignment = NSTextAlignmentCenter;
    CGFloat downmileageLabelUnitX = downmileageLabelX;
    CGFloat downmileageLabelUnitY = downmileageLabelY+downmileageLabelH;
    CGFloat downmileageLabelUnitW = downmileageLabelW;
    CGFloat downmileageLabelUnitH = downmileageLabelH;
    downmileageLabelUnit.frame = CGRectMake(downmileageLabelUnitX, downmileageLabelUnitY, downmileageLabelUnitW, downmileageLabelUnitH);
    [self refreshMapDown:_dictionaryArray];//刷新地图底盘的数据
}

#pragma mark  --- -  私有方法
//刷新地图中，下面的view的数据
-(void)refreshMapDown:(NSMutableArray *)array
{
    // 1.key 2.图 - image 3.数值 - number 4.单位 - unit 5.名称 - name
    // DICKEY  -- 1 - 时长- 2 - 计步- 3 - 心率- 4 - 步速- 5 - 里程
    //    NSMutableAttributedString *string;
    for (int i=0; i<array.count; i++)
    {
        NSDictionary *dic = array[i];
        int dex = [dic[DICKEY] intValue];
        switch (dex)
        {
            case 1:
            {
                _timelength.text = [dic objectForKey:DICNUMBER];
            }
                break;
            case 2:
            {
                
                _downStepLabel.text = [dic objectForKey:DICNUMBER];
            }
                break;
            case 3:
            {
                
            }
                break;
            case 4:
            {
                
                _downStepSLabel.text = [dic objectForKey:DICNUMBER];
            }
                break;
            case 5:
            {
                
                _downmileageLabel.text = [dic objectForKey:DICNUMBER];
            }
                break;
            default:
                break;
        }
    }
}

//绘制轨迹，放到中间去

-(void)configPolyline
{
    
    NSArray *tempInit = [AllTool getLatLonDegree:_locationMutableArray[0]];
    
    double  latMax = [tempInit[0] doubleValue];
    double  latMin = [tempInit[0] doubleValue];
    double  lonMax = [tempInit[1] doubleValue];
    double  lonMin = [tempInit[1] doubleValue];
    for (NSString *str in _locationMutableArray)
    {
        NSArray *temp = [AllTool getLatLonDegree:str];
        double number = [temp[0] doubleValue];
        double number1 = [temp[1] doubleValue];
        
        //adaLog(@"number-%f number1-%f",number,number1);
        if(number>latMax)
        {
            latMax = number;
        }
        if(number<latMin)
        {
            latMin = number;
        }
        if(number1>lonMax)
        {
            lonMax = number1;
        }
        if(number1<lonMin)
        {
            lonMin = number1;
        }
    }
    
    double  latAvg = (latMax+latMin)/2.0;
    double  lonAvg = (lonMax+lonMin)/2.0;
    //adaLog(@"--- %f --- %f",latAvg,lonAvg);
    
    //计算距离
//    CLLocationCoordinate2D minCoordinate = CLLocationCoordinate2DMake(latMin,lonMin);
//    CLLocationCoordinate2D maxCoordinate = CLLocationCoordinate2DMake(latMax,lonMax);
//    double ziTest = [MapTool calculateDistanceWithStart:minCoordinate end:maxCoordinate];
    double sysDistance = [[[CLLocation alloc] initWithLatitude:latMin longitude:lonMin] distanceFromLocation:[[CLLocation alloc] initWithLatitude:latMax longitude:lonMax]];
//    //adaLog(@"ziTest - %f sysTest - %f",ziTest,sysTest);
    
    //NSArray *temp = [self getLatLonDegree:_locationMutableArray[0]];
    //设置地图显示范围(如果不进行区域设置会自动显示区域范围并指定当前用户位置为地图中心点)
    double bili = sysDistance/111000.0;
    CLLocationDegrees latM = 1.4*bili*([UIScreen mainScreen].bounds.size.width/375.0);
    CLLocationDegrees lonM = 1.4*bili*([UIScreen mainScreen].bounds.size.height/667.0);
    CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake(latAvg,lonAvg);
    MKCoordinateSpan span = MKCoordinateSpanMake(latM,lonM);
    MKCoordinateRegion region=MKCoordinateRegionMake(startCoordinate, span);
    [_mapViewDetail setRegion:region animated:true];
    //    NSArray *tempOne = [AllTool getLatLonDegree:_locationMutableArray[0]];
    //    NSArray *tempTwo = [AllTool getLatLonDegree:_locationMutableArray[2]];
    
    NSArray *minStart = [AllTool getLatLonDegree:_locationMutableArray.firstObject];
    // 设置地图显示的类型及根据范围进行显示  安放大头针
    MKPointAnnotation *pinAnnotation = [[MKPointAnnotation alloc] init];
    pinAnnotation.coordinate = CLLocationCoordinate2DMake([minStart[0] doubleValue], [minStart[1] doubleValue]);
    pinAnnotation.title =@"go";
    [_mapViewDetail addAnnotation:pinAnnotation];
    
    NSArray *maxStart = [AllTool getLatLonDegree:_locationMutableArray.lastObject];//[_locationMutableArray.count-1]
    // 设置地图显示的类型及根据范围进行显示  安放大头针
    MKPointAnnotation *pinAnnotation1 = [[MKPointAnnotation alloc] init];
    pinAnnotation1.coordinate = CLLocationCoordinate2DMake([maxStart[0] doubleValue], [maxStart[1] doubleValue]);
    pinAnnotation1.title =@"end";
    [_mapViewDetail addAnnotation:pinAnnotation1];
}
-(void)backTrail
{
    //adaLog(@"_locationMutableArray.count  == %ld",_locationMutableArray.count);
    if (_locationMutableArray.count > 0)
    {
        NSArray *tempInit = [AllTool getLatLonDegree:_locationMutableArray.firstObject];
        
        double  latMax = [tempInit.firstObject doubleValue];
        double  latMin = [tempInit.firstObject doubleValue];
        double  lonMax = [tempInit.lastObject doubleValue];
        double  lonMin = [tempInit.lastObject doubleValue];
        for (NSString *str in _locationMutableArray)
        {
            NSArray *temp = [AllTool getLatLonDegree:str];
            double number = [temp.firstObject doubleValue];
            double number1 = [temp.lastObject doubleValue];
            
            //adaLog(@"number-%f number1-%f",number,number1);
            if(number>latMax)
            {
                latMax = number;
            }
            if(number<latMin)
            {
                latMin = number;
            }
            if(number1>lonMax)
            {
                lonMax = number1;
            }
            if(number1<lonMin)
            {
                lonMin = number1;
            }
        }
        
        //adaLog(@"latMax = %f latMin = %f,lonMax = %f lonMin = %f",latMax,latMin,lonMax,lonMin);
        double  latAvg = (latMax+latMin)/2.0;
        double  lonAvg = (lonMax+lonMin)/2.0;
        //adaLog(@"latAvg --- %f lonAvg --- %f",latAvg,lonAvg);
        
        //计算距离
//        CLLocationCoordinate2D minCoordinate = CLLocationCoordinate2DMake(latMin,lonMin);
//        CLLocationCoordinate2D maxCoordinate = CLLocationCoordinate2DMake(latMax,lonMax);
//        double ziTest = [MapTool calculateDistanceWithStart:minCoordinate end:maxCoordinate];
        double sysDistance = [[[CLLocation alloc] initWithLatitude:latMin longitude:lonMin] distanceFromLocation:[[CLLocation alloc] initWithLatitude:latMax longitude:lonMax]];
//        //adaLog(@"ziTest - %f sysTest - %f",ziTest,sysTest);
        
        //NSArray *temp = [self getLatLonDegree:_locationMutableArray[0]];
        //设置地图显示范围(如果不进行区域设置会自动显示区域范围并指定当前用户位置为地图中心点)
        double bili = sysDistance/111000.0;
        //adaLog(@"bili == = = ==%f",bili);
        CLLocationDegrees latM = 1.4*bili*([UIScreen mainScreen].bounds.size.width/375.0);
        CLLocationDegrees lonM = 1.4*bili*([UIScreen mainScreen].bounds.size.height/667.0);
        CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake(latAvg,lonAvg);
        MKCoordinateSpan span = MKCoordinateSpanMake(latM,lonM);
        MKCoordinateRegion region=MKCoordinateRegionMake(startCoordinate, span);
        //adaLog(@"region === %f == %f  span == %f== %f",region.center.latitude,region.center.longitude,region.span.latitudeDelta,region.span.longitudeDelta);
        [_mapViewDetail setRegion:region animated:true];
    }
}
-(void)backSportDetail
{
    self.haveTabBar = YES;
    //    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
#pragma mark  --- -  scrollView   - - delegate

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    // 记录scrollView 的当前位置，因为已经设置了分页效果，所以：位置/屏幕大小 = 第几页
    double xx = scrollView.contentOffset.x;
    //adaLog(@"scrollViewDidScroll-x=%f",xx);
    if(xx<1)
    {
        return;
    }
    int current = xx/CurrentDeviceWidth;
    //adaLog(@"current - %d",current);
    if (current==0)
    {
        [self trailViewAction];
    }
    else if (current==1)
    {
        [self detailViewAction];
    }
    else  if (current==2)
    {
        [self chartViewAction];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - MKMapViewDelegate   -- 自带地图
/**
 更新用户位置，只要用户改变则调用此方法（包括第一次定位到用户位置）
 第一种画轨迹的方法:我们使用在地图上的变化来描绘轨迹,这种方式不用考虑从 CLLocationManager 取出的经纬度在 mapView 上显示有偏差的问题
 */
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self backTrail];
}
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    
    if ([overlay isKindOfClass:[MKPolyline class]]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        MKPolylineView *polyLineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        polyLineView.lineWidth = 10.0; //折线宽度
        polyLineView.strokeColor = [UIColor blueColor]; //折线颜色
        return (MKOverlayRenderer *)polyLineView;
#pragma clang diagnostic pop
    }
    return nil;
}
#pragma mark mapView Delegate 地图 添加标注时 回调
- (MKAnnotationView *) mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc]init];
        //annotationView.image = [UIImage imageNamed:@"acc"];
        //        是否允许显示插入视图*********
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
    else
    {
        if([annotation.title isEqualToString:@"end"])
        {
            MKAnnotationView *annotationView = [[MKAnnotationView alloc]init];
            //annotationView.image = [UIImage imageNamed:@"map_end"];
            //[UIImage imageNamed:@"acc"];
            //
            
            //        是否允许显示插入视图*********
            annotationView.canShowCallout = YES;
            UILabel *endLabel = [[UILabel alloc]init];
            [annotationView addSubview:endLabel];
            endLabel.text =@"end";
            endLabel.textAlignment = NSTextAlignmentCenter;
            endLabel.textColor = allColorWhite;//[ColorTool getColor:@"dddcdc"];//UIColorFromHex(383838);
            endLabel.layer.borderColor = [UIColor whiteColor].CGColor;
            endLabel.layer.borderWidth = 1;
            endLabel.layer.cornerRadius = 10;
            endLabel.layer.masksToBounds = YES;
            endLabel.font = [UIFont systemFontOfSize:8];
            endLabel.backgroundColor = [ColorTool getColor:@"ff4200"];
            //        endLabel
            CGFloat  endLabelX= 0;
            CGFloat  endLabelY= 0;
            CGFloat  endLabelW= 20;
            CGFloat  endLabelH= endLabelW;
            endLabel.frame = CGRectMake(endLabelX, endLabelY, endLabelW, endLabelH);
            endLabel.center= annotationView.center;
            return annotationView;
        }
        else
        {
            MKAnnotationView *annotationView = [[MKAnnotationView alloc]init];
            //        是否允许显示插入视图*********
            annotationView.canShowCallout = YES;
            UILabel *endLabel = [[UILabel alloc]init];
            [annotationView addSubview:endLabel];
            endLabel.text =@"go";
            endLabel.textAlignment = NSTextAlignmentCenter;
            endLabel.textColor = allColorWhite;//[ColorTool getColor:@"dddcdc"];//UIColorFromHex(383838);
            endLabel.layer.borderColor = [UIColor whiteColor].CGColor;
            endLabel.layer.borderWidth = 1;
            endLabel.layer.cornerRadius = 10;
            endLabel.layer.masksToBounds = YES;
            endLabel.font = [UIFont systemFontOfSize:10];
            endLabel.backgroundColor = [ColorTool getColor:@"7cc933"];
            
            //        endLabel
            CGFloat  endLabelX= 0;
            CGFloat  endLabelY= 0;
            CGFloat  endLabelW= 20;
            CGFloat  endLabelH= endLabelW;
            endLabel.frame = CGRectMake(endLabelX, endLabelY, endLabelW, endLabelH);
            endLabel.center= annotationView.center;
            return annotationView;
            
            
        }
    }
}

#pragma mark - 位置管理者懒加载
- (CLLocationManager *)localManage
{
    if (_localManage == nil)
    {
        _localManage = [[CLLocationManager alloc]init];
        //设置定位的精度
        [_localManage setDesiredAccuracy:kCLLocationAccuracyBest];
        //位置信息更新最小距离
        _localManage.distanceFilter = 10;
        //设置代理
        _localManage.delegate = self;
        //如果没有授权则请求用户授权,
        //因为 requestAlwaysAuthorization 是 iOS8 后提出的,需要添加一个是否能响应的条件判断,防止崩溃
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined && [_localManage respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_localManage requestAlwaysAuthorization];
        }
        //创建存放位置的数组
        //_locationMutableArray = [[NSMutableArray alloc] init];
    }
    return _localManage;
}
@end
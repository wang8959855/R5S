//天气 api    http://docs.heweather.com/224489

#define normalFont  [UIFont systemFontOfSize:14]
#define  UIPickerViewHeight 246
#define SPORTTYPENUMBER  @"SPORTTYPENUMBER"
#define SPORTTYPETITLE  @"SPORTTYPETIME"

#import "MapSportTypeViewController.h"
#import "NSAttributedString+appendAttributedString.h"
#import "SportTypeSelected.h"
#import "MapKit/MapKit.h"
#import "CoreLocation/CoreLocation.h"
#import "NSDate+MJ.h"
#import "SportingMapViewController.h"
#import "WGS84TOGCJ02.h"
#import "ZCChinaLocation.h"

@interface MapSportTypeViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate,SportTypeSelectedDelegate>

@property (nonatomic,strong) MKMapView *map;//地图
@property (nonatomic,strong) CLLocationManager *loca; //定位

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
@property (nonatomic, strong) UIButton *timeViewButton;//目标设置
@property (nonatomic, strong) UIImageView *goImageView;//开始按钮
@property (nonatomic, strong) UIButton *sportTypeButton;//运动类型的按钮

@property (nonatomic, strong) UIButton *weatherButton;//天气按钮
@property (nonatomic, strong) NSString *targetTime;//运动的目标时间的字符串
@property (nonatomic, assign) BOOL canLocation;//是否可以定位，可以定位才进入运动界面
@property (nonatomic, assign) BOOL isSupportSport;//是否支持在线运动
//@property (nonatomic, strong) UILabel *supportLab;//手环不支持在线运动
//@property (nonatomic, assign) NSInteger refreshWeather;//刷新天气的属性
@property (nonatomic, strong) UIButton *startBtn;//开始运动的按钮
@end

@implementation MapSportTypeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[PSDrawerManager instance] cancelDragResponse];
}

#pragma  mark   - --- 建设   - View

-(void)setupView
{
    // self.view.backgroundColor = [UIColor greenColor];
    _canLocation = NO;
    _isSupportSport = NO;
    //_refreshWeather = 0;
    [self setupBackgroudMap];
    [self setupUpView];//上
    [self setupDownView];//下
    [self setupHeadView];//头
    [self NotSupportBracelet];
    _startBtn.userInteractionEnabled = YES;
}
-(void)setupDownView
{
    
    CGFloat goImageViewW = 150*WidthProportion;
    CGFloat goImageViewH = goImageViewW;
    CGFloat goImageViewX = (CurrentDeviceWidth - goImageViewW)/2;
    CGFloat goImageViewY = CurrentDeviceHeight - goImageViewH - 42.5*HeightProportion;
    UIImageView *goImageView = [[UIImageView alloc]init];
    [self.view addSubview:goImageView];
    goImageView.userInteractionEnabled = YES;
    goImageView.image = [UIImage imageNamed:@"GO_map"];
    goImageView.frame = CGRectMake(goImageViewX, goImageViewY, goImageViewW, goImageViewH);
    _goImageView = goImageView;
    
    CGFloat startBtnX = 0;
    CGFloat startBtnY = 0;
    CGFloat startBtnW = goImageViewW;
    CGFloat startBtnH = startBtnW;
    UIButton *startBtn = [[UIButton alloc]init];
    [self.view addSubview:startBtn];
    _startBtn = startBtn;
    //    startBtn.backgroundColor = allColorRed;
    startBtn.frame = CGRectMake(startBtnX, startBtnY, startBtnW, startBtnH);
    startBtn.backgroundColor = [UIColor clearColor];
    [startBtn addTarget:self action:@selector(startBtnAction) forControlEvents:UIControlEventTouchUpInside];
    startBtn.center = goImageView.center;
    startBtn.userInteractionEnabled = NO;
    //    _startBtn = startBtn;
}
-(void)setupUpView
{
   
    
    UIImageView *targetImageView = [[UIImageView alloc]init];
    [self.view addSubview:targetImageView];
    targetImageView.image = [UIImage imageNamed:@"Time_one"];
    targetImageView.userInteractionEnabled = YES;
    
    CGFloat targetqiImageViewW = 110*WidthProportion;
    CGFloat targetqiImageViewH = 33*HeightProportion;
    CGFloat targetqiImageViewX = 20*WidthProportion;
    CGFloat targetqiImageViewY = 30*HeightProportion+64;
    targetImageView.frame = CGRectMake(targetqiImageViewX, targetqiImageViewY, targetqiImageViewW, targetqiImageViewH);
    targetImageView.centerX =self.view.centerX;
    //    目标 按钮
    CGFloat targetButtonX = HeightProportion*3;
    CGFloat targetButtonY = 0;
    CGFloat targetButtonW = targetqiImageViewW;
    CGFloat targetButtonH = targetqiImageViewH - 3*HeightProportion;
    
    UIButton *targetButton = [[UIButton alloc]init];
    [targetImageView addSubview:targetButton];
    targetButton.frame = CGRectMake(targetButtonX, targetButtonY, targetButtonW, targetButtonH);
    [targetButton addTarget:self action:@selector(targetButtonAction) forControlEvents:UIControlEventTouchUpInside];
    targetButton.backgroundColor = [UIColor clearColor];
    targetButton.layer.cornerRadius = targetButtonH/2;
    [targetButton setImage:[UIImage imageNamed:@"Target_Map"] forState:UIControlStateNormal];
    [targetButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10*WidthProportion, 0.0, 0.0)];
    self.pickerViewHour = @"00";
    self.pickerViewMinute = @"30";
    [targetButton setAttributedTitle:[NSAttributedString getAttributedText:16 pickerViewHour:self.pickerViewHour pickerViewMinute:self.pickerViewMinute] forState:UIControlStateNormal];
    //返回目标时间
    
    [targetButton addTarget:self action:@selector(timeTargetMap) forControlEvents:UIControlEventTouchUpInside];
    targetButton.adjustsImageWhenHighlighted = NO;
    self.timeViewButton=targetButton;
    
    //    CGFloat weatherImageViewY = targetqiImageViewY;
    //    CGFloat weatherImageViewW = 75*WidthProportion;
    //    CGFloat weatherImageViewH = targetqiImageViewH;
    //    CGFloat weatherImageViewX = CurrentDeviceWidth - 28*WidthProportion - weatherImageViewW;
    //
    //    UIImageView *weatherImageView = [[UIImageView alloc]init];
    //    [self.view addSubview:weatherImageView];
    //    weatherImageView.image = [UIImage imageNamed:@"天气1"];
    //    weatherImageView.userInteractionEnabled = YES;
    //    weatherImageView.frame = CGRectMake(weatherImageViewX, weatherImageViewY, weatherImageViewW, weatherImageViewH);
    //
    //    //  天气按钮
    //    CGFloat weatherButtonX = 0;
    //    CGFloat weatherButtonY = 0;
    //    CGFloat weatherButtonW = weatherImageViewW;
    //    CGFloat weatherButtonH = weatherImageViewH-3*HeightProportion;
    //
    //    UIButton *weatherButton = [[UIButton alloc]init];
    //    [weatherImageView addSubview:weatherButton];
    //    weatherButton.frame = CGRectMake(weatherButtonX, weatherButtonY, weatherButtonW, weatherButtonH);
    //    [weatherButton addTarget:self action:@selector(weatherButtonAction) forControlEvents:UIControlEventTouchUpInside];
    //    weatherButton.backgroundColor = [UIColor clearColor];
    //
    //    weatherButton.layer.cornerRadius = weatherButtonH/2;
    //    [weatherButton setImage:[UIImage imageNamed:@"空气质量"] forState:UIControlStateNormal];
    //    [weatherButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5*WidthProportion, 0.0, 0.0)];
    //    [weatherButton setTitle:@"优" forState:UIControlStateNormal];
    //    //    weatherButton.titleLabel.textColor = [UIColor blackColor];
    //    [weatherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    weatherButton.adjustsImageWhenHighlighted = NO;
    //    _weatherButton = weatherButton;
    
    CGFloat sportTypeImageViewY = 93*HeightProportion+64;
    CGFloat sportTypeImageViewW = 121*WidthProportion;
    CGFloat sportTypeImageViewH = targetqiImageViewH;
    CGFloat sportTypeImageViewX = (CurrentDeviceWidth - sportTypeImageViewW)/2;
    UIImageView *sportTypeImageView = [[UIImageView alloc]init];
    [self.view addSubview:sportTypeImageView];
    sportTypeImageView.userInteractionEnabled  = YES;
    sportTypeImageView.image = [UIImage imageNamed:@"Movement_type_map"];
    sportTypeImageView.frame = CGRectMake(sportTypeImageViewX, sportTypeImageViewY, sportTypeImageViewW, sportTypeImageViewH);
    
    //  运动类型的 按钮
    
    CGFloat sportTypeButtonX = 0;
    CGFloat sportTypeButtonY = 0;
    CGFloat sportTypeButtonW = sportTypeImageViewW;
    CGFloat sportTypeButtonH = sportTypeImageViewH-3*HeightProportion;
    
    UIButton *sportTypeButton = [[UIButton alloc]init];
    _sportTypeButton = sportTypeButton;
    [sportTypeImageView addSubview:sportTypeButton];
    sportTypeButton.frame = CGRectMake(sportTypeButtonX, sportTypeButtonY, sportTypeButtonW, sportTypeButtonH);
    [sportTypeButton addTarget:self action:@selector(sportTypeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    sportTypeButton.backgroundColor = [UIColor clearColor];
    [sportTypeButton setTitle:NSLocalizedString(@"徒步", nil) forState:UIControlStateNormal];
    [sportTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
}

-(void)setupUpView11
{
    UIImageView *targetImageView = [[UIImageView alloc]init];
    [self.view addSubview:targetImageView];
    targetImageView.image = [UIImage imageNamed:@"Time_one"];
    targetImageView.userInteractionEnabled = YES;
    
    CGFloat targetqiImageViewW = 110*WidthProportion;
    CGFloat targetqiImageViewH = 33*HeightProportion;
    CGFloat targetqiImageViewX = 20*WidthProportion;
    CGFloat targetqiImageViewY = 20*HeightProportion+64;
    targetImageView.frame = CGRectMake(targetqiImageViewX, targetqiImageViewY, targetqiImageViewW, targetqiImageViewH);
    
    //    目标 按钮
    CGFloat targetButtonX = HeightProportion*3;
    CGFloat targetButtonY = 0;
    CGFloat targetButtonW = targetqiImageViewW;
    CGFloat targetButtonH = targetqiImageViewH - 3*HeightProportion;
    
    UIButton *targetButton = [[UIButton alloc]init];
    [targetImageView addSubview:targetButton];
    targetButton.frame = CGRectMake(targetButtonX, targetButtonY, targetButtonW, targetButtonH);
    [targetButton addTarget:self action:@selector(targetButtonAction) forControlEvents:UIControlEventTouchUpInside];
    targetButton.backgroundColor = [UIColor clearColor];
    targetButton.layer.cornerRadius = targetButtonH/2;
    [targetButton setImage:[UIImage imageNamed:@"Target_Map"] forState:UIControlStateNormal];
    [targetButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10*WidthProportion, 0.0, 0.0)];
    self.pickerViewHour = @"00";
    self.pickerViewMinute = @"30";
    [targetButton setAttributedTitle:[NSAttributedString getAttributedText:16 pickerViewHour:self.pickerViewHour pickerViewMinute:self.pickerViewMinute] forState:UIControlStateNormal];
    //返回目标时间
    //    [timeViewButton setAttributedTitle:[self getAttributedText:18] forState:UIControlStateNormal];
    [targetButton addTarget:self action:@selector(timeTargetMap) forControlEvents:UIControlEventTouchUpInside];
    //    targetButton.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];
    targetButton.adjustsImageWhenHighlighted = NO;
    //    targetButton.centerX = targetImageView.centerX;
    self.timeViewButton=targetButton;
    
    CGFloat weatherImageViewY = targetqiImageViewY;
    CGFloat weatherImageViewW = 75*WidthProportion;
    CGFloat weatherImageViewH = targetqiImageViewH;
    CGFloat weatherImageViewX = CurrentDeviceWidth - 28*WidthProportion - weatherImageViewW;
    
    UIImageView *weatherImageView = [[UIImageView alloc]init];
    [self.view addSubview:weatherImageView];
    weatherImageView.image = [UIImage imageNamed:@"Weather__two"];
    weatherImageView.userInteractionEnabled = YES;
    weatherImageView.frame = CGRectMake(weatherImageViewX, weatherImageViewY, weatherImageViewW, weatherImageViewH);
    
    //  天气按钮
    CGFloat weatherButtonX = 0;
    CGFloat weatherButtonY = 0;
    CGFloat weatherButtonW = weatherImageViewW;
    CGFloat weatherButtonH = weatherImageViewH-3*HeightProportion;
    
    UIButton *weatherButton = [[UIButton alloc]init];
    [weatherImageView addSubview:weatherButton];
    weatherButton.frame = CGRectMake(weatherButtonX, weatherButtonY, weatherButtonW, weatherButtonH);
    [weatherButton addTarget:self action:@selector(weatherButtonAction) forControlEvents:UIControlEventTouchUpInside];
    weatherButton.backgroundColor = [UIColor clearColor];
    
    weatherButton.layer.cornerRadius = weatherButtonH/2;
    [weatherButton setImage:[UIImage imageNamed:@"air_quality"] forState:UIControlStateNormal];
    [weatherButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5*WidthProportion, 0.0, 0.0)];
    [weatherButton setTitle:@"优" forState:UIControlStateNormal];
    //    weatherButton.titleLabel.textColor = [UIColor blackColor];
    [weatherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    weatherButton.adjustsImageWhenHighlighted = NO;
    _weatherButton = weatherButton;
    
    CGFloat sportTypeImageViewY = 83*HeightProportion+64;
    CGFloat sportTypeImageViewW = 121*WidthProportion;
    CGFloat sportTypeImageViewH = weatherImageViewH;
    CGFloat sportTypeImageViewX = (CurrentDeviceWidth - sportTypeImageViewW)/2;
    UIImageView *sportTypeImageView = [[UIImageView alloc]init];
    [self.view addSubview:sportTypeImageView];
    sportTypeImageView.userInteractionEnabled  = YES;
    sportTypeImageView.image = [UIImage imageNamed:@"Movement_type_map"];
    sportTypeImageView.frame = CGRectMake(sportTypeImageViewX, sportTypeImageViewY, sportTypeImageViewW, sportTypeImageViewH);
    
    //  运动类型的 按钮
    
    CGFloat sportTypeButtonX = 0;
    CGFloat sportTypeButtonY = 0;
    CGFloat sportTypeButtonW = sportTypeImageViewW;
    CGFloat sportTypeButtonH = sportTypeImageViewH-3*HeightProportion;
    
    UIButton *sportTypeButton = [[UIButton alloc]init];
    _sportTypeButton = sportTypeButton;
    [sportTypeImageView addSubview:sportTypeButton];
    sportTypeButton.frame = CGRectMake(sportTypeButtonX, sportTypeButtonY, sportTypeButtonW, sportTypeButtonH);
    [sportTypeButton addTarget:self action:@selector(sportTypeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    sportTypeButton.backgroundColor = [UIColor clearColor];
    [sportTypeButton setTitle:@"徒步" forState:UIControlStateNormal];
    [sportTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
}
-(void)testView
{
    UIView *testView = [[UIView alloc]init];
    [self.view addSubview:testView];
    testView.frame = CGRectMake(29*WidthProportion, 137*HeightProportion, 324*WidthProportion, 360*HeightProportion);
    testView.backgroundColor = [UIColor blackColor];
    
}
-(void)setupHeadView
{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    CGFloat headViewX = 0;
    CGFloat headViewY = StatusBarHeight;
    CGFloat headViewW = CurrentDeviceWidth;
    CGFloat headViewH = 44;
    headView.frame = CGRectMake(headViewX, headViewY, headViewW, headViewH);
    
    UILabel *title = [[UILabel alloc]init];
    [headView addSubview:title];
    title.text = NSLocalizedString(@"选择运动模式", nil);
    title.textAlignment = NSTextAlignmentCenter;
    title.sd_layout
    .widthIs(200)
    .heightIs(30)
    .centerXEqualToView(headView)
    .centerYEqualToView(headView);
    
    UIButton  *backButton = [[UIButton alloc]init];
    [headView addSubview:backButton];
    [backButton setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    CGFloat backButtonX = 0;
    CGFloat backButtonY = 0;
    CGFloat backButtonW = headViewH;
    CGFloat backButtonH = 44;
    backButton.frame = CGRectMake(backButtonX, backButtonY, backButtonW, backButtonH);
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor blackColor];
    [self.view  addSubview:topView];
    topView.frame = CGRectMake(0, 0, CurrentDeviceWidth, StatusBarHeight);
    //     return headView;
}
-(void)setupBackgroudMap
{
    CGFloat mapX = 0;
    CGFloat mapY = SafeAreaTopHeight;
    CGFloat mapW = CurrentDeviceWidth;
    CGFloat mapH = CurrentDeviceHeight;
    self.map = [[MKMapView alloc]init];
    self.map.delegate = self;
    self.map.showsUserLocation = YES;
    self.map.mapType = MKMapTypeStandard;
    [self.view addSubview:self.map];
    self.map.frame = CGRectMake(mapX, mapY, mapW, mapH);
    //是否启用定位服务
    if ([CLLocationManager locationServicesEnabled])
    {
        //adaLog(@"开始定位");
        //调用 startUpdatingLocation 方法后,会对应进入 didUpdateLocations 方法
        [self.loca startUpdatingLocation];
    }
    else
    { //adaLog(@"定位服务为关闭状态,无法使用定位服务");
    }
}
-(void)NotSupportBracelet
{
    [[PZBlueToothManager sharedInstance] checkVerSionWithBlock:^(int firstHardVersion, int secondHardVersion, int softVersion, int blueToothVersion) {
        int8_t soft;
        int8_t hard;
        int8_t hardTwo;
        int8_t blue;
        BOOL isCan = YES;
        if (secondHardVersion == 161616) {
            hard = [HCHCommonManager getInstance].curHardVersion;
            soft = [HCHCommonManager getInstance].softVersion;
            blue = [HCHCommonManager getInstance].blueVersion;
            isCan = [AllTool checkVersionWithHard:hard HardTwo:161616  Soft:soft Blue:blue];
        }
        else
        {
            hard = [HCHCommonManager getInstance].curHardVersion;
            hardTwo = [HCHCommonManager getInstance].curHardVersionTwo;
            soft = [HCHCommonManager getInstance].softVersion;
            blue = [HCHCommonManager getInstance].blueVersion;
            isCan = [AllTool checkVersionWithHard:hard HardTwo:hardTwo Soft:soft Blue:blue];
        }
        if (!isCan) {
            //_supportLab.hidden = NO;
            _isSupportSport = NO;
            //adaLog(@"不支持在线运动");
            
            UIAlertView *supportAlert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"该手环不支持在线运动，展示gps数据", nil) delegate:self
                                                         cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
            [supportAlert show];
        }
        else
        {
            _isSupportSport = YES;
        }
        
    }];
    
}

#pragma  mark   - --- 私有方法
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    //    [self dismissViewControllerAnimated:YES completion:nil];
}
//开始按钮的事件
-(void)startBtnAction
{
    _startBtn.userInteractionEnabled = NO;
    [self performSelector:@selector(startBtnisCan) withObject:nil afterDelay:1.f];
    if(!_canLocation)
    {
        UIAlertView *fuwu = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"请允许位置服务", nil) delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
        //fuwu.tag = 67;
        [fuwu show];
        //    _startButton.userInteractionEnabled = YES;
        return;
    }
    [self.loca stopUpdatingLocation];
    SportingMapViewController  * sporting =  [[SportingMapViewController alloc]init];
    sporting.targetTime = [AllTool getSportTargetTime:self.targetTime];
    sporting.sportTypeDic = self.sportTypeDic;
    if (![CositeaBlueTooth sharedInstance].isConnected ||!_isSupportSport)
    {
        sporting.isStoreMap = YES;//取地图数据
    }
    else
    {
        sporting.isStoreMap = NO;//取手环数据
    }
    [self.navigationController pushViewController:sporting animated:YES];
}
-(void)startBtnisCan
{
_startBtn.userInteractionEnabled = YES;
}
// 目标按钮
-(void)targetButtonAction
{
    
}
// 天气按钮
-(void)weatherButtonAction
{
    
}
#pragma mark - - - 天气的代理 ---- AFAppDotNetAPIClientDelegate
//-(void)callbackWeather:(NSDictionary *)weatherDic
//{
//    //    [_weatherButton setTitle:[AllTool pm25ToString:[weatherDic[@"pmStr"] intValue]] forState:UIControlStateNormal];
//}

// 运动类型。。按钮
-(void)sportTypeButtonAction
{
    //adaLog(@"运动类型的选择");
    SportTypeSelected *sel = [SportTypeSelected showSportTypeSelect];
    sel.sportTypeDic = self.sportTypeDic;
    [sel show];
    sel.delegate = self;
}
#pragma mark - - -选择运动类型的代理 ---- SportTypeSelectedDelegate
-(void)callbackSportType:(NSMutableDictionary *)TypeDic
{
    self.sportTypeDic = TypeDic;
    [_sportTypeButton setTitle:[TypeDic objectForKey:SPORTTYPETITLE] forState:UIControlStateNormal];
}
//
-(void)timeTargetMap
{
    //    if (self.sportType < 100)
    //    {
    //adaLog(@"选择运动时间");
    if (_SubBackView == nil) [self setPickerViewTwo];
    //    }
}
#pragma mark ---   alertView   delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 66)
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
#pragma mark - MKMapViewDelegate
/**
 *  更新到用户的位置时就会调用(显示的位置、显示范围改变)
 *  userLocation : 大头针模型数据， 对大头针位置的一个封装（这里的userLocation描述的是用来显示用户位置的蓝色大头针）
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.005029,0.003181);//(0.2509, 0.2256);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [self.map setRegion:region animated:YES];
}
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
            _canLocation = NO;
            //adaLog(@"用户还未进行授权");
            break;
        }
        case kCLAuthorizationStatusDenied:{
            _canLocation = NO;
            // 判断当前设备是否支持定位和定位服务是否开启
            if([CLLocationManager locationServicesEnabled]){
                
                //adaLog(@"用户不允许程序访问位置信息或者手动关闭了位置信息的访问，帮助跳转到设置界面");
                UIAlertView *fuwu = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"请允许位置服务", nil) delegate:self                                                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
                fuwu.tag = 66;
                [fuwu show];
                // NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                // if ([[UIApplication sharedApplication] canOpenURL:url]) {
                // [[UIApplication sharedApplication] openURL: url];
                // }
            }else{
                //adaLog(@"定位服务关闭,弹出系统的提示框,点击设置可以跳转到定位服务界面进行定位服务的开启");
            }
            break;
        }
        case kCLAuthorizationStatusRestricted:{
            //adaLog(@"受限制的");
            _canLocation = NO;
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:{
            _canLocation = YES;
            //adaLog(@"授权    允许在前台和后台均可使用定位服务");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:{
            _canLocation = YES;
            //adaLog(@"授权   允许在前台可使用定位服务");
            break;
        }
            
        default:
            break;
    }
}

#pragma mark  --  UIDatePicker --
- (void)setPickerViewTwo
{
    [self.view endEditing:YES];
    _SubBackView = [[UIButton alloc] initWithFrame:CurrentDeviceBounds];
    _SubBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_SubBackView];
    [_SubBackView addTarget:self action:@selector(dateSureClickTwo) forControlEvents:UIControlEventTouchUpInside];
    
    
    _SubAnimationView  = [[UIView alloc] initWithFrame:CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, UIPickerViewHeight)];
    [_SubBackView addSubview:_SubAnimationView];
    _SubAnimationView.backgroundColor = [UIColor whiteColor];
    
    //弹出的pickerView
    CGFloat pickerViewX = 0;
    CGFloat pickerViewY = 50;
    CGFloat pickerViewW = CurrentDeviceWidth;
    CGFloat pickerViewH = UIPickerViewHeight - pickerViewY;
    
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
    if(self.timeViewButton.titleLabel.attributedText)
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
        _SubAnimationView.frame = CGRectMake(0, CurrentDeviceHeight - UIPickerViewHeight,CurrentDeviceWidth, UIPickerViewHeight);
    }];
}

- (void)hiddenPickerView
{
    [UIView animateWithDuration:0.23 animations:^{
        _SubAnimationView.frame = CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, UIPickerViewHeight);
        _SubBackView.frame = CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, UIPickerViewHeight);
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

    [self.timeViewButton setAttributedTitle:[NSAttributedString getAttributedText:16 pickerViewHour:self.pickerViewHour pickerViewMinute:self.pickerViewMinute] forState:UIControlStateNormal];
    //    [ADASaveDefaluts setObject:[NSString stringWithFormat:@"%@H%@min",self.pickerViewHour,self.pickerViewMinute] forKey:MAPSPORTTARGET];//保存地图运动目标
    self.targetTime = [NSString stringWithFormat:@"%@H%@min",self.pickerViewHour,self.pickerViewMinute];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark   - -- 懒加载
-(NSMutableDictionary *)sportTypeDic
{
    if (!_sportTypeDic)
    {
        _sportTypeDic = [NSMutableDictionary dictionary];
        [_sportTypeDic setObject:@"01" forKey:SPORTTYPENUMBER];
        [_sportTypeDic setObject:@"徒步" forKey:SPORTTYPETITLE];
    }
    return _sportTypeDic;
}

- (CLLocationManager *)loca
{
    if (_loca == nil)
    {
        _loca = [[CLLocationManager alloc]init];
        //设置定位的精度
        [_loca setDesiredAccuracy:kCLLocationAccuracyBest];
        
        //位置信息更新最小距离
        _loca.distanceFilter = 5;
        
        //设置代理
        _loca.delegate = self;
        
        //如果没有授权则请求用户授权,
        //因为 requestAlwaysAuthorization 是 iOS8 后提出的,需要添加一个是否能响应的条件判断,防止崩溃
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined && [_loca respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_loca requestAlwaysAuthorization];
        }
        
        //创建存放位置的数组
        //        _locationMutableArray = [[NSMutableArray alloc] init];
    }
    return _loca;
}


@end

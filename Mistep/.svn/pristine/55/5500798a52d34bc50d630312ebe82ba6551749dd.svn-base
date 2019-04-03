//
////测试 服务器
////static NSString * const testAFAppDotNetAPIBaseURLString = @"https://bracelet.cositea.com:8445/bracelet/";
//static NSString * const testAFAppDotNetAPIBaseURLString = @"http://bracelet.cositea.com:8089/bracelet/";
///**
// *
// *侧边栏的宽度
// */
//#define  sideWidth (220 * WidthProportion)
//
//#import "HomeViewController.h"
//#import "SheBeiViewController.h"
//#import "AboutViewController.h"
//#import "HelpViewController.h"
//#import "LoginViewController.h"
//#import "EditPersonInformationViewController.h"
//#import "AlarmViewController.h"
//#import "ViewController.h"
//#import "HomeTableViewCell.h"
//#import "SMTabbedSplitViewController.h"
//#import "SMTabBarItem.h"
//#import "PhoneSetViewController.h"
//#import "SMSAlarmViewController.h"
//#import "JiuzuoViewController.h"
//#import "HeartHomeAlarmViewController.h"
//#import "FangdiuViewController.h"
//#import "TakePhotoViewController.h"
////#import "FriendListViewController.h"
//#import "HelpViewController.h"
//#import "UIImage+ForceDecode.h"
//#import "TaiwanViewController.h"
//#import "pageManageViewController.h"
//#import "PSDrawerManager.h"
//#import "UIView+leoAdd.h"
//#import "Masonry.h"
//#import "AppDelegate.h"
//
//
//#import "HomeTwoViewController.h"
//
//@interface HomeTwoViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
//
//
//@property (nonatomic, weak) UIImageView *coverImageView;
//@property (nonatomic, strong) UILabel *userNameLabel; //用户名字
//@property (nonatomic, strong) SMTabbedSplitViewController *split;
//
//
//@property (nonatomic,strong) UIImageView *backImageView;//背景图
//@property (nonatomic,strong) UIImageView *headImageView;//头图
//@property (nonatomic,strong) UITableView *tableView;//列表
//
//@property (nonatomic,strong) UIImageView *bleImageView;//蓝牙
//@property (nonatomic,strong) UILabel *bleLabel;//蓝牙
//@property (nonatomic,strong) UIImageView *eleImageView;//电量
//@property (nonatomic,strong) UILabel *eleLabel;//电量
//
//@property (nonatomic,strong) UIView *lineView;//横线
//@property (nonatomic,strong) NSArray *dataArray;
////@property (nonatomic,strong) UILabel *userNameLabel; //用户名字
//@property (nonatomic,strong) UIButton *headBtn;//头图的按钮
//@property (strong, nonatomic) UIButton *loginButtonTwo;//登录按钮
//@property (strong, nonatomic) CositeaBlueTooth *blueManage;
//
//@end
//
//static NSString *reuseID  = @"CELL";
//
//@implementation HomeTwoViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
//    [self setupView];
//}
//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:YES];
//    [self viewWillRefresh];
//}
//+(id)sharedInstance
//{
//    static HomeTwoViewController * instance;
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[self alloc] init];
//    });
//    
//    return instance;
//}
//
////- (instancetype)initWithFrame:(CGRect)frame {
////    self = [super initWithFrame:frame];
////    if (self) {
////        self.backgroundColor = [UIColor whiteColor];
////
////        [self setupView];
////    }
////    return self;
////}
//-(void)setupView
//{
//    
//    //背景图
//    self.backImageView = [[UIImageView alloc]init];
//    [self.view addSubview:self.backImageView];
//    self.backImageView.image = [UIImage imageNamed:@"CL_背景"];
//    //头图
//    self.headImageView = [[UIImageView alloc]init];
//    [self.view addSubview:self.headImageView];
//    self.headImageView.image = [UIImage imageNamed:@"CL_head"];
//    
//    UIButton *headBtn = [[UIButton alloc]init];
//    _headBtn = headBtn;
//    [self.view addSubview:headBtn];
//    //    headBtn.backgroundColor = allColorRed;
//    [headBtn addTarget:self action:@selector(personAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    //用户的名字
//    _userNameLabel = [[UILabel alloc]init];
//    [self.view addSubview:_userNameLabel];
//    _userNameLabel.alpha = 0.5;
//    //    _userNameLabel.backgroundColor = allColorRed;
//    _userNameLabel.textAlignment =NSTextAlignmentCenter;
//    //蓝牙
//    self.bleImageView = [[UIImageView alloc]init];
//    [self.view addSubview:self.bleImageView];
//    self.bleImageView.image = [UIImage imageNamed:@"蓝牙"];
//    
//    CGFloat bleImageViewX=30*WidthProportion;
//    CGFloat bleImageViewY=160*HeightProportion;
//    CGFloat bleImageViewW=12*WidthProportion;
//    CGFloat bleImageViewH=16*HeightProportion;
//    self.bleImageView.frame =CGRectMake(bleImageViewX, bleImageViewY, bleImageViewW, bleImageViewH);
//    
//    self.bleLabel = [[UILabel alloc]init];
//    [self.view addSubview:self.bleLabel];
//    self.bleLabel.tag = 50;
//    self.bleLabel.text  = NSLocalizedString(@"未连接", nil);
//    self.bleLabel.font = [UIFont systemFontOfSize:11];
//    self.bleLabel.frame =CGRectMake(50*WidthProportion, 157*HeightProportion, 34*WidthProportion, 21*HeightProportion);
//    
//    [self.bleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.bleImageView.mas_right).with.offset(8*WidthProportion);
//        make.centerY.equalTo(self.bleImageView);
//    }];
//    
//    //电量
//    self.eleImageView = [[UIImageView alloc]init];
//    [self.view addSubview:self.eleImageView];
//    self.eleImageView.image = [UIImage imageNamed:@"电量"];
//    self.eleImageView.frame =CGRectMake(104*WidthProportion, 160.5*HeightProportion, 20*WidthProportion, 14*HeightProportion);
//    
//    [self.eleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.bleLabel.mas_right).with.offset(20*WidthProportion);
//        make.centerY.equalTo(self.bleLabel);
//    }];
//    
//    self.eleLabel = [[UILabel alloc]init];
//    [self.view addSubview:self.eleLabel];
//    self.eleLabel.font = [UIFont systemFontOfSize:12];
//    self.eleLabel.tag = 50;
//    self.eleLabel.text  = NSLocalizedString(@"x", nil);
//    self.eleLabel.frame =CGRectMake(136*WidthProportion, 160*HeightProportion, 6.5*WidthProportion, 15*HeightProportion);
//    
//    [self.eleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.eleImageView.mas_right).with.offset(8*WidthProportion);
//        make.centerY.equalTo(self.eleImageView);
//    }];
//    
//    //横线
//    self.lineView = [[UIView alloc]init];
//    [self.view addSubview:self.lineView];
//    self.lineView.backgroundColor = allColorWhite;
//    //列表
//    self.tableView = [[UITableView alloc]init];
//    [self.view addSubview:self.tableView];
//    
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    //    _tableView.backgroundView = nil;
//    _tableView.backgroundColor = [UIColor clearColor];//[UIColor cyanColor]
//    [_tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:reuseID];
//    self.dataArray = @[@"设备管理",NSLocalizedString(@"设备管理", nil),
//                       @"远程拍照",NSLocalizedString(@"遥控拍照", nil),
//                       @"设置", NSLocalizedString(@"设置", nil),
//                       @"关于", NSLocalizedString(@"关于", nil),];
//    
//    if (![HCHCommonManager getInstance].userInfoDictionAry)
//    {
//        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginCache"];
//        if (userInfo && userInfo.count != 0)
//        {
//            [HCHCommonManager getInstance].userInfoDictionAry = [[NSMutableDictionary alloc] initWithDictionary:userInfo];
//        }
//    }
//    else
//    {
//        if (!([HCHCommonManager getInstance].userInfoDictionAry[@"nick"] == [NSNull null]))
//        {
//            _userNameLabel.text = [HCHCommonManager getInstance].userInfoDictionAry[@"nick"];
//        }
//        
//    }
//    if (![CositeaBlueTooth sharedInstance].isConnected)
//    {
//        for (UIView *view in self.view.subviews)
//        {
//            if (view.tag == 50)
//            {
//                view.alpha = 0.5;
//            }
//        }
//    }
//    else
//    {
//        _eleLabel.text = [NSString stringWithFormat:@"%d%%",[HCHCommonManager getInstance].curPower];
//        _bleLabel.text = NSLocalizedString(@"已连接", nil);
//    }
//    
//    _blueManage = [CositeaBlueTooth sharedInstance];
//    
//    [_blueManage addObserver:self forKeyPath:@"isConnected" options:NSKeyValueObservingOptionNew context:nil];//观察连接的赋值
//    [[HCHCommonManager getInstance] addObserver:self forKeyPath:@"curPower" options:NSKeyValueObservingOptionNew context:nil];//观察电量的赋值
//    //    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
//    //    [center addObserver:self selector:@selector(viewWillRefresh) name:@"homeViewWillRefresh" object:nil];
//    [self viewWillRefresh];
//}
////观察电量的赋值
//
////观察连接的赋值
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
//{
//    if (!_blueManage.isConnected)
//    {
//        for (UIView *view in self.view.subviews)
//        {
//            if (view.tag == 50)
//            {
//                view.alpha = 0.5;
//            }
//            _bleLabel.text = NSLocalizedString(@"未连接", nil);
//            _eleLabel.text = @"x";
//        }
//    }else{
//        for (UIView *view in self.view.subviews)
//        {
//            if (view.tag == 50)
//            {
//                view.alpha = 1;
//            }
//        }
//        _bleLabel.text = NSLocalizedString(@"已连接", nil);
//        _eleLabel.text = [NSString stringWithFormat:@"%d%%",[HCHCommonManager getInstance].curPower];
//        //        [self viewWillRefresh];
//    }
//}
//
//
//-(void)layoutSubviews
//{
//    [super.view layoutSubviews];
//    self.backImageView.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height);
//    self.headImageView.frame = CGRectMake(0, 50*HeightProportion, 80*WidthProportion, 80*WidthProportion);
//    _headImageView.layer.cornerRadius = self.headImageView.width/2;
//    _headImageView.clipsToBounds = YES;
//    self.headBtn.size = self.headImageView.size;
//    
//    self.lineView.frame = CGRectMake(0, 193*HeightProportion, self.view.width, 1);
//    self.tableView.frame = CGRectMake(0, 194*HeightProportion, self.view.width, 473*HeightProportion);
//    
//    CGFloat userNameLabelX = _headImageView.frame.origin.x;
//    CGFloat userNameLabelY = CGRectGetMaxY(_headImageView.frame);
//    CGFloat userNameLabelW = self.view.width;
//    CGFloat userNameLabelH = 30 * HeightProportion;
//    _userNameLabel.frame = CGRectMake(userNameLabelX, userNameLabelY, userNameLabelW, userNameLabelH);
//    
//    self.headImageView.centerX = self.view.centerX;
//    _userNameLabel.centerX = self.headImageView.centerX;
//    self.headBtn.center = self.headImageView.center;
//    
//}
//
//- (void)personAction
//{
//    EditPersonInformationViewController * personVC = [EditPersonInformationViewController new];
//    personVC.isEdit = NO;
//    personVC.EditState = EditPersonStateEdit;
//    [self unitePushViewController:personVC];
//    //    [self.navigationController pushViewController:personVC animated:YES];
//    //adaLog(@"输出");
//}
//#pragma mark -- UITableViewDelegate
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return _dataArray.count/2;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
//    UIImage *image = [UIImage imageNamed:_dataArray[2*indexPath.row]];
//    cell.logoImageView.image = image;
//    NSString *titlle = _dataArray[2*indexPath.row + 1];
//    cell.buttonTittleLabel.text = titlle;
//    //    //adaLog(@"titlletitlle - %@",titlle);
//    //    cell.backgroundColor = [UIColor grayColor];
//    return cell;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    switch (indexPath.row)
//    {
//            //adaLog(@"indexPath = %ld",indexPath.row);
//            //            [self friendListPage];
//            //            break;
//        case 0:
//            [self SheBeiGuanLi:nil];
//            break;
//        case 1:
//            [self takePhoto];
//            break;
//        case 2:
//            [self sheZhiPage];
//            break;
//        case 3:
//            [self aboutPage:nil];
//            break;
//            //        case 4:
//            //            [self fuwuPage];
//            //            break;
//            //        case 5:
//        default:
//            break;
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 40.f*CurrentDeviceHeight/480.;
//}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.1f;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
//{
//    return _tableView.height - 40.f*CurrentDeviceHeight/480.*7;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc]init];
//    //    view.backgroundColor = allColorWhite;
//    //    view.userInteractionEnabled = YES;
//    _loginButtonTwo = [UIButton buttonWithType:UIButtonTypeCustom];
//    //    _loginButtonTwo.backgroundColor = allColorRed;
//    [_loginButtonTwo addTarget:self action:@selector(LoginActionTwo:) forControlEvents:UIControlEventTouchUpInside];
//    [_loginButtonTwo setTitleColor:kColor(31, 31, 31) forState:UIControlStateNormal];
//    if ([HCHCommonManager getInstance].isLogin)
//    {
//        [_loginButtonTwo setTitle:NSLocalizedString(@"注销", nil) forState:UIControlStateNormal];
//    }
//    else
//    {
//        [_loginButtonTwo setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
//    }
//    [view addSubview:_loginButtonTwo];
//    _loginButtonTwo.titleLabel.font = [UIFont systemFontOfSize:14];
//    [_loginButtonTwo sizeToFit];
//    _loginButtonTwo.sd_layout.centerYEqualToView(view)
//    .widthIs(_loginButtonTwo.width)
//    .leftSpaceToView(view,15);
//    
//    //    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 50, 50, 50)];
//    //    btn.backgroundColor = [UIColor greenColor];
//    //    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
//    //     [view addSubview:btn];
//    return view;
//}
//-(void)btnAction
//{
//    
//}
//#pragma mark -- UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1)
//    {
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        [AllTool addActityIndicatorInView:window labelText:NSLocalizedString(@"正在退出...", nil) detailLabel:NSLocalizedString(@"正在退出...", nil)];
//        [[AFAppDotNetAPIClient sharedClient]globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"user_loginOut" ParametersDictionary:nil Block:^(id responseObject, NSError *error,NSURLSessionDataTask *task) {
//            [AllTool removeActityIndicatorFromView:window];
//            if (error)
//            {
//                [AllTool addActityTextInView:window text:NSLocalizedString(@"服务器异常", nil) deleyTime:1.5f];
//            }
//            else
//            {
//                [HCHCommonManager getInstance].isLogin = NO;
//                [HCHCommonManager getInstance].userInfoDictionAry = nil;
//                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kThirdPartLoginKey];
//                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:LastLoginUser_Info];
//                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"loginCache"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                ViewController *welVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"Main"];
//                [AllTool setRootViewController:welVC animationType:kCATransitionPush];
//                //                [PSDrawerManager instance].closeView.hidden = YES;
//            }
//        }];
//    }
//}
//
////每次侧滑后都运行这个方法
//-(void)viewWillRefresh
//{
//    [[PZBlueToothManager sharedInstance] checkBandPowerWithPowerBlock:^(int number) {
//        if ([CositeaBlueTooth sharedInstance].isConnected)
//        {
//            for (UIView *view in self.view.subviews)
//            {
//                if (view.tag == 50)
//                {
//                    view.alpha = 1;
//                }
//            }
//            _eleLabel.text = [NSString stringWithFormat:@"%d%%",number];
//            _bleLabel.text = NSLocalizedString(@"已连接", nil);
//        }
//    }];
//    if (!([HCHCommonManager getInstance].userInfoDictionAry[@"nick"] == [NSNull null]))
//    {
//        _userNameLabel.text = [HCHCommonManager getInstance].userInfoDictionAry[@"nick"];
//    }
//    
//    [self settedHeadImageView];
//}
//
//-(void)settedHeadImageView
//{
//    NSString *name = [[HCHCommonManager getInstance].userInfoDictionAry objectForKey:@"header"] ;
//    if (name && (NSNull *)name != [NSNull null])
//    {
//        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
//        NSString *path = [cacheDir stringByAppendingPathComponent:name];
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        if (path && [fileManager fileExistsAtPath:path]) {
//            _headImageView.image = [[HCHCommonManager getInstance] getHeadImageWithFile:path];
//        }
//        else
//        {
//            //  testAFAppDotNetAPIBaseURLString  @"http://bracelet.cositea.com:8089/bracelet/download_userHeader"
//            
//            [[AFAppDotNetAPIClient sharedClient] globalDownloadWithUrl:[NSString stringWithFormat:@"%@%@",testAFAppDotNetAPIBaseURLString,@"download_userHeader"] Block:^(id responseObject, NSURL *filePath, NSError *error) {
//                if (error)
//                {
//                    //adaLog(@"error = %@",error.localizedDescription);
//                }
//                else
//                {
//                    if (filePath)
//                    {
//                        UIImage *image = [[HCHCommonManager getInstance] getHeadImageWithFile:[filePath path]];
//                        if (image)
//                        {
//                            _headImageView.image = image;
//                        }
//                        [[HCHCommonManager getInstance] setUserHeaderWith:[path lastPathComponent]];
//                    }
//                }
//            }];
//        }
//    }
//}
//
//#pragma  mark    - - - 私有方法
//- (void)SheBeiGuanLi:(id)sender
//{
//    SheBeiViewController *sheBeiVC = [SheBeiViewController sharedInstance];
//    [self unitePushViewController:sheBeiVC];
//    
//}
//
//- (void)aboutPage:(id)sender
//{
//    AboutViewController *aboutVC = [AboutViewController new];
//    [self unitePushViewController:aboutVC];
//}
//
//- (void)helpAction:(id)sender
//{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://bracelet.cositea.com:8089/bracelet/v3"]];
//    
//}
//
//- (void)LoginActionTwo:(id)sender
//{
//    if ([HCHCommonManager getInstance].isLogin)
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"注意", nil) message:NSLocalizedString(@"您确定退出当前帐号?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
//        [alertView show];
//        
//    }
//    else
//    {
//        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        ViewController *welVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"Main"];
//        [AllTool setRootViewController:welVC animationType:kCATransitionPush];
//        //        [PSDrawerManager instance].closeView.hidden = YES;
//    }
//    
//}
//- (void)fuwuPage
//{
//    HelpViewController *helpVC = [[HelpViewController alloc] init];
//    helpVC.navigationController.navigationBar.hidden = YES;
//}
//
////- (void)friendListPage
////{
////    //    if (![HCHCommonManager getInstance].isLogin)
////    //    {
////    //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
////    //        [self addActityTextInView:window text:NSLocalizedString(@"未登录", nil) deleyTime:1.5f];
////    //        return;
////    //    }
////    //    [self addCurrentPageScreenshot];
////    //    [self settingDrawerWhenPush];
////    FriendListViewController *friendVC = [[FriendListViewController alloc] init];
////    friendVC.navigationController.navigationBar.hidden = YES;
////
////}
//
//- (void)takePhoto
//{
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
//    {
//        if (![CositeaBlueTooth sharedInstance].isConnected)
//        {
//            [self addActityTextInView:window text:NSLocalizedString(@"蓝牙未连接", nil) deleyTime:1.5f];
//            return;
//        }
//    }
//    else
//    {
//        [self addActityTextInView:window text:NSLocalizedString(@"未绑定", nil) deleyTime:1.5f];
//        return;
//    }
//    //    [self addCurrentPageScreenshot];
//    //    [self settingDrawerWhenPush];
//    TakePhotoViewController *photeVC = [TakePhotoViewController new];
//    photeVC.navigationController.navigationBar.hidden = YES;
//    [self unitePushViewController:photeVC];
//}
//#pragma mark   - - - -   统一的   push  VC  的方法
//-(void)unitePushViewController:(UIViewController *)VC
//{
//    VC.hidesBottomBarWhenPushed = YES;
//    [[PSDrawerManager instance] resetShowType:PSDrawerManagerShowCenter];
//    
//    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    //    tempAppDelegate.mainTabBarController.selectedViewController.view.userInteractionEnabled = YES;
//    tempAppDelegate.coverBtn.hidden = YES;
//    
//    [tempAppDelegate.mainTabBarController.selectedViewController pushViewController:VC animated:NO];
//    //    [PSDrawerManager instance].closeView.hidden = YES;
//    
//}
//- (void)sheZhiPage
//{
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
//    {
//        if (![CositeaBlueTooth sharedInstance].isConnected)
//        {
//            [self addActityTextInView:window text:NSLocalizedString(@"蓝牙未连接", nil) deleyTime:1.5f];
//            return;
//        }
//    }
//    else
//    {
//        [self addActityTextInView:window text:NSLocalizedString(@"未绑定", nil) deleyTime:1.5f];
//        return;
//    }
//    
//    //    if (![CositeaBlueTooth sharedInstance].isConnected)
//    //    {
//    //        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    //        //        [self addActityTextInView:window text:NSLocalizedString(@"蓝牙未连接", nil) deleyTime:1.5f];
//    //        return;
//    //    }
//    SMTabbedSplitViewController *split = [[SMTabbedSplitViewController alloc] initTabbedSplit];
//    _split = split;
//    AlarmViewController *alarmVC = [AlarmViewController new];
//    
//    SMTabBarItem *alarmTab = [[SMTabBarItem alloc] initWithVC:alarmVC image:[UIImage imageNamed:@"闹钟"] selectedImage:[UIImage imageNamed:@"闹钟选中状态"] andTitle:@""];
//    
//    PhoneSetViewController *phoneVC = [[PhoneSetViewController alloc] init];
//    SMTabBarItem *alarmTab2 = [[SMTabBarItem alloc] initWithVC:phoneVC image:[UIImage imageNamed:@"来电提醒"] selectedImage:[UIImage imageNamed:@"来电提醒选中状态"] andTitle:@""];
//    
//    SMSAlarmViewController *SMSVC = [[SMSAlarmViewController alloc] init];
//    SMTabBarItem *alarmTab3 = [[SMTabBarItem alloc] initWithVC:SMSVC image:[UIImage imageNamed:@"信息提醒"]  selectedImage:[UIImage imageNamed:@"信息提醒选中状态"]andTitle:@""];
//    
//    JiuzuoViewController *jiuzuoVC = [JiuzuoViewController new];
//    SMTabBarItem *alarmTab4 = [[SMTabBarItem alloc] initWithVC:jiuzuoVC image:[UIImage imageNamed:@"久坐提醒"]  selectedImage:[UIImage imageNamed:@"久坐提醒选中状态"] andTitle:@""];
//    
//    HeartHomeAlarmViewController *heartVC = [[HeartHomeAlarmViewController alloc] init];
//    SMTabBarItem *alarmTab5 = [[SMTabBarItem alloc] initWithVC:heartVC image:[UIImage imageNamed:@"心率监测"]  selectedImage:[UIImage imageNamed:@"心率监测选中状态"] andTitle:@""];
//    
//    FangdiuViewController *fangdiuVC = [FangdiuViewController new];
//    SMTabBarItem *alarmTab6 = [[SMTabBarItem alloc] initWithVC:fangdiuVC image:[UIImage imageNamed:@"防丢提醒"] selectedImage:[UIImage imageNamed:@"防丢提醒选中状态"] andTitle:@""];
//    //抬腕唤醒
//    TaiwanViewController *taiwanVC = [TaiwanViewController new];
//    SMTabBarItem *alarmTab7 = [[SMTabBarItem alloc] initWithVC:taiwanVC image:[UIImage imageNamed:@"抬腕"] selectedImage:[UIImage imageNamed:@"抬腕选中状态"] andTitle:@""];
//    
//    //页面管理
//    pageManageViewController *pageVC = [pageManageViewController new];
//    SMTabBarItem *alarmTab8 = [[SMTabBarItem alloc] initWithVC:pageVC image:[UIImage imageNamed:@"按钮未选中"] selectedImage:[UIImage imageNamed:@"按钮选中"] andTitle:@""];
//    
//    split.background = [UIColor whiteColor];
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CurrentDeviceWidth, 64)];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [imageView addSubview:button];
//    
//    imageView.backgroundColor = [UIColor whiteColor];
//    UIView *topView = [[UIView alloc] init];
//    topView.backgroundColor = [UIColor blackColor];
//    [imageView addSubview:topView];
//    topView.frame = CGRectMake(0, 0, CurrentDeviceWidth, 20);
//    imageView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    imageView.layer.shadowOffset = CGSizeMake(0, 1);
//    imageView.layer.shadowOpacity = 0.6;
//    imageView.layer.shadowRadius = 4;
//    
//    button.sd_layout.leftSpaceToView(imageView,15)
//    .topSpaceToView (imageView,28)
//    .widthIs(24)
//    .heightIs(24);
//    [button setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
//    UIButton *bigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [imageView addSubview:bigBtn];
//    bigBtn.sd_layout.leftSpaceToView(imageView,0)
//    .topSpaceToView(imageView,10)
//    .widthIs(60)
//    .bottomEqualToView(imageView);
//    [bigBtn addTarget:split action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    imageView.userInteractionEnabled = YES;
//    [split.view addSubview:imageView];
//    UILabel *label = [[UILabel alloc] init];
//    [imageView addSubview:label];
//    label.text = NSLocalizedString(@"设置", nil);
//    [label sizeToFit];
//    label.font = [UIFont systemFontOfSize:17];
//    label.textColor = [UIColor blackColor];
//    label.sd_layout.centerXEqualToView(imageView)
//    .widthIs(label.width)
//    .topSpaceToView(imageView,31)
//    .heightIs(21);
//    //    [self addCurrentPageScreenshot];
//    //    [self settingDrawerWhenPush];
//    
//    
//    split.navigationController.navigationBar.hidden = YES;
//    
//    if ([[ADASaveDefaluts objectForKey:AllDEVICETYPE] integerValue] == 2)
//    {
//        
//        if([[ADASaveDefaluts objectForKey:SUPPORTPAGEMANAGER] integerValue]<4294967295)
//        {
//            split.tabsViewControllers = @[alarmTab,alarmTab2,alarmTab3,alarmTab4,alarmTab5,alarmTab6,alarmTab8];
//        }
//        else
//        {
//            split.tabsViewControllers = @[alarmTab,alarmTab2,alarmTab3,alarmTab4,alarmTab5,alarmTab6];
//        }
//        // split.tabsViewControllers = @[alarmTab,alarmTab2,alarmTab3,alarmTab4,alarmTab5,alarmTab6];
//    }
//    else
//    {
//        if([[ADASaveDefaluts objectForKey:SUPPORTPAGEMANAGER] integerValue]<4294967295)
//        {
//            split.tabsViewControllers = @[alarmTab,alarmTab2,alarmTab3,alarmTab4,alarmTab5,alarmTab6,alarmTab7,alarmTab8];
//        }
//        else
//        {
//            if([[ADASaveDefaluts objectForKey:SHOWPAGEMANAGER] integerValue]<4294967295)
//            {
//                split.tabsViewControllers = @[alarmTab,alarmTab2,alarmTab3,alarmTab4,alarmTab5,alarmTab6,alarmTab7,alarmTab8];
//            }
//            else
//            {
//                split.tabsViewControllers = @[alarmTab,alarmTab2,alarmTab3,alarmTab4,alarmTab5,alarmTab6,alarmTab7];
//            }
//        }
//        
//        // split.tabsViewControllers = @[alarmTab,alarmTab2,alarmTab3,alarmTab4,alarmTab5,alarmTab6,alarmTab7];
//    }
//    
//    [self unitePushViewController:_split];
//    //    [self.navigationController pushViewController:_split animated:YES];
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
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//@end

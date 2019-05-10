
//测试 服务器
//static NSString * const testAFAppDotNetAPIBaseURLString = @"https://bracelet.cositea.com:8445/bracelet/";
static NSString * const testAFAppDotNetAPIBaseURLString = @"http://bracelet.cositea.com:8089/bracelet/";
/**
 *
 *侧边栏的宽度
 */
#define  sideWidth (220 * WidthProportion)

#import "HomeViewController.h"
#import "SheBeiViewController.h"
#import "AboutViewController.h"
#import "HelpViewController.h"
#import "LoginViewController.h"
#import "EditPersonInformationViewController.h"
#import "AlarmViewController.h"
#import "ViewController.h"
#import "HomeTableViewCell.h"
#import "SMTabbedSplitViewController.h"
#import "SMTabBarItem.h"
#import "PhoneSetViewController.h"
#import "SMSAlarmViewController.h"
#import "JiuzuoViewController.h"
#import "HeartHomeAlarmViewController.h"
#import "FangdiuViewController.h"
#import "TakePhotoViewController.h"
//#import "FriendListViewController.h"
#import "HelpViewController.h"
#import "UIImage+ForceDecode.h"
#import "TaiwanViewController.h"
#import "pageManageViewController.h"
#import "PSDrawerManager.h"
#import "UIView+leoAdd.h"
#import "Masonry.h"
#import "AppDelegate.h"
#import "AlertUserInfomationViewController.h"
#import "MineEWMViewController.h"
#import "WLBarcodeViewController.h"
#import "NewFriendsViewController.h"

#import "HomeView.h"

@interface HomeView ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,ZBarReaderDelegate>

@property (nonatomic, weak) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *userNameLabel; //用户名字
//服务费日期
@property (nonatomic, strong) UILabel *serveDateLabel;

@property (nonatomic, strong) SMTabbedSplitViewController *split;


@property (nonatomic,strong) UIImageView *backImageView;//背景图
@property (nonatomic,strong) UIImageView *headImageView;//头图
@property (nonatomic,strong) UITableView *tableView;//列表

@property (nonatomic,strong) UIImageView *bleImageView;//蓝牙
@property (nonatomic,strong) UILabel *bleLabel;//蓝牙
@property (nonatomic,strong) UIImageView *eleImageView;//电量
@property (nonatomic,strong) UILabel *eleLabel;//电量

@property (nonatomic,strong) UIView *lineView;//横线
@property (nonatomic,strong) NSArray *dataArray;
//@property (nonatomic,strong) UILabel *userNameLabel; //用户名字
@property (nonatomic,strong) UIButton *headBtn;//头图的按钮
@property (strong, nonatomic) UIButton *loginButtonTwo;//注销按钮
@property (strong, nonatomic) UIButton *signOut;//退出
@property (nonatomic,strong) UIView *signline;//竖线

@property (strong, nonatomic) CositeaBlueTooth *blueManage;
@end


static NSString *reuseID  = @"CELL";


@implementation HomeView

+(id)sharedInstance
{
    static HomeView * instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        [self setupView];
    }
    return self;
}
-(void)setupView
{
    
    //背景图
    self.backImageView = [[UIImageView alloc]init];
    [self addSubview:self.backImageView];
//    self.backImageView.image = [UIImage imageNamed:@"CL_背景"];
    self.backImageView.backgroundColor = kColor(45, 141, 251);
    //头图
    self.headImageView = [[UIImageView alloc]init];
    [self addSubview:self.headImageView];
//    self.headImageView.image = [UIImage imageNamed:@"CL_head"];
//    [[HCHCommonManager getInstance] UserHeader];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[[HCHCommonManager getInstance] UserHeader]]  placeholderImage:[UIImage imageNamed:@"touxiang_"]];
    
    UIButton *headBtn = [[UIButton alloc]init];
    _headBtn = headBtn;
    [self addSubview:headBtn];
    //    headBtn.backgroundColor = allColorRed;
    [headBtn addTarget:self action:@selector(personAction) forControlEvents:UIControlEventTouchUpInside];
    
    //用户的名字
    _userNameLabel = [[UILabel alloc]init];
    [self addSubview:_userNameLabel];
    _userNameLabel.textColor = allColorWhite;
    _userNameLabel.textAlignment =NSTextAlignmentLeft;
    _userNameLabel.font = [UIFont systemFontOfSize:15];
    //服务费日期
    _serveDateLabel = [[UILabel alloc] init];
//    [self addSubview:_serveDateLabel];
    _serveDateLabel.font = [UIFont systemFontOfSize:10];
    //蓝牙
    self.bleImageView = [[UIImageView alloc]init];
    [self addSubview:self.bleImageView];
    self.bleImageView.image = [UIImage imageNamed:@"bluetooth"];
    
    CGFloat bleImageViewX=30*WidthProportion;
    CGFloat bleImageViewY=160*HeightProportion;
    CGFloat bleImageViewW=12*WidthProportion;
    CGFloat bleImageViewH=16*HeightProportion;
    self.bleImageView.frame = CGRectMake(bleImageViewX, bleImageViewY, bleImageViewW, bleImageViewH);
    
    self.bleLabel = [[UILabel alloc]init];
    [self addSubview:self.bleLabel];
    self.bleLabel.tag = 50;
    self.bleLabel.textColor = allColorWhite;
    self.bleLabel.text  = NSLocalizedString(@"未连接", nil);
    self.bleLabel.font = [UIFont systemFontOfSize:11];
    self.bleLabel.frame =CGRectMake(50*WidthProportion, 157*HeightProportion, 34*WidthProportion, 21*HeightProportion);
    
    [self.bleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bleImageView.mas_right).with.offset(8*WidthProportion);
        make.centerY.equalTo(self.bleImageView);
    }];
    
    //电量
    self.eleImageView = [[UIImageView alloc]init];
    [self addSubview:self.eleImageView];
    self.eleImageView.image = [UIImage imageNamed:@"battery"];
    self.eleImageView.frame =CGRectMake(104*WidthProportion, 160.5*HeightProportion, 20*WidthProportion, 14*HeightProportion);
    
    [self.eleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bleLabel.mas_right).with.offset(20*WidthProportion);
        make.centerY.equalTo(self.bleLabel);
    }];
    
    self.eleLabel = [[UILabel alloc]init];
    [self addSubview:self.eleLabel];
    self.eleLabel.font = [UIFont systemFontOfSize:12];
    self.eleLabel.tag = 50;
    self.eleLabel.textColor = allColorWhite;
    self.eleLabel.text  = NSLocalizedString(@"x", nil);
    self.eleLabel.frame =CGRectMake(136*WidthProportion, 160*HeightProportion, 6.5*WidthProportion, 15*HeightProportion);
    
    [self.eleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.eleImageView.mas_right).with.offset(8*WidthProportion);
        make.centerY.equalTo(self.eleImageView);
    }];
    
    //横线
    self.lineView = [[UIView alloc]init];
//    [self addSubview:self.lineView];
    self.lineView.backgroundColor = allColorWhite;
    //列表
    self.tableView = [[UITableView alloc]init];
    [self addSubview:self.tableView];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];//[UIColor cyanColor]
    [_tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:reuseID];
    self.dataArray = @[@"erweima",@"我的二维码",
                       @"saoyisao",@"扫一扫",
                       @"friends",@"亲友监护",
                       @"远程拍照",NSLocalizedString(@"遥控拍照", nil),
                       @"shebei",NSLocalizedString(@"设备管理", nil),
                       @"设置", NSLocalizedString(@"设置", nil),
                       @"关于", NSLocalizedString(@"关于", nil),];
    
    if (![HCHCommonManager getInstance].userInfoDictionAry)
    {
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginCache"];
        if (userInfo && userInfo.count != 0)
        {
            [HCHCommonManager getInstance].userInfoDictionAry = [[NSMutableDictionary alloc] initWithDictionary:userInfo];
        }
    }
    else
    {
        if (!([HCHCommonManager getInstance].userInfoDictionAry[@"nick"] == [NSNull null]))
        {
            _userNameLabel.text = [HCHCommonManager getInstance].userInfoDictionAry[@"nick"];
        }
        
    }
    if (![CositeaBlueTooth sharedInstance].isConnected)
    {
        for (UIView *view in self.subviews)
        {
            if (view.tag == 50)
            {
                view.alpha = 0.5;
            }
        }
    }
    else
    {
        _eleLabel.text = [NSString stringWithFormat:@"%d%%",[HCHCommonManager getInstance].curPower];
        _bleLabel.text = NSLocalizedString(@"已连接", nil);
    }
    
    _blueManage = [CositeaBlueTooth sharedInstance];
    
    [_blueManage addObserver:self forKeyPath:@"isConnected" options:NSKeyValueObservingOptionNew context:nil];//观察连接的赋值
    [[HCHCommonManager getInstance] addObserver:self forKeyPath:@"curPower" options:NSKeyValueObservingOptionNew context:nil];//观察电量的赋值
    [[HCHCommonManager getInstance] addObserver:self forKeyPath:@"isLogin" options:NSKeyValueObservingOptionNew context:nil];//观察电量的赋值
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observerUserInfo) name:UserInformationUpDateNotification object:nil];//观察个人信息的赋值
    //    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //    [center addObserver:self selector:@selector(viewWillRefresh) name:@"homeViewWillRefresh" object:nil];
    
    //退出
    _signOut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_signOut setTitle:@"退出" forState:UIControlStateNormal];
    [_signOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_signOut addTarget:self action:@selector(signOutAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_signOut];
    
    _signline = [[UIView alloc] init];
    [self addSubview:_signline];
    _signline.backgroundColor = kColor(116, 116, 116);
    
    //注销
    _loginButtonTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButtonTwo setTitle:@"注销" forState:UIControlStateNormal];
    [_loginButtonTwo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButtonTwo addTarget:self action:@selector(LoginActionTwo:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_loginButtonTwo];
    
    [self viewWillRefresh];
    [self observerUserInfo];
}
//观察个人信息的赋值
- (void)observerUserInfo{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[[HCHCommonManager getInstance] UserHeader]]  placeholderImage:[UIImage imageNamed:@"touxiang_"]];
    _userNameLabel.text = [[HCHCommonManager getInstance] UserAcount];
    _serveDateLabel.text = [NSString stringWithFormat:@"健康服务费%@到期",[[HCHCommonManager getInstance] UserVipTime]];
}

//观察电量的赋值


//观察连接的赋值
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isLogin"]) {
        
        if ([HCHCommonManager getInstance].isLogin)
        {
            [_loginButtonTwo setTitle:NSLocalizedString(@"注销", nil) forState:UIControlStateNormal];
        }
        else
        {
            [_loginButtonTwo setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
        }
    } else {
        
        
        if (!_blueManage.isConnected)
        {
            for (UIView *view in self.subviews)
            {
                if (view.tag == 50)
                {
                    view.alpha = 0.5;
                }
                _bleLabel.text = NSLocalizedString(@"未连接", nil);
                _eleLabel.text = @"x";
                [self setUimageViewWith:20];
            }
        }else{
            for (UIView *view in self.subviews)
            {
                if (view.tag == 50)
                {
                    view.alpha = 1;
                }
            }
            _bleLabel.text = NSLocalizedString(@"已连接", nil);
            _eleLabel.text = [NSString stringWithFormat:@"%d%%",[HCHCommonManager getInstance].curPower];
            //        [self viewWillRefresh];
            [self setUimageViewWith:[HCHCommonManager getInstance].curPower];
        }
    }
}


-(void)layoutSubviews {
    [super layoutSubviews];
    self.backImageView.frame = CGRectMake(0, 20, self.bounds.size.width, self.bounds.size.height);
    self.headImageView.frame = CGRectMake(10, 50*HeightProportion, 70*WidthProportion, 70*WidthProportion);
    _headImageView.layer.cornerRadius = self.headImageView.width/2;
    _headImageView.clipsToBounds = YES;
    
    self.lineView.frame = CGRectMake(0, 193*HeightProportion, self.width, 1);
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(_headImageView.frame)+10, self.width, 473*HeightProportion);
    
    CGFloat userNameLabelX = CGRectGetMaxX(_headImageView.frame)+10;
    CGFloat userNameLabelY = 50*HeightProportion;
    CGFloat userNameLabelW = self.width-CGRectGetMaxX(_headImageView.frame);
    CGFloat userNameLabelH = 20 * HeightProportion;
    _userNameLabel.frame = CGRectMake(userNameLabelX, userNameLabelY+10, userNameLabelW, userNameLabelH);
    
    self.headBtn.center = self.headImageView.center;
    self.headBtn.size = CGSizeMake(self.frame.size.width, 70*WidthProportion);
    
    _serveDateLabel.frame = CGRectMake(userNameLabelX, CGRectGetMaxY(_userNameLabel.frame), userNameLabelW, 20);
    
    CGRect bleRect = _bleImageView.frame;
    bleRect.origin.y = CGRectGetMaxY(_serveDateLabel.frame)+10-20;
    bleRect.origin.x = userNameLabelX;
    _bleImageView.frame = bleRect;
    
    _signOut.frame = CGRectMake(0, ScreenHeight-50, self.width/2, 30);
    _signline.frame = CGRectMake(CGRectGetMaxX(_signOut.frame)-0.5, ScreenHeight-45, 1, 20);
    _loginButtonTwo.frame = CGRectMake(CGRectGetMaxX(_signOut.frame), ScreenHeight-50, self.width/2, 30);
    
}

- (void)personAction
{
//    EditPersonInformationViewController * personVC = [EditPersonInformationViewController new];
//    personVC.isEdit = NO;
//    personVC.EditState = EditPersonStateEdit;
//    [self unitePushViewController:personVC];
    //    [self.navigationController pushViewController:personVC animated:YES];
    ////adaLog(@"输出");
    
    AlertUserInfomationViewController *personVC = [AlertUserInfomationViewController new];
    [self unitePushViewController:personVC];
    
}
#pragma mark -- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    UIImage *image = [UIImage imageNamed:_dataArray[2*indexPath.row]];
    cell.logoImageView.image = image;
    NSString *titlle = _dataArray[2*indexPath.row + 1];
    cell.buttonTittleLabel.text = titlle;
    //    ////adaLog(@"titlletitlle - %@",titlle);
    //    cell.backgroundColor = [UIColor grayColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
            ////adaLog(@"indexPath = %ld",indexPath.row);
            //            [self friendListPage];
            //            break;
        case 0://我的二维码
            [self EWMClick];
            break;
        case 1://扫一扫
            [self saoYiSao];
            break;
        case 2://亲友监护
            [self friendJH];
            break;
        case 3:
            [self takePhoto];
            break;
        case 4:
            [self SheBeiGuanLi:nil];
            break;
        case 5:
            [self sheZhiPage];
            break;
//        case 6://我的费用
//            [self feiYong:nil];
//            break;
//        case 8://我的推广
//            [self tuiGuang:nil];
//            break;
        case 6:
            [self aboutPage:nil];
            break;
            //        case 4:
            //            [self fuwuPage];
            //            break;
            //        case 5:
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f*CurrentDeviceHeight/480.;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
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
    return nil;
}
-(void)btnAction
{
    
}
#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        [AllTool addActityIndicatorInView:window labelText:NSLocalizedString(@"正在退出...", nil) detailLabel:NSLocalizedString(@"正在退出...", nil)];
//        [[AFAppDotNetAPIClient sharedClient]globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"user_loginOut" ParametersDictionary:nil Block:^(id responseObject, NSError *error,NSURLSessionDataTask *task) {}];
        //            [AllTool removeActityIndicatorFromView:window];
        //            if (error)
        //            {
        //                [AllTool addActityTextInView:window text:NSLocalizedString(@"网络连接错误", nil) deleyTime:1.5f];
        //            }
        //            else
        //            {
        [HCHCommonManager getInstance].isLogin = NO;
        [HCHCommonManager getInstance].userInfoDictionAry = nil;
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kThirdPartLoginKey];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:LastLoginUser_Info];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"loginCache"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *welVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"Main"];
        [AllTool setRootViewController:welVC animationType:kCATransitionPush];
        //                [PSDrawerManager instance].closeView.hidden = YES;
        //            }
        
    }
}

//每次侧滑后都运行这个方法
-(void)viewWillRefresh
{
    //    //adaLog(@"  = = = = = =  不断的请求");
    
    [[PZBlueToothManager sharedInstance] checkBandPowerWithPowerBlock:^(int number) {
        if ([CositeaBlueTooth sharedInstance].isConnected)
        {
            for (UIView *view in self.subviews)
            {
                if (view.tag == 50)
                {
                    view.alpha = 1;
                }
            }
            _eleLabel.text = [NSString stringWithFormat:@"%d%%",number];
            _bleLabel.text = NSLocalizedString(@"已连接", nil);
        }
    }];
    if (!([HCHCommonManager getInstance].userInfoDictionAry[@"nick"] == [NSNull null]))
    {
        _userNameLabel.text = [HCHCommonManager getInstance].userInfoDictionAry[@"nick"];
    }
    
    [self settedHeadImageView];
}

-(void)settedHeadImageView
{
    NSString *name = [[HCHCommonManager getInstance].userInfoDictionAry objectForKey:@"header"] ;
    if (name && (NSNull *)name != [NSNull null])
    {
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:name];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (path && [fileManager fileExistsAtPath:path]) {
            _headImageView.image = [[HCHCommonManager getInstance] getHeadImageWithFile:path];
        }
        else
        {
            //  testAFAppDotNetAPIBaseURLString  @"http://bracelet.cositea.com:8089/bracelet/download_userHeader"
            
            [[AFAppDotNetAPIClient sharedClient] globalDownloadWithUrl:[NSString stringWithFormat:@"%@%@",testAFAppDotNetAPIBaseURLString,@"download_userHeader"] Block:^(id responseObject, NSURL *filePath, NSError *error) {
                if (error)
                {
                    ////adaLog(@"error = %@",error.localizedDescription);
                }
                else
                {
                    if (filePath)
                    {
                        UIImage *image = [[HCHCommonManager getInstance] getHeadImageWithFile:[filePath path]];
                        if (image)
                        {
                            _headImageView.image = image;
                        }
                        [[HCHCommonManager getInstance] setUserHeaderWith:[path lastPathComponent]];
                    }
                }
            }];
        }
    }
}

#pragma  mark    - - - 私有方法
- (void)EWMClick{
    MineEWMViewController *mine = [MineEWMViewController new];
    [self unitePushViewController:mine];
}

- (void)friendJH{
    NewFriendsViewController *friend = [NewFriendsViewController new];
    [self unitePushViewController:friend];
}

- (void)saoYiSao{
    WLBarcodeViewController *vc=[[WLBarcodeViewController alloc] initWithBlock:^(NSString *str, BOOL isScceed) {
        
        if (isScceed) {
            NSLog(@"扫描后的结果~%@",str);
            [self addFriendWithId:str];
        }else{
            NSLog(@"扫描后的结果~%@",str);
            [self addActityTextInView:self text:@"无法识别" deleyTime:1.5f];
        }
    }];
    [self unitePresentViewController:vc];
}

- (void)SheBeiGuanLi:(id)sender
{
    SheBeiViewController *sheBeiVC = [SheBeiViewController sharedInstance];
    [self unitePushViewController:sheBeiVC];
    
}

//我的费用
- (void)feiYong:(id)sender{
    H5ViewController *h5 = [H5ViewController new];
    h5.titleStr = @"我的费用";
    //
    h5.url = [NSString stringWithFormat:@"https://rulong.lantianfangzhou.com/wechat2/fy.html?userID=%@&token=%@",USERID,TOKEN];
    [self unitePushViewController:h5];
}

//我的推广
- (void)tuiGuang:(id)sender{
    H5ViewController *h5 = [H5ViewController new];
    h5.titleStr = @"我的推广";
    h5.url = @"https://wap.youzan.com/salesman/home/tutorial/index?kdt_id=10292855";
    [self unitePushViewController:h5];
}


- (void)aboutPage:(id)sender
{
    AboutViewController *aboutVC = [AboutViewController new];
    [self unitePushViewController:aboutVC];
}

- (void)helpAction:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://bracelet.cositea.com:8089/bracelet/v3"]];
    
}

- (void)LoginActionTwo:(id)sender
{
    if ([HCHCommonManager getInstance].isLogin)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"注意", nil) message:NSLocalizedString(@"您确定退出当前帐号?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
        [alertView show];
        
    }
    else
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *welVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"Main"];
        [AllTool setRootViewController:welVC animationType:kCATransitionPush];
        //        [PSDrawerManager instance].closeView.hidden = YES;
    }
    
}

//退出
- (void)signOutAction{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        
        window.alpha = 0;
        
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
        
    } completion:^(BOOL finished) {
        
        exit(0);
        
    }];
}

- (void)fuwuPage
{
    HelpViewController *helpVC = [[HelpViewController alloc] init];
    helpVC.navigationController.navigationBar.hidden = YES;
}

//- (void)friendListPage
//{
//    //    if (![HCHCommonManager getInstance].isLogin)
//    //    {
//    //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    //        [self addActityTextInView:window text:NSLocalizedString(@"未登录", nil) deleyTime:1.5f];
//    //        return;
//    //    }
//    //    [self addCurrentPageScreenshot];
//    //    [self settingDrawerWhenPush];
//    FriendListViewController *friendVC = [[FriendListViewController alloc] init];
//    friendVC.navigationController.navigationBar.hidden = YES;
//
//}

- (void)takePhoto
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
    {
        if (![CositeaBlueTooth sharedInstance].isConnected)
        {
            [self addActityTextInView:window text:NSLocalizedString(@"蓝牙未连接", nil) deleyTime:1.5f];
            return;
        }
    }
    else
    {
        [self addActityTextInView:window text:NSLocalizedString(@"未绑定", nil) deleyTime:1.5f];
        return;
    }
    //    [self addCurrentPageScreenshot];
    //    [self settingDrawerWhenPush];
    TakePhotoViewController *photeVC = [TakePhotoViewController new];
    photeVC.navigationController.navigationBar.hidden = YES;
    [self unitePushViewController:photeVC];
}

#pragma mark - ZBarReaderDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    ZBarSymbolSet *result = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for (symbol in result) {
        break;
    }
    NSString *data = symbol.data;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark   - - - -   统一的   push  VC  的方法
-(void)unitePushViewController:(UIViewController *)VC
{
    //    VC.hidesBottomBarWhenPushed = YES;
    [[PSDrawerManager instance] resetShowType:PSDrawerManagerShowCenter];
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    tempAppDelegate.mainTabBarController.selectedViewController.view.userInteractionEnabled = YES;
    tempAppDelegate.coverBtn.hidden = YES;
    
    [VC setHidesBottomBarWhenPushed:YES];
    [tempAppDelegate.mainTabBarController.selectedViewController pushViewController:VC animated:NO];
    [[PSDrawerManager instance] cancelDragResponse];
    //    [PSDrawerManager instance].closeView.hidden = YES;
    
}

-(void)unitePresentViewController:(UIViewController *)VC
{
    //    VC.hidesBottomBarWhenPushed = YES;
    [[PSDrawerManager instance] resetShowType:PSDrawerManagerShowCenter];
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    tempAppDelegate.mainTabBarController.selectedViewController.view.userInteractionEnabled = YES;
    tempAppDelegate.coverBtn.hidden = YES;
    
    [VC setHidesBottomBarWhenPushed:YES];
    [tempAppDelegate.mainTabBarController.selectedViewController presentViewController:VC animated:YES completion:nil];
    [[PSDrawerManager instance] cancelDragResponse];
    //    [PSDrawerManager instance].closeView.hidden = YES;
    
}

- (void)sheZhiPage
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
    {
        if (![CositeaBlueTooth sharedInstance].isConnected)
        {
            [self addActityTextInView:window text:NSLocalizedString(@"蓝牙未连接", nil) deleyTime:1.5f];
            return;
        }
    }
    else
    {
        [self addActityTextInView:window text:NSLocalizedString(@"未绑定", nil) deleyTime:1.5f];
        return;
    }
    
    SMTabbedSplitViewController *split = [[SMTabbedSplitViewController alloc] initTabbedSplit];
    _split = split;
    AlarmViewController *alarmVC = [AlarmViewController new];
    
    SMTabBarItem *alarmTab = [[SMTabBarItem alloc] initWithVC:alarmVC image:[UIImage imageNamed:@"闹钟"] selectedImage:[UIImage imageNamed:@"闹钟选中状态"] andTitle:@""];
    
    PhoneSetViewController *phoneVC = [[PhoneSetViewController alloc] init];
    SMTabBarItem *alarmTab2 = [[SMTabBarItem alloc] initWithVC:phoneVC image:[UIImage imageNamed:@"来电提醒"] selectedImage:[UIImage imageNamed:@"来电提醒选中状态"] andTitle:@""];
    
    SMSAlarmViewController *SMSVC = [[SMSAlarmViewController alloc] init];
    SMTabBarItem *alarmTab3 = [[SMTabBarItem alloc] initWithVC:SMSVC image:[UIImage imageNamed:@"信息提醒"]  selectedImage:[UIImage imageNamed:@"信息提醒选中状态"]andTitle:@""];
    
    JiuzuoViewController *jiuzuoVC = [JiuzuoViewController new];
    SMTabBarItem *alarmTab4 = [[SMTabBarItem alloc] initWithVC:jiuzuoVC image:[UIImage imageNamed:@"久坐提醒"]  selectedImage:[UIImage imageNamed:@"久坐提醒选中状态"] andTitle:@""];
    
    HeartHomeAlarmViewController *heartVC = [[HeartHomeAlarmViewController alloc] init];
    SMTabBarItem *alarmTab5 = [[SMTabBarItem alloc] initWithVC:heartVC image:[UIImage imageNamed:@"心率监测"]  selectedImage:[UIImage imageNamed:@"心率监测选中状态"] andTitle:@""];
    
    FangdiuViewController *fangdiuVC = [FangdiuViewController new];
    SMTabBarItem *alarmTab6 = [[SMTabBarItem alloc] initWithVC:fangdiuVC image:[UIImage imageNamed:@"防丢提醒"] selectedImage:[UIImage imageNamed:@"防丢提醒选中状态"] andTitle:@""];
    //抬腕唤醒
    TaiwanViewController *taiwanVC = [TaiwanViewController new];
    SMTabBarItem *alarmTab7 = [[SMTabBarItem alloc] initWithVC:taiwanVC image:[UIImage imageNamed:@"抬腕"] selectedImage:[UIImage imageNamed:@"抬腕选中状态"] andTitle:@""];
    
    //页面管理
    pageManageViewController *pageVC = [pageManageViewController new];
    SMTabBarItem *alarmTab8 = [[SMTabBarItem alloc] initWithVC:pageVC image:[UIImage imageNamed:@"按钮未选中"] selectedImage:[UIImage imageNamed:@"按钮选中"] andTitle:@""];
    
    split.background = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CurrentDeviceWidth, 64)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageView addSubview:button];
    
    imageView.backgroundColor = [UIColor whiteColor];
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor blackColor];
    [imageView addSubview:topView];
    topView.frame = CGRectMake(0, 0, CurrentDeviceWidth, 20);
    imageView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    imageView.layer.shadowOffset = CGSizeMake(0, 1);
    imageView.layer.shadowOpacity = 0.6;
    imageView.layer.shadowRadius = 4;
    
    button.sd_layout.leftSpaceToView(imageView,15)
    .topSpaceToView (imageView,28)
    .widthIs(24)
    .heightIs(24);
    [button setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    UIButton *bigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageView addSubview:bigBtn];
    bigBtn.sd_layout.leftSpaceToView(imageView,0)
    .topSpaceToView(imageView,10)
    .widthIs(60)
    .bottomEqualToView(imageView);
    [bigBtn addTarget:split action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    imageView.userInteractionEnabled = YES;
    [split.view addSubview:imageView];
    UILabel *label = [[UILabel alloc] init];
    [imageView addSubview:label];
    label.text = NSLocalizedString(@"设置", nil);
    [label sizeToFit];
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor blackColor];
    label.sd_layout.centerXEqualToView(imageView)
    .widthIs(label.width)
    .topSpaceToView(imageView,31)
    .heightIs(21);
    //    [self addCurrentPageScreenshot];
    //    [self settingDrawerWhenPush];
    
    UIButton *guideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageView addSubview:guideButton];
    guideButton.frame = CGRectMake(CurrentDeviceWidth - 45, 32, 20, 20);
    [guideButton setImage:[UIImage imageNamed:@"zy-black"] forState:UIControlStateNormal];
    [guideButton addTarget:self action:@selector(guideAction) forControlEvents:UIControlEventTouchUpInside];
    
    split.navigationController.navigationBar.hidden = YES;
    
    if ([[ADASaveDefaluts objectForKey:AllDEVICETYPE] integerValue] == 2)
    {
        
        if([[ADASaveDefaluts objectForKey:SUPPORTPAGEMANAGER] integerValue]<4294967295)
        {
            split.tabsViewControllers = @[alarmTab,alarmTab2,alarmTab3,alarmTab4,alarmTab5,alarmTab6,alarmTab8];
        }
        else
        {
            split.tabsViewControllers = @[alarmTab,alarmTab2,alarmTab3,alarmTab4,alarmTab5,alarmTab6];
        }
        // split.tabsViewControllers = @[alarmTab,alarmTab2,alarmTab3,alarmTab4,alarmTab5,alarmTab6];
    }
    else
    {
        if([[ADASaveDefaluts objectForKey:SUPPORTPAGEMANAGER] integerValue]<4294967295)
        {
            split.tabsViewControllers = @[alarmTab,alarmTab2,alarmTab3,alarmTab4,alarmTab5,alarmTab6,alarmTab7,alarmTab8];
        }
        else
        {
            if([[ADASaveDefaluts objectForKey:SHOWPAGEMANAGER] integerValue]<4294967295)
            {
                split.tabsViewControllers = @[alarmTab,alarmTab2,alarmTab3,alarmTab4,alarmTab5,alarmTab6,alarmTab7,alarmTab8];
            }
            else
            {
                split.tabsViewControllers = @[alarmTab,alarmTab2,alarmTab3,alarmTab4,alarmTab5,alarmTab6,alarmTab7];
            }
        }
        
        // split.tabsViewControllers = @[alarmTab,alarmTab2,alarmTab3,alarmTab4,alarmTab5,alarmTab6,alarmTab7];
    }
    
    [self unitePushViewController:_split];
    //    [self.navigationController pushViewController:_split animated:YES];
    
    
}

//指引
- (void)guideAction{
    GuideLinesViewController *guide = [GuideLinesViewController new];
    guide.index = 0;
    guide.imageArr = @[@"set1"];
    [_split.navigationController pushViewController:guide animated:YES];
}

#pragma mark - 弹出HUD
- (void)addActityTextInView : (UIView *)view text : (NSString *)textString deleyTime : (float)times {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    //    hud.labelText = textString ;
    hud.label.text = textString;
    hud.margin = 10.f;
    //    	hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.square = YES;
    //    [hud hide:YES afterDelay:times];
    [hud hideAnimated:YES afterDelay:times];
}

-(void)setUimageViewWith:(int)electricity
{
//    if (electricity <= 30)
//    {
//        self.eleImageView.image = [UIImage imageNamed:@"electricity20"];
//    }
//    else if (electricity <= 50)
//    {
//        self.eleImageView.image = [UIImage imageNamed:@"electricity40"];
//    }
//    else if (electricity <= 70)
//    {
//        self.eleImageView.image = [UIImage imageNamed:@"electricity60"];
//    }
//    else if (electricity <= 90)
//    {
//        self.eleImageView.image = [UIImage imageNamed:@"electricity80"];
//    }
//    else
//    {
//        self.eleImageView.image = [UIImage imageNamed:@"electricity100"];
//    }
}

//#pragma mark - 更换主页面之后，改成push  和 pop
//
///// 添加当前页面的截屏
//- (void)addCurrentPageScreenshot {
//
//    UIImage *screenImage = [UIImage screenshot];
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:screenImage];
//    imgView.image = screenImage;
//    [self.view addSubview:imgView];
//    self.coverImageView = imgView;
//
//}
//
///// 设置抽屉视图pop后的状态
//- (void)settingDrawerWhenPop {
//    //    self.mm_drawerController.maximumLeftDrawerWidth = sideWidth;
//    //    self.mm_drawerController.showsShadow = YES;
//    //    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
//    //    [self.coverImageView removeFromSuperview];
//    //    self.coverImageView = nil;
//
//}
//
///// 设置抽屉视图push后的状态
//- (void)settingDrawerWhenPush {
//    //    [self.mm_drawerController setMaximumLeftDrawerWidth:CurrentDeviceWidth];
//    //    self.mm_drawerController.showsShadow = NO;
//    //    // 这里一定要关闭手势，否则隐藏在屏幕右侧的drawer可以被拖拽出来
//    //    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
//
//}

//添加好友
- (void)addFriendWithId:(NSString *)friendId{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [AllTool addActityIndicatorInView:window labelText:@"正在添加好友" detailLabel:@"正在添加好友"];
    [self performSelector:@selector(loginTimeOut) withObject:nil afterDelay:60.f];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@/%@",ADDFRIEND,TOKEN];
    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:uploadUrl fileUrl:nil params:@{@"userId":USERID,@"friendId":friendId} Block:^(id responseObject, NSError *error) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeOut) object:nil];
        
        [AllTool removeActityIndicatorFromView:window];
        if (error)
        {
            [AllTool addActityTextInView:window text:NSLocalizedString(@"网络连接错误", nil) deleyTime:1.5f];
        }
        else
        {
            int code = [[responseObject objectForKey:@"code"] intValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 0) {
                [AllTool addActityTextInView:window text:NSLocalizedString(@"添加成功", nil) deleyTime:1.5f];
            } else {
                [AllTool addActityTextInView:window text:NSLocalizedString(message, nil)  deleyTime:1.5f];
            }
        }
    }];
}


@end

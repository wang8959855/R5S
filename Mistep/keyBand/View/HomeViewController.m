//
//  HomeViewController.m
//  keyband
//
//  Created by 迈诺科技 on 15/10/29.
//  Copyright © 2015年 mainuo. All rights reserved.
//

//测试 服务器
static NSString * const testAFAppDotNetAPIBaseURLString = @"https://bracelet.cositea.com:8445/bracelet/";

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


@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic, weak) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) SMTabbedSplitViewController *split;
@end

static NSString *reuseID  = @"CELL";


@implementation HomeViewController



- (void)dealloc
{
    [_blueManage removeObserver:self forKeyPath:@"isConnected"];
    self.blueManage = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[PZBlueToothManager sharedInstance] checkBandPowerWithPowerBlock:^(int number) {
        if ([CositeaBlueTooth sharedInstance].isConnected)
        {
            for (UIView *view in self.view.subviews)
            {
                if (view.tag == 50)
                {
                    view.alpha = 1;
                }
            }
            _dianliangLabel.text = [NSString stringWithFormat:@"%d%%",number];
            _lianjieLabel.text = NSLocalizedString(@"已连接", nil);
        }
    }];
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
            _headerImageView.image = [[HCHCommonManager getInstance] getHeadImageWithFile:path];
        }
        else
        {
            //  testAFAppDotNetAPIBaseURLString  @"http://bracelet.cositea.com:8089/bracelet/download_userHeader"
            
            [[AFAppDotNetAPIClient sharedClient] globalDownloadWithUrl:[NSString stringWithFormat:@"%@%@",testAFAppDotNetAPIBaseURLString,@"/download_userHeader"] Block:^(id responseObject, NSURL *filePath, NSError *error) {
                if (error)
                {
                    //adaLog(@"error = %@",error.localizedDescription);
                }
                else
                {
                    if (filePath)
                    {
                        UIImage *image = [[HCHCommonManager getInstance] getHeadImageWithFile:[filePath path]];
                        if (image)
                        {
                            _headerImageView.image = image;
                        }
                        [[HCHCommonManager getInstance] setUserHeaderWith:[path lastPathComponent]];
                    }
                }
            }];
        }
    }
}
- (void)setupView
{
    [self setXibLabel];
    
    CGFloat userNameLabelX = _headerImageView.frame.origin.x;
    CGFloat userNameLabelY = CGRectGetMaxY(_headerImageView.frame);
    CGFloat userNameLabelW = _headerImageView.width;
    CGFloat userNameLabelH = 30 * HeightProportion;
    _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(userNameLabelX, userNameLabelY, userNameLabelW, userNameLabelH)];
    [self.view addSubview:_userNameLabel];
    _userNameLabel.alpha = 0.5;
    _userNameLabel.textAlignment =NSTextAlignmentCenter;
    //    _userNameLabel.text = @"123";
    //    _userNameLabel.backgroundColor = allColorRed;
    _userNameLabel.sd_layout
    .centerXEqualToView(_headerImageView)
    //    .leftSpaceToView(_headerImageView,-(_headerImageView.width))
    .topSpaceToView(_headerImageView,0)
    .widthIs(_headerImageView.width)
    .heightIs(userNameLabelH);
    
    
    self.navigationController.navigationBar.hidden = YES;
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
        for (UIView *view in self.view.subviews)
        {
            if (view.tag == 50)
            {
                view.alpha = 0.5;
            }
        }
    }
    else
    {
        _dianliangLabel.text = [NSString stringWithFormat:@"%d%%",[HCHCommonManager getInstance].curPower];
        _lianjieLabel.text = NSLocalizedString(@"已连接", nil);
    }
    
    _headerImageView.layer.cornerRadius = 40;
    _headerImageView.clipsToBounds = YES;
    
    
    
    _blueManage = [CositeaBlueTooth sharedInstance];
    
    [_blueManage addObserver:self forKeyPath:@"isConnected" options:NSKeyValueObservingOptionNew context:nil];
    // @"亲情关爱.png",NSLocalizedString(@"亲情关爱", nil),  @"服务",  NSLocalizedString(@"服务", nil),
    self.dataArray = @[@"设备管理.png",NSLocalizedString(@"设备管理", nil),
                       @"远程拍照",NSLocalizedString(@"遥控拍照", nil),
                       @"设置", NSLocalizedString(@"设置", nil),
                       @"关于", NSLocalizedString(@"关于", nil),];
    [_tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:reuseID];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];
    
    
}

- (void)setXibLabel
{
    _lianjieLabel.text = NSLocalizedString(@"未连接", nil);
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self settingDrawerWhenPop];
    if (!([HCHCommonManager getInstance].userInfoDictionAry[@"nick"] == [NSNull null]))
    {
        _userNameLabel.text = [HCHCommonManager getInstance].userInfoDictionAry[@"nick"];
    }
    
}
- (void)viewDidLayoutSubviews
{
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (!_blueManage.isConnected)
    {
        for (UIView *view in self.view.subviews)
        {
            if (view.tag == 50)
            {
                view.alpha = 0.5;
            }
            _lianjieLabel.text = NSLocalizedString(@"未连接", nil);
            _dianliangLabel.text = @"x";
        }
    }else{
        for (UIView *view in self.view.subviews)
        {
            if (view.tag == 50)
            {
                view.alpha = 1;
            }
        }
        _dianliangLabel.text = [NSString stringWithFormat:@"%d%%",[HCHCommonManager getInstance].curPower];
        _lianjieLabel.text = NSLocalizedString(@"已连接", nil);
    }
}


- (void)SheBeiGuanLi:(id)sender
{
    [self addCurrentPageScreenshot];
    [self settingDrawerWhenPush];
    
    SheBeiViewController *sheBeiVC = [SheBeiViewController sharedInstance];
    [self.navigationController pushViewController:sheBeiVC animated:YES];
    //[self setRootViewController:sheBeiVC animationType:kCATransitionPush];
}

- (void)aboutPage:(id)sender
{
    [self addCurrentPageScreenshot];
    [self settingDrawerWhenPush];
    
    AboutViewController *aboutVC = [AboutViewController new];
    [self.navigationController pushViewController:aboutVC animated:YES];
    //[self setRootViewController:aboutVC animationType:kCATransitionPush];
}

- (void)helpAction:(id)sender
{
    //    HelpViewController *helpVC = [HelpViewController new];
    //    [self setRootViewController:helpVC animationType:kCATransitionPush];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://bracelet.cositea.com:8089/bracelet/v3"]];
    
}

- (void)LoginAction:(id)sender
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
        [self setRootViewController:welVC animationType:kCATransitionPush];
    }
    
}



- (IBAction)personAction:(id)sender
{
    [self addCurrentPageScreenshot];
    [self settingDrawerWhenPush];
    EditPersonInformationViewController * personVC = [EditPersonInformationViewController new];
    personVC.isEdit = NO;
    personVC.EditState = EditPersonStateEdit;
    [self.navigationController pushViewController:personVC animated:YES];
    
    //    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:personVC];
    //    personVC.navigationController.navigationBar.hidden = YES;
    //    [self setRootViewController:nav animationType:nil];
    
    
}
#pragma mark - 更换主页面之后，改成push  和 pop

/// 添加当前页面的截屏
- (void)addCurrentPageScreenshot {
    
    UIImage *screenImage = [UIImage screenshot];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:screenImage];
    imgView.image = screenImage;
    [self.view addSubview:imgView];
    self.coverImageView = imgView;
    
}

/// 设置抽屉视图pop后的状态
- (void)settingDrawerWhenPop {
//    self.mm_drawerController.maximumLeftDrawerWidth = sideWidth;
//    self.mm_drawerController.showsShadow = YES;
//    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
//    [self.coverImageView removeFromSuperview];
//    self.coverImageView = nil;
    
}

/// 设置抽屉视图push后的状态
- (void)settingDrawerWhenPush { 
//    [self.mm_drawerController setMaximumLeftDrawerWidth:CurrentDeviceWidth];
//    self.mm_drawerController.showsShadow = NO;
//    // 这里一定要关闭手势，否则隐藏在屏幕右侧的drawer可以被拖拽出来
//    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
    
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
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
            //            [self friendListPage];
            //            break;
        case 0:
            [self SheBeiGuanLi:nil];
            break;
        case 1:
            [self takePhoto];
            break;
        case 2:
            [self sheZhiPage];
            break;
        case 3:
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

- (void)fuwuPage
{
    [self addCurrentPageScreenshot];
    [self settingDrawerWhenPush];
    HelpViewController *helpVC = [[HelpViewController alloc] init];
    helpVC.navigationController.navigationBar.hidden = YES;
    [self.navigationController pushViewController:helpVC animated:YES];
    //[self setRootViewController:helpVC animationType:nil];
}

//- (void)friendListPage
//{
//    if (![HCHCommonManager getInstance].isLogin)
//    {
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        [self addActityTextInView:window text:NSLocalizedString(@"未登录", nil) deleyTime:1.5f];
//        return;
//    }
//    [self addCurrentPageScreenshot];
//    [self settingDrawerWhenPush];
//    FriendListViewController *friendVC = [[FriendListViewController alloc] init];
//    friendVC.navigationController.navigationBar.hidden = YES;
//    [self.navigationController pushViewController:friendVC animated:YES];
//    
//    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:friendVC];
//    //    friendVC.navigationController.navigationBar.hidden = YES;
//    //    [self setRootViewController:nav animationType:nil];
//}

- (void)takePhoto
{
    if (![CositeaBlueTooth sharedInstance].isConnected)
    {
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        [self addActityTextInView:window text:NSLocalizedString(@"蓝牙未连接", nil) deleyTime:1.5f];
        return;
    }
    [self addCurrentPageScreenshot];
    [self settingDrawerWhenPush];
    TakePhotoViewController *photeVC = [TakePhotoViewController new];
    photeVC.navigationController.navigationBar.hidden = YES;
    [self.navigationController pushViewController:photeVC animated:YES];
    //[self setRootViewController:photeVC animationType:nil];
}


- (void)sheZhiPage
{
    if (![CositeaBlueTooth sharedInstance].isConnected)
    {
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        [self addActityTextInView:window text:NSLocalizedString(@"蓝牙未连接", nil) deleyTime:1.5f];
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
    
    
    
    //    split.tabsViewControllers = @[alarmTab,alarmTab2,alarmTab3,alarmTab5,alarmTab6];
    
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
    [self addCurrentPageScreenshot];
    [self settingDrawerWhenPush];
    
    
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
            split.tabsViewControllers = @[alarmTab,alarmTab2,alarmTab3,alarmTab4,alarmTab5,alarmTab6,alarmTab7];
        }
        if([[ADASaveDefaluts objectForKey:SHOWPAGEMANAGER] integerValue]<4294967295)
        {
            split.tabsViewControllers = @[alarmTab,alarmTab2,alarmTab3,alarmTab4,alarmTab5,alarmTab6,alarmTab7,alarmTab8];
        }
        // split.tabsViewControllers = @[alarmTab,alarmTab2,alarmTab3,alarmTab4,alarmTab5,alarmTab6,alarmTab7];
    }
    [self.navigationController pushViewController:_split animated:YES];
    
    
    // [self performSelector:@selector(selfPushSet) withObject:nil afterDelay:1.0f];
    
    // [[CositeaBlueTooth sharedInstance] checkPageManager:^(uint pageManager) {
    
    //   [self.navigationController popToRootViewControllerAnimated:YES];
    //        if (pageManager>=0)
    //        {
    // [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(selfPushSet) object:nil];
    // split.tabsViewControllers = @[alarmTab,alarmTab2,alarmTab3,alarmTab4,alarmTab5,alarmTab6,alarmTab7,alarmTab8];
    //        }
    //        else
    //        {   }
    // [self.navigationController pushViewController:split animated:YES];
    //  }];
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:split];
    //    split.navigationController.navigationBar.hidden = YES;
    //    [self setRootViewController:nav animationType:kCATransitionPush];
}
//-(void)selfPushSet
//{
//    if(_split)
//    {[self.navigationController pushViewController:_split animated:YES];}
//}
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
    return _tableView.height - 40.f*CurrentDeviceHeight/480.*7;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton addTarget:self action:@selector(LoginAction:) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton setTitleColor:kColor(31, 31, 31) forState:UIControlStateNormal];
    if ([HCHCommonManager getInstance].isLogin)
    {
        [_loginButton setTitle:NSLocalizedString(@"注销", nil) forState:UIControlStateNormal];
    }
    else
    {
        [_loginButton setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
    }
    [view addSubview:_loginButton];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_loginButton sizeToFit];
    _loginButton.sd_layout.centerYEqualToView(view)
    .widthIs(_loginButton.width)
    .leftSpaceToView(view,15);
    return view;
}

#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [self addActityIndicatorInView:window labelText:NSLocalizedString(@"正在退出...", nil) detailLabel:NSLocalizedString(@"正在退出...", nil)];
        [[AFAppDotNetAPIClient sharedClient]globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"user_loginOut" ParametersDictionary:nil Block:^(id responseObject, NSError *error,NSURLSessionDataTask *task) {
            [self removeActityIndicatorFromView:window];
            if (error)
            {
                [self addActityTextInView:window text:NSLocalizedString(@"网络连接错误", nil) deleyTime:1.5f];
            }else
            {
                [HCHCommonManager getInstance].isLogin = NO;
                [HCHCommonManager getInstance].userInfoDictionAry = nil;
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kThirdPartLoginKey];
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:LastLoginUser_Info];
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"loginCache"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ViewController *welVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"Main"];
                [self setRootViewController:welVC animationType:kCATransitionPush];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

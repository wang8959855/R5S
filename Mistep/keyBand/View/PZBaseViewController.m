
//
//  PZBaseViewController.m
//  keyband
//
//  Created by 迈诺科技 on 15/10/27.
//  Copyright © 2015年 mainuo. All rights reserved.
//

/**
 *
 *侧边栏的宽度
 */
#define  sideWidth (220 * WidthProportion)

#import "PZBaseViewController.h"

#import "HomeViewController.h"
#import "TodayViewController.h"
//#import "YRSideViewController.h"
#import "SharedViewController.h"
#import "MainTabBarController.h"
#import "TodayStepsViewController.h"
//#import "TodaySportViewController.h"
#import "TodaySportMapViewController.h"
#import "TodaySleepViewController.h"
#import "XueyaViewController.h"
#import "UIImage+ForceDecode.h"
#import "DeviceTypeViewController.h"
//#import "LeftView.h"
#import "UIView+leoAdd.h"
#import "PSDrawerManager.h"
#import "HomeView.h"
//#import "HomeTwoViewController.h"
#import "HealthTestingViewController.h"
#import "HealtPoliceViewController.h"
#import "HealtRegulationViewController.h"

#import "AppDelegate.h"
#import "EditPersonalInformationOneViewController.h"
#import "SleepNewViewController.h"


#import "SignViewController.h"
#import "MoreView.h"

@interface PZBaseViewController ()
{
    UIImageView *navImageView;
}

@property (nonatomic, weak) UIImageView *coverImageView;

@end

@implementation PZBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _topNavView.backgroundColor = [UIColor whiteColor];
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor blackColor];
    [_topNavView addSubview:topView];
    topView.frame = CGRectMake(0, 0, CurrentDeviceWidth, 20);
    _topNavView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _topNavView.layer.shadowOffset = CGSizeMake(0, 1);
    _topNavView.layer.shadowOpacity = 0.6;
    _topNavView.layer.shadowRadius = 4;
    _topNavView.userInteractionEnabled = YES;
    
    _topNavView2.backgroundColor = [UIColor whiteColor];
    UIView *topView1 = [[UIView alloc] init];
    topView1.backgroundColor = [UIColor blackColor];
    [_topNavView2 addSubview:topView1];
    topView1.frame = CGRectMake(0, 0, CurrentDeviceWidth, 20);
    _topNavView2.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _topNavView2.layer.shadowOffset = CGSizeMake(0, 1);
    _topNavView2.layer.shadowOpacity = 0.6;
    _topNavView2.layer.shadowRadius = 4;
    
    _hour1.text = NSLocalizedString(@"小时", nil);
    _hour2.text = NSLocalizedString(@"小时", nil);
    _hour3.text = NSLocalizedString(@"小时", nil);
    _hour4.text = NSLocalizedString(@"小时", nil);
    
    _minites1.text = NSLocalizedString(@"分钟", nil);
    _minites2.text = NSLocalizedString(@"分钟", nil);
    _minites3.text = NSLocalizedString(@"分钟", nil);
    _minites4.text = NSLocalizedString(@"分钟", nil);
    
    _colories1.text = NSLocalizedString(@"千卡", nil);
    _colories2.text = NSLocalizedString(@"千卡", nil);
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreView) name:@"PushMoreView" object:nil];
}

- (void)moreView{
    [MoreView moreView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 更换主页面
- (void)setRootViewController:(UIViewController *)viewController animationType:(NSString *)animationType
{
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    CATransition *animation = [CATransition  animation ];
    animation.subtype = kCATransitionFromRight;
    animation.duration = 0.25;
    animation.type = kCATransitionPush;
    [window.layer addAnimation:animation forKey:nil];
    window.rootViewController = viewController;
}

- (void)popToViewController:(UIViewController *)viewController animationType:(NSString *)animationType
{
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    CATransition *animation = [CATransition  animation ];
    animation.subtype = kCATransitionFromLeft;
    animation.duration = 0.25;
    animation.type = kCATransitionPush;
    [window.layer addAnimation:animation forKey:nil];
    
    window.rootViewController = viewController;
}

- (UIResponder *)checkNextResponderIsKindOfViewController : (Class)viewClass{
    UIResponder *reResponder = nil ;
    
    for (UIView* next = self.view.superview ; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass: viewClass ]) {
            reResponder = nextResponder ;
            
            break;
        }
    }
    
    return reResponder ;
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
//
//    self.mm_drawerController.maximumLeftDrawerWidth = sideWidth;
//    self.mm_drawerController.showsShadow = YES;
//    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
//    [self.coverImageView removeFromSuperview];
//    self.coverImageView = nil;
//
//}
//
///// 设置抽屉视图push后的状态
//- (void)settingDrawerWhenPush {
//
//    [self.mm_drawerController setMaximumLeftDrawerWidth:CurrentDeviceWidth];
//    self.mm_drawerController.showsShadow = NO;
//    // 这里一定要关闭手势，否则隐藏在屏幕右侧的drawer可以被拖拽出来
//    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
//
//}

//#pragma mark - UINavigationControllerDelegate
//
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//
//    if ([viewController isKindOfClass:[HomeViewController class]]) {
//        [navigationController setNavigationBarHidden:NO animated:YES];
//    } else {
//        [navigationController setNavigationBarHidden:NO animated:YES];
//    }
//
//}

#pragma mark - 判断帐号密码
- (BOOL) isUserName:(NSString *)userName
{
    
    if (userName.length == 0)
    {
        //        [self showAlertView:NSLocalizedString( @"帐号不能为空，请输入不少于4个字符的帐号", nil)];
        return NO;
    }
    else
    {
        if (userName.length<4 || userName.length>32)
        {
            //            [self showAlertView:NSLocalizedString(@"帐号输入错误，请输入不少于4个字符的帐号", nil) ];
            return NO;
        }
        NSString * regex = @"([A-Za-z0-9\_]{4,32}$)";
        NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        //        BOOL isRight = [pred evaluateWithObject:userName];
        if (![pred evaluateWithObject:userName])
        {
            //            [self showAlertView:NSLocalizedString(@"帐号输入只允许大小写字母、数字、下划线", nil) ];
            return NO;
        }
    }
    return YES;
}



- (BOOL) isPassWord:(NSString *)passWord
{
    if (passWord.length == 0)
    {
        //        [self showAlertView:NSLocalizedString(@"密码不能为空，请输入不少于6个字符的密码", nil) ];
        return NO;
    }
    else if (passWord.length < 6)
    {
        //        [self showAlertView:NSLocalizedString(@"密码输入错误，请输入不少于6个字符的密码", nil) ];
        return NO;
    }
    return YES;
}

- (BOOL) isEmail:(NSString *)string
{
    if (string.length == 0)
    {
        //        [self showAlertView:NSLocalizedString(@"邮箱不能为空，请输入邮箱", nil) ];
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isEmail = [emailTest evaluateWithObject:string];
    if (isEmail)
    {
        return YES;
    }
    else
    {
        //        [self showAlertView:NSLocalizedString(@"邮箱格式输入错误，请检查您的邮箱", nil) ];
        return NO;
    }
}

- (BOOL) checkUserName:(NSString *)userName
{
    if (userName.length == 0)
    {
        [self showAlertView:NSLocalizedString( @"手机号不能为空", nil)];
        return NO;
    }
    else
    {
        if (userName.length != 11)
        {
            [self showAlertView:NSLocalizedString(@"请输入正确的手机号", nil) ];
            return NO;
        }
    }
    return YES;
    
}

- (BOOL) checkPassWord:(NSString *)passWord
{
    if (passWord.length == 0)
    {
        [self showAlertView:NSLocalizedString(@"验证码不能为空", nil) ];
        return NO;
    }
    return YES;
    
}


- (BOOL) checkEmail:(NSString *)string
{
    if (string.length == 0)
    {
        [self showAlertView:NSLocalizedString(@"邮箱不能为空，请输入邮箱", nil) ];
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isEmail = [emailTest evaluateWithObject:string];
    if (isEmail)
    {
        return YES;
    }
    else
    {
        [self showAlertView:NSLocalizedString(@"邮箱格式输入错误，请检查您的邮箱", nil) ];
        return NO;
    }
    
}

- (void)showAlertView:(NSString *)string
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:string delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    [self performSelector:@selector(hidenAlertView:) withObject:alertView afterDelay:2.];
}

- (void)hidenAlertView:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

- (MainTabBarController *)gettabBarController
{
    MainTabBarController *tabBar = [[MainTabBarController alloc] init];
    tabBar.tabBar.tintColor = kMainColor;
    
    UIView *mview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CurrentDeviceWidth, 49)];
//    mview.backgroundColor = kColor(20, 67, 131);
    [tabBar.tabBar insertSubview:mview atIndex:0];
    
//    TodayStepsViewController *helthTesing = [TodayStepsViewController sharedInstance];
    SignViewController *helthTesing = [SignViewController new];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:helthTesing];
    helthTesing.navigationController.navigationBar.hidden = YES;
    UITabBarItem *tabItem1 = [[UITabBarItem alloc] init];
    tabItem1.image = [[UIImage imageNamed:@"healthy-white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabItem1.selectedImage = [[UIImage imageNamed:@"healthy-blue"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabItem1.title = @"体征";
    helthTesing.tabBarItem = tabItem1;
//    tabItem1.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    //TodaySportViewController *sportVC = [[TodaySportViewController alloc] init];
    //UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:sportVC];
    
    //sportVC.navigationController.navigationBar.hidden = YES;
    // UITabBarItem *tabItem2 = [[UITabBarItem alloc] init];
    // sportVC.tabBarItem =tabItem2;
//    TodaySportMapViewController *sportVC = [[TodaySportMapViewController alloc] init];
    
    
    UIViewController *con = [UIViewController new];
    UINavigationController *nav00 = [[UINavigationController alloc] initWithRootViewController:con];
    con.navigationController.navigationBar.hidden = YES;
    UITabBarItem *tabItem00 = [[UITabBarItem alloc] init];
    tabItem00.image = [[UIImage imageNamed:@"yuan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabItem00.selectedImage = [[UIImage imageNamed:@"yuan-hou"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    con.tabBarItem =tabItem00;
    
    SleepNewViewController *policeVC = [[SleepNewViewController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:policeVC];
    policeVC.navigationController.navigationBar.hidden = YES;
    UITabBarItem *tabItem2 = [[UITabBarItem alloc] init];
    policeVC.tabBarItem =tabItem2;
//    tabItem2.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    tabItem2.image = [[UIImage imageNamed:@"steps-white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabItem2.selectedImage = [[UIImage imageNamed:@"steps-blue"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabItem2.title = @"睡眠";
    
    TodaySleepViewController *todaySleepVC = [[TodaySleepViewController alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:todaySleepVC];
    todaySleepVC.navigationController.navigationBar.hidden = YES;
    UITabBarItem *tabItem3 = [[UITabBarItem alloc] init];
    todaySleepVC.tabBarItem =tabItem3;
//    tabItem3.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    tabItem3.image = [[UIImage imageNamed:@"report-white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabItem3.selectedImage = [[UIImage imageNamed:@"report-blue"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabItem3.title = @"报告";
    
    
//    XueyaViewController *xueyaVC = [[XueyaViewController alloc] init];
    HealtRegulationViewController *regulation = [[HealtRegulationViewController alloc] init];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:regulation];
    regulation.navigationController.navigationBar.hidden = YES;
    UITabBarItem *tabItem4 = [[UITabBarItem alloc] init];
    regulation.tabBarItem =tabItem4;
//    tabItem4.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    tabItem4.image = [[UIImage imageNamed:@"regulate-white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabItem4.selectedImage = [[UIImage imageNamed:@"regulate-blue"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabItem4.title = @"运动";
    
    NSArray *tabbarItems;
    uint supportNum = [[ADASaveDefaluts objectForKey:SUPPORTPAGEMANAGER] doubleValue];
//    if (supportNum >> 7 & 1) {
//        tabbarItems = @[nav1,nav2,nav3];
//    } else {
//    }
    tabbarItems = @[nav1,nav3,nav00,nav4,nav2];
    [tabBar setViewControllers:tabbarItems animated:YES];
    
    UITabBarItem *item = [UITabBarItem appearance];
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateSelected];
    
    return tabBar;
}

#pragma mark - 获取用户信息
- (void)getUserInfo{
    NSString *url = [NSString stringWithFormat:@"%@/%@",GETUSERINFO,TOKEN];
    if (!USERID) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userId"];
        return;
    }
    WeakSelf;
    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:url fileUrl:nil params:@{@"userId":USERID} Block:^(id responseObject, NSError *error) {
        if (error){
            [weakSelf removeActityIndicatorFromView:weakSelf.view];
            [weakSelf addActityTextInView:self.view text:NSLocalizedString(@"服务器异常", ni) deleyTime:1.5f];
        }else{
            int code = [[responseObject objectForKey:@"code"] intValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 0) {
                NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"data"]];
                for (NSString *str in [tempDic allKeys]) {
                    if ((NSNull *)tempDic[str] == [NSNull null]) {
                        [tempDic setValue:@"" forKey:str];
                    }
                }
                [HCHCommonManager getInstance].userInfoDictionAry = [NSMutableDictionary dictionaryWithDictionary:tempDic];
                [ADASaveDefaluts setObject:[[HCHCommonManager getInstance] UserDiastolicP] forKey:BLOODPRESSURELOW];
                [ADASaveDefaluts setObject:[[HCHCommonManager getInstance] UserSystolicP] forKey:BLOODPRESSUREHIGH];
                [[NSUserDefaults standardUserDefaults] setObject:tempDic forKey:@"loginCache"];
                
                if ([tempDic[@"Name"] length] == 0) {
                    EditPersonalInformationOneViewController *editVC = [[UIStoryboard storyboardWithName:@"EditPersonalInformationViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"EditPersonalOne"];
                    editVC.uploadInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:USERID ,@"userId", nil];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:editVC];
                    [self setRootViewController:nav animationType:nil];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:UserInformationUpDateNotification object:nil];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:nil];
//                [self performSelector:@selector(dimissAlertController:) withObject:alert afterDelay:1.5];
            }
        }
    }];
}

- (void)loginHome
{
    //获取用户信息
    [self getUserInfo];
    if ([[[HCHCommonManager getInstance] UserTel] isEqualToString:@"17791548573"]) {
        [ADASaveDefaluts setDeviceType:@"001"];
    }else{
        //检查是否有设备类型
        BOOL isYes = [self checkDeviceType];
        if (isYes) {
            return;
        }
    }
    
    self.tabBarCon = [self gettabBarController];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    tempAppDelegate.mainTabBarController = self.tabBarCon;
    HomeView *leftView = [[HomeView alloc]init];
    //[HomeView sharedInstance];
    leftView.frame = CGRectMake(0, 0, 250*WidthProportion, CurrentDeviceHeight);
    //    HomeTwoViewController *VC = [[HomeTwoViewController alloc] init];
    //    VC.view.frame = CGRectMake(0, 0, 250*WidthProportion, CurrentDeviceHeight);
    //    UIView *leftView = [VC view];
    [[PSDrawerManager instance] installCenterViewController:self.tabBarCon leftView:leftView];
    
    //    HomeViewController *leftVC = [HomeViewController new];
    //    UINavigationController *leftNav = [[UINavigationController alloc]initWithRootViewController:leftVC];
    //    LeftView *leftView = [[LeftView alloc] initWithFrame:CGRectMake(0, 0,375,667)];
    //   [[PSDrawerManager instance] installCenterViewController:tabBar leftView:leftView];
    //    MMDrawerController * drawerController = [[MMDrawerController alloc] initWithCenterViewController:tabBar leftDrawerViewController:leftNav];
    //    [drawerController setMaximumLeftDrawerWidth:sideWidth];
    //    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    //    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    //    [self setRootViewController:drawerController animationType:kCATransitionPush];
}
-(BOOL)checkDeviceType
{
    if (![ADASaveDefaluts getDeviceTypeForKey])
    {
        DeviceTypeViewController *type = [[DeviceTypeViewController alloc]init];
        type.isHiddenBackButton = YES;
        type.navigationController.navigationBar.hidden = YES;
        [self.navigationController pushViewController:type animated:YES];
        
        return  YES;
    }
    return NO;
}
- (void)backToHome
{
    //检查是否有设备类型
    BOOL isYes = [self checkDeviceType];
    if (isYes) {
        return;
    }
    MainTabBarController *tabBar = [self gettabBarController];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    tempAppDelegate.mainTabBarController = tabBar;
    HomeView *leftView = [[HomeView alloc]init];
    leftView.frame = CGRectMake(0, 0, 250*WidthProportion, CurrentDeviceHeight);
    
    //    HomeTwoViewController *VC = [[HomeTwoViewController alloc] init];
    //    VC.view.frame = CGRectMake(0, 0, 250*WidthProportion, CurrentDeviceHeight);
    //    UIView *leftView = [VC view];
    [[PSDrawerManager instance] installCenterViewController:tabBar leftView:leftView];
    
    //    HomeViewController *leftVC = [HomeViewController new];
    //    UINavigationController *leftNav = [[UINavigationController alloc]initWithRootViewController:leftVC];
    
    //    LeftView *leftView = [[LeftView alloc] initWithFrame:CGRectMake(0, 0,CurrentDeviceWidth,CurrentDeviceHeight)];
    
    //    MMDrawerController * drawerController = [[MMDrawerController alloc] initWithCenterViewController:tabBar leftDrawerViewController:leftNav];
    //    [drawerController setMaximumLeftDrawerWidth:sideWidth];
    //    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    //    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    //    [self popToViewController:drawerController animationType:nil];
}


- (NSMutableAttributedString *)makeAttributedStringWithString:(NSString *)string andLength:(int)length
{
    NSMutableAttributedString *stepString = [[NSMutableAttributedString alloc]initWithString:string];
    if ([HCHCommonManager getInstance].LanuguageIndex_SRK == ChinesLanguage_Enum ||[HCHCommonManager getInstance].LanuguageIndex_SRK == KoreaLanguage_Enum)
    {
        [stepString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(length, string.length - length)];
    }
    else
    {
        if(string.length >= 5)
        {
            [stepString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(length, string.length - length)];
        }
        else
        {
            [stepString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(length, string.length - length)];
        }
    }
    return stepString;
}

//# pragma mark - 获取sideVC
//- (YRSideViewController *)getSideVC
//{
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    YRSideViewController *sideVC = (YRSideViewController *)window.rootViewController;
//    return sideVC;
//}

- (void)loginTimeOut{
    [self removeActityIndicatorFromView:self.view];
    [self addActityTextInView:self.view text:NSLocalizedString(@"服务器异常", nil)  deleyTime:1.5f];
}

#pragma mark - 颜色生成Image

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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

- (void)addActityIndicatorInView :(UIView *)view labelText : (NSString *)labelString detailLabel : (NSString *)detailString{
    
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:view];
    //    hud.dimBackground = YES ;
    
    if(labelString != nil)
        //        hud.labelText =  labelString ;
        hud.label.text = labelString;
    if(detailString != nil)
        //        hud.detailsLabelText = detailString ;
        hud.detailsLabel.text = detailString;
    hud.square = YES;
    
    [view addSubview:hud];
    //    [hud show:YES];
    [hud showAnimated:YES];
}

- (void)removeActityIndicatorFromView : (UIView *)view{
    for( UIView *viewInView in [view subviews]){
        if( [viewInView isKindOfClass:[MBProgressHUD class] ]){
            [viewInView removeFromSuperview];
            break;
        }
    }
}

- (void)setButtonWithButton:(UIButton *)button andTitle:(NSString *)string
{
    [button setBackgroundColor:kColor(73, 126, 227)];
    [button setTitle:string forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
}

- (void)shareVC
{
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    SharedViewController *shareVC = [SharedViewController new];
    shareVC.image = viewImage;
    
    
    [self.navigationController pushViewController:shareVC animated:YES];
}

- (void)loginStateTimeOutWithBlock:(void(^)(BOOL state))block;
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:LastLoginUser_Info];
    if (dic)
    {
        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"user_login" ParametersDictionary:dic Block:^(id responseObject, NSError *error,NSURLSessionTask *task) {
            if (error) {
                [self removeActityIndicatorFromView:self.view];
                [self addActityTextInView:self.view text:NSLocalizedString(@"失败", nil) deleyTime:1.5f];
                if (block)
                {
                    block(NO);
                }
            }else {
                int code = [[responseObject objectForKey:@"code"] intValue];
                if(code == 9003) {
                    int timeSeconds = [[TimeCallManager getInstance] getSecondsOfCurDay];
                    NSDictionary *dic = [[SQLdataManger getInstance]getTotalDataWith:timeSeconds];
                    if (!dic) {
                        NSString *macAddress = [AllTool amendMacAddressGetAddress];
                        //                        NSString *macAddress = [ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
                        //                        if (!macAddress)
                        //                        {
                        //                            macAddress = DEFAULTDEVICEID;
                        //                        }
                        dic = [NSDictionary dictionaryWithObjectsAndKeys:
                               [[HCHCommonManager getInstance]UserAcount],CurrentUserName_HCH,
                               [NSNumber numberWithInt:timeSeconds],  DataTime_HCH,
                               [NSNumber numberWithInt:0], TotalSteps_DayData_HCH,
                               [NSNumber numberWithInt:0], TotalMeters_DayData_HCH,
                               [NSNumber numberWithInt:0], TotalCosts_DayData_HCH,
                               [NSNumber numberWithInt:[HCHCommonManager getInstance].sleepPlan ], Sleep_PlanTo_HCH,
                               [NSNumber numberWithInt:[HCHCommonManager getInstance].stepsPlan], Steps_PlanTo_HCH,
                               [NSNumber numberWithInt:0],TotalDeepSleep_DayData_HCH,
                               [NSNumber numberWithInt:0],TotalLittleSleep_DayData_HCH,
                               [NSNumber numberWithInt:0],TotalWarkeSleep_DayData_HCH,
                               [NSNumber numberWithInt:0],TotalSleepCount_DayData_HCH,
                               [NSNumber numberWithInt:testEventCount],TotalDayEventCount_DayData_HCH,
                               [NSNumber numberWithInt:0],TotalDataActivityTime_DayData_HCH,
                               [NSNumber numberWithInt:[[TimeCallManager getInstance] getWeekIndexInYearWith:timeSeconds]], TotalDataWeekIndex_DayData_HCH,
                               [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]],DEVICETYPE,
                               macAddress,DEVICEID,
                               @"0",ISUP,
                               nil];
                        [[SQLdataManger getInstance]insertSignalDataToTable:DayTotalData_Table withData:dic];
                    }
                    
                    if (block)
                    {
                        block(YES);
                    }
                    
                }else {
                    [self removeActityIndicatorFromView:self.view];
                    [self addActityTextInView:self.view text:(NSLocalizedString(@"失败", nil)) deleyTime:1.5f];
                }
            }
        }];
    }
    else{
        NSDictionary *thirdDic = [[NSUserDefaults standardUserDefaults] objectForKey:kThirdPartLoginKey];
        if (thirdDic)
        {
            [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"user_thirdPartyLogin" ParametersDictionary:thirdDic Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
                if (error)
                {
                    [self addActityTextInView:self.view text:(NSLocalizedString(@"失败", nil)) deleyTime:1.5f];
                    if (block)
                    {
                        block(NO);
                    }
                }
                else
                {
                    int code = [responseObject[@"code"] intValue];
                    if (code == 9003)
                    {
                        int timeSeconds = [[TimeCallManager getInstance] getSecondsOfCurDay];
                        NSDictionary *dic = [[SQLdataManger getInstance]getTotalDataWith:timeSeconds];
                        if (!dic) {
                            NSString *macAddress = [AllTool amendMacAddressGetAddress];
                            //                            NSString *macAddress = [ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
                            //                            if (!macAddress)
                            //                            {
                            //                                macAddress = DEFAULTDEVICEID;
                            //                            }
                            dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [[HCHCommonManager getInstance]UserAcount],CurrentUserName_HCH,
                                   [NSNumber numberWithInt:timeSeconds],  DataTime_HCH,
                                   [NSNumber numberWithInt:0], TotalSteps_DayData_HCH,
                                   [NSNumber numberWithInt:0], TotalMeters_DayData_HCH,
                                   [NSNumber numberWithInt:0], TotalCosts_DayData_HCH,
                                   [NSNumber numberWithInt:[HCHCommonManager getInstance].sleepPlan ], Sleep_PlanTo_HCH,
                                   [NSNumber numberWithInt:[HCHCommonManager getInstance].stepsPlan], Steps_PlanTo_HCH,
                                   [NSNumber numberWithInt:0],TotalDeepSleep_DayData_HCH,
                                   [NSNumber numberWithInt:0],TotalLittleSleep_DayData_HCH,
                                   [NSNumber numberWithInt:0],TotalWarkeSleep_DayData_HCH,
                                   [NSNumber numberWithInt:0],TotalSleepCount_DayData_HCH,
                                   [NSNumber numberWithInt:testEventCount],TotalDayEventCount_DayData_HCH,
                                   [NSNumber numberWithInt:0],TotalDataActivityTime_DayData_HCH,
                                   [NSNumber numberWithInt:[[TimeCallManager getInstance] getWeekIndexInYearWith:timeSeconds]], TotalDataWeekIndex_DayData_HCH,
                                   [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]],DEVICETYPE,
                                   macAddress,DEVICEID,
                                   @"0",ISUP,
                                   nil];
                            [[SQLdataManger getInstance]insertSignalDataToTable:DayTotalData_Table withData:dic];
                        }
                    }
                    if (block)
                    {
                        block(YES);
                    }
                }
            }];
        }
    }
}

- (BOOL)stringNotNull:(NSString *)string
{
    if ((NSNull *)string == [NSNull null])
    {
        return NO;
    }
    return YES;
}

//在后台登录
- (void)backstageUseCacheLogin:(NSDictionary *)loginDic
{
    [self getUserInfoDiction];//把缓存的东西放到运行中
    if (kHCH.iphoneNetworkStatus==NotReachable)
    {
        return;
    }
    int timeSeconds = [[TimeCallManager getInstance] getSecondsOfCurDay];
    NSDictionary *dic = [[SQLdataManger getInstance]getTotalDataWith:timeSeconds];
    if (!dic) {
        NSString *macAddress = [AllTool amendMacAddressGetAddress];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               [[HCHCommonManager getInstance]UserAcount],CurrentUserName_HCH,
               [NSNumber numberWithInt:timeSeconds],  DataTime_HCH,
               [NSNumber numberWithInt:0], TotalSteps_DayData_HCH,
               [NSNumber numberWithInt:0], TotalMeters_DayData_HCH,
               [NSNumber numberWithInt:0], TotalCosts_DayData_HCH,
               [NSNumber numberWithInt:[HCHCommonManager getInstance].sleepPlan ], Sleep_PlanTo_HCH,
               [NSNumber numberWithInt:[HCHCommonManager getInstance].stepsPlan], Steps_PlanTo_HCH,
               [NSNumber numberWithInt:0],TotalDeepSleep_DayData_HCH,
               [NSNumber numberWithInt:0],TotalLittleSleep_DayData_HCH,
               [NSNumber numberWithInt:0],TotalWarkeSleep_DayData_HCH,
               [NSNumber numberWithInt:0],TotalSleepCount_DayData_HCH,
               [NSNumber numberWithInt:testEventCount],TotalDayEventCount_DayData_HCH,
               [NSNumber numberWithInt:0],TotalDataActivityTime_DayData_HCH,
               [NSNumber numberWithInt:[[TimeCallManager getInstance] getWeekIndexInYearWith:timeSeconds]], TotalDataWeekIndex_DayData_HCH,
               [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]],DEVICETYPE,
               macAddress,DEVICEID,
               @"0",ISUP,
               nil];
        [[SQLdataManger getInstance]insertSignalDataToTable:DayTotalData_Table withData:dic];
    }
    [[NSUserDefaults standardUserDefaults] setObject:loginDic forKey:LastLoginUser_Info];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *url = [NSString stringWithFormat:@"%@/tel/%@/code/%@",LOGIN,dic[@"userName"],dic[@""]];
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:loginDic Block:^(id responseObject, NSError *error,NSURLSessionDataTask *task)
     {
         if (error)
         {
         }
         else
         {
             int code = [[responseObject objectForKey:@"code"] intValue];
             
             if (code == 9003)
             {
                 [AllTool startUpData];
                 NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                 NSString *name = [tempDic objectForKey:@"header"] ;
                 if ((NSNull *)name == [NSNull null]) {
                     [tempDic setValue:nil forKey:@"header"];
                 }
                 [[NSUserDefaults standardUserDefaults] setObject:tempDic forKey:@"loginCache"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 
                 [HCHCommonManager getInstance].userInfoDictionAry = [NSMutableDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                 [[HCHCommonManager getInstance] setUserAcountName:loginDic[@"account"]];
                 [HCHCommonManager getInstance].isLogin = YES;
                 [HCHCommonManager getInstance].isThirdPartLogin = NO;
             }
             else if(code == 9004){
             }else {
             }
         }
     }];
}
//在后台登录
- (void)backstageuseThirdCacheLogin:(NSDictionary *)param
{
    [self getUserInfoDiction];//把缓存的东西放到运行中
    if (kHCH.iphoneNetworkStatus==NotReachable)
    {
        return;
    }
    int timeSeconds = [[TimeCallManager getInstance] getSecondsOfCurDay];
    NSDictionary *dic = [[SQLdataManger getInstance]getTotalDataWith:timeSeconds];
    if (!dic) {
        NSString *macAddress = [AllTool amendMacAddressGetAddress];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               [[HCHCommonManager getInstance]UserAcount],CurrentUserName_HCH,
               [NSNumber numberWithInt:timeSeconds],  DataTime_HCH,
               [NSNumber numberWithInt:0], TotalSteps_DayData_HCH,
               [NSNumber numberWithInt:0], TotalMeters_DayData_HCH,
               [NSNumber numberWithInt:0], TotalCosts_DayData_HCH,
               [NSNumber numberWithInt:[HCHCommonManager getInstance].sleepPlan ], Sleep_PlanTo_HCH,
               [NSNumber numberWithInt:[HCHCommonManager getInstance].stepsPlan], Steps_PlanTo_HCH,
               [NSNumber numberWithInt:0],TotalDeepSleep_DayData_HCH,
               [NSNumber numberWithInt:0],TotalLittleSleep_DayData_HCH,
               [NSNumber numberWithInt:0],TotalWarkeSleep_DayData_HCH,
               [NSNumber numberWithInt:0],TotalSleepCount_DayData_HCH,
               [NSNumber numberWithInt:testEventCount],TotalDayEventCount_DayData_HCH,
               [NSNumber numberWithInt:0],TotalDataActivityTime_DayData_HCH,
               [NSNumber numberWithInt:[[TimeCallManager getInstance] getWeekIndexInYearWith:timeSeconds]], TotalDataWeekIndex_DayData_HCH,
               [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]],DEVICETYPE,
               macAddress,DEVICEID,
               @"0",ISUP,
               nil];
        [[SQLdataManger getInstance]insertSignalDataToTable:DayTotalData_Table withData:dic];
    }
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"user_thirdPartyLogin" ParametersDictionary:param Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
        if (error)
        {
        }
        else
        {
            [self partLoginDic:responseObject];
        }
    } ];
}

- (void)partLoginDic:(NSDictionary *)param;
{
    int code = [param[@"code"] intValue];
    if (code == 9003)
    {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[param objectForKey:@"data"]];
        [AllTool startUpData];
        NSString *headString = tempDic[@"header"];
        if ((NSNull *)headString != [NSNull null])
        {
            [[NSUserDefaults standardUserDefaults] setObject:tempDic forKey:@"loginCache"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [HCHCommonManager getInstance].userInfoDictionAry = [NSMutableDictionary dictionaryWithDictionary:[param objectForKey:@"data"]];
        [HCHCommonManager getInstance].isLogin = YES;
        [HCHCommonManager getInstance].isThirdPartLogin = YES;

    }
}
//取出缓存中的东西放到运行中
-(void)getUserInfoDiction
{
    NSMutableDictionary *userInfoDic = [ADASaveDefaluts objectForKey:@"loginCache"];
    [HCHCommonManager getInstance].userInfoDictionAry = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
}
@end

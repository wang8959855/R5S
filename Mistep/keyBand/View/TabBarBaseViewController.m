//
//  TabBarBaseViewController.m
//  Mistep
//
//  Created by 迈诺科技 on 2016/9/24.
//  Copyright © 2016年 huichenghe. All rights reserved.
//


#define kAppDelegate [[UIApplication sharedApplication] delegate]
#define KONEDAYSECONDS 86400


#import "TabBarBaseViewController.h"
#import "TrendViewController.h"
#import "SharedViewController.h"
#import "AppDelegate.h" 
#import "PSDrawerManager.h"


@interface TabBarBaseViewController ()

@end

@implementation TabBarBaseViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated
{
//    [_datePickBtn setTitle:[self changeDateTommddeWithSeconds:kHCH.selectTimeSeconds] forState:UIControlStateNormal];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hiddenDateBackView];
}

#pragma mark -- 内部方法



- (BOOL)isToday
{
    return [HCHCommonManager getInstance].selectTimeSeconds == kHCH.todayTimeSeconds;
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


- (void)addButtonsOnNavView:(UIView *)navView isBackButton:(BOOL)isBackBtn
{
    if (isBackBtn)
    {
        UIButton *leftVCBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftVCBtn.frame = CGRectMake(3, StatusBarHeight , 50, SafeAreaTopHeight-StatusBarHeight);
        [leftVCBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [leftVCBtn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:leftVCBtn];
    }
    else
    {
        UIButton *leftVCBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftVCBtn.frame = CGRectMake(3, StatusBarHeight , 50, SafeAreaTopHeight-StatusBarHeight);
        [leftVCBtn setImage:[UIImage imageNamed:@"caidan"] forState:UIControlStateNormal];
        [leftVCBtn addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:leftVCBtn];
    }
    
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(CurrentDeviceWidth - 45 - 3, StatusBarHeight, 45, SafeAreaTopHeight-StatusBarHeight);
    shareBtn.tag = 1002;
    [shareBtn setImage:[UIImage imageNamed:@"share_it"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:shareBtn];
    
    UIButton *trendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    trendBtn.frame = CGRectMake(shareBtn.left - 45, StatusBarHeight, 45, SafeAreaTopHeight-StatusBarHeight);
    [trendBtn setImage:[UIImage imageNamed:@"Details"] forState:UIControlStateNormal];
    [trendBtn addTarget:self action:@selector(trendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [navView addSubview:trendBtn];
    
    [navView addSubview:self.datePickBtn];
    self.datePickBtn.size = CGSizeMake(120, SafeAreaTopHeight-StatusBarHeight);
    self.datePickBtn.origin = CGPointMake(ScreenWidth/2-60, StatusBarHeight);
    self.datePickBtn.titleLabel.font = Font_Normal_String(14);
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(_datePickBtn.left - 30, StatusBarHeight, 30, SafeAreaTopHeight-StatusBarHeight);
    [leftBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    leftBtn.tag =0;
    [leftBtn addTarget:self action:@selector(changeDateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [navView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(_datePickBtn.right, StatusBarHeight, 30, SafeAreaTopHeight-StatusBarHeight);
    [rightBtn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    rightBtn.tag = 1;
    [rightBtn addTarget:self action:@selector(changeDateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [navView addSubview:rightBtn];
}

- (void)dateSureClick
{
    NSDate *pickDate = _datePicker.date;
    NSDateFormatter *formates = [[NSDateFormatter alloc]init];
    [formates setDateFormat:@"yyyy/MM/dd"];
    NSString *dayString = [formates stringFromDate:pickDate];
    kHCH.selectTimeSeconds = [[TimeCallManager getInstance] getSecondsWithTimeString:dayString andFormat:@"yyyy/MM/dd"];
    [self hiddenDateBackView];
    [self timeSecondsChanged];
}

- (void)hiddenDateBackView
{
    [UIView animateWithDuration:0.23 animations:^{
        _animationView.frame = CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, 246);
    } completion:^(BOOL finished) {
        
        [_backView removeFromSuperview];
        _backView = nil;
        [_datePicker removeFromSuperview];
        _datePicker = nil;
    }];
}

#pragma mark -- button方法

- (void)backButtonClick:(UIButton *)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chooseDate
{
    _backView = [[UIView alloc] initWithFrame:CurrentDeviceBounds];
    _backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_backView];
    
    _animationView  = [[UIView alloc] initWithFrame:CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, 246 + 49)];
    [_backView addSubview:_animationView];
    _animationView.backgroundColor = [UIColor whiteColor];
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30,CurrentDeviceWidth, 216)];
    NSString* string = @"19000101";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate* minDate = [formatter dateFromString:string];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.backgroundColor = [UIColor whiteColor];
    NSDate *maxDate = [NSDate date];
    _datePicker.maximumDate = maxDate;
    _datePicker.minimumDate = minDate;
    [_animationView addSubview:_datePicker];
    
    //        UIView *buttonView = [[UIView alloc] init];
    //        buttonView.backgroundColor = [UIColor redColor];
    //        [_animationView addSubview:buttonView];
    //        CGFloat buttonViewW = 30;
    //        CGFloat buttonViewH = buttonViewW;
    //        CGFloat buttonViewX = CurrentDeviceWidth - buttonViewW;
    //        CGFloat buttonViewY = buttonViewW;
    //        buttonView.frame = CGRectMake(buttonViewX, buttonViewY, buttonViewW, buttonViewH);
    //        buttonView.sd_layout
    //        .topSpaceToView(_animationView,10)
    //        .rightSpaceToView(_animationView,20)
    //        .heightIs(30)
    //        .widthIs(30);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_animationView addSubview:button];
    button.frame = CGRectMake(CurrentDeviceWidth-80, 0, 80, 40);
    //    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(dateSureClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *btnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    btnImageView.image = [UIImage imageNamed:@"xuanze"];
    btnImageView.center = button.center;
    [_animationView addSubview:btnImageView];
    
    [UIView animateWithDuration:0.23 animations:^{
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        if (self.haveTabBar)
        {
            _animationView.frame = CGRectMake(0, CurrentDeviceHeight-246 - 49,CurrentDeviceWidth, 246);
        }
        else
        {
            _animationView.frame = CGRectMake(0, CurrentDeviceHeight-246,CurrentDeviceWidth, 246);
        }
    }];
}

- (void)leftButtonClick:(UIButton *)button
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [UIView animateWithDuration:0.3f animations:^{
        
        CGAffineTransform rightScopeTransform = CGAffineTransformTranslate([kAppDelegate window].transform, CurrentDeviceWidth * kLeftWidthScale, 0);
        
        
        tempAppDelegate.mainTabBarController.view.transform = rightScopeTransform;
        
    }completion:^(BOOL finished) {
        //        [(MainTabBarController*)tempAppDelegate.mainTabBarController selectedViewController].view.userInteractionEnabled  = NO;
        //        kHCH.coverBtn.hidden = YES;
//        AppDelegate *app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
        tempAppDelegate.coverBtn.hidden = NO;
    }];
    
    
}

- (void)shareButtonClick:(UIButton *)button
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, [UIScreen mainScreen].scale);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    SharedViewController *shareVC = [SharedViewController new];
    shareVC.image = viewImage;
    
    shareVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shareVC animated:YES];
}

- (void)trendButtonClick:(UIButton *)button
{
    TrendViewController *trendVC = [TrendViewController new];
    trendVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:trendVC animated:YES];
}

- (void)changeDateButtonClick:(UIButton *)button
{
    return;
    if (button.tag == 0)
    {
        kHCH.selectTimeSeconds -= KONEDAYSECONDS;
        [self timeSecondsChanged];
    }
    else
    {
        //        右
        if (kHCH.todayTimeSeconds == kHCH.selectTimeSeconds)
        {
            return;
        }
        else
        {
            kHCH.selectTimeSeconds += KONEDAYSECONDS;
            [self timeSecondsChanged];
        }
    }
}

- (void)childrenTimeSecondChanged
{
    
}

- (NSString *)changeDateTommddeWithSeconds:(int)seconds
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    if (kHCH.todayTimeSeconds == kHCH.selectTimeSeconds)
    {
        //        [dateFormatter setDateFormat:@"MM.dd  "];
        //        NSString *dateString = [dateFormatter stringFromDate:date];
        return [NSString stringWithFormat:@"%@",NSLocalizedString(@"今天", nil)];
    }
    [dateFormatter setDateFormat:@"MM.dd  E"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return [NSString stringWithFormat:@"%@",dateString];
}

#pragma mark -- get方法
- (UIView *)navView
{
    if (!_navView)
    {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CurrentDeviceWidth, SafeAreaTopHeight)];
        _navView.backgroundColor = kColor(37 ,124 ,255);
        UIView *topView = [[UIView alloc] init];
        topView.tag = 1001;
        topView.backgroundColor = kColor(37 ,124 ,255);
        [_navView addSubview:topView];
        topView.frame = CGRectMake(0, 0, CurrentDeviceWidth, StatusBarHeight);
        _navView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _navView.layer.shadowOffset = CGSizeMake(0, 1);
        _navView.layer.shadowOpacity = 0.6;
        _navView.layer.shadowRadius = 4;
        //        self.haveTabBar = YES;
        
        [self addButtonsOnNavView:_navView isBackButton:NO];
    }
    return _navView;
}

- (UIView *)backNavView
{
    if (!_backNavView)
    {
        _backNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CurrentDeviceWidth, SafeAreaTopHeight)];
        _backNavView.backgroundColor = allColorWhite;
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = [UIColor blackColor];
        [_backNavView addSubview:topView];
        topView.frame = CGRectMake(0, 0, CurrentDeviceWidth, StatusBarHeight);
        _backNavView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _backNavView.layer.shadowOffset = CGSizeMake(0, 1);
        _backNavView.layer.shadowOpacity = 0.6;
        _backNavView.layer.shadowRadius = 4;
        //        self.haveTabBar = NO;
        [self addButtonsOnNavView:_backNavView isBackButton:YES];
    }
    return _backNavView;
}

- (UIView *)alphaNavView
{
    if (!_alphaNavView)
    {
        _alphaNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CurrentDeviceWidth, SafeAreaTopHeight)];
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CurrentDeviceWidth, StatusBarHeight)];
        topView.backgroundColor = [UIColor blackColor];
        [_alphaNavView addSubview:topView];
        _alphaNavView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        //        self.haveTabBar = YES;
        [self addButtonsOnNavView:_alphaNavView isBackButton:NO];
    }
    return _alphaNavView;
}

- (UIButton *)datePickBtn
{
    if (!_datePickBtn)
    {
        _datePickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_datePickBtn addTarget:self action:@selector(chooseDate) forControlEvents:UIControlEventTouchUpInside];
//        [_datePickBtn setTitle:NSLocalizedString(@"", nil) forState:UIControlStateNormal];
        [_datePickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _datePickBtn;
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

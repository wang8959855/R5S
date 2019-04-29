//
//  MoreView.m
//  Wukong
//
//  Created by apple on 2019/3/26.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import "MoreView.h"
#import "SOSView.h"
#import "PoliceAlertView.h"
#import "RhythmViewController.h"
#import "RegulationViewController.h"
#import "NowTestViewController.h"

static MoreView *instance = nil;
@interface MoreView ()<CLLocationManagerDelegate>

@property (nonatomic, strong) UIButton *rotateBtn;

//节律
@property (nonatomic, strong) UIButton *jielvBtn;
//sos
@property (nonatomic, strong) UIButton *sosBtn;
//定位
@property (nonatomic, strong) UIButton *locationBtn;
//预警
@property (nonatomic, strong) UIButton *policeBtn;
//调控
@property (nonatomic, strong) UIButton *regulationBtn;
//即时监测
@property (nonatomic, strong) UIButton *testBtn;

//4个按钮的初始位置
@property (nonatomic, assign) CGRect btnInitialFrame;
//4个按钮的结束位置
@property (nonatomic, strong) NSArray *endFrameArr;

//宽度
@property (nonatomic, assign) CGFloat viewWidth;

@property (strong,nonatomic) CLLocationManager* locationManager;


@end

@implementation MoreView

+ (instancetype)moreView{
    @synchronized(self) {
        if( instance == nil ){
            instance =  [[MoreView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            [[UIApplication sharedApplication].keyWindow addSubview:instance];
            
            CGAffineTransform endAngle = CGAffineTransformMakeRotation(M_PI / 4);
            [UIView animateWithDuration:0.3 animations:^{
                instance.rotateBtn.transform = endAngle;
                for (int i = 0; i < 5; i++) {
                    UIView *view = [instance viewWithTag:100+i];
                    view.frame = [instance.endFrameArr[i] CGRectValue];
                }
                [instance getState];
            } completion:^(BOOL finished) {
            }];
        }
    }
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews{
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100.0f;
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = self.bounds;
    [self addSubview:effectview];
    
    self.rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.rotateBtn];
    self.rotateBtn.frame = CGRectMake(ScreenWidth/2-44, ScreenHeight-SafeAreaBottomHeight-26, 88, 88);
    [self.rotateBtn setImage:[UIImage imageNamed:@"yuan"] forState:UIControlStateNormal];
    [self.rotateBtn addTarget:self action:@selector(rotateAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.viewWidth = (ScreenWidth-180)/3;
    //创建4个按钮的初始位置
    self.btnInitialFrame = CGRectMake(ScreenWidth/2-self.viewWidth/2, ScreenHeight-SafeAreaBottomHeight-30, self.viewWidth, 88);
    
    for (int i = 0; i < 5; i++) {
        UIView *view = [[UIView alloc] initWithFrame:self.btnInitialFrame];
        [self addSubview:view];
        view.tag = 100+i;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 68, self.viewWidth, 20)];
        [view addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:13];
        label.tag = 200+i;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, self.viewWidth, 68);
        [view addSubview:button];
        [button addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            
            self.policeBtn = button;
            [button setImage:[UIImage imageNamed:@"yj-blue"] forState:UIControlStateSelected];
            [button setImage:[UIImage imageNamed:@"yujing-h"] forState:UIControlStateNormal];
            label.text = @"预警";
        }else if (i == 1){
            self.locationBtn = button;
            [button setImage:[UIImage imageNamed:@"dw-blue"] forState:UIControlStateSelected];
            label.text = @"定位";
            [button setImage:[UIImage imageNamed:@"dingwei-h"] forState:UIControlStateNormal];
        }else if (i == 2){
            self.sosBtn = button;
            [button setImage:[UIImage imageNamed:@"sos-blue"] forState:UIControlStateNormal];
            label.text = @"sos";
        }else if (i == 3){
            self.jielvBtn = button;
            [button setImage:[UIImage imageNamed:@"jl-blue"] forState:UIControlStateNormal];
            label.text = @"节律";
        }else if (i == 4){
            self.regulationBtn = button;
            [button setImage:[UIImage imageNamed:@"tiaokong"] forState:UIControlStateNormal];
            label.text = @"调控";
        }else if (i == 5){
            self.testBtn = button;
            [button setImage:[UIImage imageNamed:@"jishi"] forState:UIControlStateNormal];
            label.text = @"即时监测";
        }
        
    }
    [self bringSubviewToFront:self.rotateBtn];
    
    //设置6个按钮的结束位置
    CGRect rect1 = CGRectMake(40, ScreenHeight-SafeAreaBottomHeight-250, self.viewWidth, 88);
    CGRect rect2 = CGRectMake(ScreenWidth/2-self.viewWidth/2, ScreenHeight-SafeAreaBottomHeight-250, self.viewWidth, 88);
    CGRect rect3 = CGRectMake(ScreenWidth-40-self.viewWidth, ScreenHeight-SafeAreaBottomHeight-250, self.viewWidth, 88);
    
    CGRect rect4 = CGRectMake(self.viewWidth+20, ScreenHeight-SafeAreaBottomHeight-150, self.viewWidth, 88);
    CGRect rect5 = CGRectMake(ScreenWidth-self.viewWidth*2-20, ScreenHeight-SafeAreaBottomHeight-150, self.viewWidth, 88);
    CGRect rect6 = CGRectMake(ScreenWidth-40-self.viewWidth, ScreenHeight-SafeAreaBottomHeight-150, self.viewWidth, 88);
    self.endFrameArr = @[@(rect1),@(rect2),@(rect3),@(rect4),@(rect5),@(rect6)];
    
}

//按钮点击事件
- (void)menuAction:(UIButton *)button{
    if (button == self.jielvBtn) {//节律
        [self rotateAction:nil];
        RhythmViewController *rhy = [RhythmViewController new];
        rhy.hidesBottomBarWhenPushed = YES;
        [[self findCurrentViewController].navigationController pushViewController:rhy animated:YES];
    }else if (button == self.sosBtn){//sos
        SOSView *sos = [SOSView initSOSView];
        [sos show];
        WeakSelf;
        sos.sosOKBlock = ^{
            if (!weakSelf.locationBtn.selected) {
                [self makeCenterToast:@"请先打开定位"];
                return;
            }
            [weakSelf startLocation];
        };
    }else if (button == self.locationBtn){//定位
        [self rotateAction:nil];
        NSString *title = @"";
        if (button.selected) {
            title = @"关闭轨迹定位将让监护人无法获取您的位置信息，是否关闭";
        }else{
            title = @"轨迹定位将让监护人获取您的位置信息，是否开启";
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"通知" message:title preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //跳转设置
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:settingsURL];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [[self findCurrentViewController] presentViewController:alert animated:YES completion:nil];
    }else if (button == self.policeBtn){//预警
        WeakSelf;
        PoliceAlertView *al = [PoliceAlertView policeAlertView];
        [al show];
        al.switchStateBlock = ^(BOOL state) {
            weakSelf.policeBtn.selected = state;
            UILabel *label = [self viewWithTag:203];
            if (state) {
                label.textColor = kMainColor;
            }else{
                label.textColor = [UIColor grayColor];
            }
        };
    }else if (button == self.regulationBtn){//调控
        [self rotateAction:nil];
        RegulationViewController *regulat = [RegulationViewController new];
        regulat.hidesBottomBarWhenPushed = YES;
        [[self findCurrentViewController].navigationController pushViewController:regulat animated:YES];
    }else if (button == self.testBtn){//检测
        [self rotateAction:nil];
        NowTestViewController *test = [NowTestViewController new];
        test.hidesBottomBarWhenPushed = YES;
        [[self findCurrentViewController].navigationController pushViewController:test animated:YES];
    }
}

//关闭界面
- (void)rotateAction:(UIButton *)button{
    [UIView animateWithDuration:0.3 animations:^{
        button.transform = CGAffineTransformIdentity;
        for (int i = 0; i < 5; i++) {
            UIView *view = [self viewWithTag:100+i];
            view.frame = self.btnInitialFrame;
        }
    } completion:^(BOOL finished) {
        [instance removeFromSuperview];
        instance = nil;
    }];
}
//关闭界面
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.3 animations:^{
        self.rotateBtn.transform = CGAffineTransformIdentity;
        for (int i = 0; i < 5; i++) {
            UIView *view = [self viewWithTag:100+i];
            view.frame = self.btnInitialFrame;
        }
    } completion:^(BOOL finished) {
        [instance removeFromSuperview];
        instance = nil;
    }];
}

//开始定位
- (void)startLocation{
    
    [self makeToastActivity:CSToastPositionCenter];
    
    if ([[[UIDevice currentDevice]systemVersion]doubleValue] >8.0){
        
        [self.locationManager requestWhenInUseAuthorization];
        
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        _locationManager.allowsBackgroundLocationUpdates =YES;
        
    }
    
    [self.locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    
    [manager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *place = placemarks.firstObject;
        NSLog(@"name,%@",place.name);                      // 位置名
        NSLog(@"thoroughfare,%@",place.thoroughfare);      // 街道
        NSLog(@"subThoroughfare,%@",place.subThoroughfare);// 子街道
        NSLog(@"locality,%@",place.locality);              // 市
        NSLog(@"subLocality,%@",place.subLocality);        // 区
        NSLog(@"country,%@",place.country);                // 国家
        if (!place.locality || place.locality.length == 0) {
            //定位失败
            [self hideToastActivity];
            [self makeCenterToast:@"定位失败"];
            return;
        }
        [self requestSOSAddress:[NSString stringWithFormat:@"%@%@%@%@",place.country,place.locality,place.subLocality,place.name] lng:oldCoordinate.longitude lat:oldCoordinate.latitude environment:place.name];
    }];
}

//点击sos
- (void)requestSOSAddress:(NSString *)address lng:(float)lng lat:(float)lat environment:(NSString *)environment{
    NSString *url = [NSString stringWithFormat:@"%@/%@",CLICKSOS,TOKEN];
    NSDictionary *para = @{@"UserID":USERID,@"address":address,@"lng":@(lng),@"lat":@(lat),@"environment":environment};
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:para Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        [self hideToastActivity];
        int code = [responseObject[@"code"] intValue];
        NSString *message = responseObject[@"message"];
        if (code == 0) {
            [self rotateAction:nil];
            [[self findCurrentViewController].view makeCenterToast:@"呼叫成功"];
        }else{
            [self makeCenterToast:message];
        }
    }];
}


//定位信息
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    UILabel *label = [self viewWithTag:201];
    switch (status) {
        case kCLAuthorizationStatusDenied:{//未定位
            self.locationBtn.selected = NO;
//            label.textColor = [UIColor grayColor];
        }break;
        default:{//已定位
//            label.textColor = kMainColor;
            self.locationBtn.selected = YES;
        }break;
    }
}

//查询画预警状态
- (void)getState{
    NSString *url = [NSString stringWithFormat:@"%@/%@",GETSERVER,TOKEN];
    NSDictionary *para = @{@"UserID":USERID};
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:para Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        int code = [responseObject[@"code"] intValue];
        if (code == 0) {
            int isWarn = [responseObject[@"data"][@"isWarn"] intValue];
            self.policeBtn.selected = isWarn;
//            UILabel *label = [self viewWithTag:200];
//            if (isWarn) {
//                label.textColor = kMainColor;
//            }else{
//                label.textColor = [UIColor grayColor];
//            }
        }else{
            
        }
    }];
}

//获取最上层的viewcontroller
- (UIViewController *)findCurrentViewController {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    
    while (true) {
        
        if (topViewController.presentedViewController) {
            
            topViewController = topViewController.presentedViewController;
            
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            
            topViewController = [(UINavigationController *)topViewController topViewController];
            
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
            
        } else {
            break;
        }
    }
    return topViewController;
}



@end

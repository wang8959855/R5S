//
//  LoctionUpdateTool.m
//  Wukong
//
//  Created by apple on 2018/6/19.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "LoctionUpdateTool.h"
#import <BMKLocationKit/BMKLocationManager.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BMKLocationKit/BMKLocationAuth.h>

@interface LoctionUpdateTool ()<BMKLocationManagerDelegate,BMKLocationAuthDelegate>

@property (nonatomic, strong) BMKLocationManager *locationManager;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger uploadNum;

@end

@implementation LoctionUpdateTool

+ (LoctionUpdateTool *)sharedInstance{
    static LoctionUpdateTool * instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        [instance createLocation];
    });
    return instance;
}

- (void)createLocation{
    //初始化实例
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"D9vyaPEBqnK7vNZTCqSSpSP2PxvyN3vF" authDelegate:self];
    _locationManager = [[BMKLocationManager alloc] init];
    //设置delegate
    _locationManager.delegate = self;
    //设置是否允许后台定位
    _locationManager.allowsBackgroundLocationUpdates = YES;
    //设置返回位置的坐标系类型
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    //设置距离过滤参数
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置位置获取超时时间
    _locationManager.locationTimeout = 30;
    //设置获取地址信息超时时间
    _locationManager.reGeocodeTimeout = 30;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(startUploadLocation) userInfo:nil repeats:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startUploadLocation) name:@"uploadLocation" object:nil];
    [self.timer fire];
}

- (void)startUploadLocation{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if ([CLLocationManager locationServicesEnabled] &&
        (status == kCLAuthorizationStatusAuthorizedWhenInUse
         || status == kCLAuthorizationStatusAuthorizedAlways)) {
            //定位功能可用，开始定位
            //单次定位
            WeakSelf
            [self.locationManager requestLocationWithReGeocode:YES withNetworkState:NO completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
                weakSelf.uploadNum = 0;
                if (location.rgcData) {
                    NSString *address = @"";
                    if ([location.rgcData.province isEqualToString:location.rgcData.city]) {
                        address = [NSString stringWithFormat:@"%@%@",location.rgcData.city,location.rgcData.district];
                    }else{
                        address = [NSString stringWithFormat:@"%@%@%@",location.rgcData.province,location.rgcData.city,location.rgcData.district];
                    }
                    [weakSelf requestUploadAddress:address lng:location.location.coordinate.longitude lat:location.location.coordinate.latitude environment:location.rgcData.locationDescribe];
                }else{
                    [weakSelf requestUploadAddress:@"" lng:location.location.coordinate.longitude lat:location.location.coordinate.latitude environment:@""];
                }
            }];
            
        }
}

//定时上传定位
- (void)requestUploadAddress:(NSString *)address lng:(float)lng lat:(float)lat environment:(NSString *)environment{
    NSString *url = [NSString stringWithFormat:@"%@/%@",UPLOADLOCATION,TOKEN];
    NSDictionary *para = @{@"UserID":USERID,@"address":address,@"lng":@(lng),@"lat":@(lat),@"environment":environment,@"apptime":[[TimeCallManager getInstance] getCurrentAreaTime]};
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:para Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        if (error) {
            return;
        }
        int code = [responseObject[@"code"] intValue];
        if (code == 0) {
            //上传成功
            NSLog(@"上传成功");
            PZBaseViewController *topmostVC = (PZBaseViewController *)[self topViewController];
            [topmostVC.view makeCenterToast:kLOCAL(@"腕上健康:地理位置上传成功")];
        }else{
            //上传失败
            if (self.uploadNum < 3) {
                [self performSelector:@selector(afterUploadAddress:) withObject:@{@"address":address,@"lng":@(lng),@"lat":@(lat),@"environment":environment} afterDelay:5];
            }
            self.uploadNum++;
        }
    }];
}

- (void)afterUploadAddress:(NSDictionary *)dic{
    [self requestUploadAddress:dic[@"address"] lng:[dic[@"lng"] floatValue] lat:[dic[@"lat"] floatValue] environment:dic[@"environment"]];
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end

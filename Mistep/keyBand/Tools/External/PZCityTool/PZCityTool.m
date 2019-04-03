//
//  PZCityTool.m
//  Mistep
//
//  Created by 迈诺科技 on 16/7/25.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "PZCityTool.h"
#import "CityNumber.h"
#import <CoreLocation/CoreLocation.h>
#import "ZCChinaLocation.h"
#import "BleTool.h"

static PZCityTool *instance;

@interface PZCityTool()<CLLocationManagerDelegate>

@property(nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation PZCityTool

+ (PZCityTool *)sharedInstance
{
    if (!instance)
    {
        instance = [[PZCityTool alloc] init];
        [instance initData];
    }
    return instance;
}

- (void)initData
{
    if ([CLLocationManager locationServicesEnabled])
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        self.locationManager.distanceFilter = 1000;
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_8_0
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined && [self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [self.locationManager requestAlwaysAuthorization];
        }
#endif
        [self.locationManager startUpdatingLocation];
    }
    
}

#pragma mark - CoreLocationDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    NSString *locationString = [NSString stringWithFormat:@"%.6f,%.6f",currentLocation.coordinate.longitude,currentLocation.coordinate.latitude];
    [manager stopUpdatingLocation];

    [ADASaveDefaluts setObject:locationString forKey:[NSString stringWithFormat:@"%@location",kHCH.UserAcount]];
    BOOL sendWeather = [BleTool sendWeatherFilter];
    if (sendWeather)
    {
        
        BOOL ischina = [[ZCChinaLocation shared] isInsideChina:currentLocation.coordinate];
//        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        if(ischina)
        {
            kHCH.weatherLocation = 2;
            [[AFAppDotNetAPIClient sharedClient] checkWeatherWithCityNameThree:currentLocation];

        }
        else
        {
            kHCH.weatherLocation = 2;
            [[AFAppDotNetAPIClient sharedClient] checkWeatherWithCityNameThree:currentLocation];
            
        }
        
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
}
-(void)refresh
{
    [self.locationManager startUpdatingLocation];
}
@end

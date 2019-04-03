//
//  MapTool.m
//  Mistep
//
//  Created by 迈诺科技 on 2017/2/28.
//  Copyright © 2017年 huichenghe. All rights reserved.
//

#import "MapTool.h"


@implementation MapTool
// 距离测算
+ (double)calculateDistanceWithStart:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end
{
    
    double meter = 0;
    
    double startLongitude = start.longitude;
    double startLatitude = start.latitude;
    double endLongitude = end.longitude;
    double endLatitude = end.latitude;
    
    double radLatitude1 = startLatitude * M_PI / 180.0;
    double radLatitude2 = endLatitude * M_PI / 180.0;
    double a = fabs(radLatitude1 - radLatitude2);
    double b = fabs(startLongitude * M_PI / 180.0 - endLongitude * M_PI / 180.0);
    
    double s = 2 * asin(sqrt(pow(sin(a/2),2) + cos(radLatitude1) * cos(radLatitude2) * pow(sin(b/2),2)));
    s = s * 6378137;
    
    meter = round(s * 10000) / 10000;
    
//    CLLocation *lastLocation = [[CLLocation alloc] initWithLatitude:0 longitude:0];
//    CLLocation *nowLocation = [[CLLocation alloc] initWithLatitude:0 longitude:0];
//    
//    int distanceMeters = [lastLocation distanceFromLocation:nowLocation];
    
    
    return meter;
}

@end

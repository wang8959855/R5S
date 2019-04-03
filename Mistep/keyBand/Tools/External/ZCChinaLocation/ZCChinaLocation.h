


//
//文档：
//http://blog.csdn.net/cuibo1123/article/details/45691631
//
//使用方法：
//
//将ZCChinaLocation.h和ZCChinaLocation.m添加到工程;
//
//判断纬度：44.042156， 经度132.759178是否在中国境内
//BOOL ischina = [[ZCChinaLocation shared] isInsideChina:(CLLocationCoordinate2D){44.042156,132.759178}];
//YES  是在中国


#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@interface ZCChinaLocation : NSObject

//单例
+ (instancetype)shared;

//判断location是否在中国
- (BOOL)isInsideChina:(CLLocationCoordinate2D)location;

@end

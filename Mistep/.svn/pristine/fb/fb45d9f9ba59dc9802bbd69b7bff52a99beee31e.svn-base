//WGS-84：是国际标准，GPS坐标（Google Earth使用、或者GPS模块）
//GCJ-02：中国坐标偏移标准，Google地图、高德、腾讯使用
//BD-09 ：百度坐标偏移标准，Baidu地图使用
//
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface WGS84TOGCJ02 : NSObject
//判断是否已经超出中国范围
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;
//转GCJ-02
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;
@end

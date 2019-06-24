// AFAppDotNetAPIClient.h
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "AFHTTPSessionManager.h"
#import <CoreLocation/CoreLocation.h>

typedef enum {
    NSAFRequest_GET   = 0,
    NSAFRequest_POST,
}NSAFRequestType_Enum;

//@protocol AFAppDotNetAPIClientDelegate <NSObject>
//
//-(void)callbackWeather:(NSDictionary *)weatherDic;
//
//@end

@interface AFAppDotNetAPIClient : NSObject

//@property (nonatomic,weak) id<AFAppDotNetAPIClientDelegate> delegate;

@property (nonatomic, copy) NSString *city;

+ (instancetype)sharedClient;

/*
 *功能:检测网络状态
 */
+ (void)netWorkStatusWithBlock:(void (^)(AFNetworkReachabilityStatus status))block;
//开始监测网络
+ (void)startMonitor;
/*
 *功能:网络请求
 *参数:requestSerializer 请求数据参数组合方式
 *     responseSerializer 返回数据参数组合方式
 *     requestType 请求类型 NSAFRequest_GET 和 NSAFRequest_POST
 *     requestURL 请求的后缀URL
 *     parameterDictionary 请求参数字典
 *     block 回调block
 */
- (NSURLSessionDataTask *)globalRequestWithRequestSerializerType:(AFHTTPRequestSerializer *) requestSerializer
                                           ResponseSerializeType:(AFHTTPResponseSerializer *) responseSerializer
                                                     RequestType:(NSAFRequestType_Enum) requestType
                                                      RequestURL:(NSString *) requestURL
                                            ParametersDictionary:(NSDictionary *) parameterDictionary
                                                           Block:(void (^)(id responseObject, NSError *error,NSURLSessionDataTask*task))block;

/*
 *功能:文件上传
 *参数:urlStr 上传地址URL
 *     filePath 本地文件路径
 *     block 回调block
 */
- (void)globalUploadWithUrl:(NSString *)urlStr fileUrl:(NSString *)filePath
                      Block:(void (^)(id responseObject,NSError *error))block;
- (void)globalDownloadWithUrl:(NSString *)urlStr
                        Block:(void (^)(id responseObject, NSURL *filePath,NSError *error))block;

- (void)globalmultiPartUploadWithUrl:(NSString *)urlStr fileUrl:(NSString *)filePath params:(NSDictionary *)params
                               Block:(void (^)(id responseObject,NSError *error))block;

/*
 
 根据城市名称检查天气
 */

- (void)checkWeatherWithCityName:(NSString *)cityName;
 
//查询国外天气  、。和风
- (void)checkWeatherWithCityNameThree:(CLLocation *)location;
@end

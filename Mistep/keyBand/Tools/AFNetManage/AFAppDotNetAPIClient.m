// AFAppDotNetAPIClient.h
//http://www.heweather.com/documents  和风api的文档
#define WEBWEATHER @"https://api.heweather.com/v5/weather?city="
#define KEYWEATHER @"&key="

/**
 *  是否开启https SSL 验证
 *
 *  @return YES为开启，NO为关闭
 */
#define openHttpsSSL NO
/**
 *  SSL 证书名称，仅支持cer格式。“app.bishe.com.cer”,则填“app.bishe.com”
 */
#define certificate @"certificate-https"

#define certificateBendi @"server-192.168.6.166"

//#define KONEDAYSECONDS 86400

#import "AFAppDotNetAPIClient.h"
#import "PZWeatherModel.h"
#import "WeatherDays.h"
#import "WeatherDay.h"
#import "CityNumber.h"
#import <CoreLocation/CoreLocation.h>
//#import "BleTool.h"


//测试  公司本地电脑
//static NSString * const testAFAppDotNetAPIBaseURLString = @"http://192.168.1.104:8888/bracelet/";
static NSString * const testAFAppDotNetAPIBaseURLString = @"http://bracelet.cositea.com:8089/bracelet/";

//测试 服务器
//static NSString * const testAFAppDotNetAPIBaseURLString = @"http://bracelet.cositea.com:8888/bracelet/";
//测试 本地电脑
//static NSString * const testAFAppDotNetAPIBaseURLString = @"https://192.168.6.166:8443/bracelet/";

//static NSString * const testAFAppDotNetAPIBaseURLString = @"https://bracelet.cositea.com:8443/bracelet/";

//54.202.220.62  国外正式版本
//static NSString * const testAFAppDotNetAPIBaseURLString = @"https://54.202.220.62:8443/bracelet/";
//         国内正式版本
//static NSString * const testAFAppDotNetAPIBaseURLString = @"https://115.28.94.14:8443/bracelet/";

@implementation AFAppDotNetAPIClient

+ (instancetype)sharedClient {
    static AFAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFAppDotNetAPIClient alloc]init];
    });
    
    return _sharedClient;
}

- (void)checkWeatherWithCityName:(NSString *)cityName;
{
    NSString *numberID = [CityNumber querycityNumber:cityName];
    //adaLog(@"numberID  -- - -  -- -  %@",numberID);
    if(!numberID){   return; }
    [self requestCityWeatherWithCityNumber:numberID];
}

- (void)requestCityWeatherWithCityNumber:(NSString *)cityNumber
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    NSString *urlString = [NSString stringWithFormat:@"http://weatherapi.market.xiaomi.com/wtr-v2/weather?cityId=%@",cityNumber];
    
    //adaLog(@"urlString = %@",urlString);
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //接收天气数据
        //adaLog(@"responseObject-%@",responseObject);
        if (responseObject)
        {
#pragma mark  - - 请求的的数据处理
            [self responseData:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //adaLog(@"error = = 天气请求失败 == %@",error);
    }];
}

//查询国外天气  、。和风
#pragma mark   国外的经纬度地址    请求天气

- (void)checkWeatherWithCityNameThree:(CLLocation *)location
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    NSString *urlString;
    CGFloat lon = location.coordinate.longitude;
    CGFloat lat = location.coordinate.latitude;
    if (kHCH.LanguageNum == 0)      //中文
    {
        urlString  = [NSString stringWithFormat:@"%@%f,%f%@&lang=zh-cn",WEBWEATHER,lon,lat,KEYWEATHER];
    }
    else if(kHCH.LanguageNum == 1)  //英文
    {
        urlString  = [NSString stringWithFormat:@"%@%f,%f%@&lang=en",WEBWEATHER,lon,lat,KEYWEATHER];
    }
    else //泰语
    {
        urlString  = [NSString stringWithFormat:@"%@%f,%f%@&lang=th",WEBWEATHER,lon,lat,KEYWEATHER];
    }
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dict = [[SQLdataManger getInstance] queryWeather];//查询数据库中天气
    
    int qian = [[TimeCallManager getInstance]  getSecondsOfCurDay];  //获得当前天的秒数
    NSString *dataStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:qian andFormat:@"yyyy-MM-dd HH:mm:ss"];   //获得当前天的字符串
    
    //条件一  ： 数据库是否有数据
    if (dict.allKeys.count > 0)
    {
        NSLog(@" --- %@",dict[WEATHERTIME]);
        int oldTime = [[TimeCallManager getInstance] getSecondsWithTimeString:dict[WEATHERTIME] andFormat:@"yyyy-MM-dd HH:mm:ss"];
        //条件二  ： 数据库 有数据  是否在今天
        BOOL isToday = [[TimeCallManager getInstance] adayWith:oldTime andEndTime:qian];
        if (isToday)
        {
            [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
             {
                 NSDictionary *countDic =  [(NSArray*)responseObject[@"HeWeather5"] firstObject];
                 NSDictionary *dailyDic = [(NSArray*)countDic[@"daily_forecast"] firstObject];
                 NSAssert(dailyDic.allKeys.count>0,@"天气有空值  就被打断了");
                 if (dailyDic.allKeys.count <= 0)
                 {
                     return;
                 }
                 if (responseObject)
                 {
                     NSString *loca = [NSString stringWithFormat:@"%3.05f,%3.05f",lat,lon];
                     NSData *jsonData=[NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                     //保存数据库
                     NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                           @1,WEATHERID,
                                           dataStr,WEATHERTIME,
                                           loca,WEATHERLOCATION,
                                           jsonData,WEATHERCONTENT,
                                           nil];
                     [[SQLdataManger getInstance] replaceDataWithColumns:dic toTableName:WEATHERTABLE];
                     
                     [self responseDataThree:responseObject];
                 }
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 adaLog(@"失败");
             }];
            
        }
        else
        {
            
            CLLocation *startLoc = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
            NSArray *temp = [dict[WEATHERLOCATION] componentsSeparatedByString:@","];
            NSString *latitudeStr = temp[0];
            NSString *longitudeStr = temp[1];
            CLLocation *endLoc = [[CLLocation alloc] initWithLatitude:[latitudeStr floatValue] longitude:[longitudeStr floatValue]];
            double meters = [startLoc distanceFromLocation:endLoc];//两地之间的距离
            //条件三  ： 数据库 有数据  今天 用户是否还在同一个城市
            if (meters > 110000)
            {
                [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                 {
                     NSDictionary *countDic =  [(NSArray*)responseObject[@"HeWeather5"] firstObject];
                     NSDictionary *dailyDic = [(NSArray*)countDic[@"daily_forecast"] firstObject];
//                     NSAssert(dailyDic.allKeys.count > 0,@"天气有空值  就被打断了");
                     if (dailyDic.allKeys.count <= 0)
                     {
                         return;
                     }
                     if (responseObject)
                     {
                         NSString *loca = [NSString stringWithFormat:@"%3.05f,%3.05f",lat,lon];
                         NSData *jsonData=[NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                         //保存数据库
                         NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                               @1,WEATHERID,
                                               dataStr,WEATHERTIME,
                                               loca,WEATHERLOCATION,
                                               jsonData,WEATHERCONTENT,
                                               nil];
                         [[SQLdataManger getInstance] replaceDataWithColumns:dic toTableName:WEATHERTABLE];
                         //                          insertDataWithColumns:dic toTableName:WEATHERTABLE];
                         [self responseDataThree:responseObject];
                     }
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     //adaLog(@"失败");
                 }];
                
            }
            else
            {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:dict[WEATHERCONTENT]
                                                                    options:NSJSONReadingMutableContainers error:nil];
                //adaLog(@"dic = %@",dic);
                adaLog(@"今天同一个城市 === 同样的天气");
                [self responseDataThree:dic];
                
            }
            
        }
    }
    else
    {
        //        adaLog(@"数据库没有数据");
        [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             NSDictionary *countDic =  [(NSArray*)responseObject[@"HeWeather5"] firstObject];
             NSDictionary *dailyDic = [(NSArray*)countDic[@"daily_forecast"] firstObject];
             if (dailyDic != nil) {
                 NSAssert(dailyDic.allKeys.count > 0,@"天气有空值  就被打断了");                 
             }
             if(dailyDic.allKeys.count <= 0)
             {
                 return;
             }
             if (responseObject)
             {
                 NSString *loc = [NSString stringWithFormat:@"%3.05f,%3.05f",location.coordinate.latitude,location.coordinate.longitude];
                 NSData *jsonData=[NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                 //保存数据库
                 NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @1,WEATHERID,
                                       dataStr,WEATHERTIME,
                                       loc,WEATHERLOCATION,
                                       jsonData,WEATHERCONTENT,
                                       nil];
                 [[SQLdataManger getInstance] insertDataWithColumns:dic toTableName:WEATHERTABLE];
                 [self responseDataThree:responseObject];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             //adaLog(@"失败");
         }];
    }
}

- (NSURLSessionDataTask *)globalRequestWithRequestSerializerType:(AFHTTPRequestSerializer *) requestSerializer
                                           ResponseSerializeType:(AFHTTPResponseSerializer *) responseSerializer
                                                     RequestType:(NSAFRequestType_Enum) requestType
                                                      RequestURL:(NSString *) requestURL
                                            ParametersDictionary:(NSDictionary *) parameterDictionary
                                                           Block:(void (^)(id responseObject, NSError *error,NSURLSessionDataTask*task))block
{
    //    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:
    //                                    [NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
    //    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:
                                     [NSURL URLWithString:testAFAppDotNetAPIBaseURLString]];
    // 3.设置超时时间为10s
    manager.requestSerializer.timeoutInterval = 60;
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    
    if (requestType == NSAFRequest_POST) {
        if (requestSerializer) {
            manager.requestSerializer = requestSerializer;
            
        }
        if (responseSerializer) {
            manager.responseSerializer = responseSerializer;
        }
        return [manager POST:requestURL parameters:parameterDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (block) {
                block(responseObject, nil,task);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (block) {
                block(nil, error,task);
            }
        }];
        
    }else {
        if (requestSerializer) {
            manager.requestSerializer = requestSerializer;
        }
        if (responseSerializer) {
            manager.responseSerializer = responseSerializer;
        }
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 60.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        return [manager GET:requestURL parameters:parameterDictionary progress:nil
                    success:^(NSURLSessionDataTask * __unused task, id responseObject) {
                        if (block) {
                            NSString *string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                            string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                            string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                            [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                            NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
                            NSDictionary *newDic = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONReadingMutableContainers error:nil];
                            block(newDic, nil,task);
                        }
                    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                        if (block) {
                            block(nil, error,task);
                        }
                    }];
    }
}


- (void)globalDownloadWithUrl:(NSString *)urlStr Block:(void (^)(id responseObject, NSURL *filePath,NSError *error))block
{
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    
    NSString *urlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // 指定下载文件保存的路径
        // //adaLog(@"%@ %@", targetPath, response.suggestedFilename);
        // 将下载文件保存在缓存路径中
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
        // URLWithString返回的是网络的URL,如果使用本地URL,需要注意
        // NSURL *fileURL1 = [NSURL URLWithString:path];
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        ////adaLog(@"== %@ |||| %@", fileURL1, fileURL);
        return fileURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (block) {
            block(response,filePath,error);
        }
    }];
    
    [task resume];
}

- (void)globalUploadWithUrl:(NSString *)urlStr fileUrl:(NSString *)filePath
                      Block:(void (^)(id responseObject,NSError *error))block
{
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURL *filePathURL = [NSURL fileURLWithPath:filePath];
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePathURL progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (block) {
            block(responseObject, error);
        }
    }];
    [uploadTask resume];
}

+ (void)netWorkStatusWithBlock:(void (^)(AFNetworkReachabilityStatus status))block
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (block) {
            block(status);
        }
    }];
}
+(void)startMonitor
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                // 未知网络
                //adaLog(@"未知网络");
                //                kHCH.networkStatus = AFNetworkReachabilityStatusUnknown;
                break;
            case AFNetworkReachabilityStatusNotReachable:// 没有网络(断网)
                //adaLog(@"没有网络(断网)");
                //                kHCH.networkStatus = AFNetworkReachabilityStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:// 手机自带网络
                //adaLog(@"手机自带网络");
                //                kHCH.networkStatus = AFNetworkReachabilityStatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                // WIFI
                //adaLog(@"WIFI");
                //                kHCH.networkStatus = AFNetworkReachabilityStatusReachableViaWiFi;
                break;
        }
    }];
    // 3.开始监控
    [manager startMonitoring];
    
}

- (void)globalmultiPartUploadWithUrl:(NSString *)urlStr fileUrl:(NSString *)filePath params:(NSDictionary *)params Block:(void (^)(id responseObject,NSError *error))block
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:testAFAppDotNetAPIBaseURLString]];
    
    // 3.设置超时时间为10s
    manager.requestSerializer.timeoutInterval = 60;
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    
    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (filePath)
        {
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"file" error:nil];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (block) {
            block(responseObject,nil);
        }
        int code = [[responseObject objectForKey:@"code"] intValue];
        if (code == 1001) {
            //token鉴权失败直接退出
            [HCHCommonManager getInstance].isLogin = NO;
            [HCHCommonManager getInstance].userInfoDictionAry = nil;
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kThirdPartLoginKey];
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:LastLoginUser_Info];
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"loginCache"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ViewController *welVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"Main"];
            [AllTool setRootViewController:welVC animationType:kCATransitionPush];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,error);
        }
    }];
}

#pragma mark  - - 请求的的数据处理
//接收天气数据
-(void)responseData:(id)responseObject
{
    if(kHCH.queryWeatherArray.count >0)
    {
        NSDictionary *dict = (NSDictionary *)kHCH.queryWeatherArray[0];
        
        if([dict[QUERYWEATHERID] intValue] == 1)
        {
            NSDictionary *todayDic = responseObject[@"today"];
            if (todayDic)
            {
                
                NSString *date = todayDic[@"date"];
                NSMutableArray *dateArray = [AllTool weatherDateToArray:date];
                int num = [dict[QUERYWEATHERRI] intValue] - [dateArray[0] intValue];
                if (num == 0)
                {
                    [self responseToday:responseObject];//请求某天数据。某天是今天时
                }
                else
                {
                    NSDictionary *forecastDic = responseObject[@"forecast"];
                    
                    NSString *fl_num = forecastDic[[NSString stringWithFormat:@"fl%d",num]];
                    NSString *fx_num = forecastDic[[NSString stringWithFormat:@"fx%d",num]];
                    NSString *weather_num = forecastDic[[NSString stringWithFormat:@"weather%d",num]];
                    NSString *temp_num = forecastDic[[NSString stringWithFormat:@"temp%d",num]];
                    if (temp_num.length <=0) {
                        return;
                    }
                    // NSString *weather_num = forecastDic[[NSString stringWithFormat:@"weather%d",num]];
                    
                    WeatherDay *day = [[WeatherDay alloc]init];
                    day.fl_num = [AllTool findNumFromStr:fl_num];
                    day.fx_num = [AllTool findWeather_fx:fx_num];
                    day.weatherType = [AllTool rangeWeather:weather_num];
                    day.weatherContent = weather_num;
                    NSMutableArray *arr = [AllTool tempToArray:temp_num];
                    day.temp_num_Max = arr[0];
                    day.temp_num_Min = arr[1];
                    [[CositeaBlueTooth sharedInstance] sendOneDayWeatherTwo:day];
                }
            }
        }
        else if ([dict[QUERYWEATHERID] intValue] == 2)
        {
            NSDictionary *todayDic = responseObject[@"today"];
            if (todayDic)
            {
                NSDictionary *forecastDic = responseObject[@"forecast"];
                NSString *date = todayDic[@"date"];
                NSMutableArray *dateArray = [AllTool weatherDateToArray:date];
                
                NSMutableArray *array = [NSMutableArray array];
                for (int i = 0; i<[dict[QUERYWEATHERDAYNUMBER] intValue]; i++)
                {
                    //adaLog(@"i = %d",i);
                    WeatherDays *days = [[WeatherDays alloc]init];
                    if (i==0)
                    {   days.weatherDateArray = dateArray;
                        days.weatherType = [AllTool rangeWeather:todayDic[@"weatherStart"]];
                        days.weatherMax = todayDic[@"tempMax"];
                        days.weatherMin = todayDic[@"tempMin"];
                    }
                    else
                    {
                        NSMutableArray *ArrayTemp = [NSMutableArray arrayWithArray:dateArray];
                        NSString *riTemp=[NSString stringWithFormat:@"%ld",([ArrayTemp[0] integerValue] + i)];
                        [ArrayTemp replaceObjectAtIndex:0 withObject:riTemp];
                        days.weatherDateArray = ArrayTemp;
                        NSString *weather = forecastDic[[NSString stringWithFormat:@"weather%d",i]];
                        days.weatherType = [AllTool rangeWeather:weather];
                        NSString *tempI = forecastDic[[NSString stringWithFormat:@"temp%d",i]];
                        if (tempI.length <=0) {
                            return;
                        }
                        NSMutableArray *arr = [AllTool tempToArray:tempI];
                        days.weatherMax = arr[0];
                        days.weatherMin = arr[1];
                    }
                    [array addObject:days];
                }
                [[CositeaBlueTooth sharedInstance] sendWeatherArray:array day:[dict[QUERYWEATHERRI] intValue] number:[dict[QUERYWEATHERDAYNUMBER] intValue]];
            }
            
        }
        [kHCH.queryWeatherArray removeObjectAtIndex:0];
    }
    else
    {
        NSDictionary *todayDic = responseObject[@"today"];
        if (todayDic)
        {
            NSDictionary *aqiDictionary = responseObject[@"aqi"];
            NSDictionary *realtimeDictionary = responseObject[@"realtime"];
            
            NSString *date = todayDic[@"date"];
            NSString *shi = realtimeDictionary[@"time"];
            NSString *city = aqiDictionary[@"city"];
            NSString *weather = realtimeDictionary[@"weather"];
            
            NSString *tempMax = todayDic[@"tempMax"];
            NSString *tempMin = todayDic[@"tempMin"];
            NSString *currentTemp = realtimeDictionary[@"temp"];
            NSString *index_uv = responseObject[@"forecast"][@"index_uv"];
            
            NSString *fl = realtimeDictionary[@"WS"];
            NSString *fx = realtimeDictionary[@"WD"];
            NSString *aqi = aqiDictionary[@"aqi"];
            NSString *cityid = realtimeDictionary[@"cityid"];
            
            
            PZWeatherModel *weatherModel = [[PZWeatherModel alloc] init];
            weatherModel.weatherDate = date;
            weatherModel.realtimeShi=shi;
            weatherModel.weather_city = city;
            weatherModel.weatherContent = weather;
            
            weatherModel.weatherMax = tempMax;
            weatherModel.weatherMin = tempMin;
            weatherModel.weather_currentTemp = currentTemp;
            weatherModel.weather_uv = index_uv;
            weatherModel.weather_fl = fl;
            
            weatherModel.weather_fx = fx;
            weatherModel.weather_aqi = aqi;
            weatherModel.city_id = cityid;
            //adaLog(@"weatherModel - %@",weatherModel);
            PZWeatherModel * weatherM = [AllTool weatherToWatch:weatherModel];
            [[CositeaBlueTooth sharedInstance] sendWeather:weatherM];
        }
    }
}
//请求某天数据。某天是今天时
-(void)responseToday:(id)responseObject
{
    NSDictionary *todayDic = responseObject[@"today"];
    if (todayDic)
    {
        NSDictionary *aqiDictionary = responseObject[@"aqi"];
        NSDictionary *realtimeDictionary = responseObject[@"realtime"];
        
        NSString *date = todayDic[@"date"];
        NSString *shi = realtimeDictionary[@"time"];
        NSString *city = aqiDictionary[@"city"];
        NSString *weather = realtimeDictionary[@"weather"];
        
        NSString *tempMax = todayDic[@"tempMax"];
        NSString *tempMin = todayDic[@"tempMin"];
        NSString *currentTemp = realtimeDictionary[@"temp"];
        NSString *index_uv = responseObject[@"forecast"][@"index_uv"];
        
        NSString *fl = realtimeDictionary[@"WS"];
        NSString *fx = realtimeDictionary[@"WD"];
        NSString *aqi = aqiDictionary[@"aqi"];
        NSString *cityid = realtimeDictionary[@"cityid"];
        
        
        PZWeatherModel *weatherModel = [[PZWeatherModel alloc] init];
        weatherModel.weatherDate = date;
        weatherModel.realtimeShi=shi;
        weatherModel.weather_city = city;
        weatherModel.weatherContent = weather;
        
        weatherModel.weatherMax = tempMax;
        weatherModel.weatherMin = tempMin;
        weatherModel.weather_currentTemp = currentTemp;
        weatherModel.weather_uv = index_uv;
        weatherModel.weather_fl = fl;
        
        weatherModel.weather_fx = fx;
        weatherModel.weather_aqi = aqi;
        weatherModel.city_id = cityid;
        //adaLog(@"weatherModel - %@",weatherModel);
        PZWeatherModel * weatherM = [AllTool weatherToWatch:weatherModel];
        [[CositeaBlueTooth sharedInstance] sendOneDayWeather:weatherM];
    }
}
#pragma mark  - - 请求的的数据处理 -- 处理国外数据
//处理国外数据
-(void)responseDataThree:(id)response
{
    if(kHCH.queryWeatherArray.count >0)
    {
        
        NSDictionary *dict = (NSDictionary *)kHCH.queryWeatherArray[0];
        
        if([dict[QUERYWEATHERID] intValue] == 1)
        {
            NSDictionary *countDic = [(NSArray*)response[@"HeWeather5"] firstObject];
            NSDictionary *dailyDic = [(NSArray*)countDic[@"daily_forecast"] firstObject];
            if (dailyDic.allKeys.count <= 0)
            {
                return;
            }
            NSString *date = dailyDic[@"date"];
            NSMutableArray *dateArray = [AllTool weatherDateToArray:date];
            int num = [dict[QUERYWEATHERRI] intValue] - [dateArray[0] intValue];
            if (num == 0)
            {
                [self responseTodayThree:response];//请求某天数据。某天是今天时
            }
            else
            {
                if(num<3)
                {
                    NSDictionary *dailyDic = countDic[@"daily_forecast"][num];
                    
                    NSString *fl_num =  dailyDic[@"wind"][@"sc"];
                    NSString *fx_num =  dailyDic[@"wind"][@"dir"];
                    NSString *weather_num =  dailyDic[@"cond"][@"txt_d"];
                    NSString *weatherCode =  dailyDic[@"cond"][@"code_d"];
                    NSString *temp_max =  dailyDic[@"tmp"][@"max"];
                    NSString *temp_min =  dailyDic[@"tmp"][@"min"];
                    
                    WeatherDay *day = [[WeatherDay alloc]init];
                    day.fl_num = [AllTool findNumFromStr:fl_num];
                    day.fx_num = [AllTool findWeather_fx:fx_num];
                    if (kHCH.LanguageNum != 0)//提前把非中文的天气转成中文
                    {
                        weather_num = [AllTool AheadEnglishToChinese:weatherCode];
                    }
                    day.weatherType = [AllTool rangeWeather:weather_num];
                    day.weatherContent = weather_num;
                    day.weatherCode = weatherCode;
                    
                    day.temp_num_Max = temp_max;
                    day.temp_num_Min = temp_min;
                    [[CositeaBlueTooth sharedInstance] sendOneDayWeatherTwo:day];
                    
                }
            }
        }
        else if ([dict[QUERYWEATHERID] intValue] == 2)
        {
            
            NSDictionary *countDic =  [(NSArray*)response[@"HeWeather5"] firstObject];//response[@"HeWeather5"][0];
            NSDictionary *dailyDic = [(NSArray*)countDic[@"daily_forecast"] firstObject];
            if (dailyDic.allKeys.count <= 0)
            {
                return;
            }
            NSString *date = dailyDic[@"date"];
            NSMutableArray *dateArray = [AllTool weatherDateToArray:date];
            
            NSMutableArray *array = [NSMutableArray array];
            NSInteger dayNumber = [dict[QUERYWEATHERDAYNUMBER] intValue];
            if (dayNumber>3)
            {
                dayNumber = 3;
            }
            for (int i = 0; i<dayNumber; i++)
            {
             
                WeatherDays *days = [[WeatherDays alloc]init];
                if (i==0)
                {   days.weatherDateArray = dateArray;
                    NSString *wea = dailyDic[@"cond"][@"txt_d"];
                    NSString *weaCode = dailyDic[@"cond"][@"code_d"];
//                    adaLog(@"wea = %@,weaCode = %@",wea,weaCode);
                    if (kHCH.LanguageNum != 0)//提前把非中文的天气转成中文
                    {
                        wea = [AllTool AheadEnglishToChinese:weaCode];
                    }
                    days.weatherType = [AllTool rangeWeather:wea];
                    days.weatherMax = dailyDic[@"tmp"][@"max"];
                    days.weatherMin = dailyDic[@"tmp"][@"min"];
                }
                else
                {
                    NSMutableArray *ArrayTemp = [NSMutableArray arrayWithArray:dateArray];
                    NSString *riTemp=[NSString stringWithFormat:@"%ld",([ArrayTemp[0] integerValue] + i)];
                    [ArrayTemp replaceObjectAtIndex:0 withObject:riTemp];
                    days.weatherDateArray = ArrayTemp;
                    
                    NSDictionary *dailyDic = countDic[@"daily_forecast"][i];
                    
                    NSString *wea = dailyDic[@"cond"][@"txt_d"];
                    NSString *weaCode = dailyDic[@"cond"][@"code_d"];
                    if (kHCH.LanguageNum != 0)//提前把非中文的天气转成中文
                    {
                        wea = [AllTool AheadEnglishToChinese:weaCode];
                    }
                    days.weatherType = [AllTool rangeWeather:wea];
                    days.weatherMax = dailyDic[@"tmp"][@"max"];
                    days.weatherMin = dailyDic[@"tmp"][@"min"];
                }
                [array addObject:days];
            }
            [[CositeaBlueTooth sharedInstance] sendWeatherArray:array day:[dict[QUERYWEATHERRI] intValue] number:[dict[QUERYWEATHERDAYNUMBER] intValue]];
        }
        [kHCH.queryWeatherArray removeObjectAtIndex:0];
    }
    else
    {
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *now;
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit;
        now=[NSDate date];
        NSDateComponents * comps = [calendar components:unitFlags fromDate:now];
        
        //adaLog(@" comps= ==   %ld",[comps hour]);
        NSDictionary *countDic = [(NSArray *)response[@"HeWeather5"] firstObject];
        
        NSDictionary *dailyDic = [(NSArray *)countDic[@"daily_forecast"] firstObject];
        //nil
        NSString *date;
        NSString *tempMax;
        NSString *tempMin;
        NSString *index_uv;
        if(dailyDic != nil)
        {
            date = dailyDic[@"date"];
            tempMax = dailyDic[@"tmp"][@"max"];
            tempMin = dailyDic[@"tmp"][@"min"];
            index_uv = dailyDic[@"uv"];
        }
        else
        {
            return;
        }
        NSString *shi = [NSString stringWithFormat:@"%ld",[comps hour]];
        NSString *city = countDic[@"basic"][@"city"];
        NSString *weather = dailyDic[@"cond"][@"txt_d"];
        NSString *weatherCode = dailyDic[@"cond"][@"code_d"];
        NSString *currentTemp = dailyDic[@"tmp"][@"max"];
        
        
        NSString *fl = dailyDic[@"wind"][@"sc"];
        if((NSNull *)fl==[NSNull null])
        {
            [fl substringWithRange:NSMakeRange(0, 2)];
        }
        NSString *fx = dailyDic[@"wind"][@"dir"];
        NSString *aqi = @"1000";    //空气质量是1000的默认值，就是没有空气质量
        
        
        
        PZWeatherModel *weatherModel = [[PZWeatherModel alloc] init];
        weatherModel.weatherDate = date;
        weatherModel.realtimeShi=shi;
        weatherModel.weather_city = city;
        weatherModel.weatherContent = weather;
        weatherModel.weatherCode = weatherCode;
        
        weatherModel.weatherMax = tempMax;
        weatherModel.weatherMin = tempMin;
        weatherModel.weather_currentTemp = currentTemp;
        weatherModel.weather_uv = index_uv;
        weatherModel.weather_fl = fl;
        
        weatherModel.weather_fx = fx;
        weatherModel.weather_aqi = aqi;
        //adaLog(@"weatherModel - %@",weatherModel);
        PZWeatherModel * weatherM = [AllTool weatherToWatch:weatherModel];
        
        [[CositeaBlueTooth sharedInstance] sendWeather:weatherM];
        
    }
    
    
}
//请求某天数据。某天是今天时  -- 国外天气
-(void)responseTodayThree:(id)responseObject
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit;
    now=[NSDate date];
    NSDateComponents * comps = [calendar components:unitFlags fromDate:now];
    
    //adaLog(@" comps= ==   %ld",[comps hour]);
    
    NSDictionary *countDic = responseObject[@"HeWeather5"][0];
    
//    NSDictionary *nowDic = countDic[@"now"];
    NSDictionary *dailyDic = countDic[@"daily_forecast"][0];
    
    NSString *date = dailyDic[@"date"];
    NSString *shi = [NSString stringWithFormat:@"%ld",[comps hour]];
    NSString *city = countDic[@"basic"][@"city"];
    NSString *weather = dailyDic[@"cond"][@"txt_d"];
    NSString *weatherCode = dailyDic[@"cond"][@"code_d"];
    NSString *currentTemp = dailyDic[@"tmp"][@"max"];
//    NSString *weather = nowDic[@"cond"][@"txt"];
//    NSString *weatherCode = nowDic[@"cond"][@"code"];
//    NSString *currentTemp = nowDic[@"tmp"];
    
    NSString *tempMax = dailyDic[@"tmp"][@"max"];
    NSString *tempMin = dailyDic[@"tmp"][@"min"];
    
    NSString *index_uv = dailyDic[@"uv"];
    NSString *fl = dailyDic[@"wind"][@"sc"];
    if((NSNull *)fl==[NSNull null])
    {
        [fl substringWithRange:NSMakeRange(0, 2)];
    }
    NSString *fx = dailyDic[@"wind"][@"dir"];
    NSString *aqi = @"1000";    //空气质量是1000的默认值，就是没有空气质量
    
    
    
    PZWeatherModel *weatherModel = [[PZWeatherModel alloc] init];
    weatherModel.weatherDate = date;
    weatherModel.realtimeShi=shi;
    weatherModel.weather_city = city;
    weatherModel.weatherContent = weather;
    weatherModel.weatherCode = weatherCode;
    
    weatherModel.weatherMax = tempMax;
    weatherModel.weatherMin = tempMin;
    weatherModel.weather_currentTemp = currentTemp;
    weatherModel.weather_uv = index_uv;
    weatherModel.weather_fl = fl;
    
    weatherModel.weather_fx = fx;
    weatherModel.weather_aqi = aqi;
    
    //adaLog(@"weatherModel - %@",weatherModel);
    PZWeatherModel * weatherM = [AllTool weatherToWatch:weatherModel];
    [[CositeaBlueTooth sharedInstance] sendOneDayWeather:weatherM];
    
}
#pragma mark   - -- - https 的验证

- (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书  certificate     certificateBendi
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:certificate ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    //AFSSLPinningModeNone: 代表客户端无条件地信任服务器端返回的证书。
    //AFSSLPinningModePublicKey: 代表客户端会将服务器端返回的证书与本地保存的证书中，PublicKey的部分进行校验；如果正确，才继续进行。
    //AFSSLPinningModeCertificate: 代表客户端会将服务器端返回的证书和本地保存的证书中的所有内容，包括PublicKey和证书部分，全部进行校验；如果正确，才继续进行。
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = YES;
    
    securityPolicy.pinnedCertificates = (NSSet *)@[certData];
    
    return securityPolicy;
}

@end

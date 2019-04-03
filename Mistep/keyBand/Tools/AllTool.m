
#define initNumber  @"20"
#define ArraySize(ARR) ( (sizeof(ARR)) / ( sizeof(ARR[0])) )
#define calculateHeart 220


#import "AllTool.h"
#import "PerModel.h"
#import "TimingUploadData.h"

@implementation AllTool
/**
 *   求平均值
 */
+(NSString *)getMean:(NSArray *)array
{
    if(!array)
    {
        return @"0";
    }
    NSString *str  = @"0";
    if (array.count>0)
    {
        ////adaLog(@"- -----ppp");
        if (array.count == 1 )
        {
            if([array[0] isKindOfClass:[NSString class]])
            {
                if([array[0] isEqualToString:initNumber])
                {
                    return @"0";
                }
            }
        }
        ////adaLog(@"- -----222");
        NSInteger heartNum = 0;
        int timer = 0;
        NSInteger temp = 0;
        for (NSString  *str in array) {
            temp = [str integerValue];
            if (temp > 0)
            {
                heartNum += temp;
                ++ timer;
            }
        }
        str  = [NSString stringWithFormat:@"%ld",heartNum / timer];
    }
    return str;
}
/**
 *   求平均值
 */
+(NSString *)getMax:(NSArray *)array
{
    NSString *max = @"0";
    int maxN = 0;
    if (array.count>0)
    {
        ////adaLog(@"- -----ppp");
        if (array.count == 1 )
        {
            if([array[0] isKindOfClass:[NSString class]])
            {
                if([array[0] isEqualToString:initNumber])
                {
                    return @"0";
                }
            }
        }
        
        for (int i = 0 ;  i <array.count; i ++)
        {
            int heart = [array[i] intValue];
            if (heart!=255)
            {
                if (maxN < heart)
                {
                    maxN = heart;
                }
            }
            
        }
        max = [NSString stringWithFormat:@"%d",maxN];
    }
    return max;
}
/**
 *   求最大值
 */
+(NSString *)getSportIDMax:(NSArray *)array
{
    NSString *maxStr = @"0";
    if(array.count>0)
    {
        int maxInt = 0;
        int tempInt = 0;
        for (int i=0; i<array.count; i++)
        {
            tempInt = [array[i] intValue];
            //adaLog(@"tempInt = %d",tempInt);
            if (tempInt > maxInt)
            {
                maxInt  = tempInt;
            }
        }
        ++maxInt;
        maxStr = [NSString stringWithFormat:@"%d",maxInt];
    }
    return maxStr;
}
/**
 *   把心率带数组转化为分钟。用于以后的计算
 */
+(NSMutableArray *)seconedTominute:(NSArray *)array
{
    NSMutableArray *minuteArray = [NSMutableArray array];
    NSInteger temp = 0;
    NSInteger timer = 0;
    
    for (NSInteger i = 0;i < array.count; )
    {
        temp = [array[i] integerValue];
        if (temp > 0)
        {
            [minuteArray addObject:array[i]];
            if (timer > 0) {
                i = i + (60 - timer);
                timer = 0;
            }
            else
            {
                i+=60;
            }
        }
        else
        {
            if (timer >= 60)
            {
                timer = 0;
                [minuteArray addObject:@"0"];
                ++ i;
            }
            else
            {
                ++ i;
                ++timer;
            }
        }
    }
    if (minuteArray.count <= 0) {
        [minuteArray addObject:initNumber];
    }
    return minuteArray;
}

//手表的过滤
+(NSMutableArray *)checkWatch:(NSArray *)deviceArray
{
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for ( PerModel *model in deviceArray)
    {
        if (model.type == 8) {
            [tempArray addObject:model];
        }
    }
    return tempArray;
}

//手环的过滤
+(NSMutableArray *)checkBracelet:(NSArray *)deviceArray
{
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for ( PerModel *model in deviceArray)
    {
        if (model.type != 8) {
            [tempArray addObject:model];
        }
    }
    return tempArray;
}

//核实手环版本是否支持在线运动
+(BOOL)checkVersionWithHard:(int)hardV HardTwo:(int)hardTwo Soft:(int)softV Blue:(int)blueV
{
    BOOL isNotSupport = YES;
    
    int8_t soft = softV;
    int8_t hard = hardV;
    //    int8_t hardTwoUse = hardTwo;
    int8_t blue = blueV;
    NSString *ha = [NSString string];
    //    NSString *haTwo = [NSString string];
    NSString *so = [NSString string];
    NSString *bl = [NSString string];
    NSInteger haInt;
    //    NSInteger haTwoInt;
    NSInteger soInt;
    NSInteger blInt;
    if (hardTwo == 161616) {
        
        ha = [NSString stringWithFormat:@"%02x",hard];
        bl = [NSString stringWithFormat:@"%02x",blue];
        so = [NSString stringWithFormat:@"%02x",soft];
        haInt = [self hexStringTranslateToDoInteger:ha];
        blInt = [self hexStringTranslateToDoInteger:bl];
        soInt = [self hexStringTranslateToDoInteger:so];
        //adaLog( @" - - %ld  %ld  %ld  ",haInt,blInt,soInt);
        
    }
    else
    {
        ha = [NSString stringWithFormat:@"%02x%02x",hardTwo,hard];
        bl = [NSString stringWithFormat:@"%02x",blue];
        so = [NSString stringWithFormat:@"%02x",soft];
        haInt = [self hexStringTranslateToDoInteger:ha];
        blInt = [self hexStringTranslateToDoInteger:bl];
        soInt = [self hexStringTranslateToDoInteger:so];
        //adaLog( @" - - %ld  %ld  %ld  ",haInt,blInt,soInt);
    }
    
    if(haInt == 15 && soInt <= 6)
    {
        isNotSupport = NO;
    }
    if(haInt == 17 && soInt <= 24)//11:00:18  以下不支持 包括=
    {
        isNotSupport = NO;
    }
    if(haInt == 18 && soInt <= 26)//12:00:1a  以下不支持 包括=
    {
        isNotSupport = NO;
    }
    if(haInt == 19 && soInt <= 8)//13:00:08  以下不支持 包括=
    {
        isNotSupport = NO;
    }
    if(haInt == 21 && soInt <= 7) //15:00:08  以下不支持不包括
    {
        isNotSupport = NO;
    }
    if(haInt == 23 && soInt < 1  && blInt != 1) //17:00:00以上可以的
    {
        isNotSupport = NO;
    }
    
    return isNotSupport;
}

// 十六进制字符串转换为十进制数
+(NSInteger)hexStringTranslateToDoInteger:(NSString *)hexString
{
    NSAssert([hexString isKindOfClass:[NSString class]],@"是这个类型 = ");
    NSInteger Do=0;//获取10进制数
    NSInteger length=[hexString length];
    NSInteger array[length];//获取每个字节的10进制数
    
    for(int i=0;i<length;i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; //16进制数中的第i位
        
        if(hex_char1>='0'&&hex_char1<='9')//// 0 的Ascll  48
        {
            array[i]=(hex_char1-48)*pow(16, length-1-i);
        }
        else if(hex_char1>='A'&&hex_char1<='F')//// A 的Ascll  65
        {
            array[i]=(hex_char1-65+10)*pow(16, length-1-i);
        }
        else//// a 的Ascll  97
        {
            array[i]=(hex_char1-97+10)*pow(16, length-1-i);
        }
    }
    for(int k=0;k<length;k++)
    {
        Do+=array[k];
    }
    return Do;
}

//十进制转十六进制
+ (NSString *)ToHex:(long long int)tmpid{
    
    NSString *nLetterValue;
    
    NSString *str =@"";
    
    long long int ttmpig;
    
    for (int i = 0; i<9; i++) {
        
        ttmpig=tmpid%16;
        
        tmpid=tmpid/16;
        
        switch (ttmpig)
        
        {
                
            case 10:
                
                nLetterValue =@"a";break;
                
            case 11:
                
                nLetterValue =@"b";break;
                
            case 12:
                
                nLetterValue =@"c";break;
                
            case 13:
                
                nLetterValue =@"d";break;
                
            case 14:
                
                nLetterValue =@"e";break;
                
            case 15:
                
                nLetterValue =@"f";break;
                
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    if ([str isEqualToString:@"0"]) {
        str = @"ff";
    }
    
    
    return str;
}

//清理绑定设备的缓存
+(void)clearDeviceBangding
{
    //    [ADASaveDefaluts remobeObjectForKey:AllDEVICETYPE];
    [ADASaveDefaluts remobeObjectForKey:kLastDeviceUUID];
    if([CositeaBlueTooth sharedInstance].connectUUID)
    {
        [[CositeaBlueTooth sharedInstance] disConnectedWithUUID:[CositeaBlueTooth sharedInstance].connectUUID];
    }
}

//截取时间字符串的一部分
+ (NSString *)timecutting:(NSString *)timeString
{
    NSString *string = [NSString string];
    if(timeString.length>18)
    {
        string = [timeString substringWithRange:NSMakeRange(11, 5)];
    }
    return string;
}
//十六进制转二进制
+(NSString *)getBinaryByhex:(NSString *)hex
{
    NSMutableDictionary  *hexDic = [[NSMutableDictionary alloc] init];
    hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [hexDic setObject:@"0000" forKey:@"0"];
    [hexDic setObject:@"0001" forKey:@"1"];
    [hexDic setObject:@"0010" forKey:@"2"];
    [hexDic setObject:@"0011" forKey:@"3"];
    [hexDic setObject:@"0100" forKey:@"4"];
    [hexDic setObject:@"0101" forKey:@"5"];
    [hexDic setObject:@"0110" forKey:@"6"];
    [hexDic setObject:@"0111" forKey:@"7"];
    [hexDic setObject:@"1000" forKey:@"8"];
    [hexDic setObject:@"1001" forKey:@"9"];
    [hexDic setObject:@"1010" forKey:@"A"];
    [hexDic setObject:@"1011" forKey:@"B"];
    [hexDic setObject:@"1100" forKey:@"C"];
    [hexDic setObject:@"1101" forKey:@"D"];
    [hexDic setObject:@"1110" forKey:@"E"];
    [hexDic setObject:@"1111" forKey:@"F"];
    NSMutableString *binaryString=[[NSMutableString alloc] init];
    for (int i=0; i<[hex length]; i++) {
        NSRange rage;
        rage.length = 1;
        rage.location = i;
        NSString *key = [hex substringWithRange:rage];
        key = [key uppercaseString];
        
        //        NSLog(@"%@",[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]);
        //        binaryString = [NSString stringWithFormat:@"%@%@",binaryString,[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]];
        [binaryString appendString:[hexDic objectForKey:key]];
    }
    //adaLog(@"转化后的二进制为:%@",binaryString);
    return binaryString;
}
//二进制转十六进制
+(NSString *)getHexByBinary:(NSString *)Binary
{
    NSMutableDictionary  *binaryDic = [[NSMutableDictionary alloc] init];
    binaryDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [binaryDic setObject:@"0" forKey:@"0000"];
    [binaryDic setObject:@"1" forKey:@"0001"];
    [binaryDic setObject:@"2" forKey:@"0010"];
    [binaryDic setObject:@"3" forKey:@"0011"];
    [binaryDic setObject:@"4" forKey:@"0100"];
    [binaryDic setObject:@"5" forKey:@"0101"];
    [binaryDic setObject:@"6" forKey:@"0110"];
    [binaryDic setObject:@"7" forKey:@"0111"];
    [binaryDic setObject:@"8" forKey:@"1000"];
    [binaryDic setObject:@"9" forKey:@"1001"];
    [binaryDic setObject:@"A" forKey:@"1010"];
    [binaryDic setObject:@"B" forKey:@"1011"];
    [binaryDic setObject:@"C" forKey:@"1100"];
    [binaryDic setObject:@"D" forKey:@"1101"];
    [binaryDic setObject:@"E" forKey:@"1110"];
    [binaryDic setObject:@"F" forKey:@"1111"];
    NSMutableString *hexString=[[NSMutableString alloc] init];
    
    for (int i=0; i<[Binary length]; i=i+4) {
        NSRange rage;
        rage.length = 4;
        rage.location = i;
        NSString *key = [Binary substringWithRange:rage];
        //  //adaLog(@"%@",[NSString stringWithFormat:@"%@",[binaryDic objectForKey:key]]);
        //        hexString = [NSString stringWithFormat:@"%@%@",hexString,[NSString stringWithFormat:@"%@",[binaryDic objectForKey:key]]];
        [hexString appendString:[binaryDic objectForKey:key]];
    }
    //adaLog(@"转化后的 16 进制为:%@",hexString);
    return hexString;
}

+(PZWeatherModel*)weatherToWatch:(PZWeatherModel*)weather//把网络请求的数据转为可以发给手表的数据值
{
    
    PZWeatherModel *watchWeather = [[PZWeatherModel alloc]init];
    watchWeather.weatherDate= weather.weatherDate;
    watchWeather.realtimeShi= weather.realtimeShi;
    watchWeather.weather_city= weather.weather_city;
    watchWeather.city_id= weather.city_id;
    if (kHCH.weatherLocation == 1) {
        //adaLog(@"  国内的天气。不需要英文转中文");
        if (weather.weatherContent)
        {
            watchWeather.weatherType = [self rangeWeather:weather.weatherContent];
        }
        else
        {
            watchWeather.weatherType = @"0";
        }
    }
    else
    {
        NSString * weatherContent = [NSString string];
        if (kHCH.LanguageNum != 0)//提前把非中文的天气转成中文
        {
            weatherContent = [AllTool AheadEnglishToChinese:weather.weatherCode];
            watchWeather.weatherType = [self rangeWeather:weatherContent];
        }
        else
        {
            watchWeather.weatherType = [self rangeWeather:weather.weatherContent];
        }
    }
    watchWeather.weatherContent = weather.weatherContent;
    
//    adaLog(@"watchWeather.weatherContent  == %@",watchWeather.weatherContent);
    
    NSMutableArray *TArray = [NSMutableArray array];
    [TArray addObject:weather.weatherMin];
    [TArray addObject:weather.weatherMax];
    if (weather.weather_currentTemp)
    {
        [TArray addObject:weather.weather_currentTemp];
    }else
    {
        [TArray addObject:weather.weatherMax];
    }
    watchWeather.tempArray = TArray;
    //紫外线
    if (weather.weather_uv)
    {
        watchWeather.weather_uv = [self rangeUV:weather.weather_uv];
    }
    else
    {watchWeather.weather_uv=nil;
    }
    watchWeather.weather_fl = [self findNumFromStr:weather.weather_fl];
    watchWeather.weather_fx = [self findWeather_fx:weather.weather_fx];
    watchWeather.weather_aqi= weather.weather_aqi;
    watchWeather.weatherCode = weather.weatherCode;
    watchWeather.weatherMax = weather.weatherMax;
    watchWeather.weatherMin = weather.weatherMin;
    watchWeather.weather_currentTemp = weather.weather_currentTemp;
    return watchWeather;
}
//天气内容判断
+(NSString *)rangeWeather:(NSString *)weather
{
    //     if(kHCH.LanguageNum == 1)  //英文
    //    {
    //        weather = [self englishToChinese:weather];//英文转中文
    //    }
    NSString *str = @"0";
    if (weather)
    {
        NSRange range = [weather rangeOfString:@"转" options:NSCaseInsensitiveSearch];
        if (range.location != NSNotFound)
        {
            //weather = [weather substringWithRange:NSMakeRange(0, range.location)];
            //有   转字。返回严重的天气
            NSString * weather1 = [weather substringWithRange:NSMakeRange(0, range.location)];
            NSString *weather2 = [weather substringWithRange:NSMakeRange(range.location+1,weather.length-(range.location+1))];
            weather1 = [self rangeWeather:weather1];
            weather2 = [self rangeWeather:weather2];
            
            if ([weather1 intValue] > [weather2 intValue])
            {
                return weather1;
            }
            else
            {
                return weather2;
            }
            
        }
        
        if ([weather isEqualToString:@"多云"])
        {  str = @"1";
        }
        else if([weather isEqualToString:@"阴"])
        {  str = @"2";
        }
        else if([weather isEqualToString:@"阵雨"])
        {  str = @"3";
        }
        else if([weather isEqualToString:@"小雨"])
        {  str = @"4";
        }
        else if([weather isEqualToString:@"小到中雨"])
        { str = @"5";
        }
        else if([weather isEqualToString:@"中雨"])
        {  str = @"6";
        }
        else if([weather isEqualToString:@"中到大雨"])
        {  str = @"7";
        }
        else if([weather isEqualToString:@"大雨"])
        { str = @"8";
        }
        else if([weather isEqualToString:@"暴雨"])
        { str = @"9";
        }
        else if([weather isEqualToString:@"大暴雨"])
        {  str = @"10";
        }
        else if([weather isEqualToString:@"特大暴雨"])
        {  str = @"11";
        }
        else if([weather isEqualToString:@"冻雨"])
        {  str = @"12";
        }
        else if([weather isEqualToString:@"雷阵雨"])
        { str = @"13";
        }
        else if([weather isEqualToString:@"雷阵雨伴有冰雹"])
        {  str = @"14";
        }
        else if([weather isEqualToString:@"雷雨"])
        {  str = @"15";
        }
        else if([weather isEqualToString:@"冰雹"])
        {  str = @"16";
        }
        else if([weather isEqualToString:@"雨带雪"])
        {  str = @"17";
        }
        else if([weather isEqualToString:@"阵雪"])
        {  str = @"18";
        }
        else if([weather isEqualToString:@"小雪"])
        {  str = @"19";
        }
        else if([weather isEqualToString:@"小到中雪"])
        {  str = @"20";
        }
        else if([weather isEqualToString:@"中雪"])
        {  str = @"21";
        }
        else if([weather isEqualToString:@"中到大雪"])
        {  str = @"22";
        }
        else if([weather isEqualToString:@"大雪"])
        {  str = @"23";
        }
        else if([weather isEqualToString:@"冻雨"])
        {  str = @"24";
        }
        else if([weather isEqualToString:@"浮尘"])
        {   str = @"25";
        }
        else if([weather isEqualToString:@"沙尘暴"])
        {  str = @"26";
        }
        else if([weather isEqualToString:@"扬沙"])
        {  str = @"27";
        }
        else if([weather isEqualToString:@"霾"])
        {  str = @"28";
        }
        else if([weather isEqualToString:@"雾"])
        {   str = @"29";
        }
        else if([weather isEqualToString:@"霰"])
        {   str = @"30";
        }
        else if([weather isEqualToString:@"飑线"])
        {  str = @"31";
        }
        
        else if ([weather isEqualToString:@"少云"])//兼容和风天气的天气预报
        {  str = @"1";
        }
        else if([weather isEqualToString:@"晴间多云"])
        {  str = @"2";
        }
        else if([weather isEqualToString:@"毛毛雨/细雨"])
        {  str = @"4";
        }
        else if([weather isEqualToString:@"强阵雨"]||[weather isEqualToString:@"雷阵雨"]||[weather isEqualToString:@"强雷阵雨"]||[weather isEqualToString:@"雷阵雨伴有冰雹"]||[weather isEqualToString:@"极端降雨"])
        { str = @"8";
        }
        else if([weather isEqualToString:@"雨雪天气"]||[weather isEqualToString:@"阵雨夹雪"]||[weather isEqualToString:@"雨夹雪"])
        {  str = @"17";
        }
        else if([weather isEqualToString:@"暴雪"])
        {  str = @"23";
        }
        else if([weather isEqualToString:@"薄雾"])
        {   str = @"25";
        }
        
        else if([weather isEqualToString:@"强沙尘暴"])
        {  str = @"26";
        }
        else if([weather isEqualToString:@"扬沙"])
        {  str = @"27";
        }
        else if([weather isEqualToString:@"飑线"])
        {  str = @"31";
        }
    }
    return  str;
}

//英文的天气转化为中文的天气
+(NSString *)englishToChinese:(NSString *)english
{
    NSString *chinese = [NSString string];
    if([english isEqualToString:@"Sunny/Clear"])
    {
        chinese = @"晴";
    }
    else if ([english isEqualToString:@"Cloudy"])
    {chinese = @"多云";
    }
    else if ([english isEqualToString:@"Few Clouds"])
    {chinese = @"少云";
    }
    else if ([english isEqualToString:@"Partly Cloudy"])
    {chinese = @"晴间多云";
    }
    else if ([english isEqualToString:@"Overcast"])
    {chinese = @"阴";
    }
    else if ([english isEqualToString:@"Windy"])
    {chinese = @"有风";
    }
    else if ([english isEqualToString:@"Calm"])
    {chinese = @"平静";
    }
    else if ([english isEqualToString:@"Light Breeze"])
    {chinese = @"微风";
    }
    else if ([english isEqualToString:@"Moderate/Gentle Breeze"])
    {chinese = @"和风";
    }
    else if([english isEqualToString:@"Fresh Breeze"])
    {chinese = @"清风";
    }
    else if([english isEqualToString:@"Strong Breeze"])
    {chinese = @"强风/劲风";
    }
    else if([english isEqualToString:@"High Wind, Near Gale"])
    {chinese = @"疾风";
    }
    else if([english isEqualToString:@"Gale"])
    {chinese = @"大风";
    }
    else if([english isEqualToString:@"Strong Gale"])
    {chinese = @"烈风";
    }
    else if([english isEqualToString:@"Storm"])
    {chinese = @"风暴";
    }
    else if([english isEqualToString:@"Violent Storm"])
    {chinese = @"狂爆风";
    }
    else if([english isEqualToString:@"Hurricane"])
    {chinese = @"飓风";
    }
    else if([english isEqualToString:@"Tornado"])
    {chinese = @"龙卷风";
    }
    else if([english isEqualToString:@"Tropical Storm"])
    {chinese = @"热带风暴";
    }
    else if([english isEqualToString:@"Shower Rain"])
    {chinese = @"阵雨";
    }
    else if([english isEqualToString:@"Heavy Shower Rain"])
    {chinese = @"强阵雨";
    }
    else if([english isEqualToString:@"Thundershower"])
    {chinese = @"雷阵雨";
    }
    else if([english isEqualToString:@"Heavy Thunderstorm"])
    {chinese = @"强雷阵雨";
    }
    else if([english isEqualToString:@"Hail"])
    {chinese = @"雷阵雨伴有冰雹";
    }
    else if([english isEqualToString:@"Light Rain"])
    {chinese = @"小雨";
    }
    else if([english isEqualToString:@"Moderate Rain"])
    {chinese = @"中雨";
    }
    else if([english isEqualToString:@"Heavy Rain"])
    {chinese = @"大雨";
    }
    else if([english isEqualToString:@"Extreme Rain"])
    {chinese = @"极端降雨	";
    }
    else if([english isEqualToString:@"Drizzle Rain"])
    {chinese = @"毛毛雨/细雨";
    }
    else if([english isEqualToString:@"Storm"])
    {chinese = @"暴雨";
    }
    else if([english isEqualToString:@"Heavy Storm"])
    {chinese = @"大暴雨";
    }
    else if([english isEqualToString:@"Severe Storm"])
    {chinese = @"特大暴雨";
    }
    else if([english isEqualToString:@"Freezing Rain"])
    {chinese = @"冻雨";
    }
    else if([english isEqualToString:@"Light Snow"])
    {chinese = @"小雪";
    }
    else if([english isEqualToString:@"Moderate Snow"])
    {chinese = @"中雪";
    }
    else if([english isEqualToString:@"Heavy Snow"])
    {chinese = @"大雪";
    }
    else if([english isEqualToString:@"Snowstorm"])
    {chinese = @"暴雪";
    }
    else if([english isEqualToString:@"Sleet"])
    {chinese = @"雨夹雪";
    }
    else if([english isEqualToString:@"Rain And Snow"])
    {chinese = @"雨雪天气";
    }
    else if([english isEqualToString:@"Shower Snow"])
    {chinese = @"阵雨夹雪";
    }
    else if([english isEqualToString:@"Snow Flurry"])
    {chinese = @"阵雪";
    }
    else if([english isEqualToString:@"Mist"])
    {chinese = @"薄雾";
    }
    else if([english isEqualToString:@"Foggy"])
    {chinese = @"雾";
    }
    else if([english isEqualToString:@"Haze"])
    {chinese = @"霾";
    }
    else if([english isEqualToString:@"Sand"])
    {chinese = @"扬沙";
    }else if([english isEqualToString:@"Dust"])
    {chinese = @"浮尘";
    }
    else if([english isEqualToString:@"Duststorm"])
    {chinese = @"沙尘暴";
    }
    else if([english isEqualToString:@"Sandstorm"])
    {chinese = @"强沙尘暴";
    }
    else if([english isEqualToString:@"Hot"])
    {chinese = @"热";
    }
    else if([english isEqualToString:@"Cold"])
    {chinese = @"冷";
    }
    else //if([english isEqualToString:@"Unknown"])
    {chinese = @"未知";
    }
    //    else if([english isEqualToString:@"Storm"])
    //    {chinese = @"暴雨";
    //    }
    //    else if([english isEqualToString:@"Storm"])
    //    {chinese = @"暴雨";
    //    }
    return chinese;
}

/**
 
 不是中文 ，提前把天气转成中文
 
 **/
+(NSString *)AheadEnglishToChinese:(NSString *)english
{
    NSString *chinese = [NSString string];
    if([english isEqualToString:@"100"])
    {
        chinese = @"晴";
    }
    else if ([english isEqualToString:@"101"])
    {chinese = @"多云";
    }
    else if ([english isEqualToString:@"102"])
    {chinese = @"少云";
    }
    else if ([english isEqualToString:@"103"])
    {chinese = @"晴间多云";
    }
    else if ([english isEqualToString:@"104"])
    {chinese = @"阴";
    }
    else if ([english isEqualToString:@"200"])
    {chinese = @"有风";
    }
    else if ([english isEqualToString:@"201"])
    {chinese = @"平静";
    }
    else if ([english isEqualToString:@"202"])
    {chinese = @"微风";
    }
    else if ([english isEqualToString:@"203"])
    {chinese = @"和风";
    }
    else if([english isEqualToString:@"204"])
    {chinese = @"清风";
    }
    else if([english isEqualToString:@"205"])
    {chinese = @"强风/劲风";
    }
    else if([english isEqualToString:@"206"])
    {chinese = @"疾风";
    }
    else if([english isEqualToString:@"207"])
    {chinese = @"大风";
    }
    else if([english isEqualToString:@"208"])
    {chinese = @"烈风";
    }
    else if([english isEqualToString:@"209"])
    {chinese = @"风暴";
    }
    else if([english isEqualToString:@"210"])
    {chinese = @"狂爆风";
    }
    else if([english isEqualToString:@"211"])
    {chinese = @"飓风";
    }
    else if([english isEqualToString:@"212"])
    {chinese = @"龙卷风";
    }
    else if([english isEqualToString:@"213"])
    {chinese = @"热带风暴";
    }
    else if([english isEqualToString:@"300"])
    {chinese = @"阵雨";
    }
    else if([english isEqualToString:@"301"])
    {chinese = @"强阵雨";
    }
    else if([english isEqualToString:@"302"])
    {chinese = @"雷阵雨";
    }
    else if([english isEqualToString:@"303"])
    {chinese = @"强雷阵雨";
    }
    else if([english isEqualToString:@"304"])
    {chinese = @"雷阵雨伴有冰雹";
    }
    else if([english isEqualToString:@"305"])
    {chinese = @"小雨";
    }
    else if([english isEqualToString:@"306"])
    {chinese = @"中雨";
    }
    else if([english isEqualToString:@"307"])
    {chinese = @"大雨";
    }
    else if([english isEqualToString:@"308"])
    {chinese = @"极端降雨	";
    }
    else if([english isEqualToString:@"309"])
    {chinese = @"毛毛雨/细雨";
    }
    else if([english isEqualToString:@"310"])
    {chinese = @"暴雨";
    }
    else if([english isEqualToString:@"311"])
    {chinese = @"大暴雨";
    }
    else if([english isEqualToString:@"312"])
    {chinese = @"特大暴雨";
    }
    else if([english isEqualToString:@"313"])
    {chinese = @"冻雨";
    }
    else if([english isEqualToString:@"400"])
    {chinese = @"小雪";
    }
    else if([english isEqualToString:@"401"])
    {chinese = @"中雪";
    }
    else if([english isEqualToString:@"402"])
    {chinese = @"大雪";
    }
    else if([english isEqualToString:@"403"])
    {chinese = @"暴雪";
    }
    else if([english isEqualToString:@"404"])
    {chinese = @"雨夹雪";
    }
    else if([english isEqualToString:@"405"])
    {chinese = @"雨雪天气";
    }
    else if([english isEqualToString:@"406"])
    {chinese = @"阵雨夹雪";
    }
    else if([english isEqualToString:@"407"])
    {chinese = @"阵雪";
    }
    else if([english isEqualToString:@"500"])
    {chinese = @"薄雾";
    }
    else if([english isEqualToString:@"501"])
    {chinese = @"雾";
    }
    else if([english isEqualToString:@"502"])
    {chinese = @"霾";
    }
    else if([english isEqualToString:@"503"])
    {chinese = @"扬沙";
    }else if([english isEqualToString:@"504"])
    {chinese = @"浮尘";
    }
    else if([english isEqualToString:@"507"])
    {chinese = @"沙尘暴";
    }
    else if([english isEqualToString:@"508"])
    {chinese = @"强沙尘暴";
    }
    else if([english isEqualToString:@"900"])
    {chinese = @"热";
    }
    else if([english isEqualToString:@"901"])
    {chinese = @"冷";
    }
    else //if([english isEqualToString:@"Unknown"])
    {chinese = @"未知";
    }
    
    return chinese;
}

//紫外线强度判断
+(NSString *)rangeUV:(NSString *)UV
{
    
    BOOL ishave = [self isChinese:UV];
    
    NSString *uv = @"0";
    if (ishave)
    {
        if ([UV isEqualToString:@"中"]||[UV isEqualToString:@"中等"]) {
            uv = @"1";
        }
        else
        {
            uv = @"2";
        }
    }
    else
    {
        NSInteger  grade = [UV integerValue];
        if (grade > 6)
        {
            uv = @"2";
        }
        else if(grade > 3&&grade <= 5)
        {
            uv = @"1";
        }
        else
        {
            uv = @"0";
        }
    }
    return uv;
}
/**
 *
 *取出其中的数字
 **/
+(NSString *)findNumFromStr:(NSString *)weather_fl
{
    
    //NSString *originalString = @"小于3级";
    //    NSMutableString *numberString = [[NSMutableString alloc] init];
    //    if (weather_fl)
    //    {
    //        // Intermediate
    //        NSString *tempStr;
    //        NSScanner *scanner = [NSScanner scannerWithString:weather_fl];
    //        NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    //
    //        while (![scanner isAtEnd]) {
    //            // Throw away characters before the first number.
    //            [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
    //
    //            // Collect numbers.
    //            [scanner scanCharactersFromSet:numbers intoString:&tempStr];
    //            [numberString appendString:tempStr];
    //            tempStr = @"";
    //        }
    //    }
    NSString *numberString = [NSString string];
    if (kHCH.weatherLocation == 1)
    {
        numberString = [NSString stringWithFormat:@"%ld",[weather_fl integerValue]];
    }
    else
    {
        if ([weather_fl isEqualToString:@"平静"])
        {
            numberString = @"0";
        }
        else if ([weather_fl isEqualToString:@"有风"])
        {
            numberString = @"1";
        }
        else if ([weather_fl isEqualToString:@"微风"])
        {
            numberString = @"3";
        }
        else if ([weather_fl isEqualToString:@"和风"])
        {
            numberString = @"4";
        }
        else if ([weather_fl isEqualToString:@"强风"]||[weather_fl isEqualToString:@"劲风"])
        {
            numberString = @"6";
        }
        else if ([weather_fl isEqualToString:@"疾风"])
        {
            numberString = @"7";
        }
        else if ([weather_fl isEqualToString:@"大风"])
        {
            numberString = @"8";
        }
        else if ([weather_fl isEqualToString:@"清风"]||[weather_fl isEqualToString:@"烈风"])
        {
            numberString = @"9";
        }
        else if ([weather_fl isEqualToString:@"风暴"]||[weather_fl isEqualToString:@"狂爆风"])
        {
            numberString = @"10";
        }
        else if ([weather_fl isEqualToString:@"飓风"])
        {
            numberString = @"12";
        }
        else if ([weather_fl isEqualToString:@"龙卷风"])
        {
            numberString = @"13";
        }
        else if ([weather_fl isEqualToString:@"热带风暴"])
        {
            numberString = @"14";
        }
        else
        {
            numberString = @"3";
        }
    }
    return numberString;
    
}

/**
 *      判断其中的 风向
 *
 **/
+(NSString *)findWeather_fx:(NSString *)fx
{
    
//    NSAssert([fx isKindOfClass:[NSString class]],@"是这个类型 = ");
    BOOL noHave = [self isChinese:fx];
    if(!noHave)
    {
        fx = [self englishWind:fx];//把英文的风向的简称改成中文 用于匹配
    }
    if (fx)
    {
        NSInteger fxLength = [fx length];
        if (fxLength>2)
        {
            fx = [fx substringWithRange:NSMakeRange(0, 2)];
        }
        NSRange rang = [fx rangeOfString:@"风" options:NSCaseInsensitiveSearch];
        if (rang.location != NSNotFound)
        {
            fx = [fx substringWithRange:NSMakeRange(0, 1)];
        }
        
    }
    
    
    NSString *weather_fx = @"0";
    if ([fx isEqualToString:@"东"])
    {
        weather_fx = @"1";
    }
    else if ([fx isEqualToString:@"南"])
    {
        weather_fx = @"2";
    }
    else if ([fx isEqualToString:@"西"])
    {
        weather_fx = @"3";
    }
    else if ([fx isEqualToString:@"北"])
    {
        weather_fx = @"4";
    }
    else if ([fx isEqualToString:@"东南"])
    {
        weather_fx = @"5";
    }
    else if ([fx isEqualToString:@"东北"])
    {
        weather_fx = @"6";
    }
    else if ([fx isEqualToString:@"西南"])
    {
        weather_fx = @"7";
    }
    else if ([fx isEqualToString:@"西北"])
    {
        weather_fx = @"8";
    }
    
    return weather_fx;
    
}
//把英文的风向的简称改成中文 用于匹配
+(NSString *)englishWind:(NSString *)english
{
    NSString *wind = [NSString string];
    wind = [english stringByReplacingOccurrencesOfString:@"E" withString:@"东"];
    wind = [english stringByReplacingOccurrencesOfString:@"S" withString:@"南"];
    wind = [english stringByReplacingOccurrencesOfString:@"W" withString:@"西"];
    wind = [english stringByReplacingOccurrencesOfString:@"N" withString:@"北"];
    return wind;
}
/**
 *把日期截取生成  时 日 月 年
 */
+(NSMutableArray*)weatherDateToArray:(NSString *)date
{
    NSMutableArray *arr = [NSMutableArray array];
    if (date)
    {
        NSArray *arrayDay = [date componentsSeparatedByString:@"-"];
        [arr addObject:arrayDay[2]];//日
        [arr addObject:arrayDay[1]];//月
        [arr addObject:arrayDay[0]];//年
    }
    return arr;
}

/**
 *       天气范围   拆分字符串成数组
 *
 **/
+(NSMutableArray*)tempToArray:(NSString *)date
{
    NSMutableArray * arr = [NSMutableArray array];
    if (date) {
        //温度
        NSArray *array = [date componentsSeparatedByString:@"~"]; //从字符~中分隔成2个元素的数组
        NSString *hight = [(NSString *)array[0] stringByReplacingOccurrencesOfString:@"℃" withString:@""];
        NSString *di = [(NSString *)array[1] stringByReplacingOccurrencesOfString:@"℃" withString:@""];
        //adaLog(@"hight =%@,di =%@",hight,di);
        [arr addObject:hight];
        [arr addObject:di];
    }
    
    return arr;
}

//  十进制转二进制
+ (NSString *)toBinarySystemWithDecimalSystem:(NSString *)decimal
{
    int num = [decimal intValue];
    int remainder = 0;      //余数
    int divisor = 0;        //除数
    
    NSString * prepare = @"";
    
    while (true)
    {
        remainder = num%2;
        divisor = num/2;
        num = divisor;
        prepare = [prepare stringByAppendingFormat:@"%d",remainder];
        
        if (divisor == 0)
        {
            break;
        }
    }
    
    NSString * result = @"";
    for (int i = (int)prepare.length - 1; i >= 0; i --)
    {
        result = [result stringByAppendingFormat:@"%@",
                  [prepare substringWithRange:NSMakeRange(i , 1)]];
    }
    
    return result;
}

//  二进制转十进制
+ (NSString *)toDecimalSystemWithBinarySystem:(NSString *)binary
{
    int ll = 0 ;
    int  temp = 0 ;
    for (int i = 0; i < binary.length; i ++)
    {
        temp = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        temp = temp * powf(2, binary.length - i - 1);
        ll += temp;
    }
    
    NSString * result = [NSString stringWithFormat:@"%d",ll];
    
    return result;
}
/**
 *      十六进制字符串转化为数组
 *
 **/
+ (NSMutableArray *)hexToArray:(NSString *)hex
{
    NSMutableArray * Arr = [NSMutableArray array];
    NSMutableString *hexString = [NSMutableString stringWithString:hex];
    
    hexString = [self eightEight:hexString];
    
    NSInteger a=0,b=0,c=0,d=0;
    a = [self hexStringTranslateToDoInteger:[hexString substringWithRange:NSMakeRange(0, 2)]];
    b = [self hexStringTranslateToDoInteger:[hexString substringWithRange:NSMakeRange(2, 2)]];
    c = [self hexStringTranslateToDoInteger:[hexString substringWithRange:NSMakeRange(4, 2)]];
    d = [self hexStringTranslateToDoInteger:[hexString substringWithRange:NSMakeRange(6, 2)]];
    if(b!=0)
    {
        [Arr addObjectsFromArray:@[[NSString stringWithFormat:@"%ld",b],[NSString stringWithFormat:@"%ld",c],[NSString stringWithFormat:@"%ld",d],[NSString stringWithFormat:@"%ld",a]]];
    }
    else if(c!=0)
    {
        [Arr addObjectsFromArray:@[[NSString stringWithFormat:@"%ld",c],[NSString stringWithFormat:@"%ld",d],[NSString stringWithFormat:@"%ld",a],[NSString stringWithFormat:@"%ld",b]]];
        
    }
    else if(d!=0)
    {
        [Arr addObjectsFromArray:@[[NSString stringWithFormat:@"%ld",d],[NSString stringWithFormat:@"%ld",a],[NSString stringWithFormat:@"%ld",b],[NSString stringWithFormat:@"%ld",c]]];
        
    }
    else
    {[Arr addObjectsFromArray:@[[NSString stringWithFormat:@"%ld",a],[NSString stringWithFormat:@"%ld",b],[NSString stringWithFormat:@"%ld",c],[NSString stringWithFormat:@"%ld",d]]];
        
    }
    return Arr;
}
+(NSMutableString *)eightEight:(NSMutableString *)hexString
{
    
    if (hexString.length == 0)
    {  [hexString appendString:@"00000000"];
    }
    else if (hexString.length == 1)
    {  [hexString insertString:@"0000000" atIndex:0];
    }
    else if (hexString.length == 2)
    {  [hexString insertString:@"000000" atIndex:0];
    }
    else if (hexString.length == 3)
    {   [hexString insertString:@"00000" atIndex:0];
    }
    else if (hexString.length == 4)
    {  [hexString insertString:@"0000" atIndex:0];
    }
    else if (hexString.length == 5)
    {   [hexString insertString:@"000" atIndex:0];
    }
    else if (hexString.length == 6)
    {  [hexString insertString:@"00" atIndex:0];
    }
    else if (hexString.length == 7)
    {  [hexString insertString:@"0" atIndex:0];
    }
    return hexString;
}
/**
 *      十进制字符串转化为数组  。用于发给蓝牙
 *
 **/
+ (NSMutableArray *)numberToArray:(int)number
{
    //    NSString *hexString = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",number]];
    
    //    Arr = [self hexToArray:hexString];
    NSMutableArray * Arr = [NSMutableArray array];
    
    for(int i = 0;i<4;i++)
    {
        //  int  byte = (Byte)(number>>(24-i*8));
        int  byte = (Byte)(number>>i*8)&0xff;
        //   NSLog(@"byte - %d",byte);
        [Arr addObject:[NSString stringWithFormat:@"%d",byte]];
    }
    return Arr;
}
/**
 *  开始上传数据
 */
+ (void)startUpData
{
    if([[ADASaveDefaluts objectForKey:LOGINTYPE] intValue]!=3)
    {
        [TimingUploadData sharedInstance];
    }
}


+(void)clearDeviceType
{
    [ADASaveDefaluts remobeObjectForKey:AllDEVICETYPE];
    [ADASaveDefaluts remobeObjectForKey:kLastDeviceUUID];
    if([CositeaBlueTooth sharedInstance].connectUUID)
    {
        [[CositeaBlueTooth sharedInstance] disConnectedWithUUID:[CositeaBlueTooth sharedInstance].connectUUID];
    }
}

/**
 *
 arrayToString    11，22，33，44,
 */
+(NSString *)arrayToString2:(NSArray*)array
{
    if(array.count == 0)
    {
        return @"";
    }
    NSMutableString *string = [NSMutableString string];
    for(int i=0;i<array.count;i++)
    {
        [string appendFormat:@"%@",array[i]];
    }
    
    return string;
}

+(NSString *)arrayToStringHeart:(NSArray*)array
{
    if(array.count == 0)
    {
        return @"";
    }
    NSMutableString *string = [NSMutableString string];
    for(int i=0;i<array.count;i++)
    {
        [string appendFormat:@"%@",[self ToHex:[array[i] integerValue]]];
    }
    
    return string;
}

+(NSString *)arrayToStringSport:(NSArray*)array
{
    if(array.count == 0)
    {
        return @"";
    }
    NSMutableString *string = [NSMutableString string];
    for(int i=0;i<array.count;i++)
    {
        if(array.count-1 == i)
        {
            
            [string appendFormat:@"%@",array[i]];
        }
        else
        {
            [string appendFormat:@"%@;",array[i]];
            
        }
        // //adaLog(@"i=%d",i);
    }
    
    return string;
}

/**
 *
 arrayToString    11，22，33，44
 */
+(NSString *)arrayToString:(NSArray*)array
{
    if(array.count == 0)
    {
        return @"";
    }
    NSMutableString *string = [NSMutableString string];
    for(int i=0;i<array.count;i++)
    {
        if(array.count-1 == i)
        {
            
            [string appendFormat:@"%@",array[i]];
        }
        else
        {
            [string appendFormat:@"%@,",array[i]];
            
        }
        // //adaLog(@"i=%d",i);
    }
    
    return string;
}

/** *
 macToString    mac地址转化为字符串
 */
+(NSString *)macToMacString:(NSString *)string
{
    if (!string)
    {
        //从名字中截取mac地址。
        NSString *deviceName = [ADASaveDefaluts objectForKey:kLastDeviceNAME];
        NSArray *array = [self getRangeStr:deviceName findText:@"_"];
        if (array.count == 1)
        {
            int loc = [array.firstObject intValue];
            deviceName = [deviceName substringWithRange:NSMakeRange(loc+1,deviceName.length-loc-1)];
            string =  [self deviceNameToGetMacAddress:deviceName];
        }
        else
        {
            string = DEFAULTDEVICEID;
        }
    }
    else
    {
        if(string.length > 12)
        {
            NSRange range = [string rangeOfString:@"B7" options:NSCaseInsensitiveSearch];
//            NSAssert(range.length>0,@"mac 出现奇怪的问题了。%@",string);
//            if (range.length>0)
//            {
//                //一般情况。就是走这个位置
//                string = [string substringWithRange:NSMakeRange(range.location+range.length,12)];
//            }
//            else
//            {
                string = [string substringWithRange:NSMakeRange(string.length-12,12)];
//            }
        }
        else
        {
            string = DEFAULTDEVICEID;
        }
    }
    string = [string uppercaseString];//全部变大写
    return  string;
}
/**
 *
 macToString    data  mac地址转化为字符串
 */
+(NSString *)macDataToString:(NSData *)macAddressData
{
    if (!macAddressData) {
        return nil;
    }
    Byte* byte = (Byte*)[macAddressData bytes];
    NSString* string = @"";
    if (macAddressData != nil) {
        for (int i = 0; i < macAddressData.length; i++) {
            NSString* string1 = [NSString stringWithFormat:@"%X",byte[i]];
            if (string1.length == 1) {
                string = [string stringByAppendingFormat:@"0%@",string1];
            } else {
                string = [string stringByAppendingString:string1];
            }
        }
    }
    //    //adaLog(@"macAddress - %@",string);
    BOOL correct = [self checkMacAddressCorrect:string];
    if (!correct) {
        string = nil;
    }
    if(string)
    {
        string = [string uppercaseString];
    }
    return  string;
}


/**
 *
 获取这个字符串中的所有xxx的所在的index
 */
+ (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText
{
    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:20];
    if (findText == nil && [findText isEqualToString:@""]) {
        return nil;
    }
    NSRange rang = [text rangeOfString:findText options:NSCaseInsensitiveSearch]; //获取第一次出现的range
    if (rang.location != NSNotFound && rang.length != 0) {
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];//将第一次的加入到数组中
        NSRange rang1 = {0,0};
        NSInteger location = 0;
        NSInteger length = 0;
        for (int i = 0;; i++)
        {
            if (0 == i) {//去掉这个xxx
                location = rang.location + rang.length;
                length = text.length - rang.location - rang.length;
                rang1 = NSMakeRange(location, length);
            }else
            {
                location = rang1.location + rang1.length;
                length = text.length - rang1.location - rang1.length;
                rang1 = NSMakeRange(location, length);
            }
            //在一个range范围内查找另一个字符串的range
            rang1 = [text rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0) {
                break;
            }else//添加符合条件的location进数组
            {
                [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
            }
        }
        return arrayRanges;
    }
    return nil;
}
/**
 *
 macToString    data  mac地址转化为字符串
 */
+(BOOL)savePeripheral:(PerModel *)model
{
    if(!model.macAddress)
    {
        return NO;
    }
    NSArray *peripheralArray = [[SQLdataManger getInstance] queryALLDataWithTable:Peripheral_Table];
    BOOL isHave = NO;
    for (NSDictionary *dict in peripheralArray)
    {
        if ([dict[macAddress_per] isEqualToString:model.macAddress]) {
            isHave = YES;
        }
    }
    if (isHave) {
        return NO;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *rssiStr = [NSString string];
    NSString *deviceNameTemp = [NSString string];
    NSString *deviceIdTemp = [NSString string];
    if (abs(model.RSSI)>0) {
        rssiStr = [NSString stringWithFormat:@"%d",model.RSSI];
    } else {
        rssiStr = @"0";
    }
    if (model.deviceName) {
        deviceNameTemp = model.deviceName;
    } else {
        deviceNameTemp = @"0";
    }
    deviceIdTemp = [NSString stringWithFormat:@"%ld",[[SQLdataManger getInstance] queryPeripheralALL]];
    [dict setObject:deviceIdTemp forKey:deviceId_per];
    [dict setObject:model.macAddress forKey:macAddress_per];
    [dict setObject:model.UUIDString forKey:UUIDString_per];
    [dict setObject:rssiStr forKey:RSSI_per];
    [dict setObject:deviceNameTemp forKey:deviceName_per];
    BOOL insert = [[SQLdataManger getInstance] insertSignalDataToTable:Peripheral_Table withData:dict];
    return insert;
}

/**
 *
 检查到设置中的外设。没有收到广播。就从数据库中取得macAddress  保存本地
 */
+(BOOL)setMacaddress:(NSString *)uuid
{
    // if (!uuid) {
    //    return NO;
    //}
    NSDictionary *dictionary = [[SQLdataManger getInstance] getPeripheralWith:uuid];
    if(!dictionary)
    {
        return NO;
    }
    [ADASaveDefaluts setObject:dictionary[macAddress_per] forKey:kLastDeviceMACADDRESS];
    return YES;
}
/**
 *
 字典转json格式字符串：
 **/

+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

/*!
 
 * @brief 把格式化的JSON格式的字符串转换成字典
 
 * @param jsonString JSON格式的字符串
 
 * @return 返回字典
 
 */

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    if(err) {
        //adaLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/*!
 * @brief 制造180分钟的0值。
 
 * @return NSMutableArray
 */
+(NSMutableArray *)makeArrayEight
{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<180; i++)
    {
        [arr addObject:@"ff"];
    }
    return arr;
}
/*!
 * @brief 制造144分钟的0值。
 0-清醒 1-浅睡 2-深睡
 * @return NSMutableArray
 */
+(NSMutableArray *)makeSleepArray
{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<144; i++)
    {
        [arr addObject:@"3"];
    }
    return arr;
}
// 判断字符串中是否有中文
+ (BOOL)isChinese:(NSString *)str{
    for (int i  = 0; i < str.length; i++) {
        int a = [str characterAtIndex:i];
        if (a >= 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}
/*
 校验mac地址的正确性   -- 长度
 * @param mac地址
 
 * @return BOOL
 */
+(BOOL)checkMacAddressLength:(NSString *)macString
{
    BOOL correct = YES;
    if (macString.length == 6)
    {
        correct = NO;
    }
    return correct;
}

/*
 校验mac地址的正确性
 * @param mac地址
 
 * @return BOOL
 */
+(BOOL)checkMacAddressCorrect:(NSString *)macString
{
    BOOL correct = YES;
    NSRange b7Range = [macString  rangeOfString:@"B7" options:NSCaseInsensitiveSearch];
    NSRange b6Range = [macString  rangeOfString:@"B6" options:NSCaseInsensitiveSearch];
    if (b7Range.location == NSNotFound)
    {
        correct = NO;
    }
    if (b6Range.location == NSNotFound) // b6Range.length   <2
    {
        correct = NO;
    }
    if((macString.length - b7Range.location) < 14)
    {
        correct = NO;
    }
    if ((macString.length - b6Range.location) < 6)
    {
        correct = NO;
    }
    return correct;
}
/*
 核实MacAddress是否需要修正
 * @param mac地址
 
 * @return BOOL
 */
+(BOOL)isNeedAmendMacAddress:(NSString *)macString
{
    BOOL isNeed = NO;
    if(!macString)
    {
        isNeed = YES;
    }
    if([macString isEqualToString:DEFAULTDEVICEID])
    {
        isNeed = YES;
    }
    return isNeed;
}

/*
 保存macAddress之前的获取
 
 * @return macAddress
 */
+(NSString *)amendMacAddressGetAddress
{
    
    NSString *deviceId = [NSString string];
    
    NSString *macStr = [ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
    if (!macStr)
    {
        //从名字中截取mac地址。
        NSString *deviceName = [ADASaveDefaluts objectForKey:kLastDeviceNAME];
        NSArray *array = [self getRangeStr:deviceName findText:@"_"];
        if (array.count == 1)
        {
            deviceName = [deviceName substringWithRange:NSMakeRange([array[0] intValue]+1,deviceName.length-[array[0] intValue]-1)];
            deviceId =  [self deviceNameToGetMacAddress:deviceName];
            //            if(deviceName.length == 10)
            //            {
            //                deviceName = [NSString stringWithFormat:@"00%@",deviceName];
            //            }
            //            else if (deviceName.length == 8)
            //            {
            //                deviceName = [NSString stringWithFormat:@"0000%@",deviceName];
            //            }
            //            deviceId =  deviceName;
        }
        else
        {
            deviceId = DEFAULTDEVICEID;
        }
    }
    else
    {
        deviceId = macStr;
    }
    
    return deviceId;
}
+(NSString *)deviceNameToGetMacAddress:(NSString *)fifthMac
{
    NSString *macAddress = [NSString string];
    //从名字中截取mac地址。
    NSString *deviceName = [ADASaveDefaluts objectForKey:kLastDeviceNAME];
    NSRange r2range = [deviceName rangeOfString:@"R2" options:NSCaseInsensitiveSearch];
    NSRange k18srange = [deviceName rangeOfString:@"K18s" options:NSCaseInsensitiveSearch];
    NSRange k64srange = [deviceName rangeOfString:@"K64s" options:NSCaseInsensitiveSearch];
    NSRange b7srange = [deviceName rangeOfString:@"B7" options:NSCaseInsensitiveSearch];
    if (r2range.location!=NSNotFound|| k18srange.location!=NSNotFound|| k64srange.location != NSNotFound)
    {//r2,k18s,k64s
        macAddress = [self r2strAppendstr:fifthMac];
    }
    else if(b7srange.location!=NSNotFound)
    {//b7
        macAddress = [self b7strAppendstr:fifthMac];
    }
    else //if(r2range.location != NSNotFound)
    {//r1 多种情况
        macAddress = [self r1strAppendstr:fifthMac];
        
    }
    return macAddress;
}
//r2 k18s k64s 拼接的字符串
+(NSString *)r2strAppendstr:(NSString *)strR2
{
    return [NSString stringWithFormat:@"00%@",strR2];
}
//r2 k18s k64s 拼接的字符串
+(NSString *)b7strAppendstr:(NSString *)strB7
{
    return [NSString stringWithFormat:@"ed%@",strB7];
}
//r1 拼接的字符串
+(NSString *)r1strAppendstr:(NSString *)strR1
{
    return [NSString stringWithFormat:@"e0%@",strR1];
}

//　              0-50　Ⅰ　优　可正常活动
//            　　51-100　Ⅱ　良　可正常活动
//            　　101-150　Ⅲ1　轻微污染　长期接触，易感人群出现症状
//            　　151-200　Ⅲ2　轻度污染　长期接触，健康人群出现症状
//            　　201-250　Ⅳ1　中度污染　一定时间接触后，健康人群出现症状
//            　　251-300　Ⅳ2　中度重污染　一定时间接触后，心脏病和肺病患者症状显著加剧
//            　　>300　Ⅴ　重度污染　健康人群明显强烈症状，提前出现某些疾病
/*
 pm25   用于计算空气质量
 
 * @return pm25
 */
+(NSString *)pm25ToString:(NSInteger)number
{
    NSString *quality = [NSString string];
    if (number<=50)
    {
        quality = @"优";
    }
    else if (number>50 && number<=100)
    {
        quality = @"良";
    }
    else
    {
        quality = @"差";
    }
    //    else if (number>100 && number<=150)
    //    {
    //        quality = @"轻微污染";
    //    }
    //    else if (number>150 && number<=200)
    //    {
    //        quality = @"轻度污染";
    //    }
    //    else if (number>200 && number<=250)
    //    {
    //        quality = @"中度污染";
    //    }
    //    else if (number>250 && number<=300)
    //    {
    //        quality = @"中度重污染";
    //    }
    //    else
    //    {
    //        quality = @"重度污染";
    //    }
    return quality;
}
//经纬度分出
+(NSArray *)getLatLonDegree:(NSString *)LLString
{
    NSString *locationStr = LLString;
    NSArray *temp = [locationStr componentsSeparatedByString:@","];
    //    NSString *latitudeStr = temp[0];
    //    NSString *longitudeStr = temp[1];
    return temp;
}
/*
 获取运动目标时间
 
 * @return target
 */
+(NSString *)getSportTargetTime:(NSString *)targetTime
{
    NSString * target = [NSString string];
    //    NSString *str = [ADASaveDefaluts objectForKey:MAPSPORTTARGET];
    //adaLog(@"targetTime - %@",targetTime);
    if (!targetTime)
    {
        return @"00:30:00";
    }
    NSRange range1 = [targetTime rangeOfString:@"H" options:NSCaseInsensitiveSearch];
    NSString *str1 = [targetTime substringToIndex:range1.location];
    NSRange range2 = [targetTime rangeOfString:@"min" options:NSCaseInsensitiveSearch];
    NSString *str2 = [targetTime substringWithRange:NSMakeRange(range2.location-2, 2)];
    target = [NSString stringWithFormat:@"%@:%@:00",str1,str2];
    
    //adaLog(@"target - %@",target);
    
    return target;
    //  [ADASaveDefaluts setObject:[NSString stringWithFormat:@"%@H%@min",self.pickerViewHour,self.pickerViewMinute] forKey:MAPSPORTTARGET];//保存地图运动目标
}
/**
 
 *  是直接使用
 
 */
+(BOOL)isDirectUse
{
    BOOL isDown = NO;
    if([[ADASaveDefaluts objectForKey:LOGINTYPE] intValue] ==3)
    {
        isDown = YES;
    }
    else
    {
        isDown = NO;
    }
    return isDown;
}

/**
 
 *  计算配速
 
 */
+(NSString*)pacewithTime:(double)time andRice:(double)rice
{
    NSString *str = [NSString string];
    if(rice<=0)
    {
        str = @"0'0\"";
    }
    else
    {
        time = time/60;//转为分钟
        rice = rice/1000;//转为公里
        NSString * fen = [NSString stringWithFormat:@"%.2f",time/rice];
        NSArray *array = [fen componentsSeparatedByString:@"."];
        NSInteger miaos =  ([array[1] intValue]*0.6);
        //adaLog(@"miaos-%ld",miaos);
        str = [NSString stringWithFormat:@"%@'%ld\"",array[0],miaos];
        //adaLog(@"str-%@",str);
        //adaLog(@"str-%@",str);
    }
    
    return str;
}
/**
 
 *  过滤 255 和 0
 
 */
+(NSMutableArray*)checkArray:(NSArray *)array
{
    NSMutableArray *arr =[NSMutableArray array];
    
    for (NSString *str in array)
    {
        int temp = [str intValue];
        if (!(temp==0||temp==255))
        {
            [arr addObject:[NSString stringWithFormat:@"%d",temp]];
        }
    }
    
    return arr;
}
#pragma mark - 更换主页面
+ (void)setRootViewController:(UIViewController *)viewController animationType:(NSString *)animationType
{
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    CATransition *animation = [CATransition  animation ];
    animation.subtype = kCATransitionFromRight;
    animation.duration = 0.25;
    animation.type = kCATransitionPush;
    [window.layer addAnimation:animation forKey:nil];
    window.rootViewController = viewController;
}

//显示提示框
+ (void)addActityIndicatorInView :(UIView *)view labelText : (NSString *)labelString detailLabel : (NSString *)detailString
{
    
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
//移除view
+ (void)removeActityIndicatorFromView : (UIView *)view{
    for( UIView *viewInView in [view subviews]){
        if( [viewInView isKindOfClass:[MBProgressHUD class] ]){
            [viewInView removeFromSuperview];
            break;
        }
    }
}
#pragma mark - 弹出HUD
+ (void)addActityTextInView : (UIView *)view text : (NSString *)textString deleyTime : (float)times {
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

/**
 *      通过过滤，把有效的睡眠中的清醒转成浅睡。开始睡眠后 30分钟，就算开始。超过30分钟的清醒才是清醒，否则清醒转浅睡
 *
 **/
+ (NSMutableArray *)filterSleepToValid:(NSArray *)sleepArr
{
    if(sleepArr.count<=0)
    { return (NSMutableArray *)sleepArr;}
    int filter = 0;//根据这个值判断是否开始过滤
    int filtAwakeep = 0;//根据这个值判断是否转化清醒
    
    NSMutableArray * resultArr = [NSMutableArray arrayWithArray:sleepArr];
    
    int lightSleep = 0;
    int awakeSleep = 0;
    int deepSleep = 0;
    BOOL isBegin = NO;
    int nightBeginTime = 0;
    int nightEndTime = 0;
    int sixFiler = 0;//总过滤器。要求六点前过滤
    for (int i = 0 ; i < sleepArr.count; i ++)
    {
        int sleepState = [sleepArr[i] intValue];
        if (sleepState != 0 && sleepState != 3)
        {
            if (isBegin == NO)
            {
                isBegin = YES;
                nightBeginTime = i;
            }
            nightEndTime = i;
        }
    }
    if (nightEndTime > nightBeginTime)
    {
        for (int i = nightBeginTime ; i <= nightEndTime; i ++)
        {
            int state = [sleepArr[i] intValue];
            if (state == 2 )    {
                if(filtAwakeep>0&&filtAwakeep<4&&filter>3&&sixFiler<49)
                {
                    awakeSleep -= filtAwakeep;
                    lightSleep += filtAwakeep;
                    for (int te = 1; te <= filtAwakeep; te++) {
                        int atIndex = i -te;
//                        [resultArr replaceObjectAtIndex:atIndex withObject:@1];//把清醒换成浅睡
                    }
                    filtAwakeep = 0;
                }else
                {
                    if (filtAwakeep > 3)
                    {
                        filter = 1;
                        filtAwakeep = 0;
                    } else {
                        filtAwakeep = 0;
                    }
                }
                ++deepSleep; }      //深睡
            else if (state == 1){
                if(filtAwakeep>0&&filtAwakeep<4&&filter>3&&sixFiler<49)
                {
                    awakeSleep -= filtAwakeep;
                    lightSleep += filtAwakeep;
                    for (int teb = 1; teb <= filtAwakeep; teb++) {
                        int atIndex = i -teb;
                        [resultArr replaceObjectAtIndex:atIndex withObject:@1];//把清醒换成浅睡
                    }
                    filtAwakeep = 0;
                }else
                {
                    if (filtAwakeep > 3)
                    {
                        filter = 1;
                        filtAwakeep = 0;
                    } else {
                        filtAwakeep = 0;
                    }
                }
                ++lightSleep; }    //浅睡
            else if (state == 0 || state == 3)
            {
                ++awakeSleep;
                ++ filtAwakeep;
            }   //清醒
            ++filter;
            ++sixFiler;
        }
    }
    else{ return (NSMutableArray *)sleepArr;}
    
    return resultArr;
}

+ (CAShapeLayer *)getCornerRoundWithSelfView:(UIView *)originalView byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)size{
    
    //绘制左上和左下圆角
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:originalView.bounds byRoundingCorners:corners cornerRadii:size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    
    maskLayer.frame = originalView.bounds;
    
    maskLayer.path = maskPath.CGPath;
    
    return maskLayer;
    
}


+ (int)calcAge:(NSString *)birthday{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat=@"yyyy-MM-dd";//指定转date得日期格式化形式
    NSDate *ageDate = [dateFormatter dateFromString:birthday];
    
    //获得当前系统时间
    NSDate *currentDate = [NSDate date];
    //获得当前系统时间与出生日期之间的时间间隔
    NSTimeInterval time = [currentDate timeIntervalSinceDate:ageDate];
    //时间间隔以秒作为单位,求年的话除以60*60*24*356
    int age = ((int)time)/(3600*24*365);
    return age;
}

//基准高压和基准低压
+ (NSArray *)calcSWithBirthday:(NSString *)birthday sex:(NSString *)sex{
    NSArray *arr;
    //计算年龄
    int age = [AllTool calcAge:birthday];
    if ([sex isEqualToString:@"1"]) {
        //男
        if (age <= 20) {
            arr = [NSArray arrayWithObjects:@"115",@"73", nil];
        }else if (age >= 21 && age <= 25){
            arr = [NSArray arrayWithObjects:@"115",@"73", nil];
        }else if (age >= 26 && age <= 30){
            arr = [NSArray arrayWithObjects:@"115",@"75", nil];
        }else if (age >= 31 && age <= 35){
            arr = [NSArray arrayWithObjects:@"117",@"76", nil];
        }else if (age >= 36 && age <= 40){
            arr = [NSArray arrayWithObjects:@"120",@"80", nil];
        }else if (age >= 41 && age <= 45){
            arr = [NSArray arrayWithObjects:@"124",@"81", nil];
        }else if (age >= 46 && age <= 50){
            arr = [NSArray arrayWithObjects:@"128",@"82", nil];
        }else if (age >= 51 && age <= 55){
            arr = [NSArray arrayWithObjects:@"134",@"84", nil];
        }else if (age >= 56 && age <= 60){
            arr = [NSArray arrayWithObjects:@"137",@"84", nil];
        }else{
            arr = [NSArray arrayWithObjects:@"148",@"86", nil];
        }
    }else{
        //女
        if (age <= 20) {
            arr = [NSArray arrayWithObjects:@"110",@"70", nil];
        }else if (age >= 21 && age <= 25){
            arr = [NSArray arrayWithObjects:@"110",@"71", nil];
        }else if (age >= 26 && age <= 30){
            arr = [NSArray arrayWithObjects:@"112",@"73", nil];
        }else if (age >= 31 && age <= 35){
            arr = [NSArray arrayWithObjects:@"114",@"74", nil];
        }else if (age >= 36 && age <= 40){
            arr = [NSArray arrayWithObjects:@"116",@"77", nil];
        }else if (age >= 41 && age <= 45){
            arr = [NSArray arrayWithObjects:@"122",@"78", nil];
        }else if (age >= 46 && age <= 50){
            arr = [NSArray arrayWithObjects:@"128",@"79", nil];
        }else if (age >= 51 && age <= 55){
            arr = [NSArray arrayWithObjects:@"134",@"80", nil];
        }else if (age >= 56 && age <= 60){
            arr = [NSArray arrayWithObjects:@"139",@"82", nil];
        }else{
            arr = [NSArray arrayWithObjects:@"145",@"83", nil];
        }
    }
    
    return arr;
}

@end
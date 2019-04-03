//
//  BleTool.m
//  Mistep
//
//  Created by 迈诺科技 on 2017/3/13.
//  Copyright © 2017年 huichenghe. All rights reserved.
//

#define isZhHans [[[NSLocale preferredLanguages] firstObject] hasPrefix:@"zh-Hans"] //是中文为YES其他为NO
#define isTH [[[NSLocale preferredLanguages] firstObject] hasPrefix:@"th"] //是泰文为YES其他为NO


#import "BleTool.h"

@implementation BleTool

/*
 
 *      只有B7才发送天气 ，不是B7
 
 */
+(BOOL)sendWeatherFilter
{
    BOOL isCan = NO;
    
    NSString *str = [ADASaveDefaluts objectForKey:kLastDeviceNAME];
    //adaLog(@"strB7 = %@",str);//@"B7"
    if (NSOrderedSame == [str compare:@"B7" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 2)])
    {
        isCan = YES;
    }
    if([[ADASaveDefaluts objectForKey:WEATHERSUPPORT] intValue]==1)
    {
        isCan = YES;
    }
    return isCan;
}
/*
 
 *     判断系统是什么语言。我们应该用那个语言
 
 */
+(int)setLanguageTool
{
    int langage = 0;//默认中文
    if (!isZhHans)
    {
        langage = 1; // 不是中文就是英文
    }
    if (isTH)
    {
        langage = 2; // 如果是泰语就是泰语
    }
    return langage;
}
/*
 
 *    地点  最大24个字节
 
 */
+(NSData *)checkLocaleLength:(NSData *)localeData
{
    
    if (localeData.length > 24)
    {
        localeData = [localeData subdataWithRange:NSMakeRange(0, 24)];
    }
    return localeData;
}

/*
 
 *    天气内容  最大48个字节
 
 */
+(NSData *)checkWeatherContentLength:(NSData *)weatherContentData
{
    
    if (weatherContentData.length > 48)
    {
        weatherContentData = [weatherContentData subdataWithRange:NSMakeRange(0, 48)];
    }
    return weatherContentData;
}
/*
 
 *    计算发送超时的时间。
 
 */
+(CGFloat)countSendtimeOutWith:(CGFloat)sendL AndReceive:(CGFloat)receiveL
{
    CGFloat timeOut = 0.0;
    timeOut = MAX(sendL, receiveL) * 70.0 + 100.0 + arc4random()%100;
    timeOut /= 1000.0;
    return timeOut;
}

/*
 
 *   计算延时多长时间重发数据
 
 */
//+(int)delayResendTimeWithLength:(int)dataLength
//{
//
//}


//日月： 2
//月日： 1
+(int)getMMDDformat //日期显示格式
{
    int num = 2;
    NSString *lanString = [[NSLocale preferredLanguages] firstObject];
    if ([lanString hasPrefix:@"en"] )//英语
    {
        num = 1;
    }
    else  if ([lanString hasPrefix:@"ko"] )//韩语
    {
        num = 1;
    }
    else  if ([lanString hasPrefix:@"ja"] )//日语
    {
        num = 1;
    }
    else  if ([lanString hasPrefix:@"zh"] )//中文
    {
        num = 1;
    }
    return num;
}
@end

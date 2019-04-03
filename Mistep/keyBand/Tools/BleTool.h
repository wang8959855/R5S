//
//  BleTool.h
//  Mistep
//
//  Created by 迈诺科技 on 2017/3/13.
//  Copyright © 2017年 huichenghe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BleTool : NSObject
/*
 
 *      只有B7才发送天气 ，不是B7
 
 */
+(BOOL)sendWeatherFilter;

/*
 
 *     判断系统是什么语言。我们应该用那个语言
 
 */
+(int)setLanguageTool;


/*
 
 *     地点 最大24个字节
 
 */
+(NSData *)checkLocaleLength:(NSData *)localeData;


/*
 
 *    天气内容  最大48个字节
 
 */
+(NSData *)checkWeatherContentLength:(NSData *)weatherContentData;
/*
 
 *    计算发送超时的时间。
 
 */
+(CGFloat)countSendtimeOutWith:(CGFloat)sendL AndReceive:(CGFloat)receiveL;
/*
 
 *   计算延时多长时间重发数据
 
 */
//+(int)delayResendTimeWithLength:(int)dataLength;
+(int)getMMDDformat; //日期显示格式
@end
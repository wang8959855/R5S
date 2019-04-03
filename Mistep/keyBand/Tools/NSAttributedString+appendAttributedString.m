//
//  NSAttributedString+appendAttributedString.m
//  Mistep
//
//  Created by 迈诺科技 on 2016/11/3.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "NSAttributedString+appendAttributedString.h"

@implementation NSAttributedString (appendAttributedString)


//获取属性字符串
+ (NSMutableAttributedString *)makeAttributedStringWithnumBer:(NSString *)string Unit:(NSString *)unit WithFont:(int)font
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, attributeString.length)];
    NSMutableAttributedString *unitString = [[NSMutableAttributedString alloc] initWithString:unit];
    [unitString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font / 2] range:NSMakeRange(0, unitString.length)];
    [attributeString appendAttributedString:unitString];
    return attributeString;
}

//返回目标时间
+(NSAttributedString *)getAttributedText:(CGFloat)font pickerViewHour:(NSString *)pickerViewHour  pickerViewMinute:(NSString *)pickerViewMinute
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]init];
    if(![pickerViewHour isEqualToString:@"00"])
    {
        NSMutableAttributedString *hour =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%02ldH",[pickerViewHour integerValue]]];
        [hour addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, hour.length - 1)];
        [hour addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font/2] range:NSMakeRange(hour.length - 1,1)];
        [attributedText appendAttributedString:hour];
        //adaLog(@"hour == %@",hour.string);
    }
    
    if(![pickerViewMinute isEqualToString:@"00"])
    {
        NSMutableAttributedString *minute =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%02ldmin",[pickerViewMinute integerValue]]];
        [minute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, minute.length - 3)];
        [minute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font/2] range:NSMakeRange(minute.length - 3,3)];
        [attributedText appendAttributedString:minute];
        //adaLog(@"minute == %@",minute.string);
    }
    return attributedText;
}

@end
//
//  ColorTool.m
//  Mistep
//
//  Created by 迈诺科技 on 2017/1/20.
//  Copyright © 2017年 huichenghe. All rights reserved.
//

#import "ColorTool.h"

@implementation ColorTool


+ (UIColor *)getColor:(NSString *)hexColor{
    NSString *cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if (cString.length < 6) {
        return [UIColor clearColor];
    }
    
    if ([cString hasPrefix:@"OX"]) {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString hasPrefix:@"OX"]) {
        cString = [cString substringFromIndex:2];
    }
    if (cString.length != 6) {
        return [UIColor clearColor];
    }
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r,g,b;
    
    [[NSScanner scannerWithString:rString]scanHexInt:&r];
    [[NSScanner scannerWithString:gString]scanHexInt:&g];
    [[NSScanner scannerWithString:bString]scanHexInt:&b];
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}
/*
 * 用16进制，设置为颜色,透明值
 */
+ (UIColor *)getColorAndAlpha:(NSString *)hexColor alpha:(CGFloat)alpha
{
    NSString *cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if (cString.length < 6) {
        return [UIColor clearColor];
    }
    
    if ([cString hasPrefix:@"OX"]) {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString hasPrefix:@"OX"]) {
        cString = [cString substringFromIndex:2];
    }
    if (cString.length != 6) {
        return [UIColor clearColor];
    }
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r,g,b;
    
    [[NSScanner scannerWithString:rString]scanHexInt:&r];
    [[NSScanner scannerWithString:gString]scanHexInt:&g];
    [[NSScanner scannerWithString:bString]scanHexInt:&b];
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];

}
@end

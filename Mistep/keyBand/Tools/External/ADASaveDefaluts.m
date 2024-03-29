//
//  SHSaveDefaluts.m
//  LEDFAN
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ADASaveDefaluts.h"

@implementation ADASaveDefaluts

+ (void)setObject:(id)obj forKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:obj forKey:key];
    [defaults synchronize];
}

+ (id)objectForKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id object = [defaults objectForKey:key];
    if ([object isKindOfClass:[NSNull class]]) {
        object = nil;
    }
    return object;
}

+ (void)setDeviceType:(id)obj
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:obj forKey:AllDEVICETYPE];
    [defaults synchronize];
    
}
+ (id)getDeviceTypeForKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:AllDEVICETYPE];
}
+ (int)getDeviceTypeInt
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:AllDEVICETYPE] intValue];
}
+ (void)remobeObjectForKey:(NSString *)key {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}
+(void)setAllColor:(UIColor *)color forKey:(NSString *)key
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    NSArray *arr =@[[NSString stringWithFormat:@"%f",components[0]],[NSString stringWithFormat:@"%f",components[1]],[NSString stringWithFormat:@"%f",components[2]],[NSString stringWithFormat:@"%f",components[3]]];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //adaLog(@"arr == %@",arr);
}
+(UIColor *)colorForKey:(NSString *)key
{
    NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    //adaLog(@"array == %@",array);
    
    return [UIColor colorWithRed:[array[0] floatValue] green:[array[1] floatValue] blue:[array[2] floatValue] alpha:[array[3] floatValue]];
}
@end

//
//  ColorTool.h
//  Mistep
//
//  Created by 迈诺科技 on 2017/1/20.
//  Copyright © 2017年 huichenghe. All rights reserved.
//

//颜色的 的处理工具

#import <Foundation/Foundation.h>

@interface ColorTool : NSObject
/*
 * 用16进制，设置为颜色
 */
+ (UIColor *)getColor:(NSString *)hexColor;
/*
 * 用16进制，设置为颜色,透明值
 */
+ (UIColor *)getColorAndAlpha:(NSString *)hexColor alpha:(CGFloat)alpha;
@end

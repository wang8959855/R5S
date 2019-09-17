//
//  NSMutableArray+Extension.m
//  test1
//
//  Created by apple on 2019/8/5.
//  Copyright © 2019 apple. All rights reserved.
//

#import "NSMutableArray+Extension.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Extension)

+ (void)load
{
    NSString *version= [UIDevice currentDevice].systemVersion;
    if (version.integerValue < 10) {
        return;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class clsI = NSClassFromString(@"__NSArrayM");
        
        Method method1 = class_getInstanceMethod(clsI, @selector(objectAtIndexedSubscript:));
        Method method2 = class_getInstanceMethod(clsI, @selector(yye_objectAtIndexedSubscript:));
        method_exchangeImplementations(method1, method2);
        
        Method method3 = class_getInstanceMethod(clsI, @selector(objectAtIndex:));
        Method method4 = class_getInstanceMethod(clsI, @selector(yye_objectAtIndex:));
        method_exchangeImplementations(method3, method4);
        
        Class clsSingleI = NSClassFromString(@"__NSSingleObjectArrayM");
        Method method5 = class_getInstanceMethod(clsSingleI, @selector(objectAtIndex:));
        Method method6 = class_getInstanceMethod(clsSingleI, @selector(yyeSingle_objectAtIndex:));
        method_exchangeImplementations(method5, method6);
    });
}

- (id)yye_objectAtIndexedSubscript:(NSUInteger)index{
    if(index>=self.count) return @"";
    
    return [self yye_objectAtIndexedSubscript:index];
}

- (id)yye_objectAtIndex:(NSUInteger)index{
    if(index>=self.count) return @"";
    
    return [self yye_objectAtIndex:index];
}

- (id)yyeSingle_objectAtIndex:(NSUInteger)index{
    if(index>=self.count){
        return @"";
    }
    
    return [self yyeSingle_objectAtIndex:index];
}

@end

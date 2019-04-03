//
//  AlertMainView.h
//  Wukong
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

typedef enum : NSUInteger {
    AlertMainViewTypeTest,
    AlertMainViewTypePolice,
    AlertMainViewTypeRegulation,
} AlertMainViewType;

#import <UIKit/UIKit.h>

@interface AlertMainView : UIView

/**
 * 单行
 */
+ (AlertMainView *)alertMainViewWithType:(AlertMainViewType)type;

/**
 * 多行
 */
+ (AlertMainView *)alertMainViewWithArray:(NSArray *)array;

@end

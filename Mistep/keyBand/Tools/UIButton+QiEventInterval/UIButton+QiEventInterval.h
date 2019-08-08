//
//  UIButton+QiEventInterval.h
//  Wukong
//
//  Created by apple on 2019/7/15.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (QiEventInterval)

@property (nonatomic, assign) NSTimeInterval custom_acceptEventInterval;// 可以用这个给重复点击加间隔

@end

NS_ASSUME_NONNULL_END

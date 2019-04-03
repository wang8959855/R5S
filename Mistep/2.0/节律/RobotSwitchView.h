//
//  RobotSwitchView.h
//  Wukong
//
//  Created by apple on 2019/3/29.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^backRobotSwitchBlock)(NSInteger count, NSArray *arr);
@interface RobotSwitchView : UIView

+ (instancetype)robotSwitchView;

@property (nonatomic, copy) backRobotSwitchBlock backRobotSwitchBlock;

@end

NS_ASSUME_NONNULL_END

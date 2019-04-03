//
//  PoliceAlertView.h
//  Wukong
//
//  Created by apple on 2018/9/4.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^switchStateBlock)(BOOL state);
@interface PoliceAlertView : UIView

+ (PoliceAlertView *)policeAlertView;

- (void)show;

@property (nonatomic, copy) switchStateBlock switchStateBlock;

@end

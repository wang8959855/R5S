//
//  SOSView.h
//  Wukong
//
//  Created by apple on 2018/5/23.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sosOKBlock)(void);
@interface SOSView : UIView

+ (SOSView *)initSOSView;

- (void)show;


@property (nonatomic, copy) sosOKBlock sosOKBlock;
@end

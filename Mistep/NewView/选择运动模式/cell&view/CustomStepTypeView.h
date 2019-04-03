//
//  CustomStepTypeView.h
//  Wukong
//
//  Created by apple on 2018/6/28.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CustomStepTypeBlock)(NSString *type);
@interface CustomStepTypeView : UIView

@property (nonatomic, copy) CustomStepTypeBlock CustomStepTypeBlock;

+ (instancetype)customStepTypeView;

- (void)show;

@end

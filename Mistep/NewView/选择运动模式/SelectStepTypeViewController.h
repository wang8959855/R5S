//
//  SelectStepTypeViewController.h
//  Wukong
//
//  Created by apple on 2018/6/26.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^backStepType)(NSString *type);

@interface SelectStepTypeViewController : UIViewController

@property (nonatomic, copy) backStepType backStepType;

@end

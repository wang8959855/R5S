//
//  DeviceTypeViewController.h
//  Mistep
//
//  Created by 迈诺科技 on 2016/11/23.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "PZBaseViewController.h"

@protocol DeviceTypeViewControllerDelegate <NSObject>
-(void)deviceisChange:(BOOL)change;
@end
@interface DeviceTypeViewController : PZBaseViewController
@property (nonatomic,weak) id<DeviceTypeViewControllerDelegate> delegate;
@property (nonatomic,assign) BOOL isHiddenBackButton;

@end

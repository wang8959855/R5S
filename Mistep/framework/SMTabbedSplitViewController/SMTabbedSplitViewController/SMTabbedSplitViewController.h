//
//  SMSplitViewController.h
//  SMSplitViewController
//
//  Created by Sergey Marchukov on 15.02.14.
//  Copyright (c) 2014 Sergey Marchukov. All rights reserved.
//
//  This content is released under the ( http://opensource.org/licenses/MIT ) MIT License.
//  Repository: https://github.com/sergik-ru/SMTabbedSplitViewController
//  Version 1.0.3
//

#import <UIKit/UIKit.h>
#import "PZBaseViewController.h"
#import "SMTabBar.h"

typedef NS_ENUM(NSUInteger, SMSplitType) {
    
    SMTabbedSplt,
    SMDefaultSplit
};

@interface SMTabbedSplitViewController : PZBaseViewController

@property (nonatomic, readonly, strong) SMTabBar *tabBar;
@property (nonatomic, weak) UIColor *background;
@property (nonatomic, strong) NSArray *tabsViewControllers;
@property (nonatomic, strong) NSArray *actionsButtons;
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, readonly, weak) UIViewController *masterViewController;
@property (nonatomic) SMSplitType splitType;

- (id)initTabbedSplit;
- (id)initSplit;
- (void)backButtonClick;
- (void)hideMaster;
- (void)showMaster;

@end
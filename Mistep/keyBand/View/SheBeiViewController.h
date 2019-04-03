//
//  SheBeiViewController.h
//  keyBand
//
//  Created by 迈诺科技 on 15/11/3.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import "PZBaseViewController.h"

typedef void(^removeBindingBlock)(int number);

@interface SheBeiViewController : PZBaseViewController

@property (nonatomic, copy) NSArray *deviceArray;

@property (weak, nonatomic) IBOutlet UIImageView *UpviewBackgroup;

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (weak, nonatomic)IBOutlet UITableView *deviceTableView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UILabel *zhaoshouhuanLabel;

@property (weak, nonatomic) IBOutlet UILabel *zhaoshouhuanDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *resetLabel;

@property (weak, nonatomic) IBOutlet UILabel *resetDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *clearCacheLabel;

@property (weak, nonatomic) IBOutlet UILabel *clearCacheDetalLabel;

@property (weak, nonatomic) IBOutlet UIImageView *searchViewTopView;
@property (weak, nonatomic) IBOutlet UILabel *deviceName;
@property (weak, nonatomic) IBOutlet UIImageView *helpImageView;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (copy, nonatomic) removeBindingBlock removeBindingBlock;
@property (weak, nonatomic) IBOutlet UILabel *sousuoTitle;


+ (SheBeiViewController *)sharedInstance;//唯一的实例化方法


-(void)changRemoveBinding:(removeBindingBlock)removeBindingBlock;

@end

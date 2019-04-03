//
//  HomeViewController.h
//  keyband
//
//  Created by 迈诺科技 on 15/10/29.
//  Copyright © 2015年 mainuo. All rights reserved.
//

#import "PZBaseViewController.h"

@interface HomeViewController : PZBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *dianliangLabel;

@property (weak, nonatomic) IBOutlet UILabel *lianjieLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIButton *loginButton;

@property (strong, nonatomic) CositeaBlueTooth *blueManage;

@property (strong, nonatomic) NSArray *dataArray;



@end

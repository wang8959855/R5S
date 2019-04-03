//
//  SMSAlarmViewController.h
//  Wukong
//
//  Created by 迈诺科技 on 16/5/18.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "PZBaseViewController.h"

@interface SMSAlarmViewController : PZBaseViewController


@property (strong, nonatomic) NSArray *dataArray;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *tagArray;

@end

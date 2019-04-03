//
//  JiuzuoViewController.h
//  Wukong
//
//  Created by 迈诺科技 on 16/5/18.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "PZBaseViewController.h"

@interface JiuzuoViewController : PZBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UILabel *kJiuzuoShijianLabel;

@property (copy, nonatomic) NSArray *dataArray;

@property (strong, nonatomic) NSMutableArray *exitArray;

@end

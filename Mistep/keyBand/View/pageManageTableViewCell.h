//
//  pageManageTableViewCell.h
//  Mistep
//
//  Created by 迈诺科技 on 2016/12/9.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^setPage)(NSInteger num);

@interface pageManageTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong) UIImageView *headImageView;
@property(nonatomic,strong) UILabel *headLabel;
@property(nonatomic,strong) UISwitch *Switch;

@property(nonatomic,strong) NSString *imageString;
@property(nonatomic,strong) NSString *titleString;

@property (strong, nonatomic) NSString *openTag;
@property (copy, nonatomic) setPage setPage;

@end

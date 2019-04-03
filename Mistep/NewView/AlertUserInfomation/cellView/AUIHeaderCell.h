//
//  AUIHeaderCell.h
//  Wukong
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AUIHeaderCell : UITableViewCell

+ (AUIHeaderCell *)tableView:(UITableView *)tableView identfire:(NSString *)identfire;

@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property (weak, nonatomic) IBOutlet UIImageView *userHeader;

@property (weak, nonatomic) IBOutlet UIButton *alertNickButton;
@property (weak, nonatomic) IBOutlet UIButton *selectHeaderButton;


@end

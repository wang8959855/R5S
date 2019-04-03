//
//  AUIAccountCell.h
//  Wukong
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AUIAccountCell : UITableViewCell

+ (AUIAccountCell *)tableView:(UITableView *)tableView identfire:(NSString *)identfire;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIButton *alertButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertRight;

@end

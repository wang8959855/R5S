//
//  AUIMineCell.h
//  Wukong
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AUIMineCell : UITableViewCell

+ (AUIMineCell *)tableView:(UITableView *)tableView identfire:(NSString *)identfire;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailRight;



@end

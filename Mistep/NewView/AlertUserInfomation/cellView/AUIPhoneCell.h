//
//  AUIPhoneCell.h
//  Wukong
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AUIPhoneCell : UITableViewCell

+ (AUIPhoneCell *)tableView:(UITableView *)tableView identfire:(NSString *)identfire;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

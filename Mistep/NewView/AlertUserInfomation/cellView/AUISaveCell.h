//
//  AUISaveCell.h
//  Wukong
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AUISaveCell : UITableViewCell

+ (AUISaveCell *)tableView:(UITableView *)tableView identfire:(NSString *)identfire;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;


@end

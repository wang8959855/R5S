//
//  SMSTableViewCell.h
//  Wukong
//
//  Created by 迈诺科技 on 16/5/18.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SMSTableViewCell : UITableViewCell

@property (assign, nonatomic) int openTag;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UISwitch *openSwitch;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;



@end

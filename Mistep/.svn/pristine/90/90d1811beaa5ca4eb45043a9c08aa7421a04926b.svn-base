//
//  SMSTableViewCell.m
//  Wukong
//
//  Created by 迈诺科技 on 16/5/18.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "SMSTableViewCell.h"

@implementation SMSTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_openSwitch setOn:NO];
}
- (IBAction)switchValueChanged:(UISwitch *)sender
{
    [[CositeaBlueTooth sharedInstance] setSystemAlarmWithType:_openTag State:sender.isOn];
    [self performSelector:@selector(queryAlarm) withObject:nil afterDelay:0.08];
}

- (void)queryAlarm
{
//    [[BlueToothManager getInstance] querySystemAlarmWithIndex:_openTag];
    [[CositeaBlueTooth sharedInstance] checkSystemAlarmWithType:_openTag StateBlock:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

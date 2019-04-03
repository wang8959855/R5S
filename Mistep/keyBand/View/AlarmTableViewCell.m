//
//  AlarmTableViewCell.m
//  keyBand
//
//  Created by 迈诺科技 on 15/11/25.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import "AlarmTableViewCell.h"

@implementation AlarmTableViewCell

//- (void)awakeFromNib {
//    // Initialization code
//}

- (void)dealloc
{
    self.cellDic = nil;
}

- (void)setCellDic:(NSDictionary *)cellDic
{
    if (_cellDic != cellDic)
    {
        _cellDic = cellDic;
        _dateLabel.text = cellDic[@"1"];
        _weekLabel.text = cellDic[@"2"];
        _typeLabel.text = cellDic[@"0"];
//        _stringLabel.text = cellDic[@"4"];
        _typeImageVIew.image = [UIImage imageNamed:cellDic[@"5"]];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

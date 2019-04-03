//
//  JiuzuoTableViewCell.m
//  Wukong
//
//  Created by 迈诺科技 on 16/5/18.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "JiuzuoTableViewCell.h"

@implementation JiuzuoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(SedentaryModel *)model
{
    _model = model;
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d-%02d:%02d",model.beginHour,model.beginMin,model.endHour,model.endMin];
    self.durationLabel.text = [NSString stringWithFormat:@"%d%@",model.duration,NSLocalizedString(@"分钟", nil)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

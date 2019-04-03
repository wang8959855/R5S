//
//  VoiceCell.m
//  Wukong
//
//  Created by apple on 2019/3/30.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import "VoiceCell.h"

@implementation VoiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

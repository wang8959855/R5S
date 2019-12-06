//
//  SuggestCell.m
//  Wukong
//
//  Created by apple on 2019/12/3.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import "SuggestCell.h"

@implementation SuggestCell

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

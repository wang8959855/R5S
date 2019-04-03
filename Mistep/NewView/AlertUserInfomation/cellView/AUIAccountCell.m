//
//  AUIAccountCell.m
//  Wukong
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "AUIAccountCell.h"

@implementation AUIAccountCell

+ (AUIAccountCell *)tableView:(UITableView *)tableView identfire:(NSString *)identfire{
    AUIAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:identfire];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AUIAccountCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

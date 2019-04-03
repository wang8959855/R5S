//
//  AUIHeaderCell.m
//  Wukong
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "AUIHeaderCell.h"

@implementation AUIHeaderCell

+ (AUIHeaderCell *)tableView:(UITableView *)tableView identfire:(NSString *)identfire{
    AUIHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:identfire];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AUIHeaderCell" owner:self options:nil].lastObject;
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

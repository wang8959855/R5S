//
//  AUIMineCell.m
//  Wukong
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "AUIMineCell.h"

@implementation AUIMineCell

+ (AUIMineCell *)tableView:(UITableView *)tableView identfire:(NSString *)identfire{
    AUIMineCell *cell = [tableView dequeueReusableCellWithIdentifier:identfire];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AUIMineCell" owner:self options:nil].lastObject;
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

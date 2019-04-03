//
//  FriendListCell.m
//  Wukong
//
//  Created by apple on 2018/5/19.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "FriendListCell.h"

@implementation FriendListCell

+ (FriendListCell *)tableView:(UITableView *)tableView identfire:(NSString *)identfire{
    FriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:identfire];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FriendListCell" owner:self options:nil].firstObject;
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

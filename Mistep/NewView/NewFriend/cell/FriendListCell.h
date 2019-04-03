//
//  FriendListCell.h
//  Wukong
//
//  Created by apple on 2018/5/19.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendListCell : UITableViewCell

+ (FriendListCell *)tableView:(UITableView *)tableView identfire:(NSString *)identfire;

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *heartRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sportsLabel;


@end

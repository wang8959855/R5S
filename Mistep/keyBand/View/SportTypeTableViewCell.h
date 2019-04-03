//
//  SportModelTableViewCell.h
//  Mistep
//
//  Created by 迈诺科技 on 2016/10/24.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SportTypeTableViewCell : UITableViewCell
@property (nonatomic,copy)NSString *titleName;
@property (nonatomic,copy)NSString *imageName;
@property (nonatomic,copy)NSString *markName;


+ (instancetype)cellWithSportModelTableView:(UITableView *)tableView;
- (void)SportModelRefresh:(NSInteger)row;



@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;

@end

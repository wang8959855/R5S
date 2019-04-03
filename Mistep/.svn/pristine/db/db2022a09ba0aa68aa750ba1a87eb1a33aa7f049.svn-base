//
//  SportModelTableViewCell.m
//  Mistep
//
//  Created by 迈诺科技 on 2016/10/24.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "SportTypeTableViewCell.h"
@interface SportTypeTableViewCell()


@end
@implementation SportTypeTableViewCell

+ (instancetype)cellWithSportModelTableView:(UITableView *)tableView
{
    static NSString *cellID = @"SportModelTableViewCell";
    SportTypeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"SportTypeTableViewCell" owner:self options:nil] firstObject];
        //        cell = [[SportModelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
    }
    return self;
}
- (void)SportModelRefresh:(NSInteger)row
{
    switch (row) {
        case 1:
            self.imageName = @"buxing";
            self.titleName = NSLocalizedString(@"徒步", nil);
            break;
        case 2:
            self.imageName = @"Run_Sport";
            self.titleName = NSLocalizedString(@"跑步", nil);
            break;
        case 3:
            self.imageName = @"Climbing";
            self.titleName = NSLocalizedString(@"登山", nil);
            break;
        case 4:
            self.imageName = @"BallClassSport";
            self.titleName = NSLocalizedString(@"球类运动", nil);
            break;
        case 5:
            self.imageName = @"Strength_Training";
            self.titleName = NSLocalizedString(@"力量训练", nil);
            break;
        case 6:
            self.imageName = @"AerobicTraining_map";
            self.titleName = NSLocalizedString(@"有氧运动", nil);
            break;
        case 7:
            self.imageName = @"customize";
            self.titleName = NSLocalizedString(@"自定义", nil);
            break;
        default:
            self.imageName = @"buxing";
            self.titleName = NSLocalizedString(@"徒步", nil);
            break;
    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setTitleName:(NSString *)titleName
{
    _titleName = titleName;
    _title.text = titleName;
}
-(void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    UIImage *imageUse = [UIImage imageNamed:imageName];
    _headImage.image = imageUse;
}
-(void)setMarkName:(NSString *)markName
{
    _markName = markName;
    UIImage *markImageUse = [UIImage imageNamed:markName];
    _markImageView.image = markImageUse;
}
//-(void)setHeadImage:(NSString *)headImageName
//{
//    UIImage *imageUse = [UIImage imageNamed:headImageName];
//    _headImage.image = imageUse;
//
//}
//-(void)setTitle:(NSString *)titleString
//{
//    _title.text = titleString;
//}
//-(void)setMarkImageView:(NSString *)markImageViewName
//{
//
//    UIImage *markImageUse = [UIImage imageNamed:markImageViewName];
//    _markImageView.image = markImageUse;
//}
@end

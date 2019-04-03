//
//  pageManageTableViewCell.m
//  Mistep
//
//  Created by 迈诺科技 on 2016/12/9.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "pageManageTableViewCell.h"
#import "Masonry.h"

@implementation pageManageTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static  NSString *cellID = @"pageManageTableViewCell";
    pageManageTableViewCell *pageCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!pageCell)
    {
        pageCell = [[pageManageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    return pageCell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       [self setupView];
    }
    return self;
}
-(void)setupView
{
    _headImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_headImageView];
    
    CGFloat headImageViewX = 20*WidthProportion;
    CGFloat headImageViewW = 40*WidthProportion;
    CGFloat headImageViewH = headImageViewW;
    CGFloat headImageViewY = (65*HeightProportion - headImageViewH)/2;
    _headImageView.frame = CGRectMake(headImageViewX, headImageViewY, headImageViewW, headImageViewH);
    
    
    _headLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_headLabel];
    CGFloat headLabelX = CGRectGetMaxX(_headImageView.frame);
    CGFloat headLabelW = 150*WidthProportion;
    CGFloat headLabelH = 30;
    CGFloat headLabelY = (65*HeightProportion - headLabelH)/2;
    _headLabel.frame = CGRectMake(headLabelX, headLabelY, headLabelW, headLabelH);
    
    
    _Switch = [[UISwitch alloc]init];
    [self.contentView addSubview:_Switch];
    [_Switch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventTouchUpInside];
//    _Switch.backgroundColor = allColorRed;
    _Switch.onTintColor = [UIColor blueColor];
    CGFloat switchX = CGRectGetMaxX(_headImageView.frame) + 170*WidthProportion;
    CGFloat switchW = 49*WidthProportion;
    CGFloat switchH = 31*HeightProportion;
    CGFloat switchY = (65*HeightProportion - switchH)/2;
    _Switch.frame = CGRectMake(switchX, switchY, switchW, switchH);
    
    
    //    _Switch.sd_layout
    //    .widthIs(49)
    //    .heightIs(31)
    //    .topSpaceToView(self.contentView,10*WidthProportion)
    //    .rightSpaceToView(self.contentView,60*WidthProportion);
    //.centerYIs(self.contentView.centerY)
}

- (void)switchValueChanged:(UISwitch *)sender
{
    //adaLog(@"sender.isOn - -%d",sender.isOn);
    self.setPage([_openTag intValue]);
}

-(void)setImageString:(NSString *)imageString
{ 
    if (imageString) {
        _imageString = imageString;
        _headImageView.image = [UIImage imageNamed:imageString];
    }
}
-(void)setTitleString:(NSString *)titleString
{
    if (titleString)
    {
        _titleString = titleString;
        _headLabel.text = titleString;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib]; 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

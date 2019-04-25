//
//  AttentionCell.m
//  Bracelet
//
//  Created by apple on 2018/10/25.
//  Copyright © 2018 com.czjk.www. All rights reserved.
//

#import "AttentionCell.h"
#import "UIImageView+WebCache.h"

@implementation AttentionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headerImage.layer.cornerRadius = (ScreenWidth - 140)/3/2;
    self.headerImage.layer.masksToBounds = YES;
}

- (void)setDic:(NSDictionary *)dic{
    if (dic[@"name"] && ![dic[@"name"] isEqual:[NSNull null]]) {
        self.nameLabel.text = dic[@"name"];
    }else{
        self.nameLabel.text = @"";
    }
    if ([dic[@"client"] isEqualToString:@"wx"]) {
        self.wxImage.hidden = NO;
    }else{
        self.wxImage.hidden = YES;
    }
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
}

@end

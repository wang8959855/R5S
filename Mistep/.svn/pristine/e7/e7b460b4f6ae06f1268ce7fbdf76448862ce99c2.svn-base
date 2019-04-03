//
//  DoneCustomView.m
//  zidingyi
//
//  Created by 蒋宝 on 17/3/16.
//  Copyright © 2017年 Smartbi. All rights reserved.
//

#import "DoneCustomView.h"

@interface DoneCustomView()

@property (nonatomic,strong) UILabel *titleLabel;

@end
@implementation DoneCustomView
- (id)init
{
    self = [super init];
    if (self) {
        [self addDoneCustomView];
        self.backgroundColor = [UIColor colorWithRed:232/255.0 green:240/255.0 blue:249/255.0 alpha:15];
//        [UIColor clearColor];
//        [UIColor colorWithRed:232/255.0 green:240/255.0 blue:249/255.0 alpha:15];// [ColorTool getColor:@"0f003afd"];
//        [UIColor greenColor];
    }
    return self;
}
-(void)addDoneCustomView
{
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
-(void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    self.titleLabel.text = titleString;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsLayout];
}
@end

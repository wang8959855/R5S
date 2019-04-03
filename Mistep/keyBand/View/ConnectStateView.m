//
//  ConnectStateView.m
//  Mistep
//
//  Created by 迈诺科技 on 2017/3/17.
//  Copyright © 2017年 huichenghe. All rights reserved.
//

#import "ConnectStateView.h"
@interface ConnectStateView()

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation ConnectStateView


- (id)init
{
    self = [super init];
    if (self) {
        [self addDoneCustomView];
        self.backgroundColor = [UIColor colorWithRed:232/255.0 green:240/255.0 blue:249/255.0 alpha:15];// [ColorTool getColor:@"0f003afd"];
        //[UIColor greenColor];
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
-(void)setStateString:(NSString *)stateString
{
    _stateString = stateString;
    self.titleLabel.text = stateString;
    
}
//-(void)setTitleString:(NSString *)titleString
//{
//    _titleString = titleString;
//    self.titleLabel.text = titleString;
//}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsLayout];
}
-(void)setLabeltextColor:(UIColor *)labeltextColor
{
    _labeltextColor = labeltextColor;
    
    self.titleLabel.textColor = labeltextColor;
}

@end

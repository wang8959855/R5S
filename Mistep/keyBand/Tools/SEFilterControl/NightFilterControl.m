//
//  NightFilterControl.m
//  keyBand
//
//  Created by 迈诺科技 on 15/11/11.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import "NightFilterControl.h"

@implementation NightFilterControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id) initWithFrame:(CGRect) frame Titles:(NSArray *) titles
{
    self = [super initWithFrame:frame Titles:titles];
    if (self)
    {
        self.backImageView.image = [UIImage imageNamed:@"lvtiao.png"];
        [self.handler setImage:[UIImage imageNamed:@"setStep.png"] forState:UIControlStateNormal];
        self.tipLabel.textColor = [UIColor colorWithRed:122/255.0 green:68/255.0 blue:129/255.0 alpha:1];
    }
    return self;
}

@end

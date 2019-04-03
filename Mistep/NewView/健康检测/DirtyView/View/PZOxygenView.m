//
//  PZOxygenView.m
//  Wukong
//
//  Created by apple on 2018/6/24.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "PZOxygenView.h"

#define kWidthX(x) self.width/24 * x
#define kHeight(x) self.height/100 * x
@implementation PZOxygenView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self addChildView];
    }
    return self;
}

- (void)addChildView {
    for (int i = 0; i < 10; i ++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8,i * (self.height-23)/10, 30, (self.height-23)/10)];
        label.text = [NSString stringWithFormat:@"%d",99-i];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [UIColor grayColor];
        [self addSubview:label];
    }
    
    for (int i = 0; i < 24; i ++)
    {
        UILabel *label = [[UILabel alloc] init];
        NSString *text = [NSString stringWithFormat:@"%d",i];
        if (text.length == 1)
        {
            text = [NSString stringWithFormat:@"0%@:00",text];
        }else{
            text = [NSString stringWithFormat:@"%@:00",text];
        }
        label.text = text;
        [label sizeToFit];
        label.font = [UIFont systemFontOfSize:9];
        label.textColor = [UIColor grayColor];
        label.frame =CGRectMake(i * 35+30, self.height - 10, 30 , 10);
        [self addSubview:label];
    }
}

@end

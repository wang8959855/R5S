//
//  PZPilaoView.m
//  Wukong
//
//  Created by 迈诺科技 on 16/5/12.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "PZPilaoView.h"
#import "PZPilaoChart.h"

#define kWidthX(x) self.width/24 * x
#define kHeight(x) self.height/100 * x

@implementation PZPilaoView

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

- (void)addChildView
{
//    NSArray *colorArray = @[[UIColor whiteColor],[UIColor whiteColor]];
    
//    NSArray *textArray = @[NSLocalizedString(@"         活力", nil),NSLocalizedString(@"         疲劳", nil),kColor(70,61,173),[UIColor whiteColor]];
//    for (int i = 0; i < 2; i++)
//    {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height/2 * i, self.width,  floor(self.height/2+1))];
//        label.backgroundColor = colorArray[i];
//        label.font = [UIFont systemFontOfSize:12];
//        label.text = textArray[i];
//        label.textColor = textArray[2+i];
//        label.textColor = [UIColor grayColor];
//        [self addSubview:label];
//
//    }
    
    
    for (int i = 0; i < 5; i ++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8,i * (self.height)/5, 30, 10)];
        label.text = [NSString stringWithFormat:@"%d",100 - 20*i];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [UIColor grayColor];
        [self addSubview:label];
        if(i == 0 || i == 9 || i == 5)
        {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [UIImage imageNamed:@"XQ_pointLine"];
            [self addSubview:imageView];
            imageView.frame = CGRectMake(32, i * (self.height - 8)/5 + 5, CurrentDeviceWidth20 - 38, 1);
            imageView.contentMode = UIViewContentModeLeft;
        }
    }
    
    for (int i = 0; i < 24; i ++)
    {
        UILabel *label = [[UILabel alloc] init];
        NSString *text = [NSString stringWithFormat:@"%d",i];
        if (text.length == 1)
        {
            text = [NSString stringWithFormat:@"0%@",text];
        }
        label.text = text;
        [label sizeToFit];
        label.font = [UIFont systemFontOfSize:9];
        label.textColor = [UIColor grayColor];
        label.frame =CGRectMake(i * (CurrentDeviceWidth20-12)/23, self.height - 10, 12 , 10);
        [self addSubview:label];
    }
}



//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextMoveToPoint(context, 0, kHeight(50));
//    //adaLog(@"%f，%f",kWidthX(10),kHeight(50));
//    CGContextAddQuadCurveToPoint(context, kWidthX(20), kHeight(80), kWidthX(10), kWidthX(80));
//    CGContextStrokePath(context);
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/

@end

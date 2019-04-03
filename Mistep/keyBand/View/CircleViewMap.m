//
//  CircleView.m
//  cyuc
//
//  Created by 迈诺科技 on 2017/1/22.
//  Copyright © 2017年 huichenghe. All rights reserved.
//

#import "CircleViewMap.h"

@interface CircleViewMap()

@end

@implementation CircleViewMap

+(CircleViewMap *)getObject:(CGRect )rect;
{
    return [[self alloc] initWithFrame:rect];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineWidth = 3;
        _percent = 0.9;
        self.backgroundColor = [UIColor clearColor];  //  colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];
    }
    return self;
}
- (void)setPercent:(CGFloat)percent{
    _percent = percent;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    //An opaque type that represents a Quartz 2D drawing environment.
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    //边框圆
    //    CGContextSetRGBStrokeColor(context,0.6,0.1,0.1,1.0);//画笔线的颜色
    CGContextSetRGBStrokeColor(context,1,1,1,1);
    CGContextSetLineWidth(context, _lineWidth);//线的宽度
    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    CGSize viewSize = self.bounds.size;
    //    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    // Draw the slices.
    //    CGFloat radius = viewSize.width / 2 - width;
    
    CGContextAddArc(context, viewSize.width/2, viewSize.height/2, viewSize.width/2 -2, -M_PI/2, [self getfloatWithfloat:_percent], 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
}
-(CGFloat)getfloatWithfloat:(CGFloat )number
{
    //    CGFloat zhen = 0.0;
    //    if (number<0.25)
    //    {
    //       zhen = (number*M_PI*2) - M_PI/2 ;
    //    }
    //    else
    //    {
    //        zhen = (number*M_PI*2) - M_PI/2 ;
    //    }
    return ((number*M_PI*2) - M_PI/2);
}
@end

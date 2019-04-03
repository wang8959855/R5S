//
//  PZChart.m
//  keyBand
//
//  Created by 迈诺科技 on 15/12/4.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import "PZChart.h"

@implementation PZChart

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setHeartArray:(NSArray *)heartArray
{
    if (_heartArray != heartArray)
    {
        _heartArray = heartArray;
        self.frame = CGRectMake(0, 0, self.heartArray.count + 20, self.height);
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    if (_heartArray.count != 0)
    {
        long pointCount = _heartArray.count/10 + 1;
        NSMutableArray *pointArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < pointCount - 1; i ++)
        {
            float x =  5 + i * 10 +10;
            float value = 0;
            for (int j = 0; j < 10; j ++)
            {
                if (value < [_heartArray[i *10 + j] floatValue])
                {
                    value = [_heartArray[i *10 + j] floatValue];
                }
            }

            float y = (220 - value) * self.height/220.0;
            if (value != 0)
            {
                [pointArray addObject:NSStringFromCGPoint(CGPointMake(x, y))];
            }
        }
        if (pointArray.count == 0)
        {
            return;
        }
        for (int i = 0; i < pointArray.count - 1; i++)
        {
            CGPoint firstPoint = CGPointFromString(pointArray[i]);
            CGPoint secondPoint = CGPointFromString(pointArray[i +1]);
            UIBezierPath* path = [UIBezierPath bezierPath];
            [path setLineWidth:1];
            
            [path moveToPoint:firstPoint];
            [path addCurveToPoint:secondPoint controlPoint1:CGPointMake((secondPoint.x-firstPoint.x)/2+firstPoint.x, firstPoint.y) controlPoint2:CGPointMake((secondPoint.x-firstPoint.x)/2+firstPoint.x, secondPoint.y)];
            UIColor *lineColor = [UIColor colorWithRed:241/255.0 green:130/255.0 blue:130/255.0 alpha:1];
            [lineColor set];
            
            path.lineCapStyle = kCGLineCapRound;
            [path strokeWithBlendMode:kCGBlendModeNormal alpha:1];
        }
//        if(pointArray.count != 0)
//        {
//            
//            context = UIGraphicsGetCurrentContext();
//            CGContextSetRGBStrokeColor(context, 241/255.0, 130/255.0, 130/255.0, 1);
//            
//            
//            CGPoint point = CGPointFromString(pointArray[0]);
//            CGContextMoveToPoint(context, point.x, point.y);
//            for (int i = 2; i < pointArray.count; i++) {
//                
//                CGPoint p0 = CGPointFromString(pointArray[i - 1]) ;
//                CGPoint p1 = CGPointFromString(pointArray[i]);
//                int hSegments = floorf((p1.x - p0.x) / 1);
//                float dx = (p1.x - p0.x) / hSegments;
//                float da = M_PI / hSegments;
//                float ymid = (p0.y + p1.y) / 2;
//                float ampl = (p0.y - p1.y) / 2;
//                CGPoint pt0,pt1;
//                pt0 = p0;
//                for (int j = 0; j < hSegments + 1; ++j) {
//                    pt1.x = p0.x + j * dx;
//                    pt1.y = ymid + ampl * cosf(da * j);
//                    CGContextAddLineToPoint(context, pt0.x, pt0.y);
//                    CGContextAddLineToPoint(context, pt1.x, pt1.y);
//                    pt0 = pt1;
//                }   
//            }
//            CGContextStrokePath(context);
//        }

    }
}

@end

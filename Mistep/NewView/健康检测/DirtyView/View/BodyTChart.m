//
//  BodyTChart.m
//  Wukong
//
//  Created by apple on 2018/6/24.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "BodyTChart.h"

@implementation BodyTChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setBodyTArray:(NSArray *)bodyTArray{
    if (_bodyTArray != bodyTArray)
    {
        _bodyTArray = bodyTArray;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (_bodyTArray.count != 0)
    {
        long pointCount = _bodyTArray.count+1;
        NSMutableArray *pointArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < pointCount - 1; i ++)
        {
            float x = i * 35 +35+15;
            float value = 0;
            
            value = [_bodyTArray[i] floatValue];
            
            float y = (77.5 - value) * self.height/77.5-1.5;
            if (value == 0) {
                y = self.height-1.5;
            }
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
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetRGBStrokeColor(context, 241/255.0, 130/255.0, 130/255.0, 1);
            
            CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
            CGContextAddLineToPoint(context, secondPoint.x, secondPoint.y);
            CGContextStrokePath(context);
        }
        
    }
}

@end

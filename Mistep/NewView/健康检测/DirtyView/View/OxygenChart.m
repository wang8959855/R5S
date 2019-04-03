//
//  OxygenChart.m
//  Wukong
//
//  Created by apple on 2018/6/24.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "OxygenChart.h"

@implementation OxygenChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setOxygenArray:(NSArray *)oxygenArray{
    if (_oxygenArray != oxygenArray)
    {
        _oxygenArray = oxygenArray;
        
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (_oxygenArray.count != 0)
    {
        long pointCount = _oxygenArray.count+1;
        NSMutableArray *pointArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < pointCount - 1; i ++)
        {
            float x =  i * 35 +30+15;
            float value = 0;
            
            value = [_oxygenArray[i] floatValue];
            
            float y = (99 - value) * self.height/10+(self.height/10)/2;
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

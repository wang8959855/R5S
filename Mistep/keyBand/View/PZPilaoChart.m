//
//  PZPilaoChart.m
//  Wukong
//
//  Created by 迈诺科技 on 16/5/13.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "PZPilaoChart.h"

#define kWidthx(x) self.width/23.0 * x

#define kHeight(x) self.height/100.0 * x

@implementation PZPilaoChart

- (void)setPilaoArray:(NSArray *)pilaoArray{
    if (pilaoArray) {
        _pilaoArray = pilaoArray;
        [self setNeedsDisplay];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        int age = [[HCHCommonManager getInstance] getPersonAge];
        int health = 25;
        int normal = 15;
        int danger = 5;
        if (age < 25)
        {
            health = 50;
            normal = 40;
            danger = 30;
        }else if (age < 35)
        {
            health = 45;
            normal = 35;
            danger = 20;
        }
        else if (age < 45)
        {
            health = 40;
            normal = 25;
            danger = 15;
        }
        else if (age < 55)
        {
            health = 35;
            normal = 20;
            danger = 10;
        }
        else if (age < 65)
        {
            health = 30;
            normal = 15;
            danger = 5;
        }
        float height = self.frame.size.height;
        
        NSArray *lineArray = @[[NSNumber numberWithInt:health],kColor(146, 208, 80),[NSNumber numberWithInt:normal],kColor(0, 176, 240),[NSNumber numberWithInt:danger],kColor(255, 16, 0)];
        NSArray *labelArray = @[NSLocalizedString(@"健康", nil),NSLocalizedString(@"正常", nil),NSLocalizedString(@"危险", nil),NSLocalizedString(@"高危", nil)];
        for (int i = 0 ; i < lineArray.count / 2; i ++)
        {
            int y = [lineArray[i * 2] intValue];
            CGPoint firstPoint = CGPointMake(32, (100-y)*height/100);
            CGPoint secondPoint = CGPointMake(CurrentDeviceWidth20, (100-y)*height/100);
            [self addDotLineWithFirstPoint:firstPoint SecondPoint:secondPoint LineColor:lineArray[i * 2 + 1]];
            if (i == 0)
            {
                UILabel *label = [[UILabel alloc] init];
                [self addSubview:label];
                label.text = labelArray[0];
                label.font = [UIFont systemFontOfSize:9];
                [label sizeToFit];
                label.textAlignment = NSTextAlignmentRight;
                label.frame = CGRectMake(CurrentDeviceWidth20 - label.width-3*WidthProportion, (100-y)*height/100-(self.height/100 * 10), label.width, (self.height/100 * 10));
                UILabel *label2 = [[UILabel alloc] init];
                [self addSubview:label2];
                label2.text = labelArray[1];
                label2.font = [UIFont systemFontOfSize:9];
                [label2 sizeToFit];
                label2.textAlignment = NSTextAlignmentRight;
                label2.frame = CGRectMake(CurrentDeviceWidth20 - label.width-3*WidthProportion, (100-y)*height/100, label2.width, (self.height/100 * 10) );
                //adaLog(@"%@",label2);
            }
            else
            {
                UILabel *label = [[UILabel alloc] init];
                [self addSubview:label];
                label.text = labelArray[i + 1];
                label.font = [UIFont systemFontOfSize:9];
                [label sizeToFit];
                label.textAlignment = NSTextAlignmentRight;
                label.frame = CGRectMake(CurrentDeviceWidth20 - label.width-3*WidthProportion, (100-y)*height/100, label.width, (self.height/100 * 10));
            }
        }
    }
    return self;
}

- (void)addDotLineWithFirstPoint:(CGPoint)firstPoint SecondPoint:(CGPoint)secondPoint LineColor:(UIColor *)color
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:CGPointMake(CurrentDeviceWidth/2.0, self.height/2.0)];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[color CGColor]];
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:0.5f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    // 3=线的宽度 1=每条线的间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:1],nil]];
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, firstPoint.x, firstPoint.y);
    CGPathAddLineToPoint(path, NULL, secondPoint.x,secondPoint.y);
    // Setup the path CGMutablePathRef path = CGPathCreateMutable(); // 0,10代表初始坐标的x，y
    // 320,10代表初始坐标的x，y
    //    CGPathMoveToPoint(path, NULL, 0, 10);
    //    CGPathAddLineToPoint(path, NULL, 320,10);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的
    [self.layer addSublayer:shapeLayer];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    if (_pilaoArray && _pilaoArray.count != 0)
    {
        for (int i = 0; i < _pilaoArray.count; i ++)
        {
            float first = [_pilaoArray[i] floatValue];
            if (first != 255)
            {
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSetRGBStrokeColor(context, 241/255.0, 130/255.0, 130/255.0, 1);

                int beginy = self.height/100 * (100 - 50);
                CGContextMoveToPoint(context, kWidthx(0), beginy);
                CGContextAddLineToPoint(context, kWidthx(i), self.height/100 * (100-first));
                CGContextStrokePath(context);
                break;
                
            }
        }
        
        for (int i = 0 ; i < _pilaoArray.count - 1; i ++)
        {
            float first = [_pilaoArray[i] floatValue];
            CGPoint firstPoint;
            CGPoint secondPoint;
            if (first != 255)
            {
                firstPoint = CGPointMake(kWidthx(i), self.height/100 * (100 - first));
                
                float second = [_pilaoArray[i + 1] floatValue];
                
                secondPoint = CGPointMake(kWidthx((i + 1)), self.height/100 * (100-second));
                for (int index = 1; second == 255; index ++)
                {
                    if (index >= _pilaoArray.count - i)
                    {
                        return;
                    }
                    second = [_pilaoArray[i + index] floatValue];
                    secondPoint = CGPointMake(kWidthx((i + index)), self.height/100 * (100-second));
                }
                
                UIBezierPath* path = [UIBezierPath bezierPath];
                [path setLineWidth:1];
                
                [path moveToPoint:firstPoint];
                [path addCurveToPoint:secondPoint controlPoint1:CGPointMake((secondPoint.x-firstPoint.x)/2+firstPoint.x, firstPoint.y) controlPoint2:CGPointMake((secondPoint.x-firstPoint.x)/2+firstPoint.x, secondPoint.y)];
                UIColor *lineColor = [UIColor colorWithRed:241/255.0 green:130/255.0 blue:130/255.0 alpha:1];
                [lineColor set];
                
                path.lineCapStyle = kCGLineCapRound;
                [path strokeWithBlendMode:kCGBlendModeNormal alpha:1];
                
            }

        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

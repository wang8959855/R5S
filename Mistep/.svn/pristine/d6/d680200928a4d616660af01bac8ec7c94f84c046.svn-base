//   iphone6  1.25  的width

//#define CurrentDeviceWidth  [UIScreen mainScreen].bounds.size.width
//#define CurrentDeviceHeight [UIScreen mainScreen].bounds.size.height
//#define WidthProportion  CurrentDeviceWidth / 375
//#define HeightProportion  CurrentDeviceHeight / 667


#import "ADAChart.h"

@interface ADAChart()

@property (nonatomic,strong) UIBezierPath* path;

@end
@implementation ADAChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        //[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];
        //
    }
    return self;
}
- (void)setHeartArray:(NSArray *)heartArray
{
    _heartArray = heartArray;
    self.frame = CGRectMake(0, 0, self.heartArray.count*1.25*WidthProportion + 30*WidthProportion, self.bounds.size.height);
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //adaLog(@"_heartArray.count - %ld",_heartArray.count);
    if (_heartArray.count != 0)
    {
        long pointCount = _heartArray.count;
        NSMutableArray *pointArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < pointCount; i ++)
        {
            float x = i * 1.25*WidthProportion+30*WidthProportion;
            float value = 0;
            value = [_heartArray[i] floatValue];
            //            for (int j = 0; j < 10; j ++)
            //            {
            //                //                if (value < [_heartArray[i *10 + j] floatValue])
            //                //                {
            //                if(value==0)
            //                {
            //                    value = [_heartArray[i *10 + j] floatValue];
            //                }
            //                //                }
            //            }
            
            float y = (220 - value) * (self.bounds.size.height-20*HeightProportion-70*HeightProportion)/220.0 + 70*HeightProportion;
            if (value != 0)
            {
                //adaLog(@"x= %f,y = %f",x,y);
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
            //            UIBezierPath*
            _path = [UIBezierPath bezierPath];
            [_path setLineWidth:1];
            
            [_path moveToPoint:firstPoint];
            [_path addCurveToPoint:secondPoint controlPoint1:CGPointMake((secondPoint.x-firstPoint.x)/2+firstPoint.x, firstPoint.y) controlPoint2:CGPointMake((secondPoint.x-firstPoint.x)/2+firstPoint.x, secondPoint.y)];
            UIColor *lineColor = [ColorTool getColor:@"0639f6"];
//            [UIColor colorWithRed:241/255.0 green:130/255.0 blue:130/255.0 alpha:1];
            [lineColor set];
            
            _path.lineCapStyle = kCGLineCapRound;
            [_path strokeWithBlendMode:kCGBlendModeNormal alpha:1];
        }
    }
    else
    {
        if (_path) {
            [_path removeAllPoints];
            _path = nil;
        }
        
    }
}

@end

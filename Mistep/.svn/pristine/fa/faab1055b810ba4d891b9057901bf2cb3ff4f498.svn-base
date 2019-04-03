

//#define CurrentDeviceWidth  [UIScreen mainScreen].bounds.size.width
//#define CurrentDeviceHeight [UIScreen mainScreen].bounds.size.height
//#define WidthProportion  CurrentDeviceWidth / 375
//#define HeightProportion  CurrentDeviceHeight / 667


#define radian(x) (x)* M_PI / 180 // 将度数转换为弧度
#define degrees(x) (x)* 180 / M_PI
#define du 360

#define COLORWITHGRAY  [UIColor grayColor]//
#define COLORWITHGREEN  [UIColor greenColor]//
#define COLORWITHYELLOW  [UIColor yellowColor]//
#define COLORWITHORANGE  [UIColor orangeColor]//
#define COLORWITHRED  [UIColor redColor]//

#define COLORWITHGRAY1  [ColorTool getColor:@"#afd48d"]//
#define COLORWITHGREEN1  [ColorTool getColor:@"7cc933"]//
#define COLORWITHYELLOW1  [ColorTool getColor:@"d9d100"]//
#define COLORWITHORANGE1  [ColorTool getColor:@"ff9000"]//
#define COLORWITHRED1  [ColorTool getColor:@"ff4200"]//

#import "SectorView.h"

@implementation SectorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _sectorArray = [NSArray array];
        _sectorArray = @[@1,@0,@0,@0,@0];
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (!_sectorArray)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context,COLORWITHGRAY1.CGColor);//填充颜色
        CGContextMoveToPoint(context,self.frame.size.width/2 , self.frame.size.height/2);
        CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2,self.frame.size.height/2-13*HeightProportion,0,M_PI*2, 0);
        CGContextFillPath(context);
        return;
    }
    if (_sectorArray.count>0)
    {
        if (_sectorArray.count==5)
        {
            int one = [_sectorArray[0] intValue];
            int two = [_sectorArray[1] intValue];
            int three = [_sectorArray[2] intValue];
            int si = [_sectorArray[3] intValue];
            int sive = [_sectorArray[4] intValue];
            if (one==0&&two==0&&three==0&&si==0&&sive==0)
            {
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSetFillColorWithColor(context,COLORWITHGRAY1.CGColor);//填充颜色
                CGContextMoveToPoint(context,self.frame.size.width/2 , self.frame.size.height/2);
                CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2,self.frame.size.height/2-13*HeightProportion,0,M_PI*2, 0);
                CGContextFillPath(context);
            }
        }
        
        
        
        CGFloat start = -90;
        CGFloat end = [_sectorArray[0] floatValue]*du+start;
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context,COLORWITHGRAY1.CGColor);//填充颜色
        CGContextMoveToPoint(context,self.frame.size.width/2 , self.frame.size.height/2);
        CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2,self.frame.size.height/2-13*HeightProportion,radian(start),radian(end), 0);
        CGContextFillPath(context);
        
        CGFloat start1 = end;
        CGFloat end1 = [_sectorArray[1] floatValue]*du+start1;
        CGContextSetFillColorWithColor(context,COLORWITHGREEN1.CGColor);//填充颜色
        CGContextMoveToPoint(context,self.frame.size.width/2 , self.frame.size.height/2);
        CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2,self.frame.size.height/2-13*HeightProportion,radian(start1),radian(end1), 0);
        CGContextFillPath(context);
        
        
        CGFloat start2 = end1;
        CGFloat end2 = [_sectorArray[2] floatValue]*du+start2;
        CGContextSetFillColorWithColor(context,COLORWITHYELLOW1.CGColor);//填充颜色
        CGContextMoveToPoint(context,self.frame.size.width/2 , self.frame.size.height/2);
        CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2,self.frame.size.height/2-13*HeightProportion,radian(start2),radian(end2), 0);
        CGContextFillPath(context);
        
        CGFloat start3 = end2;
        CGFloat end3 = [_sectorArray[3] floatValue]*du+start3;
        CGContextSetFillColorWithColor(context,COLORWITHORANGE1.CGColor);//填充颜色
        CGContextMoveToPoint(context,self.frame.size.width/2 , self.frame.size.height/2);
        CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2,self.frame.size.height/2-13*HeightProportion,radian(start3),radian(end3), 0);
        CGContextFillPath(context);
        
        CGFloat start4 = end3;
        CGFloat end4 = [_sectorArray[4] floatValue]*du+start4;
        CGContextSetFillColorWithColor(context,COLORWITHRED1.CGColor);//填充颜色
        CGContextMoveToPoint(context,self.frame.size.width/2 , self.frame.size.height/2);
        CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2,self.frame.size.height/2-13*HeightProportion,radian(start4),radian(end4), 0);
        CGContextFillPath(context);
        
        
    }
    else
    {
       
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context,COLORWITHGRAY1.CGColor);//填充颜色
        CGContextMoveToPoint(context,self.frame.size.width/2 , self.frame.size.height/2);
        CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2,self.frame.size.height/2-13*HeightProportion,0,M_PI*2, 0);
        CGContextFillPath(context);
    }
}
-(void)setSectorArray:(NSArray *)sectorArray
{
    //    if(sectorArray)
    //    {
    _sectorArray = sectorArray;
    //    }
    //    else
    //    {
    //        _sectorArray = @[@1,@0,@0,@0,@0];
    //    }
    // 2.通知自定义view重新绘制图形
    [self setNeedsDisplay];
}
@end

//
//  XueyaChartView.m
//  Mistep
//
//  Created by 迈诺科技 on 2016/10/20.
//  Copyright © 2016年 huichenghe. All rights reserved.
//
#define DeleteLabelTag   2000
#define fontColor [UIColor lightGrayColor]
//#define monthNumber    8
#import "XueyaChartView.h"
@interface XueyaChartView()
@property (nonatomic, strong) CAShapeLayer *lineChartLayer;
@property (nonatomic, assign) NSInteger times;
@property (nonatomic, strong) CAGradientLayer *shousuoyaLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end
@implementation XueyaChartView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.3];
//        [UIColor clearColor];
//        self.backgroundColor = [UIColor whiteColor];
//        _bounceX = 40;
//        _bounceY = 30;
//        [self createLabelX];
//        [self createLabelY];
       // [self drawGradientBackgroundView];
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    /*******画出坐标轴********/
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 2.0);
//    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
//    CGContextMoveToPoint(context,  _bounceX, _bounceY);
//    CGContextAddLineToPoint(context,  _bounceX, rect.size.height - _bounceY);
//    CGContextAddLineToPoint(context,rect.size.width - 20, rect.size.height - _bounceY);
//    [fontColor set];
//    CGContextStrokePath(context);
    
    [self dravLine];
}

#pragma mark 画折线图
- (void)dravLine{
    
    CGFloat downLineViewX = 0;
    CGFloat downLineViewY = self.height - 1 - 20 * HeightProportion;
    CGFloat downLineViewW = self.width;
    CGFloat downLineViewH = 1;
    UIView *downLineView = [[UIView alloc]initWithFrame:CGRectMake(downLineViewX, downLineViewY, downLineViewW, downLineViewH)];
    [self addSubview:downLineView];
    downLineView.backgroundColor = [UIColor grayColor];
    
    for(UIView *view in self.subviews)
    {
        if (view.tag == DeleteLabelTag)
        {
            [view removeFromSuperview];
        }
    }
//    UIView *view = (UIView*)[self viewWithTag:DeleteLabelTag];
    if (_chartArray.count > 0) {
        //舒张压
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _gradientLayer = gradientLayer;
        //        gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:22/255.0 green:224/255.0 blue:190/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithWhite:1 alpha:0.1].CGColor];
        //
        //        gradientLayer.locations=@[@0.0,@1.0];
        //        gradientLayer.startPoint = CGPointMake(0.0,0.0);
        //        gradientLayer.endPoint = CGPointMake(0.0,2);
        
        UIBezierPath * path = [[UIBezierPath alloc]init];
        path.lineWidth = 1.0;
        self.pathKuozhang = path;
        UIColor * color = color16e0be;
        [color set];
        NSDictionary *blood = _chartArray[0];
        
        CGFloat startY =self.height - ([blood[@"systolicPressure"] integerValue]  / 200.0 * self.height);
        CGFloat startX = 0;
        //        _shousuoLabel.text = dictionary[@"systolicPressure"];
        //        _shuzhangLabel.text = dictionary[@"diastolicPressure"];
        
        CGFloat startXMargin = self.width / 7;
        [path moveToPoint:CGPointMake(startX,startY)];
        //创建折现点标记
        for (NSInteger i = 0; i< _chartArray.count; i++) {
            
            NSDictionary *blood = _chartArray[i];
            startY = self.height - ([blood[@"systolicPressure"] integerValue]  / 200.0 * self.height);
            startX = startXMargin * ( i + 1 );
            [path addLineToPoint:CGPointMake(startX,startY)];
            
            CGFloat falglabelX = startX;
            CGFloat falglabelH = 10;
            CGFloat falglabelY = startY - falglabelH * 6 / 4;
            CGFloat falglabelW = 30;
            UILabel * falglabel = [[UILabel alloc]initWithFrame:CGRectMake(falglabelX,falglabelY,falglabelW,falglabelH)];
            falglabel.backgroundColor = [UIColor clearColor];
            //            falglabel.tag = 3000+ i;
            falglabel.text = blood[@"systolicPressure"];falglabel.textColor = color16e0be;
            falglabel.font = [UIFont systemFontOfSize:8.0];
            [self addSubview:falglabel];
            [falglabel adjustsFontSizeToFitWidth];
            falglabel.textAlignment = NSTextAlignmentCenter;
            falglabel.centerX = startX;
            falglabel.tag = DeleteLabelTag;
            
            CGFloat timesX = 0;
            CGFloat timesH = 10;
            CGFloat timesY = CGRectGetMaxY(downLineView.frame) + 1;
            CGFloat timesW = 30;
            UILabel * times = [[UILabel alloc]initWithFrame:CGRectMake(timesX,timesY,timesW,timesH)];
            times.backgroundColor = [UIColor clearColor];
            times.text = [NSString stringWithFormat:@"%2.0ld%@",i + 1,NSLocalizedString(@"次", nil)];
            times.font = [UIFont systemFontOfSize:12.0];
            [self addSubview:times];
            [times adjustsFontSizeToFitWidth];
            times.textAlignment = NSTextAlignmentCenter;
            times.centerX = falglabel.centerX;
            times.tag = DeleteLabelTag;
        }
        [path stroke];
        
        CAShapeLayer *arc = [CAShapeLayer layer];
        arc.path = path.CGPath;
        gradientLayer.mask = arc;
        [self.layer addSublayer:gradientLayer];
        
        
        
        /**
         *
         *收缩压
         *
         */
        CAGradientLayer *shousuoyaLayer = [CAGradientLayer layer];
        shousuoyaLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _shousuoyaLayer = shousuoyaLayer;
        //        shousuoyaLayer.colors = @[(__bridge id)[UIColor colorWithRed:57/255.0 green:186/255.0 blue:254/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithWhite:1 alpha:0.1].CGColor];
        //
        //        shousuoyaLayer.locations=@[@0.0,@1.0];
        //        shousuoyaLayer.startPoint = CGPointMake(0.0,0.0);
        //        shousuoyaLayer.endPoint = CGPointMake(0.0,1);
        //
        UIBezierPath * shousuoyapath = [[UIBezierPath alloc]init];
        shousuoyapath.lineWidth = 1.0;
        self.pathShousuo = shousuoyapath;
        UIColor * color1 = color39baff;
        [color1 set];
        CGFloat startX1 = 0;
        CGFloat startY1 = self.height - ([blood[@"diastolicPressure"] integerValue]  / 200.0 * self.height);
        [shousuoyapath moveToPoint:CGPointMake(startX1,startY1)];
        //创建折现点标记
        for (NSInteger i = 0; i< _chartArray.count; i++) {

            NSDictionary *blood = _chartArray[i];
            startY = self.height - ([blood[@"diastolicPressure"] integerValue]  / 200.0 * self.height);
            startX = startXMargin * ( i + 1 );
            [shousuoyapath addLineToPoint:CGPointMake(startX,startY)];
            
            CGFloat falglabelX = startX;
            CGFloat falglabelH = 10;
            CGFloat falglabelY = startY - falglabelH * 6 / 4;
            CGFloat falglabelW = 30;
            UILabel * falglabel = [[UILabel alloc]initWithFrame:CGRectMake(falglabelX,falglabelY,falglabelW,falglabelH)];
            falglabel.backgroundColor = [UIColor clearColor];
            falglabel.text = blood[@"diastolicPressure"];falglabel.textColor = color39baff;
            falglabel.font = [UIFont systemFontOfSize:8.0];
            [self addSubview:falglabel];
            [falglabel adjustsFontSizeToFitWidth];
            falglabel.textAlignment = NSTextAlignmentCenter;
            falglabel.centerX = startX;
            falglabel.tag = DeleteLabelTag;
        }
        [shousuoyapath stroke];
        
        CAShapeLayer *slow = [CAShapeLayer layer];
        slow.path = shousuoyapath.CGPath;
        shousuoyaLayer.mask = slow;
        [self.layer addSublayer:shousuoyaLayer];
    }
    else
    {
        self.shousuoyaLayer = [CAGradientLayer layer];
        self.gradientLayer = [CAGradientLayer layer];
        if (self.shousuoyaLayer)   [self.shousuoyaLayer removeFromSuperlayer];
        if (self.gradientLayer)    [self.gradientLayer removeFromSuperlayer];
    }
}
-(void)setChartArray:(NSArray *)chartArray
{
    _chartArray = chartArray;
    [self setNeedsDisplay];
}

//#pragma mark 创建x轴的数据
//- (void)createLabelX{
//    CGFloat  month = _chartArray.count;
//    
//    CGFloat  LabelMonthX = 0;
//    CGFloat  LabelMonthY = 0;
//    CGFloat  LabelMonthW = 0;
//    CGFloat  LabelMonthH = 0;
//    
//    for (NSInteger i = 0; i < month; i++) {
//        LabelMonthX =  (self.frame.size.width - 2* _bounceX)/month * i +  _bounceX;
//        LabelMonthY =  self.frame.size.height - _bounceY + _bounceY*0.3;
//        LabelMonthW =  (self.frame.size.width - 2* _bounceX)/month- 5;
//        LabelMonthH =  _bounceY/2;
//        
//        UILabel * LabelMonth = [[UILabel alloc]initWithFrame:CGRectMake(LabelMonthX, LabelMonthY, LabelMonthW, LabelMonthH)];
//        //       LabelMonth.backgroundColor = [UIColor greenColor];
//        LabelMonth.tag = 1000 + i;
//        LabelMonth.text = [NSString stringWithFormat:@"%ld次",i+1];
//        LabelMonth.textColor = fontColor;
//        LabelMonth.font = [UIFont systemFontOfSize:8];
//        //        LabelMonth.transform = CGAffineTransformMakeRotation(M_PI * 0.3);
//        [self addSubview:LabelMonth];
//    }
//    
//}
//#pragma mark 创建y轴数据
//- (void)createLabelY{
//    CGFloat Ydivision = 5;
//    for (NSInteger i = 0; i < Ydivision; i++) {
//        UILabel * labelYdivision = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.frame.size.height - 2 * _bounceY)/Ydivision *i + _bounceX, _bounceY, _bounceY/2.0)];
//        //   labelYdivision.backgroundColor = [UIColor greenColor];
//        labelYdivision.tag = 2000 + i;
//        labelYdivision.text = [NSString stringWithFormat:@"%.0f",(Ydivision - i)*20 +40];
//        labelYdivision.textAlignment = NSTextAlignmentRight;
//        labelYdivision.font = [UIFont systemFontOfSize:10];
//        labelYdivision.textColor = fontColor;
//        [self addSubview:labelYdivision];
//    }
//}



//-(void)setSystolicPressureArray:(NSArray *)systolicPressureArray
//{
//    _systolicPressureArray = systolicPressureArray;
//}
//
//-(void)diastolicPressureArray:(NSArray *)diastolicPressureArray
//{
//    _diastolicPressureArray = diastolicPressureArray;
//}

@end
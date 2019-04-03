////
////  ratioCircle.m
////  testUI
////
////  Created by 迈诺科技 on 2016/11/4.
////  Copyright © 2016年 huichenghe. All rights reserved.
////
//#define colorOne kColor(218,152,228)
//#define colorTwo kColor(1,158,232)
//#define colorThree kColor(74,144,226)
//#define colorFour kColor(83,199,251)
//#define colorFive kColor(18,225,234)
//#define colorBack kColor(230, 230, 230)//圆圈的背景
//
//#import "ratioCircle.h"
//@interface ratioCircle()
//
//@end
//
//@implementation ratioCircle
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        _start = - M_PI_2;
//        _circleWidth = 16;
//        _circleY = frame.size.height / 2;
//        _circleX = frame.size.width / 2;
//        _circleRadius = frame.size.height / 20 * 8 ;
//        _direction = 1;
//    }
//    return self;
//}
//
//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    
//    CGContextRef ctx =UIGraphicsGetCurrentContext();
//    if(self.ratioOne==0&&self.ratioTwo==0&&self.ratioThree==0&&self.ratioFour==0&&self.ratioFive==0)
//    {
//        
//        CGFloat ratioCircleStartOne = _start;
//        CGFloat ratioCircleEndOne = _start - M_PI * 2;
//        CGContextAddArc(ctx, _circleX,_circleY, _circleRadius,ratioCircleStartOne,ratioCircleEndOne, _direction);
//        CGContextSetLineWidth(ctx,_circleWidth);
//        CGContextSetLineCap(ctx,kCGLineCapRound);
//        CGContextSetStrokeColorWithColor(ctx, colorBack.CGColor);
//        CGContextStrokePath(ctx);
//        return;
//    }
//    
//    //第一结
//    CGFloat ratioCircleStartOne = _start;
//    CGFloat ratioCircleEndOne = _start - M_PI * 2 * _ratioOne;
//    CGContextAddArc(ctx, _circleX,_circleY, _circleRadius,ratioCircleStartOne,ratioCircleEndOne, _direction);
//    CGContextSetLineWidth(ctx,_circleWidth);
//    CGContextSetLineCap(ctx,kCGLineCapRound);
//    CGContextSetStrokeColorWithColor(ctx, colorOne.CGColor);
//    CGContextStrokePath(ctx);
//    
//    //第二结
//    CGFloat ratioCircleStartTwo = ratioCircleEndOne;
//    CGFloat ratioCircleEndTwo = ratioCircleEndOne - M_PI * 2 * _ratioTwo;
//    CGContextAddArc(ctx, _circleX,_circleY, _circleRadius,ratioCircleStartTwo,ratioCircleEndTwo, _direction);
//    CGContextSetLineWidth(ctx,_circleWidth);
//    CGContextSetLineCap(ctx,kCGLineCapRound);
//    CGContextSetStrokeColorWithColor(ctx, colorTwo.CGColor);
//    CGContextStrokePath(ctx);
//    
//    //第三结
//    CGFloat ratioCircleStartThree = ratioCircleEndTwo;
//    CGFloat ratioCircleEndThree = ratioCircleEndTwo - M_PI * 2 * _ratioThree;
//    CGContextAddArc(ctx, _circleX,_circleY, _circleRadius,ratioCircleStartThree,ratioCircleEndThree, _direction);
//    CGContextSetLineWidth(ctx,_circleWidth);
//    CGContextSetLineCap(ctx,kCGLineCapRound);
//    CGContextSetStrokeColorWithColor(ctx, colorThree.CGColor);
//    CGContextStrokePath(ctx);
//    
//    //第四结
//    CGFloat ratioCircleStartFour = ratioCircleEndThree;
//    CGFloat ratioCircleEndFour = ratioCircleEndThree - M_PI * 2 * _ratioFour;
//    CGContextAddArc(ctx, _circleX,_circleY, _circleRadius,ratioCircleStartFour,ratioCircleEndFour, _direction);
//    CGContextSetLineWidth(ctx,_circleWidth);
//    CGContextSetLineCap(ctx,kCGLineCapRound);
//    CGContextSetStrokeColorWithColor(ctx, colorFour.CGColor);
//    CGContextStrokePath(ctx);
//    
//    //第五结
//    CGFloat ratioCircleStartFive = ratioCircleEndFour;
//    CGFloat ratioCircleEndFive = ratioCircleEndFour - M_PI * 2 * _ratioFive;
//    CGContextAddArc(ctx, _circleX,_circleY, _circleRadius,ratioCircleStartFive,ratioCircleEndFive, _direction);
//    CGContextSetLineWidth(ctx,_circleWidth);
//    CGContextSetLineCap(ctx,kCGLineCapRound);
//    CGContextSetStrokeColorWithColor(ctx, colorFive.CGColor);
//    CGContextStrokePath(ctx);
//    
//    CGFloat margin = 0.001;
//    if (_ratioOne)
//    {
//        ratioCircleEndOne =  _start - margin;
//        CGContextAddArc(ctx, _circleX,_circleY, _circleRadius,ratioCircleStartOne,ratioCircleEndOne, _direction);
//        CGContextSetLineWidth(ctx,_circleWidth);
//        CGContextSetLineCap(ctx,kCGLineCapRound);
//        CGContextSetStrokeColorWithColor(ctx, colorOne.CGColor);
//        CGContextStrokePath(ctx);
//    }
//    else if (_ratioTwo)
//    {
//        CGFloat ratioCircleEndTwo = ratioCircleEndOne - margin;
//        CGContextAddArc(ctx, _circleX,_circleY, _circleRadius,ratioCircleStartTwo,ratioCircleEndTwo, _direction);
//        CGContextSetLineWidth(ctx,_circleWidth);
//        CGContextSetLineCap(ctx,kCGLineCapRound);
//        CGContextSetStrokeColorWithColor(ctx, colorTwo.CGColor);
//        CGContextStrokePath(ctx);
//    }
//    else if (_ratioThree)
//    {
//        CGFloat ratioCircleEndThree = ratioCircleEndTwo - margin;
//        CGContextAddArc(ctx, _circleX,_circleY, _circleRadius,ratioCircleStartThree,ratioCircleEndThree, _direction);
//        CGContextSetLineWidth(ctx,_circleWidth);
//        CGContextSetLineCap(ctx,kCGLineCapRound);
//        CGContextSetStrokeColorWithColor(ctx, colorThree.CGColor);
//        CGContextStrokePath(ctx);
//    }
//    else if (_ratioFour)
//    {
//        CGFloat ratioCircleEndFour = ratioCircleEndThree - margin;
//        CGContextAddArc(ctx, _circleX,_circleY, _circleRadius,ratioCircleStartFour,ratioCircleEndFour, _direction);
//        CGContextSetLineWidth(ctx,_circleWidth);
//        CGContextSetLineCap(ctx,kCGLineCapRound);
//        CGContextSetStrokeColorWithColor(ctx, colorFour.CGColor);
//        CGContextStrokePath(ctx);
//    }
//    else
//    {
//        CGFloat ratioCircleEndFive = ratioCircleEndFour - margin;
//        CGContextAddArc(ctx, _circleX,_circleY, _circleRadius,ratioCircleStartFive,ratioCircleEndFive, _direction);
//        CGContextSetLineWidth(ctx,_circleWidth);
//        CGContextSetLineCap(ctx,kCGLineCapRound);
//        CGContextSetStrokeColorWithColor(ctx, colorFive.CGColor);
//        CGContextStrokePath(ctx);
//        
//    }
//    
//}
//-(void)setRatioFive:(CGFloat)ratioFive
//{
//    _ratioFive = ratioFive;
//     [self setNeedsDisplay];
//}
//
//@end

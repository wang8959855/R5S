////
////  sport.m
////  testUI
////
////  Created by 迈诺科技 on 2016/11/2.
////  Copyright © 2016年 huichenghe. All rights reserved.
////
//
//#import "sportView.h"
//@interface sportView()
////@property (nonatomic, assign) CGFloat startAngle;//背景圆
////@property (nonatomic, assign) CGFloat endAngle;//背景圆
//@property (nonatomic, assign) CGFloat ArcX;
//@property (nonatomic, assign) CGFloat ArcY;
//@end
//@implementation sportView
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self  initData];
//    }
//    return self;
//}
//-(void)initData
//{
//    _lineWidth = 14;
//    _ringRadius = self.width * 9 / 10 /2;
//    _startAngle = M_PI * 3 / 4;
//    _endAngle = M_PI_4;
//    _progress = 0;
//    _minValue = 0;
//    _maxValue = 0;
//}
//-(void)setProgress:(NSInteger)progress
//{
//    CGFloat  temp = progress /_maxValue;
//    CGFloat  tempTT = M_PI * 2 -  _startAngle + _endAngle;
//    self.progressTT = _startAngle + temp * tempTT;
//    _progress = progress;
//}
//-(void)setProgressTT:(CGFloat)progressTT
//{
//    CGFloat TT = 2 * M_PI + M_PI / 4;
//    if(progressTT <= TT)
//        _progressTT = progressTT;
//    else
//        _progressTT = TT;
//    [self setNeedsDisplay];
//}
//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    
//    // 1.获得上下文
//    
//    CGContextRef ctx =UIGraphicsGetCurrentContext();
//    _ArcX = self.centerX;
//    _ArcY = self.centerY + 10;
//    CGContextAddArc(ctx,_ArcX,_ArcY, _ringRadius, _startAngle,_endAngle , 0);
//    CGContextSetLineWidth(ctx,_lineWidth);
//    CGContextSetLineCap(ctx,kCGLineCapRound);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithHexString:@"#30385d"].CGColor);
//    CGContextStrokePath(ctx);
//    
//    CGContextAddArc(ctx, _ArcX,_ArcY, _ringRadius, _startAngle,_progressTT , 0);
//    CGContextSetLineWidth(ctx,_lineWidth);
//    CGContextSetLineCap(ctx,kCGLineCapRound);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithHexString:@"#15ebf5"].CGColor);
//    CGContextStrokePath(ctx);
//    
//    
//    //    if (! self.dotImageView)
//    //    {
//    //        self.dotImageView = [[UIImageView alloc] init];
//    //        self.dotImageView.image = [UIImage imageNamed:@"Greenpoint"];
//    //        CGFloat dotImageViewWidth = 30;
//    //        CGFloat dotImageViewHeight = dotImageViewWidth;
//    //        self.dotImageView.size = CGSizeMake(dotImageViewWidth, dotImageViewHeight);
//    //        self.dotImageView.layer.cornerRadius = dotImageViewWidth / 2;
//    //        self.dotImageView.layer.masksToBounds = YES;
//    //       self.dotImageView.center = CGPointMake(self.frame.size.width/2., self.frame.size.height/2.);
//    //        [self addSubview:self.dotImageView];
//    //    }
//    //    self.dotImageView.frame = [self getEndPointFrameWithProgress:1.1];
//}
////更新小点的位置
//-(CGRect)getEndPointFrameWithProgress:(float)progress
//{
//    CGFloat useTT;
//    if (_progressTT < 2 * M_PI)
//        useTT= _progressTT;
//    else
//        useTT = _progressTT - 2 * M_PI;
//    
//    int index = (useTT)/M_PI_2 + 1;//用户区分在第几象限内
//    float needAngle = index*M_PI_2 - useTT;//用于计算正弦/余弦的角度
//    float x = 0,y = 0;//用于保存_dotView的frame
//    switch (index) {
//        case 1:
//            //adaLog(@"第一象限");
//            y = _ringRadius + sinf(needAngle)*_ringRadius;
//            x = _ringRadius + cosf(needAngle)*_ringRadius;
//            break;
//        case 2:
//            //adaLog(@"第二象限");
//            x = _ringRadius + cosf(needAngle)*_ringRadius;
//            y = _ringRadius + sinf(needAngle)*_ringRadius;
//            break;
//        case 3:
//            //adaLog(@"第三象限");
//            x = _ringRadius - sinf(needAngle)*_ringRadius;
//            y = _ringRadius + cosf(needAngle)*_ringRadius;
//            break;
//        case 4:
//            //adaLog(@"第四象限");
//            
//            x = _ringRadius + cosf(needAngle)*_ringRadius;
//            y = _ringRadius - sinf(needAngle)*_ringRadius;
//            break;
//        default:
//            break;
//    }
//    //为了让圆圈的中心和圆环的中心重合
//    //    x -= (_dotImageView.bounds.size.width/2.0f - _lineWidth/2.0f);
//    //    y -= (_dotImageView.bounds.size.width/2.0f - _lineWidth/2.0f);
//    //更新圆环的frame
//    CGRect rect = _dotImageView.frame;
//    rect.origin.x = x;
//    rect.origin.y = y;
//    return  rect;
//}
//@end

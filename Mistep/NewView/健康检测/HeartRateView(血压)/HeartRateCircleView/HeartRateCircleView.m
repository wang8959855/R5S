//
//  HeartRateCircleView.m
//  Wukong
//
//  Created by apple on 2018/5/21.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "HeartRateCircleView.h"

#define kDefaultStartAngle                      M_PI_4 * 3
#define kDefaultEndAngle                        M_PI_4
#define kDefaultMinValue                        0
#define kDefaultMaxValue                        220
#define kDefaultLimitValue                      50
#define kDefaultNumOfDivisions                  6
#define kDefaultNumOfSubDivisions               10

#define kDefaultRingThickness                   15
#define kDefaultRingBackgroundColor             [UIColor colorWithWhite:0.9 alpha:1]
#define kDefaultRingColor                       [UIColor colorWithRed:76.0/255 green:217.0/255 blue:100.0/255 alpha:1]

#define kDefaultDivisionsRadius                 1.25
#define kDefaultDivisionsColor                  [UIColor colorWithWhite:0.5 alpha:1]
#define kDefaultDivisionsPadding                12

#define kDefaultSubDivisionsRadius              0.75
#define kDefaultSubDivisionsColor               [UIColor colorWithWhite:0.5 alpha:0.5]

#define kDefaultLimitDotRadius                  2
#define kDefaultLimitDotColor                   [UIColor redColor]

#define kDefaultValueFont                       [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:150]
#define kDefaultValueTextColor                  [UIColor colorWithWhite:0.1 alpha:1]

#define kDefaultUnitOfMeasurement               @"km/h"
#define kDefaultUnitOfMeasurementFont           [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16]
#define kDefaultUnitOfMeasurementTextColor      [UIColor colorWithWhite:0.3 alpha:1]

@interface HeartRateCircleView ()

// For calculation
@property (nonatomic, assign) CGFloat divisionUnitAngle;
@property (nonatomic, assign) CGFloat divisionUnitValue;

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) CAShapeLayer *backProgressLayer;

@property (nonatomic, strong) UILabel *valueLabel;

@property (nonatomic, strong) UIImageView *sleepImageView;


@property (nonatomic, strong) UILabel *numlabel;//220
@property (nonatomic, strong) UILabel *num1label;//40
@property (nonatomic, strong) UILabel *num2label;//60
@property (nonatomic, strong) UILabel *num3label;//90
@property (nonatomic, strong) UILabel *num4label;//120
@property (nonatomic, strong) UILabel *num5label;//150

//记录上一次心率
@property (nonatomic, assign) CGFloat lastHr;

@end

@implementation HeartRateCircleView

#pragma mark - INIT

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    if (!self.backgroundColor) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    // Set default values
    _startAngle = kDefaultStartAngle;
    _endAngle = kDefaultEndAngle;
    
    _value = kDefaultMinValue;
    _minValue = kDefaultMinValue;
    _maxValue = kDefaultMaxValue;
    _limitValue = kDefaultLimitValue;
    //    _numOfDivisions = kDefaultNumOfDivisions;
    //    _numOfSubDivisions = kDefaultNumOfSubDivisions;
    
    // Ring
    _ringThickness = kDefaultRingThickness;
    _ringBackgroundColor = kDefaultRingBackgroundColor;
    
    // Divisions
    _divisionsRadius = kDefaultDivisionsRadius;
    _divisionsColor = kDefaultDivisionsColor;
    _divisionsPadding = kDefaultDivisionsPadding;
    
    // Subdivisions
    _subDivisionsRadius = kDefaultSubDivisionsRadius;
    _subDivisionsColor = kDefaultSubDivisionsColor;
    
    // Limit dot
    _showLimitDot = YES;
    _limitDotRadius = kDefaultLimitDotRadius;
    _limitDotColor = kDefaultLimitDotColor;
    
    // Value Text
    _valueFont = kDefaultValueFont;
    _valueTextColor = kDefaultValueTextColor;
    
    // Unit Of Measurement
    _showUnitOfMeasurement = YES;
    _unitOfMeasurement = kDefaultUnitOfMeasurement;
    _unitOfMeasurementFont = kDefaultUnitOfMeasurementFont;
    _unitOfMeasurementTextColor = kDefaultUnitOfMeasurementTextColor;
    
}


#pragma mark - ANIMATION

- (void)strokeGauge
{
    /*!
     *  Set progress for ring layer
     */
    CGFloat progress ;
    
    if (!self.maxValue)
    {
        progress = 0;
    }else
    {
        CGFloat com = (self.value - self.minValue)/(self.maxValue - self.minValue);
        if (com > 1)
        {
            progress = 1;
        }
        else
        {
            progress = com;
        }
    }
    
    self.progressLayer.strokeEnd = progress;
    self.backProgressLayer.strokeEnd = progress;
    /*!
     *  Set ring stroke color
     */
    //    UIColor *ringColor = kDefaultRingColor;
    
    //    if (self.delegate && [self.delegate respondsToSelector:@selector(gaugeView:ringStokeColorForValue:)]) {
    //        ringColor = [self.delegate gaugeView:self ringStokeColorForValue:self.value];
    //    }
    //    self.progressLayer.strokeColor = ringColor.CGColor;
    
    [self.gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    
}


#pragma mark - CUSTOM DRAWING

- (void)drawRect:(CGRect)rect
{
    /*!
     *  Prepare drawing
     */
    //    self.divisionUnitValue = self.numOfDivisions ? (self.maxValue - self.minValue)/self.numOfDivisions : 0;
    //    self.divisionUnitAngle = self.numOfDivisions ? (M_PI * 2 - ABS(self.endAngle - self.startAngle))/self.numOfDivisions : 0;
    
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    CGFloat ringRadius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))/2 - self.ringThickness/2;
    //    CGFloat dotRadius = ringRadius - self.ringThickness/2 - self.divisionsPadding - self.divisionsRadius/2;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*!
     *  Draw the ring background
     */
    CGContextSetLineWidth(context, self.ringThickness);
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, ringRadius, 0, M_PI * 2, 0);
    CGContextSetStrokeColorWithColor(context, [self.ringBackgroundColor colorWithAlphaComponent:1].CGColor);
    CGContextStrokePath(context);
    
    /*!
     *  Draw the ring progress background
     */
    CGContextSetLineWidth(context, self.ringThickness);
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, ringRadius, self.startAngle, self.endAngle, 0);
    CGContextSetStrokeColorWithColor(context, kColor(244, 70, 73).CGColor);
    CGContextStrokePath(context);
    
    CGContextSetLineWidth(context, self.ringThickness);
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, ringRadius, -M_PI_4/1.5, M_PI/1.6, 0);
    CGContextSetStrokeColorWithColor(context, kColor(253, 183, 45).CGColor);
    CGContextStrokePath(context);
    
    CGContextSetLineWidth(context, self.ringThickness);
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, ringRadius, M_PI_4/9, M_PI_2/1.5, 0);
    CGContextSetStrokeColorWithColor(context, kColor(26, 160, 229).CGColor);
    CGContextStrokePath(context);
    
    //
    //    [path stroke];
    /*!
     *  Draw divisions and subdivisions
     */
    
    
    /*!
     *  Draw the limit dot
     */
    
    
    /*!
     *  Progress Layer
     */
    
    if (!self.backProgressLayer)
    {
        self.backProgressLayer = [CAShapeLayer layer];
        self.backProgressLayer.contentsScale = [[UIScreen mainScreen] scale];
        self.backProgressLayer.fillColor = [UIColor clearColor].CGColor;
        self.backProgressLayer.lineCap = kCALineJoinRound;
        self.backProgressLayer.lineJoin = kCALineJoinRound;
        self.backProgressLayer.strokeColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:self.backProgressLayer];
        self.backProgressLayer.strokeEnd = 0;
    }
    
    if (!self.progressLayer)
    {
        self.progressLayer = [CAShapeLayer layer];
        self.progressLayer.contentsScale = [[UIScreen mainScreen] scale];
        self.progressLayer.fillColor = [UIColor clearColor].CGColor;
        self.progressLayer.lineCap = kCALineJoinRound;
        self.progressLayer.lineJoin = kCALineJoinRound;
        self.progressLayer.strokeColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:self.progressLayer];
        self.progressLayer.strokeEnd = 0;
    }
    
    self.backProgressLayer.frame = CGRectMake(center.x - ringRadius - self.ringThickness/2,
                                              center.y - ringRadius - self.ringThickness/2,
                                              (ringRadius + self.ringThickness/2) * 2,
                                              (ringRadius + self.ringThickness/2) * 2);
    self.backProgressLayer.bounds = self.backProgressLayer.frame;
    
    self.progressLayer.frame = CGRectMake(center.x - ringRadius - self.ringThickness/2,
                                          center.y - ringRadius - self.ringThickness/2,
                                          (ringRadius + self.ringThickness/2) * 2,
                                          (ringRadius + self.ringThickness/2) * 2);
    self.progressLayer.bounds = self.progressLayer.frame;
    
    
    
    UIBezierPath *smoothedPath = [UIBezierPath bezierPathWithArcCenter:self.progressLayer.position
                                                                radius:ringRadius
                                                            startAngle:self.startAngle
                                                              endAngle:self.endAngle
                                                             clockwise:YES];
    self.backProgressLayer.path = smoothedPath.CGPath;
    self.backProgressLayer.lineWidth = self.ringThickness;
    
    self.progressLayer.path = smoothedPath.CGPath;
    self.progressLayer.lineWidth = self.ringThickness;
    
    
    
    
    
    if (!self.sleepImageView) {
        self.sleepImageView = [[UIImageView alloc] init];
        self.sleepImageView.image = [UIImage imageNamed:@"redHeart"];
        self.sleepImageView.size = CGSizeMake(35, 30);
        self.sleepImageView.center = CGPointMake(self.width/2., self.height/2.-40);
        [self addSubview:self.sleepImageView];
    }
    
    //数字的label
    //220
    if (!self.numlabel) {
        self.numlabel = [[UILabel alloc] init];
        self.numlabel.text = @"220";
        self.numlabel.font = [UIFont systemFontOfSize:15];
        self.numlabel.textColor = allColorWhite;
        self.numlabel.textAlignment = NSTextAlignmentCenter;
        self.numlabel.size = CGSizeMake(50, 20);
        self.numlabel.center = CGPointMake(self.width/2., -15);
        [self addSubview:self.numlabel];
    }
    //40
    if (!self.num1label) {
        self.num1label = [[UILabel alloc] init];
        self.num1label.text = @"40";
        self.num1label.font = [UIFont systemFontOfSize:15];
        self.num1label.textColor = allColorWhite;
        self.num1label.textAlignment = NSTextAlignmentCenter;
        self.num1label.size = CGSizeMake(50, 20);
        self.num1label.center = CGPointMake(self.width, self.height/2.-60);
        [self addSubview:self.num1label];
    }
    //55
    if (!self.num2label) {
        self.num2label = [[UILabel alloc] init];
        self.num2label.text = @"55";
        self.num2label.font = [UIFont systemFontOfSize:15];
        self.num2label.textColor = allColorWhite;
        self.num2label.textAlignment = NSTextAlignmentCenter;
        self.num2label.size = CGSizeMake(50, 20);
        self.num2label.center = CGPointMake(self.width+12, self.height/2.+13);
        [self addSubview:self.num2label];
    }
    //90
    if (!self.num3label) {
        self.num3label = [[UILabel alloc] init];
        self.num3label.text = @"90";
        self.num3label.font = [UIFont systemFontOfSize:15];
        self.num3label.textColor = allColorWhite;
        self.num3label.textAlignment = NSTextAlignmentCenter;
        self.num3label.size = CGSizeMake(50, 20);
        self.num3label.center = CGPointMake(self.width-48, self.height-3);
        [self addSubview:self.num3label];
    }
    //120
    if (!self.num4label) {
        self.num4label = [[UILabel alloc] init];
        self.num4label.text = @"120";
        self.num4label.font = [UIFont systemFontOfSize:15];
        self.num4label.textColor = allColorWhite;
        self.num4label.textAlignment = NSTextAlignmentCenter;
        self.num4label.size = CGSizeMake(50, 20);
        self.num4label.center = CGPointMake(self.width/2-54, self.height+2);
        [self addSubview:self.num4label];
    }
    //150
    if (!self.num5label) {
        self.num5label = [[UILabel alloc] init];
        self.num5label.text = @"150";
        self.num5label.font = [UIFont systemFontOfSize:15];
        self.num5label.textColor = allColorWhite;
        self.num5label.textAlignment = NSTextAlignmentCenter;
        self.num5label.size = CGSizeMake(50, 20);
        self.num5label.center = CGPointMake(-15, self.height/2.0);
        [self addSubview:self.num5label];
    }
    
    
    /*!
     *  Value Label
     */
    if (!self.valueLabel)
    {
        self.valueLabel = [[UILabel alloc] init];
        self.valueLabel.backgroundColor = [UIColor clearColor];
        self.valueLabel.textAlignment = NSTextAlignmentCenter;
        
        NSMutableAttributedString *string = [self makeAttributedStringWithnumBer:@"0" Unit:NSLocalizedString(@"次/分", nil) WithFont:35];
        self.valueLabel.font = self.valueFont;
        self.valueLabel.minimumScaleFactor = 10/self.valueLabel.font.pointSize;
        self.valueLabel.textColor = self.valueTextColor;
        [self addSubview:self.valueLabel];
        self.valueLabel.size = CGSizeMake(self.width - 2 * self.ringThickness, 40);
        self.valueLabel.center = CGPointMake(self.width/2., self.height/2.);
        self.valueLabel.attributedText = string;
    }
    //    完成度Label
    if (!self.comLabel)
    {
        self.comLabel = [[UILabel alloc] init];
        self.comLabel.text = NSLocalizedString(@"实时心率", nil);
        self.comLabel.textAlignment = NSTextAlignmentCenter;
        self.comLabel.frame = CGRectMake(0, self.valueLabel.bottom + 11*kDY, self.width, 20 * kDY);
        self.comLabel.font = Font_Normal_String(14);
        self.comLabel.textColor = kMainColor;
        [self addSubview:self.comLabel];
    }
    
    
    /*!
     *  Unit Of Measurement Label
     */
    
    if (!self.gradientLayer)
    {
        self.gradientLayer = [CALayer layer];
        
        CAGradientLayer *gradientLayer1 =  [CAGradientLayer layer];
        gradientLayer1.frame = CGRectMake(0, 0, self.width/2, self.height);
        [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],(id)[[UIColor clearColor] CGColor], nil]];
        [gradientLayer1 setLocations:@[@0.5]];
        [gradientLayer1 setStartPoint:CGPointMake(0.5, 1)];
        [gradientLayer1 setEndPoint:CGPointMake(0.5, 0)];
        [self.gradientLayer addSublayer:gradientLayer1];
        
        CAGradientLayer *gradientLayer2 =  [CAGradientLayer layer];
        [gradientLayer2 setLocations:@[@0.5]];
        gradientLayer2.frame = CGRectMake(self.width/2, 0, self.width/2, self.height);
        [gradientLayer2 setColors:[NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],(id)[[UIColor clearColor] CGColor], nil]];
        [gradientLayer2 setStartPoint:CGPointMake(0.5, 0)];
        [gradientLayer2 setEndPoint:CGPointMake(0.5, 1)];
        [self.gradientLayer addSublayer:gradientLayer2];
        [self.gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
        [self.layer addSublayer:self.gradientLayer];
        
    }
    
    if (! self.dotView)
    {
        self.dotView = [[UIView alloc] initWithFrame:CGRectMake(self.width/2 - self.ringThickness/2., 0, self.ringThickness ,self.ringThickness)];
        self.dotView.backgroundColor = kColor(244, 70, 73);
        self.dotView.layer.cornerRadius = self.dotView.width/2.;
        [self addSubview:self.dotView];
    }
    
    if (! self.dotImageView)
    {
        self.dotImageView = [[UIImageView alloc] init];
        self.dotImageView.backgroundColor = allColorWhite
        self.dotImageView.frame = CGRectMake(self.width/2 - self.ringThickness/2., 0, self.ringThickness ,self.ringThickness);
        self.dotImageView.layer.cornerRadius = self.ringThickness/2;
        self.dotImageView.layer.masksToBounds = YES;
        [self addSubview:self.dotImageView];
    }
    
}

- (NSMutableAttributedString *)makeAttributedStringWithnumBer:(NSString *)number Unit:(NSString *)unit WithFont:(int)font
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:number];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, attributeString.length)];
    NSMutableAttributedString *unitString = [[NSMutableAttributedString alloc] initWithString:unit];
    [unitString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font - 5] range:NSMakeRange(0, unitString.length)];
    [attributeString appendAttributedString:unitString];
    return attributeString;
}

#pragma mark - SUPPORT

- (CGFloat)angleFromValue:(CGFloat)value
{
    CGFloat level = self.divisionUnitValue ? (value - self.minValue)/self.divisionUnitValue : 0;
    CGFloat angle = level * self.divisionUnitAngle + self.startAngle;
    return angle;
}

- (void)drawDotAtContext:(CGContextRef)context
                  center:(CGPoint)center
                  radius:(CGFloat)radius
               fillColor:(CGColorRef)fillColor
{
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, radius, 0, M_PI * 2, 0);
    CGContextSetFillColorWithColor(context, fillColor);
    CGContextFillPath(context);
}


#pragma mark - PROPERTIES


- (void)setMaxValue:(CGFloat)maxValue
{
    if (_maxValue != maxValue && maxValue > _minValue) {
        _maxValue = maxValue;
        [self setNeedsDisplay];
        float com = (100 * self.value/_maxValue);
        self.comLabel.text = [NSString stringWithFormat:@"%@ %d%%",kLOCAL(@"完成度"),(int)com];
        
        float maxCom = MIN(com, 100);
        int x = self.width/2. + (self.height/2. - self.ringThickness/2.) *cos((maxCom/100.f + 0.75) *M_PI * 2);//括号内为弧度值
        int y = self.width/2. + (self.height/2. - self.ringThickness/2.) *sin((maxCom/100.f + 0.75) *M_PI * 2);
        self.dotImageView.center = CGPointMake(x, y);
    }
}


- (void)setValue:(CGFloat)value {
    
    if (self.lastHr == 0 && value == 0) {
        //黄色
        self.valueLabel.textColor = kColor(253, 183, 45);
        self.sleepImageView.image = [UIImage imageNamed:@"yellowHeart"];
        self.valueLabel.attributedText = [self makeAttributedStringWithnumBer:kLOCAL(@"异常") Unit:@"" WithFont:30];
        
        return;
    }
    if (self.lastHr != 0 && value == 0) {
        if (self.lastHr >= 40 && self.lastHr < 55) {
            //黄色
            self.valueLabel.textColor = kColor(253, 183, 45);
            self.sleepImageView.image = [UIImage imageNamed:@"yellowHeart"];
            self.valueLabel.attributedText = [self makeAttributedStringWithnumBer:kLOCAL(@"异常") Unit:@"" WithFont:30];
            [self.valueLabel adjustsFontSizeToFitWidth];
        }else if (self.lastHr >= 55 && self.lastHr < 90){
            //蓝色
            self.valueLabel.textColor = kColor(26, 160, 229);
            self.sleepImageView.image = [UIImage imageNamed:@"heart"];
            self.valueLabel.attributedText = [self makeAttributedStringWithnumBer:kLOCAL(@"正常") Unit:@"" WithFont:30];
            [self.valueLabel adjustsFontSizeToFitWidth];
        }else if (self.lastHr >= 90 && self.lastHr < 120){
            //黄色
            self.valueLabel.textColor = kColor(253, 183, 45);
            self.sleepImageView.image = [UIImage imageNamed:@"yellowHeart"];
            self.valueLabel.attributedText = [self makeAttributedStringWithnumBer:kLOCAL(@"异常") Unit:@"" WithFont:30];
            [self.valueLabel adjustsFontSizeToFitWidth];
        }else{
            //红色
            self.valueLabel.textColor = kColor(244, 70, 73);
            self.sleepImageView.image = [UIImage imageNamed:@"redHeart"];
            self.valueLabel.attributedText = [self makeAttributedStringWithnumBer:kLOCAL(@"风险") Unit:@"" WithFont:30];
            [self.valueLabel adjustsFontSizeToFitWidth];
        }
    }else{
        if (value >= 40 && value < 55) {
            //黄色
            self.valueLabel.textColor = kColor(253, 183, 45);
            self.sleepImageView.image = [UIImage imageNamed:@"yellowHeart"];
        }else if (value >= 55 && value < 90){
            //蓝色
            self.valueLabel.textColor = kColor(26, 160, 229);
            self.sleepImageView.image = [UIImage imageNamed:@"heart"];
        }else if (value >= 90 && value < 120){
            //黄色
            self.valueLabel.textColor = kColor(253, 183, 45);
            self.sleepImageView.image = [UIImage imageNamed:@"yellowHeart"];
        }else{
            //红色
            self.valueLabel.textColor = kColor(244, 70, 73);
            self.sleepImageView.image = [UIImage imageNamed:@"redHeart"];
        }
        NSMutableAttributedString *string = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%.f",value] Unit:kLOCAL(@"次/分") WithFont:35];
        self.valueLabel.attributedText = string;
        
        self.lastHr = value;
    }
    
    
    float com = (100 * value/_maxValue);
    
    float maxCom = MIN(com, 100);
    
    int x = self.width/2. + (self.height/2. - self.ringThickness/2.) *cos((maxCom/100.f + 0.75) *M_PI * 2);//括号内为弧度值
    int y = self.width/2. + (self.height/2. - self.ringThickness/2.) *sin((maxCom/100.f + 0.75) *M_PI * 2);
    self.dotImageView.center = CGPointMake(x, y);
    
    _value = value;
    _value = MAX(_value, _minValue);
    
    /*!
     *  Set text for value label
     */
    
    /*!
     *  Trigger the stoke animation of ring layer.
     */
    
    [self strokeGauge];
}

- (void)setMinValue:(CGFloat)minValue
{
    if (_minValue != minValue && minValue < _maxValue) {
        _minValue = minValue;
        
        [self setNeedsDisplay];
    }
}


- (void)setLimitValue:(CGFloat)limitValue
{
    if (_limitValue != limitValue && limitValue >= _minValue && limitValue <= _maxValue) {
        _limitValue = limitValue;
        
        [self setNeedsDisplay];
    }
}


- (void)setRingThickness:(CGFloat)ringThickness
{
    if (_ringThickness != ringThickness) {
        _ringThickness = ringThickness;
        
        [self setNeedsDisplay];
    }
}

- (void)setRingBackgroundColor:(UIColor *)ringBackgroundColor
{
    if (_ringBackgroundColor != ringBackgroundColor) {
        _ringBackgroundColor = ringBackgroundColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setDivisionsRadius:(CGFloat)divisionsRadius
{
    if (_divisionsRadius != divisionsRadius) {
        _divisionsRadius = divisionsRadius;
        
        [self setNeedsDisplay];
    }
}

- (void)setDivisionsColor:(UIColor *)divisionsColor
{
    if (_divisionsColor != divisionsColor) {
        _divisionsColor = divisionsColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setDivisionsPadding:(CGFloat)divisionsPadding
{
    if (_divisionsPadding != divisionsPadding) {
        _divisionsPadding = divisionsPadding;
        
        [self setNeedsDisplay];
    }
}

- (void)setSubDivisionsRadius:(CGFloat)subDivisionsRadius
{
    if (_subDivisionsRadius != subDivisionsRadius) {
        _subDivisionsRadius = subDivisionsRadius;
        
        [self setNeedsDisplay];
    }
}

- (void)setSubDivisionsColor:(UIColor *)subDivisionsColor
{
    if (_subDivisionsColor != subDivisionsColor) {
        _subDivisionsColor = subDivisionsColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setShowLimitDot:(BOOL)showLimitDot
{
    if (_showLimitDot != showLimitDot) {
        _showLimitDot = showLimitDot;
        
        [self setNeedsDisplay];
    }
}

- (void)setLimitDotRadius:(CGFloat)limitDotRadius
{
    if (_limitDotRadius != limitDotRadius) {
        _limitDotRadius = limitDotRadius;
        
        [self setNeedsDisplay];
    }
}

- (void)setLimitDotColor:(UIColor *)limitDotColor
{
    if (_limitDotColor != limitDotColor) {
        _limitDotColor = limitDotColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setValueFont:(UIFont *)valueFont
{
    if (_valueFont != valueFont) {
        _valueFont = valueFont;
        
        self.valueLabel.font = _valueFont;
        self.valueLabel.minimumScaleFactor = 10/_valueFont.pointSize;
    }
}

- (void)setValueTextColor:(UIColor *)valueTextColor
{
    if (_valueTextColor != valueTextColor) {
        _valueTextColor = valueTextColor;
        
        self.valueLabel.textColor = _valueTextColor;
    }
}

- (void)setShowUnitOfMeasurement:(BOOL)showUnitOfMeasurement
{
    if (_showUnitOfMeasurement != showUnitOfMeasurement) {
        _showUnitOfMeasurement = showUnitOfMeasurement;
        
    }
}

- (void)setUnitOfMeasurement:(NSString *)unitOfMeasurement
{
    if (_unitOfMeasurement != unitOfMeasurement) {
        _unitOfMeasurement = unitOfMeasurement;
        
    }
}

- (void)setUnitOfMeasurementFont:(UIFont *)unitOfMeasurementFont
{
    if (_unitOfMeasurementFont != unitOfMeasurementFont) {
        _unitOfMeasurementFont = unitOfMeasurementFont;
    }
}

- (void)setUnitOfMeasurementTextColor:(UIColor *)unitOfMeasurementTextColor
{
    if (_unitOfMeasurementTextColor != unitOfMeasurementTextColor) {
        _unitOfMeasurementTextColor = unitOfMeasurementTextColor;
    }
}

@end


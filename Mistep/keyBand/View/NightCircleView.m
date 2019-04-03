//
//  LMGaugeView.m
//  LMGaugeView
//
//  Created by LMinh on 01/08/2014.
//  Copyright (c) 2014 LMinh. All rights reserved.
//

#import "NightCircleView.h"

#define kDefaultStartAngle                      M_PI_4 * 3
#define kDefaultEndAngle                        M_PI_4
#define kDefaultMinValue                        0
#define kDefaultMaxValue                        120
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

@interface NightCircleView ()

// For calculation
@property (nonatomic, assign) CGFloat divisionUnitAngle;
@property (nonatomic, assign) CGFloat divisionUnitValue;

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) CAShapeLayer *backProgressLayer;

@property (nonatomic, strong) UILabel *valueLabel;

@property (nonatomic, strong) UIImageView *sleepImageView;

@end

@implementation NightCircleView

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
    CGContextSetStrokeColorWithColor(context, kColor(225, 225, 225).CGColor);
    CGContextStrokePath(context);
    
    /*!
     *  Draw the ring progress background
     */
    CGContextSetLineWidth(context, self.ringThickness);
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, ringRadius, self.startAngle, self.endAngle, 0);
    CGContextSetStrokeColorWithColor(context, self.ringBackgroundColor.CGColor);
    CGContextStrokePath(context);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.ringThickness, self.ringThickness,self.width - 2 * self.ringThickness , self.width - 2* self.ringThickness)];
    UIColor *fillColor = kMainColor;
    [fillColor set];
    [path fill];
    
    [path stroke];
    

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
        self.backProgressLayer.strokeColor = kMainColor.CGColor;
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
        self.sleepImageView.image = [UIImage imageNamed:@"sleep"];
        self.sleepImageView.size = CGSizeMake(34, 33);
        self.sleepImageView.center = CGPointMake(self.width/2., self.height/2.-40);
        [self addSubview:self.sleepImageView];
    }
    
    /*!
     *  Value Label
     */
    if (!self.valueLabel)
    {
        self.valueLabel = [[UILabel alloc] init];
        self.valueLabel.backgroundColor = [UIColor clearColor];
        self.valueLabel.textAlignment = NSTextAlignmentCenter;
        
        NSMutableAttributedString *string = [self makeAttributedStringWithnumBer:@"0" Unit:@"h" WithFont:35];
        [string appendAttributedString:[self makeAttributedStringWithnumBer:@"0" Unit:@"min" WithFont:35]];
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
        self.comLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"完成度",nil),@"0%"];
        self.comLabel.textAlignment = NSTextAlignmentCenter;
        self.comLabel.frame = CGRectMake(0, self.valueLabel.bottom + 11*kDY, self.width, 20 * kDY);
        self.comLabel.font = Font_Normal_String(14);
        self.comLabel.textColor = [UIColor whiteColor];
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
        [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)kColor(0, 160, 233).CGColor,(id)kColor(0, 160, 233).CGColor, nil]];
        [gradientLayer1 setLocations:@[@0.5]];
        [gradientLayer1 setStartPoint:CGPointMake(0.5, 1)];
        [gradientLayer1 setEndPoint:CGPointMake(0.5, 0)];
        [self.gradientLayer addSublayer:gradientLayer1];
        
        CAGradientLayer *gradientLayer2 =  [CAGradientLayer layer];
        [gradientLayer2 setLocations:@[@0.5]];
        gradientLayer2.frame = CGRectMake(self.width/2, 0, self.width/2, self.height);
        [gradientLayer2 setColors:[NSArray arrayWithObjects:(id)[kColor(0, 160, 233) CGColor],(id)[kColor(0, 160, 233) CGColor], nil]];
        [gradientLayer2 setStartPoint:CGPointMake(0.5, 0)];
        [gradientLayer2 setEndPoint:CGPointMake(0.5, 1)];
        [self.gradientLayer addSublayer:gradientLayer2];
        [self.gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
        [self.layer addSublayer:self.gradientLayer];
        
    }

    if (! self.dotView)
    {
        self.dotView = [[UIView alloc] initWithFrame:CGRectMake(self.width/2 - self.ringThickness/2., 0, self.ringThickness ,self.ringThickness)];
        self.dotView.backgroundColor = kMainColor;
        self.dotView.layer.cornerRadius = self.dotView.width/2.;
//        [self addSubview:self.dotView];
    }
    
    if (! self.dotImageView)
    {
        self.dotImageView = [[UIImageView alloc] init];
//        self.dotImageView.image = [UIImage imageNamed:@"newbuoy"];
        self.dotImageView.backgroundColor = allColorWhite
        self.dotImageView.size = self.dotView.size;
        self.dotImageView.center = CGPointMake(self.width/2., self.ringThickness/2.);
        self.dotImageView.layer.cornerRadius = self.dotImageView.frame.size.width/2;
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


- (void)setValue:(CGFloat)value
{
    float com = (100 * value/_maxValue);
    NSMutableAttributedString *string = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",((int)value)/60] Unit:@"h" WithFont:35];
    [string appendAttributedString:[self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",((int)value)%60] Unit:@"min" WithFont:35]];
    self.valueLabel.attributedText = string;

    float maxCom = MIN(com, 100);

    int x = self.width/2. + (self.height/2. - self.ringThickness/2.) *cos((maxCom/100.f + 0.75) *M_PI * 2);//括号内为弧度值
    int y = self.width/2. + (self.height/2. - self.ringThickness/2.) *sin((maxCom/100.f + 0.75) *M_PI * 2);
    self.dotImageView.center = CGPointMake(x, y);
    
    self.comLabel.text = [NSString stringWithFormat:@"%@ %d%%",kLOCAL(@"完成度"),(int)com];
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
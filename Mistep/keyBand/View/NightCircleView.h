//
//  LMGaugeView.h
//  LMGaugeView
//
//  Created by LMinh on 01/08/2014.
//  Copyright (c) 2014 LMinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NightCircleViewDelegate;

IB_DESIGNABLE
@interface NightCircleView : UIView

/*!
 *  Current value.
 */
@property (nonatomic, assign) CGFloat value;

/*!
 *  Minimum value.
 */
@property (nonatomic, assign) CGFloat minValue;

/*!
 *  Maximum value.
 */
@property (nonatomic, assign) CGFloat maxValue;

/*!
 *  Limit value.
 */
@property (nonatomic, assign) CGFloat limitValue;

/*!
 *  The thickness of the ring.
 */
@property (nonatomic, assign) IBInspectable CGFloat ringThickness;

/*!
 *  The background color of the ring.
 */
@property (nonatomic, strong) IBInspectable UIColor *ringBackgroundColor;

/*!
 *  The divisions radius.
 */
@property (nonatomic, assign) IBInspectable CGFloat divisionsRadius;

/*!
 *  The divisions color.
 */
@property (nonatomic, strong) IBInspectable UIColor *divisionsColor;

/*!
 *  The padding between ring and divisions.
 */
@property (nonatomic, assign) IBInspectable CGFloat divisionsPadding;

/*!
 *  The subdivisions radius.
 */
@property (nonatomic, assign) IBInspectable CGFloat subDivisionsRadius;

/*!
 *  The subdivisions color.
 */
@property (nonatomic, strong) IBInspectable UIColor *subDivisionsColor;

/*!
 *  A boolean indicates whether to show limit dot.
 */
@property (nonatomic, assign) IBInspectable BOOL showLimitDot;

/*!
 *  The radius of limit dot.
 */
@property (nonatomic, assign) IBInspectable CGFloat limitDotRadius;

/*!
 *  The color of limit dot.
 */
@property (nonatomic, strong) IBInspectable UIColor *limitDotColor;

/*!
 *  Font of value label.
 */
@property (nonatomic, strong) IBInspectable UIFont *valueFont;

/*!
 *  Text color of value label.
 */
@property (nonatomic, strong) IBInspectable UIColor *valueTextColor;


/*!
 *  A boolean indicates whether to show unit of measurement.
 */
@property (nonatomic, assign) IBInspectable BOOL showUnitOfMeasurement;

/*!
 *  The unit of measurement.
 */
@property (nonatomic, copy) IBInspectable NSString *unitOfMeasurement;

/*!
 *  Font of unit of measurement label.
 */
@property (nonatomic, strong) IBInspectable UIFont *unitOfMeasurementFont;

/*!
 *  Text color of unit of measurement label.
 */
@property (nonatomic, strong) IBInspectable UIColor *unitOfMeasurementTextColor;

@property (nonatomic, strong) UIImageView *dotImageView;

@property (nonatomic, strong) UILabel *comLabel;
/*!
 *  The receiver of all gauge view delegate callbacks.
 */
@property (nonatomic, weak) IBOutlet id<NightCircleViewDelegate> delegate;


@property (nonatomic, assign) CGFloat startAngle;

@property (nonatomic, assign) CGFloat endAngle;

@property (nonatomic, strong) UIView *dotView;

@property (nonatomic, strong) CALayer *gradientLayer;
/*!
 *  Trigger the stoke animation of ring layer.
 */
- (void)strokeGauge;

@end


@protocol NightCircleViewDelegate <NSObject>

@optional
/*!
 *  Return ring stroke color from the specified value.
 */
- (UIColor *)gaugeView:(NightCircleView *)gaugeView ringStokeColorForValue:(CGFloat)value;

@end

//
//  StepsUivew.m
//  Mistep
//
//  Created by 迈诺科技 on 2016/9/29.
//  Copyright © 2016年 huichenghe. All rights reserved.
//
#define uilable  2016
#define showLabelViewTAG  661
#define labelNumberTAG  662
#define labelUnitTAG  663
#import "StepsUivew.h"

@implementation StepsUivew
{
    int maxStep;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initData];
    }
    return self;
}

- (void)initData
{
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.userInteractionEnabled = YES;
    [self addSubview:backImageView];
    _backImageView = backImageView;
    backImageView.frame = CGRectMake(0, 0, self.width, self.height - 20);
//    backImageView.image = [UIImage imageNamed:@"StepChartBackgroundO"];
    backImageView.backgroundColor = kMainColor;
    
    UILabel *kStateLabel = [[UILabel alloc] init];
    kStateLabel.text = [NSString stringWithFormat:@"%@:",kLOCAL(@"运动状态")] ;
    [kStateLabel sizeToFit];
    kStateLabel.textColor = [UIColor whiteColor];
    [backImageView addSubview:kStateLabel];
    kStateLabel.frame = CGRectMake(8 * kX, 8 * kX, kStateLabel.width+10*WidthProportion, 16);
    kStateLabel.font = Font_Normal_String(14);
//    kStateLabel.backgroundColor = allColorRed;
    
    
    [backImageView addSubview:self.stateLabel];
    self.stateLabel.frame = CGRectMake(kStateLabel.right + 3, 8*kX - 6, backImageView.width - kStateLabel.right - 3, 22);
    self.stateLabel.text = kLOCAL(@"偏少");
    self.stateLabel.textColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] init];
    [backImageView addSubview:lineView];
    lineView.frame = CGRectMake(5, kStateLabel.bottom + 8 * kX, backImageView.width - 10, 1);
    lineView.backgroundColor = [UIColor clearColor];
    
    [backImageView addSubview:self.drawBackView];
    self.drawBackView.frame = CGRectMake(0, lineView.bottom + 8 * kX, backImageView.width, backImageView.height - (lineView.bottom + 8 * kX));
    
    float viewWidth = (CurrentDeviceWidth - 10)/49;
    for (int i = 0 ; i < 24; i ++)
    {
        if (!(i % 3))
        {
            UILabel *label = [[UILabel alloc] init];
            [self addSubview:label];
            label.frame = CGRectMake(viewWidth + viewWidth * 2 * i, backImageView.bottom + 3, viewWidth * 6, 20);
            label.font = Font_Normal_String(10);
            label.text = [NSString stringWithFormat:@"%1d:00",i];
            label.textColor = [UIColor darkGrayColor];
        }
    }
}

#pragma mark -- set方法

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    for (UIView *view in self.drawBackView.subviews)
    {
        if(view.tag >99&&view.tag<300)
        {
            view.alpha = 0;
            [view removeFromSuperview];
        }
        if (view.tag ==self.showLabelView.tag)
        {
            self.labelNumber.alpha = 0;
            [self.labelNumber removeFromSuperview];
            self.labelNumber = nil;
            self.labelUnit.alpha = 0;
            [self.labelUnit removeFromSuperview];
            self.labelUnit = nil;
            
            self.showLabelView.alpha = 0;
            [self.showLabelView removeFromSuperview];
            self.showLabelView = nil;
        }
    }
    maxStep = 0;
    int stepMtemp = 0,maxI = 0;
    UIButton *maxBtn = nil;
    for (int i = 0 ; i < _dataArray.count; i ++)
    {
        stepMtemp = [_dataArray[i] intValue];
        if (maxStep<stepMtemp)
        {
            maxStep = stepMtemp;
            maxI = i;
        }
        //maxStep = MAX(maxStep, step);
    }
    
    float maxHeight = self.drawBackView.height - 20 * HeightProportion;
    float viewWidth = self.drawBackView.width/49.;
    //adaLog(@"self.drawBackView.width = %f",self.drawBackView.width);
    if(_dataArray.count>0)
    {
        for (int i = 0; i < _dataArray.count; i ++)
        {
            float step = [_dataArray[i] floatValue];
            if ( step > 0 )
            {
                float viewHeitht = step/maxStep * maxHeight;
                
                UIView *view = [[UIView alloc] init];
                [self.drawBackView addSubview:view];
                view.backgroundColor = [UIColor whiteColor];
                view.frame = CGRectMake(viewWidth + viewWidth * 2 * i, self.drawBackView.bottom, viewWidth, 0);
                view.layer.cornerRadius = viewWidth/2.;
                view.clipsToBounds = YES;
                view.tag = i + 200;
                [UIView animateWithDuration:0.25 animations:^{
                    view.frame = CGRectMake(viewWidth + viewWidth * 2 * i, self.drawBackView.bottom - self.drawBackView.top - viewHeitht, viewWidth, viewHeitht);
                }];
                
                float buttonW = viewWidth * 2;
                float buttonMargin = viewWidth / 2;
                
                UIButton *button = [[UIButton alloc]init];
                button.backgroundColor = [UIColor clearColor];
                [self.drawBackView addSubview:button];
                button.frame = CGRectMake(buttonMargin + buttonW * i, self.drawBackView.bottom, buttonW, 0);
                button.layer.cornerRadius = viewWidth/2.;
                button.clipsToBounds = YES;
                [UIView animateWithDuration:0.25 animations:^{
                    button.frame = CGRectMake(buttonMargin + buttonW * i, self.drawBackView.bottom - self.drawBackView.top - maxHeight, buttonW, maxHeight);
                }];
                button.tag = i + 100;
                [button addTarget:self action:@selector(backNumber:) forControlEvents:UIControlEventTouchUpInside];
                if (i == maxI)
                {
                    maxBtn = button;
//                    [self backNumber:button];
                }
            }
        }
        if (maxBtn)
        {
             [self backNumber:maxBtn];
        }
    }
    else
    {
        
    }
    
}

-(void)backNumber:(UIButton *)button
{
    float step = [_dataArray[button.tag - 100] floatValue];
    if ( step <= 0 ) return;
    
    float maxHeight = self.drawBackView.height - 20;
    float viewHeitht = step/maxStep * maxHeight;
    //    step = 956956;
    CGFloat imageViewX = 0;
    CGFloat imageViewW = 40*WidthProportion;
    if (step>10000) {
        imageViewW = 48*WidthProportion;
    }
    //    CGFloat buttonY = button.frame.origin.y;
    CGFloat imageViewY = 0;
    if (maxHeight - viewHeitht > imageViewW) {
        imageViewY = self.drawBackView.height - (viewHeitht + imageViewW);
    } else {
        imageViewY = self.drawBackView.height - (viewHeitht - imageViewW / 4);
    }
    CGFloat imageViewH = imageViewW;
    self.showLabelView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    self.showLabelView.centerX = button.centerX;
    self.showLabelView.tag = showLabelViewTAG;
//#warning mark 移动气泡的位置 
    
    CGRect rect = self.showLabelView.frame;
    self.showLabelView.image = [UIImage imageNamed:@"qipao_"];
    if (rect.origin.x < 0)
    {
        rect.origin.x = -2*WidthProportion;
        self.showLabelView.frame = rect;
        self.showLabelView.image = [UIImage imageNamed:@"qipao_left"];
    }
    else if (rect.origin.x + rect.size.width > CurrentDeviceWidth)
    {
        rect.origin.x = WidthProportion + 4*WidthProportion - rect.size.width;
        self.showLabelView.frame = rect;
        self.showLabelView.image = [UIImage imageNamed:@"qipao_right"];
    }
    
    CGFloat labelNumberX = -5*WidthProportion;
    CGFloat labelNumberY = 5*HeightProportion;
    CGFloat labelNumberW = imageViewW+10*WidthProportion;
    CGFloat labelNumberH = (imageViewH - 2 * labelNumberY) / 2;
    self.labelNumber.frame = CGRectMake(labelNumberX, labelNumberY, labelNumberW, labelNumberH);
    self.labelNumber.tag = labelNumberTAG;
    CGFloat labelUnitX = 0;
    CGFloat labelUnitY = CGRectGetMaxY(self.labelNumber.frame);
    CGFloat labelUnitW = imageViewW;
    CGFloat labelUnitH = labelNumberH*(3.0/5.0);
    self.labelUnit.frame = CGRectMake(labelUnitX, labelUnitY, labelUnitW, labelUnitH);
    self.labelUnit.tag = labelUnitTAG;
    //设置显示的值
    self.labelNumber.text = [NSString stringWithFormat:@"%.0f",step];
    if (self.steps) {
        self.labelUnit.text = @"steps";
        
    } else {
        self.labelUnit.text = @"kcal";
    }
    
    [self.drawBackView addSubview:_showLabelView];
    [self.showLabelView addSubview:_labelNumber];
    [self.showLabelView addSubview:_labelUnit];
}
#pragma mark -- get方法

- (UIView *)drawBackView
{
    if (!_drawBackView)
    {
        _drawBackView = [[UIView alloc] init];
    }
    return _drawBackView;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel)
    {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = Font_Normal_String(16);
    }
    return _stateLabel;
}
-(UIImageView *)showLabelView
{
    if (!_showLabelView) {
        _showLabelView = [[UIImageView alloc]init];
        _showLabelView.image = [UIImage imageNamed:@"qipao_"];
    }
    return _showLabelView;
}
-(UILabel *)labelNumber
{
    if (!_labelNumber) {
        _labelNumber = [[UILabel alloc]init];
        _labelNumber.textAlignment = NSTextAlignmentCenter;
        _labelNumber.font = [UIFont systemFontOfSize:12*WidthProportion];
    }
    return _labelNumber;
}
-(UILabel *)labelUnit
{
    if (!_labelUnit) {
        _labelUnit = [[UILabel alloc]init];
        _labelUnit.textAlignment  = NSTextAlignmentCenter;
        _labelUnit.font = [UIFont systemFontOfSize:8*WidthProportion];
    }
    return _labelUnit;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

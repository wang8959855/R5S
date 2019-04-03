//
//  XueyaChartView.h
//  Mistep
//
//  Created by 迈诺科技 on 2016/10/20.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BloodPressureModel.h"

@interface XueyaChartView : UIView
@property (nonatomic,strong)NSArray * chartArray;  //   收缩压 array
//@property (nonatomic,strong)NSArray * diastolicPressureArray; // 舒张压
//@property (nonatomic,strong)NSString * systolicPressure;   // 收缩压
//@property (nonatomic,strong)NSString * diastolicPressure;  // 舒张压
- (instancetype)initWithFrame:(CGRect)frame;

//@property (nonatomic,assign)   CGFloat bounceX;
//@property (nonatomic,assign)   CGFloat bounceY;
@property (nonatomic,strong)   UIBezierPath * pathKuozhang;
@property (nonatomic,strong)   UIBezierPath * pathShousuo;
@end

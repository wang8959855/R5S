
//
//  StepsUivew.h
//  Mistep
//
//  Created by 迈诺科技 on 2016/9/29.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

//typedef void(^backNumber)(int,UIButton *);

#import <UIKit/UIKit.h>

@protocol StepsUivewDelegate <NSObject>
/**
 *回调高度值
 */
//-(void)callbackButtonTagShowNumber:(NSInteger)number withButton:(UIButton *)button;

@end

@interface StepsUivew : UIView

//@property (nonatomic , weak) id<StepsUivewDelegate>delegate;
//@property (nonatomic,copy) backNumber backNumber;

@property (strong, nonatomic) UILabel *stateLabel;

@property (strong, nonatomic) UIView *drawBackView;

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UIImageView *showLabelView;//显示数值的label
@property (strong, nonatomic) UILabel *labelNumber;//显示数值的label
@property (strong, nonatomic) UILabel *labelUnit;//显示数值的label
@property (assign, nonatomic) BOOL steps;

@end

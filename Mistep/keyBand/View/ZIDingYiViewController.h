//
//  ZIDingYiViewController.h
//  keyBand
//
//  Created by 迈诺科技 on 15/11/20.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZIDingYiViewController : PZBaseViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *botomConstant;

@property (strong, nonatomic) UIView *backView;

@property (weak, nonatomic) IBOutlet UIImageView *tip;

@property (strong, nonatomic) NSArray *typeArray;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (strong, nonatomic) UIView *repeatView;

@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;

@property (strong, nonatomic) NSArray *weekArray;

@property (copy, nonatomic) NSArray *dateArray;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UITextField *typeTF;

@property (copy, nonatomic) NSArray *exitArray;

@property (assign, nonatomic) BOOL isEdit;

@property (copy, nonatomic) NSDictionary *contentDic;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *repeatNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet UILabel *selectTypeLabel;

@property (strong, nonatomic) UIView *animationView;
@end

//
//  CustomStepTypeView.m
//  Wukong
//
//  Created by apple on 2018/6/28.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "CustomStepTypeView.h"

@interface CustomStepTypeView ()

@property (weak, nonatomic) IBOutlet UITextField *customTF;


@end

@implementation CustomStepTypeView

+ (instancetype)customStepTypeView{
    CustomStepTypeView *v = [[NSBundle mainBundle] loadNibNamed:@"CustomStepTypeView" owner:self options:nil].lastObject;
    v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.55];
    v.frame = [UIScreen mainScreen].bounds;
    
    return v;
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (IBAction)okAction:(UIButton *)sender {
    if (self.customTF.text.length == 0) {
        [AllTool addActityTextInView:self text:@"测试模式不能为空" deleyTime:1.5f];
        return;
    }
    if (self.CustomStepTypeBlock) {
        self.CustomStepTypeBlock(self.customTF.text);
    }
    [self removeFromSuperview];
}

- (IBAction)cancelAction:(UIButton *)sender {
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

@end

//
//  AlertNickNameView.m
//  Wukong
//
//  Created by apple on 2018/5/17.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "AlertNickNameView.h"

@implementation AlertNickNameView

+ (AlertNickNameView *)alertNickNameView{
    AlertNickNameView *v = [[NSBundle mainBundle] loadNibNamed:@"AlertNickNameView" owner:self options:nil].lastObject;
    v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.55];
    v.frame = [UIScreen mainScreen].bounds;
    
    v.cancelButton.layer.borderWidth = 1;
    v.okButton.layer.borderWidth = 1;
    v.cancelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    v.okButton.layer.borderColor = kMainColor.CGColor;
    
    return v;
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

@end

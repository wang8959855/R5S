//
//  AlertNickNameView.m
//  Wukong
//
//  Created by apple on 2018/5/17.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "AlertNickNameView.h"

@interface AlertNickNameView ()
    
@property (weak, nonatomic) IBOutlet UILabel *titleP;
    
@end

@implementation AlertNickNameView

+ (AlertNickNameView *)alertNickNameView{
    AlertNickNameView *v = [[NSBundle mainBundle] loadNibNamed:@"AlertNickNameView" owner:self options:nil].lastObject;
    v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.55];
    v.frame = [UIScreen mainScreen].bounds;
    
    v.cancelButton.layer.borderWidth = 1;
    v.okButton.layer.borderWidth = 1;
    v.cancelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    v.okButton.layer.borderColor = kMainColor.CGColor;
    [v.okButton setTitle:kLOCAL(@"确定") forState:UIControlStateNormal];
    [v.cancelButton setTitle:kLOCAL(@"取消") forState:UIControlStateNormal];
    v.titleP.text = kLOCAL(@"修改昵称");
    v.nickTF.placeholder = kLOCAL(@"点击上传你的昵称");
    
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

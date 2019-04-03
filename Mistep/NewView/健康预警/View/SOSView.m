//
//  SOSView.m
//  Wukong
//
//  Created by apple on 2018/5/23.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "SOSView.h"

@implementation SOSView

+ (SOSView *)initSOSView{
    SOSView *v = [[NSBundle mainBundle] loadNibNamed:@"SOSView" owner:self options:nil].lastObject;
    v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.55];
    v.frame = [UIScreen mainScreen].bounds;
    
    return v;
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (IBAction)cancelAction:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)okAction:(UIButton *)sender {
    if (self.sosOKBlock) {
        self.sosOKBlock();
    }
    [self removeFromSuperview];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
}

@end

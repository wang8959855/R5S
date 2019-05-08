//
//  SetBloodOxygenView.m
//  Wukong
//
//  Created by apple on 2019/3/25.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import "SetBloodOxygenView.h"

@interface SetBloodOxygenView()

@property (weak, nonatomic) IBOutlet UITextField *heightTF;
@property (weak, nonatomic) IBOutlet UITextField *lowTF;

@property (weak, nonatomic) IBOutlet UITextField *SPO2TF;

@end

@implementation SetBloodOxygenView

+ (instancetype)bloodOxygenView{
    SetBloodOxygenView *set = [[NSBundle mainBundle] loadNibNamed:@"SetBloodOxygenView" owner:self options:nil].lastObject;
    set.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.55];
    set.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [[UIApplication sharedApplication].keyWindow addSubview:set];
    
    set.SPO2TF.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"setspo2"];
    set.heightTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"setheight"];
    set.lowTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"setlow"];
    
    return set;
}

//确定
- (IBAction)okeyAction:(UIButton *)sender {
    if (self.heightTF.text.length == 0) {
        [self makeBottomToast:@"请填写基准高压值"];
        return;
    }
    if (self.lowTF.text.length == 0) {
        [self makeBottomToast:@"请填写基准低压值"];
        return;
    }
    if (self.SPO2TF.text.length == 0) {
        [self makeBottomToast:@"请填写餐后血糖值"];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.heightTF.text forKey:@"setheight"];
    [[NSUserDefaults standardUserDefaults] setObject:self.lowTF.text forKey:@"setlow"];
    [[NSUserDefaults standardUserDefaults] setObject:self.SPO2TF.text forKey:@"setspo2"];
    [self removeFromSuperview];
}

//取消
- (IBAction)cancelAction:(UIButton *)sender {
    [self removeFromSuperview];
}


@end

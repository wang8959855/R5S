//
//  RobotSwitchView.m
//  Wukong
//
//  Created by apple on 2019/3/29.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import "RobotSwitchView.h"

@interface RobotSwitchView ()

//存取开关数据
@property (nonatomic, strong) NSMutableArray *openArr;

@property (weak, nonatomic) IBOutlet UIButton *switchBtn;


@end

@implementation RobotSwitchView

+ (instancetype)robotSwitchView{
    RobotSwitchView *robot = [[NSBundle mainBundle] loadNibNamed:@"RobotSwitchView" owner:self options:nil].lastObject;
    robot.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    robot.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.55];
    [robot setData];
    
    [[UIApplication sharedApplication].keyWindow addSubview:robot];
    return robot;
}

- (void)setData{
    //获取开关的数据
    [self.openArr addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"openArr"]];
    for (int i = 0; i < self.openArr.count; i++) {
        BOOL isOpen = [self.openArr[i] boolValue];
        if (isOpen) {
            self.switchBtn.selected = YES;
            break;
        }
    }
}

//开关
- (IBAction)switchAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        //全部打开
        for (int i = 0; i < self.openArr.count; i++) {
            [self.openArr replaceObjectAtIndex:i withObject:@(YES)];
        }
    }else{
        //全部关闭
        for (int i = 0; i < self.openArr.count; i++) {
            [self.openArr replaceObjectAtIndex:i withObject:@(NO)];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.openArr forKey:@"openArr"];
}

- (IBAction)closeAction:(UIButton *)sender {
    NSInteger count = 0;
    for (NSNumber *num in self.openArr) {
        if (num.boolValue == YES) {
            count++;
        }
    }
    if (self.backRobotSwitchBlock) {
        self.backRobotSwitchBlock(count,self.openArr);
    }
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSInteger count = 0;
    for (NSNumber *num in self.openArr) {
        if (num.boolValue == YES) {
            count++;
        }
    }
    if (self.backRobotSwitchBlock) {
        self.backRobotSwitchBlock(count,self.openArr);
    }
    [self removeFromSuperview];
}

- (NSMutableArray *)openArr{
    if (!_openArr) {
        _openArr = [NSMutableArray array];
    }
    return _openArr;
}

@end

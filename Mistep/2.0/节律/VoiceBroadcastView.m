//
//  VoiceBroadcastView.m
//  Wukong
//
//  Created by apple on 2019/3/29.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import "VoiceBroadcastView.h"
#import "VoiceCell.h"

@interface VoiceBroadcastView ()<UITableViewDelegate,UITableViewDataSource>

//存取开关数据
@property (nonatomic, strong) NSMutableArray *openArr;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArr;

@end

@implementation VoiceBroadcastView

+ (instancetype)voiceBroadcastView{
    VoiceBroadcastView *voice = [[NSBundle mainBundle] loadNibNamed:@"VoiceBroadcastView" owner:self options:nil].lastObject;
    voice.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    voice.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.55];
    [[UIApplication sharedApplication].keyWindow addSubview:voice];
    [voice setData];
    return voice;
}

- (void)setData{
    //获取开关的数据
    [self.openArr addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"openArr"]];
    
    self.titleArr = @[@"丑时(01:00-03:00)",
                      @"寅时(03:00-05:00)",
                      @"卯时(05:00-07:00)",
                      @"辰时(07:00-09:00)",
                      @"巳时(09:00-11:00)",
                      @"午时(11:00-13:00)",
                      @"未时(13:00-15:00)",
                      @"申时(15:00-17:00)",
                      @"酉时(17:00-19:00)",
                      @"戌时(19:00-21:00)",
                      @"亥时(21:00-23:00)",
                      @"子时(23:00-01:00)"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"VoiceCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 40;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleL.text = self.titleArr[indexPath.row];
    cell.switchBtn.tag = 100+indexPath.row;
    
    cell.switchBtn.selected = [self.openArr[indexPath.row] boolValue];
    [cell.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)switchAction:(UIButton *)button{
    NSInteger index = button.tag-100;
    button.selected = !button.selected;
    
    [self.openArr replaceObjectAtIndex:index withObject:@(button.selected)];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:self.openArr forKey:@"openArr"];
}

//关闭
- (IBAction)closeAction:(UIButton *)sender {
    NSInteger count = 0;
    for (NSNumber *num in self.openArr) {
        if (num.boolValue == YES) {
            count++;
        }
    }
    if (self.backVoiceSwitchBlock) {
        self.backVoiceSwitchBlock(count,self.openArr);
    }
    [self removeFromSuperview];
}
//关闭
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSInteger count = 0;
    for (NSNumber *num in self.openArr) {
        if (num.boolValue == YES) {
            count++;
        }
    }
    if (self.backVoiceSwitchBlock) {
        self.backVoiceSwitchBlock(count,self.openArr);
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

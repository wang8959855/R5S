//
//  VersionAlertView.m
//  Wukong
//
//  Created by apple on 2019/8/6.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import "VersionAlertView.h"

@interface VersionAlertView ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *contentArr;

@end

@implementation VersionAlertView

+ (VersionAlertView *)versionAlertViewWithTitle:(NSString *)title content:(NSArray *)content{
    VersionAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"VersionAlertView" owner:self options:nil].lastObject;
    alert.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    alert.contentArr = content;
    [alert subViews];
    
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    
    return alert;
}

- (void)subViews{
    self.tableView.rowHeight = 20;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStr = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.textLabel.text = self.contentArr[indexPath.row];
    
    return cell;
}

//关闭
- (IBAction)closeAction:(UIButton *)sender {
    [self removeFromSuperview];
}
//sj
- (IBAction)upStore:(UIButton *)sender {
    //跳转到appstore
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/1415686707?mt=8"]];
}

@end

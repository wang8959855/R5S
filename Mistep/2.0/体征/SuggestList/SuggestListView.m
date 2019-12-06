//
//  SuggestListView.m
//  Wukong
//
//  Created by apple on 2019/12/3.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import "SuggestListView.h"
#import "SuggestCell.h"

@interface SuggestListView ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *yujingNum;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger recordNum;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *textBtn;


@end

@implementation SuggestListView

+ (instancetype)suggestListViewWithNum:(NSInteger)num superVC:(UIViewController *)vc list:(NSMutableArray *)list{
    SuggestListView *set = [[NSBundle mainBundle] loadNibNamed:@"SuggestListView" owner:self options:nil].lastObject;
    set.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.55];
    set.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [[UIApplication sharedApplication].keyWindow addSubview:set];
    set.vc = vc;
    set.recordNum = num;
    set.dataSource = list;
//    [set getList];
    [set setSubViews];
    return set;
}

- (void)setSubViews{
    [self.yujingNum setTitle:[NSString stringWithFormat:@"%ld次",self.recordNum] forState:UIControlStateNormal];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SuggestCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 30;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SuggestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.titleL.text = dic[@"advice"];
    cell.dateL.text = dic[@"time"];
    
    if ([dic[@"state"] isEqualToString:@"1"]) {
        cell.titleL.textColor = kColor(32, 157, 197);
        cell.dateL.textColor = kColor(32, 157, 197);
    }else{
        cell.titleL.textColor = [UIColor grayColor];
        cell.dateL.textColor = [UIColor grayColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self openDetail:indexPath.row];
}

//关闭
- (IBAction)colseAction:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)pushRecordAction:(UIButton *)sender {
    if (self.recordNum <= 0) {
        [self makeToast:NSLocalizedString(@"暂无预警记录", nil) duration:1.5 position:CSToastPositionCenter];
        return;
    }
    H5ViewController *h5 = [H5ViewController new];
    h5.titleStr = NSLocalizedString(@"预警记录", nil);
    h5.url = [NSString stringWithFormat:@"https://www02.lantianfangzhou.com/report/heartrate/b7s/%@/%@/0?page=curent",USERID,TOKEN];
    h5.hidesBottomBarWhenPushed = YES;
    [self.vc.navigationController pushViewController:h5 animated:YES];
    [self removeFromSuperview];
}

//返回列表
- (IBAction)backList:(UIButton *)sender {
    self.textView.text = @"";
    self.textView.hidden = YES;
    self.textBtn.hidden = YES;
}

- (void)getList{
    [self makeToastActivity:CSToastPositionCenter];
     NSString *url = [NSString stringWithFormat:@"%@/%@",SUGGEST,TOKEN];
    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:url fileUrl:nil params:@{@"userId":USERID} Block:^(id responseObject, NSError *error) {
        [self hideToastActivity];
        int code = [responseObject[@"code"] intValue];
        if (code == 0) {
            [self.dataSource addObjectsFromArray:responseObject[@"data"][@"list"]];
            self.recordNum = [responseObject[@"data"][@"warn"] integerValue];
            [self.yujingNum setTitle:[NSString stringWithFormat:@"%ld次",self.recordNum] forState:UIControlStateNormal];
            [self.tableView reloadData];
        }else{
        }
    }];
}

//详情
- (void)openDetail:(NSInteger)row{
    [self makeToastActivity:CSToastPositionCenter];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataSource[row]];
    NSString *url = [NSString stringWithFormat:@"%@/%@",SUGGESTDETAIL,TOKEN];
    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:url fileUrl:nil params:@{@"userId":USERID,@"id":dic[@"id"]} Block:^(id responseObject, NSError *error) {
        [self hideToastActivity];
        int code = [responseObject[@"code"] intValue];
        if (code == 0) {
            self.textView.hidden = NO;
            self.textBtn.hidden = NO;
            self.textView.text = responseObject[@"data"];
            
            [dic setObject:@"2" forKey:@"state"];
            [self.dataSource replaceObjectAtIndex:row withObject:dic];
            
            if (self.closeRequestBlock) {
                self.closeRequestBlock();
            }
            
            [self.tableView reloadData];
        }else{
        }
    }];
}

#pragma mark - 懒加载
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end

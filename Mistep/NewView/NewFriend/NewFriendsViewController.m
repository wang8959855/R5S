//
//  NewFriendsViewController.m
//  Wukong
//
//  Created by apple on 2018/5/19.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "NewFriendsViewController.h"
#import "WLBarcodeViewController.h"
#import "FriendListCell.h"
#import "SleepView.h"
#import "FriendDetailViewController.h"

@interface NewFriendsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation NewFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setSubViews];
}

- (void)setSubViews{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = nil;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 139;
    [self getFriendList];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendListCell *cell = [FriendListCell tableView:tableView identfire:@"listCell"];
    NSDictionary *dic = self.dataSource[indexPath.row];
    [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:dic[@"friendImg"]]];
    cell.nickName.text = dic[@"friendName"];
    cell.heartRateLabel.text = dic[@"friendHeartRate"];
    cell.sportsLabel.text = dic[@"friendStep"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //测试
//    NSString *root = @"http://test03.lantianfangzhou.com/report/current";
    //生产1
        NSString *root = @"https://rulong.lantianfangzhou.com/report/current";
    
    NSDictionary *dic = self.dataSource[indexPath.row];
    FriendDetailViewController *detail = [FriendDetailViewController new];
    detail.url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",root,dic[@"friendWatch"],USERID,TOKEN,dic[@"friendId"]];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取好友列表
- (void)getFriendList{
    [self.dataSource removeAllObjects];
    [self addActityIndicatorInView:self.view labelText:@"正在获取好友列表" detailLabel:@"正在获取好友列表"];
    [self performSelector:@selector(loginTimeOut) withObject:nil afterDelay:60.f];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@/%@",GETFRIENDLIST,TOKEN];
    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:uploadUrl fileUrl:nil params:@{@"userId":USERID} Block:^(id responseObject, NSError *error) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeOut) object:nil];
        
        [self removeActityIndicatorFromView:self.view];
        if (error)
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"网络连接错误", nil) deleyTime:1.5f];
        }
        else
        {
            int code = [[responseObject objectForKey:@"code"] intValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 0) {
                [self.dataSource addObjectsFromArray:responseObject[@"data"]];
                [self.tableView reloadData];
                
            } else {
                [self addActityTextInView:self.view text:NSLocalizedString(message, nil)  deleyTime:1.5f];
            }
        }
    }];
}

//返回
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//扫一扫
- (IBAction)saoYiSao:(UIButton *)sender{
    WLBarcodeViewController *vc=[[WLBarcodeViewController alloc] initWithBlock:^(NSString *str, BOOL isScceed) {
        
        if (isScceed) {
            NSLog(@"扫描后的结果~%@",str);
//            NSString *str1 = [str substringFromIndex:15];
            [self addFriendWithId:str];
        }else{
            NSLog(@"扫描后的结果~%@",str);
            [self addActityTextInView:self.view text:@"无法识别" deleyTime:1.5f];
        }
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

//添加好友
- (void)addFriendWithId:(NSString *)friendId{
    [self addActityIndicatorInView:self.view labelText:@"正在添加好友" detailLabel:@"正在添加好友"];
    [self performSelector:@selector(loginTimeOut) withObject:nil afterDelay:60.f];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@/%@",ADDFRIEND,TOKEN];
    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:uploadUrl fileUrl:nil params:@{@"userId":USERID,@"friendId":friendId} Block:^(id responseObject, NSError *error) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeOut) object:nil];
        
        [self removeActityIndicatorFromView:self.view];
        if (error)
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"网络连接错误", nil) deleyTime:1.5f];
        }
        else
        {
            int code = [[responseObject objectForKey:@"code"] intValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 0) {
                [self addActityTextInView:self.view text:NSLocalizedString(@"添加成功", nil) deleyTime:1.5f];
                [self getFriendList];
            } else {
                [self addActityTextInView:self.view text:NSLocalizedString(message, nil)  deleyTime:1.5f];
            }
        }
    }];
}

@end

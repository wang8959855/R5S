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
#import "AttentionView.h"

@interface NewFriendsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusHeight;

@property (nonatomic, strong) AttentionView *attentionView;

@property (weak, nonatomic) IBOutlet UILabel *line1;
@property (weak, nonatomic) IBOutlet UILabel *line2;
@property (weak, nonatomic) IBOutlet UIButton *topButton1;
@property (weak, nonatomic) IBOutlet UIButton *topButton2;


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
    self.statusHeight.constant = StatusBarHeight;
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
    NSString *root = @"http://test03.lantianfangzhou.com/report/current";
    //生产
//        NSString *root = @"https://rulong.lantianfangzhou.com/report/current";
    
    NSDictionary *dic = self.dataSource[indexPath.row];
    FriendDetailViewController *detail = [FriendDetailViewController new];
    detail.url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",root,dic[@"friendWatch"],USERID,TOKEN,dic[@"friendId"]];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//我的关注
- (IBAction)topAction1:(UIButton *)sender {
    sender.selected = YES;
    self.line1.hidden = NO;
    self.line2.hidden = YES;
    self.topButton2.selected = NO;
    [self.view sendSubviewToBack:self.attentionView];
}

//关注我的
- (IBAction)topAction2:(UIButton *)sender {
    sender.selected = YES;
    self.line2.hidden = NO;
    self.line1.hidden = YES;
    self.topButton1.selected = NO;
    [self.view bringSubviewToFront:self.attentionView];
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

- (AttentionView *)attentionView{
    if (!_attentionView) {
        _attentionView = [[AttentionView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, ScreenWidth, ScreenHeight-SafeAreaTopHeight)];
        _attentionView.vc = self;
        [self.view addSubview:_attentionView];
        [self.view sendSubviewToBack:_attentionView];
    }
    return _attentionView;
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

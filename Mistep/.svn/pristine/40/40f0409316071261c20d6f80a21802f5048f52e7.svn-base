//
//  JiuzuoViewController.m
//  Wukong
//
//  Created by 迈诺科技 on 16/5/18.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "JiuzuoViewController.h"
#import "JiuzuoTableViewCell.h"
#import "SMTabbedSplitViewController.h"
#import "JiuzuoSetViewController.h"


@interface JiuzuoViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

static NSString *reuseID = @"Cell";

@implementation JiuzuoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setXibLabels];
    
    [_tableView registerNib:[UINib nibWithNibName:@"JiuzuoTableViewCell" bundle:nil] forCellReuseIdentifier:reuseID];
    
    _exitArray = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",nil];
}

- (void)setXibLabels
{
    _titleLabel.text = NSLocalizedString(@"久坐提醒", nil);
    _kJiuzuoShijianLabel.text = NSLocalizedString(@"久坐提醒时间段", nil);
}

- (void)dealloc
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

        WeakSelf;
        [[CositeaBlueTooth sharedInstance] checkSedentaryWithSedentaryBlock:^(NSArray *array) {
            weakSelf.dataArray = array;
            [weakSelf.tableView reloadData];
            for (SedentaryModel *model in weakSelf.dataArray)
            {
                weakSelf.exitArray[model.index] = [NSString stringWithFormat:@"%d",model.index];
            }
        }];
}

#pragma mark -- ButtonAction

- (IBAction)addBtnAction:(UIButton *)sender
{
    if (_dataArray.count >= 4)
    {
        [self showAlertView:NSLocalizedString(@"最多可设置4个久坐提醒", nil)];
        return;
    }
    UIResponder *responder = [self checkNextResponderIsKindOfViewController:[SMTabbedSplitViewController class]];
    if (responder) {
        SMTabbedSplitViewController *split = (SMTabbedSplitViewController *)responder;
        JiuzuoSetViewController *jiuzuoSetVC = [JiuzuoSetViewController new];
        jiuzuoSetVC.exitArray = self.exitArray;
        [split.navigationController pushViewController:jiuzuoSetVC animated:YES];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        SedentaryModel * model = _dataArray[indexPath.row];
        [[CositeaBlueTooth sharedInstance] deleteSedentaryAlarmWithIndex:model.index];
        self.exitArray[model.index] = @"";
        [[CositeaBlueTooth sharedInstance] checkSedentaryWithSedentaryBlock:nil];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JiuzuoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIResponder *responder = [self checkNextResponderIsKindOfViewController:[SMTabbedSplitViewController class]];
    if (responder) {
        SMTabbedSplitViewController *split = (SMTabbedSplitViewController *)responder;
        JiuzuoSetViewController *jiuzuoSetVC = [JiuzuoSetViewController new];
        jiuzuoSetVC.model = _dataArray[indexPath.row];
        [split.navigationController pushViewController:jiuzuoSetVC animated:YES];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

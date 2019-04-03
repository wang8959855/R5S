////
////  shijianViewController.m
////  keyBand
////
////  Created by 迈诺科技 on 15/12/1.
////  Copyright © 2015年 huichenghe. All rights reserved.
////
//
//#import "shijianViewController.h"
//#import "HuoDongXiangQingCell.h"
//#import "DayOffLineViewController.h"
//#import "SelectSportTypeViewController.h"
//
//@interface shijianViewController ()<UITableViewDataSource,UITableViewDelegate>
//
//@end
//
//static NSString *reuseID = @"cell";
//
//@implementation shijianViewController
//
//- (void)setXibLabel
//{
//    _titleLabel.text = NSLocalizedString(@"离线事件", nil);
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//    [self setXibLabel];
//    _detailArray = [[SQLdataManger getInstance]queryActualTimeListWithDay:_seconds];
//    [_tableView registerNib:[UINib nibWithNibName:@"HuoDongXiangQingCell" bundle:nil] forCellReuseIdentifier:reuseID];
//
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return _detailArray.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    HuoDongXiangQingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
//    cell.contentDic = _detailArray[indexPath.row];
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 120;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    HuoDongXiangQingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:cell.contentDic];
//    int type = [dic[SportType_ActualData_HCH] intValue];
//    if (type == -1)
//    {
//        _selectIndexPath = indexPath;
//        SelectSportTypeViewController *typeVC = [[SelectSportTypeViewController alloc] init];
//        typeVC.eventDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
//        typeVC.cell = cell;
//        [self.navigationController pushViewController:typeVC animated:YES];
//    }
//    else
//    {
//        DayOffLineViewController *OffLineVC = [[DayOffLineViewController alloc]init];
//        OffLineVC.indexPath = indexPath;
//        OffLineVC.contentDic = cell.contentDic;
//        OffLineVC.heartRateArray = cell.heartArray;
//        [self.navigationController pushViewController:OffLineVC animated:YES];
//    }
//}
//
//
//
////- (void)typeButtonAction:(UIButton *)button
////{
////    HuoDongXiangQingCell *cell = [_tableView cellForRowAtIndexPath:_selectIndexPath];
////    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:cell.contentDic];
////    [dic setValue:[NSNumber numberWithInt:button.tag - 100] forKey:SportType_ActualData_HCH];
////    cell.contentDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
////    [[SQLdataManger getInstance] insertSignalDataToTable:ACtualTimeData_Table withData:dic];
////    DayOffLineViewController *offLineVC = [[DayOffLineViewController alloc]init];
////    offLineVC.indexPath = _selectIndexPath;
////    offLineVC.contentDic = cell.contentDic;
////    offLineVC.heartRateArray = cell.heartArray;
////    [self.navigationController pushViewController:offLineVC animated:YES];
////}
//
//
//- (IBAction)gobackAction:(id)sender
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end

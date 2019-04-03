////
////  SelectSportTypeViewController.m
////  Wukong
////
////  Created by 迈诺科技 on 16/5/6.
////  Copyright © 2016年 huichenghe. All rights reserved.
////
//
//#import "SelectSportTypeViewController.h"
//#import "DayOffLineViewController.h"
//#import "HuoDongXiangQingCell.h"
//
//@interface SelectSportTypeViewController ()<UITableViewDelegate,UITableViewDataSource>
//{
//    NSIndexPath *selectIndexPath;
//    
//}
//@end
//
//@implementation SelectSportTypeViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//    _imageArray = [[NSArray alloc]initWithObjects:
//                   @"jingxi",NSLocalizedString(@"静息", nil),
//                   @"tubu",NSLocalizedString(@"徒步", nil),
//                   @"paopu",NSLocalizedString(@"跑步",nil),
//                   @"pashan",NSLocalizedString(@"爬山",nil),
//                   @"qiulei",NSLocalizedString(@"球类运动", nil),
//                   @"juzhong",NSLocalizedString(@"力量训练",nil),
//                   @"youyang",NSLocalizedString(@"有氧训练",nil),
//                   @"JR_zidingyi",NSLocalizedString(@"自定义",nil),
//                   nil];
//    _customTF = [[UITextField alloc] init];
//    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
//    selectIndexPath = path;
//    [self updateUIafterListRowClickedWith:path];
//}
//
//- (void)updateUIafterListRowClickedWith:(NSIndexPath *)indexpath {
//    if (!selectIndexPath) {
//        UITableViewCell *cell = [_typeTableView cellForRowAtIndexPath:indexpath];
//        UIButton *button = (UIButton *)[cell.contentView viewWithTag:500];
//        button.hidden = !button.isHidden;
//        selectIndexPath = indexpath;
//        return;
//    }
//    if (indexpath.row != selectIndexPath.row) {
//        UITableViewCell *cell = [_typeTableView cellForRowAtIndexPath:indexpath];
//        UIButton *button = (UIButton *)[cell.contentView viewWithTag:500];
//        button.hidden = !button.isHidden;
//        
//        cell = [_typeTableView cellForRowAtIndexPath:selectIndexPath];
//        button = (UIButton *)[cell.contentView viewWithTag:500];
//        button.hidden = !button.isHidden;
//        
//        selectIndexPath = indexpath;
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 40;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 100;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CurrentDeviceWidth, CurrentDeviceHeight)];
//    view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:view];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [view addSubview:button];
//    [self setButtonWithButton:button andTitle:NSLocalizedString(@"确定", nil)];
//    [button addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    button.sd_layout.centerXEqualToView(view)
//    .topSpaceToView(view,30)
//    .heightIs(40)
//    .widthIs(250);
//    return view;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView* myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CurrentDeviceWidth, 40)];
//    myView.backgroundColor = [[UIColor alloc]initWithRed:246.f/255 green:246.f/255 blue:246.f/255 alpha:1.0f];
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, CurrentDeviceWidth - 30, 20)];
//    //    titleLabel.backgroundColor = [[UIColor alloc]initWithRed:250.f/255 green:220.f/255 blue:165.f/255 alpha:1.0f];
//    titleLabel.font = [UIFont systemFontOfSize:13];
//    titleLabel.textAlignment = NSTextAlignmentLeft;
//    titleLabel.textColor = [[UIColor alloc]initWithRed:149.f/255 green:149.f/255 blue:149.f/255 alpha:1.0f];
//    titleLabel.text =  NSLocalizedString(@"选择测试模式:", nil);
//    [myView addSubview:titleLabel];
//    
//    UIImageView *topLine = [[UIImageView alloc]initWithFrame :CGRectMake(0, 0, CurrentDeviceWidth, 1) ];
//    topLine.backgroundColor = [[UIColor alloc]initWithRed:231.f/255 green:231.f/255 blue:231.f/255 alpha:1.0f];
//    [myView addSubview:topLine];
//    
//    UIImageView *btmLine = [[UIImageView alloc]initWithFrame :CGRectMake(0, 39, CurrentDeviceWidth, 1) ];
//    btmLine.backgroundColor = [[UIColor alloc]initWithRed:231.f/255 green:231.f/255 blue:231.f/255 alpha:1.0f];
//    [myView addSubview:btmLine];
//    return myView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 58;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return _imageArray.count/2;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellID = @"cell" ;
//    static NSString *customCellID = @"custom";
//    UITableViewCell *cell;
//    if (indexPath.row == 7)
//    {
//        cell = [tableView dequeueReusableCellWithIdentifier:customCellID];
//        if (!cell)
//        {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customCellID];
//            cell.backgroundView = nil ;
//            cell.backgroundColor = [UIColor whiteColor];
//            cell.contentView.backgroundColor = [UIColor clearColor];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
//            
//            UIButton *imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            imgButton.frame = CGRectMake(10, 11, 36, 36);
//            imgButton.backgroundColor = [UIColor clearColor];
//            imgButton.tag = 100;
//            imgButton.userInteractionEnabled = NO;
//            [cell.contentView addSubview:imgButton];
//            
//            _customTF.frame = CGRectMake(65, 0, CurrentDeviceWidth - 100, 58);
//            _customTF.placeholder = NSLocalizedString(@"自定义",nil);
//            _customTF.returnKeyType = UIReturnKeyDone;
//            [_customTF addTarget:self action:@selector(textBeginEdit) forControlEvents:UIControlEventEditingDidBegin];
//            [cell.contentView addSubview:_customTF];
//            
//            
//            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(65, 57, CurrentDeviceWidth - 80, 1)];
//            line.backgroundColor = [UIColor colorWithRed:231.f/255.f green:231.f/255.f blue:231.f/255.f alpha:1.f];
//            line.tag = 300;
//            [cell.contentView addSubview:line];
//            UIButton *selBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            selBtn.frame = CGRectMake(CurrentDeviceWidth - 40, 19, 20, 20);
//            selBtn.backgroundColor = [UIColor clearColor];
//            [selBtn setBackgroundImage:[UIImage imageNamed:@"JR_SelectTip"] forState:UIControlStateNormal];
//            selBtn.hidden = YES;
//            selBtn.tag = 500;
//            [cell.contentView addSubview:selBtn];
//        }
//    }
//    else
//    {
//        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//        if( !cell ){
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//            cell.backgroundView = nil ;
//            cell.backgroundColor = [UIColor whiteColor];
//            cell.contentView.backgroundColor = [UIColor clearColor];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
//            
//            UIButton *imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            imgButton.frame = CGRectMake(10, 11, 36, 36);
//            imgButton.backgroundColor = [UIColor clearColor];
//            imgButton.tag = 100;
//            imgButton.userInteractionEnabled = NO;
//            [cell.contentView addSubview:imgButton];
//            
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(65, 0, CurrentDeviceWidth - 120, 58)];
//            label.backgroundColor = [UIColor clearColor];
//            label.textColor = [UIColor colorWithRed:84.f/255.f green:84.f/255.f blue:84.f/255.f alpha:1.f];
//            label.font = Font_Normal_String(16);
//            label.tag = 200;
//            [cell.contentView addSubview:label];
//            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(65, 57, CurrentDeviceWidth - 80, 1)];
//            line.backgroundColor = [UIColor colorWithRed:231.f/255.f green:231.f/255.f blue:231.f/255.f alpha:1.f];
//            line.tag = 300;
//            [cell.contentView addSubview:line];
//            UIButton *selBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            selBtn.frame = CGRectMake(CurrentDeviceWidth - 40, 19, 20, 20);
//            selBtn.backgroundColor = [UIColor clearColor];
//            [selBtn setBackgroundImage :[UIImage imageNamed:@"JR_SelectTip"] forState:UIControlStateNormal];
//            selBtn.hidden = YES;
//            selBtn.tag = 500;
//            [cell.contentView addSubview:selBtn];
//        }
//    }
//    UIView *line = [cell.contentView viewWithTag:300];
//    if (indexPath.row == _imageArray.count/2 -1) {
//        line.frame = CGRectMake(0, 57, CurrentDeviceWidth, 1);
//    }else {
//        line.frame = CGRectMake(65, 57, CurrentDeviceWidth - 80, 1);
//    }
//    
//    UIButton *selButton = (UIButton *)[cell.contentView viewWithTag:500];
//    selButton.hidden = indexPath.row == selectIndexPath.row?NO:YES;
//    UIButton *button = (UIButton *)[cell.contentView viewWithTag:100];
//    UILabel *lab = (UILabel *)[cell.contentView viewWithTag:200];
//    [button setBackgroundImage:[UIImage imageNamed:[_imageArray objectAtIndex:indexPath.row*2]] forState:UIControlStateNormal];
//    lab.text = [_imageArray objectAtIndex:indexPath.row*2 + 1];
//    return cell ;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [_customTF resignFirstResponder];
//    [self updateUIafterListRowClickedWith:indexPath];
//}
//
//- (void)textBeginEdit
//{
//    NSIndexPath *path = [NSIndexPath indexPathForRow:7 inSection:0];
//    [self updateUIafterListRowClickedWith:path];
//}
//
//- (void)nextButtonAction:(UIButton *)sender {
//    [_customTF resignFirstResponder];
//    sender.userInteractionEnabled = NO;
//    if (!selectIndexPath) {
//        [self addActityTextInView:self.view text:NSLocalizedString(@"选择测试模式", nil)  deleyTime:1.5f];
//        sender.userInteractionEnabled = YES;
//        return;
//    }
//    if(_customTF.text.length == 0  && selectIndexPath.row == 7)
//    {
//        [self addActityTextInView:self.view text:NSLocalizedString(@"选择测试模式", nil)  deleyTime:1.5f];
//        sender.userInteractionEnabled = YES;
//        return;
//    }
//    
//    //        if (selectIndexPath.row == 7)
//    //        {
//    //            [_eventDic setValue:[NSNumber numberWithInt:selectIndexPath.row] forKey:SportType_ActualData_HCH];
//    //            [_eventDic setValue:_customTF.text forKey:SportString_ActualData_HCH];
//    //            [_eventDic setValue:[NSNumber numberWithInt:selectIndexPath.row] forKey:SportType_ActualData_HCH];
//    //            [[SQLdataManger getInstance] insertSignalDataToTable:ACtualTimeData_Table withData:_eventDic];
//    //
//    //        }
//    //        else
//    //        {
//    //            [_eventDic setValue:[NSNumber numberWithInt:selectIndexPath.row] forKey:SportType_ActualData_HCH];
//    //            [[SQLdataManger getInstance] insertSignalDataToTable:ACtualTimeData_Table withData:_eventDic];
//    //        }
//    DayOffLineViewController *offLineVC = [[DayOffLineViewController alloc]init];
//    offLineVC.isFirst = YES;
//    offLineVC.indexPath = selectIndexPath;
//    offLineVC.contentDic = _eventDic;
//    offLineVC.heartRateArray = self.cell.heartArray;
//    self.cell.contentDic = _eventDic;
//    [self.navigationController pushViewController:offLineVC animated:YES];
//    
//    
//    sender.userInteractionEnabled = YES;
//}
//
//
//- (IBAction)goBack:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
// #pragma mark - Navigation
// 
// // In a storyboard-based application, you will often want to do a little preparation before navigation
// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// // Get the new view controller using [segue destinationViewController].
// // Pass the selected object to the new view controller.
// }
// */
//
//@end

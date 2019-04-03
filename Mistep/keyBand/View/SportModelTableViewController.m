////
////  SportModelTableViewController.m
////  Mistep
////
////  Created by 迈诺科技 on 2016/10/24.
////  Copyright © 2016年 huichenghe. All rights reserved.
////
//
//#import "SportModelTableViewController.h"
//#import "SportModelTableViewCell.h"
//
//@interface SportModelTableViewController ()<UITableViewDelegate,UITableViewDataSource>
//@property (nonatomic,assign)sportType sportType;
//@property (nonatomic,strong)NSString *sportName;
//@property (nonatomic,strong)UIButton *footButton;
//@end
//
//@implementation SportModelTableViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, CurrentDeviceWidth, CurrentDeviceHeight - 64) style:UITableViewStylePlain];
//    [self.view addSubview:self.tableView];
//    [self setupHeadView];
//    
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    //    [self.tableView setTableHeaderView:[self  setupHeadView]];
//    [self.tableView setTableFooterView:[self  setupFootView]];
//    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.sportType = 100;
//}
//-(void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:YES];
//}
//-(void)setupHeadView
//{
//    UIView *headView = [[UIView alloc]init];
//    headView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:headView];
//    CGFloat headViewX = 0;
//    CGFloat headViewY = 20;
//    CGFloat headViewW = CurrentDeviceWidth;
//    CGFloat headViewH = 44;
//    headView.frame = CGRectMake(headViewX, headViewY, headViewW, headViewH);
//    
//    UILabel *title = [[UILabel alloc]init];
//    [headView addSubview:title];
//    title.text = NSLocalizedString(@"选择运动模式", nil);
//    title.textAlignment = NSTextAlignmentCenter;
//    title.sd_layout
//    .widthIs(150)
//    .heightIs(30)
//    .centerXEqualToView(headView)
//    .centerYEqualToView(headView);
//    
//    UIButton  *backButton = [[UIButton alloc]init];
//    [headView addSubview:backButton];
//    [backButton setImage:[UIImage imageNamed:@"左"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    CGFloat backButtonX = 0;
//    CGFloat backButtonY = 0;
//    CGFloat backButtonW = headViewH;
//    CGFloat backButtonH = 44;
//    backButton.frame = CGRectMake(backButtonX, backButtonY, backButtonW, backButtonH);
//    
//    //     return headView;
//}
//-(void)backAction
//{
//    [self.navigationController popViewControllerAnimated:YES];
//    //    [self dismissViewControllerAnimated:YES completion:nil];
//}
//-(UIView *)setupFootView
//{
//    UIView *footView = [[UIView alloc]init];
//    footView.backgroundColor = kColor(246, 246, 246);
//    CGFloat footViewX = 0;
//    CGFloat footViewY = 0;
//    CGFloat footViewW = CurrentDeviceWidth;
//    CGFloat footViewH = 150;
//    footView.frame = CGRectMake(footViewX, footViewY, footViewW, footViewH);
//    
//    UIButton *footButton = [[UIButton alloc]init];
//    [footView addSubview:footButton];
//    _footButton = footButton;
//    footButton.backgroundColor = kColor(73, 125, 227);
//    footButton.layer.cornerRadius = 5;
//    [footButton addTarget:self action:@selector(callbackSelect) forControlEvents:UIControlEventTouchUpInside];
//    [footButton setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
//    [footButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    CGFloat footButtonX = 20;
//    CGFloat footButtonY = footViewH / 3;
//    CGFloat footButtonW = footViewW - 2 * footButtonX;
//    CGFloat footButtonH = footButtonY;
//    footButton.frame = CGRectMake(footButtonX, footButtonY, footButtonW, footButtonH);
//    
//    return footView;
//}
//-(void)callbackButtonCan
//{
//    _footButton.userInteractionEnabled = YES;
//}
//-(void)callbackSelect
//{
//    _footButton.userInteractionEnabled = NO;
//    [self performSelector:@selector(callbackButtonCan) withObject:nil afterDelay:2.0f];
//    //    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
//    
//    //adaLog(@"self.sportType   =  %d",self.sportType);
//    if (!self.sport)
//    {
//        if ([self.delegate respondsToSelector:@selector(callbackSelected:andSportModel:andSportName:)])
//            [self.delegate callbackSelected:self.sportType andSportModel:nil andSportName:self.sportName];
//    }
//    else
//    {
//        self.sport.sportType = [NSString stringWithFormat:@"%d",self.sportType];
//        NSMutableDictionary *dictionary  =[NSMutableDictionary dictionary];
//        [dictionary setValue:self.sport.sportID forKey:@"sportID"];
//        [dictionary setValue:[[HCHCommonManager getInstance]UserAcount] forKey:CurrentUserName_HCH];
//        [dictionary setValue:self.sport.sportType forKey:@"sportType"];
//        [dictionary setValue:self.sport.sportDate forKey:@"sportDate"];
//        [dictionary setValue:self.sport.fromTime forKey:@"fromTime"];
//        [dictionary setValue:self.sport.toTime forKey:@"toTime"];
//        [dictionary setValue:self.sport.stepNumber forKey:@"stepNumber"];
//        [dictionary setValue:self.sport.kcalNumber forKey:@"kcalNumber"];
//        [dictionary setValue:self.sportName forKey:@"sportName"];
//        NSData *heartData = [NSKeyedArchiver archivedDataWithRootObject:self.sport.heartRateArray];
//        [dictionary setValue:heartData forKey:@"heartRate"];
//        NSString *deviceType =  [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
//        NSString *deviceId = [AllTool amendMacAddressGetAddress];
//        //        NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
//        //        if (!deviceId) {
//        //            deviceId =  DEFAULTDEVICEID;
//        //        }
//        [dictionary setValue:deviceId forKey:DEVICEID];
//        [dictionary setValue:deviceType forKey:DEVICETYPE];
//        [dictionary setValue:@"0" forKey:ISUP];
//        
//        [[SQLdataManger getInstance] replaceDataWithColumns:dictionary toTableName:@"ONLINESPORT"];
//        if ([self.delegate respondsToSelector:@selector(callbackSelected:andSportModel:andSportName:)])
//            [self.delegate callbackSelected:10  andSportModel:self.sport andSportName:self.sport.sportName];
//    }
//}
//- (void)didReceiveMemoryWarning {  [super didReceiveMemoryWarning];}
//#pragma mark - Table view data source
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 7;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    SportModelTableViewCell *cell = [SportModelTableViewCell cellWithSportModelTableView:tableView];
//    cell.backgroundColor = kColor(246, 246, 246);
//    [cell SportModelRefresh:indexPath.row];
//    
//    if (self.sportType == indexPath.row + 100)
//    {
//        cell.markName = @"xuanze";
//    }
//    if (indexPath.row > 5 && self.sportType > 105)
//    {
//        if (self.sportName.length > 0)
//        {
//            cell.titleName = self.sportName;
//        }
//    }
//    
//    return cell;
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    SportModelTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.selected = NO;
//    self.sportType = (int)indexPath.row + 100;
//    self.sportName = cell.titleName;
//    self.sport.sportName = cell.titleName;
//    
//    if (indexPath.row > 5) {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"自定义", nil) preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"否", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"是", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            UITextField *login = alertController.textFields.firstObject;
//            if (login.text.length > 0) {
//                self.sport.sportName = login.text;
//                self.sportName = login.text;
//                [self.tableView reloadData];
//            }
//        }];
//        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
//            textField.placeholder = NSLocalizedString(@"自定义", nil);
//        }];
//        
//        [alertController addAction:cancelAction];
//        [alertController addAction:okAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
//    [self.tableView reloadData];
//    
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 220 * HEIGHT_PROPORTION;
//}
//-(void)dealloc
//{
//    //adaLog(@"销毁     - - - - - SportModelTableViewController ");
//}
//@end

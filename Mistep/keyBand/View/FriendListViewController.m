////
////  FriendListViewController.m
////  Mistep
////
////  Created by 迈诺科技 on 16/5/31.
////  Copyright © 2016年 huichenghe. All rights reserved.
////
//
//#import "FriendListViewController.h"
//#import "FriendListTableViewCell.h"
//#import "FriendListDetailViewController.h"
//
//@interface FriendListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
//
//@end
//
//static NSString *reuseID = @"Cell";
//
//@implementation FriendListViewController
//
//- (void)dealloc
//{
//    
//}
//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:YES];
//    [[PSDrawerManager instance] cancelDragResponse];
//}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self setXibLabels];
//    _addUserInfo = [NSMutableDictionary new];
//    
//    [_listTableView registerNib:[UINib nibWithNibName:@"FriendListTableViewCell" bundle:nil] forCellReuseIdentifier:reuseID];
//    _listTableView.showsVerticalScrollIndicator = NO;
//    _listTableView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.1];
//    _dataArray = [[NSMutableArray alloc] init];
//    
//    _nickNameTF.delegate = self;
//    
//    [self reloadAttentionList];
//     // Do any additional setup after loading the view from its nib.
//}
//
//- (void)reloadAttentionList
//{
//    [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"正在获取关注列表", nil) detailLabel:nil];
//    
//    __weak FriendListViewController *weakSelf = self;
//    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:[AFHTTPResponseSerializer serializer] RequestType:NSAFRequest_GET RequestURL:@"attention_myAttention" ParametersDictionary:nil Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
//        if (error)
//        {
//            [self removeActityIndicatorFromView:self.view];
//        }
//        else
//        {
//            
//            int code = [responseObject[@"code"] intValue];
//            if (code != 9001)
//            {
//                [self removeActityIndicatorFromView:self.view];
//            }
//            if (code == 9001)
//            {
//                [weakSelf loginStateTimeOutWithBlock:^(BOOL state) {
//                    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:[AFHTTPResponseSerializer serializer] RequestType:NSAFRequest_GET RequestURL:@"attention_myAttention" ParametersDictionary:nil Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
//                        if (error)
//                        {
//                        }
//                        else
//                        {
//                            [self removeActityIndicatorFromView:self.view];
//                            int code = [responseObject[@"code"] intValue];
//                            if (code == 9003)
//                            {
//                                [weakSelf.dataArray removeAllObjects];
//                                [weakSelf.dataArray addObjectsFromArray:responseObject[@"data"]];
//                                [_listTableView reloadData];
//                            }
//                        }
//                    }];
//                }];
//            }
//            else if (code == 9003)
//            {
//                [weakSelf.dataArray removeAllObjects];
//                [weakSelf.dataArray addObjectsFromArray:responseObject[@"data"]];
//                [_listTableView reloadData];
//            }
//        }
//    }];
//}
//
//- (void)setXibLabels
//{
//    _titleLabel.text = NSLocalizedString(@"亲情关爱", nil);
//    _userNameLabel.text = NSLocalizedString(@"亲关帐号", nil);
//    _kBirthDateLabel.text = NSLocalizedString(@"生日", nil);
//    _markNameLabel.text = NSLocalizedString(@"备注名称", nil);
//    [_addButton setTitle:NSLocalizedString(@"添加关注", nil) forState:UIControlStateNormal];
//    [_addButton addTarget:self action:@selector(sendAddInfoAction:) forControlEvents:UIControlEventTouchUpInside];
//}
//
//- (IBAction)goBackAction:(UIButton *)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//    //[self backToHome];
//}
//
//- (IBAction)addNiewAction:(UIButton *)sender
//{
//    self.backView.frame = CurrentDeviceBounds;
//    self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
//    [self.view addSubview:_backView];
//    [UIView animateWithDuration:0.35 animations:^{
//        self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    }];
//}
//
//- (IBAction)birthdatePickAction:(UIButton *)sender
//{
//    [self.view endEditing:YES];
//    if (!_animationView)
//    {
//        _animationView  = [[UIView alloc] initWithFrame:CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, 246)];
//        [_backView addSubview:_animationView];
//        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30,CurrentDeviceWidth, 216)];
//        NSString* string = @"19000101";
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//        [formatter setDateFormat:@"yyyyMMdd"];
//        NSDate* minDate = [formatter dateFromString:string];
//        _datePicker.datePickerMode = UIDatePickerModeDate;
//        _datePicker.backgroundColor = [UIColor whiteColor];
//        NSDate *maxDate = [NSDate date];
//        _datePicker.maximumDate = maxDate;
//        _datePicker.minimumDate = minDate;
//        [_animationView addSubview:_datePicker];
//        
//        UIView *buttonView = [[UIView alloc] init];
//        buttonView.backgroundColor = [UIColor whiteColor];
//        [_animationView addSubview:buttonView];
//        buttonView.sd_layout.leftEqualToView(_backView)
//        .rightEqualToView(_backView)
//        .heightIs(30)
//        .bottomSpaceToView(_datePicker,0);
//        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [buttonView addSubview:button];
//        button.frame = CGRectMake(CurrentDeviceWidth-80, 0, 80, 40);
//        [button addTarget:self action:@selector(dateSureClick) forControlEvents:UIControlEventTouchUpInside];
//        
//        UIImageView *btnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//        btnImageView.image = [UIImage imageNamed:@"hook"];
//        btnImageView.center = button.center;
//        [buttonView addSubview:btnImageView];
//        
//        [UIView animateWithDuration:0.23 animations:^{
//            _animationView.frame = CGRectMake(0, CurrentDeviceHeight-246,CurrentDeviceWidth, 246);
//        }];
//    }
//}
//
//- (IBAction)userNmaeTFEndEditing:(UITextField *)sender
//{
//    [self.view endEditing:YES];
//    [_addUserInfo setObject:sender.text forKey:@"account"];
//}
//
//- (IBAction)nickNameTFEndEditing:(UITextField *)sender
//{
//    NSString *str = sender.text;
//
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
//    [_addUserInfo setObject:result forKey:@"mark"];
//}
//
//- (void)dateSureClick
//{
//    NSDate *pickDate = _datePicker.date;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *string = [formatter stringFromDate:pickDate];
//    _birthDateLabel.text = string;
//    [_addUserInfo setObject:string forKey:@"birth"];
//
//    
//    [UIView animateWithDuration:0.23 animations:^{
//        _animationView.frame = CGRectMake(0, CurrentDeviceHeight,CurrentDeviceWidth, 246);
//    } completion:^(BOOL finished) {
//        [_animationView removeFromSuperview];
//        self.animationView = nil;
//        self.datePicker = nil;
//    }];
//}
//
//- (void)sendAddInfoAction:(UIButton *)sender
//{
//    if ([_addUserInfo allKeys].count != 3) {
//        [self addActityTextInView:self.view text:NSLocalizedString(@"请完善资料", nil) deleyTime:1.5f];
//        return;
//    }
//    for (NSString *key in [_addUserInfo allKeys]) {
//        NSString *data = [_addUserInfo objectForKey:key];
//        if ([data isEqualToString:@""] || !data) {
//            [self addActityTextInView:self.view text:NSLocalizedString(@"请完善资料", nil) deleyTime:1.5f];
//            return;
//        }
//    }
//    
//    if (![self checkUserName:_userNameTF.text])
//    {
//        return;
//    }
//    [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"正在添加", nil) detailLabel:nil];
//    
//    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:@"attention_addAttention" fileUrl:nil params:_addUserInfo Block:^(id responseObject, NSError *error) {
//        //adaLog(@"%@",responseObject[@"msg"]);
//        if (error)
//        {
//            [self removeActityIndicatorFromView:self.view];
//            [self addActityTextInView:self.view text:@"服务器异常" deleyTime:1.5f];
//        }else
//        {
//            int code = [responseObject[@"code"] intValue];
// 
//            if (code != 9001)
//            {
//                [self removeActityIndicatorFromView:self.view];
//            }
//            if (code == 9001)
//            {
//                [self loginStateTimeOutWithBlock:^(BOOL state) {
//                    if (state)
//                    {
//                        [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:@"attention_addAttention" fileUrl:nil params:_addUserInfo Block:^(id responseObject, NSError *error) {
//                            if (error)
//                            {
//                                [self removeActityIndicatorFromView:self.view];
//                                [self addActityTextInView:self.view text:@"服务器异常" deleyTime:1.5f];
//                            }else
//                            {
//                                [self removeActityIndicatorFromView:self.view];
//                                int code = [responseObject[@"code"] intValue];
//                                    if (code == 9003)
//                                    {
//                                        [self reloadAttentionList];
//                                    }
//                                    if (code == 400)
//                                    {
////                                        关注不能超过5个
//                                        [self addActityTextInView:self.view text:NSLocalizedString(@"关注用户不能超过5个", nil) deleyTime:1.5f];
//                                    }else if (code == 401)
//                                    {
//                                        [self addActityTextInView:self.view text:NSLocalizedString(@"该用户已关注", nil) deleyTime:1.5f];
//                                    }else if (code == 402)
//                                    {
//                                        [self addActityTextInView:self.view text:NSLocalizedString(@"生日输入错误", nil) deleyTime:1.5f];
//                                    }else if (code == 403)
//                                    {
//                                        [self addActityTextInView:self.view text:NSLocalizedString(@"关注的用户不存在", nil) deleyTime:1.5f];
//                                    }else if (code == 404)
//                                    {
//                                        [self addActityTextInView:self.view text:NSLocalizedString(@"不能关注自己", nil) deleyTime:1.5f];
//                                    }else{
//                                        [self addActityTextInView:self.view text:NSLocalizedString(@"服务器异常", nil) deleyTime:1.5f];
//                                    }
//                            }
//                        }];
//                    }else{
//                        [self addActityTextInView:self.view text:NSLocalizedString(@"服务器异常", nil) deleyTime:1.5f];
//                    }
//                }];
//            }else  if (code == 9003)
//            {
//                [self reloadAttentionList];
//            }
//            else if (code == 400)
//            {
//                //                                        关注不能超过5个
//                [self addActityTextInView:self.view text:NSLocalizedString(@"关注用户不能超过5个", nil) deleyTime:1.5f];
//            }else if (code == 401)
//            {
//                [self addActityTextInView:self.view text:NSLocalizedString(@"该用户已关注", nil) deleyTime:1.5f];
//            }else if (code == 402)
//            {
//                [self addActityTextInView:self.view text:NSLocalizedString(@"生日输入错误", nil) deleyTime:1.5f];
//            }else if (code == 403)
//            {
//                [self addActityTextInView:self.view text:NSLocalizedString(@"关注的用户不存在", nil) deleyTime:1.5f];
//            }else if (code == 404)
//            {
//                [self addActityTextInView:self.view text:NSLocalizedString(@"不能关注自己", nil) deleyTime:1.5f];
//            }else{
//                [self addActityTextInView:self.view text:NSLocalizedString(@"服务器异常", nil) deleyTime:1.5f];
//            }
//
//        }
//    }];
//    
//    [_backView removeFromSuperview];
//    [_animationView removeFromSuperview];
//    self.animationView = nil;
//
//}
//
//#pragma mark --UITableViewDataSource
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.5f;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return _dataArray.count;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    FriendListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//    cell.contentDic = _dataArray[indexPath.row];
//     cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.1];
//    return cell;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 107;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary *dic = _dataArray[indexPath.row];
//
//    FriendListDetailViewController *detailVC = [[FriendListDetailViewController alloc]init];
//    detailVC.modelDic = dic;
//    [self.navigationController pushViewController:detailVC animated:YES];
//    
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"正在删除", nil) detailLabel:nil];
//    NSDictionary *dic = _dataArray[indexPath.row];
//    NSString *userID = dic[@"id"];
//    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:[NSString stringWithFormat:@"attention_deleteAttention?passiveUserId=%@",userID] ParametersDictionary:nil Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
//        if (error)
//        {
//            [self removeActityIndicatorFromView:self.view];
//            [self addActityTextInView:self.view text:NSLocalizedString(@"删除失败", nil) deleyTime:1.5f];
//        }
//        else
//        {
//            int code = [responseObject[@"code"] intValue];
//            if (code != 9001)
//            {
//                [self removeActityIndicatorFromView:self.view];
//                if (code == 9003)
//                {
//                    [self addActityTextInView:self.view text:NSLocalizedString(@"删除成功", nil) deleyTime:1.5f];
//                    NSDictionary *dic = _dataArray[indexPath.row];
//                    [_dataArray removeObject:dic];
//                    [_listTableView reloadData];
//                }
//                
//            }else
//            {
//                [self loginStateTimeOutWithBlock:^(BOOL state) {
//                    if (state)
//                    {
//                        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:[NSString stringWithFormat:@"attention_deleteAttention?passiveUserId=%@",userID] ParametersDictionary:nil Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
//                            if (error)
//                            {
//                                [self removeActityIndicatorFromView:self.view];
//                                [self addActityTextInView:self.view text:NSLocalizedString(@"删除失败", nil) deleyTime:1.5f];
//                            }
//                            else
//                            {
//                                int code = [responseObject[@"code"] intValue];
//                                [self removeActityIndicatorFromView:self.view];
//                                if (code == 9003)
//                                {
//                                    [self addActityTextInView:self.view text:NSLocalizedString(@"删除成功", nil) deleyTime:1.5f];
//                                    NSDictionary *dic = _dataArray[indexPath.row];
//                                    [_dataArray removeObject:dic];
//                                    [_listTableView reloadData];
//                                }
//                            }
//                        }];
//                    }
//            }];
//            }
//        }
//    }];
//}
//
//
//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touche = [touches anyObject];
//    CGPoint touchePoint = [touche locationInView:self.view];
//    if (CGRectContainsPoint(_inputView.frame, touchePoint))
//    {
//        return;
//    }
//    [_backView removeFromSuperview];
//    _userNameTF.text = @"";
//    _birthDateLabel.text = @"";
//    _nickNameTF.text = @"";
//}
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (textField.text.length >= 32)
//    {
//        return NO;
//    }
//    return YES;
//}
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

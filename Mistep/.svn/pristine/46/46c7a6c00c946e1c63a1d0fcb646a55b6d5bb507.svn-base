////
////  FriendListDetailViewController.m
////  Mistep
////
////  Created by 迈诺科技 on 16/6/3.
////  Copyright © 2016年 huichenghe. All rights reserved.
////
//
//#import "FriendListDetailViewController.h"
//#import "UIImageView+AFNetworking.h"
//
//#define KONEDAYSECONDS 86400
//
//
//@interface FriendListDetailViewController ()
//{
//    UIActivityIndicatorView *aiv;
//}
//@end
//
//@implementation FriendListDetailViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//    [self setXibLabels];
//    self.markLabel.text = _modelDic[@"mark"];
//    NSString *header = _modelDic[@"header"];
//    _headerImageView.layer.cornerRadius = _headerImageView.width/2;
//    [_headerImageView clipsToBounds];
//    if ((NSNull *)header != [NSNull null])
//    {
//        NSString *url = [NSString stringWithFormat:@"http://bracelet.cositea.com:8089/bracelet/download_userHeader?filename=%@",header];
//        [_headerImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"QG_manHeader"]];
//    }
//    
//    _trendScrollView.contentSize = CGSizeMake(2*CurrentDeviceWidth, _trendScrollView.height);
//    _trendScrollView.showsHorizontalScrollIndicator = NO;
//    _trendScrollView.pagingEnabled = YES;
//    _trendScrollView.scrollEnabled = NO;
//    _dayBtn.selected = YES;
//    
//    NSDictionary *param = @{@"userId":_modelDic[@"id"],@"timeType":@1};
//    
//    aiv = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    aiv.center = CGPointMake(CurrentDeviceWidth/2, _trendScrollView.centerY);
//    [aiv startAnimating];
//    [self.view addSubview:aiv];
//    
//    int todaySecond = [[TimeCallManager getInstance] getSecondsOfCurDay];
//    
//    
//    for (int i = 0 ; i < 7 ; i ++)
//    {
//        int second = todaySecond - KONEDAYSECONDS*(6-i);
//        
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"MM/dd"];
//        NSString *dateString = [formatter stringFromDate:date];
//        
//        UILabel *label = [[UILabel alloc] init];
//        label.font = [UIFont systemFontOfSize:13];
//        label.text = dateString;
//        label.textColor = [UIColor grayColor];
//        [self.view addSubview:label];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.sd_layout.topSpaceToView(_trendScrollView,2)
//        .leftSpaceToView(self.view,i *CurrentDeviceWidth/7)
//        .widthIs(CurrentDeviceWidth/7)
//        .heightIs(15);
//    }
//    
//    UILabel *textLabel = [[UILabel alloc] init];
//    textLabel.text = NSLocalizedString(@"步数", nil);
//    textLabel.font = [UIFont systemFontOfSize:14];
//    textLabel.tag = 50;
//    [self.view addSubview:textLabel];
//    [textLabel sizeToFit];
//    textLabel.sd_layout.rightSpaceToView(self.view,12)
//    .bottomSpaceToView(self.view,10)
//    .heightIs (20)
//    .widthIs(textLabel.width);
//    
//    UIView *imageTipView = [[UIView alloc] init];
//    imageTipView.backgroundColor = kStepColor;
//    imageTipView.tag = 50;
//    [self.view addSubview:imageTipView];
//    imageTipView.sd_layout.centerYEqualToView(textLabel)
//    .rightSpaceToView(textLabel,12)
//    .widthIs(35)
//    .heightIs(5);
//    
//    __weak FriendListDetailViewController *weakSelf = self;
//    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"attention_friendHealth" ParametersDictionary:param Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
//        if (error)
//        {
//        }
//        else
//        {
//            int code = [responseObject[@"code"] intValue];
//            if (code != 9001)
//            {
//                [aiv stopAnimating];
//                [aiv removeFromSuperview];
//                aiv = nil;
//                if (code == 9003)
//                {
//                    weakSelf.detaiArray = responseObject[@"data"];
//                }
//            }else
//            {
//                [self loginStateTimeOutWithBlock:^(BOOL state) {
//                    if (state)
//                    {
//                            [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"attention_friendHealth" ParametersDictionary:param Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
//                                [aiv stopAnimating];
//                                [aiv removeFromSuperview];
//                                aiv = nil;
//                                int code = [responseObject[@"code"] intValue];
//                                if (code == 9003)
//                                {
//                                    weakSelf.detaiArray = responseObject[@"data"];
//                                }
//                            }];
//                    }
//                }];
//            }
//        }
//    }];
//    [self dayBtnAction:_dayBtn];
//}
//
//- (void)setXibLabels
//{
//    _kActivityLabel.text = NSLocalizedString(@"活力", nil);
//    _kTiredLabel.text = NSLocalizedString(@"疲劳", nil);
//    _kWeekTrendLabel.text = NSLocalizedString(@"周活动趋势图", nil);
//    _kStepsLabel.text = NSLocalizedString(@"步数", nil);
//    _titleLabel.text = NSLocalizedString(@"活动详情", nil);
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    NSString *pilaoString = _modelDic[@"indexFatigue"];
//    int pilaoValue = 100;
//    if ((NSNull*)pilaoString != [NSNull null] && [pilaoString intValue] != 0)
//    {
//        pilaoValue = [pilaoString intValue];
//    }
//    
//    UIImageView *pilaoTip = [[UIImageView alloc] init];
//    pilaoTip.image = [UIImage imageNamed:@"QG_pilaoTip"];
//    [_pilaoBGImageView addSubview:pilaoTip];
//    pilaoTip.sd_layout.widthIs(10)
//    .heightIs(18)
//    .centerYIs(5)
//    .leftSpaceToView(_pilaoBGImageView,(_pilaoBGImageView.width-10)/100*(100-pilaoValue));
//}
//
//- (IBAction)dayBtnAction:(UIButton *)sender
//{
//    if (!_dayBtn.selected)
//    {
//        for (UIView *view in self.view.subviews)
//        {
//            if (view.tag == 50)
//            {
//                [view removeFromSuperview];
//            }
//        }
//        
//        _dayBtn.selected = YES;
//        _nightBtn.selected = NO;
//        _trendScrollView.contentOffset = CGPointMake(0, 0);
//        
//        UILabel *textLabel = [[UILabel alloc] init];
//        textLabel.text = NSLocalizedString(@"步数", nil);
//        textLabel.font = [UIFont systemFontOfSize:14];
//        textLabel.tag = 50;
//        [self.view addSubview:textLabel];
//        [textLabel sizeToFit];
//        textLabel.sd_layout.rightSpaceToView(self.view,12)
//        .bottomSpaceToView(self.view,10)
//        .heightIs (20)
//        .widthIs(textLabel.width);
//        
//        UIView *imageTipView = [[UIView alloc] init];
//        imageTipView.backgroundColor = kStepColor;
//        imageTipView.tag = 50;
//        [self.view addSubview:imageTipView];
//        imageTipView.sd_layout.centerYEqualToView(textLabel)
//        .rightSpaceToView(textLabel,12)
//        .widthIs(35)
//        .heightIs(5);
//        
//    }
//}
//
//- (IBAction)nightBtnAction:(UIButton *)sender
//{
//    if (!_nightBtn.selected)
//    {
//        for (UIView *view in self.view.subviews)
//        {
//            if (view.tag == 50)
//            {
//                [view removeFromSuperview];
//            }
//        }
//        _nightBtn.selected = YES;
//        _dayBtn.selected = NO;
//        _trendScrollView.contentOffset = CGPointMake(CurrentDeviceWidth, 0);
//        
//        NSArray *colorArray = @[NSLocalizedString(@"清醒", nil),kWakeSleepColor,NSLocalizedString(@"浅睡", nil),kLightSleepColor,NSLocalizedString(@"深睡", nil),kDeppSleepColor];
//        for (int i = 0 ; i < 3; i ++)
//        {
//            UILabel *textLabel = [[UILabel alloc] init];
//            textLabel.font = [UIFont systemFontOfSize:14];
//            textLabel.tag = 50;
//            textLabel.text = colorArray[i*2];
//            textLabel.numberOfLines = 2;
//            textLabel.textAlignment = NSTextAlignmentCenter;
//            [self.view addSubview:textLabel];
//            textLabel.sd_layout.rightSpaceToView(self.view,12 + 100 * i)
//            .bottomSpaceToView(self.view,0)
//            .heightIs (35)
//            .widthIs(60);
//            
//            UIView *imageTipView = [[UIView alloc] init];
//            imageTipView.backgroundColor = colorArray[i * 2 + 1];
//            imageTipView.tag = 50;
//            [self.view addSubview:imageTipView];
//            imageTipView.sd_layout.centerYEqualToView(textLabel)
//            .rightSpaceToView(textLabel,3)
//            .widthIs(35)
//            .heightIs(5);
//        }
//    }
//}
//
//-(void)setDetaiArray:(NSArray *)detaiArray
//{
//    _detaiArray = detaiArray;
//    
//    int maxStep = 0;
//    int maxSleep = 0;
//    for (int i = 0 ; i < detaiArray.count; i ++)
//    {
//        NSDictionary *dic = detaiArray[i];
//        NSString *stepString = dic[@"step"];
//        int step = 0;
//        
//        int Deep = [dic[@"sleepDept"] intValue];
//        int light = [dic[@"sleepLight"] intValue];
//        int awake = [dic[@"sleepAweek"] intValue];
//        if (maxSleep < Deep)
//        {
//            maxSleep = Deep;
//        }
//        if (maxSleep < light)
//        {
//            maxSleep = light;
//        }
//        if (maxSleep < awake)
//        {
//            maxSleep = awake;
//        }
//        
//        if ((NSNull *)stepString != [NSNull null])
//        {
//            step = [stepString intValue];
//            if (step > maxStep)
//            {
//                maxStep = step;
//            }
//        }
//    }
//    
//    for (int i = 0 ; i < detaiArray.count; i ++)
//    {
//        NSDictionary *dic = detaiArray[i];
//        NSString *dateString = dic[@"day"];
//        NSString *stepString = dic[@"step"];
//        int step = 0;
//        if ((NSNull *)stepString != [NSNull null])
//        {
//            step = [stepString intValue];
//        }
//        int second = [[TimeCallManager getInstance] getSecondsWithTimeString:dateString andFormat:@"yyyy-MM-dd"];
//        int todaySecond = [[TimeCallManager getInstance] getSecondsOfCurDay];
//        int index =6 - (todaySecond - second)/KONEDAYSECONDS;
//        if (maxStep != 0)
//        {
//            UIView *stepView = [[UIView alloc] init];
//            stepView.backgroundColor = kStepColor;
//            [_trendScrollView addSubview: stepView];
//            stepView.sd_layout.leftSpaceToView(_trendScrollView,index * CurrentDeviceWidth/7 + (CurrentDeviceWidth/7 - 30)/2)
//            .widthIs (30)
//            .heightIs ((_trendScrollView.height - 15)/maxStep * step)
//            .bottomEqualToView(_trendScrollView);
//            
//            UILabel *label = [[UILabel alloc] init ];
//            label.textAlignment = NSTextAlignmentCenter;
//            label.font = [UIFont systemFontOfSize:12];
//            label.textColor = kStepColor;
//            [_trendScrollView addSubview:label];
//            label.sd_layout.bottomSpaceToView (stepView,3)
//            .leftSpaceToView (_trendScrollView,index * CurrentDeviceWidth/7)
//            .widthIs(CurrentDeviceWidth/7)
//            .heightIs(10);
//            label.text = [NSString stringWithFormat:@"%d",step];
//        }
//        
//        int Deep = [dic[@"sleepDept"] intValue];
//        int light = [dic[@"sleepLight"] intValue];
//        int awake = [dic[@"sleepAweek"] intValue];
//        NSArray *array = @[[NSNumber numberWithInt:Deep],kDeppSleepColor,[NSNumber numberWithInt:light],kLightSleepColor,[NSNumber numberWithInt:awake],kWakeSleepColor];
//        int dayMax = 0;
//        for (int i = 0 ; i < 2; i ++)
//        {
//            int value = [array[i * 2] intValue];
//            if (dayMax < value)
//            {
//                dayMax = value;
//            }
//        }
//        for ( int i = 0 ; i < 2; i ++)
//        {
//            if (maxSleep != 0)
//            {
//                UIView *view = [[UIView alloc] init];
//                view.backgroundColor = array[i * 2 +1];
//                int sleepValue = [array[i*2] intValue];
//                [_trendScrollView addSubview:view];
//                view.sd_layout.leftSpaceToView(_trendScrollView,CurrentDeviceWidth + index*CurrentDeviceWidth/7 + CurrentDeviceWidth/28 * (i + 1))
//                .widthIs(CurrentDeviceWidth/28)
//                .heightIs((_trendScrollView.height - 15)/maxSleep * sleepValue)
//                .bottomEqualToView(_trendScrollView);
//                if (dayMax != 0 && dayMax == sleepValue)
//                {
//                    UILabel *sleepLabel = [[UILabel alloc] init ];
//                    sleepLabel.textAlignment = NSTextAlignmentCenter;
//                    sleepLabel.font = [UIFont systemFontOfSize:12];
//                    sleepLabel.textColor = kDeppSleepColor;
//                    [_trendScrollView addSubview:sleepLabel];
//                    sleepLabel.sd_layout.bottomSpaceToView (view,3)
//                    .leftSpaceToView (_trendScrollView,CurrentDeviceWidth + index * CurrentDeviceWidth/7)
//                    .widthIs(CurrentDeviceWidth/7)
//                    .heightIs(10);
//                    sleepLabel.text = [NSString stringWithFormat:@"%dh%d'",(Deep +light)/60,(Deep + light)%60];
//                }
//            }
//        }
//    }
//}
//
//- (IBAction)backAction:(UIButton *)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (IBAction)sharedAction:(UIButton *)sender
//{
//    [self shareVC];
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

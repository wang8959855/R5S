////
////  TodaySportDetailViewController.m
////  Mistep
////
////  Created by 迈诺科技 on 2016/11/3.
////  Copyright © 2016年 huichenghe. All rights reserved.
////
//#define fontNumber   13
//#define fontNumberDa   27
//#define calculateHeart 220
//#define downBackColor kColor(230, 230, 230)
//
//
//#import "TodaySportDetailViewController.h"
//#import "NSAttributedString+appendAttributedString.h"
//#import "ratioCircle.h"
//
//@interface TodaySportDetailViewController ()
//@property (nonatomic,strong)UIView *upView;//上层view
//
//@property (nonatomic,strong)UILabel *labelTwoSeconed;//心率区间  label
//@property (nonatomic,strong)UILabel *labelTwoThird;
//@property (nonatomic,strong)UILabel *labelTwoFourth;
//@property (nonatomic,strong)UILabel *labelTwoFifth;
//@property (nonatomic,strong)UILabel *labelTwoSixth;
//@property (nonatomic,strong)UILabel *labelThirdSeconed;//时长label
//@property (nonatomic,strong)UILabel *labelThirdThird;
//@property (nonatomic,strong)UILabel *labelThirdFourth;
//@property (nonatomic,strong)UILabel *labelThirdFifth;
//@property (nonatomic,strong)UILabel *labelThirdSixth;
//@property (nonatomic,strong)UILabel *labelFourthSeconed;//百分比  label
//@property (nonatomic,strong)UILabel *labelFourthThird;
//@property (nonatomic,strong)UILabel *labelFourthFourth;
//@property (nonatomic,strong)UILabel *labelFourthFifth;
//@property (nonatomic,strong)UILabel *labelFourthSixth;
//
//@property (nonatomic,strong)UILabel *fisrtLabeltwo;//平均心率 label
//@property (nonatomic,strong)UILabel *seconedLabeltwo;//热量消耗 label
//@property (nonatomic,strong)UILabel *thirdLabeltwo;//运动强度 label
//
//@property (nonatomic,assign) NSInteger limit;   //时长  number
//@property (nonatomic,assign) NSInteger anaerobic;
//@property (nonatomic,assign) NSInteger aerobic;
//@property (nonatomic,assign) NSInteger fatBurning;
//@property (nonatomic,assign) NSInteger warmUp;
//@property (nonatomic,strong) UILabel *timeLabelNumber;//显示时间的lable
//@property (nonatomic,strong) NSDate *date;
//@property (nonatomic,strong) ratioCircle * circle;
//@property (nonatomic,strong) UILabel *titleLabel;//head的name
//@property (nonatomic,strong) UIView *headView;//head的view
//
//@end
//
//@implementation TodaySportDetailViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self  setupView];
//    
//}
//-(void)setupView
//{
////    self.view.backgroundColor = [UIColor whiteColor];
//    [self initProperty];
//    [self  setupHeadView];
//    [self  setupUPView];
//    [self  setupMiddleView];
//    [self  setupDownView];
//    [self  setupHeartSection];//心率区间 setupintervalWithDate
//    
//    
//}
//
////心率区间 setup  %02ld
//-(void)setupHeartSection
//{
//   _seconedLabeltwo.attributedText = [NSAttributedString  makeAttributedStringWithnumBer:_sport.kcalNumber Unit:@"kcal" WithFont:fontNumberDa];
//    /**
//     *心率区间
//     */
//    NSInteger maxHeart,maxHeartOno,maxHeartTwo,maxHeartThree,maxHeartFour;
//    maxHeart = calculateHeart - [[HCHCommonManager getInstance]getAge];
//    
//    maxHeartOno = maxHeart * 90 /100;
//    maxHeartTwo = maxHeart * 80 /100;
//    maxHeartThree = maxHeart * 70 /100;
//    maxHeartFour = maxHeart * 60 /100;
//    _labelTwoSixth.attributedText = [NSMutableAttributedString  makeAttributedStringWithnumBer:[NSString stringWithFormat:@">%ld",maxHeartOno] Unit:@"bpm" WithFont:fontNumber];
//    _labelTwoFifth.attributedText = [NSMutableAttributedString  makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%ld-%ld",maxHeartTwo,maxHeartOno] Unit:@"bpm" WithFont:fontNumber];
//    _labelTwoFourth.attributedText = [NSMutableAttributedString  makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%ld-%ld",maxHeartThree,maxHeartTwo] Unit:@"bpm" WithFont:fontNumber];
//    _labelTwoThird.attributedText = [NSMutableAttributedString  makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%ld-%ld",maxHeartFour,maxHeartThree] Unit:@"bpm" WithFont:fontNumber];
//    _labelTwoSeconed.attributedText = [NSMutableAttributedString  makeAttributedStringWithnumBer:[NSString stringWithFormat:@"<%ld",maxHeartFour] Unit:@"bpm" WithFont:fontNumber];
//    //    //adaLog(@" - %ld _ %ld-%ld _ %ld -%ld",maxHeart,maxHeartOno,maxHeartTwo,maxHeartThree,maxHeartFour);
//    
//        //从心率数组中取出心率  [AllTool seconedTominute:_sport.heartRateArray];
//    NSMutableArray *minuteArray =  [NSMutableArray arrayWithArray:_sport.heartRateArray];
//    //平均心率  ping jun
//    _fisrtLabeltwo.attributedText = [NSAttributedString  makeAttributedStringWithnumBer:[AllTool getMean:minuteArray] Unit:NSLocalizedString(@"次/分钟", nil) WithFont:fontNumberDa];
//    //   时长
//    NSInteger  heartNum = 0;
//    for (NSString *heart in minuteArray) {
//        heartNum = [heart integerValue];
//        if(heartNum > maxHeartOno)
//        {
//            ++_limit;
//        }
//        else if (heartNum > maxHeartTwo)
//        {
//            ++_anaerobic;
//        }
//        else if (heartNum > maxHeartThree)
//        {
//            ++_aerobic;
//        }
//        else if (heartNum > maxHeartFour)
//        {
//            ++_fatBurning;
//        }
//        else
//        {
//            ++_warmUp;
//        }
//    }
//    
//    //总时间长度
//    NSInteger hour = minuteArray.count / 60;
//    NSInteger minute = minuteArray.count % 60;
//    
//    NSMutableAttributedString *string;
//    if (hour > 0) {
//        string = [NSMutableAttributedString makeAttributedStringWithnumBer:[NSString  stringWithFormat:@"%ld",hour] Unit:@"h" WithFont:fontNumberDa];
//        [string appendAttributedString:[NSMutableAttributedString makeAttributedStringWithnumBer:[NSString  stringWithFormat:@"%ld",minute] Unit:@"min" WithFont:fontNumberDa]];
//    }
//    else
//    {
//        if (minute > 0) {
//            string = [NSMutableAttributedString makeAttributedStringWithnumBer:[NSString  stringWithFormat:@"%ld",minute] Unit:@"min" WithFont:fontNumberDa];
//        }
//        else
//        {
//            
//            string = [NSMutableAttributedString makeAttributedStringWithnumBer:[NSString  stringWithFormat:@"%d",0] Unit:@"min" WithFont:fontNumberDa];
//        }
//    }
//    _timeLabelNumber.attributedText = string;
//    
//    
////    //adaLog(@" - %ld _ %ld-%ld _ %ld -%ld",_limit,_anaerobic,_aerobic,_fatBurning,_warmUp);
////    NSInteger seconed = 60;
////    
////    NSInteger re = _warmUp / seconed;
////    NSInteger ranzhi = _fatBurning / seconed;
////    NSInteger you = _aerobic / seconed;
////    NSInteger wu = _anaerobic / seconed;
////    NSInteger jixian = _limit / seconed;
//    NSString *text1 = [NSString string];//
//    NSString *text2 = [NSString string];// stringWithFormat:@"%ld ",_fatBurning / seconed];
//    NSString *text3 = [NSString string];// stringWithFormat:@"%ld ",_aerobic / seconed];
//    NSString *text4 = [NSString string];// stringWithFormat:@"%ld ",_anaerobic / seconed];
//    NSString *text5 = [NSString string];// stringWithFormat:@"%ld ",_limit / seconed];
//    text1 = [NSString stringWithFormat:@"%ld ",_warmUp];
//    text2 = [NSString stringWithFormat:@"%ld ",_fatBurning];
//    text3 = [NSString stringWithFormat:@"%ld ",_aerobic];
//    text4 = [NSString stringWithFormat:@"%ld ",_anaerobic];
//    text5 = [NSString stringWithFormat:@"%ld ",_limit];
//    
//    _labelThirdSeconed.attributedText = [NSMutableAttributedString  makeAttributedStringWithnumBer:text1 Unit:@"min" WithFont:fontNumber];
//    _labelThirdThird.attributedText = [NSMutableAttributedString  makeAttributedStringWithnumBer:text2 Unit:@"min" WithFont:fontNumber];
//    _labelThirdFourth.attributedText = [NSMutableAttributedString  makeAttributedStringWithnumBer:text3 Unit:@"min" WithFont:fontNumber];
//    _labelThirdFifth.attributedText = [NSMutableAttributedString  makeAttributedStringWithnumBer:text4  Unit:@"min" WithFont:fontNumber];
//    _labelThirdSixth.attributedText = [NSMutableAttributedString  makeAttributedStringWithnumBer:text5  Unit:@"min" WithFont:fontNumber];
//    
//    
//    //运动强度
//    if (_limit >= 5)
//        _thirdLabeltwo.text = NSLocalizedString(@"非常高", nil);
//    else  if (_anaerobic + _limit>= 10)
//        _thirdLabeltwo.text = NSLocalizedString(@"高", nil);
//    else if (_anaerobic + _limit + _aerobic >= 40)
//        _thirdLabeltwo.text = NSLocalizedString(@"中", nil);
//    else if (_anaerobic + _limit + _aerobic + _fatBurning >= 80)
//        _thirdLabeltwo.text = NSLocalizedString(@"低", nil);
//    else
//        _thirdLabeltwo.text = NSLocalizedString(@"非常低", nil);
//    
//    
//    //百分比
//    CGFloat warmUpRadio = 0;
//    CGFloat fatBurningRadio = 0;
//    CGFloat aerobicRadio = 0;
//    CGFloat anaerobicRadio = 0;
//    CGFloat limitRadio = 0;
//    CGFloat radioCount = 0;
//    CGFloat number = 100;
//    radioCount = _warmUp + _fatBurning + _aerobic + _anaerobic + _limit;
//    
//    warmUpRadio = _warmUp / radioCount * number;
//    fatBurningRadio = _fatBurning / radioCount * number;
//    aerobicRadio = _aerobic / radioCount * number;
//    anaerobicRadio = _anaerobic / radioCount * number;
//    limitRadio = _limit / radioCount * number;
//    if (radioCount == 0) {
//        warmUpRadio = 0;
//        fatBurningRadio = 0;
//        aerobicRadio = 0;
//        anaerobicRadio = 0;
//        limitRadio = 0;
//    }
//    _labelFourthSeconed.text = [NSString stringWithFormat:@"%2.0f%%",warmUpRadio];
//    _labelFourthThird.text = [NSString stringWithFormat:@"%2.0f%%",fatBurningRadio];
//    _labelFourthFourth.text = [NSString stringWithFormat:@"%2.0f%%",aerobicRadio];
//    _labelFourthFifth.text = [NSString stringWithFormat:@"%2.0f%%",anaerobicRadio];
//    _labelFourthSixth.text = [NSString stringWithFormat:@"%2.0f%%",limitRadio];
//    
//    _circle.ratioOne = limitRadio;
//    _circle.ratioTwo = anaerobicRadio;
//    _circle.ratioThree = aerobicRadio;
//    _circle.ratioFour =fatBurningRadio;
//    _circle.ratioFive = warmUpRadio;
//    
//}
//-(void)getTotalTime
//{
//    // _sport.fromTime d
//}
//-(void)countHeart:(NSInteger)number
//{
//    
//}
//-(void)setupHeadView
//{
//    [self.view addSubview:self.headView];
//
//    
//    //导航条的背景图
//    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.headView.width, self.headView.height)];
//    [self.headView addSubview:headImage];
//    headImage.image = [UIImage imageNamed:@"导航条阴影"];
//    
//    
//    UIButton *backButton = [[UIButton alloc]init];
//    [self.headView addSubview:backButton];
//    //    backButton.backgroundColor = [UIColor greenColor];
//    [backButton setImage:[UIImage imageNamed:@"左"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(backActionDetail) forControlEvents:UIControlEventTouchUpInside];
//    
//    CGFloat backButtonX = 0;
//    CGFloat backButtonY = 0;
//    CGFloat backButtonW = 44;
//    CGFloat backButtonH = 44;
//    backButton.frame = CGRectMake(backButtonX, backButtonY, backButtonW, backButtonH);
//   
//    [self.headView addSubview:self.titleLabel];
////    self.titleLabel.centerX = self.headView.centerX;
////    self.titleLabel.centerY = self.headView.centerY;
//    self.titleLabel.sd_layout
//    .centerXEqualToView(self.headView)
//    .centerYEqualToView(self.headView);
//    if (_sport.sportName) {
//        self.titleLabel.text = _sport.sportName;
//    } else {
//        if (_titleLabel) {
//            _titleLabel.text = [self setupTitle];
//        }
//    }
//   
//}
//-(NSString *)setupTitle
//{
//    NSString * titleString = [NSString string];
//    NSInteger sportType = [_sport.sportType integerValue];
//     NSInteger type =0;
//    if (sportType>=100)
//    {
//        type = sportType - 100;
//    }
//    else
//    {
//        type = sportType;
//    }
//    switch (type) {
//        case 0:
//            titleString = NSLocalizedString(@"徒步", nil);;
//            break;
//        case 1:
//            titleString = NSLocalizedString(@"跑步", nil);;
//            break;
//        case 2:
//            titleString = NSLocalizedString(@"登山", nil);;
//            break;
//        case 3:
//            titleString = NSLocalizedString(@"球类", nil);;
//            break;
//        case 4:
//            titleString = NSLocalizedString(@"力量训练", nil);;
//            break;
//        case 5:
//            titleString = NSLocalizedString(@"有氧训练", nil);;
//            break;
//        case 6:
//            titleString = NSLocalizedString(@"自定义", nil);;
//            break;
//        default:
//            titleString = NSLocalizedString(@"徒步", nil);;
//            break;
//    }
//    
//    return  titleString;
//}
//
//-(void)setupUPView
//{
//    UIView *upView = [[UIView alloc]init];
//    _upView = upView;
//    [self.view addSubview:upView];
//    upView.backgroundColor = allColorWhite;
//    
//    CGFloat upViewX = 0;
//    CGFloat upViewY = 64;
//    CGFloat upViewW = CurrentDeviceWidth;
//    CGFloat upViewH = 100 * CurrentDeviceHeight / 667;
//    upView.frame = CGRectMake(upViewX, upViewY, upViewW, upViewH);
//    
//    // 第一个界面
//    UIView *fisrtView = [[UIView alloc]init];
//    [upView addSubview:fisrtView];
//    
//    CGFloat fisrtViewX = 0;
//    CGFloat fisrtViewY = 0;
//    CGFloat fisrtViewW = CurrentDeviceWidth / 3;
//    CGFloat fisrtViewH = upViewH;
//    fisrtView.frame = CGRectMake(fisrtViewX, fisrtViewY, fisrtViewW, fisrtViewH);
//    
//    UILabel *fisrtLabelone = [[UILabel alloc]init];
//    [fisrtView addSubview:fisrtLabelone];
//    fisrtLabelone.textColor = fontcolorless;
//    fisrtLabelone.text = NSLocalizedString(@"平均心率", nil);
//    fisrtLabelone.textAlignment = NSTextAlignmentCenter;
//    
//    CGFloat fisrtLabeloneX = 0;
//    CGFloat fisrtLabeloneY = fisrtViewH / 3;
//    CGFloat fisrtLabeloneW = fisrtViewW;
//    CGFloat fisrtLabeloneH = fisrtViewH / 3;
//    fisrtLabelone.frame = CGRectMake(fisrtLabeloneX, fisrtLabeloneY, fisrtLabeloneW, fisrtLabeloneH);
//    
//    UILabel *fisrtLabeltwo = [[UILabel alloc]init];
//    [fisrtView addSubview:fisrtLabeltwo];
//    _fisrtLabeltwo = fisrtLabeltwo;
//    fisrtLabeltwo.textColor = fontcolorMain;
//    fisrtLabeltwo.attributedText = [NSAttributedString  makeAttributedStringWithnumBer:@"0" Unit:NSLocalizedString(@"次/分钟", nil) WithFont:fontNumberDa];
//    fisrtLabeltwo.textAlignment = NSTextAlignmentCenter;
//    
//    CGFloat fisrtLabeltwoX = 0;
//    CGFloat fisrtLabeltwoY = CGRectGetMaxY(fisrtLabelone.frame);
//    CGFloat fisrtLabeltwoW = fisrtLabeloneW;
//    CGFloat fisrtLabeltwoH = fisrtLabeloneH;
//    fisrtLabeltwo.frame = CGRectMake(fisrtLabeltwoX, fisrtLabeltwoY, fisrtLabeltwoW, fisrtLabeltwoH);
//    
//    //第二个界面
//    UIView *seconedView = [[UIView alloc]init];
//    [upView addSubview:seconedView];
//    
//    CGFloat seconedViewX = CurrentDeviceWidth / 3;
//    CGFloat seconedViewY = 0;
//    CGFloat seconedViewW = CurrentDeviceWidth / 3;
//    CGFloat seconedViewH = upViewH;
//    seconedView.frame = CGRectMake(seconedViewX, seconedViewY, seconedViewW, seconedViewH);
//    
//    UILabel *seconedLabelone = [[UILabel alloc]init];
//    [seconedView addSubview:seconedLabelone];
//    seconedLabelone.textColor = fontcolorless;
//    seconedLabelone.text = NSLocalizedString(@"热量消耗", nil);
//    seconedLabelone.textAlignment = NSTextAlignmentCenter;
//    
//    CGFloat seconedLabeloneX = 0;
//    CGFloat seconedLabeloneY = seconedViewH / 3;
//    CGFloat seconedLabeloneW = seconedViewW;
//    CGFloat seconedLabeloneH = seconedViewH / 3;
//    seconedLabelone.frame = CGRectMake(seconedLabeloneX, seconedLabeloneY, seconedLabeloneW, seconedLabeloneH);
//    
//    UILabel *seconedLabeltwo = [[UILabel alloc]init];
//    [seconedView addSubview:seconedLabeltwo];
//    _seconedLabeltwo = seconedLabeltwo;
//    seconedLabeltwo.textColor = fontcolorMain;
//    seconedLabeltwo.attributedText = [NSAttributedString  makeAttributedStringWithnumBer:@"0" Unit:@"kcal" WithFont:fontNumberDa];
//    seconedLabeltwo.textAlignment = NSTextAlignmentCenter;
//    
//    CGFloat seconedLabeltwoX = 0;
//    CGFloat seconedLabeltwoY = CGRectGetMaxY(seconedLabelone.frame);
//    CGFloat seconedLabeltwoW = fisrtLabeloneW;
//    CGFloat seconedLabeltwoH = fisrtLabeloneH;
//    seconedLabeltwo.frame = CGRectMake(seconedLabeltwoX, seconedLabeltwoY, seconedLabeltwoW, seconedLabeltwoH);
//    //第三个界面
//    UIView *thirdView = [[UIView alloc]init];
//    [upView addSubview:thirdView];
//    
//    CGFloat thirdViewX = CurrentDeviceWidth / 3 *2;
//    CGFloat thirdViewY = 0;
//    CGFloat thirdViewW = CurrentDeviceWidth / 3;
//    CGFloat thirdViewH = upViewH;
//    thirdView.frame = CGRectMake(thirdViewX, thirdViewY, thirdViewW, thirdViewH);
//    
//    UILabel *thirdLabelone = [[UILabel alloc]init];
//    [thirdView addSubview:thirdLabelone];
//    thirdLabelone.textColor = fontcolorless;
//    thirdLabelone.text = NSLocalizedString(@"运动强度", nil);
//    thirdLabelone.textAlignment = NSTextAlignmentCenter;
//    
//    CGFloat thirdLabeloneX = 0;
//    CGFloat thirdLabeloneY = thirdViewH / 3;
//    CGFloat thirdLabeloneW = thirdViewW;
//    CGFloat thirdLabeloneH = thirdViewH / 3;
//    thirdLabelone.frame = CGRectMake(thirdLabeloneX, thirdLabeloneY, thirdLabeloneW, thirdLabeloneH);
//    
//    UILabel *thirdLabeltwo = [[UILabel alloc]init];
//    [thirdView addSubview:thirdLabeltwo];
//    _thirdLabeltwo = thirdLabeltwo;
//    thirdLabeltwo.textColor = fontcolorMain;
//    thirdLabeltwo.text = NSLocalizedString(@"非常低", nil);
//    thirdLabeltwo.textAlignment = NSTextAlignmentCenter;
//    
//    CGFloat thirdLabeltwoX = 0;
//    CGFloat thirdLabeltwoY = CGRectGetMaxY(thirdLabelone.frame);
//    CGFloat thirdLabeltwoW = fisrtLabeloneW;
//    CGFloat thirdLabeltwoH = fisrtLabeloneH;
//    thirdLabeltwo.frame = CGRectMake(thirdLabeltwoX, thirdLabeltwoY, thirdLabeltwoW, thirdLabeltwoH);
//    
//}
//
//-(void)setupMiddleView
//{
//    UIView *MiddleView = [[UIView alloc]init];
//    [self.view addSubview:MiddleView];
//    //    MiddleView.backgroundColor = [UIColor grayColor];
//    
//    CGFloat MiddleViewX = 0;
//    CGFloat MiddleViewY = CGRectGetMaxY(_upView.frame);
//    CGFloat MiddleViewW = CurrentDeviceWidth;
//    CGFloat MiddleViewH = (CurrentDeviceHeight - (_upView.height + 64)) / 2;
//    MiddleView.frame = CGRectMake(MiddleViewX, MiddleViewY, MiddleViewW, MiddleViewH);
//    
//    CGFloat circleX = 0;
//    CGFloat circleY = 0;
//    CGFloat circleW = MiddleViewW;
//    CGFloat circleH = MiddleViewH;
//    ratioCircle * circle = [[ratioCircle alloc]initWithFrame:CGRectMake(circleX, circleY, circleW, circleH)];
//    [MiddleView addSubview:circle];
//    _circle = circle;
//    circle.backgroundColor = [UIColor whiteColor];
////    circle.ratioOne = 0.1;
////    circle.ratioTwo = 0.2;
////    circle.ratioThree = 0.3;
////    circle.ratioFour = 0.2;
////    circle.ratioFive = 0.2;
//    
//    
//    UILabel *timeLabel = [[UILabel alloc]init];
//    [MiddleView addSubview:timeLabel];
//    timeLabel.backgroundColor = [UIColor clearColor];
//    timeLabel.text = NSLocalizedString(@"总运动时长", nil) ;
//    timeLabel.textAlignment = NSTextAlignmentCenter;
//    CGFloat timeLabelX = 0 ;
//    CGFloat timeLabelH = 20;
//    CGFloat timeLabelY = MiddleViewH / 2 - timeLabelH;
//    CGFloat timeLabelW = CurrentDeviceWidth / 2 - 30;
//    timeLabel.frame = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
//    timeLabel.centerX = MiddleView.centerX;
//    //    timeLabel.sd_layout.centerXEqualToView(10,MiddleView);
//    //    timeLabel.centerY = MiddleView.centerY - timeLabelH;
//    
//    
//    UILabel *timeLabelNumber = [[UILabel alloc]init];
//    [MiddleView addSubview:timeLabelNumber];
//    _timeLabelNumber = timeLabelNumber;
//    timeLabelNumber.backgroundColor = [UIColor clearColor];
//    timeLabelNumber.text = @"0min";
//    timeLabelNumber.textAlignment = NSTextAlignmentCenter;
//    CGFloat timeLabelNumberX = 0;
//    CGFloat timeLabelNumberH = 40;
//    CGFloat timeLabelNumberY = MiddleViewH / 2;
//    CGFloat timeLabelNumberW = timeLabelW;
//    timeLabelNumber.frame = CGRectMake(timeLabelNumberX, timeLabelNumberY, timeLabelNumberW, timeLabelNumberH);
//    timeLabelNumber.centerX = MiddleView.centerX;
//    //    timeLabelNumber.centerY = MiddleView.centerY + timeLabelNumberH;
//    [MiddleView sendSubviewToBack:circle];
//    
//}
//-(void)setupDownView
//{
//    UIView *DownView = [[UIView alloc]init];
//    [self.view addSubview:DownView];
//    DownView.backgroundColor = [UIColor whiteColor];
//    
//    CGFloat DownViewX = 0;
//    CGFloat DownViewW = CurrentDeviceWidth;
//    CGFloat DownViewH = (CurrentDeviceHeight - (_upView.height + 64)) / 2;
//    CGFloat DownViewY = CGRectGetMaxY(_upView.frame) + DownViewH;
//    DownView.frame = CGRectMake(DownViewX, DownViewY, DownViewW, DownViewH);
//    
//    CGFloat marginX = 10;
//    CGFloat marginY = 5;
//    
//    //第一条
//    UIView *oneView = [[UIView alloc]init];
//    [DownView addSubview:oneView];
//    oneView.backgroundColor = downBackColor;
//    //[UIColor whiteColor];
//    
//    CGFloat imageVW = 28;
//    CGFloat marginDuo = 20;
//    
//    
//    CGFloat oneViewX = marginX;
//    CGFloat oneViewY = 0;
//    CGFloat oneViewW = CurrentDeviceWidth - 2 * oneViewX;
//    CGFloat oneViewH = (DownViewH - 10 - 25) / 6;
//    oneView.frame = CGRectMake(oneViewX, oneViewY, oneViewW, oneViewH);
//    
//    UILabel *labelOne = [[UILabel alloc]init];
//    [oneView addSubview:labelOne];
//    labelOne.backgroundColor = [UIColor clearColor];
//    labelOne.textAlignment = NSTextAlignmentCenter;
//    labelOne.text = NSLocalizedString(@"运动类型", nil);
//    labelOne.font = [UIFont systemFontOfSize:fontNumber];
//    
//    CGFloat labelOneX = imageVW;
//    CGFloat labelOneY = 0;
//    CGFloat labelOneW = (oneView.width  - imageVW)/ 4;
//    CGFloat labelOneH = oneView.height;
//    labelOne.frame = CGRectMake(labelOneX, labelOneY, labelOneW, labelOneH);
//    
//    UILabel *labelTwo = [[UILabel alloc]init];
//    [oneView addSubview:labelTwo];
//    //    labelTwo.backgroundColor = [UIColor greenColor];
//    labelTwo.textAlignment = NSTextAlignmentCenter;
//    labelTwo.text = NSLocalizedString(@"心率区间", nil);
//    labelTwo.font = [UIFont systemFontOfSize:fontNumber];
//    
//    CGFloat labelTwoX = CGRectGetMaxX(labelOne.frame);
//    CGFloat labelTwoY = 0;
//    CGFloat labelTwoW = labelOneW + marginDuo;
//    CGFloat labelTwoH = oneView.height;
//    labelTwo.frame = CGRectMake(labelTwoX, labelTwoY, labelTwoW, labelTwoH);
//    
//    UILabel *labelThird = [[UILabel alloc]init];
//    [oneView addSubview:labelThird];
//    labelThird.backgroundColor = [UIColor clearColor];
//    labelThird.textAlignment = NSTextAlignmentCenter;
//    labelThird.text = NSLocalizedString(@"时长", nil);
//    labelThird.font = [UIFont systemFontOfSize:fontNumber];
//    
//    CGFloat labelThirdX = CGRectGetMaxX(labelTwo.frame);
//    CGFloat labelThirdY = 0;
//    CGFloat labelThirdW = (oneView.width  - CGRectGetMaxX(labelTwo.frame)) / 2;
//    CGFloat labelThirdH = oneView.height;
//    labelThird.frame = CGRectMake(labelThirdX, labelThirdY, labelThirdW, labelThirdH);
//    
//    UILabel *labelFourth = [[UILabel alloc]init];
//    [oneView addSubview:labelFourth];
//    labelFourth.backgroundColor = [UIColor clearColor];
//    labelFourth.textAlignment = NSTextAlignmentCenter;
//    labelFourth.text = NSLocalizedString(@"百分比", nil);
//    labelFourth.font = [UIFont systemFontOfSize:fontNumber];
//    
//    CGFloat labelFourthX = CGRectGetMaxX(labelThird.frame);
//    CGFloat labelFourthY = 0;
//    CGFloat labelFourthW = labelThirdW;
//    CGFloat labelFourthH = oneView.height;
//    labelFourth.frame = CGRectMake(labelFourthX, labelFourthY, labelFourthW, labelFourthH);
//    
//    //第二条
//    UIView *seconedView = [[UIView alloc]init];
//    [DownView addSubview:seconedView];
//    seconedView.backgroundColor = downBackColor;
//    
//    CGFloat seconedViewX = oneViewX;
//    CGFloat seconedViewY = CGRectGetMaxY(oneView.frame) + marginY;
//    CGFloat seconedViewW = oneViewW;
//    CGFloat seconedViewH = oneViewH;
//    seconedView.frame = CGRectMake(seconedViewX, seconedViewY, seconedViewW, seconedViewH);
//    
//    //第二条  前图
//    UIImageView *imageV = [[UIImageView alloc]init];
//    [seconedView addSubview:imageV];
//    imageV.image = [UIImage imageNamed:@"热身"];
//    imageV.backgroundColor = [UIColor clearColor];
//    CGFloat imageVX = 0;
//    //    CGFloat imageVW = 28;
//    CGFloat imageVH = 23;
//    CGFloat imageVY = (seconedViewH - imageVH)/2;
//    imageV.frame = CGRectMake(imageVX, imageVY, imageVW, imageVH);
//    
//    
//    UILabel *labelOneSeconed = [[UILabel alloc]init];
//    [seconedView addSubview:labelOneSeconed];
//    labelOneSeconed.backgroundColor = [UIColor clearColor];
//    labelOneSeconed.textAlignment = NSTextAlignmentCenter;
//    labelOneSeconed.text = NSLocalizedString(@"热身", nil);
//    labelOneSeconed.font = [UIFont systemFontOfSize:fontNumber];
//    CGFloat labelOneSeconedX = imageVW;
//    CGFloat labelOneSeconedY = 0;
//    CGFloat labelOneSeconedW = (seconedViewW - imageVW) / 4 ;
//    CGFloat labelOneSeconedH = oneView.height;
//    labelOneSeconed.frame = CGRectMake(labelOneSeconedX, labelOneSeconedY, labelOneSeconedW, labelOneSeconedH);
//    
//    UILabel *labelTwoSeconed = [[UILabel alloc]init];
//    [seconedView addSubview:labelTwoSeconed];
//    _labelTwoSeconed = labelTwoSeconed;
//    //    labelTwoSeconed.backgroundColor = [UIColor greenColor];
//    labelTwoSeconed.textAlignment = NSTextAlignmentCenter;
//    labelTwoSeconed.text = @"<=150bpm";
//    labelTwoSeconed.font = [UIFont systemFontOfSize:fontNumber];
//    CGFloat labelTwoSeconedX = CGRectGetMaxX(labelOneSeconed.frame);
//    CGFloat labelTwoSeconedY = 0;
//    CGFloat labelTwoSeconedW = labelTwoW;
//    CGFloat labelTwoSeconedH = oneView.height;
//    labelTwoSeconed.frame = CGRectMake(labelTwoSeconedX, labelTwoSeconedY, labelTwoSeconedW, labelTwoSeconedH);
//    
//    UILabel *labelThirdSeconed = [[UILabel alloc]init];
//    [seconedView addSubview:labelThirdSeconed];
//    _labelThirdSeconed = labelThirdSeconed;
//    labelThirdSeconed.backgroundColor = [UIColor clearColor];
//    labelThirdSeconed.textAlignment = NSTextAlignmentCenter;
//    labelThirdSeconed.text = @"0min";
//    labelThirdSeconed.font = [UIFont systemFontOfSize:fontNumber];
//    CGFloat labelThirdSeconedX = labelThirdX;
//    CGFloat labelThirdSeconedY = 0;
//    CGFloat labelThirdSeconedW = labelThirdW;
//    CGFloat labelThirdSeconedH = oneView.height;
//    labelThirdSeconed.frame = CGRectMake(labelThirdSeconedX, labelThirdSeconedY, labelThirdSeconedW, labelThirdSeconedH);
//    
//    UILabel *labelFourthSeconed = [[UILabel alloc]init];
//    [seconedView addSubview:labelFourthSeconed];
//    _labelFourthSeconed = labelFourthSeconed;
//    labelFourthSeconed.backgroundColor = [UIColor clearColor];
//    labelFourthSeconed.textAlignment = NSTextAlignmentCenter;
//    labelFourthSeconed.text = @"0%";
//    labelFourthSeconed.font = [UIFont systemFontOfSize:fontNumber];
//    CGFloat labelFourthSeconedX = CGRectGetMaxX(labelThirdSeconed.frame);
//    CGFloat labelFourthSeconedY = 0;
//    CGFloat labelFourthSeconedW = labelThirdSeconedW;
//    CGFloat labelFourthSeconedH = oneView.height;
//    labelFourthSeconed.frame = CGRectMake(labelFourthSeconedX, labelFourthSeconedY, labelFourthSeconedW, labelFourthSeconedH);
//    
//    
//    //第三条
//    UIView *thirdView = [[UIView alloc]init];
//    [DownView addSubview:thirdView];
//    thirdView.backgroundColor = downBackColor;
//    CGFloat thirdViewX = seconedViewX;
//    CGFloat thirdViewY = CGRectGetMaxY(seconedView.frame) + marginY;
//    CGFloat thirdViewW = seconedViewW;
//    CGFloat thirdViewH = seconedViewH;
//    thirdView.frame = CGRectMake(thirdViewX, thirdViewY, thirdViewW, thirdViewH);
//    
//    //第三条  前图
//    UIImageView *imageVthird = [[UIImageView alloc]init];
//    [thirdView addSubview:imageVthird];
//    imageVthird.image = [UIImage imageNamed:@"有氧"];
//    imageVthird.backgroundColor = [UIColor clearColor];
//    CGFloat imageVthirdX = 0;
//    CGFloat imageVthirdW = imageVW;
//    CGFloat imageVthirdH = imageVH;
//    CGFloat imageVthirdY = (thirdViewH - imageVthirdH)/2;
//    imageVthird.frame = CGRectMake(imageVthirdX, imageVthirdY, imageVthirdW, imageVthirdH);
//    
//    
//    UILabel *labelOneThird = [[UILabel alloc]init];
//    [thirdView addSubview:labelOneThird];
//    labelOneThird.backgroundColor = [UIColor clearColor];
//    labelOneThird.textAlignment = NSTextAlignmentCenter;
//    labelOneThird.text = NSLocalizedString(@"燃脂", nil);
//    labelOneThird.font = [UIFont systemFontOfSize:fontNumber];
//    CGFloat labelOneThirdX = imageVW;
//    CGFloat labelOneThirdY = 0;
//    CGFloat labelOneThirdW = (thirdViewW - imageVthirdW) / 4 ;
//    CGFloat labelOneThirdH = oneView.height;
//    labelOneThird.frame = CGRectMake(labelOneThirdX, labelOneThirdY, labelOneThirdW, labelOneThirdH);
//    
//    UILabel *labelTwoThird = [[UILabel alloc]init];
//    [thirdView addSubview:labelTwoThird];
//    _labelTwoThird = labelTwoThird;
//    //    labelTwoThird.backgroundColor = [UIColor greenColor];
//    labelTwoThird.textAlignment = NSTextAlignmentCenter;
//    labelTwoThird.text = @"115-130bpm";
//    labelTwoThird.font = [UIFont systemFontOfSize:fontNumber];
//    CGFloat labelTwoThirdX = CGRectGetMaxX(labelOneThird.frame);
//    CGFloat labelTwoThirdY = 0;
//    CGFloat labelTwoThirdW = labelTwoW;
//    CGFloat labelTwoThirdH = oneView.height;
//    labelTwoThird.frame = CGRectMake(labelTwoThirdX, labelTwoThirdY, labelTwoThirdW, labelTwoThirdH);
//    
//    UILabel *labelThirdThird = [[UILabel alloc]init];
//    [thirdView addSubview:labelThirdThird];
//    _labelThirdThird = labelThirdThird;
//    labelThirdThird.backgroundColor = [UIColor clearColor];
//    labelThirdThird.textAlignment = NSTextAlignmentCenter;
//    labelThirdThird.text = @"0min";
//    labelThirdThird.font = [UIFont systemFontOfSize:fontNumber];
//    CGFloat labelThirdThirdX =  labelThirdX;
//    CGFloat labelThirdThirdY = 0;
//    CGFloat labelThirdThirdW = labelThirdW;
//    CGFloat labelThirdThirdH = oneView.height;
//    labelThirdThird.frame = CGRectMake(labelThirdThirdX, labelThirdThirdY, labelThirdThirdW, labelThirdThirdH);
//    
//    UILabel *labelFourthThird = [[UILabel alloc]init];
//    [thirdView addSubview:labelFourthThird];
//    _labelFourthThird = labelFourthThird;
//    labelFourthThird.backgroundColor = [UIColor clearColor];
//    labelFourthThird.textAlignment = NSTextAlignmentCenter;
//    labelFourthThird.text = @"0%";
//    labelFourthThird.font = [UIFont systemFontOfSize:fontNumber];
//    CGFloat labelFourthThirdX = CGRectGetMaxX(labelThirdThird.frame);
//    CGFloat labelFourthThirdY = 0;
//    CGFloat labelFourthThirdW = labelThirdThirdW;
//    CGFloat labelFourthThirdH = oneView.height;
//    labelFourthThird.frame = CGRectMake(labelFourthThirdX, labelFourthThirdY, labelFourthThirdW, labelFourthThirdH);
//    
//    
//    //第四条
//    UIView *fourthView = [[UIView alloc]init];
//    [DownView addSubview:fourthView];
//    fourthView.backgroundColor = downBackColor;
//    CGFloat fourthViewX = thirdViewX;
//    CGFloat fourthViewY = CGRectGetMaxY(thirdView.frame) + marginY;
//    CGFloat fourthViewW = thirdViewW;
//    CGFloat fourthViewH = thirdViewH;
//    fourthView.frame = CGRectMake(fourthViewX, fourthViewY, fourthViewW, fourthViewH);
//    
//    //第四条  前图
//    UIImageView *imageVFourth = [[UIImageView alloc]init];
//    [fourthView addSubview:imageVFourth];
//    imageVFourth.image = [UIImage imageNamed:@"无氧-"];
//    imageVFourth.backgroundColor = [UIColor clearColor];
//    CGFloat imageVFourthX = 0;
//    CGFloat imageVFourthW = imageVW;
//    CGFloat imageVFourthH = imageVH;
//    CGFloat imageVFourthY = (fourthViewH - imageVFourthH)/2;
//    imageVFourth.frame = CGRectMake(imageVFourthX, imageVFourthY, imageVFourthW, imageVFourthH);
//    
//    
//    UILabel *labelOneFourth = [[UILabel alloc]init];
//    [fourthView addSubview:labelOneFourth];
//    labelOneFourth.backgroundColor = [UIColor clearColor];
//    labelOneFourth.textAlignment = NSTextAlignmentCenter;
//    labelOneFourth.text = NSLocalizedString(@"有氧", nil);
//    labelOneFourth.font = [UIFont systemFontOfSize:fontNumber];
//    CGFloat labelOneFourthX = imageVW;
//    CGFloat labelOneFourthY = 0;
//    CGFloat labelOneFourthW = (fourthViewW - imageVFourthW) / 4 ;
//    CGFloat labelOneFourthH = oneView.height;
//    labelOneFourth.frame = CGRectMake(labelOneFourthX, labelOneFourthY, labelOneFourthW, labelOneFourthH);
//    
//    UILabel *labelTwoFourth = [[UILabel alloc]init];
//    [fourthView addSubview:labelTwoFourth];
//    _labelTwoFourth = labelTwoFourth;
//    labelTwoFourth.backgroundColor = [UIColor clearColor];
//    labelTwoFourth.textAlignment = NSTextAlignmentCenter;
//    labelTwoFourth.text = @"130-150bpm";
//    labelTwoFourth.font = [UIFont systemFontOfSize:fontNumber];
//    CGFloat labelTwoFourthX = CGRectGetMaxX(labelOneFourth.frame);
//    CGFloat labelTwoFourthY = 0;
//    CGFloat labelTwoFourthW = labelTwoW;
//    CGFloat labelTwoFourthH = oneView.height;
//    labelTwoFourth.frame = CGRectMake(labelTwoFourthX, labelTwoFourthY, labelTwoFourthW, labelTwoFourthH);
//    
//    UILabel *labelThirdFourth = [[UILabel alloc]init];
//    [fourthView addSubview:labelThirdFourth];
//    _labelThirdFourth = labelThirdFourth;
//    labelThirdFourth.backgroundColor = [UIColor clearColor];
//    labelThirdFourth.textAlignment = NSTextAlignmentCenter;
//    labelThirdFourth.text = @"0min";
//    labelThirdFourth.font = [UIFont systemFontOfSize:fontNumber];
//    CGFloat labelThirdFourthX = labelThirdX;
//    CGFloat labelThirdFourthY = 0;
//    CGFloat labelThirdFourthW = labelThirdW;
//    CGFloat labelThirdFourthH = oneView.height;
//    labelThirdFourth.frame = CGRectMake(labelThirdFourthX, labelThirdFourthY, labelThirdFourthW, labelThirdFourthH);
//    
//    UILabel *labelFourthFourth = [[UILabel alloc]init];
//    [fourthView addSubview:labelFourthFourth];
//    _labelFourthFourth = labelFourthFourth;
//    labelFourthFourth.backgroundColor = [UIColor clearColor];
//    labelFourthFourth.textAlignment = NSTextAlignmentCenter;
//    labelFourthFourth.text = @"0%";
//    labelFourthFourth.font = [UIFont systemFontOfSize:fontNumber];
//    CGFloat labelFourthFourthX = CGRectGetMaxX(labelThirdThird.frame);
//    CGFloat labelFourthFourthY = 0;
//    CGFloat labelFourthFourthW = labelThirdFourthW;
//    CGFloat labelFourthFourthH = oneView.height;
//    labelFourthFourth.frame = CGRectMake(labelFourthFourthX, labelFourthFourthY, labelFourthFourthW, labelFourthFourthH);
//    
//    
//    //第五条
//    UIView * fifthView = [[UIView alloc]init];
//    [DownView addSubview: fifthView];
//    fifthView.backgroundColor = downBackColor;
//    
//    CGFloat fifthViewX = fourthViewX;
//    CGFloat fifthViewY = CGRectGetMaxY(fourthView.frame) + marginY;
//    CGFloat fifthViewW = fourthViewW;
//    CGFloat fifthViewH = fourthViewH;
//    fifthView.frame = CGRectMake(fifthViewX, fifthViewY, fifthViewW, fifthViewH);
//    
//    
//    //第五条  前图
//    UIImageView *imageVFifth = [[UIImageView alloc]init];
//    [fifthView addSubview:imageVFifth];
//    imageVFifth.image = [UIImage imageNamed:@"燃脂"];
//    imageVFifth.backgroundColor = [UIColor clearColor];
//    CGFloat imageVFifthX = 0;
//    CGFloat imageVFifthW = imageVW;
//    CGFloat imageVFifthH = imageVH;
//    CGFloat imageVFifthY = (fifthViewH - imageVFifthH)/2;
//    imageVFifth.frame = CGRectMake(imageVFifthX, imageVFifthY, imageVFifthW, imageVFifthH);
//    
//    
//    UILabel *labelOneFifth = [[UILabel alloc]init];
//    [fifthView addSubview:labelOneFifth];
//    labelOneFifth.backgroundColor = [UIColor clearColor];
//    labelOneFifth.textAlignment = NSTextAlignmentCenter;
//    labelOneFifth.text = NSLocalizedString(@"无氧", nil);
//    labelOneFifth.font = [UIFont systemFontOfSize:fontNumber];
//    CGFloat labelOneFifthX = imageVW;
//    CGFloat labelOneFifthY = 0;
//    CGFloat labelOneFifthW = (fifthViewW - imageVFourthW) / 4 ;
//    CGFloat labelOneFifthH = oneView.height;
//    labelOneFifth.frame = CGRectMake(labelOneFifthX, labelOneFifthY, labelOneFifthW, labelOneFifthH);
//    
//    UILabel *labelTwoFifth = [[UILabel alloc]init];
//    [fifthView addSubview:labelTwoFifth];
//    _labelTwoFifth = labelTwoFifth;
//    labelTwoFifth.backgroundColor = [UIColor clearColor];
//    labelTwoFifth.textAlignment = NSTextAlignmentCenter;
//    labelTwoFifth.text = @"150-170bpm";
//    labelTwoFifth.font = [UIFont systemFontOfSize:fontNumber];
//    CGFloat labelTwoFifthX = CGRectGetMaxX(labelOneFourth.frame);
//    CGFloat labelTwoFifthY = 0;
//    CGFloat labelTwoFifthW = labelTwoW;
//    CGFloat labelTwoFifthH = oneView.height;
//    labelTwoFifth.frame = CGRectMake(labelTwoFifthX, labelTwoFifthY, labelTwoFifthW, labelTwoFifthH);
//    
//    UILabel *labelThirdFifth = [[UILabel alloc]init];
//    [fifthView addSubview:labelThirdFifth];
//    _labelThirdFifth = labelThirdFifth;
//    labelThirdFifth.backgroundColor = [UIColor clearColor];
//    labelThirdFifth.textAlignment = NSTextAlignmentCenter;
//    labelThirdFifth.text = @"0min";
//    labelThirdFifth.font = [UIFont systemFontOfSize:fontNumber];
//    CGFloat labelThirdFifthX = labelThirdX;
//    CGFloat labelThirdFifthY = 0;
//    CGFloat labelThirdFifthW = labelThirdW;
//    CGFloat labelThirdFifthH = oneView.height;
//    labelThirdFifth.frame = CGRectMake(labelThirdFifthX, labelThirdFifthY, labelThirdFifthW, labelThirdFifthH);
//    
//    UILabel *labelFourthFifth = [[UILabel alloc]init];
//    [fifthView addSubview:labelFourthFifth];
//    _labelFourthFifth = labelFourthFifth;
//    labelFourthFifth.backgroundColor = [UIColor clearColor];
//    labelFourthFifth.textAlignment = NSTextAlignmentCenter;
//    labelFourthFifth.text = @"0%";
//    labelFourthFifth.font = [UIFont systemFontOfSize:fontNumber];
//    CGFloat labelFourthFifthX = CGRectGetMaxX(labelThirdThird.frame);
//    CGFloat labelFourthFifthY = 0;
//    CGFloat labelFourthFifthW = labelThirdThirdW;
//    CGFloat labelFourthFifthH = oneView.height;
//    labelFourthFifth.frame = CGRectMake(labelFourthFifthX, labelFourthFifthY, labelFourthFifthW, labelFourthFifthH);
//    
//    //第六条
//    UIView *Sixth = [[UIView alloc]init];
//    [DownView addSubview:Sixth];
//    Sixth.backgroundColor = downBackColor;
//    CGFloat SixthX = fifthViewX;
//    CGFloat SixthY = CGRectGetMaxY(fifthView.frame) + marginY;
//    CGFloat SixthW = fifthViewW;
//    CGFloat SixthH = fifthViewH;
//    Sixth.frame = CGRectMake(SixthX, SixthY, SixthW, SixthH);
//    //第六条  前图
//    UIImageView *imageVSixth = [[UIImageView alloc]init];
//    [Sixth addSubview:imageVSixth];
//    imageVSixth.image = [UIImage imageNamed:@"极限"];
//    imageVSixth.backgroundColor = [UIColor clearColor];
//    CGFloat imageVSixthX = 0;
//    CGFloat imageVSixthW = imageVW;
//    CGFloat imageVSixthH = imageVH;
//    CGFloat imageVSixthY = (SixthH - imageVSixthH)/2;
//    imageVSixth.frame = CGRectMake(imageVSixthX, imageVSixthY, imageVSixthW, imageVSixthH);
//    
//    
//    UILabel *labelOneSixth = [[UILabel alloc]init];
//    [Sixth addSubview:labelOneSixth];
//    labelOneSixth.backgroundColor = [UIColor clearColor];
//    labelOneSixth.textAlignment = NSTextAlignmentCenter;
//    labelOneSixth.text = NSLocalizedString(@"极限", nil);
//    labelOneSixth.font = [UIFont systemFontOfSize:fontNumber];
//    CGFloat labelOneSixthX = imageVW;
//    CGFloat labelOneSixthY = 0;
//    CGFloat labelOneSixthW = (SixthW - imageVFourthW) / 4 ;
//    CGFloat labelOneSixthH = oneView.height;
//    labelOneSixth.frame = CGRectMake(labelOneSixthX, labelOneSixthY, labelOneSixthW, labelOneSixthH);
//    
//    UILabel *labelTwoSixth = [[UILabel alloc]init];
//    [Sixth addSubview:labelTwoSixth];
//    _labelTwoSixth = labelTwoSixth;
//    labelTwoSixth.backgroundColor = [UIColor clearColor];
//    labelTwoSixth.textAlignment = NSTextAlignmentCenter;
//    labelTwoSixth.text = @"170-190bpm";
//    labelTwoSixth.font = [UIFont systemFontOfSize:fontNumber];
//    CGFloat labelTwoSixthX = CGRectGetMaxX(labelOneFourth.frame);
//    CGFloat labelTwoSixthY = 0;
//    CGFloat labelTwoSixthW = labelTwoW;
//    CGFloat labelTwoSixthH = oneView.height;
//    labelTwoSixth.frame = CGRectMake(labelTwoSixthX, labelTwoSixthY, labelTwoSixthW, labelTwoSixthH);
//    
//    UILabel *labelThirdSixth = [[UILabel alloc]init];
//    [Sixth addSubview:labelThirdSixth];
//    _labelThirdSixth = labelThirdSixth;
//    labelThirdSixth.backgroundColor = [UIColor clearColor];
//    labelThirdSixth.textAlignment = NSTextAlignmentCenter;
//    labelThirdSixth.text = @"0min";
//    labelThirdSixth.font = [UIFont systemFontOfSize:fontNumber];
//    CGFloat labelThirdSixthX = labelThirdX;
//    CGFloat labelThirdSixthY = 0;
//    CGFloat labelThirdSixthW = labelThirdW;
//    CGFloat labelThirdSixthH = oneView.height;
//    labelThirdSixth.frame = CGRectMake(labelThirdSixthX, labelThirdSixthY, labelThirdSixthW, labelThirdSixthH);
//    
//    UILabel *labelFourthSixth = [[UILabel alloc]init];
//    [Sixth addSubview:labelFourthSixth];
//    _labelFourthSixth = labelFourthSixth;
//    labelFourthSixth.backgroundColor = [UIColor clearColor];
//    labelFourthSixth.textAlignment = NSTextAlignmentCenter;
//    labelFourthSixth.text = @"0%";
//    labelFourthSixth.font = [UIFont systemFontOfSize:fontNumber];
//    CGFloat labelFourthSixthX = CGRectGetMaxX(labelThirdThird.frame);
//    CGFloat labelFourthSixthY = 0;
//    CGFloat labelFourthSixthW = labelThirdSixthW;
//    CGFloat labelFourthSixthH = oneView.height;
//    labelFourthSixth.frame = CGRectMake(labelFourthSixthX, labelFourthSixthY, labelFourthSixthW, labelFourthSixthH);
//    
//}
//-(void)setSport:(SportModel *)sport
//{
//    if (sport) {
//        _sport = sport;
////        _seconedLabeltwo.attributedText = [NSAttributedString  makeAttributedStringWithnumBer:sport.kcalNumber Unit:@"kcal" WithFont:fontNumberDa];
//    }
////    [self  setupHeartSection]; //心率区间 setup
////    if (_sport.sportName) {
////        self.titleLabel.text = _sport.sportName;
////    } else {
////        if (_titleLabel) {
////            _titleLabel.text = [self setupTitle];
////        }
////    }
//}
//#pragma  mark  - - 私有方法
//-(void)backActionDetail
//{
//    //adaLog(@"退出");
////    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
//}
//#pragma  mark  - - init   property
//-(void)initProperty
//{
//    _date = [[NSDate alloc]init];
//}
//- (void)didReceiveMemoryWarning {  [super didReceiveMemoryWarning]; }
//
//-(UILabel *)titleLabel
//{
//    if (!_titleLabel) {
//        _titleLabel = [[UILabel alloc]init];
//        //    [headView addSubview:titleLabel];
//        _titleLabel.backgroundColor = [UIColor clearColor];
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        //    _titleLabel = titleLabel;
//        CGFloat titleLabelX = 0;
//        CGFloat titleLabelY = 0;
//        CGFloat titleLabelW = 220;
//        CGFloat titleLabelH = 30;
//        _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
//    }
//    return _titleLabel;
//}
//-(UIView *)headView
//{
//    if (!_headView) {
//        _headView = [[UIView alloc]init];
//        [self.view addSubview:_headView];
//        CGFloat headViewX = 0;
//        CGFloat headViewY = 20;
//        CGFloat headViewW = CurrentDeviceWidth;
//        CGFloat headViewH = 44;
//        _headView.frame = CGRectMake(headViewX, headViewY, headViewW, headViewH);
//        _headView.backgroundColor = allColorWhite;
//        
//    }
//    return _headView;
//}
//
//@end

//
//  TodaySleepDetailViewController.m
//  Mistep
//
//  Created by 迈诺科技 on 2016/11/14.
//  Copyright © 2016年 huichenghe. All rights reserved.
//
#define deepColor kColor(53,84,223)
#define lightColor kColor(36,228,242)
#define awakeColor kColor(252,125,12)
#define downBackColor kColor(230,240,249)

#define fontSizeSleep  22

#import "TodaySleepDetailViewController.h"
#import "NSAttributedString+appendAttributedString.h"
#import "SleepTool.h"

@interface TodaySleepDetailViewController ()
//上层视图。深睡，浅睡，清醒
@property (strong, nonatomic) NSDictionary *detailDic;
@property (strong, nonatomic) NSMutableArray *sleepArray;
//@property (assign, nonatomic) int second;
@property (strong, nonatomic) UIImageView *sleepView;
@property (strong, nonatomic) UIImageView *imageViewBed;
@property (strong, nonatomic) UILabel *deepLabel;
@property (strong, nonatomic) UILabel *EasyLabel;
@property (strong, nonatomic) UILabel *AwakeLabel;
//下层视图。夜间心率
@property (strong, nonatomic) NSMutableArray *nightHeartArray;
@property (strong, nonatomic) UIScrollView *nightHeartScrollView;
@property (strong, nonatomic) UIView *nightHeartVIew;
@property (strong, nonatomic) UILabel *day220;//day220  多出来的部分
@property (strong, nonatomic) UILabel *avgHeartLabNumber;
@property (strong, nonatomic) UILabel *maxHeartLabNumberNumber;
@end

@implementation TodaySleepDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //    [self childrenTimeSecondChanged];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[PSDrawerManager instance] cancelDragResponse];
    [self childrenTimeSecondChanged];
}
- (void)childrenTimeSecondChanged
{
    [self reloadDataWithInternet];
}
-(void)initVariable
{
    _detailDic = [NSDictionary dictionary];
    _sleepArray = [NSMutableArray array];
    _nightHeartArray = [NSMutableArray array];
}
-(void)reloadDataWithInternet
{
     [self reloadData];// 睡眠数据
    //   用户 上传下行，，查看数据
//    if([AllTool isDirectUse])
//    {
//        [self reloadData];
//    }
//    else
//    {
//        //蓝牙没有连接就查询服务器
//        if ([CositeaBlueTooth sharedInstance].isConnected)
//        {
//            // 睡眠数据
//            NSDictionary *todayDic =  [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:kHCH.selectTimeSeconds];
//            NSDictionary *lastDayDic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:kHCH.selectTimeSeconds - KONEDAYSECONDS];
//            if (todayDic&&lastDayDic)
//            {
//                [self reloadData];
//            }
//            else if (todayDic&&!lastDayDic)
//            {
//                [self performSelector:@selector(reloadData) withObject:nil afterDelay:1.0f];
//                WeakSelf;
//                [TimingUploadData downSleepDataADay:^(NSDictionary *dict, NSDictionary *dictionary) {
//                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadData) object:nil];
//                    [weakSelf reloadData];
//                } date:kHCH.selectTimeSeconds-KONEDAYSECONDS];
//            }
//            else if (!todayDic&&lastDayDic)
//            {
//                [self performSelector:@selector(reloadData) withObject:nil afterDelay:1.0f];
//                WeakSelf;
//                [TimingUploadData downSleepDataADay:^(NSDictionary *dict, NSDictionary *dictionary) {
//                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadData) object:nil];
//                    [weakSelf reloadData];
//                } date:kHCH.selectTimeSeconds];
//            }
//            else
//            {
//                [self performSelector:@selector(reloadData) withObject:nil afterDelay:1.0f];
//                WeakSelf;
//                [TimingUploadData  downSleepData:^(NSDictionary *todayDic,NSDictionary *lastDayDic) {
//                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadData) object:nil];
//                    [weakSelf reloadData];
//                } date:kHCH.selectTimeSeconds];
//            }
//        }
//        else
//        {
//            [self performSelector:@selector(reloadData) withObject:nil afterDelay:1.0f];
//            WeakSelf;
//            [TimingUploadData  downSleepData:^(NSDictionary *todayDic,NSDictionary *lastDayDic) {
//                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadData) object:nil];
//                [weakSelf reloadData];
//            } date:kHCH.selectTimeSeconds];
//        }
//    }
}
- (void)reloadData
{
    _detailDic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:kHCH.selectTimeSeconds];
    [_sleepArray removeAllObjects];
    NSDictionary *lastDayDic= [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:kHCH.selectTimeSeconds - KONEDAYSECONDS];
    
    NSMutableArray * lastDaySleepArray = [SleepTool lastDaySleepDataWithDictionary:lastDayDic];
    
    [_sleepArray addObjectsFromArray:lastDaySleepArray];
    
    NSArray *todaySleepArray = [SleepTool todayDaySleepDataWithDictionary:_detailDic];
    [_sleepArray addObjectsFromArray:todaySleepArray];
    
     _sleepArray = [AllTool filterSleepToValid:_sleepArray];//过滤清醒成浅睡
    
    [self updateView];
    
}
- (void)updateView
{
    
    [self drawSleepView];
    //    [self drawHeartView];
    //    [self updateLabels];
    
}

- (void)drawSleepView
{
//#warning mark  测试数据的显示
//    [_sleepArray removeAllObjects];
//    _sleepArray = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"2",@"2",@"2",@"2",@"2",@"3",@"3",@"3",@"3",@"2",@"2",@"2",@"2",@"2",@"3",@"2",@"2",@"2",@"2",@"1",@"2",@"2",@"2",@"2",@"2",@"2",@"1",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"1",@"1",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"3",@"2",@"2",@"2",@"2",@"2",@"3",@"3",@"3",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0" ]];
    
    for(UIView *view in _imageViewBed.subviews)
    {
        if (view.tag == 100)
        {
            [view removeFromSuperview];
        }
    }
    for(UIView *view in _sleepView.subviews)
    {
        if (view.tag == 100)    [view removeFromSuperview];
        
    }
    int nightBeginTime = 0;
    int nightEndTime = 0;
    BOOL isBegin = NO;
    int lightSleep = 0;
    int deepSleep = 0;
    int awake = 0;
    for (int i = 0; i < _sleepArray.count; i ++)
    {
        int sleepState = [_sleepArray[i] intValue];
        if (sleepState != 0 && sleepState != 3)
        {
            if (isBegin == NO)
            {
                isBegin = YES;
                nightBeginTime = i;
            }
            nightEndTime = i;
        }
    }
    
    
    if (_sleepArray && _sleepArray.count != 0)
    {
        if (nightEndTime > nightBeginTime)
        {
            CGFloat viewMargin = 22*WidthProportion;
            CGFloat viewMarginBed = 12*WidthProportion;
            CGFloat viewX = 0;
            CGFloat viewW = ((float)_imageViewBed.width-2*viewMarginBed)/(nightEndTime - nightBeginTime+1);
            CGFloat viewY = 80;
            CGFloat viewH = (CurrentDeviceHeight - 64) / 4;
            for (int i = nightBeginTime ; i <= nightEndTime; i ++)
            {
                int state = [_sleepArray[i] intValue];
                UIView *view = [[UIView alloc]init];
                view.tag = 100;
                [_sleepView addSubview:view];
                if (state == 2 )
                {
                    view.backgroundColor = deepColor;
                    deepSleep ++;
                    viewH = (CurrentDeviceHeight - 64) / 4;
                    
                }else if (state == 1)
                {
                    view.backgroundColor = lightColor;
                    lightSleep ++;
                    viewH = (CurrentDeviceHeight - 64) / 4 * 0.6;
                }
                else if (state == 0 || state == 3)
                {
                    view.backgroundColor = awakeColor;
                    awake ++;
                    viewH = (CurrentDeviceHeight - 64) / 4 * 0.32;
                }
                
                viewX = viewMargin + (i-nightBeginTime)*((float)_imageViewBed.width-2*viewMarginBed)/(nightEndTime - nightBeginTime+1);
                viewY = CGRectGetMaxY(_imageViewBed.frame) - _imageViewBed.height *2 / 3 - viewH;
                view.frame=CGRectMake(viewX, viewY,viewW,viewH);
                
            }
            NSArray *timeArray = nil;
            nightEndTime += 1;
            if (nightEndTime - nightBeginTime >= 3)
            {
                int firstTime = nightBeginTime + (nightEndTime - nightBeginTime)/3;
                int secondTime = nightBeginTime + (nightEndTime - nightBeginTime)/3*2;
                timeArray = @[[NSNumber numberWithInt:nightBeginTime],[NSNumber numberWithInt:firstTime],[NSNumber numberWithInt:secondTime],[NSNumber numberWithInt:nightEndTime]];
                CGFloat labelX = 0;
                CGFloat labelW = 35;
                CGFloat labelH = 15 * HeightProportion;
                CGFloat labelY = _imageViewBed.height/2;
                for (int i = 0; i < timeArray.count; i ++)
                {
                    UILabel *label = [[UILabel alloc] init];
                    label.font = [UIFont systemFontOfSize:12];
                    label.textColor = [UIColor blackColor];
                    label.tag = 100;
                    int index = [timeArray[i] intValue];
                    int time = 0;
                    if (index < 12)
                    {
                        time = 22+index/6;
                    }
                    else
                    {
                        time = (index - 12)/6;
                    }
                    int min = index%6*10;
                    label.text = [NSString stringWithFormat:@"%d:%02d",time,min];
                    [_imageViewBed addSubview:label];
                    label.textAlignment = NSTextAlignmentCenter;
                    
                    labelX = (_imageViewBed.width - 35)/3*i;
                    label.frame = CGRectMake(labelX, labelY, labelW, labelH);
                    
                    //                    label.sd_layout.leftSpaceToView(_sleepView,(CurrentDeviceWidth - 35)/3*i)
                    //                    .bottomSpaceToView(_sleepView,23)
                    //                    .widthIs(35)
                    //                    .heightIs(15);
                }
            }
            else
            {
                timeArray = @[[NSNumber numberWithInt:nightBeginTime],[NSNumber numberWithInt:nightEndTime]];
                CGFloat labelX = 0;
                CGFloat labelW = 35;
                CGFloat labelH = 15 * HeightProportion;
                CGFloat labelY = _imageViewBed.height/2;
                for (int i = 0; i < timeArray.count; i ++)
                {
                    UILabel *label = [[UILabel alloc] init];
                    label.font = [UIFont systemFontOfSize:12];
                    label.textColor = [UIColor blackColor];
                    label.tag = 100;
                    int index = [timeArray[i] intValue];
                    int time = 0;
                    if (index < 12)
                    {
                        time = 22+index/6;
                    }
                    else
                    {
                        time = (index - 12)/6;
                    }
                    int min = index%6*10;
                    label.text = [NSString stringWithFormat:@"%d:%02d",time,min];
                    label.textAlignment = NSTextAlignmentCenter;
                    [_imageViewBed addSubview:label];
                    labelX = (_imageViewBed.width - 35)/3*i;
                    label.frame = CGRectMake(labelX, labelY, labelW, labelH);
                    
                    //                    label.sd_layout.leftSpaceToView(_sleepView,(CurrentDeviceWidth - 35)*i)
                    //                    .bottomSpaceToView(_sleepView,23)
                    //                    .widthIs(35)
                    //                    .heightIs(15);
                }
                
            }
        }
    }
    
    _deepLabel.attributedText = [self getHandMinAttributeStringWithNumber:deepSleep * 10];
  
    _EasyLabel.attributedText = [self getHandMinAttributeStringWithNumber:lightSleep * 10];;
    
    _AwakeLabel.attributedText = [self getHandMinAttributeStringWithNumber:awake * 10];;
    
    [self.sleepView addSubview:_imageViewBed];
    [self drawNightHeartViewWithBeginTime:nightBeginTime EndTime:nightEndTime];
    
}


- (void)drawNightHeartViewWithBeginTime:(int)beginTime EndTime:(int)endTime
{
    [_nightHeartArray removeAllObjects];
    for (UIView *view in _nightHeartScrollView.subviews)
    {
        [view removeFromSuperview];
    }
    if (beginTime == endTime)
    {
        return;
    }
    beginTime = beginTime*10;
    endTime = endTime *10;
    NSDictionary *heartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:kHCH.selectTimeSeconds - KONEDAYSECONDS + 8 ];
    
    NSArray *array =  [NSKeyedUnarchiver unarchiveObjectWithData:heartDic[HeartRate_ActualData_HCH]];
    //只是去后面两个小时
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    NSRange range = NSMakeRange(0, mutableArray.count/3);
    [mutableArray removeObjectsInRange:range];
    
    NSMutableArray *tempArray = [NSMutableArray new];
    if (array && array.count != 0)
    {
        [tempArray addObjectsFromArray:mutableArray];
    }
    else
    {
        for (int i = 0 ; i < 120; i ++) //晚上九点到十二点
        {
            [tempArray addObject:[NSNumber numberWithInt:0]];
        }
    }
    for (int i = 1 ; i < 5; i ++)
    {
        if( i == 4 )
        {   //只是取前十个小时
            NSDictionary *nightHeartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:kHCH.selectTimeSeconds+i];
            NSArray *array1 = [NSKeyedUnarchiver unarchiveObjectWithData:nightHeartDic[HeartRate_ActualData_HCH]];
            NSMutableArray *mutableArray1 = [NSMutableArray arrayWithArray:array1];
            NSRange range1 = NSMakeRange(mutableArray1.count/ 3, mutableArray1.count/3 *2);
            [mutableArray1 removeObjectsInRange:range1];
            if (array && array.count != 0)
            {
                [tempArray addObjectsFromArray:mutableArray1];
            }
            else
            {
                for (int i = 0 ; i < 60; i ++)
                {
                    [tempArray addObject:[NSNumber numberWithInt:0]];
                }
            }
            
        }
        else
        {
            NSDictionary *nightHeartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:kHCH.selectTimeSeconds+i];
            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:nightHeartDic[HeartRate_ActualData_HCH]];
            if (array && array.count != 0&&(!((array.count==1)&&([array[0]isEqualToString:@""]))))
            {
                [tempArray addObjectsFromArray:array];
            }
            else
            {
                for (int i = 0 ; i < 180; i ++)
                {
                    [tempArray addObject:[NSNumber numberWithInt:0]];
                }
            }
        }
    }
    
    
    for (int i = beginTime; i < endTime; i ++)
    {
        if(tempArray[i])
        {
            [_nightHeartArray addObject:tempArray[i]];
        }
        else
        {
        }
    }
    
    int maxNightHeart = 0;
    int totalNightHeart = 0;
    int nightHeartCount = 0;
    for (int i = 0 ; i < _nightHeartArray.count ; i ++)
    {
        int nightHeart = [_nightHeartArray[i] intValue];
        if (maxNightHeart < nightHeart)
        {
            maxNightHeart = nightHeart;
        }
        totalNightHeart += nightHeart;
        if (nightHeart > 0)
        {
            nightHeartCount ++;
        }
    }
    if (nightHeartCount != 0)
    {
        if (maxNightHeart >= 55 && maxNightHeart <= 89) {
            _maxHeartLabNumberNumber.textColor = [UIColor blueColor];
        }else if (maxNightHeart >= 90 && maxNightHeart <= 119){
            _maxHeartLabNumberNumber.textColor = [UIColor yellowColor];
        }else if (maxNightHeart >= 120){
            _maxHeartLabNumberNumber.textColor = [UIColor redColor];
        }
        if (totalNightHeart/nightHeartCount >= 55 && totalNightHeart/nightHeartCount <= 89) {
            _avgHeartLabNumber.textColor = [UIColor blueColor];
        }else if (totalNightHeart/nightHeartCount >= 90 && totalNightHeart/nightHeartCount <= 119){
            _avgHeartLabNumber.textColor = [UIColor yellowColor];
        }else if (totalNightHeart/nightHeartCount >= 120){
            _avgHeartLabNumber.textColor = [UIColor redColor];
        }
        _maxHeartLabNumberNumber.text = [NSString stringWithFormat:@"%d", maxNightHeart];
        _avgHeartLabNumber.text =  [NSString stringWithFormat:@"%d",totalNightHeart/nightHeartCount];
    }
    else
    {
        _maxHeartLabNumberNumber.text = @"--";
        _avgHeartLabNumber.text =  @"--";
        
    }
    
    _nightHeartScrollView.contentSize = CGSizeMake(CurrentDeviceWidth, 0);
    PZNightHeartChart *nightChart = [PZNightHeartChart new];
    [_nightHeartScrollView addSubview:nightChart];
    nightChart.sd_layout.bottomEqualToView(_nightHeartScrollView)
    .leftEqualToView(_nightHeartScrollView)
    .topEqualToView(_nightHeartScrollView)
    .widthIs(CurrentDeviceWidth - 20 * WidthProportion);
    nightChart.heartArray = _nightHeartArray;
    
    
    beginTime = beginTime/10;
    endTime = endTime /10;
    NSArray * timeArray;
    if (endTime - beginTime >= 3)
    {
        int firstTime = beginTime + (endTime - beginTime)/3;
        int secondTime = beginTime + (endTime - beginTime)/3*2;
        timeArray = @[[NSNumber numberWithInt:beginTime],[NSNumber numberWithInt:firstTime],[NSNumber numberWithInt:secondTime],[NSNumber numberWithInt:endTime]];
        
        for (int i = 0; i < timeArray.count; i ++)
        {
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor grayColor];
            label.tag = 100;
            int index = [timeArray[i] intValue];
            int time = 0;
            if (index < 12)
            {
                time = 22+index/6;
            }
            else
            {
                time = (index - 12)/6;
            }
            int min = index%6*10;
            label.text = [NSString stringWithFormat:@"%d:%02d",time,min];
            [nightChart addSubview:label];
            label.textColor = allColorWhite;
            label.textAlignment = NSTextAlignmentRight;
            label.sd_layout.leftSpaceToView(nightChart,(CurrentDeviceWidth-20*WidthProportion - 45*WidthProportion)/3*i)
            .bottomSpaceToView(nightChart,0)
            .widthIs(35*WidthProportion)
            .heightIs(15*HeightProportion);
        }
    }
    else
    {
        timeArray = @[[NSNumber numberWithInt:beginTime],[NSNumber numberWithInt:endTime]];
        for (int i = 0; i < timeArray.count; i ++)
        {
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor grayColor];
            label.textColor = allColorWhite;
            label.tag = 100;
            int index = [timeArray[i] intValue];
            int time = 0;
            if (index < 12)
            {
                time = 22+index/6;
            }
            else
            {
                time = (index - 12)/6;
            }
            int min = index%6*10;
            label.text = [NSString stringWithFormat:@"%d:%02d",time,min];
            label.textAlignment = NSTextAlignmentCenter;
            [nightChart addSubview:label];
            
            label.sd_layout.leftSpaceToView(nightChart,(CurrentDeviceWidth-20*WidthProportion - 35*WidthProportion)*i)
            .bottomSpaceToView(nightChart,0)
            .widthIs(35*WidthProportion)
            .heightIs(15*HeightProportion);
        }
    }
}
#pragma mark - - -私有方法

- (NSMutableAttributedString *)getHandMinAttributeStringWithNumber:(int)number
{
    NSMutableAttributedString *attributeString = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",number / 60] Unit:@"h" WithFont:fontSizeSleep];
    [attributeString appendAttributedString:[self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",number%60] Unit:@"min" WithFont:fontSizeSleep]];
    return attributeString;
}
#pragma mark - - -设置视图
-(void)setupView
{
    self.view.backgroundColor = downBackColor;
    [self.view addSubview:self.navView];
    self.navView.backgroundColor = [UIColor whiteColor];
    UIView *topView = [self.view viewWithTag:1001];
    topView.backgroundColor = [UIColor blackColor];
    [self.datePickBtn setTitle:@"睡眠" forState:UIControlStateNormal];
    [self.datePickBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIButton *shareBtn = [self.view viewWithTag:1002];
    [shareBtn setImage:[UIImage imageNamed:@"fenxiang-black"] forState:UIControlStateNormal];
    
    [self initVariable];//初始化变量
    [self setupDaohang];//导航条
    [self setupUpView]; //上面的视图
    [self setupDownView];//下面的视图
}
-(void)setupDaohang
{
    UIButton * btn = [[UIButton alloc]init];
    btn.backgroundColor = allColorWhite;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(backSleep) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    CGFloat btnX = 0;
    CGFloat btnY = 20;
    CGFloat btnW = 44;
    CGFloat btnH = btnW;
    btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
}
-(void)backSleep
{
    self.haveTabBar = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setupUpView
{
    //
    CGFloat imageViewX = 0;
    CGFloat imageViewY = 64;
    CGFloat imageViewW = CurrentDeviceWidth;
    CGFloat imageViewH = (CurrentDeviceHeight - 64)/2;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH)];
    imageView.image = [UIImage imageNamed:@"GradientBackground_sleep"];
    //    imageView.backgroundColor = allColorRed;
    [self.view addSubview:imageView];
    _sleepView = imageView;
    
    
    CGFloat imageViewBedX = 10 * WidthProportion;
    CGFloat imageViewBedW = CurrentDeviceWidth - 2*imageViewBedX;
    CGFloat imageViewBedH = 38 * HeightProportion;
    CGFloat imageViewBedY = imageViewH - 13 * HeightProportion - imageViewBedH;
    UIImageView *imageViewBed = [[UIImageView alloc]initWithFrame:CGRectMake(imageViewBedX, imageViewBedY, imageViewBedW, imageViewBedH)];
    _imageViewBed = imageViewBed;
    imageViewBed.image = [UIImage imageNamed:@"BlueBase_sleep"];
    [imageView addSubview:imageViewBed];
    
    //    第一层显示
    
    //深睡
    CGFloat imageViewDeepX = 20 * WidthProportion;
    CGFloat imageViewDeepY = 30 * HeightProportion;
    CGFloat imageViewDeepH = 25 * WidthProportion;
    CGFloat imageViewDeepW = imageViewDeepH;
    UIImageView *imageViewDeep = [[UIImageView alloc]initWithFrame:CGRectMake(imageViewDeepX, imageViewDeepY, imageViewDeepW, imageViewDeepH)];
    imageViewDeep.image = [UIImage imageNamed:@"shengshui"];
    [imageView addSubview:imageViewDeep];
    
    CGFloat deepLabelX = CGRectGetMaxX(imageViewDeep.frame);
    CGFloat deepLabelW = 120 * WidthProportion;
    CGFloat deepLabelH = 20 * HeightProportion;
    CGFloat deepLabelY = CGRectGetMinY(imageViewDeep.frame) + imageViewDeepH / 2 - deepLabelH;
    UILabel *deepLabel = [[UILabel alloc]initWithFrame:CGRectMake(deepLabelX, deepLabelY, deepLabelW, deepLabelH)];
    deepLabel.text =@"0h0min";
    _deepLabel = deepLabel;
    [imageView addSubview:deepLabel];
    
    CGFloat deepLabelUnionX = CGRectGetMinX(deepLabel.frame);
    CGFloat deepLabelUnionY = CGRectGetMaxY(deepLabel.frame);
    CGFloat deepLabelUnionW = deepLabelW;
    CGFloat deepLabelUnionH = deepLabelH;
    UILabel *deepLabelUnion = [[UILabel alloc]initWithFrame:CGRectMake(deepLabelUnionX, deepLabelUnionY, deepLabelUnionW, deepLabelUnionH)];
    deepLabelUnion.text = @"安静睡眠";
    [imageView addSubview:deepLabelUnion];
    
    //浅睡
    CGFloat imageViewEasyX = CurrentDeviceWidth / 2 - 40;
    CGFloat imageViewEasyY = imageViewDeepY;
    CGFloat imageViewEasyH = imageViewDeepH;
    CGFloat imageViewEasyW = imageViewEasyH;
    UIImageView *imageViewEasy = [[UIImageView alloc]initWithFrame:CGRectMake(imageViewEasyX, imageViewEasyY, imageViewEasyW, imageViewEasyH)];
    imageViewEasy.image = [UIImage imageNamed:@"qianshui"];
    [imageView addSubview:imageViewEasy];
    
    CGFloat EasyLabelX = CGRectGetMaxX(imageViewEasy.frame);
    CGFloat EasyLabelY = deepLabelY;
    CGFloat EasyLabelW = deepLabelW;
    CGFloat EasyLabelH = deepLabelH;
    UILabel *EasyLabel = [[UILabel alloc]initWithFrame:CGRectMake(EasyLabelX, EasyLabelY, EasyLabelW, EasyLabelH)];
    EasyLabel.text =@"0h0min";
    _EasyLabel = EasyLabel;
    [imageView addSubview:EasyLabel];
    
    CGFloat EasyLabelUnionX = CGRectGetMinX(EasyLabel.frame);
    CGFloat EasyLabelUnionY = CGRectGetMaxY(EasyLabel.frame);
    CGFloat EasyLabelUnionW = EasyLabelW;
    CGFloat EasyLabelUnionH = EasyLabelH;
    UILabel *EasyLabelUnion = [[UILabel alloc]initWithFrame:CGRectMake(EasyLabelUnionX, EasyLabelUnionY, EasyLabelUnionW, EasyLabelUnionH)];
    EasyLabelUnion.text = NSLocalizedString(@"浅睡", nil);
    [imageView addSubview:EasyLabelUnion];
    
    
    //清醒
    CGFloat imageViewAwakeX = 260 * WidthProportion;
    CGFloat imageViewAwakeY = imageViewDeepY;
    CGFloat imageViewAwakeH = imageViewDeepH;
    CGFloat imageViewAwakeW = imageViewAwakeH;
    UIImageView *imageViewAwake = [[UIImageView alloc]initWithFrame:CGRectMake(imageViewAwakeX, imageViewAwakeY, imageViewAwakeW, imageViewAwakeH)];
    imageViewAwake.image = [UIImage imageNamed:@"qingxing"];
    [imageView addSubview:imageViewAwake];
    
    CGFloat AwakeLabelX = CGRectGetMaxX(imageViewAwake.frame);
    CGFloat AwakeLabelY = deepLabelY;
    CGFloat AwakeLabelW = deepLabelW;
    CGFloat AwakeLabelH = deepLabelH;
    UILabel *AwakeLabel = [[UILabel alloc]initWithFrame:CGRectMake(AwakeLabelX, AwakeLabelY, AwakeLabelW, AwakeLabelH)];
    AwakeLabel.text =@"0h0min";
    _AwakeLabel = AwakeLabel;
    [imageView addSubview:AwakeLabel];
    
    CGFloat AwakeLabelUnionX = CGRectGetMinX(AwakeLabel.frame);
    CGFloat AwakeLabelUnionY = CGRectGetMaxY(AwakeLabel.frame);
    CGFloat AwakeLabelUnionW = AwakeLabelW;
    CGFloat AwakeLabelUnionH = AwakeLabelH;
    UILabel *AwakeLabelUnion = [[UILabel alloc]initWithFrame:CGRectMake(AwakeLabelUnionX, AwakeLabelUnionY, AwakeLabelUnionW, AwakeLabelUnionH)];
    AwakeLabelUnion.text = NSLocalizedString(@"清醒", nil);
    [imageView addSubview:AwakeLabelUnion];
    
}
-(void)setupDownView
{
    CGFloat downViewX = 10 * WidthProportion;
    CGFloat downViewY = (CurrentDeviceHeight - 64)/2 + 15 * HeightProportion + 64;
    CGFloat downViewW = CurrentDeviceWidth - downViewX * 2;
    CGFloat downViewH = CurrentDeviceHeight - downViewY;
    
    UIView *downView =[[UIView alloc]initWithFrame:CGRectMake(downViewX, downViewY, downViewW, downViewH)];
    [self.view addSubview:downView];
    downView.backgroundColor = allColorWhite;
    
    
    CGFloat nightHeartLabX = 10 * WidthProportion;
    CGFloat nightHeartLabY = 10 * HeightProportion;
    CGFloat nightHeartLabW = 150 * WidthProportion;
    CGFloat nightHeartLabH = 30 * HeightProportion;
    
    UILabel *nightHeartLab = [[UILabel alloc]initWithFrame:CGRectMake(nightHeartLabX, nightHeartLabY, nightHeartLabW, nightHeartLabH)];
    [downView addSubview:nightHeartLab];
    nightHeartLab.attributedText = [NSAttributedString  makeAttributedStringWithnumBer:NSLocalizedString(@"夜间心率", nil) Unit:@"/bpm" WithFont:18];
    
    CGFloat maxHeartLabX = 250 * WidthProportion;
    CGFloat maxHeartLabY = 30 * HeightProportion;
    CGFloat maxHeartLabW = 60 * WidthProportion;
    CGFloat maxHeartLabH = 20 * HeightProportion;
    UILabel *maxHeartLab = [[UILabel alloc]initWithFrame:CGRectMake(maxHeartLabX, maxHeartLabY, maxHeartLabW, maxHeartLabH)];
    [downView addSubview:maxHeartLab];
    maxHeartLab.text = NSLocalizedString(@"最高心率", nil);//平均心率
    maxHeartLab.textColor = fontcolorless;
    maxHeartLab.font = fontSizeSmall;
    
    CGFloat maxHeartLabNumberX = CGRectGetMaxX(maxHeartLab.frame);
    CGFloat maxHeartLabNumberY = maxHeartLabY;
    CGFloat maxHeartLabNumberW = maxHeartLabW;
    CGFloat maxHeartLabNumberH = maxHeartLabH;
    UILabel *maxHeartLabNumberNumber = [[UILabel alloc]initWithFrame:CGRectMake(maxHeartLabNumberX, maxHeartLabNumberY, maxHeartLabNumberW, maxHeartLabNumberH)];
    [downView addSubview:maxHeartLabNumberNumber];
    maxHeartLabNumberNumber.text = @"--";//平均心率
    maxHeartLabNumberNumber.textColor = [UIColor redColor];
    maxHeartLabNumberNumber.font = [UIFont systemFontOfSize:18];
    _maxHeartLabNumberNumber = maxHeartLabNumberNumber;
    
    CGFloat avgHeartLabX = maxHeartLabX;
    CGFloat avgHeartLabY = CGRectGetMaxY(maxHeartLab.frame);
    CGFloat avgHeartLabW = maxHeartLabW;
    CGFloat avgHeartLabH = maxHeartLabH;
    UILabel *avgHeartLab = [[UILabel alloc]initWithFrame:CGRectMake(avgHeartLabX, avgHeartLabY, avgHeartLabW, avgHeartLabH)];
    [downView addSubview:avgHeartLab];
    avgHeartLab.text = NSLocalizedString(@"平均心率", nil);
    avgHeartLab.textColor = fontcolorless;
    avgHeartLab.font = fontSizeSmall;
    
    CGFloat avgHeartLabNumberX = CGRectGetMaxX(avgHeartLab.frame);
    CGFloat avgHeartLabNumberY = avgHeartLabY;
    CGFloat avgHeartLabNumberW = maxHeartLabW;
    CGFloat avgHeartLabNumberH = maxHeartLabH;
    UILabel *avgHeartLabNumber = [[UILabel alloc]initWithFrame:CGRectMake(avgHeartLabNumberX, avgHeartLabNumberY, avgHeartLabNumberW, avgHeartLabNumberH)];
    [downView addSubview:avgHeartLabNumber];
    avgHeartLabNumber.text = @"--";
    avgHeartLabNumber.textColor =  [UIColor blueColor];
    avgHeartLabNumber.font =  [UIFont systemFontOfSize:18];
    _avgHeartLabNumber = avgHeartLabNumber;
    
    
    CGFloat nightHeartVIewX = 0;
    CGFloat nightHeartVIewY = 81 * HeightProportion;
    CGFloat nightHeartVIewW = downViewW;
    CGFloat nightHeartVIewH = downViewH - nightHeartVIewY;
    
    _nightHeartVIew =[[UIView alloc]initWithFrame:CGRectMake(nightHeartVIewX, nightHeartVIewY, nightHeartVIewW, nightHeartVIewH)];
    [downView addSubview:_nightHeartVIew];
    _nightHeartVIew.backgroundColor = allColorWhite;
    
    CGFloat scrollViewX = 0;
    CGFloat scrollViewY = 0;
    CGFloat scrollViewW = _nightHeartVIew.width;
    CGFloat scrollViewH = _nightHeartVIew.height;
    _nightHeartScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(scrollViewX,scrollViewY,scrollViewW,scrollViewH)];
    _nightHeartScrollView.showsHorizontalScrollIndicator = NO;
    _nightHeartScrollView.scrollEnabled = NO;
    [_nightHeartVIew addSubview:_nightHeartScrollView];
    [self addHeartLabelTo:_nightHeartVIew];
}

- (void)addHeartLabelTo:(UIView *)view
{
    NSArray *HRAlarmArray = [[NSUserDefaults standardUserDefaults] objectForKey:kHeartRateAlarm];
    int maxHR = 160;
    int minHR = 40;
    if (HRAlarmArray)
    {
        maxHR = [HRAlarmArray[1] intValue];
        minHR = [HRAlarmArray[0] intValue];
    }
    
    UILabel *dayWarningLabel1 = [[UILabel alloc] init];
    dayWarningLabel1.text = NSLocalizedString(@"         预警", nil);
    dayWarningLabel1.font = [UIFont systemFontOfSize:12];
    dayWarningLabel1.textColor = [UIColor colorWithRed:254/255.0 green:40/255.0 blue:42/255.0 alpha:0.6];
    [view addSubview:dayWarningLabel1];
    dayWarningLabel1.frame = CGRectMake(0, 0, view.width, view.height/220 * (220 - maxHR));
    
    
    UILabel *day220 = [[UILabel alloc] init];
    _day220 = day220;
    day220.textColor = [UIColor grayColor];
    day220.text = @"220";
    [day220 sizeToFit];
    day220.font = [UIFont systemFontOfSize:12];
    [view addSubview:day220];
    
    day220.frame = CGRectMake(8, 0, day220.width, day220.height);// + day220.height/2.
    
    
    
    UIImageView *lineImageView1 = [[UIImageView alloc] init];
    [view addSubview:lineImageView1];
    lineImageView1.image = [UIImage imageNamed:@"XQ_pointLine"];
    lineImageView1.contentMode = UIViewContentModeScaleToFill;
    lineImageView1.frame = CGRectMake(32, day220.height/2., view.width - 32, 1);
    
    UILabel *dayNormalLabel = [[UILabel alloc] init];
    dayNormalLabel.text = NSLocalizedString(@"         正常", nil);
    dayNormalLabel.textColor = [UIColor grayColor];
    dayNormalLabel.font = [UIFont systemFontOfSize:12];
    [view addSubview:dayNormalLabel];
    dayNormalLabel.frame = CGRectMake(0, dayWarningLabel1.bottom, view.width, view.height/220. * (maxHR - minHR));
    
    UILabel *dayMax = [[UILabel alloc] init];
    dayMax.textColor = [UIColor grayColor];
    
    dayMax.text = [NSString stringWithFormat:@"%.d",maxHR];
    [dayMax sizeToFit];
    dayMax.font = [UIFont systemFontOfSize:12];
    [view addSubview:dayMax];
    dayMax.frame = CGRectMake(8, dayWarningLabel1.bottom - 5, dayMax.width, 10);
    
    
    UIImageView *lineImageView2 = [[UIImageView alloc] init];
    [view addSubview:lineImageView2];
    lineImageView2.image = [UIImage imageNamed:@"XQ_pointLine"];
    lineImageView2.contentMode = UIViewContentModeScaleToFill;
    lineImageView2.frame = CGRectMake(32, dayWarningLabel1.bottom, view.width - 32, 1);
    
    
    UILabel *dayWarningLabel2 = [[UILabel alloc] init];
    dayWarningLabel2.text = NSLocalizedString(@"         预警", nil);
    dayWarningLabel2.textColor = [UIColor colorWithRed:254/255.0 green:40/255.0 blue:42/255.0 alpha:0.6];
    dayWarningLabel2.font = [UIFont systemFontOfSize:12];
    [view addSubview:dayWarningLabel2];
    dayWarningLabel2.frame = CGRectMake(0, dayNormalLabel.bottom, view.width, view.height - dayNormalLabel.bottom);
    
    
    UILabel *day50 = [[UILabel alloc] init];
    day50.textColor = [UIColor grayColor];
    day50.text = [NSString stringWithFormat:@"%d",minHR];
    [day50 sizeToFit];
    day50.font = [UIFont systemFontOfSize:12];
    [view addSubview:day50];
    day50.frame = CGRectMake(8, dayNormalLabel.bottom - 5, day50.width, 10);
    
    
    UIImageView *lineImageView3 = [[UIImageView alloc] init];
    [view addSubview:lineImageView3];
    lineImageView3.image = [UIImage imageNamed:@"XQ_pointLine"];
    lineImageView3.contentMode = UIViewContentModeScaleToFill;
    lineImageView3.frame = CGRectMake(32, dayNormalLabel.bottom, view.width - 32, 1);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

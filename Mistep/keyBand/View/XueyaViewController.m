//
//  XueyaViewController.m
//  Mistep
//
//  Created by 迈诺科技 on 2016/9/24.
//  Copyright © 2016年 huichenghe. All rights reserved.
//
#define shousuoyaWidth  110*WidthProportion
#define shousuoyaHeight  40*HeightProportion
#define shousuoyaNumberWidth  100*WidthProportion
#define shousuoyaNumberHeight  50*HeightProportion
#define shousuoyalabelFont [UIFont fontWithName:@"DS-Digital-Bold" size:60]
//[UIFont systemFontOfSize:40]
#define shousuoyalabelFontPre [UIFont fontWithName:@"DS-Digital-Bold" size:60*0.7]
#define DetailViewFont  [UIFont fontWithName:@"DS-Digital" size:16]
//[UIFont systemFontOfSize:12]
#define DetailViewFontPre [UIFont fontWithName:@"DS-Digital" size:16*0.7]
#define DetailViewWidth 40*WidthProportion
#define DetailViewHeight 49*HeightProportion
#define DetailViewContentHeight ((49 - 1)/3)*HeightProportion

#define DetailViewHeightPre 39*HeightProportion
#define DetailViewContentHeightPre ((DetailViewHeightPre - 1)/3)
#define labelTag  222
#define sousuoImageViewTag   300
#define shuzhangImageViewTag   310

#import "XueyaViewController.h"
#import "XueyaChartView.h"
//#import "UIViewController+MMDrawerController.h"
#import "XueyaCorrectView.h"
#import "SheBeiViewController.h"
#import "ConnectStateView.h"


@interface XueyaViewController ()<BlutToothManagerDelegate,PZBlueToothManagerDelegate,XueyaCorrectViewDelegate>
{
    
    CAGradientLayer *gradientLayerSousuo;
    UIBezierPath * pathtempSousuo;
    UIBezierPath * pathSousuo;
    CAShapeLayer *arctempSousuo;
    CAShapeLayer *arcSousuo;//以上是收缩压的配置对象
    UIBezierPath * pathtempShuzh;//以下是舒展压的配置对象
    UIBezierPath * pathShuzh;
    CAShapeLayer *arctempShuzh;
    CAShapeLayer *arcShuzh;
    CAGradientLayer *gradientLayerShuzh;
    
}
@property (nonatomic,strong) UIView *upperView;
@property (nonatomic,strong) UIView *middleView;
@property (nonatomic,strong) UIView *downView;
@property (nonatomic,strong) NSMutableArray * bloodArray;
@property (nonatomic,strong) UILabel *shousuoLabel;
@property (nonatomic,strong) UILabel *shuzhangLabel;
@property (nonatomic,strong) UILabel *xinlvLabel;
@property (nonatomic,strong) UILabel *spoNumberLabel;
//下半部分
@property (strong, nonatomic) UIScrollView *nightBloodScrollView;//血压滚动图
@property (strong, nonatomic) UIView *lineView;//血压滚动图  下面的竖线    y轴
@property (strong, nonatomic) UIView *XlineView;//血压滚动图  下面的竖线   x轴
@property (strong, nonatomic) XueyaChartView *chartView;//血压图表
@property (assign, nonatomic) CGFloat YlabelH;//调整高度
@property (assign, nonatomic) CGFloat XlabelH;//XlabelH

@property (strong, nonatomic) UIImageView *showLabelView;         //点击展示的图
@property (strong, nonatomic) UILabel *labelNumber;            //点击展示的label
//@property (nonatomic,strong)UIView *connectView;//提示连接的view




@property (nonatomic,strong)ConnectStateView *BLOODconStateView;//提示连接的view
@property (nonatomic,strong)UIButton *BLOODconnectButton;//显示连接中。。。的button 点击跳转设备管理
@property (nonatomic,strong)NSString *BLOODconnectString;//连接字符串。
//@property (nonatomic,strong)DoneCustomView *BLOODdoneView;
@property (nonatomic,strong)NSString *BLOODdoneString;
@property (nonatomic,strong)UILabel *BLOODchangLabel;//传递颜色的label

@property (nonatomic,strong)UIView *backALLView; //背后的所有视图



@end

@implementation XueyaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = allColorWhite;
    //    kColor(203, 213, 219);
    [self.view addSubview:self.navView];
    self.haveTabBar = YES;
    [self setupView];
    [self BLOODremindView];
    //        NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
    //            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
    //                                  @"01",BloodPressureID_def,
    //                                  @"yidali",CurrentUserName_HCH,
    //                                  @"2017-02-17",BloodPressureDate_def,
    //                                  @"2017-02-17 21:51:23",StartTime_def,
    //                                  @"150",systolicPressure_def,
    //                                  @"151",diastolicPressure_def,
    //                                  @"152",heartRateNumber_def,
    //                                  @"153",SPO2_def,
    //                                  @"154",HRV_def,
    //                                  @"0",ISUP,
    //                                  deviceId,DEVICEID,
    //                                  @"002",DEVICETYPE,
    //                                  nil];
    //            ////adaLog(@"dic -- %@",dic);
    //            [[SQLdataManger  getInstance] insertSignalDataToTable:BloodPressure_Table withData:dic];
    //        NSDictionary * dic1 = [NSDictionary dictionaryWithObjectsAndKeys:
    //                              @"02",BloodPressureID_def,
    //                              @"yidali",CurrentUserName_HCH,
    //                              @"2017-02-17",BloodPressureDate_def,
    //                              @"2017-02-17 21:41:23",StartTime_def,
    //                              @"150",systolicPressure_def,
    //                              @"151",diastolicPressure_def,
    //                              @"152",heartRateNumber_def,
    //                              @"153",SPO2_def,
    //                              @"154",HRV_def,
    //                              @"0",ISUP,
    //                              deviceId,DEVICEID,
    //                              @"002",DEVICETYPE,
    //                              nil];
    //        ////adaLog(@"dic -- %@",dic);
    //        [[SQLdataManger  getInstance] insertSignalDataToTable:BloodPressure_Table withData:dic1];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[CositeaBlueTooth sharedInstance] readyReceive:1];
}
-(void)setupView
{
    [self initModel];
    [self setupBackALLView];//backALLView   所有视图 的载体
    [self setupUpperView];
    [self setupMiddleView];
    [self setupDownView];
    [self setupBluetoothData];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[PSDrawerManager instance] beginDragResponse];
    [BlueToothManager getInstance].delegate = self;
    [self childrenTimeSecondChanged];
//    [self.tabBarController.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    int low = [[ADASaveDefaluts objectForKey:BLOODPRESSURELOW] intValue];
    int hight = [[ADASaveDefaluts objectForKey:BLOODPRESSUREHIGH] intValue];
    if (low>0&&hight>0) {
    }
    else
    {
        XueyaCorrectView *cor = [XueyaCorrectView showXueyaCorrectView];
        cor.delegate = self;
    }
    [self BLOODsetblock];
    [self BLOODrefreshAlertView];    //连接的 提示界面
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.tabBarController.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [[CositeaBlueTooth sharedInstance] readyReceive:0];
}
-(void)initModel
{
    self.bloodArray = [NSMutableArray array];
    
    [PZBlueToothManager sharedInstance].delegate = self;
    
}
- (void)childrenTimeSecondChanged
{
    [self refreshChart];
    //   用户 上传下行，，查看数据
    //    if([AllTool isDirectUse])
    //    {
    //
    //        [self refreshChart];
    //    }
    //    else
    //    {
    //
    //        //蓝牙没有连接就查询服务器
    //        if ([CositeaBlueTooth sharedInstance].isConnected)
    //        {
    //            NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:kHCH.selectTimeSeconds andFormat:@"yyyy-MM-dd"];
    //            NSMutableArray *arr = [NSMutableArray arrayWithArray:[[SQLdataManger getInstance] queryBloodPressureWithDay:timeStr]];
    //            if (arr.count>0)
    //            {
    //                [self refreshChart];
    //            }
    //            else
    //            {
    //                [self performSelector:@selector(refreshChart) withObject:nil afterDelay:1.0f];
    //                WeakSelf;
    //                [TimingUploadData downBloodPressure:^(NSArray *array) {
    //                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshChart) object:nil];
    //                    [weakSelf refreshChart];
    //                } date:kHCH.selectTimeSeconds];
    //            }
    //        }
    //        else
    //        {
    //            [self performSelector:@selector(refreshChart) withObject:nil afterDelay:1.0f];
    //            WeakSelf;
    //            [TimingUploadData downBloodPressure:^(NSArray *array) {
    //                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshChart) object:nil];
    //                [weakSelf refreshChart];
    //            } date:kHCH.selectTimeSeconds];
    //        }
    //    }
    
}

-(void)setupBluetoothData
{   WeakSelf;
    [[PZBlueToothManager sharedInstance]checkBloodPressure:^(BloodPressureModel *bloodPre) {
        //adaLog(@"设置label的值");
        if (bloodPre){
            //            NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:kHCH.selectTimeSeconds andFormat:@"yyyy-MM-dd"];
            //            NSMutableArray *arr = [NSMutableArray arrayWithArray:[[SQLdataManger getInstance] queryBloodPressureWithDay:timeStr]];
            [weakSelf refreshChart];
        };
    }];
}
-(void)refreshChart
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshChart) object:nil];
    NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:kHCH.selectTimeSeconds andFormat:@"yyyy-MM-dd"];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[SQLdataManger getInstance] queryBloodPressureWithDay:timeStr]];
    
    self.bloodArray = arr;
    if (self.bloodArray.count > 0)
    {
        //  根据  StartTime 排序
        if ([self.bloodArray count] >= 2) {
            self.bloodArray =  [self sortBlood:self.bloodArray];
        }
        
        if (self.bloodArray.count > 0) {
            NSInteger number = [self.bloodArray count] - 1;
            NSDictionary *dictionary = self.bloodArray[number];
            
            _shousuoLabel.text = dictionary[@"systolicPressure"];
            _shuzhangLabel.text = dictionary[@"diastolicPressure"];
            _xinlvLabel.text = dictionary[@"heartRateNumber"];
            _spoNumberLabel.text = [NSString stringWithFormat:@"  %@",dictionary[@"SPO2"]];
        }
    }
    else
    {
        _shousuoLabel.text = @"0";
        _shuzhangLabel.text = @"0";
        _xinlvLabel.text = @"0";
        _spoNumberLabel.text = @"  0";
    }
    [self setupChart];
    //    self.nightBloodScrollView.contentSize= CGSizeMake(self.nightBloodScrollView.width / 7 * self.bloodArray.count,self.nightBloodScrollView.height);
    //    self.chartView.chartArray = self.bloodArray;
}

#pragma mark   - - - 排序 各个运动
-(NSMutableArray *)sortBlood:(NSArray *)array
{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    for (NSInteger i = 0; i<mutableArray.count; i++) {
        for (NSInteger j= i+1; j<mutableArray.count ; j++) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSDate *date1 = [formatter dateFromString:array[i][@"StartTime"]];
            NSDate *date2 = [formatter dateFromString:array[j][@"StartTime"]];
            NSTimeInterval aTimer = [date2 timeIntervalSinceDate:date1];
            if (aTimer < 0) {
                [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    return mutableArray;
}
-(void)setupBackALLView
{
    _backALLView = [[UIView alloc]init];
    [self.view addSubview:_backALLView];
    _backALLView.backgroundColor = kColor(203, 213, 219);    CGFloat  backALLViewX = 0;
    CGFloat  backALLViewY = 64;
    CGFloat  backALLViewW = CurrentDeviceWidth;
    CGFloat  backALLViewH = CurrentDeviceHeight - 64 - 48;
    _backALLView.frame = CGRectMake(backALLViewX, backALLViewY, backALLViewW, backALLViewH);
    
}
//上层的view
-(void)setupUpperView
{
    
    UIView *upperView = [[UIView alloc]init];
    [_backALLView addSubview:upperView];
    self.upperView  = upperView;
    CGFloat  upperViewX = 0;
    CGFloat  upperViewY = 0;
    CGFloat  upperViewW = CurrentDeviceWidth;
    CGFloat  upperViewH = 274 * HeightProportion;
    upperView.frame = CGRectMake(upperViewX, upperViewY, upperViewW, upperViewH);
    
    //背景图片
    UIImageView *backImage = [[UIImageView alloc]init];
    [upperView addSubview:backImage];
    backImage.image = [UIImage imageNamed:@"background_Pre"];
    backImage.frame = CGRectMake(0, 0, upperViewW, upperViewH);
    
    //最左边的的文字
    UIView  *shousuoyaView = [self shousuoyaViewWithTitle:NSLocalizedString(@"收缩压", nil) unit:@"mmHg" three:NO];
    [upperView addSubview:shousuoyaView];
    //    shousuoyaView.backgroundColor = allColorRed;
    CGFloat  shousuoyaViewX = 10 * WidthProportion;
    CGFloat  shousuoyaViewY = 60*HeightProportion ;
    CGFloat  shousuoyaViewW = shousuoyaWidth ;
    CGFloat  shousuoyaViewH = shousuoyaHeight ;
    shousuoyaViewH = shousuoyaView.height;
    shousuoyaView.frame = CGRectMake(shousuoyaViewX, shousuoyaViewY, shousuoyaViewW, shousuoyaViewH);
    
    UIView  *shuzhangyaView = [self shousuoyaViewWithTitle:NSLocalizedString(@"舒张压", nil)  unit:@"mmHg" three:NO];
    [upperView addSubview:shuzhangyaView];
    CGFloat  shuzhangyaViewX = shousuoyaViewX;
    CGFloat  shuzhangyaViewY = CGRectGetMaxY(shousuoyaView.frame) + 20*HeightProportion;
    CGFloat  shuzhangyaViewW = shousuoyaViewW;
    CGFloat  shuzhangyaViewH = shousuoyaViewH;
    shuzhangyaView.frame = CGRectMake(shuzhangyaViewX, shuzhangyaViewY, shuzhangyaViewW, shuzhangyaViewH);
    
    UIView  *xinlvView = [self shousuoyaViewWithTitle:NSLocalizedString(@"心率", nil)  unit:@"bpm" three:YES];
    [upperView addSubview:xinlvView];
    CGFloat  xinlvViewX = shousuoyaViewX;
    CGFloat  xinlvViewY = CGRectGetMaxY(shuzhangyaView.frame) + 18*HeightProportion;
    CGFloat  xinlvViewW = shousuoyaViewW;
    CGFloat  xinlvViewH = shousuoyaViewH;
    xinlvView.frame = CGRectMake(xinlvViewX, xinlvViewY, xinlvViewW, xinlvViewH);
    
    
    UIView *backWhiteView = [[UIView alloc]init];
    [upperView addSubview:backWhiteView];
    backWhiteView.backgroundColor = [UIColor whiteColor];
    backWhiteView.layer.cornerRadius = 10;
    
    CGFloat backWhiteViewX = CGRectGetMaxX(shousuoyaView.frame) + 10;
    CGFloat backWhiteViewY = CGRectGetMinY(shousuoyaView.frame) - 10;
    CGFloat backWhiteViewW = CurrentDeviceWidth - backWhiteViewX;
    CGFloat backWhiteViewH = CGRectGetMaxY(xinlvView.frame) - backWhiteViewY + 5;
    backWhiteView.frame = CGRectMake(backWhiteViewX, backWhiteViewY, backWhiteViewW, backWhiteViewH);
    
    
    
    
    //中间数值
    UILabel *shousuoLabel = [[UILabel alloc]init];
    shousuoLabel.font =  shousuoyalabelFont;
    shousuoLabel.textAlignment = NSTextAlignmentRight;
    shousuoLabel.text = @"0";
    [upperView addSubview:shousuoLabel];
    _shousuoLabel = shousuoLabel;
    CGFloat  shousuoLabelX = CGRectGetMaxX(shousuoyaView.frame) + 10;
    CGFloat  shousuoLabelY = shousuoyaView.centerY;
    CGFloat  shousuoLabelW = shousuoyaNumberWidth;
    CGFloat  shousuoLabelH = shousuoyaNumberHeight;
    shousuoLabel.centerX = shousuoLabelX;
    shousuoLabel.centerY = shousuoLabelY;
    shousuoLabel.width = shousuoLabelW;
    shousuoLabel.height = shousuoLabelH;
    shousuoLabel.sd_layout
    .leftSpaceToView(shousuoyaView,10)
    .centerYEqualToView(shousuoyaView);
    shousuoLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *shuzhangLabel = [[UILabel alloc]init];
    shuzhangLabel.font =  shousuoyalabelFont;
    shuzhangLabel.textAlignment = NSTextAlignmentRight;
    shuzhangLabel.text = @"0";
    [upperView addSubview:shuzhangLabel];
    _shuzhangLabel = shuzhangLabel;
    CGFloat  shuzhangLabelX = CGRectGetMaxX(shuzhangyaView.frame) + 10;
    CGFloat  shuzhangLabelY = shuzhangyaView.centerY;
    CGFloat  shuzhangLabelW = shousuoyaNumberWidth;
    CGFloat  shuzhangLabelH = shousuoyaNumberHeight;
    shuzhangLabel.centerX = shuzhangLabelX;
    shuzhangLabel.centerY = shuzhangLabelY;
    shuzhangLabel.width = shuzhangLabelW;
    shuzhangLabel.height = shuzhangLabelH;
    shuzhangLabel.sd_layout
    .leftSpaceToView(shousuoyaView,10)
    .centerYEqualToView(shuzhangyaView);
    shuzhangLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *xinlvLabel = [[UILabel alloc]init];
    xinlvLabel.font = shousuoyalabelFontPre;
    xinlvLabel.textAlignment = NSTextAlignmentRight;
    xinlvLabel.text = @"0";
    [upperView addSubview:xinlvLabel];
    _xinlvLabel = xinlvLabel;
    CGFloat  xinlvLabelX = CGRectGetMaxX(xinlvView.frame) + 10;
    CGFloat  xinlvLabelY = xinlvView.centerY;
    CGFloat  xinlvLabelW = shousuoyaNumberWidth;
    CGFloat  xinlvLabelH = shousuoyaNumberHeight;
    xinlvLabel.centerX = xinlvLabelX;
    xinlvLabel.centerY = xinlvLabelY;
    xinlvLabel.width = xinlvLabelW;
    xinlvLabel.height = xinlvLabelH;
    xinlvLabel.sd_layout
    .leftSpaceToView(xinlvView,10)
    .centerYEqualToView(xinlvView);
    xinlvLabel.backgroundColor = [UIColor clearColor];
    
    //数值中详细的部分
    UIView *shousuoyaDetailView = [self shousuoyaDetailView];
    shousuoyaDetailView.backgroundColor = [UIColor clearColor];
    [upperView addSubview:shousuoyaDetailView];
    shousuoyaDetailView.sd_layout
    .leftSpaceToView(shousuoLabel,10)
    .centerYEqualToView(shousuoLabel)
    .widthIs(DetailViewWidth)
    .heightIs(DetailViewHeight);
    
    UIView *shuzhangyaDetailView = [self shuzhangyaDetailView];
    shuzhangyaDetailView.backgroundColor = [UIColor clearColor];
    [upperView addSubview:shuzhangyaDetailView];
    
    shuzhangyaDetailView.sd_layout
    .leftSpaceToView(shuzhangLabel ,10)
    .centerYEqualToView(shuzhangLabel)
    .widthIs(DetailViewWidth)
    .heightIs(DetailViewHeight);
    
    UIView *xinlvDetailView = [self xinlvDetailView];
    xinlvDetailView.backgroundColor = [UIColor clearColor];
    [upperView addSubview:xinlvDetailView];
    xinlvDetailView.sd_layout
    .leftSpaceToView(xinlvLabel ,10)
    .centerYEqualToView(xinlvLabel)
    .widthIs(DetailViewWidth)
    .heightIs(DetailViewHeight);
    
    
    
}
//创建左边的label合成的view
-(UIView *)shousuoyaViewWithTitle:(NSString *)title unit:(NSString *)unit  three:(BOOL)isThree
{
    UIView  *shousuoyaView = [[UIView alloc]init];
    UILabel *maxLabel = [[UILabel alloc]init];
    UILabel *minLabel = [[UILabel alloc]init];
    if (isThree) {
        shousuoyaView.backgroundColor = [UIColor clearColor];
        CGFloat  shousuoyaViewX = 0;
        CGFloat  shousuoyaViewY = 0;
        CGFloat  shousuoyaViewW = shousuoyaWidth*WidthProportion;
        CGFloat  shousuoyaViewH = shousuoyaHeight*HeightProportion;
        shousuoyaView.frame = CGRectMake(shousuoyaViewX, shousuoyaViewY, shousuoyaViewW, shousuoyaViewH);
        
        [shousuoyaView addSubview:maxLabel];
        maxLabel.text = title;
        maxLabel.font = [UIFont systemFontOfSize:18 * 0.7];
        maxLabel.numberOfLines = 0;
        maxLabel.textAlignment = NSTextAlignmentRight;
        CGFloat  maxLabelX = 0;
        CGFloat  maxLabelY = 0;
        CGFloat  maxLabelW = shousuoyaWidth;
        CGFloat  maxLabelH = 30*HeightProportion;
        NSDictionary *dicMaxT = @{NSFontAttributeName:maxLabel.font};
        CGSize sizeT = [maxLabel.text boundingRectWithSize:CGSizeMake(maxLabelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicMaxT context:nil].size;
        maxLabelH = sizeT.height;
        maxLabel.frame = CGRectMake(maxLabelX, maxLabelY, maxLabelW, maxLabelH);
        
        
        [shousuoyaView addSubview:minLabel];
        minLabel.text = unit;
        minLabel.font = [UIFont systemFontOfSize:9 * 0.7];
        minLabel.textAlignment = NSTextAlignmentRight;
        CGFloat  minLabelX = 0;
        CGFloat  minLabelY = CGRectGetMaxY(maxLabel.frame);
        CGFloat  minLabelW = shousuoyaWidth;
        CGFloat  minLabelH = 10*HeightProportion;
        minLabel.frame = CGRectMake(minLabelX, minLabelY, minLabelW, minLabelH);
        return shousuoyaView;
        
    }
    
    shousuoyaView.backgroundColor = [UIColor clearColor];
    CGFloat  shousuoyaViewX = 0;
    CGFloat  shousuoyaViewY = 0;
    CGFloat  shousuoyaViewW = shousuoyaWidth;
    CGFloat  shousuoyaViewH = shousuoyaHeight;
    shousuoyaView.frame = CGRectMake(shousuoyaViewX, shousuoyaViewY, shousuoyaViewW, shousuoyaViewH);
    
    [shousuoyaView addSubview:maxLabel];
    maxLabel.text = title;
    maxLabel.font = [UIFont systemFontOfSize:18];
    maxLabel.textAlignment = NSTextAlignmentRight;
    maxLabel.numberOfLines = 0;
    CGFloat  maxLabelX = 0;
    CGFloat  maxLabelY = 0;
    CGFloat  maxLabelW = shousuoyaWidth;
    CGFloat  maxLabelH = 30*HeightProportion;
    NSDictionary *dicMax = @{NSFontAttributeName:maxLabel.font};
    CGSize size2 = [maxLabel.text boundingRectWithSize:CGSizeMake(maxLabelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicMax context:nil].size;
    maxLabelH = size2.height;
    maxLabel.frame = CGRectMake(maxLabelX, maxLabelY, maxLabelW, maxLabelH);
    
    [shousuoyaView addSubview:minLabel];
    
    minLabel.text = unit;
    minLabel.font = [UIFont systemFontOfSize:9];
    minLabel.textAlignment = NSTextAlignmentRight;
    CGFloat  minLabelX = 0;
    CGFloat  minLabelY = CGRectGetMaxY(maxLabel.frame);
    CGFloat  minLabelW = shousuoyaWidth;
    CGFloat  minLabelH = 10*HeightProportion;
    minLabel.frame = CGRectMake(minLabelX, minLabelY, minLabelW, minLabelH);
    shousuoyaViewH = CGRectGetMaxY(minLabel.frame);
    shousuoyaView.frame = CGRectMake(shousuoyaViewX, shousuoyaViewY, shousuoyaViewW, shousuoyaViewH);
    return shousuoyaView;
}
//创建详细的收缩压值
-(UIView *)shousuoyaDetailView
{
    UIView *shousuoyaDetailView = [[UIView alloc]init];
    
    UILabel *fontLabel = [[UILabel alloc]init];
    [shousuoyaDetailView addSubview:fontLabel];
    fontLabel.font = DetailViewFont;
    fontLabel.text = NSLocalizedString(@"标准值", nil);
    
    fontLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat fontLabelX = 0;
    CGFloat fontLabelY = 0;
    CGFloat fontLabelW = DetailViewWidth;
    CGFloat fontLabelH = DetailViewContentHeight;
    fontLabel.frame = CGRectMake(fontLabelX, fontLabelY, fontLabelW, fontLabelH);
    [fontLabel sizeToFit];
    
    UILabel *shousuoyaMolecularLabel = [[UILabel alloc]init];
    [shousuoyaDetailView addSubview:shousuoyaMolecularLabel];
    shousuoyaMolecularLabel.font = DetailViewFont;
    shousuoyaMolecularLabel.text = @"90";
    shousuoyaMolecularLabel.textAlignment = NSTextAlignmentCenter;
    
    CGFloat shousuoyaMolecularLabelX = 0;
    CGFloat shousuoyaMolecularLabelY = CGRectGetMaxY(fontLabel.frame);
    CGFloat shousuoyaMolecularLabelW = fontLabelW;
    CGFloat shousuoyaMolecularLabelH = fontLabelH;
    shousuoyaMolecularLabel.frame = CGRectMake(shousuoyaMolecularLabelX, shousuoyaMolecularLabelY, shousuoyaMolecularLabelW, shousuoyaMolecularLabelH);
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor blackColor];
    [shousuoyaDetailView addSubview:lineView];
    CGFloat lineViewX = fontLabelW / 4;
    CGFloat lineViewY = CGRectGetMaxY(shousuoyaMolecularLabel.frame);
    CGFloat lineViewW = fontLabelW / 2;
    CGFloat lineViewH = 1;
    lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
    
    
    UILabel *shousuoyaDenominatorLabel = [[UILabel alloc]init];
    [shousuoyaDetailView addSubview:shousuoyaDenominatorLabel];
    shousuoyaDenominatorLabel.font = DetailViewFont;
    shousuoyaDenominatorLabel.text = @"139";
    shousuoyaDenominatorLabel.textAlignment = NSTextAlignmentCenter;
    
    CGFloat shousuoyaDenominatorLabelX = 0;
    CGFloat shousuoyaDenominatorLabelY = CGRectGetMaxY(lineView.frame);
    CGFloat shousuoyaDenominatorLabelW = fontLabelW;
    CGFloat shousuoyaDenominatorLabelH = shousuoyaMolecularLabelH;
    shousuoyaDenominatorLabel.frame = CGRectMake(shousuoyaDenominatorLabelX, shousuoyaDenominatorLabelY, shousuoyaDenominatorLabelW, shousuoyaDenominatorLabelH);
    
    
    CGFloat shousuoyaDetailViewX = 0;
    CGFloat shousuoyaDetailViewY = 0;
    CGFloat shousuoyaDetailViewW = fontLabelW;
    CGFloat shousuoyaDetailViewH = CGRectGetMaxY(shousuoyaDenominatorLabel.frame);
    shousuoyaDetailView.frame = CGRectMake(shousuoyaDetailViewX, shousuoyaDetailViewY, shousuoyaDetailViewW, shousuoyaDetailViewH);
    
    return  shousuoyaDetailView;
}

-(UIView *)shuzhangyaDetailView
{
    UIView *shuzhangyaDetailView = [[UIView alloc]init];
    
    UILabel *fontLabel = [[UILabel alloc]init];
    [shuzhangyaDetailView addSubview:fontLabel];
    fontLabel.font = DetailViewFont;
    fontLabel.text = NSLocalizedString(@"标准值", nil);
    fontLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat fontLabelX = 0;
    CGFloat fontLabelY = 0;
    CGFloat fontLabelW = DetailViewWidth;
    CGFloat fontLabelH = DetailViewContentHeight;
    fontLabel.frame = CGRectMake(fontLabelX, fontLabelY, fontLabelW, fontLabelH);
    [fontLabel sizeToFit];
    
    UILabel *shousuoyaMolecularLabel = [[UILabel alloc]init];
    [shuzhangyaDetailView addSubview:shousuoyaMolecularLabel];
    shousuoyaMolecularLabel.font = DetailViewFont;
    shousuoyaMolecularLabel.text = @"60";
    shousuoyaMolecularLabel.textAlignment = NSTextAlignmentCenter;
    
    CGFloat shousuoyaMolecularLabelX = 0;
    CGFloat shousuoyaMolecularLabelY = CGRectGetMaxY(fontLabel.frame);
    CGFloat shousuoyaMolecularLabelW = fontLabelW;
    CGFloat shousuoyaMolecularLabelH = fontLabelH;
    shousuoyaMolecularLabel.frame = CGRectMake(shousuoyaMolecularLabelX, shousuoyaMolecularLabelY, shousuoyaMolecularLabelW, shousuoyaMolecularLabelH);
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor blackColor];
    [shuzhangyaDetailView addSubview:lineView];
    CGFloat lineViewX = fontLabelW / 4;
    CGFloat lineViewY = CGRectGetMaxY(shousuoyaMolecularLabel.frame);
    CGFloat lineViewW = fontLabelW / 2;
    CGFloat lineViewH = 1;
    lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
    
    
    UILabel *shousuoyaDenominatorLabel = [[UILabel alloc]init];
    [shuzhangyaDetailView addSubview:shousuoyaDenominatorLabel];
    shousuoyaDenominatorLabel.font = DetailViewFont;
    shousuoyaDenominatorLabel.text = @"89";
    shousuoyaDenominatorLabel.textAlignment = NSTextAlignmentCenter;
    
    CGFloat shousuoyaDenominatorLabelX = 0;
    CGFloat shousuoyaDenominatorLabelY = CGRectGetMaxY(lineView.frame);
    CGFloat shousuoyaDenominatorLabelW = fontLabelW;
    CGFloat shousuoyaDenominatorLabelH = shousuoyaMolecularLabelH;
    shousuoyaDenominatorLabel.frame = CGRectMake(shousuoyaDenominatorLabelX, shousuoyaDenominatorLabelY, shousuoyaDenominatorLabelW, shousuoyaDenominatorLabelH);
    
    
    CGFloat shuzhangyaDetailViewX = 0;
    CGFloat shuzhangyaDetailViewY = 0;
    CGFloat shuzhangyaDetailViewW = fontLabelW;
    CGFloat shuzhangyaDetailViewH = CGRectGetMaxY(shousuoyaDenominatorLabel.frame);
    shuzhangyaDetailView.frame = CGRectMake(shuzhangyaDetailViewX, shuzhangyaDetailViewY, shuzhangyaDetailViewW, shuzhangyaDetailViewH);
    
    return  shuzhangyaDetailView;
}
-(UIView *)xinlvDetailView
{
    UIView *xinlvDetailView = [[UIView alloc]init];
    xinlvDetailView.backgroundColor = [UIColor clearColor];
    
    UILabel *fontLabel = [[UILabel alloc]init];
    [xinlvDetailView addSubview:fontLabel];
    fontLabel.font = DetailViewFontPre;
    fontLabel.text = NSLocalizedString(@"标准值", nil);
    
    fontLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat fontLabelX = 0;
    CGFloat fontLabelY = 0;
    CGFloat fontLabelW = DetailViewWidth;
    CGFloat fontLabelH = DetailViewContentHeightPre;
    [fontLabel sizeToFit];
    fontLabelW = fontLabel.width;
    fontLabel.frame = CGRectMake(fontLabelX, fontLabelY, fontLabelW, fontLabelH);
    
    UILabel *xinlvMolecularLabel = [[UILabel alloc]init];
    [xinlvDetailView addSubview:xinlvMolecularLabel];
    xinlvMolecularLabel.font = DetailViewFontPre;
    xinlvMolecularLabel.text = @"60";
    xinlvMolecularLabel.textAlignment = NSTextAlignmentCenter;
    
    CGFloat xinlvMolecularLabelX = 0;
    CGFloat xinlvMolecularLabelY = CGRectGetMaxY(fontLabel.frame);
    CGFloat xinlvMolecularLabelW = fontLabelW;
    CGFloat xinlvMolecularLabelH = fontLabelH;
    xinlvMolecularLabel.frame = CGRectMake(xinlvMolecularLabelX, xinlvMolecularLabelY, xinlvMolecularLabelW, xinlvMolecularLabelH);
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor blackColor];
    [xinlvDetailView addSubview:lineView];
    CGFloat lineViewX = fontLabelW / 4;
    CGFloat lineViewY = CGRectGetMaxY(xinlvMolecularLabel.frame);
    CGFloat lineViewW = fontLabelW / 2;
    CGFloat lineViewH = 1;
    lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
    
    
    UILabel *xinlvDenominatorLabel = [[UILabel alloc]init];
    [xinlvDetailView addSubview:xinlvDenominatorLabel];
    xinlvDenominatorLabel.font = DetailViewFontPre;
    xinlvDenominatorLabel.text = @"89";
    xinlvDenominatorLabel.textAlignment = NSTextAlignmentCenter;
    
    CGFloat xinlvDenominatorLabelX = 0;
    CGFloat xinlvDenominatorLabelY = CGRectGetMaxY(lineView.frame);
    CGFloat xinlvDenominatorLabelW = fontLabelW;
    CGFloat xinlvDenominatorLabelH = xinlvMolecularLabelH;
    xinlvDenominatorLabel.frame = CGRectMake(xinlvDenominatorLabelX, xinlvDenominatorLabelY, xinlvDenominatorLabelW, xinlvDenominatorLabelH);
    
    
    CGFloat xinlvDetailViewX = 0;
    CGFloat xinlvDetailViewY = 0;
    CGFloat xinlvDetailViewW = fontLabelW;
    CGFloat xinlvDetailViewH = CGRectGetMaxY(xinlvDenominatorLabel.frame);
    xinlvDetailView.frame = CGRectMake(xinlvDetailViewX, xinlvDetailViewY, xinlvDetailViewW, xinlvDetailViewH);
    
    return  xinlvDetailView;
}

-(UIView *)numberView
{
    UIView  *numberView;
    
    return numberView;
    
}


//中间层的view
-(void)setupMiddleView
{
    UIView *middleView = [[UIView alloc]init];
    [_backALLView addSubview:middleView];
    middleView.backgroundColor = allColorWhite;
    _middleView = middleView;
    
    //SPO2%
    UILabel *spoLabel = [[UILabel alloc]init];
    [middleView addSubview:spoLabel];
    spoLabel.textAlignment = NSTextAlignmentRight;
    CGFloat spoLabelX = CurrentDeviceWidth/3;
    CGFloat spoLabelY = 0;
    CGFloat spoLabelW = CurrentDeviceWidth / 4;
    CGFloat spoLabelH = 35;
    spoLabel.frame = CGRectMake(spoLabelX, spoLabelY, spoLabelW, spoLabelH);
    
    //SPO2%   number
    UILabel *spoNumberLabel = [[UILabel alloc]init];
    [middleView addSubview:spoNumberLabel];
    //    spoNumberLabel.textAlignment = NSTextAlignmentRight;
    CGFloat spoNumberLabelX = CGRectGetMaxX(spoLabel.frame);
    CGFloat spoNumberLabelY = 0;
    CGFloat spoNumberLabelW = spoLabelW;
    CGFloat spoNumberLabelH = spoLabelH;
    spoNumberLabel.frame = CGRectMake(spoNumberLabelX, spoNumberLabelY, spoNumberLabelW, spoNumberLabelH);
    spoLabel.text = @"SPO2%";
    spoNumberLabel.text = @"  0";
    _spoNumberLabel = spoNumberLabel;
    
    //    UIView *lineView = [[UIView alloc]init];
    //    lineView.backgroundColor = [UIColor grayColor];
    //    [middleView addSubview:lineView];
    //    CGFloat lineViewX = CGRectGetMaxX(spoNumberLabel.frame);
    //    CGFloat lineViewY = 5;
    //    CGFloat lineViewW = 1;
    //    CGFloat lineViewH = spoNumberLabelH - 2 * lineViewY;
    //    lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
    
    
    //HRV
    //    UILabel *HRVLabel = [[UILabel alloc]init];
    //    [middleView addSubview:HRVLabel];
    //    HRVLabel.textAlignment = NSTextAlignmentRight;
    //    CGFloat HRVLabelX = CGRectGetMaxX(spoNumberLabel.frame);
    //    CGFloat HRVLabelY = 0;
    //    CGFloat HRVLabelW = spoNumberLabelW;
    //    CGFloat HRVLabelH = spoNumberLabelH;
    //    HRVLabel.frame = CGRectMake(HRVLabelX, HRVLabelY, HRVLabelW, HRVLabelH);
    //
    //    //HRV number
    //    UILabel *HRVNumberLabel = [[UILabel alloc]init];
    //    [middleView addSubview:HRVNumberLabel];
    //
    //    //    HRVNumberLabel.textAlignment = NSTextAlignmentRight;
    //    CGFloat HRVNumberLabelX = CGRectGetMaxX(HRVLabel.frame);
    //    CGFloat HRVNumberLabelY = 0;
    //    CGFloat HRVNumberLabelW = HRVLabelW;
    //    CGFloat HRVNumberLabelH = HRVLabelH;
    //    HRVNumberLabel.frame = CGRectMake(HRVNumberLabelX, HRVNumberLabelY, HRVNumberLabelW, HRVNumberLabelH);
    //
    
    //    HRVLabel.text = @"HRV";
    //    HRVNumberLabel.text = @"  正常";
    //
    CGFloat middleViewX = 0;
    CGFloat middleViewY = CGRectGetMaxY(self.upperView.frame);
    CGFloat middleViewW = CurrentDeviceWidth;
    CGFloat middleViewH = CGRectGetMaxY(spoLabel.frame);
    middleView.frame = CGRectMake(middleViewX, middleViewY, middleViewW, middleViewH);
    
}
//下层的view
-(void)setupDownView
{
    _downView = [[UIView alloc]init];
    [_backALLView addSubview:_downView];
    _downView.backgroundColor = allColorWhite;  //[UIColor redColor];
    CGFloat downViewX = 5 * WidthProportion;
    CGFloat downViewY = CGRectGetMaxY(_middleView.frame) + 10 * HeightProportion;
    CGFloat downViewW = CurrentDeviceWidth - 2 * downViewX;
    CGFloat downViewH = self.backALLView.height - downViewY;
    _downView.frame = CGRectMake(downViewX, downViewY, downViewW, downViewH);
    
    //    UIScrollView *scrollView = [[UIScrollView alloc] init];
    //    scrollView.frame = CGRectMake(0, 0, 300, 30);
    //    scrollView.backgroundColor = [UIColor grayColor];
    //    [_downView addSubview:scrollView];
    //    scrollView.contentSize = CGSizeMake(600, 0);
    
    [self  addXYLabel];
    //绘制折线图
    //    [self setupChart];
    
    //    [self  addYLabel:_downView];
    //    [self setupChartView];  //绘制折线图
    [self setupTagView]; //标识界面
    
}
-(void)setupChart
{
    [self huitu];
    
    CGFloat XlabelX = CGRectGetMinX(_lineView.frame);
    CGFloat XlabelH = _YlabelH;
    CGFloat XlabelY = self.nightBloodScrollView.height - XlabelH;
    CGFloat XlabelW = self.nightBloodScrollView.width / 9;
    NSInteger number = _bloodArray.count > 9 ? _bloodArray.count : 9;
    
    UIView *downViewLine = [[UIView alloc]initWithFrame:CGRectMake(0, XlabelY, number * XlabelW, XlabelH)];
    [self.nightBloodScrollView addSubview:downViewLine];
    downViewLine.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < number; i++)
    {
        XlabelX = XlabelW * i;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(XlabelX, 0, XlabelW, XlabelH)];
        [downViewLine addSubview:label];
        label.backgroundColor = [UIColor clearColor];
        //        label.alpha = 0.3;
        label.text = [NSString stringWithFormat:@"%02d",(i+1)];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:8];
    }
    
}
//计算真实的显示  高度
-(NSInteger)dictionaryToNsinteger:(NSDictionary *)dictionary   property:(NSString *)string
{
    NSInteger tempSousuo = 0;
    NSInteger zhenshiHeight = 0;
    NSDictionary *blood = dictionary;
    tempSousuo = [blood[string] integerValue]- 40;//这是血压的数值计算
    //    //adaLog(@"tempSousuo = %ld",tempSousuo);
    zhenshiHeight = (tempSousuo / 140.0 * (self.nightBloodScrollView.height - 20*HeightProportion));// - 10*HeightProportion
    //    //adaLog(@"zhenshiHeight = %ld",zhenshiHeight);
    
    return  zhenshiHeight;
}

-(void)addImageAndButtonWithImageType:(NSInteger)ImageType   butttonTag:(NSInteger)butttonTag  point:(CGPoint)point
{
    NSInteger imageViewW = 17*WidthProportion;
    NSInteger imageViewH = imageViewW;
    UIImageView * imageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageViewW, imageViewH)];
    [self.nightBloodScrollView addSubview:imageView];
    imageView.center = point;
    imageView.tag = sousuoImageViewTag;
    //    imageView.backgroundColor = allColorRed;
    if (ImageType<2)
    {
        imageView.image = [UIImage imageNamed:@"smaller_pressure"];
    }
    else
    {
        imageView.image = [UIImage imageNamed:@"SmallGreen_pressure"];
    }
    CGFloat marginW = self.nightBloodScrollView.width / 9;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, marginW, marginW)];
    [self.nightBloodScrollView addSubview:button];
    button.center = point;
    button.tag = butttonTag;
    button.backgroundColor = [UIColor clearColor];
    button.alpha = 0.3;
    [button addTarget:self action:@selector(buttonTime:) forControlEvents:UIControlEventTouchUpInside];
}

// 点击按钮显示时间
-(void)buttonTime:(UIButton *)sender
{
    //    CGFloat marginW = self.nightBloodScrollView.width / 9;
    if(sender.tag < _bloodArray.count)
    {
        NSDictionary *blood = _bloodArray[sender.tag];
        NSInteger tempSousuoHuitu  = self.nightBloodScrollView.height - _YlabelH-[self dictionaryToNsinteger:blood property:@"systolicPressure"];
        CGFloat imageViewX = 0;
        CGFloat imageViewW = 50*WidthProportion;
        CGFloat imageViewH = 20*WidthProportion;
        CGFloat imageViewY = tempSousuoHuitu - imageViewH - 5*HeightProportion;
        self.showLabelView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
        if(sender.tag > 0)
        {
            self.showLabelView.centerX = sender.centerX;
        }
        else
        {
            self.showLabelView.centerX =(sender.centerX + imageViewW / 2);
            
        }
        //        self.showLabelView.centerX = sender.centerX;
        //        self.showLabelView.backgroundColor = allColorRed;
        
        CGFloat labelNumberX = 0;
        CGFloat labelNumberY = 2*HeightProportion;
        CGFloat labelNumberW = imageViewW;
        CGFloat labelNumberH = (imageViewH - 2 * labelNumberY);
        self.labelNumber.frame = CGRectMake(labelNumberX, labelNumberY, labelNumberW, labelNumberH);
        //设置显示的值
        self.labelNumber.text = [AllTool timecutting:blood[@"StartTime"]];//[NSString stringWithFormat:@"%d",1212];
        self.labelNumber.adjustsFontSizeToFitWidth = YES;
        _labelNumber.textColor =  fontcolorMain;
        _labelNumber.backgroundColor = [UIColor clearColor];
    }
    
    [self.nightBloodScrollView addSubview:self.showLabelView];
    [self.showLabelView addSubview:_labelNumber];
    
}


-(void)huitu
{
    if(arctempSousuo)
    {   [arctempSousuo removeAnimationForKey:@"drawCircleAnimation"];
        [arctempSousuo removeFromSuperlayer]; arctempSousuo = nil;
        [gradientLayerSousuo removeFromSuperlayer]; gradientLayerSousuo = nil;
        //[self.nightBloodScrollView.layer addSublayer:arctempSousuo];
        //[arctempSousuo addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
        //[self.nightBloodScrollView.layer addSublayer:gradientLayerSousuo];//加上渐变层
        for (UIButton *btn in self.nightBloodScrollView.subviews)
        {
            [btn removeFromSuperview];
        }
        for (UIView *imageView in self.nightBloodScrollView.subviews)
        {
            if (imageView.tag == sousuoImageViewTag)
            {
                [imageView removeFromSuperview];
            }
        }
    }
    if(!arctempSousuo)
    {arctempSousuo = [CAShapeLayer layer];
    }
    if(!gradientLayerSousuo)
    {  gradientLayerSousuo = [CAGradientLayer layer];
    }
    if (_bloodArray.count > 0)
    {
        CGFloat marginW = self.nightBloodScrollView.width / 9;
        //添加坐标的坐标点
        if(!pathtempSousuo)
        {
            pathtempSousuo=[[UIBezierPath alloc] init];}
        self.nightBloodScrollView.contentSize = CGSizeMake(marginW * _bloodArray.count,0);//marginW * _bloodArray.count
        self.nightBloodScrollView.bounces = NO;
        NSInteger pathtempX = 0;
        NSInteger pathtempY = 0;
        NSInteger maxSousuo = 0;
        //        NSInteger tempSousuo = 0;
        NSInteger tempSousuoHuitu = 0;
        //        NSInteger zhenshiHeight = 0;
        for (int i =0 ; i < _bloodArray.count; i++) {
            tempSousuoHuitu = self.nightBloodScrollView.height - _YlabelH-[self dictionaryToNsinteger:_bloodArray[i] property:@"systolicPressure"];
            if (tempSousuoHuitu < maxSousuo) {
                maxSousuo = tempSousuoHuitu;  }
            if (i ==0)
            {
                [pathtempSousuo moveToPoint:CGPointMake(0, tempSousuoHuitu)];
            }
            else
            {
                pathtempX = marginW * i;
                pathtempY = tempSousuoHuitu;
                //adaLog(@"pathtempX= %ld,pathtempY= %ld",pathtempX,pathtempY);
                [pathtempSousuo addLineToPoint:CGPointMake(pathtempX, pathtempY)];
            }
        }
        //把折线绘制到界面
        
        arctempSousuo.path =pathtempSousuo.CGPath;  //path->CGPath;
        arctempSousuo.strokeColor = [UIColor whiteColor].CGColor;
        arctempSousuo.fillColor = [UIColor clearColor].CGColor;
        arctempSousuo.lineWidth = 2;
        [self.nightBloodScrollView.layer addSublayer:arctempSousuo];
        //绘制线条的动画
        CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        drawAnimation.duration			= 5.0;
        drawAnimation.repeatCount		 = 1.0;
        drawAnimation.removedOnCompletion = NO;
        drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        drawAnimation.toValue   = [NSNumber numberWithFloat:10.0f];
        drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [arctempSousuo addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
        
        //绘制渐变色层
        
        gradientLayerSousuo.frame =CGRectMake(0, 0, (_bloodArray.count-1) * marginW,600*HeightProportion) ;// self.view.frame;
        gradientLayerSousuo.colors =  @[(__bridge id)[UIColor colorWithRed:78.0/255.0 green:193.0/255.0 blue:254.0/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:185.0/255.0 green:231.0/255.0 blue:255.0/255.0 alpha:1].CGColor,(__bridge id)[UIColor whiteColor].CGColor];//,(__bridge id)[UIColor yellowColor].CGColor
        gradientLayerSousuo.locations=@[@0.0,@0.2,@0.5,@0.8,@0.9,@1.0];
        gradientLayerSousuo.startPoint = CGPointMake(0.5,0.0);
        gradientLayerSousuo.endPoint = CGPointMake(0.5,1.0);
        [self.nightBloodScrollView.layer addSublayer:gradientLayerSousuo];//加上渐变层
        //============第一种方式添加路径->这个是绘制渐变需要的
        if(!pathSousuo){
            pathSousuo=[[UIBezierPath alloc] init];}
        NSInteger pathX = 0;
        NSInteger pathY = 0;
        
        for (int i =0 ; i < _bloodArray.count; i++) {
            tempSousuoHuitu = self.nightBloodScrollView.height - _YlabelH-[self dictionaryToNsinteger:_bloodArray[i] property:@"systolicPressure"];
            if (tempSousuoHuitu < maxSousuo) {
                maxSousuo = tempSousuoHuitu; }
            if (i ==0)
            {
                [pathSousuo moveToPoint:CGPointMake(0, tempSousuoHuitu)];
                [pathSousuo addLineToPoint:CGPointMake(0,self.nightBloodScrollView.frame.size.height)];
                [pathSousuo addLineToPoint:CGPointMake(marginW * (_bloodArray.count-1),self.nightBloodScrollView.frame.size.height)];
                
            }
            else
            {
                NSInteger num =_bloodArray.count-i;
                tempSousuoHuitu = self.nightBloodScrollView.height -_YlabelH-[self dictionaryToNsinteger:_bloodArray[num] property:@"systolicPressure"];
                pathX = marginW * (_bloodArray.count - i);
                pathY = tempSousuoHuitu;
                //adaLog(@"pathX= %ld,pathY= %ld",pathX,pathY);
                [pathSousuo addLineToPoint:CGPointMake(pathX, pathY)];
            }
        }
        [pathSousuo closePath];
        if(!arcSousuo){
            arcSousuo = [CAShapeLayer layer];}
        arcSousuo.path =pathSousuo.CGPath;
        arcSousuo.fillColor = [UIColor whiteColor].CGColor;
        arcSousuo.strokeColor = [UIColor yellowColor].CGColor;
        arcSousuo.lineWidth = 1;
        gradientLayerSousuo.mask=arcSousuo;
        
        for (int i =0 ; i < _bloodArray.count; i++) {
            tempSousuoHuitu = self.nightBloodScrollView.height - _YlabelH-[self dictionaryToNsinteger:_bloodArray[i] property:@"systolicPressure"];
            if (i ==0)
            {
                CGPoint point = CGPointMake(0, tempSousuoHuitu);
                [self addImageAndButtonWithImageType:1 butttonTag:i point:point];
            }
            else
            {
                pathtempX = marginW * i;
                pathtempY = tempSousuoHuitu;
                CGPoint point = CGPointMake(pathtempX,pathtempY);
                [self addImageAndButtonWithImageType:1 butttonTag:i point:point];
            }
        }
    }
    else
    {
        [arctempSousuo removeFromSuperlayer]; arctempSousuo = nil;
        [gradientLayerSousuo removeFromSuperlayer]; gradientLayerSousuo = nil;
#pragma mark  清除图表
    }
    [self shuzhangYa];
}
-(void)shuzhangYa
{
    NSString *shuzhangKEY = @"drawCircleAnimationShuzhang";
    for (UIView *imageView in self.nightBloodScrollView.subviews)
    {
        if (imageView.tag == shuzhangImageViewTag)
        {
            [imageView removeFromSuperview];
        }
    }
    [arctempShuzh removeAnimationForKey:shuzhangKEY];
    [arctempShuzh removeFromSuperlayer]; arctempShuzh = nil;
    [gradientLayerShuzh removeFromSuperlayer]; gradientLayerShuzh = nil;
    if (_bloodArray.count > 0)
    {
        CGFloat marginW = self.nightBloodScrollView.width / 9;
        self.nightBloodScrollView.contentSize = CGSizeMake(marginW * _bloodArray.count,0);//marginW * _bloodArray.count
        self.nightBloodScrollView.bounces = NO;
        //添加坐标的坐标点
        if (!pathtempShuzh) {
            pathtempShuzh=[[UIBezierPath alloc] init];
        }
        
        
        NSInteger pathtempX = 0;
        NSInteger pathtempY = 0;
        NSInteger maxSousuo = 0;
        //        NSInteger tempSousuo = 0;
        NSInteger tempSousuoHuitu = 0;
        //        NSInteger zhenshiHeight = 0;
        for (int i =0 ; i < _bloodArray.count; i++) {
            tempSousuoHuitu = self.nightBloodScrollView.height - _YlabelH-[self dictionaryToNsinteger:_bloodArray[i] property:@"diastolicPressure"];
            if (tempSousuoHuitu < maxSousuo) {
                maxSousuo = tempSousuoHuitu;  }
            if (i ==0)
            {
                [pathtempShuzh moveToPoint:CGPointMake(0, tempSousuoHuitu)];
            }
            else
            {
                pathtempX = marginW * i;
                pathtempY = tempSousuoHuitu;
                [pathtempShuzh addLineToPoint:CGPointMake(pathtempX, pathtempY)];
            }
        }
        //把折线绘制到界面
        if(!arctempShuzh){
            arctempShuzh = [CAShapeLayer layer];
        }
        arctempShuzh.path =pathtempShuzh.CGPath;  //path->CGPath;
        arctempShuzh.strokeColor = [UIColor whiteColor].CGColor;
        arctempShuzh.fillColor = [UIColor clearColor].CGColor;
        arctempShuzh.lineWidth = 2;
        [self.nightBloodScrollView.layer addSublayer:arctempShuzh];
        //绘制线条的动画
        CABasicAnimation *drawAnimationShuzh = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        drawAnimationShuzh.duration			= 5.0;
        drawAnimationShuzh.repeatCount		 = 1.0;
        drawAnimationShuzh.removedOnCompletion = NO;
        drawAnimationShuzh.fromValue = [NSNumber numberWithFloat:0.0f];
        drawAnimationShuzh.toValue   = [NSNumber numberWithFloat:10.0f];
        drawAnimationShuzh.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [arctempShuzh addAnimation:drawAnimationShuzh forKey:shuzhangKEY];
        
        //绘制渐变色层
        if (!gradientLayerShuzh) {
            gradientLayerShuzh = [CAGradientLayer layer];
        }
        
        gradientLayerShuzh.frame =CGRectMake(0, 0, (_bloodArray.count-1) * marginW,600) ;// self.view.frame;
        gradientLayerShuzh.colors = @[(__bridge id)[UIColor colorWithRed:100.0/255.0 green:233.0/255.0 blue:212.0/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:100.0/255.0 green:233.0/255.0 blue:212.0/255.0 alpha:1].CGColor,(__bridge id)[UIColor whiteColor].CGColor];//,(__bridge id)[UIColor yellowColor].CGColor
        gradientLayerShuzh.locations=@[@0.0,@0.2,@0.5,@0.8,@0.9,@1.0];
        gradientLayerShuzh.startPoint = CGPointMake(0.5,0.2);
        gradientLayerShuzh.endPoint = CGPointMake(0.5,1);
        [self.nightBloodScrollView.layer addSublayer:gradientLayerShuzh];//加上渐变层
        //============第一种方式添加路径->这个是绘制渐变需要的
        if (!pathShuzh) {
            pathShuzh=[[UIBezierPath alloc] init];
        }
        
        NSInteger pathX = 0;
        NSInteger pathY = 0;
        
        for (int i =0 ; i < _bloodArray.count; i++) {
            tempSousuoHuitu = self.nightBloodScrollView.height - _YlabelH-[self dictionaryToNsinteger:_bloodArray[i] property:@"diastolicPressure"];
            if (tempSousuoHuitu < maxSousuo) {
                maxSousuo = tempSousuoHuitu;  }
            if (i ==0)
            {
                [pathShuzh moveToPoint:CGPointMake(0, tempSousuoHuitu)];
                [pathShuzh addLineToPoint:CGPointMake(0,self.nightBloodScrollView.frame.size.height)];
                [pathShuzh addLineToPoint:CGPointMake(marginW * (_bloodArray.count-1),self.nightBloodScrollView.frame.size.height)];
            }
            else
            {
                NSInteger num =_bloodArray.count-i;
                tempSousuoHuitu = self.nightBloodScrollView.height -_YlabelH-[self dictionaryToNsinteger:_bloodArray[num] property:@"diastolicPressure"];
                pathX = marginW * (_bloodArray.count - i);
                pathY = tempSousuoHuitu;
                [pathShuzh addLineToPoint:CGPointMake(pathX, pathY)];
            }
        }
        [pathShuzh closePath];
        if (!arcShuzh) {
            arcShuzh = [CAShapeLayer layer];
        }
        
        arcShuzh.path =pathShuzh.CGPath;
        arcShuzh.fillColor = [UIColor whiteColor].CGColor;
        arcShuzh.strokeColor = [UIColor clearColor].CGColor;
        arcShuzh.lineWidth = 1;
        gradientLayerShuzh.mask=arcShuzh;
        
        for (int i =0 ; i < _bloodArray.count; i++) {
            tempSousuoHuitu = self.nightBloodScrollView.height - _YlabelH-[self dictionaryToNsinteger:_bloodArray[i] property:@"diastolicPressure"];
            if (i ==0)
            {
                CGPoint point = CGPointMake(0, tempSousuoHuitu);
                [self shuzhanAddImageAndButtonWithImageType:2 butttonTag:i point:point];
            }
            else
            {
                pathtempX = marginW * i;
                pathtempY = tempSousuoHuitu;
                CGPoint point = CGPointMake(pathtempX,pathtempY);
                [self shuzhanAddImageAndButtonWithImageType:2 butttonTag:i point:point];
            }
        }
    }
}

-(void)shuzhanAddImageAndButtonWithImageType:(NSInteger)ImageType   butttonTag:(NSInteger)butttonTag  point:(CGPoint)point
{
    NSInteger imageViewW = 17 *WidthProportion;
    NSInteger imageViewH = imageViewW;
    UIImageView * imageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageViewW, imageViewH)];
    [self.nightBloodScrollView addSubview:imageView];
    imageView.center = point;
    
    imageView.image = [UIImage imageNamed:@"SmallGreen_pressure"];
    imageView.tag = shuzhangImageViewTag;
    
    CGFloat marginW = self.nightBloodScrollView.width / 9;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, marginW, marginW)];
    [self.nightBloodScrollView addSubview:button];
    button.center = point;
    button.tag = butttonTag;
    button.backgroundColor = [UIColor clearColor];
    button.alpha = 0.3;
    [button addTarget:self action:@selector(shuzhanButtonTime:) forControlEvents:UIControlEventTouchUpInside];
}

// 点击按钮显示时间
-(void)shuzhanButtonTime:(UIButton *)sender
{
    //    CGFloat marginW = self.nightBloodScrollView.width / 9;
    if(sender.tag < _bloodArray.count)
    {
        NSDictionary *blood = _bloodArray[sender.tag];
        NSInteger tempSousuoHuitu  = self.nightBloodScrollView.height - _YlabelH-[self dictionaryToNsinteger:blood property:@"diastolicPressure"];
        CGFloat imageViewX = 0;
        CGFloat imageViewW = 50*WidthProportion;
        CGFloat imageViewH = 20*WidthProportion;
        CGFloat imageViewY = tempSousuoHuitu - imageViewH - 5*HeightProportion;
        self.showLabelView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
        if(sender.tag > 0)
        {
            self.showLabelView.centerX = sender.centerX;
        }
        else
        {self.showLabelView.centerX =(sender.centerX + imageViewW / 2);
        }
        
        
        CGFloat labelNumberX = 0;
        CGFloat labelNumberY = 2*HeightProportion;
        CGFloat labelNumberW = imageViewW;
        CGFloat labelNumberH = (imageViewH - 2 * labelNumberY);
        self.labelNumber.frame = CGRectMake(labelNumberX, labelNumberY, labelNumberW, labelNumberH);
        //设置显示的值
        self.labelNumber.text = [AllTool timecutting:blood[@"StartTime"]];//[NSString stringWithFormat:@"%d",1212];
        self.labelNumber.adjustsFontSizeToFitWidth = YES;
        _labelNumber.textColor =  fontcolorMain;
        _labelNumber.backgroundColor = [UIColor clearColor];
    }
    
    [self.nightBloodScrollView addSubview:self.showLabelView];
    [self.showLabelView addSubview:_labelNumber];
    
}
- (void)addXYLabel
{
    CGFloat YlabelH = 20 * HeightProportion;
    _YlabelH = YlabelH;
    //    _XlabelH = 30 * HeightProportion;
    CGFloat BloodX = 30 * WidthProportion;
    CGFloat BloodW = _downView.width - BloodX;
    CGFloat BloodH = _downView.height * 0.77;
    CGFloat BloodY = _downView.height - BloodH;
    self.nightBloodScrollView = [[UIScrollView alloc] init];
    self.nightBloodScrollView.frame = CGRectMake(BloodX, BloodY,BloodW,BloodH);//nightBloodScrollView 的高是占用0.77
    //    self.nightBloodScrollView.showsHorizontalScrollIndicator = NO;
    self.nightBloodScrollView.backgroundColor = [UIColor clearColor];
    //    self.nightBloodScrollView.alpha = 0.2;
    self.nightBloodScrollView.showsVerticalScrollIndicator = NO;
    self.nightBloodScrollView.showsHorizontalScrollIndicator = NO;
    [_downView addSubview:self.nightBloodScrollView];
    //    self.nightBloodScrollView.contentSize = CGSizeMake(BloodW * 2, 0);
    
    CGFloat lineViewX = BloodX;
    CGFloat lineViewH = _downView.height * 0.77 - YlabelH;//nightBloodScrollView 的高是占用0.77 - YlabelH 这个高度
    CGFloat lineViewY = _downView.height - lineViewH - YlabelH;
    CGFloat lineViewW = 1;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH)];
    [_downView addSubview:lineView];
    lineView.backgroundColor = [UIColor grayColor];
    _lineView = lineView;
    
    
    //    CGFloat lineImageView1X = lineView.frame.origin.x;
    //    CGFloat lineImageView1H = 1;
    //    CGFloat lineImageView1Y = 0;
    //    CGFloat lineImageView1W = _downView.width - lineImageView1X - 5;
    
    for (int i = 0; i < 8; i++)
    {
        //        labelH = 20;
        CGFloat labelY = lineView.frame.origin.y - YlabelH / 2  + lineView.frame.size.height / 7 * (i);
        CGFloat labelX = 0;
        CGFloat labelW = lineViewX;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelX, labelY, labelW, YlabelH)];
        [_downView addSubview:label];
        label.backgroundColor = [UIColor clearColor];
        label.text = [NSString stringWithFormat:@"%d",180 - 20*i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:8];
        
        //        UIImageView *lineImageView1 = [[UIImageView alloc] init];
        //        [view addSubview:lineImageView1];
        //        lineImageView1.image = [UIImage imageNamed:@"XQ_pointLine"];
        //        lineImageView1.contentMode = UIViewContentModeScaleToFill;
        //        lineImageView1.frame = CGRectMake(lineImageView1X, lineImageView1Y, lineImageView1W, lineImageView1H);
        //        lineImageView1.centerY = label.centerY;
    }
    
    lineViewH = lineViewH + YlabelH / 2;
    lineViewY = lineViewY - YlabelH / 2;
    lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
    //    [_downView addSubview:lineView];
    
    
    CGFloat XlineViewX = CGRectGetMinX(_lineView.frame);
    CGFloat XlineViewY = CGRectGetMaxY(_lineView.frame);
    CGFloat XlineViewH = 1;
    CGFloat XlineViewW = _downView.width - CGRectGetMaxX(_lineView.frame);
    UIView *XlineView = [[UIView alloc]initWithFrame:CGRectMake(XlineViewX, XlineViewY, XlineViewW, XlineViewH)];
    [_downView addSubview:XlineView];
    XlineView.backgroundColor = [UIColor grayColor];
    _XlineView = XlineView;
    
}
//- (void)addYLabel:(UIView *)view
//{
//    CGFloat lineViewX = 30 * WidthProportion;
//    CGFloat lineViewH = _downView.height / 5 * 4;
//    CGFloat lineViewY = _downView.height / 5 - 20 * HeightProportion;
//    CGFloat lineViewW = 1;
//
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH)];
//    [_downView addSubview:lineView];
//    lineView.backgroundColor = [UIColor grayColor];
//    _lineView = lineView;
//    CGFloat labelH = 0;
//
//    CGFloat lineImageView1X = lineView.frame.origin.x;
//    CGFloat lineImageView1H = 1;
//    CGFloat lineImageView1Y = 0;
//    CGFloat lineImageView1W = view.width - lineImageView1X - 5 * WidthProportion;
//
//    for (int i = 0; i < 5; i++)
//    {
//        labelH = 20;
//        CGFloat labelY = lineView.frame.origin.y - labelH / 2  + lineView.frame.size.height / 5 * i;
//        CGFloat labelX = 0;
//        CGFloat labelW = lineViewX;
//
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
//        [view addSubview:label];
//        //        label.backgroundColor = [UIColor lightGrayColor];
//        label.text = [NSString stringWithFormat:@"%d",200 - 40*i];
//        label.textAlignment = NSTextAlignmentRight;
//        label.font = [UIFont systemFontOfSize:8];
//
//        UIImageView *lineImageView1 = [[UIImageView alloc] init];
//        [view addSubview:lineImageView1];
//        lineImageView1.image = [UIImage imageNamed:@"XQ_pointLine"];
//        lineImageView1.contentMode = UIViewContentModeScaleToFill;
//        lineImageView1.frame = CGRectMake(lineImageView1X, lineImageView1Y, lineImageView1W, lineImageView1H);
//        lineImageView1.centerY = label.centerY;
//    }
//    _labelH = labelH;
//    lineViewH = lineViewH + labelH / 2;
//    lineViewY = lineViewY - labelH / 2;
//    lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
//    //    [_downView addSubview:lineView];
//}


//标识界面
-(void)setupTagView
{
    UIView *tagView = [[UIView alloc]init];
    tagView.backgroundColor = [UIColor clearColor];
    
    [_downView addSubview:tagView];
    CGFloat tagViewX = CurrentDeviceWidth / 4;
    CGFloat tagViewY = 0;
    CGFloat tagViewW = CurrentDeviceWidth / 2;
    CGFloat tagViewH = 35 * HeightProportion;
    tagView.frame = CGRectMake(tagViewX, tagViewY, tagViewW, tagViewH);
    
    //舒张压
    UIImageView *imageView =[[UIImageView alloc]init];
    [tagView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"tag_shousuo_pressure"];
    imageView.clipsToBounds = YES;
    CGFloat imageViewX = 0;
    CGFloat imageViewY = tagViewH /2;
    CGFloat imageViewW = 10 * WidthProportion;
    CGFloat imageViewH = imageViewW;
    imageView.layer.cornerRadius = imageViewW / 2;
    imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    
    
    UILabel *label = [[UILabel alloc]init];
    [tagView addSubview:label];
    label.text = NSLocalizedString(@"收缩压", nil);
    
    CGFloat labelX = CGRectGetMaxX(imageView.frame)+6*WidthProportion;
    CGFloat labelY = 0;
    CGFloat labelW = tagViewW / 2 - imageViewW;
    CGFloat labelH = tagViewH;
    label.numberOfLines = 0;
    NSDictionary *dic1 = @{NSFontAttributeName:label.font};
    CGSize size1 = [label.text boundingRectWithSize:CGSizeMake(labelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic1 context:nil].size;
    labelH = size1.height;
    label.frame = CGRectMake(labelX, labelY, labelW, labelH);
    label.centerY = imageView.centerY;
    
    //收缩压
    UIImageView *imageViewShousuo =[[UIImageView alloc]init];
    [tagView addSubview:imageViewShousuo];
    imageViewShousuo.image = [UIImage imageNamed:@"tag_kuozhang_pressure"];
    imageViewShousuo.clipsToBounds = YES;
    CGFloat imageViewShousuoX = CGRectGetMaxX(label.frame) + 10*WidthProportion;
    CGFloat imageViewShousuoY = imageViewY;
    CGFloat imageViewShousuoW = 10 * WidthProportion;
    CGFloat imageViewShousuoH = imageViewShousuoW;
    imageViewShousuo.layer.cornerRadius = imageViewShousuoW / 2;
    imageViewShousuo.frame = CGRectMake(imageViewShousuoX, imageViewShousuoY, imageViewShousuoW, imageViewShousuoH);
    
    UILabel *labelshousuo = [[UILabel alloc]init];
    [tagView addSubview:labelshousuo];
    labelshousuo.text = NSLocalizedString(@"舒张压", nil) ;
    CGFloat labelshousuoW = labelW;
    CGFloat labelshousuoX = CGRectGetMaxX(imageViewShousuo.frame)+6*WidthProportion;//tagViewW - labelshousuoW;
    CGFloat labelshousuoY = 0;
    CGFloat labelshousuoH = tagViewH;
    labelshousuo.numberOfLines = 0;
    NSDictionary *dic2 = @{NSFontAttributeName:labelshousuo.font};
    CGSize size2 = [labelshousuo.text boundingRectWithSize:CGSizeMake(labelshousuoW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic2 context:nil].size;
    labelshousuoH = size2.height;
    labelshousuo.frame = CGRectMake(labelshousuoX, labelshousuoY, labelshousuoW, labelshousuoH);
    labelshousuo.centerY = imageViewShousuo.centerY;
}
//绘制折线图
//-(void)setupChartView
//{
//    CGFloat BloodX = _lineView.centerX;
//    CGFloat BloodY = _lineView.frame.origin.y + _labelH / 2;
//    CGFloat BloodW = _downView.width - CGRectGetMaxX(_lineView.frame);
//    CGFloat BloodH = _downView.height - BloodY;
//    self.nightBloodScrollView = [[UIScrollView alloc] init];
//    self.nightBloodScrollView.frame = CGRectMake(BloodX, BloodY,BloodW,BloodH);
//    self.nightBloodScrollView.showsHorizontalScrollIndicator = NO;
//    [_downView addSubview:self.nightBloodScrollView];
////    self.nightBloodScrollView.backgroundColor = allColorRed;
//
//
//    CGFloat chartViewX = 0;
//    CGFloat chartViewY = 0;
//    CGFloat chartViewW = BloodW;
//    CGFloat chartViewH = BloodH;
//
//    XueyaChartView *chartView = [[XueyaChartView alloc]initWithFrame:CGRectMake(chartViewX, chartViewY, chartViewW, chartViewH)];
//    _chartView = chartView;
//    [self.nightBloodScrollView addSubview:chartView];
//}
//-(void)setupLine
//{
//
//    CGFloat labelMargin = _downView.height / 6;
//    CGFloat labelX = 0;
//    CGFloat labelY = 0;
//    CGFloat labelW = 40;
//    CGFloat labelH = 30;
//
//    CGFloat Ydivision = 5;
//    for (NSInteger i = 0; i < Ydivision; i++) {
//        labelY = labelMargin * ( i + 1 );
//        UILabel * labelYdivision = [[UILabel alloc]initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
////           labelYdivision.backgroundColor = [UIColor greenColor];
////        labelYdivision.tag = 2000 + i;
////        labelYdivision.text = [NSString stringWithFormat:@"%.0f",(Ydivision - i)*40 +40];
////        labelYdivision.textAlignment = NSTextAlignmentRight;
////        labelYdivision.font = [UIFont systemFontOfSize:10];
////        labelYdivision.textColor = fontColor;
////        [_downView addSubview:labelYdivision];
////        labelYdivision.centerY = _downView.height / 6 * i+1;
//    }
//}
#pragma mark -- XueyaCorrectViewDelegate  代理。发送校正值
-(void)callbackChange
{
    [[CositeaBlueTooth sharedInstance] setupCorrectNumber];
    
}

-(UIImageView *)showLabelView
{
    if (!_showLabelView) {
        _showLabelView = [[UIImageView alloc]init];
        _showLabelView.image = [UIImage imageNamed:@"rectangle_pressure"];
    }
    return _showLabelView;
}

-(UILabel *)labelNumber
{
    if (!_labelNumber) {
        _labelNumber = [[UILabel alloc]init];
        _labelNumber.textAlignment = NSTextAlignmentCenter;
        _labelNumber.font = [UIFont systemFontOfSize:14];
    }
    return _labelNumber;
}

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning];  }



#pragma mark   ------- -- 连接状态的提示
-(void)BLOODremindView
{
    _BLOODchangLabel = [[UILabel alloc]init];
    
    //    [self.view addSubview:self.BLOODdoneView];
    //    self.BLOODdoneView.alpha = 0;
    
    _BLOODconStateView = [[ConnectStateView alloc]init];
    [self.view addSubview:_BLOODconStateView];
    CGFloat conStateViewX = 0;
    CGFloat conStateViewY = 64;
    CGFloat conStateViewW = CurrentDeviceWidth;
    CGFloat conStateViewH = 60*HeightProportion;
    _BLOODconStateView.frame = CGRectMake(conStateViewX,conStateViewY,conStateViewW,conStateViewH);
    
    
    
    _BLOODconnectButton = [[UIButton alloc]init];
    //    _connectButton.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];
    [_BLOODconStateView addSubview:_BLOODconnectButton];
    _BLOODconnectButton.frame = CGRectMake(0, 0, conStateViewW, conStateViewH);
    [_BLOODconnectButton addTarget:self action:@selector(BLOODconnectButtonToshebei) forControlEvents:UIControlEventTouchUpInside];
    _BLOODconnectButton.sd_layout
    .leftSpaceToView(_BLOODconStateView,0)
    .topSpaceToView(_BLOODconStateView,0)
    .rightSpaceToView(_BLOODconStateView,0)
    .bottomSpaceToView(_BLOODconStateView,0);
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(BLOODconnectionFailedAction:) name:@"ConnectTimeout" object:nil];
    [center addObserver:self selector:@selector(BLOODrefreshAlertView) name:@"didDisconnectDevice" object:nil];
}

//初始化提醒的view  的 刷新
-(void)BLOODrefreshAlertView
{
    self.BLOODconnectButton.userInteractionEnabled = NO;
    if([CositeaBlueTooth sharedInstance].isConnected)
    {
        self.backALLView.frame = CGRectMake(0,64,self.backALLView.frame.size.width, self.backALLView.frame.size.height);
        self.BLOODconStateView.alpha = 0;
    }
    else
    {
        self.BLOODconStateView.alpha = 1;
        if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
        {
            if(kHCH.BlueToothState == CBManagerStatePoweredOn)
            {
                //self.connectLabel.text = NSLocalizedString(@"连接中...", nil);
                if([[ADASaveDefaluts objectForKey:CALLBACKFORTY] integerValue] != 2)//可用
                {
                    self.BLOODconnectString = NSLocalizedString(@"连接中...", nil);
                }
                
            }
            else
            {
                self.BLOODconnectString  = NSLocalizedString(@"bluetoothNotOpen", nil);
                
            }
        }
        else
        {
            self.BLOODconnectString = NSLocalizedString(@"未绑定", nil);
            self.BLOODconnectButton.userInteractionEnabled = YES;
            self.BLOODconStateView.labeltextColor = [UIColor blueColor];
        }
    }
    
}

-(void)BLOODconnectionFailedAction:(int)isSeek
{
    
    if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
    {
   
    if([[ADASaveDefaluts objectForKey:CALLBACKFORTY] integerValue] == 2)//可用
    {
        if ([[ADASaveDefaluts objectForKey:SEARCHDEVICEISSEEK] integerValue] == 1)    //没有找到
        {
            //                    self.connectStringHight = 2;
            self.BLOODconnectString = NSLocalizedString(@"pleaseWakeupDeviceNotfound", nil);
            
        }
        else if ([[ADASaveDefaluts objectForKey:SEARCHDEVICEISSEEK] integerValue] == 2)   //找到了
        {
            //                    self.connectStringHight = 2;
            self.BLOODconnectString = NSLocalizedString(@"bluetoothConnectionFailed", nil);
        }
    }
        
    }
    else
    {
        //self.connectLabel.text = NSLocalizedString(@"未绑定", nil);
        self.BLOODconnectString = NSLocalizedString(@"未绑定", nil);
        self.BLOODconnectButton.userInteractionEnabled = YES;
        self.BLOODconStateView.labeltextColor = [UIColor blueColor];
    }
}

-(void)BLOODconnectButtonToshebei
{
    SheBeiViewController *shebeiVC = [SheBeiViewController sharedInstance];
    shebeiVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shebeiVC animated:YES];
}
-(void)refreshConnect
{
    WeakSelf;
    if ([CositeaBlueTooth sharedInstance].isConnected)
    {   [self BLOODConnected];
        [weakSelf performSelector:@selector(BLOODsubmitIsConnect) withObject:nil afterDelay:2.0f];
    }
}
#pragma mark --  代理。监测连接状态
- (void)BlueToothIsConnected:(BOOL)isconnected
{
    if (isconnected)
    {
        [self BLOODConnected];
        [self performSelector:@selector(BLOODsubmitIsConnect) withObject:nil afterDelay:2.0f];
    }
}
-(void)BLOODConnected
{
    self.BLOODconnectString = NSLocalizedString(@"connectSuccessfully", nil);
}
-(void)BLOODsubmitIsConnect
{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(BLOODsubmitIsConnect) object:nil];
    
//    [UIView animateWithDuration:1.5f animations:^{
        //        _connectView.hidden = YES;
        self.BLOODconStateView.alpha = 0;
        self.backALLView.frame = CGRectMake(0,64,self.backALLView.frame.size.width, self.backALLView.frame.size.height);
//    }];
}
-(void)BLOODsetblock
{
    WeakSelf;
    [[PZBlueToothManager sharedInstance] checkBandPowerWithPowerBlock:^(int number) {
        if ([CositeaBlueTooth sharedInstance].isConnected)
        {
            [self BLOODConnected];
            [weakSelf performSelector:@selector(BLOODsubmitIsConnect) withObject:nil afterDelay:2.0f];
        }
    }];
    
    [[CositeaBlueTooth sharedInstance]checkCBCentralManagerState:^(CBCentralManagerState state) {
        [weakSelf BLOODrefreshAlertView];
    }];
    [[CositeaBlueTooth sharedInstance] checkConnectTimeAlert:^(int number) {
        if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
        {
            [weakSelf BLOODconnectionFailedAction:number];
        }
    }];
    [BlueToothManager getInstance].delegate = self;
    
    //解除绑定要回调事件
    SheBeiViewController *shebei = [SheBeiViewController sharedInstance];
    [shebei changRemoveBinding:^(int number) {
        //adaLog(@"number2 == %d",number);
        if (number) {
            //[weakSelf SPOsubmitIsConnect];
            [weakSelf BLOODrefreshAlertView];
        }
    }];
    
}
-(void)setBLOODconnectString:(NSString *)BLOODconnectString
{
    _BLOODconnectString = BLOODconnectString;
    //adaLog(@"--- BLOODrt -- connectString - %@",BLOODconnectString);
    self.BLOODconStateView.stateString = BLOODconnectString;
    self.BLOODconStateView.labeltextColor = _BLOODchangLabel.textColor;
    NSDictionary *dicDown3 = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
    CGSize sizeDown3 = [BLOODconnectString boundingRectWithSize:CGSizeMake(CurrentDeviceWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicDown3 context:nil].size;
    NSInteger height = sizeDown3.height;
    
    if(height>self.BLOODconStateView.height)
    {
        self.BLOODconStateView.height =  height;
    }
    if(![BLOODconnectString isEqualToString:NSLocalizedString(@"connectSuccessfully", nil)])
    {
    self.backALLView.frame = CGRectMake(0,64+self.BLOODconStateView.height,self.backALLView.frame.size.width, self.backALLView.frame.size.height);
    }
    
}

#pragma mark   - -- 蓝牙状态的回调   --- delegate

-(void)callbackCBCentralManagerState:(CBCentralManagerState)state
{
    [self performSelector:@selector(BLOODrefreshAlertView) withObject:nil afterDelay:1.f];
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

//
//  HelpBandingViewController.m
//  Mistep
//
//  Created by 迈诺科技 on 2016/11/30.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "HelpBandingViewController.h"

@interface HelpBandingViewController ()
@property (nonatomic,strong) UILabel *titleLabel;//head的name
@property (nonatomic,strong) UIView *headView;//head的view
@end

@implementation HelpBandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[PSDrawerManager instance] cancelDragResponse];
}
-(void)setupView
{
     [self  setupHeadView];
//    [self initProperty];
//    [self  setupHeadView];
//    [self  setupUPView];
//    [self  setupMiddleView];
    [self  setupDownView];

}

-(void)setupHeadView
{
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CurrentDeviceWidth, 20)];
    [self.view addSubview:blackView];
    blackView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.headView];
    //导航条的背景图
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.headView.width, self.headView.height)];
    [self.headView addSubview:headImage];
    headImage.image = [UIImage imageNamed:@"导航条阴影"];
    
    
    UIButton *backButton = [[UIButton alloc]init];
    [self.headView addSubview:backButton];
    //    backButton.backgroundColor = [UIColor greenColor];
    [backButton setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backActionDetail) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat backButtonX = 0;
    CGFloat backButtonY = 0;
    CGFloat backButtonW = 44;
    CGFloat backButtonH = 44;
    backButton.frame = CGRectMake(backButtonX, backButtonY, backButtonW, backButtonH);
    
    [self.headView addSubview:self.titleLabel];
    //    self.titleLabel.centerX = self.headView.centerX;
    //    self.titleLabel.centerY = self.headView.centerY;
    self.titleLabel.sd_layout
    .centerXEqualToView(self.headView)
    .centerYEqualToView(self.headView);
    self.titleLabel.text = NSLocalizedString(@"绑定步骤", nil);
}
-(void)setupDownView
{
    self.view.backgroundColor = allColorWhite;
    CGFloat downViewX = 0;
    CGFloat downViewY = 64;
    CGFloat downViewW = CurrentDeviceWidth;
    CGFloat downViewH = CurrentDeviceHeight - downViewY;
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(downViewX, downViewY, downViewW, downViewH)];
    [self.view addSubview:downView];
    downView.backgroundColor = allColorWhite;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0,0, downViewW, downViewH);
    scrollView.backgroundColor = allColorWhite;
    [downView addSubview:scrollView];
   
    
    //开始添加label
    CGFloat ruheLabelX = 0;
    CGFloat ruheLabelY = 20*HeightProportion;
    CGFloat ruheLabelW = CurrentDeviceWidth;
    CGFloat ruheLabelH = ruheLabelY;
    UILabel *ruheLabel = [[UILabel alloc] initWithFrame:CGRectMake(ruheLabelX, ruheLabelY, ruheLabelW, ruheLabelH)];
    [scrollView addSubview:ruheLabel];
    ruheLabel.text = NSLocalizedString(@"如何绑定设备?", nil);
//    ruheLabel.backgroundColor = [UIColor greenColor];
    
    CGFloat label1X = 20*WidthProportion;
    CGFloat label1Y = CGRectGetMaxY(ruheLabel.frame);
    CGFloat label1W = CurrentDeviceWidth - 2*label1X;
    CGFloat label1H = ruheLabelH;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(label1X, label1Y, label1W, label1H)];
    [scrollView addSubview:label1];
    label1.text = NSLocalizedString(@"1、第一步:", nil);
//    label1.backgroundColor = [UIColor yellowColor];
    
   
    UILabel *dakaiLabel = [[UILabel alloc] init];
    [scrollView addSubview:dakaiLabel];
    dakaiLabel.text = NSLocalizedString(@"打开APP进入设备管理页面，并确认手机蓝牙已打开。", nil);
    dakaiLabel.numberOfLines = 0;
//    dakaiLabel.backgroundColor = [UIColor greenColor];
    CGFloat dakaiLabelX = label1X;
    CGFloat dakaiLabelY = CGRectGetMaxY(label1.frame);
    CGFloat dakaiLabelW = label1W;
    CGFloat dakaiLabelH = ruheLabelH;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
    CGSize size = [dakaiLabel.text boundingRectWithSize:CGSizeMake(dakaiLabelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    dakaiLabelH = size.height;
    dakaiLabel.frame = CGRectMake(dakaiLabelX, dakaiLabelY, dakaiLabelW, dakaiLabelH);
    
    CGFloat guanliImageViewX = 30*WidthProportion;
    CGFloat guanliImageViewY = CGRectGetMaxY(dakaiLabel.frame)+20*HeightProportion;
    CGFloat guanliImageViewW = CurrentDeviceWidth-guanliImageViewX*2;
    CGFloat guanliImageViewH = guanliImageViewW / 1.26;
    UIImageView *guanliImageView = [[UIImageView alloc] initWithFrame:CGRectMake(guanliImageViewX, guanliImageViewY, guanliImageViewW, guanliImageViewH)];
    [scrollView addSubview:guanliImageView];
    guanliImageView.image = [UIImage imageNamed:@"组-2"];
    
    CGFloat tucengSHLabelX = 0;
    CGFloat tucengSHLabelY = CGRectGetMinY(guanliImageView.frame) + 30*HeightProportion;
    CGFloat tucengSHLabelW = 0;
    CGFloat tucengSHLabelH = ruheLabelH;
    UILabel *tucengSHLabel = [[UILabel alloc] initWithFrame:CGRectMake(tucengSHLabelX, tucengSHLabelY, tucengSHLabelW, tucengSHLabelH)];
    [scrollView addSubview:tucengSHLabel];
    tucengSHLabel.text = NSLocalizedString(@"手环", nil);
    [tucengSHLabel sizeToFit];
    tucengSHLabel.centerX = guanliImageView.centerX;
//    tucengSHLabel.backgroundColor = [UIColor yellowColor];
    
    
    CGFloat weibdLabelX = 0;
    CGFloat weibdLabelY = CGRectGetMaxY(ruheLabel.frame);
    CGFloat weibdLabelW = CurrentDeviceWidth;
    CGFloat weibdLabelH = ruheLabelH;
    UILabel *weibdLabel = [[UILabel alloc] initWithFrame:CGRectMake(weibdLabelX, weibdLabelY, weibdLabelW, weibdLabelH)];
    [scrollView addSubview:weibdLabel];
    weibdLabel.text = NSLocalizedString(@"未绑定", nil);
    weibdLabel.textColor = allColorWhite;
    [weibdLabel sizeToFit];
    weibdLabel.center = guanliImageView.center;
//    weibdLabel.backgroundColor = [UIColor yellowColor];
    
    
    CGFloat label2X = dakaiLabelX;
    CGFloat label2Y = CGRectGetMaxY(guanliImageView.frame)+20*HeightProportion;
    CGFloat label2W = dakaiLabelW;
    CGFloat label2H = ruheLabelH;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label2X, label2Y, label2W, label2H)];
    [scrollView addSubview:label2];
    label2.text = NSLocalizedString(@"2、第二步：", nil);
//    label2.backgroundColor = [UIColor yellowColor];
    
    
    UILabel *qunrenLabel = [[UILabel alloc] init];
    [scrollView addSubview:qunrenLabel];
    qunrenLabel.text = NSLocalizedString(@"确认选择的设备类型与需要绑定的设备是同一类型，如果不是同一类型请到设备类型页面更改设备类型（注：绑定了设备要更改设备类型，请先解绑设备）", nil);
    qunrenLabel.numberOfLines = 0;
//    qunrenLabel.backgroundColor = [UIColor greenColor];
    CGFloat qunrenLabelX = label2X;
    CGFloat qunrenLabelY = CGRectGetMaxY(label2.frame);
    CGFloat qunrenLabelW = dakaiLabelW;
    CGFloat qunrenLabelH = ruheLabelH;
    NSDictionary *dic2 = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
    CGSize size2 = [qunrenLabel.text boundingRectWithSize:CGSizeMake(qunrenLabelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic2 context:nil].size;
    qunrenLabelH = size2.height;
    qunrenLabel.frame = CGRectMake(qunrenLabelX, qunrenLabelY, qunrenLabelW, qunrenLabelH);
    
    CGFloat listImageViewX = 30*WidthProportion;
    CGFloat listImageViewY = CGRectGetMaxY(qunrenLabel.frame);
    CGFloat listImageViewW = CurrentDeviceWidth-listImageViewX*2;
    CGFloat listImageViewH = listImageViewW / 0.97;
    UIImageView *listImageView = [[UIImageView alloc] initWithFrame:CGRectMake(listImageViewX, listImageViewY, listImageViewW, listImageViewH)];
    [scrollView addSubview:listImageView];
    listImageView.image = [UIImage imageNamed:@"1"];
    
    CGFloat listabel2X = 0;
    CGFloat listabel2Y = 27*HeightProportion + listImageViewY;
    CGFloat listabel2W = 0;
    CGFloat listabel2H = ruheLabelH;
    UILabel *listabel2 = [[UILabel alloc] initWithFrame:CGRectMake(listabel2X, listabel2Y, listabel2W, listabel2H)];
    [scrollView addSubview:listabel2];
    listabel2.text = NSLocalizedString(@"设备列表", nil);
    [listabel2 sizeToFit];
    listabel2.centerX = listImageView.centerX;
//    listabel2.backgroundColor = [UIColor yellowColor];

    CGFloat shLabelX = 0;
    CGFloat shLabelY = listImageViewH * 0.6  + listImageViewY;
    CGFloat shLabelW = 0;
    CGFloat shLabelH = ruheLabelH;
    UILabel *shLabel = [[UILabel alloc] initWithFrame:CGRectMake(shLabelX, shLabelY, shLabelW, shLabelH)];
    [scrollView addSubview:shLabel];
    shLabel.text = NSLocalizedString(@"手环", nil);
    [shLabel sizeToFit];
    shLabel.centerX = listImageView.centerX;
//    shLabel.backgroundColor = [UIColor yellowColor];
    
    CGFloat sbLabelX = 0;
    CGFloat sbLabelW = 0;
    CGFloat sbLabelH = ruheLabelH;
    CGFloat sbLabelY = listImageViewH - sbLabelH  + listImageViewY;
    UILabel *sbLabel = [[UILabel alloc] initWithFrame:CGRectMake(sbLabelX, sbLabelY, sbLabelW, sbLabelH)];
    [scrollView addSubview:sbLabel];
    sbLabel.text = NSLocalizedString(@"手表", nil);
    [sbLabel sizeToFit];
    sbLabel.centerX = listImageView.centerX;
//    sbLabel.backgroundColor = [UIColor yellowColor];
    
    
    CGFloat label3X = label1X;
    CGFloat label3Y = CGRectGetMaxY(listImageView.frame);
    CGFloat label3W = label1W;
    CGFloat label3H = ruheLabelH;
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(label3X, label3Y, label3W, label3H)];
    [scrollView addSubview:label3];
    label3.text = NSLocalizedString(@"3、第三步：", nil);
//    label3.backgroundColor = [UIColor yellowColor];
    
    
    UILabel *dianjiLabel = [[UILabel alloc] init];
    [scrollView addSubview:dianjiLabel];
    dianjiLabel.text = NSLocalizedString(@"点击绑定设备进入连接设备页面，选择设备相对应的设备名进行连接，连接成功后回到设备管理页面。", nil);
    dianjiLabel.numberOfLines = 0;
//    dianjiLabel.backgroundColor = [UIColor greenColor];
    CGFloat dianjiLabelX = label1X;
    CGFloat dianjiLabelY = CGRectGetMaxY(label3.frame);
    CGFloat dianjiLabelW = label1W;
    CGFloat dianjiLabelH = ruheLabelH;
    NSDictionary *dic3 = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
    CGSize size3 = [dianjiLabel.text boundingRectWithSize:CGSizeMake(dianjiLabelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic3 context:nil].size;
    dianjiLabelH = size3.height;
    dianjiLabel.frame = CGRectMake(dianjiLabelX, dianjiLabelY, dianjiLabelW, dianjiLabelH);
    
    
    CGFloat bangdingImageViewX = 50*WidthProportion;
    CGFloat bangdingImageViewY = CGRectGetMaxY(dianjiLabel.frame);
    CGFloat bangdingImageViewW = CurrentDeviceWidth-bangdingImageViewX*2;
    CGFloat bangdingImageViewH = bangdingImageViewW / 0.75;
    UIImageView *bangdingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(bangdingImageViewX, bangdingImageViewY, bangdingImageViewW, bangdingImageViewH)];
    [scrollView addSubview:bangdingImageView];
    bangdingImageView.image = [UIImage imageNamed:@"3"];
    
    CGFloat bdsbX = 0;
    CGFloat bdsbY = bangdingImageViewH * 0.2  + bangdingImageViewY + 2*HeightProportion;
    CGFloat bdsbW = 0;
    CGFloat bdsbH = ruheLabelH;
    UILabel *bdsb = [[UILabel alloc] initWithFrame:CGRectMake(bdsbX, bdsbY, bdsbW, bdsbH)];
    [scrollView addSubview:bdsb];
    bdsb.text = NSLocalizedString(@"绑定设备", nil);
    bdsb.textColor = allColorWhite;
    bdsb.font = [UIFont systemFontOfSize:16];
    [bdsb sizeToFit];
    bdsb.centerX = bangdingImageView.centerX;
//    bdsb.backgroundColor = [UIColor yellowColor];
    
    CGFloat ljsbX = 0;
    CGFloat ljsbY = bangdingImageViewH * 0.6  + bangdingImageViewY;
    CGFloat ljsbW = 0;
    CGFloat ljsbH = ruheLabelH;
    UILabel *ljsb = [[UILabel alloc] initWithFrame:CGRectMake(ljsbX, ljsbY, ljsbW, ljsbH)];
    [scrollView addSubview:ljsb];
    ljsb.text = NSLocalizedString(@"连接设备", nil);
    ljsb.font = [UIFont systemFontOfSize:16];
    [ljsb sizeToFit];
    ljsb.centerX = bangdingImageView.centerX;
//    ljsb.backgroundColor = [UIColor yellowColor];
    
    
    CGFloat downLabelX = 0;
    CGFloat downLabelY = CGRectGetMaxY(bangdingImageView.frame);
    CGFloat downLabelW = CurrentDeviceWidth;
    CGFloat downLabelH = ruheLabelH;
    UILabel *downLabel = [[UILabel alloc] initWithFrame:CGRectMake(downLabelX, downLabelY, downLabelW, downLabelH)];
    [scrollView addSubview:downLabel];
    downLabel.text = NSLocalizedString(@"绑定后连接超时如何解决？", nil);
    downLabel.numberOfLines = 0;
    NSDictionary *dicDown2band = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
    CGSize sizeDownband = [downLabel.text boundingRectWithSize:CGSizeMake(downLabelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicDown2band context:nil].size;
    downLabel.height = sizeDownband.height;
    
    CGFloat downLabel1X = label1X;
    CGFloat downLabel1Y = CGRectGetMaxY(downLabel.frame);
    CGFloat downLabel1W = label1W;
    CGFloat downLabel1H = ruheLabelH;
    UILabel *downLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(downLabel1X, downLabel1Y, downLabel1W, downLabel1H)];
    [scrollView addSubview:downLabel1];
    downLabel1.text = NSLocalizedString(@"1、请确认手机蓝牙是否打开", nil);
    downLabel1.numberOfLines = 0;
    NSDictionary *dicDown2How = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
    CGSize sizeDownHow = [downLabel1.text boundingRectWithSize:CGSizeMake(downLabel1W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicDown2How context:nil].size;
    downLabel1.height = sizeDownHow.height;
    
//    downLabel1.backgroundColor = [UIColor cyanColor];
    
    
    UILabel *downLabel2 = [[UILabel alloc] init];
    [scrollView addSubview:downLabel2];
    downLabel2.text = NSLocalizedString(@"2、请确认设备是否被其他手机连接，查看设备左上角，如有蓝牙图标则表示设备被连接，请断开连接。", nil);
    downLabel2.numberOfLines = 0;
//    downLabel2.backgroundColor = [UIColor greenColor];
    CGFloat downLabel2X = label1X;
    CGFloat downLabel2Y = CGRectGetMaxY(downLabel1.frame);
    CGFloat downLabel2W = label1W;
    CGFloat downLabel2H = ruheLabelH;
    NSDictionary *dicDown2 = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
    CGSize sizeDown2 = [downLabel2.text boundingRectWithSize:CGSizeMake(downLabel2W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicDown2 context:nil].size;
    downLabel2H = sizeDown2.height;
    downLabel2.frame = CGRectMake(downLabel2X, downLabel2Y, downLabel2W, downLabel2H);
    
    UILabel *downLabel3 = [[UILabel alloc] init];
    [scrollView addSubview:downLabel3];
    downLabel3.text = NSLocalizedString(@"3、连接的时候请点亮设备屏幕，因为设备断开连接熄屏20分钟后就会关闭蓝牙广播。", nil);
    downLabel3.numberOfLines = 0;
//    downLabel3.backgroundColor = [UIColor greenColor];
    CGFloat downLabel3X = label1X;
    CGFloat downLabel3Y = CGRectGetMaxY(downLabel2.frame);
    CGFloat downLabel3W = label1W;
    CGFloat downLabel3H = ruheLabelH;
    NSDictionary *dicDown3 = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
    CGSize sizeDown3 = [downLabel3.text boundingRectWithSize:CGSizeMake(downLabel3W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicDown3 context:nil].size;
    downLabel3H = sizeDown3.height;
    downLabel3.frame = CGRectMake(downLabel3X, downLabel3Y, downLabel3W, downLabel3H);
    
    UILabel *downLabel4 = [[UILabel alloc] init];
    [scrollView addSubview:downLabel4];
    downLabel4.text = NSLocalizedString(@"4、请将设备靠近多需要连接的手机，越近越好。", nil);
    downLabel4.numberOfLines = 0;
//    downLabel4.backgroundColor = [UIColor greenColor];
    CGFloat downLabel4X = label1X;
    CGFloat downLabel4Y = CGRectGetMaxY(downLabel3.frame);
    CGFloat downLabel4W = label1W;
    CGFloat downLabel4H = ruheLabelH;
    NSDictionary *dicDown4 = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
    CGSize sizeDown4 = [downLabel4.text boundingRectWithSize:CGSizeMake(downLabel4W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicDown4 context:nil].size;
    downLabel4H = sizeDown4.height;
    downLabel4.frame = CGRectMake(downLabel4X, downLabel4Y, downLabel4W, downLabel4H);
    
    UILabel *downLabel5 = [[UILabel alloc] init];
    [scrollView addSubview:downLabel5];
    downLabel5.text = NSLocalizedString(@"以上操作若还不能连接成功请重启手机蓝牙或手机", nil);
    downLabel5.numberOfLines = 0;
//    downLabel5.backgroundColor = [UIColor greenColor];
    CGFloat downLabel5X = label1X;
    CGFloat downLabel5Y = CGRectGetMaxY(downLabel4.frame) + 20*HeightProportion;
    CGFloat downLabel5W = label1W;
    CGFloat downLabel5H = ruheLabelH;
    NSDictionary *dicDown5 = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
    CGSize sizeDown5 = [downLabel5.text boundingRectWithSize:CGSizeMake(downLabel5W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicDown5 context:nil].size;
    downLabel5H = sizeDown5.height;
    downLabel5.frame = CGRectMake(downLabel5X, downLabel5Y, downLabel5W, downLabel5H);
    
    CGFloat contentY = CGRectGetMaxY(downLabel5.frame);
    scrollView.contentSize = CGSizeMake(0,contentY);
}
-(void)backActionDetail
{
    //adaLog(@"退出");
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        //    [headView addSubview:titleLabel];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        //    _titleLabel = titleLabel;
        CGFloat titleLabelX = 0;
        CGFloat titleLabelY = 0;
        CGFloat titleLabelW = 220;
        CGFloat titleLabelH = 30;
        _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    }
    return _titleLabel;
}
-(UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc]init];
        [self.view addSubview:_headView];
        CGFloat headViewX = 0;
        CGFloat headViewY = 20;
        CGFloat headViewW = CurrentDeviceWidth;
        CGFloat headViewH = 44;
        _headView.frame = CGRectMake(headViewX, headViewY, headViewW, headViewH);
        _headView.backgroundColor = allColorWhite;
        
    }
    return _headView;
}
@end

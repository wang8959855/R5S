//
//  TaiwanViewController.m
//  Mistep
//
//  Created by 迈诺科技 on 2016/11/30.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "TaiwanViewController.h"

@interface TaiwanViewController ()
@property (nonatomic,strong) UISwitch *taiwanUISwitch;
@end

@implementation TaiwanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}
-(void)setupView
{
    self.view.backgroundColor = allColorWhite;
    CGFloat viewX = 0;
    CGFloat viewY = SafeAreaTopHeight;
    CGFloat viewW = CurrentDeviceWidth;
    CGFloat viewH = 60*HeightProportion;
    UIView *taiwanView = [[UIView alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
    [self.view addSubview:taiwanView];
    taiwanView.backgroundColor = allColorWhite;
    taiwanView.sd_layout
    .topSpaceToView(self.view,viewY)
    .heightIs(viewH)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0);
    
    CGFloat taiwanLabelX = 10*WidthProportion;
    CGFloat taiwanLabelW = 200 * WidthProportion;
    CGFloat taiwanLabelH = 30*HeightProportion;
    CGFloat taiwanLabelY = (viewH - taiwanLabelH)/2;
    UILabel *taiwanLabel = [[UILabel alloc]init];
    [taiwanView addSubview:taiwanLabel];
    taiwanLabel.backgroundColor = allColorWhite;
    taiwanLabel.text = NSLocalizedString(@"抬手亮屏", nil);
    taiwanLabel.numberOfLines = 0;
    NSDictionary *dict = @{NSFontAttributeName:taiwanLabel.font};
    CGSize size = [taiwanLabel.text boundingRectWithSize:CGSizeMake(taiwanLabelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    taiwanLabelH = size.height;
    taiwanLabel.frame = CGRectMake(taiwanLabelX, taiwanLabelY, taiwanLabelW, taiwanLabelH);
    
    CGFloat taiwanUISwitchW = 49*WidthProportion;
    CGFloat taiwanUISwitchH = 31*HeightProportion;
    CGFloat taiwanUISwitchY = (viewH - taiwanUISwitchH)/2;
    CGFloat taiwanUISwitchX = CurrentDeviceWidth - taiwanUISwitchW - 10 * WidthProportion;

    UISwitch *taiwanUISwitch = [[UISwitch alloc]initWithFrame:CGRectMake(taiwanUISwitchX, taiwanUISwitchY, taiwanUISwitchW, taiwanUISwitchH)];
    [taiwanView addSubview:taiwanUISwitch];
    taiwanUISwitch.backgroundColor = allColorWhite;
    taiwanUISwitch.onTintColor = [UIColor blueColor];
    [taiwanUISwitch addTarget:self action:@selector(swithValueChanged:) forControlEvents:UIControlEventTouchUpInside];
//    [taiwanUISwitch setOn:YES animated:YES];
    _taiwanUISwitch = taiwanUISwitch;
    taiwanUISwitch.sd_layout.rightSpaceToView(taiwanView,10*WidthProportion);
    
    CGFloat downViewX = taiwanLabelX;
    CGFloat downViewY = viewH - 1;
    CGFloat downViewW = CurrentDeviceWidth;
    CGFloat downViewH = 1;
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(downViewX, downViewY, downViewW, downViewH)];
    [taiwanView addSubview:downView];
    downView.backgroundColor = kColor(209, 209, 209);
    downView.sd_layout
    .leftSpaceToView(taiwanView,10*WidthProportion)
    .rightSpaceToView(taiwanView,10*WidthProportion);
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    WeakSelf; //   抬腕唤醒
    [[CositeaBlueTooth sharedInstance] checkSystemAlarmWithType:SystemAlarmType_Taiwan StateBlock:^(int index, int state) {
        if (index == SystemAlarmType_Taiwan)
        {
            //adaLog(@"state =  %d",state);
            [weakSelf.taiwanUISwitch setOn:state animated:YES];
        }
    }];
}
- (void)swithValueChanged:(UISwitch *)sender
{
    [[CositeaBlueTooth sharedInstance] setSystemAlarmWithType:SystemAlarmType_Taiwan State:sender.isOn];
     [[CositeaBlueTooth sharedInstance] setSystemAlarmWithType:SystemAlarmType_Fanwan State:sender.isOn];
    [[CositeaBlueTooth sharedInstance] checkSystemAlarmWithType:SystemAlarmType_Taiwan StateBlock:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

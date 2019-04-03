//
//  AboutViewController.m
//  keyBand
//
//  Created by 迈诺科技 on 15/11/17.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import "AboutViewController.h"
#import "HelpViewController.h"

//#define kSoftWareVersion @"2.3.1"

@interface AboutViewController ()<UIAlertViewDelegate>
{
    NSString *description;
}

@property (weak, nonatomic) IBOutlet UILabel *corn;

@end

@implementation AboutViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[PSDrawerManager instance] cancelDragResponse];
}
- (void)dealloc
{
    //    [BlueToothData getInstance].aboutDelegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ [ UIApplication sharedApplication] setIdleTimerDisabled:YES ] ;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ [ UIApplication sharedApplication] setIdleTimerDisabled:NO ] ;
    
}

- (void)setXibLabel
{
//    _titleLabel.text = NSLocalizedString(@"关于", nil);
//    _introductLabel.text = NSLocalizedString(@"安全，便捷，稳定的一款智能运动手环APP。", nil);
//    _softLabel.text = NSLocalizedString(@"软件版本:", nil);
//    _hardVersionLabel.text = NSLocalizedString(@"未知", nil);
//    _khardVersionLabel.text = NSLocalizedString(@"固件版本:", nil);
//    _kHelpLabel.text = NSLocalizedString(@"帮助", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self setXibLabel];
    _softVersionLabel.text =  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]; //kSoftWareVersion;
    
    if ([CositeaBlueTooth sharedInstance].isConnected)
    {
        WeakSelf;
        [[PZBlueToothManager sharedInstance] checkVerSionWithBlock:^(int firstHardVersion, int secondHardVersion, int softVersion, int blueToothVersion) {
            
            if (secondHardVersion == 161616) {
                int8_t hard = [HCHCommonManager getInstance].curHardVersion;
                int8_t soft = [HCHCommonManager getInstance].softVersion;
                int8_t blue = [HCHCommonManager getInstance].blueVersion;
                weakSelf.hardVersionLabel.text = [NSString stringWithFormat:@"%02x.%02x.%02x",hard,blue,soft];
                NSString *softStr = [NSString stringWithFormat:@"%.2f", [HCHCommonManager getInstance].curSoftVersion];
                NSString *hardStr = [NSString stringWithFormat:@"%d", [HCHCommonManager getInstance].curHardVersion];
                NSString *blueStr = [NSString stringWithFormat:@"%.2f", [HCHCommonManager getInstance].curBlueToothVersion];
                [self checkVersion:softStr hardversion:hardStr blueversion:blueStr];
            }
            else
            {
                int8_t hard = [HCHCommonManager getInstance].curHardVersion;
                int8_t hardTwo = [HCHCommonManager getInstance].curHardVersionTwo;
                int8_t soft = [HCHCommonManager getInstance].softVersion;
                int8_t blue = [HCHCommonManager getInstance].blueVersion;
                weakSelf.hardVersionLabel.text = [NSString stringWithFormat:@"%02x%02x.%02x.%02x",hardTwo,hard,blue,soft];
                
                NSString *softStr = [NSString stringWithFormat:@"%.2f", [HCHCommonManager getInstance].curSoftVersion];
                NSString *hardStr = [NSString stringWithFormat:@"%x%x",[HCHCommonManager getInstance].curHardVersionTwo,[HCHCommonManager getInstance].curHardVersion];
                hardStr = [NSString stringWithFormat:@"%ld",(long)[AllTool hexStringTranslateToDoInteger:hardStr]];
                NSString *blueStr = [NSString stringWithFormat:@"%.2f", [HCHCommonManager getInstance].curBlueToothVersion];
                [self checkVersion:softStr hardversion:hardStr blueversion:blueStr];
            }
        }];
    }
     
}

- (IBAction)helpClick:(id)sender
{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://bracelet.cositea.com:8089/bracelet/v3"]];
    HelpViewController *help = [HelpViewController new];
    help.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:help animated:YES];
}

- (IBAction)jianjie:(UIButton *)button{
    H5ViewController *jianjie = [[H5ViewController alloc] init];
    jianjie.titleStr = @"关于我们";
    jianjie.url = @"https://www.lantianfangzhou.com//app/r5s/aboutUs/index.html";
    [self.navigationController pushViewController:jianjie animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBackAction:(id)sender
{
    //    [self backToHome];
    [self.navigationController popViewControllerAnimated:YES];
}

//检查软件
- (IBAction)checkRuanjian:(UIButton *)sender {
    if (!self.corn.isHidden) {
        //跳转到appstore
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/1415686707?mt=8"]];
    }else{
        [self showAlertView:@"已是最新版本!"];
    }
}

//检查固件
- (IBAction)checkGuJian:(id)sender {
    
}

- (void)checkVersion :(NSString *)softversion hardversion:(NSString *)hardversion blueversion:(NSString *)blueversion {
    
    NSString *language = @"en-us";
    if ([HCHCommonManager getInstance].LanuguageIndex_SRK == ChinesLanguage_Enum)
    {
        language = @"zh-cn";
    }
    NSDictionary *dic = @{@"softversion":softversion,@"hardversion":hardversion,@"blueversion":blueversion,@"language":language};
    
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:[AFHTTPResponseSerializer serializer] RequestType:NSAFRequest_GET RequestURL:@"bracelet_version" ParametersDictionary:dic Block:^(id responseObject, NSError *error,NSURLSessionDataTask *task) {
        if (error)
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"网络连接错误", nil) deleyTime:1.5f];
        }
        else
        {
            int result = [[responseObject objectForKey:@"result"] intValue];
            if (result == 1)
            {
                //adaLog(@"msg -- %@",responseObject[@"msg"]);
                self.mcuDic = responseObject[@"param"][0];
                NSString *newVersion = _mcuDic[@"newVersion"];
                description = _mcuDic[@"description"];
                description = [description stringByReplacingOccurrencesOfString:@"    " withString:@"\n"];
                if (newVersion != softversion && _updateButton == nil)
                {
                    _updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    [_updateButton setTitle:NSLocalizedString(@"有新版本更新", nil) forState:UIControlStateNormal];
                    _updateButton.backgroundColor = kColor(83, 136, 227);
                    [_updateButton setTintColor:[UIColor whiteColor]];
                    _updateButton.layer.cornerRadius = 10;
                    _updateButton.titleLabel.font = [UIFont systemFontOfSize:13];
                    [_updateButton addTarget:self action:@selector(upDateRomAlert) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:_updateButton];
                    [_updateButton sizeToFit];
                    _updateButton.sd_layout.centerYEqualToView(_hardVersionLabel)
                    .rightSpaceToView(self.view,20)
                    .widthIs(_updateButton.width + 20)
                    .heightIs(20);
                }
            }else {
                [_updateButton removeFromSuperview];
                _updateButton = nil;
                [self addActityTextInView:self.view text:NSLocalizedString(@"固件已是最新", nil)  deleyTime:1.5f];
            }
        }
    }];
}

- (void)upDateRomAlert
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"固件更新", nil)  message:description  delegate:self cancelButtonTitle:NSLocalizedString (@"取消",nil)  otherButtonTitles:NSLocalizedString (@"更新",nil) , nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        return;
    }
    else
    {
        [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"正在下载固件", nil)  detailLabel:nil];
        [self downLoadRomData];
    }
}

- (void)downLoadRomData
{
    
    NSString *url = _mcuDic[@"url"];
    NSString *fileName = [[url componentsSeparatedByString:@"="] lastObject];
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    _dataCacheURL = [cacheDir stringByAppendingPathComponent:fileName];
    _dataURL =[ NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:_dataURL])
    {
        [[NSFileManager defaultManager] removeItemAtPath:_dataURL error:nil];
    }
    
    [[AFAppDotNetAPIClient sharedClient] globalDownloadWithUrl:url Block:^(id responseObject, NSURL *filePath, NSError *error) {
        
        if (error)
        {
            [self removeActityIndicatorFromView:self.view];
            [self addActityTextInView:self.view text:NSLocalizedString(@"网络连接错误", nil)  deleyTime:1.5];
        }else
        {
            [[NSFileManager defaultManager] moveItemAtPath:_dataCacheURL toPath:_dataURL error:nil];
            NSData *data = [NSData dataWithContentsOfFile:_dataURL];
            if (data && data.length != 0)
            {
                [self removeActityIndicatorFromView:self.view];
                [self blueToothUpdateRom];
            }
            else
            {
                [self removeActityIndicatorFromView:self.view];
                [self addActityTextInView:self.view text:NSLocalizedString(@"网络连接错误", nil) deleyTime:2.0];
            }
        }
    }];
}

- (void)blueToothUpdateRom
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view addSubview:_hud];
    _hud.label.text = NSLocalizedString(@"正在升级固件", nil) ;
    _hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    [_hud showAnimated:YES];
    
    [[CositeaBlueTooth sharedInstance] updateBindROMWithRomUrl:_dataURL progressBlock:^(float progress) {
        //adaLog(@"progress = %f",progress);
        _hud.progress = progress;
        
    } successBlock:^(int number) {
        //adaLog(@"升级成功");
        [_hud removeFromSuperview];
        [self addActityTextInView:self.view text:NSLocalizedString(@"手环升级成功", nil) deleyTime:1.5];
        [[NSFileManager defaultManager] removeItemAtPath:_dataURL error:nil];
        [_updateButton removeFromSuperview];
        _updateButton = nil;
    } failureBlock:^(int number) {
        //adaLog(@"升级失败");
        [self upDateFailDelegate];
    }];
}

//获取appStore版本
- (void)getAppStoreVersion{
    NSString *urlStr = @"http://itunes.apple.com/lookup?id=1415686707";
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:urlStr ParametersDictionary:nil Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        NSString * version      = responseObject[@"results"][0][@"version"];//线上最新版本
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion       = [infoDictionary objectForKey:@"CFBundleShortVersionString"];//当前用户版本
        BOOL result = [currentVersion compare:version] == NSOrderedAscending;
        if (result) {
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"updeateVersion"];
            self.corn.hidden = NO;
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"updeateVersion"];
            self.corn.hidden = YES;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateVersion" object:nil];
    }];
}


- (void)upDateFailDelegate
{
    if (_hud)
    {
        [_hud removeFromSuperview];
        _hud = nil;
    }
    [self addActityTextInView:self.view text:NSLocalizedString(@"升级失败", nil) deleyTime:2.f];
}

- (void)updateProgress:(float )progress
{
    
}
@end

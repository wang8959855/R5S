//
//  DeviceTypeViewController.m
//  Mistep
//
//  Created by 迈诺科技 on 2016/11/23.
//  Copyright © 2016年 huichenghe. All rights reserved.
//
//#define Dheight  [UIScreen mainScreen].bounds.size.height
//#define Dwidth [UIScreen mainScreen].bounds.size.width
#define buttonTag   123
#import "DeviceTypeViewController.h"
#import "FirstScanDeviceViewController.h"

@interface DeviceTypeViewController ()
@property (nonatomic,strong) UIImageView *braceletSelectView;//云环的勾
@property (nonatomic,strong) UIImageView *watchSelectView;//手表的勾
@property (nonatomic,strong) UIAlertView * alert;
@end

@implementation DeviceTypeViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[PSDrawerManager instance] cancelDragResponse];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = allColorWhite;
    [self setupView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self refreshSelect];
    
}
-(void)refreshSelect
{
    NSInteger type = [[ADASaveDefaluts objectForKey:AllDEVICETYPE] integerValue];
    if (type == 2)
    {
        _braceletSelectView.image = nil;
        _watchSelectView.image = [UIImage imageNamed:@"hook"];
    }
    else if(type == 1)
    {
        _braceletSelectView.image = [UIImage imageNamed:@"hook"];
        _watchSelectView.image = nil;
    }
}
- (void)setupView {
    [self header];
    [self downView];
}

- (void)header
{
    CGFloat headImageViewX = 0;
    CGFloat headImageViewY = 20;
    CGFloat headImageViewW = CurrentDeviceWidth;
    CGFloat headImageViewH = 44;
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(headImageViewX, headImageViewY, headImageViewW, headImageViewH)];
    
    [self.view addSubview:headImageView];
    headImageView.backgroundColor = [UIColor whiteColor];
    headImageView.userInteractionEnabled = YES;
    headImageView.image = [UIImage imageNamed:@"NavigationBarShadow"];
    
    
    UIButton *buttonBack = [[UIButton alloc]init];
    [headImageView addSubview:buttonBack];
    
    CGFloat buttonBackX = 3;
    CGFloat buttonBackY = 0;
    CGFloat buttonBackW = 50;
    CGFloat buttonBackH = 44;
    buttonBack.frame = CGRectMake(buttonBackX, buttonBackY, buttonBackW, buttonBackH);
    [buttonBack setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    //    buttonBack.backgroundColor = [UIColor redColor];
    [buttonBack addTarget:self action:@selector(backDeviceTable) forControlEvents:UIControlEventTouchUpInside];
    if (_isHiddenBackButton)
    {
        buttonBack.hidden = _isHiddenBackButton;
    }
    else
    {
        buttonBack.hidden = _isHiddenBackButton;
    }
    //head  title
    UILabel *headLabel = [[UILabel alloc]init];
    [headImageView addSubview:headLabel];
    
    CGFloat headLabelW = 200;
    CGFloat headLabelH = 30;
    CGFloat headLabelX = (CurrentDeviceWidth - headLabelW)/2;
    CGFloat headLabelY = (44 - headLabelH)/2;
    headLabel.frame = CGRectMake(headLabelX, headLabelY, headLabelW, headLabelH);
    headLabel.textAlignment = NSTextAlignmentCenter;
    headLabel.text = NSLocalizedString(@"设备列表", nil);
 
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor blackColor];
    [self.view  addSubview:topView];
    topView.frame = CGRectMake(0, 0, CurrentDeviceWidth, 20);

}
-(void)downView
{
    
    CGFloat backImageViewX = 0;
    CGFloat backImageViewY = 64;
    CGFloat backImageViewW = CurrentDeviceWidth;
    CGFloat backImageViewH = CurrentDeviceHeight - 64;
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(backImageViewX, backImageViewY, backImageViewW, backImageViewH)];
    
    [self.view addSubview:backImageView];
    backImageView.backgroundColor = [UIColor whiteColor];
    backImageView.userInteractionEnabled = YES;
    backImageView.image = [UIImage imageNamed:@"图层-2"];
    //select  title
    UILabel *nameLabel = [[UILabel alloc]init];
    [backImageView addSubview:nameLabel];
    CGFloat nameLabelX = 0;
    CGFloat nameLabelY = 30 * HeightProportion;
    CGFloat nameLabelW = CurrentDeviceWidth;
    CGFloat nameLabelH = 30 * HeightProportion;
    nameLabel.frame = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = NSLocalizedString(@"请选择设备类型", nil);
    
    
    //开始写类型
    
    CGFloat braceletImageViewY = 25 * HeightProportion + CGRectGetMaxY(nameLabel.frame);
    CGFloat braceletImageViewW = CurrentDeviceWidth / 3;
    CGFloat braceletImageViewH = braceletImageViewW;
    CGFloat braceletImageViewX = (CurrentDeviceWidth - braceletImageViewW)/2;
    UIImageView *braceletImageView = [[UIImageView alloc]initWithFrame:CGRectMake(braceletImageViewX, braceletImageViewY, braceletImageViewW, braceletImageViewH)];
    [backImageView addSubview:braceletImageView];
    braceletImageView.userInteractionEnabled = YES;
    braceletImageView.image = [UIImage imageNamed:@"云环"];
    
    CGFloat braceletSelectViewY = 0;
    CGFloat braceletSelectViewW = 23*WidthProportion;
    CGFloat braceletSelectViewH = braceletSelectViewW;
    CGFloat braceletSelectViewX = CurrentDeviceWidth - braceletSelectViewW - 20*WidthProportion;
    UIImageView *braceletSelectView = [[UIImageView alloc]initWithFrame:CGRectMake(braceletSelectViewX, braceletSelectViewY, braceletSelectViewW, braceletSelectViewH)];
    [backImageView addSubview:braceletSelectView];
    braceletSelectView.centerY = braceletImageView.centerY;
    _braceletSelectView = braceletSelectView;
    //    braceletSelectView.userInteractionEnabled = YES;
    //    braceletSelectView.image = [UIImage imageNamed:@"勾"];
    
    UILabel *braceletnameLabel = [[UILabel alloc]init];
    [backImageView addSubview:braceletnameLabel];
    CGFloat braceletnameLabelX = 0;
    CGFloat braceletnameLabelY = 10*HeightProportion + CGRectGetMaxY(braceletImageView.frame);
    CGFloat braceletnameLabelW = CurrentDeviceWidth;
    CGFloat braceletnameLabelH = 20*HeightProportion;
    braceletnameLabel.frame = CGRectMake(braceletnameLabelX, braceletnameLabelY, braceletnameLabelW, braceletnameLabelH);
    braceletnameLabel.textAlignment = NSTextAlignmentCenter;
    braceletnameLabel.text = NSLocalizedString(@"云环", nil);
    //    braceletnameLabel.backgroundColor = [UIColor greenColor];
    
    CGFloat watchImageViewX = braceletImageViewX;
    CGFloat watchImageViewY = 20*HeightProportion + CGRectGetMaxY(braceletnameLabel.frame);
    CGFloat watchImageViewW = braceletImageViewW;
    CGFloat watchImageViewH = watchImageViewW;
    UIImageView *watchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(watchImageViewX, watchImageViewY, watchImageViewW, watchImageViewH)];
    [backImageView addSubview:watchImageView];
    watchImageView.userInteractionEnabled = YES;
    watchImageView.image = [UIImage imageNamed:@"手表"];
    
    CGFloat watchSelectViewY = 0;
    CGFloat watchSelectViewW = 23*WidthProportion;
    CGFloat watchSelectViewH = watchSelectViewW;
    CGFloat watchSelectViewX = CurrentDeviceWidth - watchSelectViewW - 20*WidthProportion;
    UIImageView *watchSelectView = [[UIImageView alloc]initWithFrame:CGRectMake(watchSelectViewX, watchSelectViewY, watchSelectViewW, watchSelectViewH)];
    [backImageView addSubview:watchSelectView];
    watchSelectView.centerY = watchImageView.centerY;
    _watchSelectView = watchSelectView;
    //    watchSelectView.image = [UIImage imageNamed:@"勾"];
    
    
    UILabel *watchnameLabel = [[UILabel alloc]init];
    [backImageView addSubview:watchnameLabel];
    CGFloat watchnameLabelX = 0;
    CGFloat watchnameLabelY = 10*HeightProportion + CGRectGetMaxY(watchImageView.frame);
    CGFloat watchnameLabelW = CurrentDeviceWidth;
    CGFloat watchnameLabelH = 20*HeightProportion;
    watchnameLabel.frame = CGRectMake(watchnameLabelX, watchnameLabelY, watchnameLabelW, watchnameLabelH);
    watchnameLabel.textAlignment = NSTextAlignmentCenter;
    watchnameLabel.text = NSLocalizedString(@"手表", nil);
    //    watchnameLabel.backgroundColor = [UIColor greenColor];
    
    UIButton *selectBraceletButton = [[UIButton alloc]init];
    [backImageView addSubview:selectBraceletButton];
    selectBraceletButton.backgroundColor = [UIColor clearColor];//allColorRed;
    selectBraceletButton.alpha = 0.5;
    CGFloat selectBraceletButtonX = braceletImageViewX;
    CGFloat selectBraceletButtonY = braceletImageViewY;
    CGFloat selectBraceletButtonW = braceletImageViewW;
    CGFloat selectBraceletButtonH = CGRectGetMaxY(braceletnameLabel.frame) - selectBraceletButtonY;
    selectBraceletButton.frame = CGRectMake(selectBraceletButtonX, selectBraceletButtonY, selectBraceletButtonW, selectBraceletButtonH);
    
    UIButton *selectwatchButton = [[UIButton alloc]init];
    [backImageView addSubview:selectwatchButton];
    selectwatchButton.backgroundColor = [UIColor clearColor];//allColorRed;
    selectwatchButton.alpha = 0.5;
    CGFloat selectwatchButtonX = braceletImageViewX;
    CGFloat selectwatchButtonY = watchImageViewY;
    CGFloat selectwatchButtonW = braceletImageViewW;
    CGFloat selectwatchButtonH = CGRectGetMaxY(watchnameLabel.frame) - selectwatchButtonY;
    selectwatchButton.frame = CGRectMake(selectwatchButtonX, selectwatchButtonY, selectwatchButtonW, selectwatchButtonH);
    selectBraceletButton.tag = buttonTag;
    selectwatchButton.tag = buttonTag + 2;
    [selectBraceletButton addTarget:self action:@selector(selectDeviceType:) forControlEvents:UIControlEventTouchUpInside];
    [selectwatchButton addTarget:self action:@selector(selectDeviceType:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)dimissAlert:(UIAlertView *)alert {
    if(alert)
    {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}
#pragma mark  - -  - - button  action
-(void)selectDeviceType:(UIButton *)sender
{
    if ([CositeaBlueTooth sharedInstance].isConnected||[ADASaveDefaluts objectForKey:kLastDeviceUUID])
    {  self.alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"请先解除绑定", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [self.alert show];
        [self performSelector:@selector(dimissAlert:) withObject:self.alert afterDelay:2.0];
        
        return;
        
    }
    else
    {
        BOOL isChange = NO;
        int type = [ADASaveDefaluts getDeviceTypeInt];
        if(type > 0)
        {
            //            [ADASaveDefaluts setObject:[ADASaveDefaluts getDeviceTypeForKey] forKey:AllDEVICETYPELAST];
            if (sender.tag == buttonTag + 2)
            {
                if (type == 2)
                {
                    [ADASaveDefaluts setObject:@NO forKey:AllDEVICETYPECHANGE];
                }
                else
                {
                    isChange = YES;
                    [ADASaveDefaluts setObject:@YES forKey:AllDEVICETYPECHANGE];
                    [ADASaveDefaluts setDeviceType:[NSString stringWithFormat:@"%.3d",2]]; //手表
                    
                    [ADASaveDefaluts setObject:@"4294966304" forKey:SUPPORTPAGEMANAGER];

                }
            }
            else if (sender.tag == buttonTag)
            {
                if (type == 1)
                {
                    [ADASaveDefaluts setObject:@NO forKey:AllDEVICETYPECHANGE];
                }
                else
                {
                    isChange = YES;
                    [ADASaveDefaluts setObject:@YES forKey:AllDEVICETYPECHANGE];
                    [ADASaveDefaluts setDeviceType:[NSString stringWithFormat:@"%.3d",1]]; //云环
                    [ADASaveDefaluts setObject:@"4294967295" forKey:SUPPORTPAGEMANAGER];
                }
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            if(_delegate &&[_delegate performSelector:@selector(deviceisChange:)])
            {   [_delegate deviceisChange:isChange];
            }
            
        }
        else
        {
            if (sender.tag > buttonTag)
            {
                [ADASaveDefaluts setDeviceType:[NSString stringWithFormat:@"%.3d",2]]; //手表
            }
            else
            {    [ADASaveDefaluts setDeviceType:[NSString stringWithFormat:@"%.3d",1]]; //云环
            }
            FirstScanDeviceViewController *first = [[FirstScanDeviceViewController alloc]init];
            //first.showType = YES;
            [self.navigationController pushViewController:first animated:YES];
        }
    }
}

-(void)backDeviceTable
{    [self.navigationController popViewControllerAnimated:YES];}
- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}
-(void)dealloc
{
    //adaLog(@"----销毁");
}

@end
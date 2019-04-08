//
//  TakePhotoViewController.m
//  Wukong
//
//  Created by 迈诺科技 on 16/5/24.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "LMSTakePhotoController.h"

@interface TakePhotoViewController ()<LMSTakePhotoControllerDelegate>

@property (strong, nonatomic) LMSTakePhotoController *photoVC;

@end

@implementation TakePhotoViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[PSDrawerManager instance] cancelDragResponse];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, CurrentDeviceWidth, CurrentDeviceHeight - SafeAreaTopHeight)];
    backImageView.image = [UIImage imageNamed:@"PZ_背景.png"];
    [self.view addSubview:backImageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"相机"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, CurrentDeviceWidth/2, CurrentDeviceWidth/2);
    button.center = self.view.center;
    [self.view addSubview:button];
    
    UIButton *openButton = [UIButton buttonWithType:UIButtonTypeCustom];
    openButton.frame = CGRectMake(0, SafeAreaTopHeight, CurrentDeviceWidth, CurrentDeviceHeight - SafeAreaTopHeight);
    [openButton addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openButton];
    
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.bottom - 20 * kSY, CurrentDeviceWidth, 30)];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = kLOCAL(@"点击拍照");
//    label.font = Font_Normal_String(14);
//    [self.view addSubview:label];
    
    
    UIView * navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CurrentDeviceWidth, SafeAreaTopHeight)];
    navView.backgroundColor = [UIColor whiteColor];
    navView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    navView.layer.shadowOffset = CGSizeMake(0, 1);
    navView.layer.shadowOpacity = 0.6;
    navView.layer.shadowRadius = 4;
    [self.view addSubview:navView];
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor blackColor];
    topView.frame = CGRectMake(0, 0, CurrentDeviceWidth, StatusBarHeight);
    [navView addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = kLOCAL(@"遥控拍照");
    [titleLabel sizeToFit];
    titleLabel.center = CGPointMake(CurrentDeviceWidth/2., 42);
    [self.view addSubview: titleLabel];
    
    UIButton *bacButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bacButton.frame = CGRectMake(0, StatusBarHeight, 40, SafeAreaTopHeight-StatusBarHeight);
    [bacButton setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [bacButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bacButton];
    
    [self performSelector:@selector(openCamera) withObject:nil afterDelay:0.5f];
    
    
}

- (void)dealloc
{
    _photoVC.delegate = nil;
    self.photoVC = nil;
}

- (void)openCamera
{
    self.photoVC = [LMSTakePhotoController new];
    _photoVC.position = TakePhotoPositionBack;
    _photoVC.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_photoVC];
    [self presentViewController:nav animated:YES completion:^{
        [[CositeaBlueTooth sharedInstance] changeTakePhotoState:YES];
    }];
}

- (void)didFinishPickingImage:(UIImage *)image
{
    [[CositeaBlueTooth sharedInstance] changeTakePhotoState:NO];
    [self goBack];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self backToHome];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

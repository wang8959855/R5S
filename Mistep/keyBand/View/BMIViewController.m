//
//  BMIViewController.m
//  Wukong
//
//  Created by 迈诺科技 on 16/5/3.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "BMIViewController.h"

@interface BMIViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fubiaoTop;

@property (weak, nonatomic) IBOutlet UILabel *shou;

@property (weak, nonatomic) IBOutlet UILabel *zhengchang;

@property (weak, nonatomic) IBOutlet UILabel *chaozhong;
@property (weak, nonatomic) IBOutlet UILabel *feipang;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;


@end

@implementation BMIViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[PSDrawerManager instance] cancelDragResponse];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topNavView2.backgroundColor = kMainColor;
    
    if(_isRegister) {
        _backButton.hidden = YES;
        _backButtonBig.hidden = YES;
    }
    [self setXibLabel];
    self.topHeight.constant = SafeAreaTopHeight;
    float BMI = _weight*10000.0/_height/_height;
    float minWeight = 18.5*_height*_height/10000;
    float maxWeight = 25 * _height *_height/10000;
    _weightArea.text = [NSString stringWithFormat:@"%.1fkg-%.1fkg",minWeight,maxWeight];
    
    if (BMI < 18.5)
    {
        [self.BMIButton setTitle:[NSString stringWithFormat:@"%.0f",BMI] forState:UIControlStateNormal];
        self.fubiaoTop.constant = self.shou.center.y+9;
        
    }else if (BMI < 25)
    {
        [self.BMIButton setTitle:[NSString stringWithFormat:@"%.0f",BMI] forState:UIControlStateNormal];
        self.fubiaoTop.constant = self.zhengchang.center.y+9;

    }else if(BMI < 30)
    {
        [self.BMIButton setTitle:[NSString stringWithFormat:@"%.0f",BMI] forState:UIControlStateNormal];
        self.fubiaoTop.constant = self.chaozhong.center.y+9;
        
    }else
    {
        [self.BMIButton setTitle:[NSString stringWithFormat:@"%.0f",BMI] forState:UIControlStateNormal];
        self.fubiaoTop.constant = self.feipang.center.y+9;
        
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)setXibLabel
{
    _titleLabel.text = kLOCAL(@"个人资料");
    [_okBtn setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
}

- (IBAction)goBackClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)okBtnClick:(UIButton *)sender
{
    self.okBlock();
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

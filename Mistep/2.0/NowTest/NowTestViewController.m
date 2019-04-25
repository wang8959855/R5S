//
//  NowTestViewController.m
//  Wukong
//
//  Created by apple on 2019/4/12.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import "NowTestViewController.h"

@interface NowTestViewController ()

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger esc;

@property (weak, nonatomic) IBOutlet UIButton *starBtn;

//心率
@property (weak, nonatomic) IBOutlet UILabel *nowHeart;
//血压
@property (weak, nonatomic) IBOutlet UILabel *xueya;
//血糖
@property (weak, nonatomic) IBOutlet UILabel *xuetang;
//体温
@property (weak, nonatomic) IBOutlet UILabel *tiwen;
//心肺
@property (weak, nonatomic) IBOutlet UILabel *xinfei;
//血氧
@property (weak, nonatomic) IBOutlet UILabel *xueyang;

@property (nonatomic, strong) NSMutableArray *heartArr;

//动画的webView
@property (weak, nonatomic) IBOutlet UIWebView *webView;
//静态图
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSafe;


@end

@implementation NowTestViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //实时心率
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNowHeartRate:) name:GetNowHeartRateNotification object:nil];
    //设置透明效果
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = 0;
    self.topSafe.constant = StatusBarHeight;
}

//实时心率
- (void)getNowHeartRate:(NSNotification *)noti{
    NSString *heart = noti.object;
    if (self.starBtn.hidden == YES) {
        [self.heartArr addObject:heart];
    }
}

//开始
- (IBAction)startAction:(UIButton *)sender {
    self.esc = 60;
    [self.heartArr removeAllObjects];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dealy) userInfo:nil repeats:YES];
    [self.timer fire];
    sender.hidden = YES;
    self.imageV.hidden = YES;
    self.webView.hidden = NO;
    
    //得到图片的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"celaing-d" ofType:@"gif"];
    //将图片转为NSData
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    //自动调整尺寸
    self.webView.scalesPageToFit = YES;
    //禁止滚动
    self.webView.scrollView.scrollEnabled = NO;
    //加载数据
    [self.webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    
    self.nowHeart.text = @"--";
    self.xueyang.text = @"--";
    self.xueya.text = @"--/--";
    self.xuetang.text = @"--";
    self.tiwen.text  = @"--";
    self.xinfei.text = @"--";
    
}

//倒计时
- (void)dealy{
    self.esc--;
    if (self.esc == 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.starBtn.hidden = NO;
        self.imageV.hidden = NO;
        self.webView.hidden = YES;
        [self uploadData];
        return;
    }
}

//返回
- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)uploadData{
    if (self.heartArr.count == 0) {
        [self.view makeCenterToast:@"测量失败请重新测量!"];
        return;
    }
    
    
    
    NSInteger rate = 0;
    NSInteger num = 0;
    for (NSString *str in self.heartArr) {
        if (str.integerValue != 0) {
            rate += str.integerValue;
            num += 1;
        }
    }
    rate = rate/num;
    
    [self.view makeToastActivity:CSToastPositionCenter];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@/%@",NOWTEST,TOKEN];
    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:uploadUrl fileUrl:nil params:@{@"userid":USERID,@"rate":@(rate)} Block:^(id responseObject, NSError *error) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeOut) object:nil];
        
        [self removeActityIndicatorFromView:self.view];
        [self.view hideToastActivity];
        if (error) {
            [self.view makeCenterToast:@"网络连接错误"];
        }
        else
        {
            int code = [[responseObject objectForKey:@"code"] intValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 0) {
                [self.view makeCenterToast:@"测量成功"];
                self.xuetang.text = responseObject[@"data"][@"xuetang"];
                self.xueya.text = responseObject[@"data"][@"xueya"];
                self.nowHeart.text = responseObject[@"data"][@"rate"];
                self.tiwen.text = responseObject[@"data"][@"tiwen"];
                self.xinfei.text = responseObject[@"data"][@"xinfei"];
                self.xueyang.text = responseObject[@"data"][@"xueyang"];
            } else {
                [self.view makeCenterToast:message];
            }
        }
    }];
}

- (NSMutableArray *)heartArr{
    if (!_heartArr) {
        _heartArr = [NSMutableArray array];
    }
    return _heartArr;
}

@end

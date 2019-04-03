//
//  HelpSleepViewController.m
//  Wukong
//
//  Created by apple on 2019/3/26.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import "HelpSleepViewController.h"
#import "JXPopoverView.h"

@interface HelpSleepViewController ()<AVAudioPlayerDelegate>

//设置时间的view
@property (weak, nonatomic) IBOutlet UIView *setTimeView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

//唱片
@property (weak, nonatomic) IBOutlet UIImageView *recordImageView;

//结束播放view
@property (weak, nonatomic) IBOutlet UIView *endTimingView;
@property (weak, nonatomic) IBOutlet UILabel *timingLabel;

//定时器
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger timing;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;


//播放器
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
//选择的音乐
@property (nonatomic, assign) NSInteger selectMusic;
@property (nonatomic, strong) NSArray *musicArr;

//图片
@property (nonatomic, strong) NSArray *imageArr;

@end

@implementation HelpSleepViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if (self.playBtn.selected || !self.endTimingView.isHidden) {
        //正在播放音乐
        [self rotateView];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *url1 = [[NSBundle mainBundle]  URLForResource:@"woxihuanni.mp3" withExtension:nil];
    NSURL *url2 = [[NSBundle mainBundle]  URLForResource:@"yuxiang.mp3" withExtension:nil];
    NSURL *url3 = [[NSBundle mainBundle]  URLForResource:@"huguangsheng.mp3" withExtension:nil];
    NSURL *url4 = [[NSBundle mainBundle]  URLForResource:@"bunengshuodemimi.mp3" withExtension:nil];
    self.musicArr = @[url1,url2,url3,url4];
    self.imageArr = @[@"aid_music",@"aid_gushi",@"aid_shuyang",@"aid_ziran"];
    self.selectMusic = 0;
}

//返回
- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//加时间
- (IBAction)addTimeAction:(UIButton *)sender {
    NSInteger time = self.timeLabel.text.integerValue;
    if (time >= 60) {
        [self.view makeBottomToast:@"设置助眠时间最多60min"];
    }else{
        time+=10;
        self.timeLabel.text = [NSString stringWithFormat:@"%ldmin",time];
    }
}

//减时间
- (IBAction)lessTimeAction:(UIButton *)sender {
    NSInteger time = self.timeLabel.text.integerValue;
    if (time <= 10) {
        [self.view makeBottomToast:@"设置助眠时间最少10min"];
    }else{
        time-=10;
        self.timeLabel.text = [NSString stringWithFormat:@"%ldmin",time];
    }
}

//开始计时 点击上方开始下方按钮也变为开始
- (IBAction)starAction:(UIButton *)sender {
    self.endTimingView.hidden = NO;
    self.setTimeView.hidden = YES;
    self.timing = self.timeLabel.text.integerValue*60;
    
    //如果开始计时时paly按钮为打开状态则只开启计时，不调用播放音乐方法
    if (!self.playBtn.selected) {
        [self rotateView];
        self.playBtn.selected = YES;
        [self audioPlayer];
    }
    
    //开启定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(openTimer) userInfo:nil repeats:YES];
    [self.timer fire];
}

//结束计时  点击上下两个结束按钮都会停止计时和播放
- (IBAction)endTimingAction:(UIButton *)sender {
    self.endTimingView.hidden = YES;
    self.setTimeView.hidden = NO;
    //关闭定时器
    [self.timer invalidate];
    self.timer = nil;
    self.playBtn.selected = NO;
    [self endRotateView];
    self.audioPlayer = nil;
}

//开始/结束播放 开始时不计时。结束时结束计时和播放
- (IBAction)playAction:(UIButton *)sender {
    if (self.playBtn.selected) {
        //这时候要关闭
        [self endTimingAction:nil];
    }else{
        //这时候要开始
        self.playBtn.selected = YES;
        [self rotateView];
        [self audioPlayer];
    }
}

//打开本地播放器
- (IBAction)localMusicAction:(UIButton *)sender {
    WeakSelf;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"酷狗音乐" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf openThirdAppWith:@"kugouURL://"];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"酷我音乐" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf openThirdAppWith:@"com.kuwo.kwmusic.kwmusicForKwsing://"];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"网易云音乐" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf openThirdAppWith:@"orpheus://"];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"QQ音乐" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf openThirdAppWith:@"qqmusic://"];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)openThirdAppWith:(NSString *)url{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
            //iOS10.0以上 使用的操作
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
            
        } else{//iOS10.0以下  使用的操作
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];}
    }
}

//切换音乐 关闭正在播放音乐
- (IBAction)changeMusicAction:(UIButton *)sender {
    WeakSelf;
    JXPopoverView *popoverView = [JXPopoverView popoverView];
    JXPopoverAction *action1 = [JXPopoverAction actionWithTitle:@"自然音效类" handler:^(JXPopoverAction *action) {
        weakSelf.selectMusic = 3;
        weakSelf.recordImageView.image = [UIImage imageNamed:weakSelf.imageArr[weakSelf.selectMusic]];
        weakSelf.audioPlayer = nil;
        [weakSelf audioPlayer];
    }];
    JXPopoverAction *action2 = [JXPopoverAction actionWithTitle:@"数羊类" handler:^(JXPopoverAction *action) {
        weakSelf.selectMusic = 2;
        weakSelf.recordImageView.image = [UIImage imageNamed:weakSelf.imageArr[weakSelf.selectMusic]];
        weakSelf.audioPlayer = nil;
        [weakSelf audioPlayer];
    }];
    JXPopoverAction *action3 = [JXPopoverAction actionWithTitle:@"故事类" handler:^(JXPopoverAction *action) {
        weakSelf.selectMusic = 1;
        weakSelf.recordImageView.image = [UIImage imageNamed:weakSelf.imageArr[weakSelf.selectMusic]];
        weakSelf.audioPlayer = nil;
        [weakSelf audioPlayer];
    }];
    JXPopoverAction *action4 = [JXPopoverAction actionWithTitle:@"音乐类" handler:^(JXPopoverAction *action) {
        weakSelf.selectMusic = 0;
        weakSelf.recordImageView.image = [UIImage imageNamed:weakSelf.imageArr[weakSelf.selectMusic]];
        weakSelf.audioPlayer = nil;
        [weakSelf audioPlayer];
    }];
    [popoverView showToView:sender withActions:@[action1,action2,action3,action4]];
}

//打开定时器，这里只打开定时器不播放音乐
- (void)openTimer{
    self.timing--;
    if (self.timing == 0) {
        [self endTimingAction:nil];
    }
    NSInteger minute = 0;
    NSInteger sec = 0;
    if (self.timing >= 60) {
        minute = self.timing/60;
        sec = self.timing%60;
        self.timingLabel.text = [NSString stringWithFormat:@"%ldmin%lds",minute,sec];
    }else{
        sec = self.timing;
        self.timingLabel.text = [NSString stringWithFormat:@"%lds",sec];
    }
}


//开始图片旋转
- (void)rotateView {
    
    CABasicAnimation *rotationAnimation;

    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];

    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];

    rotationAnimation.duration = 3;

    rotationAnimation.repeatCount = HUGE_VALF;

    [self.recordImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

//结束旋转
- (void)endRotateView{
    [self.recordImageView.layer removeAllAnimations];//停止动画
}

#pragma mark -懒加载
- (AVAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        
        // 0. 设置后台音频会话
        // 01. 设置会话模式
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil]; ;
        // 02. 激活会话
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        // 1. 获取资源URL
        NSURL *url = self.musicArr[self.selectMusic];
        
        // 2. 根据资源URL, 创建 AVAudioPlayer 对象
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        //无限播放
        self.audioPlayer.numberOfLoops = -1;
        
        // 2.1 设置允许倍速播放
        self.audioPlayer.enableRate = NO;
        
        // 3. 准备播放
        [_audioPlayer prepareToPlay];
        
        //播放
        [self.audioPlayer play];
        
        // 4. 设置代理, 监听播放事件
        _audioPlayer.delegate = self;
    }
    return _audioPlayer;
}

@end

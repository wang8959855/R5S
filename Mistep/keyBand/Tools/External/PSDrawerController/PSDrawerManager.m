//
//  PSDrawerManager.m
//  PSDrawerController
//
//  Created by 雷亮 on 16/8/8.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "PSDrawerManager.h"
#import "UIView+leoAdd.h"
#import "MainTabBarController.h"
#import "HomeView.h"
//#import "HomeTwoViewController.h"
//#define kScreenWidth [UIScreen mainScreen].bounds.size.width

CGFloat const gestureMinimumTranslation = 20.0;

@interface PSDrawerManager ()

@property (nonatomic, weak, readwrite) UIViewController *centerViewController;
@property (nonatomic, weak, readwrite) UIView *leftView;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;  //常用手势
//@property (nonatomic, strong) UIPanGestureRecognizer *panBtn;  //按钮上的手势


//@property (nonatomic, assign) int direction;    //1是向右   2是向左
//@property (nonatomic, assign) CGFloat lastX;    //拖动  上一次给的 X 点

@end

@implementation PSDrawerManager

+ (instancetype)instance {
    static PSDrawerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

#pragma mark -
#pragma mark - external methods
- (void)installCenterViewController:(UIViewController *)centerViewController leftView:(UIView *)leftView
{
    
    self.centerViewController = centerViewController;
    self.leftView = leftView;
    [[kAppDelegate window] addSubview:leftView];
    [kAppDelegate window].rootViewController = self.centerViewController;
    
    [self showShadow];//设置阴影
    
    [self.centerViewController.view addGestureRecognizer:self.pan];
}

- (void)hiddenShadow {
    if (!self.centerViewController.view) { return; }
    self.centerViewController.view.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.centerViewController.view.layer.shadowOffset = CGSizeMake(0, 0);
    self.centerViewController.view.layer.shadowOpacity = 0;
    self.centerViewController.view.layer.shadowRadius = 0;
}

- (void)showShadow {
    if (!self.centerViewController.view) { return; }
    self.centerViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.centerViewController.view.layer.shadowOffset = CGSizeMake(6, 6);
    self.centerViewController.view.layer.shadowOpacity = 0.7;
    self.centerViewController.view.layer.shadowRadius = 6.f;
}

- (void)beginDragResponse {
    if (!self.centerViewController.view) { return; }
    [self.centerViewController.view addGestureRecognizer:self.pan];
    self.pan.enabled = YES;
}

- (void)cancelDragResponse {
    if (!self.centerViewController.view) { return; }
    //    [self.centerViewController.view removeGestureRecognizer:self.pan];
    self.pan.enabled = NO;
}

///Users/mainuokagi/Desktop/adaNew/demo/特殊功能Mistep/Mistep内网升级2/Podfile

- (void)resetShowType:(PSDrawerManagerShowType)showType {
    if (!self.centerViewController.view) { return; }
    
    CGAffineTransform rightScopeTransform = CGAffineTransformTranslate([kAppDelegate window].transform, CurrentDeviceWidth * kLeftWidthScale, 0);
    
    switch (showType) {
        case PSDrawerManagerShowLeft: {
            [UIView animateWithDuration:0.2f animations:^{
                self.centerViewController.view.transform = rightScopeTransform;
                //                [kAppDelegate window].subviews.firstObject.tx = self.centerViewController.view.tx / 3;
            }];
            break;
        }
        case PSDrawerManagerShowCenter: {
            [UIView animateWithDuration:0.2f animations:^{
                self.centerViewController.view.transform = CGAffineTransformIdentity;
                //                [kAppDelegate window].subviews.firstObject.tx = self.centerViewController.view.tx / 3;
            }];
            break;
        }
        case PSDrawerManagerShowLeftWithoutAnimation: {
            self.centerViewController.view.transform = rightScopeTransform;
            //            [kAppDelegate window].subviews.firstObject.tx = self.centerViewController.view.tx / 3;
            break;
        }
        case PSDrawerManagerShowCenterWithoutAnimation: {
            self.centerViewController.view.transform = CGAffineTransformIdentity;
            //            [kAppDelegate window].subviews.firstObject.tx = self.centerViewController.view.tx / 3;
            break;
        }
    }
}

#pragma mark -
#pragma mark - getter methods
- (UIPanGestureRecognizer *)pan {
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanAction:)];
    }
    return _pan;
}
#pragma mark -
#pragma mark - privite methods
//- (void)handlePanAction:(UIScreenEdgePanGestureRecognizer *)sender {
- (void)handlePanAction:(UIPanGestureRecognizer *)sender
{
    /** 注：
     *   [kAppDelegate window].subviews.firstObject.tx = sender.view.tx / 3;
     *   sender.view.tx / 3 的原因是要让中心控制器每向右移动一像素，左侧视图就向右移动 1/3 像素
     *   另外在初始化左侧视图的时候将其 frame.origin.x 设置为 -kScreenWidth * (1 - kLeftWidthScale), 这样将 tx / 3 就会刚好在左侧视图刚好展示完成时保证左侧视图的 origin.x与屏幕左侧边缘重合
     */
    // 1. 获取手指拖拽的时候，平移的值
    CGPoint translation = [sender translationInView:sender.view];
    // 2. 让当前视图进行平移
    sender.view.transform = CGAffineTransformTranslate(sender.view.transform, translation.x, 0);
    //    [kAppDelegate window].subviews.firstObject.tx = sender.view.tx / 3;
    // 3. 让平移的值不要累加
    [sender setTranslation:CGPointZero inView:sender.view];
    // 4. 获取最右边的范围
    CGAffineTransform rightScopeTransform = CGAffineTransformTranslate([kAppDelegate window].transform, CurrentDeviceWidth * kLeftWidthScale, 0);
    
    if (sender.view.tx > rightScopeTransform.tx) {
        // 当移动到右边极限时
        // 限制最右边的范围
        sender.view.transform = rightScopeTransform;
    } else if (sender.view.tx < 0.0) {
        // 限制最左边的范围
        sender.view.transform = CGAffineTransformTranslate([kAppDelegate window].transform, 0, 0);
    }
    
    // 拖拽结束时
    if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2f animations:^{
            if (sender.view.left > CurrentDeviceWidth * kLeftWidthScale * 0.5) {
                sender.view.transform = rightScopeTransform;
                //创建一个消息对象
//                NSNotification * notice = [NSNotification notificationWithName:@"homeViewWillRefresh" object:nil userInfo:nil];
                //发送消息
//                [[NSNotificationCenter defaultCenter]postNotification:notice];
//                [[HomeView sharedInstance] viewWillRefresh];
//                [[HomeTwoViewController sharedInstance] viewWillRefresh];
                AppDelegate *app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
                app.coverBtn.hidden = NO;
            } else {
                sender.view.transform = CGAffineTransformIdentity;
                //                 [(MainTabBarController*)self.centerViewController selectedViewController].view.userInteractionEnabled  = YES;
                //                 kHCH.coverBtn.hidden = YES;
                AppDelegate *app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
                app.coverBtn.hidden = YES;
            }
        }];
    }
}
@end
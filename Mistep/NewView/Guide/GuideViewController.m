//
//  GuideViewController.m
//  Wukong
//
//  Created by apple on 2019/3/19.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setView];
}

- (void)setView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth*3, ScreenHeight);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    NSArray *imageArr = @[@"guide1",@"guide2",@"guide3"];
    for (int i = 0; i < 3; i++) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, ScreenHeight)];
        [self.scrollView addSubview:imageV];
        imageV.image = [UIImage imageNamed:imageArr[i]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point =  scrollView.contentOffset;
    if (point.x >= ScreenWidth*2+100) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeGuid" object:nil];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isFirstOpen"];
    }
}

@end

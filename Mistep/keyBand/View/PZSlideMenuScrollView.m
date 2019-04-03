//
//  PZSlideMenuScrollView.m
//  Mistep
//
//  Created by 迈诺科技 on 16/7/11.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "PZSlideMenuScrollView.h"

@implementation PZSlideMenuScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        if ([pan translationInView:self].x > 0 && self.contentOffset.x == 0.0f)
        {
            return NO;
        }
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

@end

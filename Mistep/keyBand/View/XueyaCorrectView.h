//
//  XueyaCorrectView.h
//  cyuc
//
//  Created by 迈诺科技 on 2017/2/13.
//  Copyright © 2017年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XueyaCorrectViewDelegate <NSObject>

-(void)callbackChange;

@end
@interface XueyaCorrectView : UIView
@property (nonatomic,weak) id<XueyaCorrectViewDelegate> delegate;
+(id)showXueyaCorrectView;

@end

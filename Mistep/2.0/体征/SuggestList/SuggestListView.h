//
//  SuggestListView.h
//  Wukong
//
//  Created by apple on 2019/12/3.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^closeRequestBlock)();
@interface SuggestListView : UIView

+ (instancetype)suggestListViewWithNum:(NSInteger)num superVC:(UIViewController *)vc list:(NSMutableArray *)list;
@property (nonatomic, strong) UIViewController *vc;

@property (nonatomic, copy) closeRequestBlock closeRequestBlock;

@end

NS_ASSUME_NONNULL_END

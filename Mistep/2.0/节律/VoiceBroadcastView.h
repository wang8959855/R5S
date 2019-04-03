//
//  VoiceBroadcastView.h
//  Wukong
//
//  Created by apple on 2019/3/29.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^backVoiceSwitchBlock)(NSInteger count, NSArray *arr);
@interface VoiceBroadcastView : UIView

+ (instancetype)voiceBroadcastView;

@property (nonatomic, copy) backVoiceSwitchBlock backVoiceSwitchBlock;

@end

NS_ASSUME_NONNULL_END

//
//  HealtPoliceViewController.h
//  Wukong
//
//  Created by apple on 2018/5/22.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "TabBarBaseViewController.h"

@interface HealtPoliceViewController : TabBarBaseViewController

@property (nonatomic, strong) UIImageView *circleImage;

@property (strong, nonatomic) UIButton *targetBtn;

@property (nonatomic, strong) UILabel *nowHeartRateLabel;
@property (nonatomic, strong) UILabel *averageHeartRateLabel;
/** 最高心率 */
@property (nonatomic, strong) UILabel *maxHeartRateLabel;
/** 最低心率 */
@property (nonatomic, strong) UILabel *minHeartRateLabel;

@end

//
//  SportingMapViewController.h
//  Mistep
//
//  Created by 迈诺科技 on 2017/1/22.
//  Copyright © 2017年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SportingMapViewController : UIViewController

@property (nonatomic, strong) NSString *targetTime;//运动的目标时间的字符串
@property (nonatomic, strong) NSDictionary *sportTypeDic;  // 运动类型
@property (nonatomic, assign) BOOL isStoreMap;//yes 就取地图数据

@end

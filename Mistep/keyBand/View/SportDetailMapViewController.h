//
//  SportDetailMapViewController.h
//  Mistep
//
//  Created by 迈诺科技 on 2017/2/27.
//  Copyright © 2017年 huichenghe. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "TabBarBaseViewController.h"

@interface SportDetailMapViewController : TabBarBaseViewController

@property (nonatomic, strong) NSMutableArray *locationMutableArray;//存放用户位置的数组
//用这个数组记录每个字典，1.时长 2.步数 3.心率 4.步数 5.里程
@property (nonatomic,strong) NSMutableArray *dictionaryArray;
@property (strong, nonatomic) NSMutableArray *heartArray;   //心律数组。用于求平均值    又用于存储
@property (assign,nonatomic) NSInteger  kcalNumberPlus;//用于保存kcal
@property (assign, nonatomic) NSInteger progressDet;   //秒数的正数，进度
@property (strong, nonatomic) NSString *fromTime;   //保存运动时间
@property (nonatomic, assign) BOOL isStoreMap;  //yes 就取地图数据
@property (nonatomic, strong) NSDictionary *sportTypeDic;  // 运动类型

@end

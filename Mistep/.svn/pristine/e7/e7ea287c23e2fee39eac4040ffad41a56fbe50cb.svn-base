//
//  SportModelTableViewController.h
//  Mistep
//
//  Created by 迈诺科技 on 2016/10/24.
//  Copyright © 2016年 huichenghe. All rights reserved.
//
typedef enum {
    //以下是枚举成员 sportType = 0,
    SportType_walk = 1,
    SportType_run,
    SportType_uprise,
    SportType_ball,
    SportType_power,
    SportType_aerobic,
    SportType_custom
}sportType;//枚举名称


#import <UIKit/UIKit.h>
#import "SportModelMap.h"

@protocol  MapSportTypeSelectViewControllerDelegate<NSObject>

-(void)callbackSelected:(int)sportType  andSportModel:(SportModelMap *)sport  andSportName:(NSString *)SportName;

@end

@interface MapSportTypeSelectViewController : UIViewController
@property (nonatomic,weak)id<MapSportTypeSelectViewControllerDelegate> delegate;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) SportModelMap *sport;
@end

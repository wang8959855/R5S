//
//  SportMapTableViewCell.h
//  Mistep
//
//  Created by 迈诺科技 on 2017/1/19.
//  Copyright © 2017年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportModelMap.h"

typedef void (^backBlock)(int);

@protocol SportMapTableViewCellDelegate <NSObject>

-(void)deleteSportWithID:(NSString *)sportID;

@end

@interface SportMapTableViewCell : UITableViewCell

@property (nonatomic,strong) NSString * sportID;   //唯一的id   用于。存  删
@property (nonatomic,weak) id<SportMapTableViewCellDelegate> delegate;


@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIImageView *iconView; //轨迹图标
@property (nonatomic,strong) UILabel *stepsNumberLabel; //轨迹的字
@property (nonatomic,strong) UILabel *kcalNumberLabel;
@property (nonatomic,strong) UILabel *bpmNumberLabel;


@property (nonatomic,strong) NSString *headViewString;
@property (nonatomic,strong) NSString *timeString;
@property (nonatomic,strong) NSString *stepString;
@property (nonatomic,strong) NSString *kcalString;
@property (nonatomic,strong) NSString *bpmString;

@property (nonatomic,assign) NSInteger arrayIndex;//数组的下标


@property (nonatomic,strong) SportModelMap *sport;
@property (nonatomic,copy) backBlock backBlock;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

//-(void)refreshUI:(SportModel * )sport;

@end

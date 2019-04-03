//
//  SportTypeSelected.h
//  custom
//
//  Created by 蒋宝 on 17/1/19.
//  Copyright © 2017年 Smartbi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SportTypeSelectedDelegate <NSObject>

-(void)callbackSportType:(NSMutableDictionary *)sportTypeDic;

@end

@interface SportTypeSelected : UIView

@property (nonatomic,weak) id<SportTypeSelectedDelegate> delegate;
@property (nonatomic,strong) NSMutableDictionary *sportTypeDic;

+(id)showSportTypeSelect;
- (void)show;
@end

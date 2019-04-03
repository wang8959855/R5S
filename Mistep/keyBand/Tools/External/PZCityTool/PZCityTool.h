//
//  PZCityTool.h
//  Mistep
//
//  Created by 迈诺科技 on 16/7/25.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PZCityTool : NSObject

+ (PZCityTool *)sharedInstance;
/**
 *
 *刷新定位
 */
-(void)refresh;
 
@end

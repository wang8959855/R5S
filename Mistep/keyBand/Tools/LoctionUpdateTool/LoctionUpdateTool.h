//
//  LoctionUpdateTool.h
//  Wukong
//
//  Created by apple on 2018/6/19.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoctionUpdateTool : NSObject

+ (LoctionUpdateTool *)sharedInstance;

- (void)startUploadLocation;

@end

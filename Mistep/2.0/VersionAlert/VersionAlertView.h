//
//  VersionAlertView.h
//  Wukong
//
//  Created by apple on 2019/8/6.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VersionAlertView : UIView

+ (VersionAlertView *)versionAlertViewWithTitle:(NSString *)title content:(NSArray *)content;

@end

NS_ASSUME_NONNULL_END

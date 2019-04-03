//
//  GMHeader.h
//  SmartHouse
//
//  Created by Showsoft_002 on 13-6-5.
//  Copyright (c) 2013年 Showsoft_002. All rights reserved.
//

#ifndef SHOWSOFTLOG
#define SHOWSOFTLOG
#endif

#ifdef SHOWSOFTLOG
# define SSLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define SSLog(...);
#endif

#define CurrentDeviceCenter [[GMHeader getInstance] getCurrentDevieceCenter]
#define CurrentDeviceBounds [[GMHeader getInstance] getCurrentDevieceBounds]
#define CurrentDeviceSize [[GMHeader getInstance] getCurrentDevieceSize]
#define CurrentDeviceWidth [[GMHeader getInstance] getCurrentDevieceWidth]
#define CurrentDeviceHeight [[GMHeader getInstance] getCurrentDevieceHeight]
#define CurrentDeviceMiddleHeight ([[GMHeader getInstance] getCurrentDevieceHeight] - 64.0 - 49.0)

#define WidthProportion  CurrentDeviceWidth / 375.0
#define HeightProportion  CurrentDeviceHeight / 667.0


//#define deviceWidth [UIScreen mainScreen].bounds.size.width
//#define deviceHeight [UIScreen mainScreen].bounds.size.height
//#define deviceMiddleHeight ([UIScreen mainScreen].bounds.size.height - 64 - 49)

#define IsIpad_Device [[GMHeader getInstance] checkIsIpad]
#define IsIphone4_Device [[GMHeader getInstance] checkIsIpone4]
#define IsIphone5_Device [[GMHeader getInstance] checkIsIpone5]
#define IsIphone6_Device [[GMHeader getInstance] checkIsIpone6]
#define IsIphone6Plus_Device [[GMHeader getInstance] checkIsIpone6Plus]

#define LabelTextColor70 [UIColor colorWithRed:70.f/255.f green:70.f/255.f blue:70.f/255.f alpha:1.f]
#define LabelTextColor105 [UIColor colorWithRed:105.f/255.f green:105.f/255.f blue:105.f/255.f alpha:1.f]

//图片资源
#define RESOURCES_PATH @"PicResources"

//指定设备文件夹加载图片
#define AppointFolder_IMAGE(x) [[GMHeader getInstance] rtImageWithName:x]
//通用文件夹加载图片
#define GeneralFolder_IMAGE(x) [[GMHeader getInstance] rtNormalImageWithName:x]

#define LT_Normal_Font @"FrutigerNextLT-Regular" //细字体
#define LT_Medium_Font @"FrutigerNextLT-Medium"  //胖字体
#define fontSizeBig [UIFont systemFontOfSize:24]  //胖字体
#define fontSizeSmall [UIFont systemFontOfSize:12]  //胖字体
//#define Font_Normal_String(x) [UIFont fontWithName:LT_Normal_Font size:x]
//#define Font_Bold_String(x) [UIFont fontWithName:LT_Medium_Font size:x]

#define Font_Normal_String(x) [[GMHeader getInstance] getFontWithName:LT_Normal_Font size:x]
#define Font_Bold_String(x) [[GMHeader getInstance] getFontWithName:LT_Medium_Font size:x]

#define IOS6SystermJudge [[UIDevice currentDevice].systemVersion floatValue] < 7.f

//添加字体，在plist文件中，增加Fonts provided by application，加入字体即可

#define SerializationString(x) [[GMHeader getInstance] localLaguage:x]



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GMHeader : NSObject

+ (GMHeader *)getInstance;

//根据指定的名字返回图片
- (UIImage *)rtImageWithName : (NSString *)nameString;
- (UIImage *)rtNormalImageWithName : (NSString *)nameString;
- (UIFont *)getFontWithName:(NSString *)font size:(CGFloat) size;

- (CGPoint)getCurrentDevieceCenter;
- (CGRect)getCurrentDevieceBounds;
- (CGSize)getCurrentDevieceSize;
- (float)getCurrentDevieceWidth;
- (float)getCurrentDevieceHeight;
- (BOOL)checkIsIpad;
- (BOOL)checkIsIpone4;
- (BOOL)checkIsIpone5;
- (BOOL)checkIsIpone6;
- (BOOL)checkIsIpone6Plus;


@end

//
//  GMHeader.m
//  SmartHouse
//
//  Created by Showsoft_002 on 13-6-5.
//  Copyright (c) 2013年 Showsoft_002. All rights reserved.
//

#import "GMHeader.h"
#import "sys/utsname.h"

//采用三位句柄
//百位表示是否为pad，是为1，不是为0
//十位表示是否为retain屏，是为1，不是为0
//个位表示备注，在此规定，1表示iphone5

static GMHeader * instance=nil;

typedef enum {
    iPhone3GS_Enum = 0 ,
    iPhone4_Enum,
    iPhone5_Enum,
    iPhone6_Enum,
    iPhone6Plus_Enum,
    
    iPad_Enum = 100 ,
    iPadRetain_Enum ,
    
}DeviceType_Enum;

@interface GMHeader(){
    int numOfDeviece  ;
    CGRect cFrames ;
    BOOL isReadLocalData;
    NSString *curLocAddress;
    NSString *commonAddress;
}

@end

@implementation GMHeader

#define IpadName @""
#define IpadExName @""//_Ipad_HD
#define Iphone1xName @""
#define Iphone2xName @"@2x"
#define Iphone5Name @"@2x"
#define Iphone6Name @"@2x"
#define Iphone6PlusName @"@3x"

#define UI_USER_INTERFACE_IDIOM() ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] ? [[UIDevice currentDevice] userInterfaceIdiom] : UIUserInterfaceIdiomPhone)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

+ (GMHeader *)getInstance{
    if( instance == nil ){
        //        static dispatch_once_t onceToken;
        @synchronized(self) {
            instance =  [[GMHeader alloc] init];
            [instance initData];
        }
    }
    
    return instance;
}

- (void)initData{
    numOfDeviece = -1 ;
    cFrames = CGRectZero ;
    isReadLocalData = NO ;
    curLocAddress = @"" ;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRoatation:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (CGPoint)getCurrentDevieceCenter
{
    CGSize size = CurrentDeviceSize;
    return CGPointMake(size.width/2, size.height/2);

}

- (CGRect)getCurrentDevieceBounds{
    if( cFrames.size.width != 0 ) return cFrames;
    
    [self getDevieceNum];
    
    cFrames.size = [[UIScreen mainScreen] currentMode].size ;
    
    if(numOfDeviece == iPhone3GS_Enum && (cFrames.size.width * cFrames.size.height == 1024*768) ){
        cFrames.size = CGSizeMake(320, 480);
        return cFrames ;
    }else if( numOfDeviece == iPhone4_Enum && ((cFrames.size.width * cFrames.size.height == 1024*768)  || (cFrames.size.width * cFrames.size.height == 2048*1536))){
        cFrames.size = CGSizeMake(320, 480);
        return cFrames ;
    }

    
    if([UIScreen mainScreen].scale == 2.0){
        cFrames.size.width /= 2 ;
        cFrames.size.height /= 2 ;
    }else if([UIScreen mainScreen].scale == 3.0){
        cFrames.size.width /= 3 ;
        cFrames.size.height /= 3 ;
    }
    
    return cFrames;
}

- (CGSize)getCurrentDevieceSize{
    if( cFrames.size.width == 0 ){
        [self getCurrentDevieceBounds];
    }
    
    return cFrames.size ;
}

- (float)getCurrentDevieceWidth{
    if( cFrames.size.width == 0 ){
        [self getCurrentDevieceBounds];
    }
    
    return cFrames.size.width ;
}

- (float)getCurrentDevieceHeight{
    if( cFrames.size.height == 0 ){
        [self getCurrentDevieceBounds];
    }
    
    return cFrames.size.height ;
}

- (void)getDevieceNum{
    if( numOfDeviece == -1){
        numOfDeviece = 0;
        isReadLocalData = NO ;
        
        curLocAddress = @"PicResources/Iphone4";
        commonAddress = @"PicResources/General";
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            numOfDeviece = iPad_Enum;
            curLocAddress = @"PicResources/Ipad";
            if([UIScreen mainScreen].scale > 1.0){
                numOfDeviece = iPadRetain_Enum;
            }
        }else if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
            CGSize sizess = [[UIScreen mainScreen] currentMode].size ;
            if([UIScreen mainScreen].scale > 1.0){
                if( (sizess.width == 640)&&(sizess.height == 960) ){
                    numOfDeviece = iPhone4_Enum ;
                }else if( (sizess.width == 640)&&(sizess.height == 1136) ){
                    numOfDeviece = iPhone5_Enum;
                    curLocAddress = @"PicResources/Iphone5";
                }else if( (sizess.width == 750)&&(sizess.height == 1334) ){
                    numOfDeviece = iPhone6_Enum;
                    curLocAddress = @"PicResources/Iphone6";
                }else{
                    numOfDeviece = iPhone6Plus_Enum;
                    curLocAddress = @"PicResources/Iphone6Plus";
                }
            }else{
                numOfDeviece = iPhone3GS_Enum ;
            }
            if (sizess.width * sizess.height == 1024*768 || sizess.width * sizess.height == 2048 * 1536) {
                numOfDeviece = iPhone4_Enum;
                curLocAddress = @"PicResources/Iphone4";
            }
        }
    }
}

- (BOOL)checkIsIpad{
    BOOL iipad = (numOfDeviece == iPad_Enum)?YES:NO ;
    if( iipad ) return YES ;
    return (numOfDeviece == iPadRetain_Enum)?YES:NO ;
}

- (BOOL)checkIsIpone4{
    return (numOfDeviece == iPhone4_Enum)?YES:NO ;
}

- (BOOL)checkIsIpone5{
    return (numOfDeviece == iPhone5_Enum)?YES:NO ;
}

- (BOOL)checkIsIpone6{
    return (numOfDeviece == iPhone6_Enum)?YES:NO ;
}

- (BOOL)checkIsIpone6Plus{
    return (numOfDeviece == iPhone6Plus_Enum)?YES:NO ;
}

- (NSString *)rtOtherResourcePath:(NSString *)string withAddress:(NSString *)assignAddress{
    NSString *rtString = [NSString stringWithFormat:@"%@" , string ];
    NSArray *array = [rtString componentsSeparatedByString:@"/"];
    
    NSString *curPath  ;
    NSString *last = [rtString lastPathComponent];
    
    if([array count]>=2){
        curPath = [array objectAtIndex:0];
        for(int i=1;i<[array count]-1 ; i++){
            curPath = [NSString stringWithFormat:@"%@/%@" , curPath,[array objectAtIndex:i]];
        }
    }
    
    NSString *dirctory = assignAddress ;
    if( curPath ){
        dirctory = [NSString stringWithFormat:@"%@/%@",assignAddress,curPath];
    }
    
    rtString = [[NSBundle mainBundle] pathForResource:last ofType:nil inDirectory:dirctory];
    
    return rtString;
}

- (NSString *)shLoadImageWithName : (NSString *)nameString withAddress:(NSString *)assignAddress{
    NSString *rtString ;
    
    [self getDevieceNum];
    
    NSRange ranges = [nameString rangeOfString:@"." options:1];
    if( ranges.location == NSNotFound) return @"";
    NSString *deString= @"";
    
    switch (numOfDeviece) {
        case iPhone3GS_Enum://表示 非retain iphone或者ipod
            deString = Iphone1xName;
            break;
        case iPhone4_Enum://表示 retain iphone或者ipod
            deString = Iphone2xName;
            break;
        case iPhone5_Enum://表示 retain iphone5
            deString = Iphone5Name;
            break;
        case iPhone6_Enum:
            deString = Iphone6Name ;
            break;
        case iPhone6Plus_Enum:
            deString = Iphone6PlusName ;
            break;
        case iPad_Enum://表示 非retain ipad
            deString = IpadName;
            break;
        case iPadRetain_Enum://表示 retain ipad
            deString = IpadExName;
            break;
        default:
            break;
    }
    
    if( [nameString rangeOfString:deString options:1].location == NSNotFound){
        rtString = [NSString stringWithFormat:@"%@%@%@",[nameString substringToIndex:ranges.location],deString,[nameString substringFromIndex:ranges.location]];
        
    }else{
        rtString = [NSString stringWithFormat:@"%@",nameString];
    }
    
    NSArray *array = [rtString componentsSeparatedByString:@"/"];
    
    NSString *curPath  ;
    NSString *last = [rtString lastPathComponent];
    
    if([array count]>=2){
        curPath = [array objectAtIndex:0];
        for(int i=1;i<[array count]-1 ; i++){
            curPath = [NSString stringWithFormat:@"%@/%@" , curPath,[array objectAtIndex:i]];
        }
    }
    
    NSString *dirctory = assignAddress ;
    if( curPath ){
        dirctory = [NSString stringWithFormat:@"%@/%@",assignAddress,curPath];
    }
    rtString = [[NSBundle mainBundle] pathForResource:last ofType:nil inDirectory:dirctory];
    
    return rtString;
}

- (UIImage *)rtImageWithName : (NSString *)nameString{
    //先根据设备返回当前设备所对应的图片名字
    NSString *string = [self shLoadImageWithName:nameString withAddress:curLocAddress];
    UIImage *locImage = [UIImage imageWithContentsOfFile:string];
    
    //如果图片为nil并且strin！= namestring
    if( !locImage && ![string isEqualToString:nameString] ){
        NSString *otherString = [self rtOtherResourcePath:nameString withAddress:curLocAddress];//[[NSBundle mainBundle] pathForResource:nameString ofType:nil inDirectory:RESOURCES_PATH];
        locImage = [UIImage imageWithContentsOfFile:otherString];
    }
    
    return locImage;
}

- (UIImage *)rtNormalImageWithName : (NSString *)nameString{
    //先根据设备返回当前设备所对应的图片名字
    NSString *string = [self shLoadImageWithName:nameString withAddress:commonAddress];
    UIImage *locImage = [UIImage imageWithContentsOfFile:string];
    
    //如果图片为nil并且strin！= namestring
    if( !locImage && ![string isEqualToString:nameString] ){
        NSString *otherString = [self rtOtherResourcePath:nameString withAddress:commonAddress];//[[NSBundle mainBundle] pathForResource:nameString ofType:nil inDirectory:RESOURCES_PATH];
        locImage = [UIImage imageWithContentsOfFile:otherString];
    }
    
    return locImage;
}

- (UIFont *)getFontWithName:(NSString *)font size:(CGFloat) size {
    CGFloat height = [[UIScreen mainScreen] bounds].size.width;
    size = size*height/320;
    return [UIFont systemFontOfSize:size];
}


@end

#import <Foundation/Foundation.h>

typedef void(^GCDTask)(BOOL cancel);
typedef void(^gcdBlock)();

@interface GCDDelay : NSObject

+(GCDTask)gcdDelay:(NSTimeInterval)time task:(gcdBlock)block;
+(void)gcdCancel:(GCDTask)task;

+(void)gcdTest;

@end

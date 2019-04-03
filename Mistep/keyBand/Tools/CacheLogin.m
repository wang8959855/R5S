
//
//  CacheLogin.m
//  Mistep
//
//  Created by 迈诺科技 on 2016/12/27.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "CacheLogin.h"

@implementation CacheLogin

/**
 *  使用缓存登录
 */
+(BOOL)logining
{
    BOOL islogin = NO;
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:LastLoginUser_Info];
    if (dic)
    {
        [ADASaveDefaluts setObject:@"1" forKey:LOGINTYPE];
        islogin = [self useCacheLogin:dic];
    }
    else
    {
        NSDictionary *thirdDic = [[NSUserDefaults standardUserDefaults] objectForKey:kThirdPartLoginKey];
        if (thirdDic)
        {
            [ADASaveDefaluts setObject:@"2" forKey:LOGINTYPE];
            islogin = [self useThirdCacheLogin:thirdDic];
        }
    }
    return islogin;
}
+(BOOL)useCacheLogin:(NSDictionary *)loginDic
{
    
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"user_login" ParametersDictionary:loginDic Block:^(id responseObject, NSError *error,NSURLSessionDataTask *task)
     {
         if (error)
         {
             //adaLog(@"登录超时");
         }
         else
         {
             
         }
     }];
    
    return YES;
}

+(BOOL)useThirdCacheLogin:(NSDictionary *)param
{
    
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"user_thirdPartyLogin" ParametersDictionary:param Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
        if (error)
        {
            //adaLog(@"登录超时");
        }
        else
        {
        }
    } ];
    return YES;
}
@end

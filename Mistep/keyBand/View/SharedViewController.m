
//
//  SharedViewController.m
//  keyBand
//
//  Created by 迈诺科技 on 15/11/2.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import "SharedViewController.h"
#import "AppDelegate.h"
#import <TwitterKit/TwitterKit.h>
//#import <UShareUI/UShareUI.h>
//#import "UMShareTypeViewController.h"
#import "UMSocial.h"


@interface SharedViewController ()<UITextViewDelegate>

typedef enum {
    ShareTypeQQ = 200,
    ShareTypeKongJian,
    ShareTypeWeiXin,
    ShareTypePengYouQuan,
    ShareTypeWeiBo,
    ShareTypeFacebook,
    ShareTypeTwitter
}ShareType;

@end

@implementation SharedViewController

- (void)dealloc
{
    
}

- (void)setXibLabel
{
    _titleLabel.text = NSLocalizedString(@"分享", nil);
    _shareToLabel.text = NSLocalizedString(@"分享到:", nil);
    [_shareToOther setTitle:NSLocalizedString(@"分享到其他", nil) forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setXibLabel];
    self.shareImageView.image = self.image;
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[PSDrawerManager instance] cancelDragResponse];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 按钮事件

- (IBAction)LastPage:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //    [self.view removeConstraints:self.view.constraints];
}

- (IBAction)shareToOther:(UIButton *)sender
{
    [UMSocialData defaultData].extConfig.title = @"分享的title";
    [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"5b34dec5a40fa35b2d00016c"
                                      shareText:appName
                                     shareImage:_image
                                shareToSnsNames:@[UMShareToSms,UMShareToEmail]
                                       delegate:nil];
    //    [UMSocialUIManager removeAllCustomPlatformWithoutFilted];
    //    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sms),@(UMSocialPlatformType_Email)]];
    //    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    //    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRadius;
    //
    //    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
    //
    //        [self runShareWithType:platformType];
    //    }];
}
//UMSocialPlatformType_Sms                = 13,//短信
//UMSocialPlatformType_Email              = 14,//邮件

//- (void)runShareWithType:(UMSocialPlatformType)type
//{
//    adaLog(@"type = %ld",type);
//
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = nil;
//    messageObject = [UMSocialMessageObject messageObject];
//    //设置文本
//    messageObject.text = @"mistep";
//    //创建图片内容对象
//    UMShareImageObject *shareObject = nil;
//    shareObject = [[UMShareImageObject alloc] init];
//    //如果有缩略图，则设置缩略图
//    //shareObject.thumbImage = _image;
//    shareObject.shareImage = _image;
//    //分享消息对象设置分享内容对象
//
//    messageObject.shareObject = shareObject;
//    UMSocialPlatformType aa = type;
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:aa messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error) {
//            adaLog(@"************Share fail with error %@*********",error);
//        }else{
//            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;
//                //分享结果消息
//                adaLog(@"response message is %@",resp.message);
//                //第三方原始返回的数据
//                adaLog(@"response originalResponse data is %@",resp.originalResponse);
//
//            }else{
//                adaLog(@"response data is %@",data);
//            }
//        }
//    }];
//}

- (IBAction)chooseShare:(UIButton *)sender
{
    _selectedBtn = sender.tag;
    UMSocialSnsPlatform *snsPlatform = [[UMSocialSnsPlatform alloc]init];
    [UMSocialData setAppKey:@"5b34dec5a40fa35b2d00016c"];
    switch (_selectedBtn)
    {
        case ShareTypeQQ:
        {
            [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
            snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"qq"];
        }
            break;
        case ShareTypeKongJian:
        {
            [UMSocialData defaultData].extConfig.qzoneData.url = @"http://bracelet.cositea.com:8089/bracelet/";
            snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"qzone"];
        }
            break;
        case ShareTypeWeiXin:
        {
            [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeImage;
            snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"wxsession"];
        }
            break;
        case ShareTypePengYouQuan:
        {
            [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeImage;
            snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"wxtimeline"];
        }
            break;
        case ShareTypeWeiBo:
        {
            snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"sina"];
        }
            break;
        case ShareTypeFacebook:
        {
            snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"facebook"];
        }
            break;
        case ShareTypeTwitter:
        {
            //            snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"twitter"];
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToTwitter] content:appName image:_image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
                if (response.responseCode == UMSResponseCodeSuccess)
                {
                    [self showAlertView:NSLocalizedString(@"分享成功", nil)];
                }
            }];
            return;
        }
            break;
        default:
            break;
    }
    [[UMSocialControllerService defaultControllerService] setShareText:appName shareImage:_image socialUIDelegate:nil];
    if (snsPlatform == nil) {
        [self.view makeCenterToast:@"暂不支持"];
        return;
    }
    snsPlatform.snsClickHandler(self,[UMSocialControllerService  defaultControllerService],YES);
}

//{
//    _selectedBtn = sender.tag;
//
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = nil;
//    messageObject = [UMSocialMessageObject messageObject];
//    //设置文本
//    messageObject.text = @"mistep";
//    //创建图片内容对象
//    UMShareImageObject *shareObject = nil;
//    shareObject = [[UMShareImageObject alloc] init];
//    //如果有缩略图，则设置缩略图
//    //shareObject.thumbImage = _image;
//    shareObject.shareImage = _image;
//    //分享消息对象设置分享内容对象
//
//    messageObject.shareObject = shareObject;
//    UMSocialPlatformType aa = UMSocialPlatformType_QQ;
//
//    switch (_selectedBtn)
//    {
//        case ShareTypeQQ:
//        {
//            aa = UMSocialPlatformType_QQ;
//        }
//            break;
//
//        case ShareTypeWeiXin:
//        {
//            aa = UMSocialPlatformType_WechatSession;
//        }
//            break;
//        case ShareTypePengYouQuan:
//        {
//            aa = UMSocialPlatformType_WechatTimeLine;
//        }
//            break;
//        case ShareTypeWeiBo:
//        {
//            aa = UMSocialPlatformType_Sina;
//        }
//            break;
//        case ShareTypeFacebook:
//        {
//            aa = UMSocialPlatformType_Facebook;
//        }
//            break;
//        case ShareTypeTwitter:
//        {
//            aa = UMSocialPlatformType_Twitter;
//            adaLog(@"  -- - - twitter");
//        }
//            break;
//        default:
//            break;
//    }
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:aa messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error) {
//            adaLog(@"************Share fail with error %@*********",error);
//        }else{
//            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;
//                //分享结果消息
//                adaLog(@"response message is %@",resp.message);
//                //第三方原始返回的数据
//                adaLog(@"response originalResponse data is %@",resp.originalResponse);
//
//            }else{
//                adaLog(@"response data is %@",data);
//            }
//        }
//    }];
//}





- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

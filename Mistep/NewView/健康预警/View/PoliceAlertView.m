//
//  PoliceAlertView.m
//  Wukong
//
//  Created by apple on 2018/9/4.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "PoliceAlertView.h"

@interface PoliceAlertView()

@property (weak, nonatomic) IBOutlet UIButton *switchButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation PoliceAlertView

+ (PoliceAlertView *)policeAlertView{
    PoliceAlertView *v = [[NSBundle mainBundle] loadNibNamed:@"PoliceAlertView" owner:self options:nil].lastObject;
    v.frame = [UIScreen mainScreen].bounds;
    v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.55];
    [v getState];
    
    return v;
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

//切换状态
- (IBAction)switchAction:(UIButton *)sender {
    NSString *url = [NSString stringWithFormat:@"%@/%@",SETNOTI,TOKEN];
    NSDictionary *para = @{@"UserID":USERID,@"warn":@(!sender.selected)};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    // 3.设置超时时间为10s
    [manager POST:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        int code = [responseObject[@"code"] intValue];
        if (code == 0) {
            sender.selected = !sender.selected;
            if (sender.selected) {
                self.titleLabel.text = @"预警通知开启";
            }else{
                self.titleLabel.text = @"预警通知关闭";
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//查询状态
- (void)getState{
    NSString *url = [NSString stringWithFormat:@"%@/%@",GETSERVER,TOKEN];
    NSDictionary *para = @{@"UserID":USERID};
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:para Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        int code = [responseObject[@"code"] intValue];
        if (code == 0) {
           int isWarn = [responseObject[@"data"][@"isWarn"] intValue];
            self.switchButton.selected = isWarn;
            if (isWarn) {
                self.titleLabel.text = @"预警通知开启";
            }else{
                self.titleLabel.text = @"预警通知关闭";
            }
        }else{
            
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.switchStateBlock) {
        self.switchStateBlock(self.self.switchButton.selected);
    }
    [self removeFromSuperview];
}

@end

//
//  AlertNickNameView.h
//  Wukong
//
//  Created by apple on 2018/5/17.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertNickNameView : UIView

+ (AlertNickNameView *)alertNickNameView;

- (void)show;

@property (weak, nonatomic) IBOutlet UITextField *nickTF;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;


@end

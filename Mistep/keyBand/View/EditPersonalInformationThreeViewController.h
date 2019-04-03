//
//  EditPersonalInformationThreeViewController.h
//  Wukong
//
//  Created by apple on 2018/5/15.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "PZBaseViewController.h"

@interface EditPersonalInformationThreeViewController : PZBaseViewController

//上传的字典
@property (strong, nonatomic) NSMutableDictionary *uploadInfoDic;

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (weak, nonatomic) IBOutlet UIButton *completeButton;

@property (weak, nonatomic) IBOutlet UITextField *rafTel1TF;
@property (weak, nonatomic) IBOutlet UITextField *rafTel2TF;
@property (weak, nonatomic) IBOutlet UITextField *rafTel3TF;

@property (strong, nonatomic) NSString *imageFilePath;



@end

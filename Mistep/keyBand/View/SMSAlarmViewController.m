//
//  SMSAlarmViewController.m
//  Wukong
//
//  Created by 迈诺科技 on 16/5/18.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "SMSAlarmViewController.h"
#import "SMSTableViewCell.h"

@interface SMSAlarmViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SMSAlarmViewController

static NSString * reuseID = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _titleLabel.text = NSLocalizedString(@"信息提醒", nil);
    
    [_tableView registerNib:[UINib nibWithNibName:@"SMSTableViewCell" bundle:nil] forCellReuseIdentifier:reuseID];
    //     [ADASaveDefaluts setObject:@"2" forKey:SUPPORTINFORMATION];//支持Line信息提醒
    if([[ADASaveDefaluts objectForKey:SUPPORTINFORMATION] intValue] == 2)
    {//支持Line信息提醒
        _dataArray = @[NSLocalizedString(@"电话簿短信", nil),@"电话簿短信",NSLocalizedString(@"QQ好友信息", nil),@"SZ_QQ",NSLocalizedString(@"微信好友信息", nil),@"SZ_微信",NSLocalizedString(@"Facebook信息", nil),@"SZ_facebook",NSLocalizedString(@"WhatsAPP信息", nil),@"WhatsApp",NSLocalizedString(@"Twitter信息", nil),@"twitter",NSLocalizedString(@"Skype信息", nil),@"skype",NSLocalizedString(@"Line信息", nil),@"line"];
        
        _tagArray = @[@2,@10,@9,@11,@14,@13,@12,@16];
        
    }
    else
    {
        _dataArray = @[NSLocalizedString(@"电话簿短信", nil),@"电话簿短信",NSLocalizedString(@"QQ好友信息", nil),@"SZ_QQ",NSLocalizedString(@"微信好友信息", nil),@"SZ_微信",NSLocalizedString(@"Facebook信息", nil),@"SZ_facebook",NSLocalizedString(@"WhatsAPP信息", nil),@"WhatsApp",NSLocalizedString(@"Twitter信息", nil),@"twitter",NSLocalizedString(@"Skype信息", nil),@"skype"];
        _tagArray = @[@2,@10,@9,@11,@14,@13,@12];
    }
}
- (void)dealloc
{
    
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self querySystemAlarm];
    
}

- (void)querySystemAlarm
{
    if([[ADASaveDefaluts objectForKey:SUPPORTINFORMATION] intValue] == 2)
    {//支持Line信息提醒
        for (int i = 0 ; i < 8; i ++)
        {
            WeakSelf;
            [[CositeaBlueTooth sharedInstance] checkSystemAlarmWithType:[_tagArray[i] intValue] StateBlock:^(int index, int state) {
                switch (index)
                {
                    case SystemAlarmType_SMS:
                    {
                        SMSTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                        [cell.openSwitch setOn:state animated:YES];
                    }
                        break;
                    case SystemAlarmType_QQ:
                    {
                        SMSTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                        [cell.openSwitch setOn:state animated:YES];
                    }
                        break;
                    case SystemAlarmType_WeChat:
                    {
                        SMSTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                        [cell.openSwitch setOn:state animated:YES];
                    }
                        break;
                    case SystemAlarmType_Facebook:
                    {
                        SMSTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                        [cell.openSwitch setOn:state animated:YES];
                    }
                        break;
                    case SystemAlarmType_WhatsAPP:
                    {
                        SMSTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                        [cell.openSwitch setOn:state animated:YES];
                    }
                        break;
                    case SystemAlarmType_Twitter:
                    {
                        SMSTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
                        [cell.openSwitch setOn:state animated:YES];
                    }
                        break;
                    case SystemAlarmType_Skype:
                    {
                        SMSTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
                        [cell.openSwitch setOn:state animated:YES];
                    }
                        break;
                        
                    case SystemAlarmType_Line:
                    {
                        SMSTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
                        [cell.openSwitch setOn:state animated:YES];
                    }
                        break;
                    default:
                        break;
                }
                //adaLog(@"index= %d,state= %d",index,state);
            }];
        }
    }
    else
    {
        for (int i = 0 ; i < 7; i ++)
        {
            WeakSelf;
            [[CositeaBlueTooth sharedInstance] checkSystemAlarmWithType:[_tagArray[i] intValue] StateBlock:^(int index, int state) {
                switch (index)
                {
                    case SystemAlarmType_SMS:
                    {
                        SMSTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                        [cell.openSwitch setOn:state animated:YES];
                    }
                        break;
                    case SystemAlarmType_QQ:
                    {
                        SMSTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                        [cell.openSwitch setOn:state animated:YES];
                    }
                        break;
                    case SystemAlarmType_WeChat:
                    {
                        SMSTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                        [cell.openSwitch setOn:state animated:YES];
                    }
                        break;
                    case SystemAlarmType_Facebook:
                    {
                        SMSTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                        [cell.openSwitch setOn:state animated:YES];
                    }
                        break;
                    case SystemAlarmType_WhatsAPP:
                    {
                        SMSTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                        [cell.openSwitch setOn:state animated:YES];
                    }
                        break;
                    case SystemAlarmType_Twitter:
                    {
                        SMSTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
                        [cell.openSwitch setOn:state animated:YES];
                    }
                        break;
                    case SystemAlarmType_Skype:
                    {
                        SMSTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
                        [cell.openSwitch setOn:state animated:YES];
                    }
                        break;
                    default:
                        break;
                }
                //adaLog(@"index= %d,state= %d",index,state);
            }];
        }
    }
}

#pragma mark -- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    cell.nameLabel.text = _dataArray[indexPath.row * 2];
    cell.headImageView.image = [UIImage imageNamed: _dataArray[indexPath.row * 2 +1]];
    cell.openTag = [_tagArray[indexPath.row] intValue];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

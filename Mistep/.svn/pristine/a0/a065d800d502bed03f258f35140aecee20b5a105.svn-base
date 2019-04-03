//
//  AlarmViewController.m
//  keyBand
//
//  Created by 迈诺科技 on 15/11/20.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import "AlarmViewController.h"
#import "ZIDingYiViewController.h"
#import "AlarmTableViewCell.h"
#import "HeartAlarmViewController.h"
#import "DeleteAlertViewController.h"
#import "SMTabbedSplitViewController.h"

@interface AlarmViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *alarmArray;
    NSMutableArray *contentArray;
    NSMutableArray *exitArray;
}
@end

static NSString *reuseID = @"alarmCell";

@implementation AlarmViewController

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    alarmArray = nil;
    contentArray = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setXibLabel];

    alarmArray = @[NSLocalizedString(@"运动", nil),NSLocalizedString(@"约会",nil),NSLocalizedString (@"喝水", nil),NSLocalizedString (@"吃药",nil),NSLocalizedString(@"睡眠",nil)];
    contentArray = [[NSMutableArray alloc]init];
    exitArray = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"", nil];
    [_alarmTableVIew registerNib:[UINib nibWithNibName:@"AlarmTableViewCell" bundle:nil] forCellReuseIdentifier:reuseID];
    
}

- (void)setXibLabel
{
    _titleLabel.text = NSLocalizedString(@"添加闹铃", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BlueToothDataDelegate


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (int i = 0 ; i < exitArray.count; i ++)
    {
        exitArray[i] = @"";
    }
    if (contentArray)
    {
        [contentArray removeAllObjects];
        [_alarmTableVIew reloadData];
        
    }
    if ([CositeaBlueTooth sharedInstance].isConnected)
    {
        WeakSelf;
        [[CositeaBlueTooth sharedInstance] checkAlarmWithBlock:^(CustomAlarmModel *alarmModel) {
            [weakSelf updateAlarmListWith:alarmModel];
        }];
    }
    else
    {
        [self addActityTextInView:self.view text:NSLocalizedString(@"蓝牙未连接" , nil) deleyTime:1.5];
    }
}

#pragma mark - 蓝牙连接方法

- (void)updateAlarmListWith:(CustomAlarmModel *)model {
    int alarmIndex = model.index;
    int alarmType = model.type;
    NSString *alarmString;
    if (model.type != 6)
    {
       alarmString  = alarmArray[alarmType -1];
    }else
    {
        alarmString = model.noticeString;
    }
    NSString *timeString = [self getAlarmTimeStringWithData:model.timeArray];
    NSString *repetString = [self getAlarmRepeateStringWithData:model.repeatArray];
    NSString *imageName = [self getAlarmImageWith:alarmType];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         timeString, @"1",
                         repetString, @"2",
                         [NSNumber numberWithInt:alarmIndex], @"3",
                         model.repeatArray, @"4",
                         imageName,@"5",
                         alarmString, @"0",
                         nil];
    BOOL isNeedAdd = YES;
    for (NSDictionary *dic in contentArray) {
        int tempIndex = [[dic objectForKey:@"3"] intValue];
        if (tempIndex == alarmIndex) {
            isNeedAdd = NO;
        }
    }
    if (isNeedAdd) {
        [contentArray addObject:dic];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:contentArray.count-1 inSection:0];
        NSArray *insertIndexPaths = [NSArray arrayWithObjects:indexPath,nil];
        
        [_alarmTableVIew insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationRight];
        exitArray[alarmIndex] = [NSString stringWithFormat:@"%d",alarmIndex];
    }
}


- (NSString *)getAlarmImageWith:(int)alarmType
{
    NSArray *array = [[NSArray alloc]initWithObjects:@"ZDY_运动",@"约会",@"喝水",@"吃药",@"ZDY_睡眠",@"编辑", nil];
    NSString *imageString = array[alarmType-1];
    return imageString;
}


- (NSString *)transToUnicodStringWithString:(NSString *)string
{
    NSMutableString *resultStr = [[NSMutableString alloc]initWithCapacity:0];
    for (int i = 0; i < string.length/4; i++)
    {
        NSMutableString *mutString = [[NSMutableString alloc] initWithCapacity:0];
        NSRange range = NSMakeRange(4*i, 4);
        NSString *cString = [string substringWithRange:range];
        [mutString appendString:[cString substringWithRange:NSMakeRange(2, 2)]];
        [mutString appendString:[cString substringWithRange:NSMakeRange(0, 2)]];
        [resultStr appendString:@"\\u"];
        [resultStr appendString:mutString];
    }
    return resultStr;
}

- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

- (NSString *)getAlarmRepeateStringWithData:(NSArray *)repeatArray {
    NSString *str = @"";
    NSArray *array = @[NSLocalizedString(@"周日", nil),NSLocalizedString(@"周一",nil),NSLocalizedString(@"周二",nil),NSLocalizedString (@"周三", nil),NSLocalizedString(@"周四", nil),NSLocalizedString (@"周五", nil),NSLocalizedString(@"周六",nil),NSLocalizedString(@"仅一次",nil),NSLocalizedString(@"每天",nil),NSLocalizedString (@"工作日", nil),NSLocalizedString (@"周末", nil)];

    NSMutableArray *dayArray = [NSMutableArray array];
    for (int i = 0; i < 7 ; i ++)
    {
        BOOL isSelected = [repeatArray[i] boolValue];
        if ( isSelected == YES )
        {
            [dayArray addObject:array[i]];
        }
    }
    if (dayArray.count == 0)
    {
        str = array[7];
    }
    else if (dayArray.count == 2 && [dayArray containsObject:array[0]] && [dayArray containsObject:array[6]])
    {
        str = array[10];
    }
    else if (dayArray.count == 5 && ![dayArray containsObject:array[0]] && ![dayArray containsObject:array[6]] )
    {
        str = array[9];
    }
    else if (dayArray.count == 7)
    {
        str = array[8];
    }
    else
    {
        NSMutableString *textString = [NSMutableString new];
        for (NSString * string in dayArray)
        {
            [textString appendFormat:@"%@ ",string];
        }
        str = textString;
    }

    return str;
}


- (NSString *)getAlarmTimeStringWithData:(NSArray *)array {
    NSString *str = @"";
    
    for (int i = 0; i < array.count; i ++)
    {
        NSString *tempStr = array[i];
        str = ([str isEqualToString:@""]) ? tempStr :[NSString stringWithFormat:@"%@/%@", str, tempStr];
    }
    
    return str;
}

- (int)combineDataWithAddr:(Byte *)addr andLength:(int)len {
    int result = 0;
    for (int index = 0; index < len; index ++) {
        result = result | ((*(addr + index)) << (8 *index));
    }
    return result;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    cell.cellDic = contentArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (IBAction)zdyAddAction:(UIButton*)button
{
    if (contentArray.count >7)
    {
        UIResponder *responder = [self checkNextResponderIsKindOfViewController:[SMTabbedSplitViewController class]];
        if (responder) {
            SMTabbedSplitViewController *split = (SMTabbedSplitViewController *)responder;
            [self addActityTextInView:split.view text:NSLocalizedString(@"提醒最大为8个", nil) deleyTime:1.5];
        }
        return;
    }
    ZIDingYiViewController *zidingyiVC = [ZIDingYiViewController new];
    zidingyiVC.exitArray = exitArray;
//    [self presentViewController:zidingyiVC animated:YES completion:nil];
    UIResponder *responder = [self checkNextResponderIsKindOfViewController:[SMTabbedSplitViewController class]];
    if (responder) {
        SMTabbedSplitViewController *split = (SMTabbedSplitViewController *)responder;
        [split.navigationController pushViewController:zidingyiVC animated:YES];
    }
}

- (void)alarmUnpairBlueTooth
{
    DeleteAlertViewController *deleteVC = [[DeleteAlertViewController alloc] init];
    [self presentViewController:deleteVC animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        int index = [[contentArray[indexPath.row] objectForKey:@"3"] intValue];
        [[CositeaBlueTooth sharedInstance] deleteAlarmWithAlarmIndex:index];
        
        exitArray[indexPath.row] = @"";
        NSDictionary *dic = contentArray[indexPath.row];
        [contentArray removeObject:dic];
        [tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZIDingYiViewController *zidingyiVC = [ZIDingYiViewController new];
    zidingyiVC.isEdit = YES;
    zidingyiVC.contentDic = contentArray[indexPath.row];
    UIResponder *responder = [self checkNextResponderIsKindOfViewController:[SMTabbedSplitViewController class]];
    if (responder) {
        SMTabbedSplitViewController *split = (SMTabbedSplitViewController *)responder;
        [split.navigationController pushViewController:zidingyiVC animated:YES];
    }
}




@end

////
////  FriendListTableViewCell.m
////  Mistep
////
////  Created by 迈诺科技 on 16/6/1.
////  Copyright © 2016年 huichenghe. All rights reserved.
////
//
//#import "FriendListTableViewCell.h"
//#import "UIImageView+AFNetworking.h"
//
//
//@implementation FriendListTableViewCell
//
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    [self setXibLabels];
//    _headerImageView.layer.cornerRadius = _headerImageView.width/2;
//    _headerImageView.clipsToBounds = YES;
//    // Initialization code
//}
//
//- (void)setXibLabels
//{
//    _kSport.text = NSLocalizedString(@"运动:", nil);
//    _kSleep.text = NSLocalizedString(@"睡眠:", nil);
//    _kPilaoState.text = NSLocalizedString(@"状态:", nil);
//}
//
//- (void)setContentDic:(NSDictionary *)contentDic
//{
//    NSString *nickName = contentDic[@"mark"];
//    int completionTime = [contentDic[@"finishTimes"] intValue];
//    NSString *sleepString = contentDic[@"sleepStatus"];
//    NSString *pilaoString = contentDic[@"indexFatigue"];
//    int pilao;
//    if (((NSNull *)pilaoString != [NSNull null]))
//    {
//        pilao = [contentDic[@"indexFatigue"] intValue];
//    }
//    else
//    {
//        pilao = 100;
//    }
//
//    NSString *sleepStateText;
//    
//    if ((NSNull *)sleepString != [NSNull null]) {
//        if ([sleepString isEqualToString:@"A"])
//        {
//            sleepStateText = NSLocalizedString(@"充裕", nil);
//        }
//        if ([sleepString isEqualToString:@"B"]) {
//            sleepStateText = NSLocalizedString(@"正常", nil);
//        }
//        if ([sleepString isEqualToString:@"C"])
//        {
//            sleepStateText = NSLocalizedString(@"偏少", nil);
//        }
//    }else{
//        sleepStateText = NSLocalizedString(@"充裕", nil);
//    }
//
//    NSString *pilaoText;
//    if (pilao == 0)
//    {
//        pilaoText = NSLocalizedString(@"活力", nil);
//    }else if (pilao <=50)
//    {
//        pilaoText = NSLocalizedString(@"疲劳", nil);
//    }else
//    {
//        pilaoText = NSLocalizedString(@"活力", nil);
//    }
//
//    NSString *timeString = contentDic[@"lastDate"];
//    NSString *timeText;
//    if ((NSNull *)timeString != [NSNull null])
//    {
//        timeText = [timeString substringFromIndex:5];
//    }
//    else {
//        timeText = NSLocalizedString(@"无数据", nil);
//    }
//    
//    NSString *header = contentDic[@"header"];
//    if ((NSNull *)header != [NSNull null])
//    {
//        NSString *url = [NSString stringWithFormat:@"http://bracelet.cositea.com:8089/bracelet/download_userHeader?filename=%@",header];
//        [_headerImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"QG_manHeader"]];
//    }
//    
//    NSString *completiontext = [NSString stringWithFormat:NSLocalizedString(@"%@ %d %@", nil),NSLocalizedString(@"完成", nil),completionTime,NSLocalizedString(@"次", nil)];
//    _nickNameLabel.text = nickName;
//    _completionTimeLabel.text = completiontext;
//    _sleepStateLabel.text = sleepStateText;
//    _tiredStateLabel.text = pilaoText;
//    _dateLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"数据更新时间:", nil),timeText] ;
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
//
//@end

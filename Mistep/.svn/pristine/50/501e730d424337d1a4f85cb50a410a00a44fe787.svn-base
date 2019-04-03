////
////  HuoDongXiangQingCell.m
////  keyBand
////
////  Created by 迈诺科技 on 15/11/2.
////  Copyright © 2015年 huichenghe. All rights reserved.
////
//
//#import "HuoDongXiangQingCell.h"
//#define KONEDAYSECONDS 86400
//
//@implementation HuoDongXiangQingCell
//
////- (void)awakeFromNib {
////    // Initialization code
////}
//
//- (int)getTimeIndexWithSecond:(int)seconds
//{
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"HH"];
//    int hour = [[dateFormatter stringFromDate:date] intValue];
//    [dateFormatter setDateFormat:@"mm"];
//    int min = [[dateFormatter stringFromDate:date]intValue];
//    int timeIndex = hour * 60 + min;
//    return timeIndex;
//}
//
//- (int)getHearRate
//{
//    int begeinSecond = [_contentDic[StartTime_ActualData_HCH] intValue] ;
//    int endSecond = [_contentDic[StopTime_ActualData_HCH] intValue] ;
//
//    int beginIndex = [self getTimeIndexWithSecond:begeinSecond];
//    int endIndex = [self getTimeIndexWithSecond:endSecond];
//    int beginHour = beginIndex / 60;
//    int endHour = endIndex / 60;
//    int beginPackIndex = beginHour / 3 + 1;
//    int endPackIndex = endHour/3 +1;
//    _heartArray = [NSMutableArray array];
//    int dataDate = [_contentDic[DataTime_HCH] intValue];
//    
//    
//    
//    if (endSecond < dataDate + KONEDAYSECONDS)
//    {
//        for (int i = beginPackIndex; i < endPackIndex + 1; i ++)
//        {
//            NSDictionary *heartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds: dataDate + i];
//            NSData *heartData = heartDic[HeartRate_ActualData_HCH];
//            NSArray *array = nil;
//            if (heartData) {
//                @try
//                {
//                    array =[NSKeyedUnarchiver unarchiveTopLevelObjectWithData:heartData error:nil];
//                }
//                @catch (NSException *exception)
//                {
//                 NSLog(@"%s\n%@", __FUNCTION__, exception);
//                }
//                @finally {
//                }
//            }
//            if (array && array.count != 0)
//            {
//                [_heartArray addObjectsFromArray:array];
//            }
//            else
//            {
//                for (int i = 0 ; i < 180; i ++)
//                {
//                    [_heartArray addObject:@0];
//                }
//            }
//        }
//    }
//    else
//    {
//        for (int i = beginPackIndex; i < 9; i ++)
//        {
//            NSDictionary *heartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds: dataDate + i];
//            NSData *heartData = heartDic[HeartRate_ActualData_HCH];
//            NSArray *array = [NSKeyedUnarchiver unarchiveTopLevelObjectWithData:heartData error:nil];
//            if (array && array.count != 0)
//            {
//                [_heartArray addObjectsFromArray:array];
//            }
//            else
//            {
//                for (int i = 0 ; i < 180; i ++)
//                {
//                    [_heartArray addObject:@0];
//                }
//            }
//        }
//        for (int i = 1; i < endPackIndex + 1; i ++)
//        {
//            NSDictionary *heartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds: dataDate + i];
//            NSData *heartData = heartDic[HeartRate_ActualData_HCH];
//            NSArray *array = [NSKeyedUnarchiver unarchiveTopLevelObjectWithData:heartData error:nil];
//            if (array && array.count != 0)
//            {
//                [_heartArray addObjectsFromArray:array];
//            }
//            else
//            {
//                for (int i = 0 ; i < 180; i ++)
//                {
//                    [_heartArray addObject:@0];
//                }
//            }
//        }
//    }
//
//    int activeMin = (endSecond - begeinSecond)/60+1;
//    
//    if (beginIndex%180 + activeMin > _heartArray.count)
//    {
//        activeMin = _heartArray.count - beginIndex%180;
//    }
//
//    int totalHeartRate = 0;
//    int heartCount = 0;
//
//    for (int i = beginIndex%180; i < beginIndex%180 + activeMin; i ++)
//    {
//        int heartRate = [_heartArray[i] intValue];
//        totalHeartRate += heartRate;
//        if (heartRate != 0)
//        {
//            heartCount ++;
//        }
//    }
//    
//    int aveHeart = 0;
//    if (heartCount > 0)
//    {
//         aveHeart = totalHeartRate/heartCount;
//    }
//    return aveHeart;
//}
//
//- (void)setContentDic:(NSDictionary *)contentDic
//{
//    if (_contentDic != contentDic)
//    {
//        _contentDic = [[NSMutableDictionary alloc] initWithDictionary:contentDic];;
//        
//        int heartRate = [self getHearRate];
//        NSArray *imageArray = [[NSArray alloc]initWithObjects:
//                               @"jingxi",NSLocalizedString(@"静息", nil),
//                               @"tubu",NSLocalizedString(@"徒步", nil),
//                               @"paopu",NSLocalizedString(@"跑步",nil),
//                               @"pashan",NSLocalizedString(@"爬山",nil),
//                               @"qiulei",NSLocalizedString(@"球类运动", nil),
//                               @"juzhong",NSLocalizedString(@"力量训练",nil),
//                               @"youyang",NSLocalizedString(@"有氧训练",nil),
//                               @"JR_zidingyi",contentDic[SportString_ActualData_HCH],
//                               nil];;
//        int type = [[_contentDic objectForKey:SportType_ActualData_HCH] intValue];
//        if (type == -1)
//        {
//            if ([HCHCommonManager getInstance].LanuguageIndex_SRK == ChinesLanguage_Enum)
//            {
//                _centenImageView.image = [UIImage imageNamed:@"weizhi"];
//            }
//            else
//            {
//                _centenImageView.image = [UIImage imageNamed:@"weizhi_en"];
//            }
//        }
//        else
//        {
//            _centenImageView.image = [UIImage imageNamed:imageArray[[_contentDic[SportType_ActualData_HCH] intValue]*2]];
//        }
//        int cost = [[self.contentDic objectForKey:CostCount_ActualData_HCH] intValue];
//        NSString *costText = [NSString stringWithFormat:NSLocalizedString(@"%d 千卡", nil),cost];
//        _costLabel.text = costText;
//        int steps = [[self.contentDic objectForKey:StepCount_ActualData_HCH] intValue];
//        NSString *stepString = [NSString stringWithFormat:NSLocalizedString(@"%d 步", nil),steps];
//        _stepLabel.text = stepString;
//        NSString *startTime = [self getTimeStrWith:_contentDic andTimeKey:StartTime_ActualData_HCH];
//        NSString *stopTime = [self getTimeStrWith:_contentDic andTimeKey:StopTime_ActualData_HCH];
//        _timeLabel.text = [NSString stringWithFormat:@"%@-%@",startTime,stopTime];
//        _heartRateLabel.text = [NSString stringWithFormat:@"%d bpm",heartRate];
//    }
//}
//
//
//- (NSString *)getTimeStrWith:(NSDictionary *)dic andTimeKey:(NSString *)key {
//    int seconds = [[dic objectForKey:key] intValue];
//    NSString *timeStr = [[TimeCallManager getInstance]getTimeStringWithSeconds:seconds andFormat:@"HH:mm"];
//    return timeStr;
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
//
//@end

//
//  AlarmTableViewCell.h
//  keyBand
//
//  Created by 迈诺科技 on 15/11/25.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmTableViewCell : UITableViewCell

@property (copy, nonatomic) NSDictionary *cellDic;

@property (weak, nonatomic) IBOutlet UIImageView *typeImageVIew;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *weekLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *stringLabel;

@end

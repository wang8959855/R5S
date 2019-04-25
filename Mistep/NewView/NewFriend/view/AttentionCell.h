//
//  AttentionCell.h
//  Bracelet
//
//  Created by apple on 2018/10/25.
//  Copyright © 2018 com.czjk.www. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AttentionCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *dic;

@property (weak, nonatomic) IBOutlet UIButton *guanbiButton;

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *wxImage;

@end

NS_ASSUME_NONNULL_END

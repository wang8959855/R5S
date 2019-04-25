//
//  SportMapTableViewCell.m
//  Mistep
//
//  Created by 迈诺科技 on 2017/1/19.
//  Copyright © 2017年 huichenghe. All rights reserved.
//

#define deviceWidth [UIScreen mainScreen].bounds.size.width
#define deviceHeight [UIScreen mainScreen].bounds.size.height
#define numberFont  [UIFont systemFontOfSize:15]
#define markFont  [UIFont systemFontOfSize:9]
#define fontColorSet [UIColor whiteColor]
#define headImageViewWidth  40*WidthProportion
//#define space  10
#define spaceViewSpace  20*HeightProportion
#define spaceViewWidth   1
#define LabelHeight  20
#define calculateHeart 220


#import "SportMapTableViewCell.h"
#import "ColorTool.h"

@interface SportMapTableViewCell()<UIScrollViewDelegate>
{
    UIButton *selectButton;
}
@property (nonatomic,strong) UIScrollView *scrollView;
@end

@implementation SportMapTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    
    static NSString *cellID = @"sportTableViewCell";
    SportMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SportMapTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) { // 初始化子控件
        [self  setupControl];
        //        [self addTap];
    }
    return self;
}
-(void)addTap
{
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.contentView addGestureRecognizer:rightSwipeGestureRecognizer];
    
}
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    [_scrollView setContentOffset:CGPointMake(self.contentView.width/3, 0) animated:YES];
}
-(void)setupControl
{
    UIImageView *headImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:headImageView];
    _headImageView = headImageView;
    headImageView.image = [UIImage imageNamed:@"paobuyuan"];
    headImageView.clipsToBounds = YES;
    //    headImageView.backgroundColor = [UIColor orangeColor];
    
    CGFloat headImageViewX = 15*WidthProportion;
    CGFloat headImageViewY = 0;
    CGFloat headImageViewW = headImageViewWidth;
    CGFloat headImageViewH = headImageViewW;
    headImageView.frame = CGRectMake(headImageViewX, headImageViewY, headImageViewW, headImageViewH);
    headImageView.layer.cornerRadius = headImageViewW * 0.5;
    
    //左边连接的灰色的线条
    UILabel *verticalView = [[UILabel alloc]init];
//    [self.contentView addSubview:verticalView];
    verticalView.backgroundColor = [UIColor grayColor];
    
    CGFloat verticalViewX = CGRectGetMinX(headImageView.frame) + headImageViewW * 0.5;
    CGFloat verticalViewY = CGRectGetMaxY(headImageView.frame);
    CGFloat verticalViewW = 1;
    CGFloat verticalViewH = 118*HeightProportion - verticalViewY;
    verticalView.frame = CGRectMake(verticalViewX, verticalViewY, verticalViewW, verticalViewH);
    
    
    
    UILabel *timeLabel = [[UILabel alloc]init];
    [self.contentView addSubview:timeLabel];
    _timeLabel = timeLabel;
    timeLabel.text =@"16:00- 19:45";
    CGFloat timeLabelX = CGRectGetMaxX(headImageView.frame) + 10;
    CGFloat timeLabelY = headImageViewY;
    CGFloat timeLabelW = 150;
    CGFloat timeLabelH = headImageViewH;
    timeLabel.frame = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    timeLabel.textColor = kMainColor;
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    [self.contentView addSubview:scrollView];
    //    scrollView.userInteractionEnabled = NO;
    _scrollView = scrollView;
    //    [self.contentView addGestureRecognizer:self.scrollView.panGestureRecognizer];
    
    CGFloat scrollViewX = CGRectGetMinX(headImageView.frame) + headImageView.frame.size.width * 0.5 + 2;
    CGFloat scrollViewY = CGRectGetMaxY(headImageView.frame);
    CGFloat scrollViewW = deviceWidth-16*WidthProportion- 15*WidthProportion - scrollViewX;
    CGFloat scrollViewH = 80*HeightProportion;
    scrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH);
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(scrollViewW / 3 * 4, scrollViewH);
    scrollView.layer.cornerRadius = 20*WidthProportion;
    scrollView.backgroundColor = kMainColor;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    
    //详细的scrollView内容   第一个界面  -- steps
    UIImageView *iconView = [[UIImageView alloc]init];
    [scrollView addSubview:iconView];
    _iconView = iconView;
    iconView.image = [UIImage imageNamed:@"xiaobushu"];
    //    iconView.backgroundColor = [UIColor orangeColor];
    
    CGFloat iconViewW = 30*WidthProportion;
    CGFloat iconViewH = iconViewW;
    CGFloat iconViewX = 10;
    CGFloat iconViewY = scrollViewH/2-15;
    iconView.frame = CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH);
    
    
    UILabel *stepsNumberLabel = [[UILabel alloc]init];
    [scrollView addSubview:stepsNumberLabel];
    _stepsNumberLabel = stepsNumberLabel;
    stepsNumberLabel.backgroundColor = [UIColor clearColor];
    stepsNumberLabel.text = @"0";
    stepsNumberLabel.textColor = fontColorSet;
    stepsNumberLabel.font = numberFont;
    
    CGFloat stepsNumberLabelX = iconView.right+5;
    CGFloat stepsNumberLabelW = scrollViewW / 3 - 15 - iconView.width;
    CGFloat stepsNumberLabelH = 20*HeightProportion;
    CGFloat stepsNumberLabelY = iconViewY-5;
    stepsNumberLabel.frame = CGRectMake(stepsNumberLabelX, stepsNumberLabelY, stepsNumberLabelW, stepsNumberLabelH);
    
    UILabel *stepsMarkLabel = [[UILabel alloc] init];
    stepsMarkLabel.backgroundColor = [UIColor clearColor];
    stepsMarkLabel.frame = CGRectMake(stepsNumberLabelX, stepsNumberLabel.bottom, stepsNumberLabelW, stepsNumberLabelH);
    stepsMarkLabel.text = @"步数";
    stepsMarkLabel.textColor = fontColorSet;
    stepsMarkLabel.font = [UIFont systemFontOfSize:11];
    [scrollView addSubview:stepsMarkLabel];
    
    
    //中间的分割线
    UIView * spaceView = [[UIView alloc]init];
    [scrollView addSubview:spaceView];
    spaceView.backgroundColor = allColorWhite;
    
    CGFloat spaceViewX = scrollViewW / 3;
    CGFloat spaceViewY = spaceViewSpace;
    CGFloat spaceViewW = spaceViewWidth;
    CGFloat spaceViewH = scrollViewH - spaceViewSpace * 2;
    spaceView.frame = CGRectMake(spaceViewX, spaceViewY, spaceViewW, spaceViewH);
    
    //中间的分割线
    UIView * spaceViewSeconed = [[UIView alloc]init];
    [scrollView addSubview:spaceViewSeconed];
    spaceViewSeconed.backgroundColor = allColorWhite;
    
    CGFloat spaceViewSeconedX = spaceViewX * 2;
    CGFloat spaceViewSeconedY = spaceViewY;
    CGFloat spaceViewSeconedW = spaceViewW;
    CGFloat spaceViewSeconedH = spaceViewH;
    spaceViewSeconed.frame = CGRectMake(spaceViewSeconedX, spaceViewSeconedY, spaceViewSeconedW, spaceViewSeconedH);
    
    
    
    
    //第二个detai界面  --- kcal
    
    UIImageView *kcalIconView = [[UIImageView alloc]init];
    [scrollView addSubview:kcalIconView];
    kcalIconView.image = [UIImage imageNamed:@"CalorieWhite"];
    
    
    CGFloat kcalIconViewW = iconViewW;
    CGFloat kcalIconViewH = kcalIconViewW;
    CGFloat kcalIconViewX = scrollViewW/3 + 10;
    CGFloat kcalIconViewY = scrollViewH/2-15;
    kcalIconView.frame = CGRectMake(kcalIconViewX, kcalIconViewY, kcalIconViewW, kcalIconViewH);
    
    UILabel *kcalNumberLabel = [[UILabel alloc]init];
    [scrollView addSubview:kcalNumberLabel];
    _kcalNumberLabel = kcalNumberLabel;
    kcalNumberLabel.backgroundColor = [UIColor clearColor];
    kcalNumberLabel.text = @"0";
    kcalNumberLabel.textColor = fontColorSet;
    kcalNumberLabel.font = numberFont;
    
    CGFloat kcalNumberLabelX = kcalIconView.right+5;
    CGFloat kcalNumberLabelW = scrollViewW / 3 - 15 - kcalIconView.width;
    CGFloat kcalNumberLabelH = LabelHeight;
    CGFloat kcalNumberLabelY = kcalIconViewY-5;
    kcalNumberLabel.frame = CGRectMake(kcalNumberLabelX, kcalNumberLabelY, kcalNumberLabelW, kcalNumberLabelH);
    
    UILabel *kcalMarkLabel = [[UILabel alloc] init];
    kcalMarkLabel.backgroundColor = [UIColor clearColor];
    kcalMarkLabel.frame = CGRectMake(kcalNumberLabelX, kcalNumberLabel.bottom, kcalNumberLabelW, kcalNumberLabelH);
    kcalMarkLabel.text = @"卡路里";
    kcalMarkLabel.textColor = fontColorSet;
    kcalMarkLabel.font = [UIFont systemFontOfSize:11];
    [scrollView addSubview:kcalMarkLabel];
    
    //    UILabel *kcalMarkLabel = [[UILabel alloc]init];
    //    [scrollView addSubview:kcalMarkLabel];
    //    kcalMarkLabel.text = @"kcal";
    //    kcalMarkLabel.textColor = fontColorSet;
    //    kcalMarkLabel.font = markFont;
    //    kcalMarkLabel.textAlignment = NSTextAlignmentCenter;
    //
    //    CGFloat kcalMarkLabelW = kcalNumberLabelW;
    //    CGFloat kcalMarkLabelH = kcalNumberLabelH;
    //    CGFloat kcalMarkLabelX = kcalNumberLabelX;
    //    CGFloat kcalMarkLabelY = CGRectGetMaxY(stepsNumberLabel.frame);
    //    kcalMarkLabel.frame = CGRectMake(kcalMarkLabelX, kcalMarkLabelY, kcalMarkLabelW, kcalMarkLabelH);
    
    
    //第三个detai界面   ---  bpm
    
    UIImageView *bpmIconView = [[UIImageView alloc]init];
    [scrollView addSubview:bpmIconView];
    bpmIconView.image = [UIImage imageNamed:@"HeartRateWhite"];
    
    CGFloat bpmIconViewW = iconViewW;
    CGFloat bpmIconViewH = bpmIconViewW;
    CGFloat bpmIconViewX = kcalIconViewX + scrollViewW/3;
    CGFloat bpmIconViewY = kcalIconViewY;
    bpmIconView.frame = CGRectMake(bpmIconViewX, bpmIconViewY, bpmIconViewW, bpmIconViewH);
    
    
    UILabel *bpmNumberLabel = [[UILabel alloc]init];
    [scrollView addSubview:bpmNumberLabel];
    _bpmNumberLabel = bpmNumberLabel;
    
    bpmNumberLabel.backgroundColor = [UIColor clearColor];
    bpmNumberLabel.text = @"0";
    bpmNumberLabel.textColor = fontColorSet;
    bpmNumberLabel.font = numberFont;
    
    
    CGFloat bpmNumberLabelX = bpmIconView.right+5;
    CGFloat bpmNumberLabelW = scrollViewW / 3 - 15 - bpmIconView.width;
    CGFloat bpmNumberLabelH = LabelHeight;
    CGFloat bpmNumberLabelY = kcalNumberLabelY;
    bpmNumberLabel.frame = CGRectMake(bpmNumberLabelX, bpmNumberLabelY, bpmNumberLabelW, bpmNumberLabelH);
    
    UILabel *bpmUnitLabel = [[UILabel alloc] init];
    bpmUnitLabel.backgroundColor = [UIColor clearColor];
    bpmUnitLabel.frame = CGRectMake(bpmNumberLabelX, bpmNumberLabel.bottom, bpmNumberLabelW, bpmNumberLabelH);
    bpmUnitLabel.text = @"心率";
    bpmUnitLabel.textColor = fontColorSet;
    bpmUnitLabel.font = [UIFont systemFontOfSize:11];
    [scrollView addSubview:bpmUnitLabel];
    
    //    UILabel *bpmMarkLabel = [[UILabel alloc]init];
    //    [scrollView addSubview:bpmMarkLabel];
    //    bpmMarkLabel.text = @"bpm";
    //    bpmMarkLabel.textColor = fontColorSet;
    //    bpmMarkLabel.font = markFont;
    //    bpmMarkLabel.textAlignment = NSTextAlignmentCenter;
    //
    //    CGFloat bpmMarkLabelW = bpmNumberLabelW;
    //    CGFloat bpmMarkLabelH = bpmNumberLabelH;
    //    CGFloat bpmMarkLabelX = bpmNumberLabelX;
    //    CGFloat bpmMarkLabelY = CGRectGetMaxY(bpmNumberLabel.frame);
    //    bpmMarkLabel.frame = CGRectMake(bpmMarkLabelX, bpmMarkLabelY, bpmMarkLabelW, bpmMarkLabelH);
    
    
    UIButton *deleteButton = [[UIButton alloc]init];
    [scrollView addSubview:deleteButton];
    [deleteButton setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteButton.backgroundColor = [ColorTool getColor:@"f8396b"];
    [deleteButton addTarget:self action:@selector(deleteSport:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat deleteButtonX = scrollViewW;
    CGFloat deleteButtonY = 0;
    CGFloat deleteButtonW = scrollViewW / 3;
    CGFloat deleteButtonH = scrollViewH;
    deleteButton.frame =  CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
    
    
    selectButton = [[UIButton alloc]init];
    [scrollView addSubview:selectButton];
    //    [selectButton setTitle:@"删除" forState:UIControlStateNormal];
    //    [selectButton setTitleColor:allColorRed forState:UIControlStateNormal];
    //    selectButton.alpha = 0.3;
    selectButton.backgroundColor = [UIColor clearColor];
    [selectButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat selectButtonX = 0;
    CGFloat selectButtonY = 0;
    CGFloat selectButtonW = scrollViewW;
    CGFloat selectButtonH = scrollViewH;
    selectButton.frame =  CGRectMake(selectButtonX, selectButtonY, selectButtonW, selectButtonH);
    
    
    //    //adaLog(@"height == %f",CGRectGetMaxY(scrollView.frame));
}
-(void)selectButton:(UIButton *)sender
{
    int aa = (int)sender.tag;
    self.backBlock(aa);
}
-(void)deleteSport:(UIButton *)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(deleteSportWithID:)]) {
        [_delegate deleteSportWithID:self.sportID];
    }
    //    -(void)deleteSportWithID:(NSString *)sportID;
    //    //adaLog(@"点击删除");
    //    [_delegate respondsToSelector:@selector(blueToothManagerReceiveHeartRateNotify:)]
}
-(void)setSport:(SportModelMap *)sport
{
    _sport = sport;
    //如果是假数据是不能滑动的
    if (sport.falseData)
    {
        _scrollView.contentSize = CGSizeMake(0,0);
    }
    else
    {
        _scrollView.contentSize = CGSizeMake(_scrollView.width / 3 * 4,0);
    }
    
    self.sportID = sport.sportID;
    self.headViewString =  sport.sportType;
    NSInteger loc = 11;
    NSInteger len = 5;
    self.timeString = [NSString stringWithFormat:@"%@- %@",[sport.fromTime substringWithRange:NSMakeRange(loc, len)],[sport.toTime substringWithRange:NSMakeRange(loc, len)]];
    //    self.stepString = sport.stepNumber;
    self.kcalString = sport.kcalNumber;
    NSString *bpm = [AllTool  getMean:sport.heartRateArray];
    //adaLog(@"bpm - %@",bpm);
    self.bpmString = bpm;
    int ishaveTrail=0;
    //adaLog(@"sport.haveTrail - %@",sport.haveTrail);
    if((NSNull *)sport.haveTrail != [NSNull null])
    {
        ishaveTrail = [sport.haveTrail intValue];
    }
    //adaLog(@"sport.haveTrail - %@",sport.haveTrail);
    if(ishaveTrail!=1)
    {
        
        [self sportStrength];
        //     self.stepString =
    }
    else
    {
//        _iconView.image = [UIImage imageNamed:@"Shape_copy_map"];
    }
}
-(void)sportStrength
{
    /**
     *心率区间
     */
    NSInteger maxHeart,maxHeartOno,maxHeartTwo,maxHeartThree,maxHeartFour;
    maxHeart = calculateHeart - [[HCHCommonManager getInstance]getAge];
    
    maxHeartOno = maxHeart * 90 /100;
    maxHeartTwo = maxHeart * 80 /100;
    maxHeartThree = maxHeart * 70 /100;
    maxHeartFour = maxHeart * 60 /100;
    
    NSInteger heartNum = 0;
    NSInteger limit = 0;   //时长  number
    NSInteger anaerobic = 0;
    NSInteger aerobic = 0;
    NSInteger fatBurning = 0;
    NSInteger warmUp = 0;
    for (NSString *heart in  _sport.heartRateArray)
    {
        heartNum = [heart integerValue];
        if(heartNum > maxHeartOno)
        {
            ++limit;
        }
        else if (heartNum > maxHeartTwo)
        {
            ++anaerobic;
        }
        else if (heartNum > maxHeartThree)
        {
            ++aerobic;
        }
        else if (heartNum > maxHeartFour)
        {
            ++fatBurning;
        }
        else
        {
            ++warmUp;
        }
    }
    
    if (limit>0)
    {
//        _iconView.image = [UIImage imageNamed:@"Limit_map"];
//        _stepsNumberLabel.text = NSLocalizedString(@"极限", nil);
    }
    else if (anaerobic>0)
    {
//        _iconView.image = [UIImage imageNamed:@"No_oxygen_map"];
//        _stepsNumberLabel.text = NSLocalizedString(@"无氧",nil);
    }
    else if (aerobic>0)
    {
//        _iconView.image = [UIImage imageNamed:@"map_youyang"];
//        _stepsNumberLabel.text = NSLocalizedString(@"有氧",nil);
    }
    else if (fatBurning>0)
    {
//        _iconView.image = [UIImage imageNamed:@"FatBurning_map"];
//        _stepsNumberLabel.text = NSLocalizedString(@"燃脂",nil);
    }
    else
    {
//        _iconView.image = [UIImage imageNamed:@"map_warmup"];
//        _stepsNumberLabel.text = NSLocalizedString(@"热身",nil);
    }
    
}
//-(void)refreshUI:(SportModel * )sport;
//{
//    self.sportID = sport.sportID;
//    self.headViewString =  sport.sportType;
//    self.timeString = [NSString stringWithFormat:@"%@- %@",[sport.fromTime substringToIndex:5],[sport.toTime substringToIndex:5]];
////    self.stepString = sport.stepNumber;
//    self.kcalString = sport.kcalNumber;
//    self.bpmString = sport.heartRate;
//}

-(void)setBpmString:(NSString *)bpmString
{
    _bpmString = bpmString;
    self.bpmNumberLabel.text = [NSString stringWithFormat:@"%@",bpmString];
}
-(void)setKcalString:(NSString *)kcalString
{
    _kcalString = kcalString;
    self.kcalNumberLabel.text = kcalString;
}
-(void)setStepString:(NSString *)stepString
{
    _stepString = stepString;
    self.stepsNumberLabel.text = stepString;
}
-(void)setTimeString:(NSString *)timeString
{
    _timeString = timeString;
    self.timeLabel.text = timeString;
}
-(void)setHeadViewString:(NSString *)headViewString
{
    _headViewString  = headViewString;
    NSInteger type = [headViewString integerValue];
    //    NSInteger type;
    if (type > 99)
    {
        type  = type - 99;
    }
    switch (type) {
        case 1:
            self.headImageView.image = [UIImage imageNamed:@"paobuyuan"];
            break;
        case 2:
            self.headImageView.image = [UIImage imageNamed:@"paobuyuan"];
            break;
        case 3:
            self.headImageView.image = [UIImage imageNamed:@"dengshanyuan"];
            break;
        case 4:
            self.headImageView.image = [UIImage imageNamed:@"BallClassSport"];
            break;
        case 5:
            self.headImageView.image = [UIImage imageNamed:@"Strength_Training"];
            
            break;
        case 6:
            self.headImageView.image = [UIImage imageNamed:@"AerobicTraining_map"];
            break;
        case 7:
            self.headImageView.image = [UIImage imageNamed:@"customize"];
            break;
        default:
            self.headImageView.image = [UIImage imageNamed:@"weizhi"];
            break;
    }
}

-(void)setArrayIndex:(NSInteger)arrayIndex
{
    _arrayIndex = arrayIndex;
    selectButton.tag = (NSInteger)arrayIndex;
}
- (void)awakeFromNib { [super awakeFromNib];   // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {  [super setSelected:selected animated:animated]; }


@end

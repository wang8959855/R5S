////
////  SportTableViewCell.m
////  company
////
////  Created by 蒋宝 on 16/10/22.
////  Copyright © 2016年 Smartbi. All rights reserved.
////
//#define deviceWidth [UIScreen mainScreen].bounds.size.width
//#define deviceHeight [UIScreen mainScreen].bounds.size.height
//#define numberFont  [UIFont systemFontOfSize:15]
//#define markFont  [UIFont systemFontOfSize:9]
//#define fontColorSet [UIColor whiteColor]
//#define headImageViewWidth  40
//#define space  10
//#define spaceViewSpace  20
//#define spaceViewWidth   1
//#define LabelHeight  20
//#import "SportTableViewCell.h"
//
//@interface SportTableViewCell()<UIScrollViewDelegate>
//{
//    UIButton *selectButton;
//}
//@property (nonatomic,strong) UIScrollView *scrollView;
//@end
//@implementation SportTableViewCell
//
//+ (instancetype)cellWithTableView:(UITableView *)tableView
//{
//    
//    
//    static NSString *cellID = @"sportTableViewCell";
//    SportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell) {
//        cell = [[SportTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    return cell;
//}
//
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) { // 初始化子控件
//        [self  setupControl];
////        [self addTap];
//    }
//    return self;
//}
//-(void)addTap
//{
//    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
//    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//    
//    [self.contentView addGestureRecognizer:rightSwipeGestureRecognizer];
//    
//}
//- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
//{
//    [_scrollView setContentOffset:CGPointMake(self.contentView.width/3, 0) animated:YES];
//}
//-(void)setupControl
//{
//    UIImageView *headImageView = [[UIImageView alloc]init];
//    [self.contentView addSubview:headImageView];
//    _headImageView = headImageView;
//    headImageView.image = [UIImage imageNamed:@"buxing"];
//    headImageView.clipsToBounds = YES;
////    headImageView.backgroundColor = [UIColor orangeColor];
//    
//    CGFloat headImageViewX = 15;
//    CGFloat headImageViewY = 10;
//    CGFloat headImageViewW = headImageViewWidth;
//    CGFloat headImageViewH = headImageViewW;
//    headImageView.frame = CGRectMake(headImageViewX, headImageViewY, headImageViewW, headImageViewH);
//    headImageView.layer.cornerRadius = headImageViewW * 0.5;
//    
//    //左边连接的灰色的线条
//    UILabel *verticalView = [[UILabel alloc]init];
//    [self.contentView addSubview:verticalView];
//    verticalView.backgroundColor = [UIColor grayColor];
//    
//    CGFloat verticalViewX = CGRectGetMinX(headImageView.frame) + headImageViewW * 0.5;
//    CGFloat verticalViewY = CGRectGetMaxY(headImageView.frame);
//    CGFloat verticalViewW = 1;
//    CGFloat verticalViewH = 138 - verticalViewY;
//    verticalView.frame = CGRectMake(verticalViewX, verticalViewY, verticalViewW, verticalViewH);
//
//    
//    
//    UILabel *timeLabel = [[UILabel alloc]init];
//    [self.contentView addSubview:timeLabel];
//    _timeLabel = timeLabel;
//    timeLabel.text =@"16:00- 19:45";
//    CGFloat timeLabelX = CGRectGetMaxX(headImageView.frame) + 10;
//    CGFloat timeLabelY = headImageViewY;
//    CGFloat timeLabelW = 150;
//    CGFloat timeLabelH = headImageViewH;
//    timeLabel.frame = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
//    
//    UIScrollView *scrollView = [[UIScrollView alloc]init];
//    [self.contentView addSubview:scrollView];
////    scrollView.userInteractionEnabled = NO;
//    _scrollView = scrollView;
////    [self.contentView addGestureRecognizer:self.scrollView.panGestureRecognizer];
//    
//    CGFloat scrollViewX = CGRectGetMinX(headImageView.frame) + headImageView.frame.size.width * 0.5 + 2;
//    CGFloat scrollViewY = CGRectGetMaxY(headImageView.frame);
//    CGFloat scrollViewW = deviceWidth - 15 - scrollViewX;
//    CGFloat scrollViewH = 88  ;
//    scrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH);
//    scrollView.delegate = self;
//    scrollView.contentSize = CGSizeMake(scrollViewW / 3 * 4, scrollViewH);
//    scrollView.layer.cornerRadius = scrollViewH * 0.5;
//    scrollView.backgroundColor =  kColor(194,208, 254); //[UIColor orangeColor];
//    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.showsVerticalScrollIndicator = NO;
//    scrollView.pagingEnabled = YES;
//    
//    
//    
//    //详细的scrollView内容   第一个界面  -- steps
//    
//    UILabel *stepsNumberLabel = [[UILabel alloc]init];
//    [scrollView addSubview:stepsNumberLabel];
//    _stepsNumberLabel = stepsNumberLabel;
//    stepsNumberLabel.backgroundColor = [UIColor clearColor];
//    stepsNumberLabel.text = @"11620";
//    stepsNumberLabel.textColor = fontColorSet;
//    stepsNumberLabel.font = numberFont;
//    stepsNumberLabel.textAlignment = NSTextAlignmentCenter;
//    
//    CGFloat stepsNumberLabelX = scrollViewW / 3 /2 ;
//    CGFloat stepsNumberLabelW = stepsNumberLabelX ;
//    CGFloat stepsNumberLabelH = LabelHeight;
//    CGFloat stepsNumberLabelY = (scrollViewH - 2 * stepsNumberLabelH) * 0.5;
//    stepsNumberLabel.frame = CGRectMake(stepsNumberLabelX, stepsNumberLabelY, stepsNumberLabelW, stepsNumberLabelH);
//    
//    
//    UIImageView *iconView = [[UIImageView alloc]init];
//    [scrollView addSubview:iconView];
//    iconView.image = [UIImage imageNamed:@"步数白色"];
////    iconView.backgroundColor = [UIColor orangeColor];
//    
//    CGFloat iconViewW = 30;
//    CGFloat iconViewH = iconViewW;
//    CGFloat iconViewX = CGRectGetMinX(stepsNumberLabel.frame) - iconViewW;
//    CGFloat iconViewY = (scrollViewH - iconViewH) * 0.5;
//    iconView.frame = CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH);
//    
//    
//    
//    
//    UILabel *markLabel = [[UILabel alloc]init];
//    [scrollView addSubview:markLabel];
//    markLabel.text = @"step";
//    markLabel.textColor = fontColorSet;
//    markLabel.font = markFont;
//    markLabel.textAlignment = NSTextAlignmentCenter;
//    
//    CGFloat markLabelW = stepsNumberLabelW;
//    CGFloat markLabelH = stepsNumberLabelH;
//    CGFloat markLabelX = stepsNumberLabelX;
//    CGFloat markLabelY = CGRectGetMaxY(stepsNumberLabel.frame);
//    markLabel.frame = CGRectMake(markLabelX, markLabelY, markLabelW, markLabelH);
//    
//    
//    //中间的分割线
//    UIView * spaceView = [[UIView alloc]init];
//    [scrollView addSubview:spaceView];
//    spaceView.backgroundColor = [UIColor grayColor];
//    
//    CGFloat spaceViewX = scrollViewW / 3;
//    CGFloat spaceViewY = spaceViewSpace;
//    CGFloat spaceViewW = spaceViewWidth;
//    CGFloat spaceViewH = scrollViewH - spaceViewSpace * 2;
//    spaceView.frame = CGRectMake(spaceViewX, spaceViewY, spaceViewW, spaceViewH);
//    
//    //中间的分割线
//    UIView * spaceViewSeconed = [[UIView alloc]init];
//    [scrollView addSubview:spaceViewSeconed];
//    spaceViewSeconed.backgroundColor = [UIColor grayColor];
//    
//    CGFloat spaceViewSeconedX = spaceViewX * 2;
//    CGFloat spaceViewSeconedY = spaceViewY;
//    CGFloat spaceViewSeconedW = spaceViewW;
//    CGFloat spaceViewSeconedH = spaceViewH;
//    spaceViewSeconed.frame = CGRectMake(spaceViewSeconedX, spaceViewSeconedY, spaceViewSeconedW, spaceViewSeconedH);
//    
//    
//    
//    
//    //第二个detai界面  --- kcal
//    
//    UILabel *kcalNumberLabel = [[UILabel alloc]init];
//    [scrollView addSubview:kcalNumberLabel];
//    _kcalNumberLabel = kcalNumberLabel;
//    kcalNumberLabel.backgroundColor = [UIColor clearColor];
//    kcalNumberLabel.text = @"620";
//    kcalNumberLabel.textColor = fontColorSet;
//    kcalNumberLabel.font = numberFont;
//    kcalNumberLabel.textAlignment = NSTextAlignmentCenter;
//    
//    CGFloat kcalNumberLabelX = scrollViewW / 2 ;
//    CGFloat kcalNumberLabelW = kcalNumberLabelX / 3;
//    CGFloat kcalNumberLabelH = LabelHeight;
//    CGFloat kcalNumberLabelY = (scrollViewH - 2 * kcalNumberLabelH) * 0.5;
//    kcalNumberLabel.frame = CGRectMake(kcalNumberLabelX, kcalNumberLabelY, kcalNumberLabelW, kcalNumberLabelH);
//    
//    
//    UIImageView *kcalIconView = [[UIImageView alloc]init];
//    [scrollView addSubview:kcalIconView];
//    kcalIconView.image = [UIImage imageNamed:@"卡路里白色"];
//    
//    
//    CGFloat kcalIconViewW = iconViewW;
//    CGFloat kcalIconViewH = kcalIconViewW;
//    CGFloat kcalIconViewX = CGRectGetMinX(kcalNumberLabel.frame) - kcalIconViewW;
//    CGFloat kcalIconViewY = (scrollViewH - kcalIconViewH) * 0.5;
//    kcalIconView.frame = CGRectMake(kcalIconViewX, kcalIconViewY, kcalIconViewW, kcalIconViewH);
//    
//    
//    
//    
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
//    
//    
//    //第三个detai界面   ---  bpm
//    
//    UILabel *bpmNumberLabel = [[UILabel alloc]init];
//    [scrollView addSubview:bpmNumberLabel];
//    _bpmNumberLabel = bpmNumberLabel;
//    
//    bpmNumberLabel.backgroundColor = [UIColor clearColor];
//    bpmNumberLabel.text = @"120";
//    bpmNumberLabel.textColor = fontColorSet;
//    bpmNumberLabel.font = numberFont;
//    bpmNumberLabel.textAlignment = NSTextAlignmentCenter;
//
//    
//    CGFloat bpmNumberLabelX = scrollViewW / 6 * 5 ;
//    CGFloat bpmNumberLabelW = scrollViewW / 6;
//    CGFloat bpmNumberLabelH = LabelHeight;
//    CGFloat bpmNumberLabelY = (scrollViewH - 2 * bpmNumberLabelH) * 0.5;
//    bpmNumberLabel.frame = CGRectMake(bpmNumberLabelX, bpmNumberLabelY, bpmNumberLabelW, bpmNumberLabelH);
//    
//    
//    UIImageView *bpmIconView = [[UIImageView alloc]init];
//    [scrollView addSubview:bpmIconView];
//    bpmIconView.image = [UIImage imageNamed:@"心率白色"];
//    
//    
//    CGFloat bpmIconViewW = iconViewW;
//    CGFloat bpmIconViewH = bpmIconViewW;
//    CGFloat bpmIconViewX = CGRectGetMinX(bpmNumberLabel.frame) - bpmIconViewW;
//    CGFloat bpmIconViewY = (scrollViewH - bpmIconViewH) * 0.5;
//    bpmIconView.frame = CGRectMake(bpmIconViewX, bpmIconViewY, bpmIconViewW, bpmIconViewH);
//    
//    
//    
//    
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
//    
//    
//    UIButton *deleteButton = [[UIButton alloc]init];
//    [scrollView addSubview:deleteButton];
//    [deleteButton setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
//    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    deleteButton.backgroundColor = [UIColor redColor];
//    [deleteButton addTarget:self action:@selector(deleteSport:) forControlEvents:UIControlEventTouchUpInside];
//    CGFloat deleteButtonX = scrollViewW;
//    CGFloat deleteButtonY = 0;
//    CGFloat deleteButtonW = scrollViewW / 3;
//    CGFloat deleteButtonH = scrollViewH;
//    deleteButton.frame =  CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
//    
//    
//    selectButton = [[UIButton alloc]init];
//    [scrollView addSubview:selectButton];
////    [selectButton setTitle:@"删除" forState:UIControlStateNormal];
////    [selectButton setTitleColor:allColorRed forState:UIControlStateNormal];
////    selectButton.alpha = 0.3;
//    selectButton.backgroundColor = [UIColor clearColor];
//    [selectButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
//    CGFloat selectButtonX = 0;
//    CGFloat selectButtonY = 0;
//    CGFloat selectButtonW = scrollViewW;
//    CGFloat selectButtonH = scrollViewH;
//    selectButton.frame =  CGRectMake(selectButtonX, selectButtonY, selectButtonW, selectButtonH);
//    
//    
////    //adaLog(@"height == %f",CGRectGetMaxY(scrollView.frame));
//}
//-(void)selectButton:(UIButton *)sender
//{
//    int aa = (int)sender.tag;
//    self.backBlock(aa);
// 
//}
//-(void)deleteSport:(UIButton *)btn
//{
//    if (_delegate && [_delegate respondsToSelector:@selector(deleteSportWithID:)]) {
//        [_delegate deleteSportWithID:self.sportID];
//    }
////    -(void)deleteSportWithID:(NSString *)sportID;
////    //adaLog(@"点击删除");
////    [_delegate respondsToSelector:@selector(blueToothManagerReceiveHeartRateNotify:)]
//}
//-(void)setSport:(SportModel *)sport
//{
//    _sport = sport;
//    self.sportID = sport.sportID;
//    self.headViewString =  sport.sportType;
//    NSInteger loc = 11;
//    NSInteger len = 5;
//    self.timeString = [NSString stringWithFormat:@"%@- %@",[sport.fromTime substringWithRange:NSMakeRange(loc, len)],[sport.toTime substringWithRange:NSMakeRange(loc, len)]];
//    self.stepString = sport.stepNumber;
//    self.kcalString = sport.kcalNumber;
//    
////    NSInteger heartNum = 0;
////    for (NSString  *str in sport.heartRateArray) {
////        heartNum += [str integerValue];
////    }
////    NSString *heart  = [NSString stringWithFormat:@"%ld",heartNum / (sport.heartRateArray.count)];
////    NSMutableArray *minuteArray =  [AllTool seconedTominute:sport.heartRateArray];
//    self.bpmString = [AllTool  getMean:sport.heartRateArray];//heart;
//}
//-(void)refreshUI:(SportModel * )sport;
//{
//    self.sportID = sport.sportID;
//    self.headViewString =  sport.sportType;
//    self.timeString = [NSString stringWithFormat:@"%@- %@",[sport.fromTime substringToIndex:5],[sport.toTime substringToIndex:5]];
//    self.stepString = sport.stepNumber;
//    self.kcalString = sport.kcalNumber;
//    self.bpmString = sport.heartRate;
//}
//
//-(void)setBpmString:(NSString *)bpmString
//{
//    _bpmString = bpmString;
//    self.bpmNumberLabel.text = bpmString;
//}
//-(void)setKcalString:(NSString *)kcalString
//{
//    _kcalString = kcalString;
//    self.kcalNumberLabel.text = kcalString;
//}
//-(void)setStepString:(NSString *)stepString
//{
//    _stepString = stepString;
//    self.stepsNumberLabel.text = stepString;
//}
//-(void)setTimeString:(NSString *)timeString
//{
//    _timeString = timeString;
//    self.timeLabel.text = timeString;
//}
//-(void)setHeadViewString:(NSString *)headViewString
//{
//    _headViewString  = headViewString;
//    NSInteger type = [headViewString integerValue] - 100;
//    switch (type) {
//        case 0:
//            self.headImageView.image = [UIImage imageNamed:@"buxing"];
//            break;
//        case 1:
//             self.headImageView.image = [UIImage imageNamed:@"跑步"];
//            break;
//        case 2:
//            self.headImageView.image = [UIImage imageNamed:@"登山"];
//            break;
//        case 3:
//            self.headImageView.image = [UIImage imageNamed:@"球类"];
//   
//            break;
//        case 4:
//            self.headImageView.image = [UIImage imageNamed:@"力量训练"];
//        
//            break;
//        case 5:
//            self.headImageView.image = [UIImage imageNamed:@"有氧训练"];
//      
//            break;
//        case 6:
//            self.headImageView.image = [UIImage imageNamed:@"自定义"];
// 
//            break;
//        default:
//            self.headImageView.image = [UIImage imageNamed:@"weizhi"];
//            break;
//    }
//}
//-(void)setArrayIndex:(NSInteger)arrayIndex
//{
//    _arrayIndex = arrayIndex;
//    selectButton.tag = (NSInteger)arrayIndex;
//}
//- (void)awakeFromNib { [super awakeFromNib];   // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {  [super setSelected:selected animated:animated]; }
//
//@end
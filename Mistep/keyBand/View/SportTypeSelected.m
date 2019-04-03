//
//  SportTypeSelected.m
//  custom
//
//  Created by 蒋宝 on 17/1/19.
//  Copyright © 2017年 Smartbi. All rights reserved.
//


//#define CurrentDeviceWidth [UIScreen mainScreen].bounds.size.width
//#define CurrentDeviceHeight [UIScreen mainScreen].bounds.size.height

#define ZITIColor  292929
#define ZITIColor1  @"292929"
//#define WidthProportion  CurrentDeviceWidth / 375
//#define HeightProportion  CurrentDeviceHeight / 667

#define SCREEN_BOUNDS         [UIScreen mainScreen].bounds
#define kActionSheetColor            [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0f]
#define VIEWTAG  1012

#define SPORTTYPENUMBER  @"SPORTTYPENUMBER"
#define SPORTTYPETITLE  @"SPORTTYPETIME"

#import "SportTypeSelected.h"

@interface SportTypeSelected()

@property (nonatomic, weak) UIView    *cover;
@property (nonatomic, weak) UIView    *coverTwo;
@property (nonatomic, weak) UIView    *actionSheet;
@property (nonatomic, assign) CGFloat  actionSheetHeight;

@property (nonatomic, strong)UIButton *stepButton; //以下是六个按钮
@property (nonatomic, strong)UIButton *runButton;
@property (nonatomic, strong)UIButton *mountainButton;
@property (nonatomic, strong)UIButton *ballButton;
@property (nonatomic, strong)UIButton *powerButton;
@property (nonatomic, strong)UIButton *oxygenButton;

@property (nonatomic, strong)UIImageView *stepRingImageView; //以下是六个可以打勾的图
@property (nonatomic, strong)UIImageView *runRingImageView;
@property (nonatomic, strong)UIImageView *mountainRingImageView;
@property (nonatomic, strong)UIImageView *ballRingImageView;
@property (nonatomic, strong)UIImageView *powerRingImageView;
@property (nonatomic, strong)UIImageView *oxygenRingImageView;

@property (nonatomic, assign)NSInteger recordTag;
@property (nonatomic, strong)UITextField *inputTextField;//自定义运动类型
@end

@implementation SportTypeSelected

+(id)showSportTypeSelect
{
    SportTypeSelected *sel = [[self alloc] init];
    //    [sel show];
    return sel;
}
- (instancetype)init
{
    self = [super initWithFrame:SCREEN_BOUNDS];
    if (self) {
        [self setupCover];
        [self setupActionSheet];
    }
    return self;
}
- (void)setupActionSheet {
    
    UIView *actionSheet = [[UIView alloc] init];
    self.actionSheet = actionSheet;
    actionSheet.layer.cornerRadius = 5;
    //    actionSheet.backgroundColor = [UIColor greenColor];
    [self addSubview:self.actionSheet];
    //
    [self setupSubView];
    //    self.actionSheet.frame = CGRectMake(0, 200, 200, 200);
    //
    //    [self setupOtherActionItems];
    //
    //    [self setupDestructiveActionItem];
    //
    //    [_actionSheet addSubview:({
    //        UIView *dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, _offsetY, self.frame.size.width, kDividerHeight)];
    //        dividerView.backgroundColor = kDividerColor;
    //        dividerView;
    //    })];
    //
    //    [self setupCancelActionItem];
    //
    //    _offsetY += kActionItemHeight;
    
    //    _actionSheetHeight = _offsetY;
}
-(void)setupSubView
{
    
    CGFloat actionSheetX = 29*WidthProportion;
    CGFloat actionSheetY = 137*HeightProportion;
    CGFloat actionSheetW = 324*WidthProportion;
    CGFloat actionSheetH = 360*HeightProportion;
    self.actionSheet.frame = CGRectMake(actionSheetX,actionSheetY,actionSheetW,actionSheetH);
    self.actionSheet.backgroundColor = [UIColor whiteColor];
    
    CGFloat titleLabelX = 0;
    CGFloat titleLabelY = 15*HeightProportion;
    CGFloat titleLabelW = actionSheetW;
    CGFloat titleLabelH = 20*HeightProportion;
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.actionSheet addSubview:titleLabel];
    titleLabel.text = NSLocalizedString(@"选择运动模式", nil);
    titleLabel.textColor = [ColorTool getColor:ZITIColor1];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
    // - -  - 分割线
    CGFloat lineViewX = 10*WidthProportion;
    CGFloat lineViewY = CGRectGetMaxY(titleLabel.frame)+15*HeightProportion;
    CGFloat lineViewW = titleLabelW - 2*lineViewX;
    CGFloat lineViewH = 1;
    UIView *lineView = [[UIView alloc]init];
    [self.actionSheet addSubview:lineView];
    lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    //  详细的类型选择
    
    //1.先放label 的位置
    CGFloat stepLabelX = lineViewX;
    CGFloat stepLabelY = lineViewY+75*HeightProportion;
    CGFloat stepLabelW = lineViewW/3;
    CGFloat stepLabelH = 20*HeightProportion;
    UILabel *stepLabel = [[UILabel alloc]init];
    [self.actionSheet addSubview:stepLabel];
    stepLabel.text = NSLocalizedString(@"徒步", nil);
    stepLabel.frame = CGRectMake(stepLabelX, stepLabelY, stepLabelW, stepLabelH);
    stepLabel.textAlignment = NSTextAlignmentCenter;
    //    stepLabel.backgroundColor = [UIColor greenColor];
    
    CGFloat runLabelX = CGRectGetMaxX(stepLabel.frame);
    CGFloat runLabelY = stepLabelY;
    CGFloat runLabelW = stepLabelW;
    CGFloat runLabelH = stepLabelH;
    UILabel *runLabel = [[UILabel alloc]init];
    [self.actionSheet addSubview:runLabel];
    runLabel.text = NSLocalizedString(@"跑步", nil);
    runLabel.frame = CGRectMake(runLabelX, runLabelY, runLabelW, runLabelH);
    runLabel.textAlignment = NSTextAlignmentCenter;
    //    runLabel.backgroundColor = [UIColor redColor];
    
    
    CGFloat mountainLabelX = CGRectGetMaxX(runLabel.frame);
    CGFloat mountainLabelY = runLabelY;
    CGFloat mountainLabelW = runLabelW;
    CGFloat mountainLabelH = runLabelH;
    UILabel *mountainLabel = [[UILabel alloc]init];
    [self.actionSheet addSubview:mountainLabel];
    mountainLabel.text = NSLocalizedString(@"登山", nil);
    mountainLabel.frame = CGRectMake(mountainLabelX, mountainLabelY, mountainLabelW, mountainLabelH);
    mountainLabel.textAlignment = NSTextAlignmentCenter;
    //    mountainLabel.backgroundColor = [UIColor blueColor];
    
    CGFloat ballLabelX = lineViewX;
    CGFloat ballLabelY = lineViewY+170*HeightProportion;
    CGFloat ballLabelW = mountainLabelW;
    CGFloat ballLabelH = mountainLabelH;
    UILabel *ballLabel = [[UILabel alloc]init];
    [self.actionSheet addSubview:ballLabel];
    ballLabel.text = NSLocalizedString(@"球类运动", nil);
    ballLabel.frame = CGRectMake(ballLabelX, ballLabelY, ballLabelW, ballLabelH);
    ballLabel.textAlignment = NSTextAlignmentCenter;
    //    ballLabel.backgroundColor = [UIColor greenColor];
    
    CGFloat powerLabelX = CGRectGetMaxX(ballLabel.frame);
    CGFloat powerLabelY = ballLabelY;
    CGFloat powerLabelW = ballLabelW;
    CGFloat powerLabelH = ballLabelH;
    UILabel *powerLabel = [[UILabel alloc]init];
    [self.actionSheet addSubview:powerLabel];
    powerLabel.text = NSLocalizedString(@"力量训练", nil);
    powerLabel.frame = CGRectMake(powerLabelX, powerLabelY, powerLabelW, powerLabelH);
    powerLabel.textAlignment = NSTextAlignmentCenter;
    //    powerLabel.backgroundColor = [UIColor redColor];
    
    
    CGFloat oxygenLabelX = CGRectGetMaxX(powerLabel.frame);
    CGFloat oxygenLabelY = powerLabelY;
    CGFloat oxygenLabelW = powerLabelW;
    CGFloat oxygenLabelH = powerLabelH;
    UILabel *oxygenLabel = [[UILabel alloc]init];
    [self.actionSheet addSubview:oxygenLabel];
    oxygenLabel.text = NSLocalizedString(@"有氧运动", nil);
    oxygenLabel.frame = CGRectMake(oxygenLabelX, oxygenLabelY, oxygenLabelW, oxygenLabelH);
    oxygenLabel.textAlignment = NSTextAlignmentCenter;
    //    oxygenLabel.backgroundColor = [UIColor blueColor];
    
    
    //2.放UIImageView  的位置
    CGFloat stepImageViewY = lineViewY+20*HeightProportion;
    CGFloat stepImageViewW = 40*WidthProportion;
    CGFloat stepImageViewH = stepImageViewW;
    CGFloat stepImageViewX = CGRectGetMaxX(stepLabel.frame)-stepLabelW/2-stepImageViewW/2;// lineViewX+20*WidthProportion;
    UIImageView *stepImageView = [[UIImageView alloc]init];
    [self.actionSheet addSubview:stepImageView];
    stepImageView.frame = CGRectMake(stepImageViewX, stepImageViewY, stepImageViewW, stepImageViewH);
    stepImageView.image = [UIImage imageNamed:@"Walking_Map"];
    
    
    
    CGFloat runImageViewY = stepImageViewY;
    CGFloat runImageViewW = stepImageViewW;
    CGFloat runImageViewH = runImageViewW;
    CGFloat runImageViewX = lineViewX+lineViewW/2-runImageViewW/2;
    UIImageView *runImageView = [[UIImageView alloc]init];
    [self.actionSheet addSubview:runImageView];
    runImageView.frame = CGRectMake(runImageViewX, runImageViewY, runImageViewW, runImageViewH);
    runImageView.image = [UIImage imageNamed:@"Running_map"];
    
    CGFloat mountainImageViewY = runImageViewY;
    CGFloat mountainImageViewW = runImageViewW;
    CGFloat mountainImageViewH = mountainImageViewW;
    CGFloat mountainImageViewX = lineViewX+lineViewW-70*WidthProportion;
    UIImageView *mountainImageView = [[UIImageView alloc]init];
    [self.actionSheet addSubview:mountainImageView];
    mountainImageView.frame = CGRectMake(mountainImageViewX, mountainImageViewY, mountainImageViewW, mountainImageViewH);
    mountainImageView.image = [UIImage imageNamed:@"Mountaineering_map"];
    
    CGFloat ballImageViewX = stepImageViewX;
    CGFloat ballImageViewY = CGRectGetMaxY(stepLabel.frame)+20*HeightProportion;
    CGFloat ballImageViewW = stepImageViewW;
    CGFloat ballImageViewH = ballImageViewW;
    UIImageView *ballImageView = [[UIImageView alloc]init];
    [self.actionSheet addSubview:ballImageView];
    ballImageView.frame = CGRectMake(ballImageViewX, ballImageViewY, ballImageViewW, ballImageViewH);
    ballImageView.image = [UIImage imageNamed:@"BallGames_maps"];
    
    
    
    CGFloat powerImageViewY = ballImageViewY;
    CGFloat powerImageViewW = ballImageViewW;
    CGFloat powerImageViewH = powerImageViewW;
    CGFloat powerImageViewX = runImageViewX;
    UIImageView *powerImageView = [[UIImageView alloc]init];
    [self.actionSheet addSubview:powerImageView];
    powerImageView.frame = CGRectMake(powerImageViewX, powerImageViewY, powerImageViewW, powerImageViewH);
    powerImageView.image = [UIImage imageNamed:@"Strength_Training_Map"];
    
    CGFloat oxygenImageViewY = powerImageViewY;
    CGFloat oxygenImageViewW = powerImageViewW;
    CGFloat oxygenImageViewH = oxygenImageViewW;
    CGFloat oxygenImageViewX = mountainImageViewX;
    UIImageView *oxygenImageView = [[UIImageView alloc]init];
    [self.actionSheet addSubview:oxygenImageView];
    oxygenImageView.frame = CGRectMake(oxygenImageViewX, oxygenImageViewY, oxygenImageViewW, oxygenImageViewH);
    oxygenImageView.image = [UIImage imageNamed:@"Aerobic_map"];
    
    
    //3.放 右上角的方框  的位置
    CGFloat stepRingImageViewX = CGRectGetMaxX(stepImageView.frame);
    CGFloat stepRingImageViewY = CGRectGetMinY(stepImageView.frame);
    CGFloat stepRingImageViewW = 14*WidthProportion;
    CGFloat stepRingImageViewH = stepRingImageViewW;
    UIImageView *stepRingImageView = [[UIImageView alloc]init];
    [self.actionSheet addSubview:stepRingImageView];
    stepRingImageView.frame = CGRectMake(stepRingImageViewX, stepRingImageViewY, stepRingImageViewW, stepRingImageViewH);
    stepRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
    _stepRingImageView = stepRingImageView;
    
    CGFloat runRingImageViewX = CGRectGetMaxX(runImageView.frame);
    CGFloat runRingImageViewY = CGRectGetMinY(runImageView.frame);
    CGFloat runRingImageViewW = stepRingImageViewW;
    CGFloat runRingImageViewH = runRingImageViewW;
    UIImageView *runRingImageView = [[UIImageView alloc]init];
    [self.actionSheet addSubview:runRingImageView];
    runRingImageView.frame = CGRectMake(runRingImageViewX, runRingImageViewY, runRingImageViewW, runRingImageViewH);
    runRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
    _runRingImageView = runRingImageView;
    
    CGFloat mountainRingImageViewX = CGRectGetMaxX(mountainImageView.frame);
    CGFloat mountainRingImageViewY = CGRectGetMinY(mountainImageView.frame);
    CGFloat mountainRingImageViewW = 14*WidthProportion;
    CGFloat mountainRingImageViewH = mountainRingImageViewW;
    UIImageView *mountainRingImageView = [[UIImageView alloc]init];
    [self.actionSheet addSubview:mountainRingImageView];
    mountainRingImageView.frame = CGRectMake(mountainRingImageViewX, mountainRingImageViewY, mountainRingImageViewW, mountainRingImageViewH);
    mountainRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
    _mountainRingImageView = mountainRingImageView;
    
    
    
    CGFloat ballRingImageViewX = CGRectGetMaxX(ballImageView.frame);
    CGFloat ballRingImageViewY = CGRectGetMinY(ballImageView.frame);
    CGFloat ballRingImageViewW = 14*WidthProportion;
    CGFloat ballRingImageViewH = ballRingImageViewW;
    UIImageView *ballRingImageView = [[UIImageView alloc]init];
    [self.actionSheet addSubview:ballRingImageView];
    ballRingImageView.frame = CGRectMake(ballRingImageViewX, ballRingImageViewY, ballRingImageViewW, ballRingImageViewH);
    ballRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
    _ballRingImageView = ballRingImageView;
    
    CGFloat powerRingImageViewX = CGRectGetMaxX(powerImageView.frame);
    CGFloat powerRingImageViewY = CGRectGetMinY(powerImageView.frame);
    CGFloat powerRingImageViewW = stepRingImageViewW;
    CGFloat powerRingImageViewH = powerRingImageViewW;
    UIImageView *powerRingImageView = [[UIImageView alloc]init];
    [self.actionSheet addSubview:powerRingImageView];
    powerRingImageView.frame = CGRectMake(powerRingImageViewX, powerRingImageViewY, powerRingImageViewW, powerRingImageViewH);
    powerRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
    _powerRingImageView  =powerRingImageView;
    
    
    CGFloat oxygenRingImageViewX = CGRectGetMaxX(oxygenImageView.frame);
    CGFloat oxygenRingImageViewY = CGRectGetMinY(oxygenImageView.frame);
    CGFloat oxygenRingImageViewW = 14*WidthProportion;
    CGFloat oxygenRingImageViewH = oxygenRingImageViewW;
    UIImageView *oxygenRingImageView = [[UIImageView alloc]init];
    [self.actionSheet addSubview:oxygenRingImageView];
    oxygenRingImageView.frame = CGRectMake(oxygenRingImageViewX, oxygenRingImageViewY, oxygenRingImageViewW, oxygenRingImageViewH);
    oxygenRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
    _oxygenRingImageView = oxygenRingImageView;
    
    _stepRingImageView.tag = 1;
    _runRingImageView.tag = 2;
    _mountainRingImageView.tag = 3;
    _ballRingImageView.tag = 4;
    _powerRingImageView.tag = 5;
    _oxygenRingImageView.tag = 6;
    
    
    //4.放UIButton    的位置   用于点击的效果
    CGFloat stepButtonX = lineViewX;
    CGFloat stepButtonY = lineViewY;
    CGFloat stepButtonW = lineViewW/3;
    CGFloat stepButtonH = CGRectGetMaxY(stepLabel.frame) - lineViewY;
    UIButton *stepButton = [[UIButton alloc]init];
    [self.actionSheet addSubview:stepButton];
    stepButton.frame = CGRectMake(stepButtonX, stepButtonY, stepButtonW, stepButtonH);
    //    stepButton.backgroundColor = [UIColor redColor];
    stepButton.adjustsImageWhenHighlighted = NO;
    _stepButton = stepButton;
    
    CGFloat runButtonW = lineViewW/3;
    CGFloat runButtonX = lineViewX + runButtonW;
    CGFloat runButtonY = lineViewY;
    CGFloat runButtonH = stepButtonH;
    UIButton *runButton = [[UIButton alloc]init];
    [self.actionSheet addSubview:runButton];
    runButton.frame = CGRectMake(runButtonX, runButtonY, runButtonW, runButtonH);
    //    runButton.backgroundColor = [UIColor greenColor];
    runButton.adjustsImageWhenHighlighted = NO;
    _runButton = runButton;
    
    
    CGFloat mountainButtonY = lineViewY;
    CGFloat mountainButtonW = lineViewW/3;
    CGFloat mountainButtonX = lineViewX+mountainButtonW*2;
    CGFloat mountainButtonH = runButtonH;
    UIButton *mountainButton = [[UIButton alloc]init];
    [self.actionSheet addSubview:mountainButton];
    mountainButton.frame = CGRectMake(mountainButtonX, mountainButtonY, mountainButtonW, mountainButtonH);
    //    mountainButton.backgroundColor = [UIColor redColor];
    mountainButton.adjustsImageWhenHighlighted = NO;
    _mountainButton = mountainButton;
    
    
    CGFloat ballButtonX = lineViewX;
    CGFloat ballButtonY = CGRectGetMaxY(stepButton.frame);
    CGFloat ballButtonW = lineViewW/3;
    CGFloat ballButtonH = CGRectGetMaxY(ballLabel.frame) - ballButtonY;
    UIButton *ballButton = [[UIButton alloc]init];
    [self.actionSheet addSubview:ballButton];
    ballButton.frame = CGRectMake(ballButtonX, ballButtonY, ballButtonW, ballButtonH);
    //    ballButton.backgroundColor = [UIColor whiteColor];
    ballButton.adjustsImageWhenHighlighted = NO;
    _ballButton = ballButton;
    
    CGFloat powerButtonW = lineViewW/3;
    CGFloat powerButtonX = lineViewX + powerButtonW;
    CGFloat powerButtonY = ballButtonY;
    CGFloat powerButtonH = ballButtonH;
    UIButton *powerButton = [[UIButton alloc]init];
    [self.actionSheet addSubview:powerButton];
    powerButton.frame = CGRectMake(powerButtonX, powerButtonY, powerButtonW, powerButtonH);
    //    powerButton.backgroundColor = [UIColor grayColor];
    powerButton.adjustsImageWhenHighlighted = NO;
    _powerButton = powerButton;
    
    
    
    CGFloat oxygenButtonY = powerButtonY;
    CGFloat oxygenButtonW = lineViewW/3;
    CGFloat oxygenButtonX = lineViewX+oxygenButtonW*2;
    CGFloat oxygenButtonH = runButtonH;
    UIButton *oxygenButton = [[UIButton alloc]init];
    [self.actionSheet addSubview:oxygenButton];
    oxygenButton.frame = CGRectMake(oxygenButtonX, oxygenButtonY, oxygenButtonW, oxygenButtonH);
    //    oxygenButton.backgroundColor = [UIColor yellowColor];
    oxygenButton.adjustsImageWhenHighlighted = NO;
    _oxygenButton =oxygenButton;
    
    stepButton.backgroundColor = [UIColor clearColor];
    runButton.backgroundColor = [UIColor clearColor];
    mountainButton.backgroundColor = [UIColor clearColor];
    ballButton.backgroundColor = [UIColor clearColor];
    powerButton.backgroundColor = [UIColor clearColor];
    oxygenButton.backgroundColor = [UIColor clearColor];
    
    stepButton.tag = 1;
    runButton.tag = 2;
    mountainButton.tag = 3;
    ballButton.tag = 4;
    powerButton.tag = 5;
    oxygenButton.tag = 6;
    [stepButton addTarget:self action:@selector(selectedSportType:) forControlEvents:UIControlEventTouchUpInside];
    [runButton addTarget:self action:@selector(selectedSportType:) forControlEvents:UIControlEventTouchUpInside];
    [mountainButton addTarget:self action:@selector(selectedSportType:) forControlEvents:UIControlEventTouchUpInside];
    [ballButton addTarget:self action:@selector(selectedSportType:) forControlEvents:UIControlEventTouchUpInside];
    [powerButton addTarget:self action:@selector(selectedSportType:) forControlEvents:UIControlEventTouchUpInside];
    [oxygenButton addTarget:self action:@selector(selectedSportType:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加新的模式
    CGFloat newTypeButtonX = 33*WidthProportion;
    CGFloat newTypeButtonY = CGRectGetMaxY(powerLabel.frame)+22*HeightProportion;
    CGFloat newTypeButtonW = actionSheetW-newTypeButtonX*2;
    CGFloat newTypeButtonH = 37*HeightProportion;
    UIButton *newTypeButton = [[UIButton alloc]init];
    [self.actionSheet addSubview:newTypeButton];
    newTypeButton.frame = CGRectMake(newTypeButtonX, newTypeButtonY, newTypeButtonW, newTypeButtonH);
    [newTypeButton setTitle:NSLocalizedString(@"创建新的模式", nil)  forState:UIControlStateNormal];
    [newTypeButton setTitleColor:UIColorFromHex(292929) forState:UIControlStateNormal];
    [newTypeButton setImage:[UIImage imageNamed:@"Shape_jia_map"] forState:UIControlStateNormal];
    newTypeButton.adjustsImageWhenHighlighted = NO;
    [newTypeButton setImageEdgeInsets:UIEdgeInsetsMake(5*WidthProportion, -10*WidthProportion, 5*WidthProportion, 0.0)];
    //    newTypeButton.backgroundColor = [UIColor redColor];
    newTypeButton.layer.cornerRadius = 5;
    newTypeButton.layer.borderWidth = 1;
    newTypeButton.layer.borderColor = [ColorTool getColor:ZITIColor1].CGColor;
    [newTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [newTypeButton addTarget:self action:@selector(newTypeButton) forControlEvents:UIControlEventTouchUpInside];
    CGFloat downLineViewX = 0;
    CGFloat downLineViewY = CGRectGetMaxY(newTypeButton.frame)+15*HeightProportion;
    CGFloat downLineViewW = actionSheetW;
    CGFloat downLineViewH = 1;
    UIView * downLineView = [[UIView alloc]init];
    [self.actionSheet addSubview:downLineView];
    downLineView.frame = CGRectMake(downLineViewX, downLineViewY, downLineViewW, downLineViewH);
    downLineView.backgroundColor =  [UIColor grayColor];
    
    CGFloat ensureButtonX = 0;
    CGFloat ensureButtonY = CGRectGetMaxY(downLineView.frame);
    CGFloat ensureButtonW = actionSheetW;
    CGFloat ensureButtonH = actionSheetH-ensureButtonY;
    UIButton *ensureButton = [[UIButton alloc]init];
    [self.actionSheet addSubview:ensureButton];
    ensureButton.frame = CGRectMake(ensureButtonX, ensureButtonY, ensureButtonW, ensureButtonH);
    [ensureButton setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [ensureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ensureButton addTarget:self action:@selector(ensureButtonAction) forControlEvents:UIControlEventTouchUpInside];
    //    ensureButton.backgroundColor = [UIColor redColor];
    //    if (!_sportTypeDic)
    //    {
    //        [self refreshDefaultSportType];
    //    }
    //    else
    //    {
    //        int typeNumber = [[_sportTypeDic objectForKey:SPORTTYPENUMBER] intValue];
    //        [self refreshSportTypeNumber:typeNumber];
    //    }
    //    if (![ADASaveDefaluts objectForKey:MAPSPORTTYPE])
    //    {
    //        [self refreshDefaultSportType];
    //    }
    //    else
    //    {
    //        [self refreshSportType:[ADASaveDefaluts objectForKey:MAPSPORTTYPE]];
    //    }
    // 重新计算子控件的fame
    [self setNeedsLayout];
}

//确定运动类型
-(void)ensureButtonAction
{
    
    NSString *sportType = [NSString string];
    
    if (self.recordTag == 1)
    {
        sportType = NSLocalizedString(@"徒步", nil);
    }
    else if (self.recordTag == 2)
    {
        sportType = NSLocalizedString(@"跑步", nil);
        // [ADASaveDefaluts setObject:sportType forKey:MAPSPORTTYPE];
    }
    else if (self.recordTag == 3)
    {
        sportType = NSLocalizedString(@"登山", nil);
        // [ADASaveDefaluts setObject:sportType forKey:MAPSPORTTYPE];
    }
    else if (self.recordTag == 4)
    {
        sportType = NSLocalizedString(@"球类运动", nil);
        // [ADASaveDefaluts setObject:sportType forKey:MAPSPORTTYPE];
    }
    else if (self.recordTag == 5)
    {
        sportType = NSLocalizedString(@"力量训练", nil);
        //[ADASaveDefaluts setObject:sportType forKey:MAPSPORTTYPE];
    }
    else if (self.recordTag == 6)
    {
        sportType = NSLocalizedString(@"有氧运动", nil);
        //[ADASaveDefaluts setObject:sportType forKey:MAPSPORTTYPE];
    }
    else
    {
        sportType = NSLocalizedString(@"徒步", nil);
        //[ADASaveDefaluts setObject:sportType forKey:MAPSPORTTYPE];
    }
    [self.sportTypeDic setObject:[NSString stringWithFormat:@"%ld",self.recordTag] forKey:SPORTTYPENUMBER];
    [self.sportTypeDic setObject:sportType forKey:SPORTTYPETITLE];
    //    [ADASaveDefaluts setObject:sportType forKey:MAPSPORTTYPE];
    if (_delegate &&[_delegate respondsToSelector:@selector(callbackSportType:)])
    {
        //adaLog(@"self.sportTypeDic --  %@",[self.sportTypeDic objectForKey:SPORTTYPENUMBER]);
        //adaLog(@"self.sportTypeDic --  %@",[self.sportTypeDic objectForKey:SPORTTYPETITLE]);
        [_delegate callbackSportType:self.sportTypeDic];
    }
    [self dismiss];
}
/**
 *  布局子控件
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
- (void)setupCover {
    
    [self addSubview:({
        UIView *cover = [[UIView alloc] init];
        cover.frame = self.bounds;
        cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
        _cover = cover;
    })];
    _cover.alpha = 0;
}
- (void)removeActionSh
{
    
    [self.actionSheet removeFromSuperview];
    self.actionSheet = nil;
    
    
}


- (void)show
{
    if (_sportTypeDic.count == 0)
    {
        [self refreshDefaultSportType];
    }
    else
    {
        int typeNumber = [[_sportTypeDic objectForKey:SPORTTYPENUMBER] intValue];
        
        [self refreshSportTypeNumber:typeNumber];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.7
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.cover.alpha = 1.0;
                         self.actionSheet.transform = CGAffineTransformMakeTranslation(0, -10);
                     }
                     completion:nil];
}
- (void)dismiss {
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.7
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.cover.alpha = 0.0;
                         self.actionSheet.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}
-(void)refreshDefaultSportType
{
    _stepRingImageView.image = [UIImage imageNamed:@"Shape_gou_map"];
    //    _sportTypeDic = [NSMutableDictionary dictionary];
}
-(void)refreshSportTypeNumber:(int)type
{
    self.recordTag = type;
    if (type == 1)
    {
        _stepRingImageView.image = [UIImage imageNamed:@"Shape_gou_map"];
    }
    else
    {
        _stepRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
    }
    if(type == 2)
    {
        _runRingImageView.image = [UIImage imageNamed:@"Shape_gou_map"];
    }
    else
    {
        _runRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
    }
    if(type == 3)
    {
        _mountainRingImageView.image = [UIImage imageNamed:@"Shape_gou_map"];
    }
    else
    {
        _mountainRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
    }
    if(type == 4)
    {
        _ballRingImageView.image = [UIImage imageNamed:@"Shape_gou_map"];
    }
    else
    {
        _ballRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
        
    }
    if(type == 5)
    {
        _powerRingImageView.image = [UIImage imageNamed:@"Shape_gou_map"];
    }
    else
    {
        _powerRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
    }
    if(type == 6)
    {
        _oxygenRingImageView.image = [UIImage imageNamed:@"Shape_gou_map"];
    }
    else
    {
        _oxygenRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
    }
}
-(void)refreshSportType:(NSString *)type
{
    //[ADASaveDefaluts setObject:sportSype forKey:MAPSPORTTYPE];
    if(!type)
    {
        return;
    }
    if ([type isEqualToString:NSLocalizedString(@"徒步", nil)])
    {
        _stepRingImageView.image = [UIImage imageNamed:@"Shape_gou_map"];
    }
    else
    {
        _stepRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
    }
    if([type isEqualToString:NSLocalizedString(@"跑步", nil)])
    {
        _runRingImageView.image = [UIImage imageNamed:@"Shape_gou_map"];
    }
    else
    {
        _runRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
        
    }
    if([type isEqualToString:NSLocalizedString(@"登山", nil)])
    {
        _mountainRingImageView.image = [UIImage imageNamed:@"Shape_gou_map"];
        
    }
    else
    {
        _mountainRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
        
    }
    if([type isEqualToString:NSLocalizedString(@"球类运动", nil)])
    {
        _ballRingImageView.image = [UIImage imageNamed:@"Shape_gou_map"];
        
    }
    else
    {
        _ballRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
        
    }
    if([type isEqualToString:NSLocalizedString(@"力量训练", nil)])
    {
        _powerRingImageView.image = [UIImage imageNamed:@"Shape_gou_map"];
        
    }
    else
    {
        _powerRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
        
    }
    if([type isEqualToString:NSLocalizedString(@"有氧运动", nil)])
    {
        _oxygenRingImageView.image = [UIImage imageNamed:@"Shape_gou_map"];
        
    }
    else
    {
        _oxygenRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
    }
    
}
-(void)selectedSportType:(UIButton *)btn
{
    self.recordTag = btn.tag;
    if(_stepRingImageView.tag == btn.tag)
    {
        _stepRingImageView.image = [UIImage imageNamed:@"Shape_gou_map"];
    }
    else
    {
        _stepRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
    }
    if(_runRingImageView.tag == btn.tag)
    {
        _runRingImageView.image = [UIImage imageNamed:@"Shape_gou_map"];
    }
    else
    {
        _runRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
        
    }
    if(_mountainRingImageView.tag == btn.tag)
    {
        _mountainRingImageView.image = [UIImage imageNamed:@"Shape_gou_map"];
        
    }
    else
    {
        _mountainRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
        
    }
    if(_ballRingImageView.tag == btn.tag)
    {
        _ballRingImageView.image = [UIImage imageNamed:@"Shape_gou_map"];
        
    }
    else
    {
        _ballRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
        
    }
    if(_powerRingImageView.tag == btn.tag)
    {
        _powerRingImageView.image = [UIImage imageNamed:@"Shape_gou_map"];
        
    }
    else
    {
        _powerRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
        
    }
    if(_oxygenRingImageView.tag == btn.tag)
    {
        _oxygenRingImageView.image = [UIImage imageNamed:@"Shape_gou_map"];
        
    }
    else
    {
        _oxygenRingImageView.image = [UIImage imageNamed:@"Rectangle_fifth_map"];
    }
}

//添加新的运动类型
-(void)newTypeButton
{
    [self removeActionSh];
    
    CGFloat inputViewY  = 170*HeightProportion;
    CGFloat inputViewW  = 320*WidthProportion;
    CGFloat inputViewH  = 156*HeightProportion;
    CGFloat inputViewX  = (CurrentDeviceWidth -inputViewW)/2;
    UIView *inputView = [[UIView alloc]init];
    [self addSubview:inputView];
    inputView.frame = CGRectMake(inputViewX, inputViewY, inputViewW, inputViewH);
    inputView.layer.cornerRadius = 5;
    inputView.backgroundColor = [UIColor whiteColor];
    
    CGFloat inputTextFieldX = 30*WidthProportion;
    CGFloat inputTextFieldY = 42*HeightProportion;
    CGFloat inputTextFieldW = inputViewW  - 2*inputTextFieldX;
    CGFloat inputTextFieldH = 39*HeightProportion;
    
    UITextField *inputTextField = [[UITextField alloc]init];
    [inputView addSubview:inputTextField];
    inputTextField.frame = CGRectMake(inputTextFieldX, inputTextFieldY, inputTextFieldW, inputTextFieldH);
    inputTextField.layer.borderWidth = 1;
    inputTextField.layer.borderColor = [UIColor grayColor].CGColor;
    inputTextField.placeholder = NSLocalizedString(@"请输入运动类型", nil);
    if ([[self.sportTypeDic objectForKey:SPORTTYPENUMBER] intValue] == 7)
    {
        inputTextField.text = [self.sportTypeDic objectForKey:SPORTTYPETITLE];
    }
    inputTextField.layer.cornerRadius = 5;
    [inputTextField addTarget:self action:@selector(sportFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _inputTextField = inputTextField;
    
    CGFloat lineViewX = 3*WidthProportion;
    CGFloat lineViewY = 28*HeightProportion+CGRectGetMaxY(inputTextField.frame);
    CGFloat lineViewW = inputViewW-lineViewX*2;
    CGFloat lineViewH = 1;
    UIView *lineView = [[UIView alloc]init];
    [inputView addSubview:lineView];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
    
    CGFloat enSureX = 0;
    CGFloat enSureY = CGRectGetMaxY(lineView.frame)+1;
    CGFloat enSureW = inputViewW;
    CGFloat enSureH = inputViewH - enSureY;
    UIButton *enSure =[[UIButton alloc]init];
    [inputView addSubview:enSure];
    enSure.frame = CGRectMake(enSureX, enSureY, enSureW, enSureH);
    [enSure setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [enSure setTitleColor:UIColorFromHex(292929) forState:UIControlStateNormal];
    [enSure addTarget:self action:@selector(customAction) forControlEvents:UIControlEventTouchUpInside];
}
-(void)customAction
{
    //    [ADASaveDefaluts setObject:_inputTextField.text forKey:MAPSPORTTYPE];
    if ([self checkSportTypeTitle])
    {
        [self.sportTypeDic setObject:@"07" forKey:SPORTTYPENUMBER];
        [self.sportTypeDic setObject:_inputTextField.text forKey:SPORTTYPETITLE];
        if (_delegate &&[_delegate respondsToSelector:@selector(callbackSportType:)])
        {
            //adaLog(@"self.sportTypeDic --  %@",self.sportTypeDic);
            //adaLog(@"self.sportTypeDic --  %@",[self.sportTypeDic objectForKey:SPORTTYPETITLE]);
            [_delegate callbackSportType:self.sportTypeDic];
        }
        [self dismiss];
        
    }
    
    
}
-(BOOL)checkSportTypeTitle
{
    BOOL isCan = YES;
    if (_inputTextField.text.length == 0)
    {
        isCan = NO;
        [self showAlertView:NSLocalizedString(@"运动类型不能为空", nil)];
    }
    return isCan;
}
- (void)showAlertView:(NSString *)string
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:string delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
    [alertView show];
    //    [self performSelector:@selector(hidenAlertView:) withObject:alertView afterDelay:2.];
}
//- (void)hidenAlertView:(UIAlertView *)alertView
//{
//    [alertView dismissWithClickedButtonIndex:0 animated:YES];
//}
//限制string 的长度
- (void)sportFieldDidChange:(UITextField *)textField
{
    NSString *string = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@" "];
    
    if (textField == _inputTextField) {
        NSInteger leng = [string dataUsingEncoding:NSUTF8StringEncoding].length;
        int xianLeng = 16;
        if (leng > xianLeng)
        {
            textField.text = [textField.text substringToIndex:xianLeng];
        }
    }
}
#pragma mark   - - - set
//-(void)setSportTypeDic:(NSMutableDictionary *)sportTypeDic
//{
//    self.sportTypeDic =  sportTypeDic;
//
//}
#pragma mark   - -- 懒加载
//-(NSMutableDictionary *)sportTypeDic
//{
//    if (_sportTypeDic)
//    {
//        _sportTypeDic = [NSMutableDictionary dictionary];
//    }
//    return _sportTypeDic;
//}
@end

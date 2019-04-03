//
//  XueyaCorrectView.m
//  cyuc
//
//  Created by 迈诺科技 on 2017/2/13.
//  Copyright © 2017年 huichenghe. All rights reserved.
//

//#define WidthProportion  [UIScreen mainScreen].bounds.size.width / 375
//#define HeightProportion  [UIScreen mainScreen].bounds.size.height / 667

#define SCREEN_BOUNDS         [UIScreen mainScreen].bounds
#define kActionSheetColor            [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0f]
#define VIEWTAG  1012
//#define ZITICOLOR  @"#282828"    //40 40  40
//#define ZITISIZE 13
#import "XueyaCorrectView.h"
#import "UIView+Extension.h"
#import "ColorTool.h"

@interface XueyaCorrectView()

@property (nonatomic, strong) UIView    *cover;
@property (nonatomic, strong) UIView    *actionSheet;
@property (nonatomic, strong) UITextField * text1;
@property (nonatomic, strong) UITextField * text2;
@property (nonatomic, assign) CGRect actionSheetRect;
@property (nonatomic,strong) UIAlertView *Alert;//自动提醒
@end
@implementation XueyaCorrectView
+(id)showXueyaCorrectView
{
    XueyaCorrectView *sel = [[self alloc] init];
    [sel show];
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
- (void)setupActionSheet {
    
    UIView *actionSheet = [[UIView alloc] init];
    self.actionSheet = actionSheet;
    [self addSubview:self.actionSheet];
    [self setupSubView];
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    //键盘高度
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    int chazhi= CurrentDeviceHeight - keyBoardFrame.size.height -CGRectGetMaxY(self.actionSheet.frame);
    int juedui = abs(chazhi);
    if ( juedui> 100)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.actionSheet.frame = CGRectMake(self.actionSheet.x, self.actionSheet.y-juedui, self.actionSheet.width, self.actionSheet.height);
        }];
        
    }
    
    
}
-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //键盘高度
    //    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.5 animations:^{
        self.actionSheet.frame = _actionSheetRect;
        
    }];
}


-(void)setupSubView
{
    CGFloat actionSheetX = 16*WidthProportion;
    CGFloat actionSheetY = 104*HeightProportion;
    CGFloat actionSheetW = 343*WidthProportion;
    CGFloat actionSheetH = 399*HeightProportion;
    self.actionSheet.frame = CGRectMake(actionSheetX,actionSheetY,actionSheetW,actionSheetH);
    _actionSheetRect = self.actionSheet.frame;
    self.actionSheet.backgroundColor = [UIColor whiteColor];
    self.actionSheet.layer.cornerRadius = 10;
    self.actionSheet.layer.masksToBounds = YES;
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    [self.actionSheet addSubview:scrollView];
    CGFloat scrollViewX = 15*WidthProportion;
    CGFloat scrollViewY = 15*HeightProportion;
    CGFloat scrollViewW = actionSheetW-scrollViewX*2;
    CGFloat scrollViewH = actionSheetH - scrollViewX - 50*WidthProportion;
    scrollView.frame = CGRectMake(scrollViewX,scrollViewY,scrollViewW,scrollViewH);
    scrollView.backgroundColor = allColorWhite;
    
    //    CGFloat titleLabelX = 0;
    //    CGFloat titleLabelY = 15*HeightProportion;
    //    CGFloat titleLabelW = actionSheetW;
    //    CGFloat titleLabelH = 20*HeightProportion;
    //    UILabel *titleLabel = [[UILabel alloc]init];
    //    [self.actionSheet addSubview:titleLabel];
    //    titleLabel.text = @"基于PPG的血压监测，因个人体质差异，需要个人基准血压用于校正血流变化与血压的对应关系，首次测量时，请输入您的基准血压。";
    //
    //    titleLabel.textAlignment = NSTextAlignmentCenter;
    //    titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
    UILabel *label1 = [[UILabel alloc] init];
    //    label1.backgroundColor = [UIColor redColor];
    [scrollView addSubview:label1];
    label1.textColor = [UIColor grayColor];
    //    label1.textColor = [ColorTool getColor:ZITICOLOR];
    //    label1.font = [UIFont systemFontOfSize:ZITISIZE];
    label1.text = NSLocalizedString(@"    基于PPG的血压监测，因个人体质差异，需要个人基准血压用于校正血流变化与血压的对应关系，首次测量时，请输入您的基准血压。", nil);
    label1.numberOfLines = 0;
    //        label1.backgroundColor = [UIColor greenColor];
    CGFloat label1X = 0;//15*WidthProportion;
    CGFloat label1Y = 0;//20*HeightProportion;
    CGFloat label1W = scrollViewW;//self.actionSheet.frame.size.width-2*label1X;
    CGFloat label1H = scrollViewH;
    NSDictionary *dic1 = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0]};
    CGSize size1 = [label1.text boundingRectWithSize:CGSizeMake(label1W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic1 context:nil].size;
    label1H = size1.height;
    label1.frame = CGRectMake(label1X, label1Y, label1W, label1H);
    
    UILabel *label2 = [[UILabel alloc] init];
    //    label2.backgroundColor = [UIColor greenColor];
    [scrollView addSubview:label2];
    label2.textColor = [UIColor grayColor];
    //    label2.textColor = [ColorTool getColor:ZITICOLOR];
    //    label2.font = [UIFont systemFontOfSize:ZITISIZE];
    label2.text = NSLocalizedString(@"    请先选择一款精确的传统血压计，并将基准的血压值输入下列信息框", nil);
    label2.numberOfLines = 0;
    //        label2.backgroundColor = [UIColor greenColor];
    CGFloat label2X = 0;//15*WidthProportion;
    CGFloat label2Y = CGRectGetMaxY(label1.frame);//+10*HeightProportion;
    CGFloat label2W = label1W;
    CGFloat label2H = scrollViewH;
    NSDictionary *dic2 = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0]};
    CGSize size2 = [label2.text boundingRectWithSize:CGSizeMake(label2W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic2 context:nil].size;
    label2H = size2.height;
    label2.frame = CGRectMake(label2X, label2Y, label2W, label2H);
    
    UIImageView *imageView = [[UIImageView alloc]init];
    [scrollView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"血压低，听诊"];
    CGFloat imageViewX = label2X;
    CGFloat imageViewY = CGRectGetMaxY(label2.frame)+10*HeightProportion;
    CGFloat imageViewW = 18*WidthProportion;
    CGFloat imageViewH = imageViewW;
    imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    
    UILabel *label3 = [[UILabel alloc] init];
    [scrollView addSubview:label3];
    label3.textColor = [UIColor grayColor];
    //    label3.textColor = [ColorTool getColor:ZITICOLOR];
    //    label3.font = [UIFont systemFontOfSize:ZITISIZE];
    label3.text = NSLocalizedString(@"请输入校正血压", nil);
    label3.numberOfLines = 0;
    //        label3.backgroundColor = [UIColor greenColor];
    CGFloat label3X = CGRectGetMaxX(imageView.frame);
    CGFloat label3Y = imageViewY;//+10*HeightProportion;
    CGFloat label3W =  self.actionSheet.frame.size.width-label3X-label1X;
    CGFloat label3H = self.actionSheet.frame.size.height;
    NSDictionary *dic3 = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0]};
    CGSize size3 = [label3.text boundingRectWithSize:CGSizeMake(label3W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic3 context:nil].size;
    label3H = size3.height;
    label3.frame = CGRectMake(label3X, label3Y, label3W, label3H);
    
    CGFloat text1X = CGRectGetMaxX(imageView.frame)+10*WidthProportion;
    CGFloat text1Y = CGRectGetMaxY(label3.frame)+10*HeightProportion;
    CGFloat text1W = 88*WidthProportion;
    CGFloat text1H = 36*WidthProportion;
    UITextField * text1 = [[UITextField alloc]initWithFrame:CGRectMake(text1X, text1Y, text1W, text1H)];
    [scrollView addSubview:text1];
    _text1 = text1;
    text1.keyboardType = UIKeyboardTypeNumberPad;
    text1.placeholder = NSLocalizedString(@"舒张压", nil);
    NSString *text1Str = [ADASaveDefaluts objectForKey:BLOODPRESSURELOW];
    if(text1Str)
    {
        text1.text = text1Str;
    }
    text1.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    text1.borderStyle = UITextBorderStyleRoundedRect;
    //    [text1 addTarget:self action:@selector(text1Didchange:) forControlEvents:UIControlEventEditingChanged];
    CGFloat text2W = text1W;
    CGFloat text2X = scrollViewW-text1X-text2W;
    CGFloat text2Y = CGRectGetMaxY(label3.frame)+10*HeightProportion;
    CGFloat text2H = text1H;
    UITextField * text2 = [[UITextField alloc]initWithFrame:CGRectMake(text2X, text2Y, text2W, text2H)];
    [scrollView addSubview:text2];
    _text2 = text2;
    text2.keyboardType = UIKeyboardTypeNumberPad;
    text2.placeholder = NSLocalizedString(@"收缩压", nil);
    NSString *text2Str = [ADASaveDefaluts objectForKey:BLOODPRESSUREHIGH];
    if(text2Str)
    {
        text2.text = text2Str;
    }
    text2.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    text2.borderStyle = UITextBorderStyleRoundedRect;
    //    [text2 addTarget:self action:@selector(text2Didchange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *lineView = [[UIView alloc]init];
    [scrollView addSubview:lineView];
    lineView.backgroundColor = [UIColor lightGrayColor];
    CGFloat wid = 20*WidthProportion;
    CGFloat lineViewX = CGRectGetMaxX(text1.frame)+wid;
    CGFloat lineViewY = CGRectGetMinY(text1.frame)+text1H/2;
    CGFloat lineViewW = CGRectGetMinX(text2.frame)-lineViewX-wid;
    CGFloat lineViewH = 1;
    lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
    
    
    UILabel *label4 = [[UILabel alloc] init];
    [scrollView addSubview:label4];
    label4.textColor = [UIColor grayColor];
    //    label4.textColor = [ColorTool getColor:ZITICOLOR];
    //    label4.font = [UIFont systemFontOfSize:ZITISIZE];
    label4.text = NSLocalizedString(@"请保持血压手表与APP已连接，填写完成，请立刻用您血压手表试一次血压，血压校正即完成，后续测量不用再次校正。", nil);
    label4.numberOfLines = 0;
    //        label4.backgroundColor = [UIColor greenColor];
    CGFloat label4X = label2X;
    CGFloat label4Y = CGRectGetMaxY(text1.frame);//+10*HeightProportion;
    CGFloat label4W = label1W;
    CGFloat label4H = label1H;
    NSDictionary *dic4 = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0]};
    CGSize size4 = [label4.text boundingRectWithSize:CGSizeMake(label4W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic4 context:nil].size;
    label4H = size4.height;
    label4.frame = CGRectMake(label4X, label4Y, label4W, label4H);
    
    UILabel *label5 = [[UILabel alloc] init];
    [scrollView addSubview:label5];
    label5.textColor = [UIColor redColor];
    //    label5.textColor = [ColorTool getColor:ZITICOLOR];
    //    label5.font = [UIFont systemFontOfSize:ZITISIZE];
    label5.text = NSLocalizedString(@"个人资料界面可修改血压基准值", nil);
    label5.numberOfLines = 0;
    //        label5.backgroundColor = [UIColor greenColor];
    CGFloat label5X = label4X;
    CGFloat label5Y = CGRectGetMaxY(label4.frame);//+10*HeightProportion;
    CGFloat label5W = label1W;
    CGFloat label5H = label1H;
    NSDictionary *dic5 = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0]};
    CGSize size5 = [label5.text boundingRectWithSize:CGSizeMake(label5W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic5 context:nil].size;
    label5H = size5.height;
    label5.frame = CGRectMake(label5X, label5Y, label5W, label5H);
    
    scrollView.contentSize =  CGSizeMake(scrollViewW,CGRectGetMaxY(label5.frame));
    scrollView.scrollEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    
    
    UIButton *ensureBtn = [[UIButton alloc]init];
    UIButton *cancelBtn = [[UIButton alloc]init];
    [self.actionSheet addSubview:ensureBtn];
    [self.actionSheet addSubview:cancelBtn];
    [ensureBtn addTarget:self action:@selector(ensureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [ensureBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [cancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [ensureBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    ensureBtn.layer.borderWidth = 0.5;
    cancelBtn.layer.borderWidth = 0.5;
    ensureBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    CGFloat  ensureBtnX = 0;
    CGFloat  ensureBtnY = CGRectGetMaxY(scrollView.frame);
    CGFloat  ensureBtnW = self.actionSheet.frame.size.width/2;
    CGFloat  ensureBtnH = 50*HeightProportion;
    ensureBtn.frame = CGRectMake(ensureBtnX, ensureBtnY, ensureBtnW, ensureBtnH);
    
    CGFloat  cancelBtnX = ensureBtnW;
    CGFloat  cancelBtnY = ensureBtnY;
    CGFloat  cancelBtnW = ensureBtnW;
    CGFloat  cancelBtnH = ensureBtnH;
    cancelBtn.frame = CGRectMake(cancelBtnX, cancelBtnY, cancelBtnW, cancelBtnH);
    //
    //    actionSheetH = CGRectGetMaxY(cancelBtn.frame);
    //    self.actionSheet.frame = CGRectMake(actionSheetX,actionSheetY,actionSheetW,actionSheetH);
    //
    //    if (actionSheetY+actionSheetH>CurrentDeviceHeight)
    //    {
    //        int cha = actionSheetH - CurrentDeviceHeight;
    //        if (cha>0)
    //        {
    //            self.actionSheet.frame = CGRectMake(actionSheetX,0,actionSheetW,actionSheetH);
    //        }
    //        else
    //        {
    //             self.actionSheet.frame = CGRectMake(actionSheetX,abs(cha)/2,actionSheetW,actionSheetH);
    //        }
    //    }
    //    _actionSheetRect = self.actionSheet.frame;
    //    "请先选择一款精确的传统血压计，并将基准的血压值输入下列信息框"
    //    "请输入校正血压"
    //    "请保持血压手表与APP已连接，填写完成，请立刻用您血压手表试一次血压，血压校正即完成，后续测量不用再次校正。"
    
    
    // 血压校正输入值高压范围90-160、低压60-100
}
-(void)ensureBtnAction
{
    if ([self checkxueya])
    {
        [ADASaveDefaluts setObject:_text1.text forKey:BLOODPRESSURELOW];
        [ADASaveDefaluts setObject:_text2.text forKey:BLOODPRESSUREHIGH];
        //        if (_delegate&&[_delegate respondsToSelector:@selector(callbackCBCentralManagerState:)])
        if (_delegate&&[_delegate respondsToSelector:@selector(callbackChange)])
        {
            [_delegate callbackChange];
        }
        [self dismiss];
    }
    else
    {
        self.Alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"请输入正确范围，舒张压40-100，收缩压90-180", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [self.Alert show];
        [self performSelector:@selector(performDismiss) withObject:nil afterDelay:2.5];
        //        [self addActityTextInView:[UIApplication sharedApplication].keyWindow text:NSLocalizedString(@"请输入正确范围，舒张压40-100，收缩压90-180", nil) deleyTime:1.5f];
        [self performSelector:@selector(TFBecomeFirstResponder:) withObject:_text1 afterDelay:1];
    }
}
-(void)cancelBtnAction
{
    [self dismiss];
}
-(void) performDismiss
{
    [self.Alert dismissWithClickedButtonIndex:0 animated:NO];
    //    [Alert release];
}
- (void)show {
    
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
#pragma  maek  - - - 私有方法

- (void)text1Didchange:(UITextField *)textField
{
}
//限制string 的长度
- (void)text2Didchange:(UITextField *)textField
{
    
}
#pragma mark - 弹出HUD
- (void)addActityTextInView : (UIView *)view text : (NSString *)textString deleyTime : (float)times {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    //    hud.labelText = textString ;
    hud.label.text = textString;
    hud.margin = 10.f;
    //    	hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.square = YES;
    //    [hud hide:YES afterDelay:times];
    [hud hideAnimated:YES afterDelay:times];
}
#pragma  maek  -- -核实血压的值
-(BOOL)checkxueya
{
    BOOL check = YES;
    NSInteger diya= [_text1.text intValue];
    NSInteger gaoya= [_text2.text intValue];
    if (diya>=40&&diya<=100)
    {
        check = YES;
    }
    else
    {
        check = NO;
    }
    if(check)
    {
        if (gaoya>=90&&gaoya<=180)
        {
            check = YES;
        }
        else
        {
            check = NO;
        }
    }
    return check;
}
#pragma mark - TF获得第一响应
- (void)TFBecomeFirstResponder:(UITextField *)textField
{
    [textField becomeFirstResponder];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
@end

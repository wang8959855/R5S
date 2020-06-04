//
//  HeartAlarmViewController.m
//  Mistep
//
//  Created by 迈诺科技 on 15/12/25.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import "HeartAlarmViewController.h"

@interface HeartAlarmViewController ()
{
}

@end

@implementation HeartAlarmViewController

- (void)dealloc
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setXibLabel];

    // Do any additional setup after loading the view from its nib.

    if (_max != 0)
    {
        _maxTF.text = [NSString stringWithFormat:@"%d",_max];
    }
    if (_min != 0)
    {
        _minTF.text = [NSString stringWithFormat:@"%d",_min];
    }
    _leftWarningLabel.text = NSLocalizedString(@"危险", nil);
    _rightWarningLabel.text = NSLocalizedString(@"危险", nil);

}

- (void)setXibLabel
{
    _titleLabel.text = NSLocalizedString(@"心率预警", nil);
    _introducLabel.text = NSLocalizedString(@"根据正常人心率范围设置最高心率和最低心率，以便于第一时间提醒您！", nil);
    _referenceLabel.text = NSLocalizedString(@"参考", nil);
    _fillInLabel.text = NSLocalizedString(@"填写:", nil);
    _maxHRLabel.text = NSLocalizedString(@"最大心率:", nil);
    _minHRLabel.text = NSLocalizedString(@"最小心率:", nil);
    _warningLabel.text = NSLocalizedString(@"请填写合理的范围！", nil);
    _kNormalAreaLabel.text = NSLocalizedString(@"正常范围", nil);
    [_confirmBtn setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



- (IBAction)completeBtnAction:(id)sender
{
    [self.view endEditing:YES];
    
    int max = [_maxTF.text intValue];
    int min = [_minTF.text intValue];
    if (min && max)
    {
        if (max < 40 || max > 100)
        {
            [self showAlertView:NSLocalizedString(@"输入的心率必须在40到100之间", nil)];
            return;
        }
        else if (min < 40 || min > 100)
        {
            [self showAlertView:NSLocalizedString(@"输入的心率必须在40到100之间", nil)];
            return;
        }else
        {
            if (max - min < 30)
            {
                [self showAlertView:NSLocalizedString(@"最大心率值必须大于最小心率值30", nil)];
                return;
            }
            else
            {
                [[CositeaBlueTooth sharedInstance] setHeartRateAlarmWithState:_state MaxHeartRate:[_maxTF.text intValue] MinHeartRate:[_minTF.text intValue]];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    else
    {
        [self addActityTextInView:self.view text:NSLocalizedString(@"输入不能为空", nil) deleyTime:1.5];
    }
}

@end

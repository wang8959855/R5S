//
//  SelectStepTypeViewController.m
//  Wukong
//
//  Created by apple on 2018/6/26.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "SelectStepTypeViewController.h"
#import "SelectStepCell.h"
#import "CustomStepTypeView.h"

@interface SelectStepTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *imageArr;

@property (nonatomic, strong) SelectStepCell *lastSelectCell;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusHeight;

@end

@implementation SelectStepTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setSubViews];
    self.statusHeight.constant = StatusBarHeight;
}

- (void)setSubViews{
    self.titleArr = @[@"徒步",@"跑步",@"登山",@"球类运动",@"力量训练",@"有氧运动",@"自定义"];
    self.imageArr = @[@"tubu-",@"paobu-",@"dengshan-",@"qiulei",@"liliang",@"youyang",@"zidingyi"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectStepCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 55;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.titleArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectStepCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!self.lastSelectCell && indexPath.row == 0) {
        self.lastSelectCell = cell;
        cell.selectImage.hidden = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = self.titleArr[indexPath.row];
    cell.imageV.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectStepCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.lastSelectCell == cell) {
        cell.selectImage.hidden = NO;
    }else{
        cell.selectImage.hidden = NO;
        self.lastSelectCell.selectImage.hidden = YES;
        self.lastSelectCell = cell;
    }
    
    if ([cell.titleLabel.text isEqualToString:@"自定义"]) {
        CustomStepTypeView *custom = [CustomStepTypeView customStepTypeView];
        [custom show];
        WeakSelf;
        custom.CustomStepTypeBlock = ^(NSString *type) {
            if (weakSelf.backStepType) {
                weakSelf.backStepType(type);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//确定
- (IBAction)okAction:(UIButton *)sender {
    NSString *type = self.lastSelectCell.titleLabel.text;
    if ([type isEqualToString:@"自定义"]) {
        [AllTool addActityTextInView:self.view text:@"测试模式不能为空" deleyTime:1.5f];
        return;
    }
    if (self.backStepType) {
        self.backStepType(type);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//返回
- (IBAction)goBackAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

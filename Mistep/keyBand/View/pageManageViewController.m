//
//  pageManageViewController.m
//  页面管理
//
//  Created by 迈诺科技 on 2016/12/8.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "pageManageViewController.h"
#import "pageManageTableViewCell.h"


@interface pageManageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UITableView *tableView;
//@property (strong,nonatomic) NSString *pageManagerString;
@property (assign,nonatomic) uint supportNumber;     //支持页面管理的数据
@property (assign,nonatomic) uint pageManager;       //页面管理的  开关
@end

@implementation pageManageViewController

-(void)loadView
{
    [super loadView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self queryPageManager];
}
- (void)queryPageManager
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(queryPageManager) object:nil];
    WeakSelf;
    [[CositeaBlueTooth sharedInstance] checkPageManager:^(uint pageManager) {
        uint  pageM = (uint) pageManager;
        _pageManager = pageManager;
        //        if (pageManager>=0)
        //        {
        
        for (int i=0; i<32; i++)
        {
            uint open = (((pageM)>>i) & 0x01);
            ////adaLog(@"open = %d",open);
            for (int index = 2;index<self.dataArray.count;index+=3)
            {
                if ([self.dataArray[index] integerValue] == i)
                {
                    pageManageTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(index - 2)/3 inSection:0]];
                    [cell.Switch setOn:!open animated:YES];
                    break;
                }
            }
        }
        //        }
    }];
}


- (void)setupView
{
    CGFloat tableViewX = 0;
    CGFloat tableViewY = 64;
    CGFloat tableViewW = CurrentDeviceWidth;
    CGFloat tableViewH = CurrentDeviceHeight - tableViewY;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setRowHeight:60*HeightProportion];
    self.tableView.tableFooterView = [[UIView alloc]init];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        UIEdgeInsets inset = UIEdgeInsetsMake(0, 10*WidthProportion, 0, 10*WidthProportion);
        [self.tableView setSeparatorInset:inset];
    }
    [self  data];
}
-(void)data
{
    
    _dataArray = [NSMutableArray arrayWithObjects:@"步数shezhi",NSLocalizedString(@"步数", nil),@"0",@"矢量智能对象",NSLocalizedString(@"心率", nil),@"1",@"运动shezhi",NSLocalizedString(@"运动", nil),@"2",@"里程",NSLocalizedString(@"里程", nil),@"3",@"卡路里shezhi",NSLocalizedString(@"卡路里",nil),@"4",@"shezhi2",NSLocalizedString(@"设置", nil),@"6",nil];
    uint supportNum = [[ADASaveDefaluts objectForKey:SUPPORTPAGEMANAGER] doubleValue];
    if(supportNum != 4294967295)
    {
        _supportNumber = supportNum;
        [self.dataArray removeAllObjects];
        //        if (supportNum>=0)
        //        {
        NSArray * array =[NSArray array];
        for (int i=0; i<32; i++)
        {
            int aa = (((self.supportNumber)>>i) & 0x01);
            if(aa == 0)
            {
                if (i==0)
                {
                    array = @[@"步数shezhi",NSLocalizedString(@"步数", nil),[NSString stringWithFormat:@"%d",i]];
                    [self.dataArray addObjectsFromArray:array];
                }
                else if (i==1)
                {
                    array = @[@"矢量智能对象",NSLocalizedString(@"心率", nil),[NSString stringWithFormat:@"%d",i]];
                    [self.dataArray addObjectsFromArray:array];
                }
                else if (i==2)
                {
                   
                    array = @[@"运动shezhi",NSLocalizedString(@"运动", nil),[NSString stringWithFormat:@"%d",i]];
                    [self.dataArray addObjectsFromArray:array];
                }
                else if (i==3)
                {
                    array = @[@"里程",NSLocalizedString(@"里程", nil),[NSString stringWithFormat:@"%d",i]];
                    [self.dataArray addObjectsFromArray:array];
                }
                else if (i==4)
                {
                    array = @[@"卡路里shezhi",NSLocalizedString(@"卡路里",nil),[NSString stringWithFormat:@"%d",i]];
                    [self.dataArray addObjectsFromArray:array];
                }
                else if (i==5)
                {
                    array = @[@"月亮shezhi",NSLocalizedString(@"睡眠",nil),[NSString stringWithFormat:@"%d",i]];
                    [self.dataArray addObjectsFromArray:array];
                }
                else if (i==6)
                {
                    array = @[@"shezhi2",NSLocalizedString(@"设置", nil),[NSString stringWithFormat:@"%d",i]];
                    [self.dataArray addObjectsFromArray:array];
                }
                else if (i==7)
                {
                    array = @[@"血压低，听诊",NSLocalizedString(@"血压", nil),[NSString stringWithFormat:@"%d",i]];
                    [self.dataArray addObjectsFromArray:array];
                }
                else if (i==8)
                {
                    array = @[@"天气",NSLocalizedString(@"天气",nil),[NSString stringWithFormat:@"%d",i]];
                    [self.dataArray addObjectsFromArray:array];
                }
                else if (i==9)
                {
                    array = @[@"信息",NSLocalizedString(@"消息", nil),[NSString stringWithFormat:@"%d",i]];
                    [self.dataArray addObjectsFromArray:array];
                }
            }
        }
        //        }
        //        else
        //        {
        //            _dataArray = [NSMutableArray arrayWithObjects:@"步数shezhi",NSLocalizedString(@"步数", nil),@"0",@"矢量智能对象",NSLocalizedString(@"心率", nil),@"1",@"运动",NSLocalizedString(@"运动", nil),@"2",@"里程",NSLocalizedString(@"里程", nil),@"3",@"卡路里shezhi",NSLocalizedString(@"卡路里",nil),@"4",@"shezhi2",NSLocalizedString(@"设置", nil),@"6",nil];
        //        }
        [self.tableView reloadData];
    }
    else
    {
        [[CositeaBlueTooth sharedInstance] supportPageManager:^(uint number) {
            //adaLog(@"支持的页面 - %u",number);
            _supportNumber = number;
            [self.dataArray removeAllObjects];
            NSArray * array =[NSArray array];
            for (int i=0; i<32; i++)
            {
                int aa = (((self.supportNumber)>>i) & 0x01);
                if(aa == 0)
                {
                    if (i==0)
                    {
                        array = @[@"步数shezhi",NSLocalizedString(@"步数", nil),[NSString stringWithFormat:@"%d",i]];
                        [self.dataArray addObjectsFromArray:array];
                    }
                    else if (i==1)
                    {
                        array = @[@"矢量智能对象",NSLocalizedString(@"心率", nil),[NSString stringWithFormat:@"%d",i]];
                        [self.dataArray addObjectsFromArray:array];
                    }
                    else if (i==2)
                    {
                        array = @[@"运动shezhi",NSLocalizedString(@"运动", nil),[NSString stringWithFormat:@"%d",i]];
                        [self.dataArray addObjectsFromArray:array];
                    }
                    else if (i==3)
                    {
                        array = @[@"里程",NSLocalizedString(@"里程", nil),[NSString stringWithFormat:@"%d",i]];
                        [self.dataArray addObjectsFromArray:array];
                    }
                    else if (i==4)
                    {
                        array = @[@"卡路里shezhi",NSLocalizedString(@"卡路里",nil),[NSString stringWithFormat:@"%d",i]];
                        [self.dataArray addObjectsFromArray:array];
                    }
                    else if (i==5)
                    {
                        array = @[@"月亮shezhi",NSLocalizedString(@"睡眠",nil),[NSString stringWithFormat:@"%d",i]];
                        [self.dataArray addObjectsFromArray:array];
                    }
                    else if (i==6)
                    {
                        array = @[@"shezhi2",NSLocalizedString(@"设置", nil),[NSString stringWithFormat:@"%d",i]];
                        [self.dataArray addObjectsFromArray:array];
                    }
                    else if (i==7)
                    {
                        array = @[@"血压低，听诊",NSLocalizedString(@"血压", nil),[NSString stringWithFormat:@"%d",i]];
                        [self.dataArray addObjectsFromArray:array];
                    }
                    else if (i==8)
                    {
                        array = @[@"天气",NSLocalizedString(@"天气",nil),[NSString stringWithFormat:@"%d",i]];
                        [self.dataArray addObjectsFromArray:array];
                    }
                    else if (i==9)
                    {
                        array = @[@"信息",NSLocalizedString(@"消息", nil),[NSString stringWithFormat:@"%d",i]];
                        [self.dataArray addObjectsFromArray:array];
                    }
                }
            }
            [self.tableView reloadData];
        }];
    }
    [self.tableView reloadData];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]init];
    CGFloat headViewX = 0;
    CGFloat headViewY = 0;
    CGFloat headViewW = CurrentDeviceWidth;
    CGFloat headViewH = 65*HeightProportion;
    headView.frame = CGRectMake(headViewX, headViewY, headViewW, headViewH);
    headView.backgroundColor = allColorWhite;
    
    UILabel *label = [[UILabel alloc]init];
    [headView addSubview:label];
    label.backgroundColor = allColorWhite;
    label.numberOfLines = 0;
    CGFloat labelX = 0;
    CGFloat labelY = 10*WidthProportion;
    CGFloat labelW = headViewW - labelY;
    CGFloat labelH = headViewH-1;
    label.frame = CGRectMake(labelX, labelY, labelW, labelH);
    label.text = NSLocalizedString(@"选择开关设备功能", nil);
    
    UIView *lineView = [[UIView alloc]init];
    [headView addSubview:lineView];
    CGFloat lineViewX = 10*WidthProportion;
    CGFloat lineViewY = headViewH - 1;
    CGFloat lineViewW = CurrentDeviceWidth - 2*lineViewX;
    CGFloat lineViewH = 0.5;
    lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 65*HeightProportion;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count/3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    pageManageTableViewCell *pageCell = [pageManageTableViewCell cellWithTableView:tableView];
    pageCell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *image_str = _dataArray[indexPath.row * 3];
    //adaLog(@"image_str -- %@",image_str);
    
    pageCell.imageString = image_str;
    pageCell.titleString = _dataArray[indexPath.row * 3 +1];
    pageCell.openTag = _dataArray[indexPath.row * 3 +2];
    WeakSelf;
    pageCell.setPage = ^(NSInteger aa)
    {
        [weakSelf touchCell:aa];
    };
    return pageCell;
}
//对对应的页面开关
-(void)touchCell:(NSInteger)row
{
    //adaLog(@"row == %ld",row);
    NSMutableString *yanMa = [NSMutableString string];
    for (int i=31; i >=0; i--)
    {
        if (i==row)
        {
            [yanMa appendString:@"1"];
        } else {
            [yanMa appendString:@"0"];
        }
    }
    NSString *newString = [AllTool toDecimalSystemWithBinarySystem:yanMa];
    
    self.pageManager = self.pageManager ^ [newString intValue];
    
//    interfaceLog(@"page 333 app set = num =%u",self.pageManager);
    [[CositeaBlueTooth sharedInstance] setupPageManager:self.pageManager];
    
    [self performSelector:@selector(queryPageManager) withObject:nil afterDelay:0.1];
    
}
//-(int)supportNumber
//{
//    if (!_supportNumber)
//    {
//        [[CositeaBlueTooth sharedInstance] supportPageManager:^(int number) {
//            //adaLog(@"支持的页面 - %d",number);
//            _supportNumber = number;
//        }];
//
//    }
//    return _supportNumber;
//}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray =[NSMutableArray array];
    }
    return _dataArray;
}
- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
- (void)didReceiveMemoryWarning {  [super didReceiveMemoryWarning];  }
@end

//
//  AttentionView.m
//  Bracelet
//
//  Created by apple on 2018/10/25.
//  Copyright © 2018 com.czjk.www. All rights reserved.
//

#import "AttentionView.h"
#import "AttentionReusableView.h"
#import "AttentionCell.h"

@interface AttentionView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *listArrayOne;
@property (nonatomic, strong) NSMutableArray *listArrayTwo;

@end

@implementation AttentionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self collectionView];
        [self getFriendList];
    }
    return self;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.listArrayOne.count;
    }
    return self.listArrayTwo.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AttentionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.dic = self.listArrayOne[indexPath.row];
        cell.guanbiButton.tag = 10000 + indexPath.row;
    }else{
        cell.dic = self.listArrayTwo[indexPath.row];
        cell.guanbiButton.tag = 20000 + indexPath.row;
    }
    [cell.guanbiButton addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    AttentionReusableView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"top" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        headerView.titleLabel.text = @"允许他(她)浏览我的健康数据:";
    }else{
        headerView.titleLabel.text = @"禁止他(她)浏览我的健康数据:";
    }
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.frame.size.width, 55);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 30, 0, 30);
}

- (void)changeState:(UIButton *)button{
    NSInteger tag = button.tag;
    NSDictionary *dic;
    if (tag >= 20000) {
        tag -= 20000;
        dic = self.listArrayTwo[tag];
    }else{
        tag -= 10000;
        dic = self.listArrayOne[tag];
    }
    [self setStateWithDic:dic];
}

//  修改状态
- (void)setStateWithDic:(NSDictionary *)dic{
    [self.vc addActityIndicatorInView:self labelText:@"正在修改" detailLabel:@"正在修改"];
    [self performSelector:@selector(loginTimeOut) withObject:nil afterDelay:60.f];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@/%@",SETATTENTION,TOKEN];
    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:uploadUrl fileUrl:nil params:@{@"userid":USERID,@"client":dic[@"client"],@"id":dic[@"id"]} Block:^(id responseObject, NSError *error) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeOut) object:nil];
        
        [self.vc removeActityIndicatorFromView:self];
        if (error)
        {
            [self.vc addActityTextInView:self text:NSLocalizedString(@"网络连接错误", nil) deleyTime:1.5f];
        }
        else
        {
            int code = [[responseObject objectForKey:@"code"] intValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 0) {
                [self getFriendList];
            } else {
                [self.vc addActityTextInView:self text:NSLocalizedString(message, nil)  deleyTime:1.5f];
            }
        }
    }];
}

//获取列表
- (void)getFriendList{
    [self.listArrayOne removeAllObjects];
    [self.listArrayTwo removeAllObjects];
    [self.vc addActityIndicatorInView:self labelText:@"正在获取好友列表" detailLabel:@"正在获取好友列表"];
    [self performSelector:@selector(loginTimeOut) withObject:nil afterDelay:60.f];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@/%@",GETATTENTIONLIST,TOKEN];
    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:uploadUrl fileUrl:nil params:@{@"userid":USERID} Block:^(id responseObject, NSError *error) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeOut) object:nil];
        
        [self.vc removeActityIndicatorFromView:self];
        if (error)
        {
            [self.vc addActityTextInView:self text:NSLocalizedString(@"网络连接错误", nil) deleyTime:1.5f];
        }
        else
        {
            int code = [[responseObject objectForKey:@"code"] intValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 0) {
                [self.listArrayOne addObjectsFromArray:responseObject[@"data"][@"y"]];
                [self.listArrayTwo addObjectsFromArray:responseObject[@"data"][@"n"]];
                [self.collectionView reloadData];
            } else {
                [self.vc addActityTextInView:self text:NSLocalizedString(message, nil)  deleyTime:1.5f];
            }
        }
    }];
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((self.frame.size.width - 140) / 3, (self.frame.size.width) / 3);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"AttentionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"top"];
        [_collectionView registerNib:[UINib nibWithNibName:@"AttentionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (NSMutableArray *)listArrayOne{
    if (!_listArrayOne) {
        _listArrayOne = [NSMutableArray array];
    }
    return _listArrayOne;
}

- (NSMutableArray *)listArrayTwo{
    if (!_listArrayTwo) {
        _listArrayTwo = [NSMutableArray array];
    }
    return _listArrayTwo;
}

@end

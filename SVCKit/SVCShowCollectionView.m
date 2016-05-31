//
//  SVCShowCollectionView.m
//  SVCKit
//
//  Created by 123 on 16/5/25.
//  Copyright © 2016年 asura. All rights reserved.
//

#import "SVCShowCollectionView.h"
#import "SVCShowCollectionViewCell.h"


static NSString *const indentifier = @"SVCShowCollectionViewCell";


@interface SVCShowCollectionView () <UICollectionViewDataSource,UICollectionViewDelegate,refreshDelegate>
//标签个数
@property (nonatomic, assign) NSInteger markCount;


@end

@implementation SVCShowCollectionView

#pragma mark- init
- (instancetype)initWithShowCollectionViewFrame:(CGRect)frame markCount:(NSInteger)markCount{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(SCREENWIDTH, frame.size.height);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self = [[SVCShowCollectionView alloc]initWithFrame:frame collectionViewLayout:flowLayout];
    [self configureCollectionView];
    _markCount = markCount;
    return self;
}

- (void)configureCollectionView{
    self.delegate = self;
    self.dataSource = self;
    self.pagingEnabled = YES;
    self.bounces = NO;
    [self registerClass:[SVCShowCollectionViewCell class] forCellWithReuseIdentifier:indentifier];
}

#pragma mark - setter
- (void)setShowDatasoucre:(NSMutableArray *)showDatasoucre{
    _showDatasoucre = showDatasoucre;
    //接收到数据.发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kNontifictaionDatasource object:_showDatasoucre];
}

- (void)setSelectdeIndex:(NSInteger)selectdeIndex{
    _selectdeIndex = selectdeIndex;
    //改变选中标签.发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kNontifictaionSelectedIndex object:@(_selectdeIndex)];
}

#pragma mark - UICollectiionView delegate && datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _markCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SVCShowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
    cell.SVCView.refreshDelegate = self;
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat count = scrollView.contentOffset.x;

    if (self.showCollectionViewDelegate && [self.showCollectionViewDelegate respondsToSelector:@selector(showCollectonViewEndScrollContentOffsetX:)]) {
        [self.showCollectionViewDelegate showCollectonViewEndScrollContentOffsetX:count];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat count = scrollView.contentOffset.x;
    
    if (self.showCollectionViewDelegate && [self.showCollectionViewDelegate respondsToSelector:@selector(showCollectonViewEndScrollContentOffsetX:)]) {
        [self.showCollectionViewDelegate showCollectonViewEndScrollContentOffsetX:count];
    }
}

#pragma mark -refreshDelegate
- (void)refreshDelegateWithNewDate:(BOOL)newData selectedIndex:(NSInteger)selectedIndex complete:(void(^)(NSMutableArray *datasource))complete failure:(void(^)(NSError *error))failure{
    if (self.showCollectionViewDelegate && [self.showCollectionViewDelegate respondsToSelector:@selector(resfreshWithNewData:selectedIndex:complete:failure:)]) {
     return  [self.showCollectionViewDelegate resfreshWithNewData:newData selectedIndex:selectedIndex complete:^(NSMutableArray *datasource) {
         complete(datasource);
     } failure:^(NSError *error) {
         failure(error);
     }];
    }
}

@end

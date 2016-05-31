//
//  SVCSegmetCollectionView.m
//  SVCKit
//
//  Created by 123 on 16/5/25.
//  Copyright © 2016年 asura. All rights reserved.
//

#import "SVCSegmetCollectionView.h"
#import "SVCShowCollectionView.h"
#import "SVCCollectionViewCell.h"


static NSString *const indentifier = @"SVCCollectionViewCell";

@interface SVCSegmetCollectionView () <UICollectionViewDelegate,UICollectionViewDataSource,showCollectionViewDelegate>
//标签个数
@property (nonatomic, assign) NSInteger markCount;
//标签标题数组
@property (nonatomic, strong) NSArray *markTitles;
//下边的集合视图
@property (nonatomic, strong) SVCShowCollectionView *showView;
//选中显示的下标
@property (nonatomic, assign) NSInteger selectedCount;
//动画.下面的条
@property (nonatomic, strong) UIView *animationView;
//选中显示的标识符
@property (nonatomic, assign) NSInteger selectedIndentifier;


@end

@implementation SVCSegmetCollectionView

#pragma mark -init
- (instancetype)initWithSVCFrame:(CGRect)frame markCount:(NSInteger)markCount markTitles:(NSArray *)markTitles{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(SCREENWIDTH / 4, frame.size.height);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self = [[SVCSegmetCollectionView alloc]initWithFrame:frame collectionViewLayout:flowLayout];
    [self configureCollectionView];
    _markCount = markCount;
    _markTitles = markTitles;
    return self;
}

- (void)configureCollectionView{
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = [UIColor whiteColor];
    [self registerClass:[SVCCollectionViewCell class] forCellWithReuseIdentifier:indentifier];
    
    _animationView = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH / 16, self.frame.size.height - 4, SCREENWIDTH / 8, 4)];
    _animationView.backgroundColor = [UIColor orangeColor];
    [self addSubview:_animationView];
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    _showView = [[SVCShowCollectionView alloc]initWithShowCollectionViewFrame:CGRectMake(0, CGRectGetMaxY(self.frame), SCREENWIDTH, SCREENHEIGHT - CGRectGetMaxY(self.frame)) markCount:_markCount];
    _showView.showCollectionViewDelegate = self;
    [self.superview addSubview:_showView];
}

#pragma mark -改变下面的条及回调
- (void)changedAnimationFrameWithContentOffsetX:(CGFloat)contentOffsetX{
    
    double ooffset = contentOffsetX;
    //前取整
    int deltaFoor = floor(ooffset);
    //后取整
    int deltaCeil = ceil(ooffset);
    
    //滑动选中回调
    if ((deltaCeil == contentOffsetX || deltaFoor == contentOffsetX) && (deltaFoor % (NSInteger)SCREENWIDTH == 0 || deltaCeil % (NSInteger)SCREENWIDTH == 0) && (deltaCeil != _selectedIndentifier || deltaFoor != _selectedIndentifier)) {
        [self responderDelegate:deltaCeil / SCREENWIDTH];
        self.selectedIndentifier = deltaCeil;
    }
    
    //条动画
    [UIView animateWithDuration:0.2 animations:^{
        CGRect animationViewFrame = _animationView.frame;
        animationViewFrame.origin.x = contentOffsetX / SCREENWIDTH * SCREENWIDTH / 4 + SCREENWIDTH / 16;
        _animationView.frame = animationViewFrame;
    }];
}
#pragma mark - 数据源 setter
- (void)setDatasource:(NSMutableArray *)datasource{
    _datasource = datasource;
    _showView.showDatasoucre = _datasource;
}

- (void)setSelectedIndentifier:(NSInteger)selectedIndentifier{
    _selectedIndentifier = selectedIndentifier;
    _showView.selectdeIndex = _selectedIndentifier;
}

#pragma mark - UICollectiionView delegate && datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _markCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SVCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
    NSString *title = _markTitles[indexPath.item];
    [cell setTitleLabelTextWithTitle:title];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //标记.防止选中后再次点击回调
    if (_selectedCount == indexPath.item) {
        return;
    }
    _selectedCount = indexPath.item;
    [self changedAnimationFrameWithContentOffsetX:indexPath.item];
    //联动下面的 collectionView
    [_showView setContentOffset:CGPointMake(_selectedCount * SCREENWIDTH, 0) animated:YES];
}

#pragma mark - SVSShowCollectionView showCollectionViewDelegate
- (void)showCollectonViewEndScrollContentOffsetX:(CGFloat)contentOffsetX{
    [self changedAnimationFrameWithContentOffsetX:contentOffsetX];
    
}
//刷新回调
- (void)resfreshWithNewData:(BOOL)newData selectedIndex:(NSInteger)selectedIndex complete:(void(^)(NSMutableArray *datasource))complete failure:(void(^)(NSError *error))failure{
    if (self.segmetCollectionViewDelegate && [self.segmetCollectionViewDelegate respondsToSelector:@selector(resfreshWithNewData:selectedIndex:complete:failure:)]) {
       return [self.segmetCollectionViewDelegate resfreshWithNewData:newData selectedIndex:selectedIndex complete:^(NSMutableArray *datasource) {
           complete(datasource);
       } failure:^(NSError *error) {
           failure(error);
       }];
    }
}
//滑动或选中回调
- (void)responderDelegate:(NSInteger)index{
    if (self.segmetCollectionViewDelegate && [self.segmetCollectionViewDelegate respondsToSelector:@selector(selectedOrEndScrolIndex:)]) {
        [self.segmetCollectionViewDelegate selectedOrEndScrolIndex:index];
    }
}

#pragma mark - layoutSubviews
- (void)layoutSubviews{
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UICollectionViewCell class]]) {
            CGRect cellFrame = view.frame;
            cellFrame.size.height = self.frame.size.height - 4;
            view.frame = cellFrame;
        }
    }
}

@end

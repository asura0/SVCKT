//
//  SVCShowCollectionView.h
//  SVCKit
//
//  Created by 123 on 16/5/25.
//  Copyright © 2016年 asura. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define kNontifictaionDatasource @"kNontifictaionDatasource"
#define kNontifictaionSelectedIndex @"kNontifictaionSelectedIndex"


/** 刷新成功后的block **/
typedef void(^complete)(NSMutableArray *datasource);
/** 刷新失败的 block **/
typedef void(^failure)(NSError *error);

@protocol showCollectionViewDelegate <NSObject>

/**
 *  @author asura, 16-05-26
 *
 *  刷新
 *
 *  @param newData       是上拉还是下拉
 *  @param selectedIndex 当前是显示的是哪一栏
 *  @param complete      成功的回调
 *  @param failure       失败的回调
 *
 *  @return 刷新或得的数据
 */
- (void)resfreshWithNewData:(BOOL)newData selectedIndex:(NSInteger)selectedIndex complete:(void(^)(NSMutableArray *datasource))complete failure:(void(^)(NSError *error))failure;

@required

/**
 *  @author asura, 16-05-27
 *
 *  滑动的回调
 *
 *  @param contentOffsetX 滑动偏移量
 */
- (void)showCollectonViewEndScrollContentOffsetX:(CGFloat)contentOffsetX;

@end

@interface SVCShowCollectionView : UICollectionView

//数据源
@property (nonatomic, strong) NSMutableArray *showDatasoucre;
//选中标签
@property (nonatomic, assign) NSInteger selectdeIndex;


@property (nonatomic, assign) id <showCollectionViewDelegate> showCollectionViewDelegate;

/**
 *  @author asura, 16-05-27
 *
 *  初始化
 *
 *  @param frame      frame
 *  @param markCount  标签个数
 *
 *  @return 实例
 */
- (instancetype)initWithShowCollectionViewFrame:(CGRect)frame markCount:(NSInteger)markCount;

@end

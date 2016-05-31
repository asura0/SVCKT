//
//  SVCSegmetCollectionView.h
//  SVCKit
//
//  Created by 123 on 16/5/25.
//  Copyright © 2016年 asura. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 刷新成功后的block **/
typedef void(^complete)(NSMutableArray *datasource);
/** 刷新失败的 block **/
typedef void(^failure)(NSError *error);


@protocol  SVCSegmetCollectionViewDelegate<NSObject>

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
 *  @author asura, 16-05-26
 *
 *  滑动或选中时的回调方法
 *
 *  @param index 滑动或选中的是哪一栏
 */
- (void)selectedOrEndScrolIndex:(NSInteger)index;

@end

@interface SVCSegmetCollectionView : UICollectionView

//数据源
@property (nonatomic, strong) NSMutableArray *datasource;
//代理
@property (nonatomic, assign) id <SVCSegmetCollectionViewDelegate> segmetCollectionViewDelegate;

/**
 *  @author asura, 16-05-26
 *
 *  初始化
 *
 *  @param frame      frame
 *  @param markCount  标签个数
 *
 *  @return 实例
 */
- (instancetype)initWithSVCFrame:(CGRect)frame markCount:(NSInteger)markCount markTitles:(NSArray *)markTitles;

@end

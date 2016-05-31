//
//  SVCViewController.h
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

@protocol  refreshDelegate<NSObject>

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
- (void)refreshDelegateWithNewDate:(BOOL)newData selectedIndex:(NSInteger)selectedIndex complete:(void(^)(NSMutableArray *datasource))complete failure:(void(^)(NSError *error))failure;

@end

@interface SVCViewController : UIViewController

//被导航所管理的 VC, 用它来 push
@property (nonatomic, strong) UIViewController *viewController;

@property (nonatomic, assign) id<refreshDelegate> refreshDelegate;


@end

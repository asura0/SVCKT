//
//  SVCShowCollectionViewCell.m
//  SVCKit
//
//  Created by 123 on 16/5/25.
//  Copyright © 2016年 asura. All rights reserved.
//

#import "SVCShowCollectionViewCell.h"


@implementation SVCShowCollectionViewCell

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureSubViews];
    }
    return self;
}


- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    [self configureSubViews];
}

//嵌套 VC
- (void)configureSubViews{
    if (_SVCView == nil) {
        _SVCView = [[SVCViewController alloc]init];
    }
    _SVCView.view.frame = self.bounds;
    [self.contentView addSubview:_SVCView.view];
    UIResponder *responder = self.superview.superview.nextResponder;
    if ([responder isKindOfClass:[UIViewController class]]) {
        [(UIViewController *)responder addChildViewController:_SVCView];
        _SVCView.viewController = (UIViewController *)responder;
    }
}

@end

//
//  SVCCollectionViewCell.m
//  SVCKit
//
//  Created by 123 on 16/5/26.
//  Copyright © 2016年 asura. All rights reserved.
//

#import "SVCCollectionViewCell.h"

@implementation SVCCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureSubViews];
    }
    return self;
}

- (void)setTitleLabelTextWithTitle:(NSString *)title{
    _titleLabel.text = title;
}

- (void)configureSubViews{
    _titleLabel = [[UILabel alloc]initWithFrame:self.bounds];
    [self addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end

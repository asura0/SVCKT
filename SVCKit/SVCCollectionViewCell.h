//
//  SVCCollectionViewCell.h
//  SVCKit
//
//  Created by 123 on 16/5/26.
//  Copyright © 2016年 asura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVCCollectionViewCell : UICollectionViewCell

//标题
@property (nonatomic, strong) UILabel *titleLabel;
//标题赋值
- (void)setTitleLabelTextWithTitle:(NSString *)title;

@end

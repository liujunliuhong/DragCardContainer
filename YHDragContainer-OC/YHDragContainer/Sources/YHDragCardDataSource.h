//
//  YHDragCardDataSource.h
//  YHDragContainer
//
//  Created by 银河 on 2019/10/5.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class YHDragCardContainer;
@protocol YHDragCardDataSource <NSObject>
@required;

/// 卡片总数
/// @param dragCard 容器
- (int)numberOfCountInDragCard:(YHDragCardContainer *)dragCard;

/// 每个索引对应的卡片
/// @param dragCard 容器
/// @param index 索引
- (UIView *)dragCard:(YHDragCardContainer *)dragCard indexOfCard:(int)index;
@end

NS_ASSUME_NONNULL_END

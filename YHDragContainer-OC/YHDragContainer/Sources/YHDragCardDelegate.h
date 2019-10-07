//
//  YHDragCardDelegate.h
//  YHDragContainer
//
//  Created by 银河 on 2019/10/5.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHDragCardDirection.h"
NS_ASSUME_NONNULL_BEGIN
@class YHDragCardContainer;
@protocol YHDragCardDelegate <NSObject>
@optional;

/// 显示顶层卡片的回调
/// @param dragCard 容器
/// @param card 卡片
/// @param index 索引
- (void)dragCard:(YHDragCardContainer *)dragCard didDisplayCard:(UIView *)card withIndex:(int)index;

/// 点击顶层卡片的回调
/// @param dragCard 容器
/// @param card 卡片
/// @param index 索引
- (void)dragCard:(YHDragCardContainer *)dragCard didSlectCard:(UIView *)card withIndex:(int)index;

/// 最后一个卡片滑完的回调(当`infiniteLoop`设置为`true`,也会走该回调)
/// @param dragCard 容器
/// @param card 卡片
- (void)dragCard:(YHDragCardContainer *)dragCard didFinishRemoveLastCard:(UIView *)card;

/// 顶层卡片滑出去的回调
/// @param dragCard 容器
/// @param card 卡片
/// @param index 索引
- (void)dragCard:(YHDragCardContainer *)dragCard didRemoveCard:(UIView *)card withIndex:(int)index;

/// 当前卡片的滑动位置信息的回调
/// @param dragCard 容器
/// @param card 卡片
/// @param index 索引
/// @param direction 卡片方向信息
/// @param canRemove 卡片所处的位置是否可以移除
/// 该代理可以用来干什么:
/// 1.实现在滑动过程中，控制容器外部某个控件的形变、颜色、透明度等等
/// 2、实现在滑动过程中，控制卡片内部某个按钮的形变、颜色、透明度等等(比如：右滑，like按钮逐渐显示；左滑，unlike按钮逐渐显示)
- (void)dragCard:(YHDragCardContainer *)dragCard currentCard:(UIView *)card withIndex:(int)index currentCardDirection:(YHDragCardDirection *)direction canRemove:(BOOL)canRemove;
@end

NS_ASSUME_NONNULL_END

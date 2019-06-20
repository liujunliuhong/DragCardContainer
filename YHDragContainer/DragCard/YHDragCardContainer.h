//
//  YHDragCardContainer.h
//  FrameDating
//
//  Created by apple on 2019/5/22.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHDragCardConfig.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YHDragCardDirection) {
    YHDragCardDirection_Left,
    YHDragCardDirection_Right,
    YHDragCardDirection_Default,
};

typedef NS_ENUM(NSUInteger, YHDragCardVerticalDirection) {
    YHDragCardVerticalDirection_Up,
    YHDragCardVerticalDirection_Down,
    YHDragCardVerticalDirection_Default,
};

@class YHDragCardContainer;
@protocol YHDragCardContainerDataSource <NSObject>
@required;
/**
 * 卡片总共有多少个
 */
- (int)numberOfCardWithCardContainer:(YHDragCardContainer *)cardContainer;

/**
 * 某个索引对应的View
 */
- (UIView *)cardContainer:(YHDragCardContainer *)cardContainer viewForIndex:(int)index;
@end



@protocol YHDragCardContainerDelegate <NSObject>
@optional;
/**
 * 点击某一个卡片的回调
 */
- (void)cardContainer:(YHDragCardContainer *)cardContainer didSelectedIndex:(int)index;

/**
 * 滑动到某一个索引的回调
 */
- (void)cardContainer:(YHDragCardContainer *)cardContainer didScrollToIndex:(int)index;

/**
 * 最后一个卡片滑完的回调
 */
- (void)cardContainerDidFinishDragLastCard:(YHDragCardContainer *)cardContainer;

/**
 * 卡片滑动过程中的回调(框架内部已包含动画，请不要再在外部设置动画)
 * widthRatio:  >0 右滑      <0 左滑
 * heightRatio: >0 下滑      <0 上滑
 */
- (void)cardContainer:(YHDragCardContainer *)cardContainer dragDirection:(YHDragCardDirection)dragDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio;


- (void)cardContainerDidDragOut:(YHDragCardContainer *)cardContainer withDragDirection:(YHDragCardDirection)dragDirection currentCardIndex:(int)currentCardIndex NS_UNAVAILABLE;

/**
 * 卡片滑动出去的回调
 * dragDirection:水平方向
 * verticalDragDirection:垂直方向
 * currentCardIndex:滑动出去的那张卡片的索引
 */
- (void)cardContainerDidDragOut:(YHDragCardContainer *)cardContainer withDragDirection:(YHDragCardDirection)dragDirection withVerticalDragDirection:(YHDragCardDirection)verticalDragDirection currentCardIndex:(int)currentCardIndex;

@end


/**
 * 仿探探卡牌滑动
 * 时隔2年多，再一次封装，想想当初作为小白，看到github上的卡牌滑动源码，........
 */
NS_CLASS_AVAILABLE_IOS(8_0) @interface YHDragCardContainer : UIView

@property (nonatomic, weak) id<YHDragCardContainerDataSource> dataSource;

@property (nonatomic, weak) id<YHDragCardContainerDelegate> delegate;

/**
 * 是否禁用拖动手势
 * 默认NO
 * 不影响卡片的点击事件
 */
@property (nonatomic, assign) BOOL isDisablePanGesture;

- (instancetype)initWithFrame:(CGRect)frame config:(YHDragCardConfig *)config;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 * 手动使卡牌滑到指定方向
 */
- (void)scrollToDirection:(YHDragCardDirection)direction;

/**
 * 撤销
 * 只有卡片滑出去了，才能撤销，框架内部已经做了判断
 * 如果当前卡片索引为0，则不能撤销
 */
- (void)revokeWithCardView:(UIView *)cardView fromDirection:(YHDragCardDirection)direction;

/**
 * 重新加载数据
 */
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END

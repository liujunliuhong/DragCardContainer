//
//  YHDragCardContainer.h
//  FrameDating
//
//  Created by apple on 2019/5/22.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHDragCardDataSource.h"
#import "YHDragCardDelegate.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YHDragCardRemoveDirection) {
    YHDragCardRemoveDirectionHorizontal,
    YHDragCardRemoveDirectionVertical,
};

/**
 * 仿探探卡牌滑动，OC版本
 * 框架难点:如何在滑动的过程中动态的控制下面几张卡片的位置形变(很多其他三方库都未实现该功能)
 * ps：时隔2年多，再一次封装，想想当初作为小白，看到github上的卡牌滑动源码，........
 */
NS_CLASS_AVAILABLE_IOS(8_0) @interface YHDragCardContainer : UIView

/// 数据源
@property (nonatomic, weak) id<YHDragCardDataSource> dataSource;

/// 代理
@property (nonatomic, weak) id<YHDragCardDelegate> delegate;

/// 可见卡片数量，默认3
/// 取值范围:大于0
/// 内部会根据`visibleCount`和`numberOfCount(_ dragCard: YHDragCard)`来纠正初始显示的卡片数量
@property (nonatomic, assign) int visibleCount;

/// 卡片之间的间隙，默认10.0
/// 如果小于0.0，默认0.0
/// 如果大于容器高度的一半，默认为容器高度一半
@property (nonatomic, assign) CGFloat cardSpacing;

/// 最底部那张卡片的缩放比例，默认0.8
/// 其余卡片的缩放比例会进行自动计算
/// 取值范围:0.1 - 1.0
/// 如果小于0.1，默认0.1
/// 如果大于1.0，默认1.0
@property (nonatomic, assign) CGFloat minScale;

/// 移除方向(一般情况下是水平方向移除的，但是有些设计是垂直方向移除的)
/// 默认水平方向
@property (nonatomic, assign) YHDragCardRemoveDirection removeDirection;

/// 水平方向上最大移除距离，默认屏幕宽度1/4
/// 取值范围:大于10.0
/// 如果小于10.0，默认10.0
/// 如果水平方向上能够移除卡片，请设置该属性的值
@property (nonatomic, assign) CGFloat horizontalRemoveDistance;

/// 水平方向上最大移除速度，默认1000.0
/// 取值范围:大于100.0。如果小于100.0，默认100.0
/// 如果水平方向上能够移除卡片，请设置该属性的值
@property (nonatomic, assign) CGFloat horizontalRemoveVelocity;

/// 垂直方向上最大移除距离，默认屏幕高度1/4
/// 取值范围:大于50.0
/// 如果小于50.0，默认50.0
/// 如果垂直方向上能够移除卡片，请设置该属性的值
@property (nonatomic, assign) CGFloat verticalRemoveDistance;

/// 垂直方向上最大移除速度，默认500.0
/// 取值范围:大于100.0。如果小于100.0，默认100.0
/// 如果垂直方向上能够移除卡片，请设置该属性的值
@property (nonatomic, assign) CGFloat verticalRemoveVelocity;

/// 侧滑角度，默认10.0度(最大会旋转10.0度)
/// 取值范围:0.0 - 90.0
/// 如果小于0.0，默认0.0
/// 如果大于90.0，默认90.0
/// 当`removeDirection`设置为`vertical`时，会忽略该属性
/// 在滑动过程中会根据`horizontalRemoveDistance`和`removeMaxAngle`来动态计算卡片的旋转角度
/// 目前我还没有遇到过在垂直方向上能移除卡片的App，因此如果上下滑动，卡片的旋转效果很小，只有在水平方向上滑动，才能观察到很明显的旋转效果
/// 因为我也不知道当垂直方向上滑动时，怎么设置卡片的旋转效果🤣
@property (nonatomic, assign) CGFloat removeMaxAngle;

/// 卡片滑动方向和纵轴之间的角度，默认5.0
/// 取值范围:5.0 - 85.0
/// 如果小于5.0，默认5.0
/// 如果大于85.0，默认85.0
/// 如果水平方向滑动能移除卡片，请把该值设置的尽量小
/// 如果垂直方向能够移除卡片，请把该值设置的大点
@property (nonatomic, assign) CGFloat demarcationAngle;

/// 是否无限滑动
@property (nonatomic, assign) BOOL infiniteLoop;

/// 是否禁用拖动(setter)
@property (nonatomic, assign) BOOL disableDrag;

/// 是否禁用卡片的点击事件(setter)
@property (nonatomic, assign) BOOL disableClick;


/// 初始化方法（目前暂时只支持纯frame布局，不支持Autolayout）
/// @param frame frame
- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// 刷新
/// @param animation 是否需要动画
- (void)reloadData:(BOOL)animation;

/// 下一张卡片
/// @param direction 方向
- (void)nextCard:(YHDragCardDirectionType)direction;

/// 撤销
/// @param direction 方向
- (void)revoke:(YHDragCardDirectionType)direction;

@end

NS_ASSUME_NONNULL_END

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
 * 仿探探卡牌滑动
 * 时隔2年多，再一次封装，想想当初作为小白，看到github上的卡牌滑动源码，........
 */
NS_CLASS_AVAILABLE_IOS(8_0) @interface YHDragCardContainer : UIView

@property (nonatomic, weak) id<YHDragCardDataSource> dataSource;
@property (nonatomic, weak) id<YHDragCardDelegate> delegate;

@property (nonatomic, assign) int visibleCount;
@property (nonatomic, assign) CGFloat cardSpacing;
@property (nonatomic, assign) CGFloat minScale;
@property (nonatomic, assign) YHDragCardRemoveDirection removeDirection;
@property (nonatomic, assign) CGFloat horizontalRemoveDistance;
@property (nonatomic, assign) CGFloat horizontalRemoveVelocity;
@property (nonatomic, assign) CGFloat verticalRemoveDistance;
@property (nonatomic, assign) CGFloat verticalRemoveVelocity;
@property (nonatomic, assign) CGFloat removeMaxAngle;
@property (nonatomic, assign) CGFloat demarcationAngle;
@property (nonatomic, assign) CGFloat infiniteLoop;

@property (nonatomic, assign) BOOL disableDrag;
@property (nonatomic, assign) BOOL disableClick;


- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


@end

NS_ASSUME_NONNULL_END

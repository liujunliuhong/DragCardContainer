//
//  YHDragCardDirection.h
//  YHDragContainer
//
//  Created by 银河 on 2019/10/5.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 卡片方向
typedef NS_ENUM(NSUInteger, YHDragCardDirectionType) {
    YHDragCardDirectionTypeDefault,  // default
    YHDragCardDirectionTypeLeft,     // left
    YHDragCardDirectionTypeRight,    // right
    YHDragCardDirectionTypeUp,       // up
    YHDragCardDirectionTypeDown,     // down
};

@interface YHDragCardDirection : NSObject
@property (nonatomic, assign) YHDragCardDirectionType horizontal;
@property (nonatomic, assign) YHDragCardDirectionType vertical;
@property (nonatomic, assign) CGFloat horizontalRatio;
@property (nonatomic, assign) CGFloat verticalRatio;
- (instancetype)initWithHorizontal:(YHDragCardDirectionType)horizontal vertical:(YHDragCardDirectionType)vertical horizontalRatio:(CGFloat)horizontalRatio verticalRatio:(CGFloat)verticalRatio;
@end

NS_ASSUME_NONNULL_END

//
//  YHDragCardConfig.h
//  FrameDating
//
//  Created by apple on 2019/5/22.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHDragCardConfig : NSObject

/**
 * 卡片可见数量
 */
@property (nonatomic, assign) int visibleCount;

/**
 * 卡片间距
 */
@property (nonatomic, assign) CGFloat cardEdge;
/**
 * 卡片的最小缩放倍数(卡片最下面那张的缩放倍数)
 */
@property (nonatomic, assign) CGFloat minScale;

- (instancetype)init;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

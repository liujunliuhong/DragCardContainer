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

typedef NS_ENUM(NSUInteger, YHDragCardDirectionType) {
    YHDragCardDirectionTypeDefault,
    YHDragCardDirectionTypeLeft,
    YHDragCardDirectionTypeRight,
    YHDragCardDirectionTypeUp,
    YHDragCardDirectionTypeDown,
};

@interface YHDragCardDirection : NSObject
@property (nonatomic, assign) YHDragCardDirectionType horizontal;
@property (nonatomic, assign) YHDragCardDirectionType vertical;
@property (nonatomic, assign) CGFloat horizontalRatio;
@property (nonatomic, assign) CGFloat verticalRatio;
@end

NS_ASSUME_NONNULL_END

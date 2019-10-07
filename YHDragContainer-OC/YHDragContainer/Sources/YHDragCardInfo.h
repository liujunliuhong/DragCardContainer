//
//  YHDragCardInfo.h
//  YHDragContainer
//
//  Created by 银河 on 2019/10/5.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 存储卡片的位置信息
@interface YHDragCardStableInfo : NSObject
@property (nonatomic) CGAffineTransform transform;
@property (nonatomic) CGRect frame;
- (instancetype)initWithTransform:(CGAffineTransform)transform frame:(CGRect)frame;
@end


/// 存储卡片的位置信息
@interface YHDragCardInfo : YHDragCardStableInfo
@property (nonatomic, strong) UIView *card;
- (instancetype)initWithCard:(UIView *)card transform:(CGAffineTransform)transform frame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END

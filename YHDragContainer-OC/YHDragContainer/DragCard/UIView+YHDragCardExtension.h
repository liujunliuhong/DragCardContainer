//
//  UIView+YHDragCardExtension.h
//  YHDragContainer
//
//  Created by 银河 on 2019/10/5.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (YHDragCardExtension)
@property (nonatomic, strong) UIPanGestureRecognizer *yh_drag_card_panGesture;
@property (nonatomic, strong) UITapGestureRecognizer *yh_drag_card_tapGesture;
@end

NS_ASSUME_NONNULL_END

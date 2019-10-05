//
//  UIView+YHDragCardExtension.m
//  YHDragContainer
//
//  Created by 银河 on 2019/10/5.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "UIView+YHDragCardExtension.h"
#import <objc/message.h>

static const char *pan_gesture_key = "com.yinhe.yh_dragcontainer.pangesture";
static const char *tap_gesture_key = "com.yinhe.yh_dragcontainer.tapgesture";

@implementation UIView (YHDragCardExtension)

- (void)setYh_drag_card_panGesture:(UIPanGestureRecognizer *)yh_drag_card_panGesture{
    objc_setAssociatedObject(self, &pan_gesture_key, yh_drag_card_panGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIPanGestureRecognizer *)yh_drag_card_panGesture{
    return objc_getAssociatedObject(self, &pan_gesture_key);
}



- (void)setYh_drag_card_tapGesture:(UITapGestureRecognizer *)yh_drag_card_tapGesture{
    objc_setAssociatedObject(self, &tap_gesture_key, yh_drag_card_tapGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UITapGestureRecognizer *)yh_drag_card_tapGesture{
    return objc_getAssociatedObject(self, &tap_gesture_key);
}



@end

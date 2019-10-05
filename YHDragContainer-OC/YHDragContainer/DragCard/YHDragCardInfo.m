//
//  YHDragCardInfo.m
//  YHDragContainer
//
//  Created by 银河 on 2019/10/5.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHDragCardInfo.h"

@implementation YHDragCardStableInfo
- (instancetype)initWithTransform:(CGAffineTransform)transform frame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.transform = transform;
        self.frame = frame;
    }
    return self;
}
@end



@implementation YHDragCardInfo
- (instancetype)initWithCard:(UIView *)card transform:(CGAffineTransform)transform frame:(CGRect)frame
{
    self = [super initWithTransform:transform frame:frame];
    if (self) {
        self.card = card;
    }
    return self;
}
@end

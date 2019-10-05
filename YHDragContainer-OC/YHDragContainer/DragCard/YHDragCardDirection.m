//
//  YHDragCardDirection.m
//  YHDragContainer
//
//  Created by 银河 on 2019/10/5.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHDragCardDirection.h"

@implementation YHDragCardDirection
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.horizontal = YHDragCardDirectionTypeDefault;
        self.vertical = YHDragCardDirectionTypeDefault;
        self.horizontalRatio = 0.0;
        self.verticalRatio = 0.0;
    }
    return self;
}
@end

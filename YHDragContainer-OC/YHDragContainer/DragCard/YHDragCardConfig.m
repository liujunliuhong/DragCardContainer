//
//  YHDragCardConfig.m
//  FrameDating
//
//  Created by apple on 2019/5/22.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHDragCardConfig.h"

@interface YHDragCardConfig()

@end

@implementation YHDragCardConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.visibleCount = 3;
        self.cardEdge = 10.0;
        self.minScale = 0.8;
    }
    return self;
}

@end

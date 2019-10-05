//
//  YHDragCardDataSource.h
//  YHDragContainer
//
//  Created by 银河 on 2019/10/5.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class YHDragCardContainer;
@protocol YHDragCardDataSource <NSObject>
@required;
- (int)numberOfCountInDragCard:(YHDragCardContainer *)dragCard;
- (UIView *)dragCard:(YHDragCardContainer *)dragCard indexOfCard:(int)index;
@end

NS_ASSUME_NONNULL_END

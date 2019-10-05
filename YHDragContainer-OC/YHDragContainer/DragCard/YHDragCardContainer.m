//
//  YHDragCardContainer.m
//  FrameDating
//
//  Created by apple on 2019/5/22.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHDragCardContainer.h"
#import "UIView+YHDragCardExtension.h"
#import "YHDragCardInfo.h"

#define YHDrageContainer_ScreenWidth          [UIScreen mainScreen].bounds.size.width
#define YHDrageContainer_ScreenHeight         [UIScreen mainScreen].bounds.size.height


@interface YHDragCardContainer()
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, assign) CGPoint initialFirstCardCenter;
@property (nonatomic, strong) NSMutableArray<YHDragCardInfo *> *infos;
@property (nonatomic, strong) NSMutableArray<YHDragCardStableInfo *> *stableInfos;
@property (nonatomic, assign) BOOL isRevoking;
@property (nonatomic, assign) BOOL isNexting;
@end

@implementation YHDragCardContainer

- (void)dealloc{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.visibleCount = 3;
        self.cardSpacing = 10.0;
        self.minScale = 0.8;
        self.removeDirection = YHDragCardRemoveDirectionHorizontal;
        self.horizontalRemoveDistance = YHDrageContainer_ScreenWidth / 4.0;
        self.horizontalRemoveVelocity = 1000.0;
        self.verticalRemoveDistance = YHDrageContainer_ScreenHeight / 4.0;
        self.verticalRemoveVelocity = 500.0;
        self.removeMaxAngle = 10.0;
        self.demarcationAngle = 5.0;
        self.infiniteLoop = NO;
        
        self.currentIndex = 0;
        self.initialFirstCardCenter = CGPointZero;
        self.infos = [NSMutableArray array];
        self.stableInfos = [NSMutableArray array];
        self.isRevoking = NO;
        self.isNexting = NO;
        
    }
    return self;
}

- (void)didMoveToWindow{
    
}

#pragma mark Public Methods
- (void)reloadData:(BOOL)animation{
    [self _reloadData:animation];
}

- (void)nextCard:(YHDragCardDirectionType)direction{
    [self _nextCard:direction];
}

- (void)revoke:(YHDragCardDirectionType)direction{
    [self _revoke:direction];
}


#pragma mark Private Methods
- (void)_reloadData:(BOOL)animation{
    [self.infos enumerateObjectsUsingBlock:^(YHDragCardInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.card removeFromSuperview];
    }];
    [self.infos removeAllObjects];
    [self.stableInfos removeAllObjects];
    self.currentIndex = 0;
    
    NSAssert([self.dataSource respondsToSelector:@selector(numberOfCountInDragCard:)], @"必须实现数据源协议");
    
    int maxCount = [self.dataSource numberOfCountInDragCard:self];
    int showCount = MIN(maxCount, self.visibleCount);
    
    if (showCount <= 0) { return; }
    
    CGFloat scale = 1.0;
    if (showCount > 1) {
        scale = (1 - [self correctScale]) / (showCount - 1);
    }
    
    CGFloat cardWidth = self.bounds.size.width;
    CGFloat cardHeight = self.bounds.size.height - ((showCount - 1) * [self correctCardSpacing]);
    
    for (int index = 0; index < showCount; index ++) {
        CGFloat y = [self correctCardSpacing] * index;
        CGRect frame = CGRectMake(0, y, cardWidth, cardHeight);
        
        CGFloat tmpScale = 1.0 - (scale * index);
        CGAffineTransform transform = CGAffineTransformMakeScale(tmpScale, tmpScale);
        
        NSAssert([self.dataSource respondsToSelector:@selector(dragCard:indexOfCard:)], @"必须实现数据源协议");
                  
        UIView *card = [self.dataSource dragCard:self indexOfCard:index];
        
        card.userInteractionEnabled = NO;
        card.layer.anchorPoint = CGPointMake(0.5, 1.0);
        [self insertSubview:card atIndex:0];
        
        card.transform = CGAffineTransformIdentity;
        card.frame = frame;
        
        if (animation) {
            [UIView animateWithDuration:0.25 animations:^{
                card.transform = transform;
            } completion:nil];
        } else {
            card.transform = transform;
        }
        
        
        YHDragCardInfo *info = [[YHDragCardInfo alloc] initWithCard:card transform:transform frame:frame];
        [self.infos addObject:info];
        
        YHDragCardStableInfo *stableInfo = [[YHDragCardStableInfo alloc] initWithTransform:transform frame:frame];
        [self.stableInfos addObject:stableInfo];
        
        if (!self.disableDrag) {
            [self addPanGesture:card];
        }
        if (!self.disableClick) {
            [self addTapGesture:card];
        }
        if (index == 0) {
            self.initialFirstCardCenter = card.center;
        }
    }
    
    self.infos.firstObject.card.userInteractionEnabled = true;
    
    [self.delegate dragCard:self didDisplayCard:self.infos.firstObject.card withIndex:self.currentIndex];
}


- (void)_nextCard:(YHDragCardDirectionType)direction{
    if (_isNexting) { return; }
    switch (direction) {
        case YHDragCardDirectionTypeRight:
        {
            
        }
            break;
        case YHDragCardDirectionTypeLeft:
        {
            
        }
            break;
        case YHDragCardDirectionTypeUp:
        {
            
        }
            break;
        case YHDragCardDirectionTypeDown:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)_revoke:(YHDragCardDirectionType)direction{
    
}

- (void)horizontalNextCard:(BOOL)isRight{
    
}

- (void)verticalNextCard:(BOOL)isUp{
    
}


#pragma mark 纠正
- (CGFloat)correctScale{
    CGFloat scale = self.minScale;
    if (scale > 1.0) { scale = 1.0; }
    if (scale < 0.1) { scale = 0.1; }
    return scale;
}

- (CGFloat)correctCardSpacing{
    CGFloat spacing = self.cardSpacing;
    if (spacing < 0) { spacing = 0.0; }
    if (spacing > self.bounds.size.height / 2.0) { spacing = self.bounds.size.height / 2.0; }
}

- (CGFloat)correctRemoveMaxAngleAndToRadius{
    CGFloat angle = self.removeMaxAngle;
    if (angle < 0.0) { angle = 0.0; }
    if (angle > 90.0) { angle = 90.0; }
    return angle / 180.0 * M_PI;
}

- (CGFloat)correctHorizontalRemoveDistance{
    return self.horizontalRemoveDistance < 10.0 ? 10.0 : self.horizontalRemoveDistance;
}

- (CGFloat)correctHorizontalRemoveVelocity{
    return self.horizontalRemoveVelocity < 100.0 ? 100.0 : self.horizontalRemoveVelocity;
}

- (CGFloat)correctVerticalRemoveDistance{
    return self.verticalRemoveDistance < 50.0 ? 50.0 : self.verticalRemoveDistance;
}

- (CGFloat)correctVerticalRemoveVelocity{
    return self.verticalRemoveVelocity < 100.0 ? 100.0 : self.verticalRemoveVelocity;
}

- (CGFloat)correctDemarcationAngle{
    CGFloat angle = self.demarcationAngle;
    if (angle < 5.0) { angle = 5.0; }
    if (angle > 85.0) { angle = 85.0; }
    return angle / 180.0 * M_PI;
}

#pragma mark 手势
- (void)addPanGesture:(UIView *)card{
    [self removePanGesture:card];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [card addGestureRecognizer:pan];
    card.yh_drag_card_panGesture = pan;
}

- (void)addTapGesture:(UIView *)card{
    [self removeTapGesture:card];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [card addGestureRecognizer:tap];
    card.yh_drag_card_tapGesture = tap;
}

- (void)removePanGesture:(UIView *)card{
    [card removeGestureRecognizer:card.yh_drag_card_panGesture];
}

- (void)removeTapGesture:(UIView *)card{
    [card removeGestureRecognizer:card.yh_drag_card_tapGesture];
}

#pragma mark Action
- (void)tapGesture:(UITapGestureRecognizer *)gesture{
    
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture{
    
}









- (instancetype)initWithFrame:(CGRect)frame config:(YHDragCardConfig *)config
{
    self = [super initWithFrame:frame];
    if (self) {
        self.config = config;
        
        //self.backgroundColor = [UIColor orangeColor];
        
        self.initialFirstCardCenter = CGPointZero;
        self.loadedIndex = 0;
        self.currentCards = [NSMutableArray array];
        self.activeCards = [NSMutableArray array];
        self.values = [NSMutableArray array];
    }
    return self;
}

/**
 * 刷新
 */
- (void)reloadData{
    self.initialFirstCardCenter = CGPointZero;
    self.loadedIndex = 0;
    
    [self.activeCards enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.activeCards removeAllObjects];
    
    [self.currentCards enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.currentCards removeAllObjects];
    
    [self.values removeAllObjects];
    
    self.sumCardCount = [self.dataSource numberOfCardWithCardContainer:self];
    
    if (self.sumCardCount <= 0) {
        return;
    }
    
    [self installInitialCards];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainer:didScrollToIndex:)]) {
        [self.delegate cardContainer:self didScrollToIndex:self.loadedIndex];
    }
}

/**
 * 初始化最开始Cards.
 */
- (void)installInitialCards{
    
    NSInteger visibleCount = self.sumCardCount <= self.config.visibleCount ? self.sumCardCount : self.config.visibleCount;
    
    for (int i = 0; i < visibleCount; i ++) {
        UIView *cardView = [self.dataSource cardContainer:self viewForIndex:i];
        cardView.layer.anchorPoint = CGPointMake(0.5, 1);
        cardView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - (self.config.visibleCount-1) * self.config.cardEdge);
        [self addSubview:cardView];
        [self sendSubviewToBack:cardView];
        [self.currentCards addObject:cardView];
        [self.activeCards addObject:cardView];
        //[self addPanGestureForCarView:cardView];
    }
    
    CGFloat unitScale = 1.0;
    if (self.currentCards.count > 1) {
        unitScale = (1.0 - self.config.minScale) / (self.currentCards.count - 1);
    }
    
    for (int i = 0; i < self.currentCards.count; i++) {
        UIView *cardView = [self.currentCards objectAtIndex:i];
        cardView.transform = CGAffineTransformIdentity;
        CGRect frame = cardView.frame;
        frame.origin.y += self.config.cardEdge * i;
        cardView.frame = frame;
        cardView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1 - (unitScale * i), (1 - unitScale * i));
        if (i == 0) {
            self.initialFirstCardCenter = cardView.center;
        }
        CGAffineTransform tmpTransform = cardView.transform;
        NSValue *value1 = [NSValue value:&tmpTransform withObjCType:@encode(CGAffineTransform)];
        NSValue *value2 = [NSValue valueWithCGRect:cardView.frame];
        [self.values addObject:@[value1, value2]]; // 数组最后一个在界面的最下面
    }
    
    [self addPanGestureForCarView:self.currentCards.firstObject];
    [self addTapGestureForCarView:self.currentCards.firstObject];
}

/**
 * 根据指定方向滑动
 */
- (void)scrollToDirection:(YHDragCardDirection)direction{
    if (direction == YHDragCardDirection_Default) {
        return;
    }
    if (self.loadedIndex >= self.sumCardCount) {
        return;
    }
    CGPoint cardCenter = CGPointZero;
    CGFloat flag = 0;
    if (direction == YHDragCardDirection_Right) {
        // 卡片往右边滑动
        cardCenter = CGPointMake(YHDrageContainer_ScreenWidth * 2, self.initialFirstCardCenter.y);
        flag = 2;
    } else if (direction == YHDragCardDirection_Left) {
        // 卡片往左边滑动
        cardCenter = CGPointMake(-YHDrageContainer_ScreenWidth, self.initialFirstCardCenter.y);
        flag = -1;
    }
    
    if (self.loadedIndex + self.config.visibleCount < self.sumCardCount) {
        [self installNext];
    }
    
    self.loadedIndex ++;
    
    if (self.loadedIndex > self.sumCardCount) {
        self.loadedIndex = self.sumCardCount;
        return;
    }
    
    if (self.loadedIndex < self.sumCardCount) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainer:didScrollToIndex:)]) {
            [self.delegate cardContainer:self didScrollToIndex:self.loadedIndex];
        }
    }
    
    UIView *cardView = self.currentCards.firstObject; // 将要移出去的CardView.
    [self.activeCards removeObject:cardView];
    [self.currentCards removeObject:cardView];
    
    [self removePanGestureForCardView:cardView];
    [self removeTapGestureForCardView:cardView];
    
    if (self.currentCards.count > 0) {
        [self addPanGestureForCarView:self.currentCards.firstObject];
        [self addTapGestureForCarView:self.currentCards.firstObject];
    }
    CGPoint tmpPoint = cardView.center;
    CGPoint tmpPoint1 = CGPointZero;
    if (direction == YHDragCardDirection_Right) {
        tmpPoint1 = CGPointMake(tmpPoint.x - 5, tmpPoint.y);
    } else if (direction == YHDragCardDirection_Left) {
        tmpPoint1 = CGPointMake(tmpPoint.x + 5, tmpPoint.y);
    }
    [UIView animateWithDuration:0.1 animations:^{
        cardView.center = tmpPoint1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.35 animations:^{
            NSArray *tmps = self.activeCards;
            if (self.activeCards.count > self.values.count) {
                tmps = [self.activeCards subarrayWithRange:NSMakeRange(0, self.values.count)];
            }
            for (int i = 0; i < tmps.count; i++) {
                CGAffineTransform tmpTransform;
                [self.values[i][0] getValue:&tmpTransform];
                CGRect rect = [self.values[i][1] CGRectValue];
                
                UIView *cardView = [tmps objectAtIndex:i];
                cardView.transform = tmpTransform;
                cardView.frame = rect;
            }
            
            CGAffineTransform translate = CGAffineTransformTranslate(CGAffineTransformIdentity, flag * 20, 0);
            cardView.transform = CGAffineTransformRotate(translate, flag * M_PI_4 / 4);
            cardView.center = cardCenter;
            
        } completion:^(BOOL finished) {
            [cardView removeFromSuperview];
        }];
    }];
    
    
    if (self.loadedIndex == self.sumCardCount) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainerDidFinishDragLastCard:)]) {
            [self.delegate cardContainerDidFinishDragLastCard:self];
        }
    }
    
    [UIView animateWithDuration:0.125 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainer:dragDirection:widthRatio:heightRatio:)]) {
            [self.delegate cardContainer:self dragDirection:self.direction widthRatio:1.0 heightRatio:1.0];
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.125 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainer:dragDirection:widthRatio:heightRatio:)]) {
                [self.delegate cardContainer:self dragDirection:self.direction widthRatio:0.0 heightRatio:0.0];
            }
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)revokeWithCardView:(UIView *)cardView fromDirection:(YHDragCardDirection)direction{
    if (direction == YHDragCardDirection_Default) {
        return;
    }
    int num = self.sumCardCount;
    if (num <= 0) {
        return;
    }
    
    if (self.loadedIndex <= 0) {
        return;
    }
    
    // 判断是否需要移除底部CardView
    BOOL isNeedRemoveBottomCard = YES;
    if (self.sumCardCount - self.loadedIndex < self.config.visibleCount) {
        isNeedRemoveBottomCard = NO;
    }
    
    self.loadedIndex --;
    
    if (self.loadedIndex > self.sumCardCount) {
        self.loadedIndex = self.sumCardCount;
        return;
    }
    
    if (self.loadedIndex < self.sumCardCount) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainer:didScrollToIndex:)]) {
            [self.delegate cardContainer:self didScrollToIndex:self.loadedIndex];
        }
    }
    
    CGPoint cardCenter = CGPointZero;
    CGFloat flag = 0;
    if (direction == YHDragCardDirection_Right) {
        // 从右边滑入
        cardCenter = CGPointMake(YHDrageContainer_ScreenWidth * 2, self.initialFirstCardCenter.y);
        flag = 2;
    } else if (direction == YHDragCardDirection_Left) {
        // 从左边滑入
        cardCenter = CGPointMake(-YHDrageContainer_ScreenWidth, self.initialFirstCardCenter.y);
        flag = -1;
    }
    
    CGAffineTransform translate = CGAffineTransformTranslate(CGAffineTransformIdentity, flag * 20, 0);
    cardView.transform = CGAffineTransformRotate(translate, flag * M_PI_4 / 4);
    cardView.center = cardCenter;
    
    
    // 把顶部card的手势移除
    if (self.currentCards.count > 0) {
        [self removePanGestureForCardView:self.currentCards.firstObject];
        [self removeTapGestureForCardView:self.currentCards.firstObject];
    }
    
    // 给cardView添加手势
    [self addPanGestureForCarView:cardView];
    [self addTapGestureForCarView:cardView];
    
    // add
    [self installRevokeCardView:cardView];
    
    
    // 最下层卡片
    UIView *bottomCardView = self.currentCards.lastObject;
    
    // 把数组中的最下层卡片移除
    if (isNeedRemoveBottomCard) {
        [self.activeCards removeObject:bottomCardView];
        [self.currentCards removeObject:bottomCardView];
    }
    
    
    
    [UIView animateWithDuration:0.35 animations:^{
        NSArray *tmps = self.activeCards;
        if (self.activeCards.count > self.values.count) {
            tmps = [self.activeCards subarrayWithRange:NSMakeRange(0, self.values.count)];
        }
        for (int i = 0; i < tmps.count; i++) {
            CGAffineTransform tmpTransform;
            [self.values[i][0] getValue:&tmpTransform];
            CGRect rect = [self.values[i][1] CGRectValue];
            
            UIView *cardView = [tmps objectAtIndex:i];
            cardView.transform = tmpTransform;
            cardView.frame = rect;
        }
    } completion:^(BOOL finished) {
        if (isNeedRemoveBottomCard) {
            [bottomCardView removeFromSuperview];
        }
    }];
}

/**
 * 添加下一张卡片
 */
- (void)installNext{
    UIView *cardView = [self.dataSource cardContainer:self viewForIndex:self.loadedIndex+self.config.visibleCount];
    cardView.layer.anchorPoint = CGPointMake(0.5, 1);
    
    CGAffineTransform tmpTransform;
    [self.values.lastObject[0] getValue:&tmpTransform];
    cardView.transform = tmpTransform;
    
    cardView.frame = [self.values.lastObject[1] CGRectValue];
    
    [self addSubview:cardView];
    [self sendSubviewToBack:cardView];
    
    [self.currentCards addObject:cardView];
    [self.activeCards addObject:cardView];
}

/**
 * 添加Revoke卡片
 */
- (void)installRevokeCardView:(UIView *)cardView{
    cardView.layer.anchorPoint = CGPointMake(0.5, 1);
    CGRect frame = [self.values.firstObject[1] CGRectValue];
    cardView.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [self addSubview:cardView];
    [self.currentCards insertObject:cardView atIndex:0];
    [self.activeCards insertObject:cardView atIndex:0];
}



/**
 * 添加拖动手势
 */
- (void)addPanGestureForCarView:(UIView *)cardView{
    if (self.isDisablePanGesture) {
        return;
    }
    UIPanGestureRecognizer *pan = objc_getAssociatedObject(cardView, &yh_drag_card_long_gesture);
    if (!pan || ![pan isKindOfClass:[UIPanGestureRecognizer class]]) {
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [cardView addGestureRecognizer:pan];
        objc_setAssociatedObject(cardView, &yh_drag_card_long_gesture, pan, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

/**
 * 移除拖动手势
 */
- (void)removePanGestureForCardView:(UIView *)cardView{
    UIPanGestureRecognizer *pan = objc_getAssociatedObject(cardView, &yh_drag_card_long_gesture);
    if (pan && [pan isKindOfClass:[UIPanGestureRecognizer class]]) {
        [cardView removeGestureRecognizer:pan];
        objc_setAssociatedObject(cardView, &yh_drag_card_long_gesture, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

/**
 * 添加单击手势
 */
- (void)addTapGestureForCarView:(UIView *)cardView{
    UITapGestureRecognizer *tap = objc_getAssociatedObject(cardView, &yh_drag_card_tap_gesture);
    if (!tap || ![tap isKindOfClass:[UITapGestureRecognizer class]]) {
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [cardView addGestureRecognizer:tap];
        objc_setAssociatedObject(cardView, &yh_drag_card_tap_gesture, tap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

/**
 * 移除单击手势
 */
- (void)removeTapGestureForCardView:(UIView *)cardView{
    UITapGestureRecognizer *tap = objc_getAssociatedObject(cardView, &yh_drag_card_tap_gesture);
    if (tap && [tap isKindOfClass:[UITapGestureRecognizer class]]) {
        [cardView removeGestureRecognizer:tap];
        objc_setAssociatedObject(cardView, &yh_drag_card_tap_gesture, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

#pragma mark ------------------ Tap手势 ------------------
- (void)tapGestureAction:(UITapGestureRecognizer *)gesture{
    if (self.loadedIndex >= self.sumCardCount) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainer:didSelectedIndex:)]) {
        [self.delegate cardContainer:self didSelectedIndex:self.loadedIndex];
    }
}

#pragma mark ------------------ Pan手势 ------------------
- (void)panGestureAction:(UIPanGestureRecognizer *)gesture{
    CGPoint point = [gesture translationInView:self];
    CGPoint velocity = [gesture velocityInView:self];
    UIView *cardView = gesture.view;
    // x轴位移比例
    CGFloat widthRatio = 0.0;
    if (self.initialFirstCardCenter.x > 0.001) {
        widthRatio = (gesture.view.center.x - self.initialFirstCardCenter.x) / (self.initialFirstCardCenter.x);
    }
    // y轴位移比例
    CGFloat heightRatio = 0.0;
    if (self.initialFirstCardCenter.y > 0.001) {
        heightRatio = (gesture.view.center.y - self.initialFirstCardCenter.y) / (self.initialFirstCardCenter.y);
    }
    
    // BEGIN
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // 添加下一个Card
        if (self.loadedIndex + self.config.visibleCount < self.sumCardCount) {
            [self installNext];
        }
        // 恢复滑动方向
        self.direction = YHDragCardDirection_Default;
        self.verticalDirection = YHDragCardVerticalDirection_Default;
        
        // 把当前手指滑动的Card从activeCards移除
        if ([self.activeCards containsObject:cardView]) {
            [self.activeCards removeObject:cardView];
        }
    }
    
    // CHANGE
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint movedPoint = CGPointMake(gesture.view.center.x + point.x, gesture.view.center.y + point.y);
        cardView.center = movedPoint;
        cardView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, (gesture.view.center.x - self.initialFirstCardCenter.x) / self.initialFirstCardCenter.x * (M_PI_4 / 12));
        [gesture setTranslation:CGPointZero inView:self];
        
        if (widthRatio >= 0.001) {
            // 右滑
            self.direction = YHDragCardDirection_Right;
        } else if (widthRatio <= -0.001) {
            // 左滑
            self.direction = YHDragCardDirection_Left;
        } else {
            // 默认
            self.direction = YHDragCardDirection_Default;
        }
        
        if (heightRatio > 0.001) {
            // 下滑
            self.verticalDirection = YHDragCardVerticalDirection_Down;
        } else if (heightRatio < -0.001) {
            // 上滑
            self.verticalDirection = YHDragCardVerticalDirection_Up;
        } else {
            // 默认
            self.verticalDirection = YHDragCardVerticalDirection_Default;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainer:dragDirection:widthRatio:heightRatio:)]) {
            [self.delegate cardContainer:self dragDirection:self.direction widthRatio:widthRatio heightRatio:heightRatio];
        }
        
        CGFloat tmpHeightRatio = ABS(heightRatio);
        CGFloat tmpWidthRatio = ABS(widthRatio);
        
        CGFloat ratio = sqrt(pow(tmpWidthRatio, 2) + pow(tmpHeightRatio, 2));
        // 改变所有Card的位置(根据x轴和y轴的位移比例来共同控制)
        [self panForChangeVisableCardsWithRatio:ratio];
    }
    
    // END
    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed) {
        CGFloat moveWidth  = (gesture.view.center.x  - self.initialFirstCardCenter.x);
        CGFloat moveHeight = (gesture.view.center.y - self.initialFirstCardCenter.y);
        CGFloat scale = 0.0;
        if (moveHeight >= -0.01 && moveHeight <= 0) {
            scale = -0.01;
        } else if (moveHeight <= 0.01 && moveHeight > 0) {
            scale = 0.01;
        } else {
            scale = moveWidth / moveHeight;
        }
        
        BOOL isDisappear = ABS(widthRatio) >= 0.8 || (sqrt(pow(velocity.x, 2) + pow(velocity.y, 2)) > 1000.0 && ABS(velocity.x) >= 1000.0);
        
        if (isDisappear) {
            // 消失
            NSArray *tmps = self.activeCards;
            if (self.activeCards.count > self.values.count) {
                tmps = [self.activeCards subarrayWithRange:NSMakeRange(0, self.values.count)];
            }
            for (int i = 0; i < tmps.count; i++) {
                CGAffineTransform tmpTransform;
                [self.values[i][0] getValue:&tmpTransform];
                CGRect rect = [self.values[i][1] CGRectValue];
                
                UIView *cardView = [tmps objectAtIndex:i];
                cardView.transform = tmpTransform;
                cardView.frame = rect;
            }
            NSInteger flag = self.direction == YHDragCardDirection_Left ? -1 : 2;
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                cardView.center = CGPointMake(YHDrageContainer_ScreenWidth * flag, YHDrageContainer_ScreenWidth * flag / scale + self.initialFirstCardCenter.y);
            } completion:^(BOOL finished) {
                [cardView removeFromSuperview];
            }];
            [UIView animateWithDuration:0.12 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainer:dragDirection:widthRatio:heightRatio:)]) {
                    [self.delegate cardContainer:self dragDirection:self.direction widthRatio:0.0 heightRatio:0.0];
                }
            } completion:^(BOOL finished) {
                
            }];
            
            [self removePanGestureForCardView:cardView];
            [self removeTapGestureForCardView:cardView];
            [self.currentCards removeObject:cardView];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainerDidDragOut:withDragDirection:withVerticalDragDirection:currentCardIndex:)]) {
                [self.delegate cardContainerDidDragOut:self withDragDirection:self.direction withVerticalDragDirection:self.verticalDirection currentCardIndex:self.loadedIndex];
            }
            
            self.loadedIndex ++;
            if (self.loadedIndex > self.sumCardCount) {
                self.loadedIndex = self.sumCardCount;
                return;
            }
            if (self.loadedIndex == self.sumCardCount) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainerDidFinishDragLastCard:)]) {
                    [self.delegate cardContainerDidFinishDragLastCard:self];
                }
            }
            if (self.loadedIndex < self.sumCardCount) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainer:didScrollToIndex:)]) {
                    [self.delegate cardContainer:self didScrollToIndex:self.loadedIndex];
                }
            }
            
            
            if (self.currentCards.count > 0) {
                [self addPanGestureForCarView:self.currentCards.firstObject];
                [self addTapGestureForCarView:self.currentCards.firstObject];
            }
        } else {
            // 复原
            
            [self.activeCards insertObject:cardView atIndex:0];
            
            if (self.loadedIndex + self.config.visibleCount < self.sumCardCount) {
                    UIView *lastView = self.currentCards.lastObject;
                    [lastView removeFromSuperview];
                    [self.currentCards removeLastObject];
                    [self.activeCards removeLastObject];
            }
            void(^animations)(void) = ^(void) {
                NSArray *tmps = self.activeCards;
                if (self.activeCards.count > self.values.count) {
                    tmps = [self.activeCards subarrayWithRange:NSMakeRange(0, self.values.count)];
                }
                
                for (int i = 0; i < tmps.count; i++) {
                    CGAffineTransform tmpTransform;
                    [self.values[i][0] getValue:&tmpTransform];
                    CGRect rect = [self.values[i][1] CGRectValue];
                    
                    UIView *cardView = [tmps objectAtIndex:i];
                    cardView.transform = tmpTransform;
                    cardView.frame = rect;
                }
            };
            [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
                animations();
            } completion:^(BOOL finished) {
                
            }];
            [UIView animateWithDuration:0.12 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainer:dragDirection:widthRatio:heightRatio:)]) {
                    [self.delegate cardContainer:self dragDirection:self.direction widthRatio:0.0 heightRatio:0.0];
                }
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

- (void)panForChangeVisableCardsWithRatio:(CGFloat)ratio{
    if (ratio >= 1) {
        ratio = 1;
    }
    if (self.activeCards.count <= 0) {
        return;
    }
    if (self.activeCards.count < self.config.visibleCount) {
        for (int i = 0; i <= self.activeCards.count - 1; i++) { // i=0其实是最顶部的card
            UIView *cardView = [self.activeCards objectAtIndex:i];
            CGAffineTransform willTransform;
            CGAffineTransform curTransform;
            [self.values[i][0] getValue:&willTransform];
            [self.values[i+1][0] getValue:&curTransform];
            
            CGRect willRect = [self.values[i][1] CGRectValue];
            CGRect curRect = [self.values[i+1][1] CGRectValue];
            
            cardView.transform = CGAffineTransformScale(CGAffineTransformIdentity, curTransform.a - (curTransform.a - willTransform.a) * ratio, curTransform.d - (curTransform.d - willTransform.d) * ratio);
            
            CGRect frame = cardView.frame;
            frame.origin.y = curRect.origin.y - (curRect.origin.y - willRect.origin.y) * ratio;
            cardView.frame = frame;
        }
        return;
    }
    
    NSArray *tmps = self.activeCards;
    if (self.activeCards.count > self.values.count) {
        tmps = [self.activeCards subarrayWithRange:NSMakeRange(0, self.values.count)];
    }
    for (int i = 0; i < tmps.count - 1; i++) { // i=0其实是最顶部的card
        UIView *cardView = [tmps objectAtIndex:i];
        CGAffineTransform willTransform;
        CGAffineTransform curTransform;
        [self.values[i][0] getValue:&willTransform];
        [self.values[i+1][0] getValue:&curTransform];
        
        CGRect willRect = [self.values[i][1] CGRectValue];
        CGRect curRect = [self.values[i+1][1] CGRectValue];
        
        cardView.transform = CGAffineTransformScale(CGAffineTransformIdentity, curTransform.a - (curTransform.a - willTransform.a) * ratio, curTransform.d - (curTransform.d - willTransform.d) * ratio);
        
        CGRect frame = cardView.frame;
        frame.origin.y = curRect.origin.y - (curRect.origin.y - willRect.origin.y) * ratio;
        cardView.frame = frame;
    }
}

#pragma mark ------------------ Setter ------------------
- (void)setIsDisablePanGesture:(BOOL)isDisablePanGesture{
    _isDisablePanGesture = isDisablePanGesture;
    if (_isDisablePanGesture) {
        [self.currentCards enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self removePanGestureForCardView:obj];
        }];
    } else {
        [self.currentCards enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addPanGestureForCarView:obj];
        }];
    }
}

@end

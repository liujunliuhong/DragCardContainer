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
/// 当前索引
/// 顶层卡片的索引(直接与用户发生交互)
@property (nonatomic, assign) int currentIndex;

/// 初始顶层卡片的位置
@property (nonatomic, assign) CGPoint initialFirstCardCenter;

/// 存储的卡片信息
@property (nonatomic, strong) NSMutableArray<YHDragCardInfo *> *infos;

/// 存储卡片位置信息(一直存在的)
@property (nonatomic, strong) NSMutableArray<YHDragCardStableInfo *> *stableInfos;

/// 是否正在撤销
/// 避免在短时间内多次调用revoke方法，必须等上一张卡片revoke完成，才能revoke下一张卡片
@property (nonatomic, assign) BOOL isRevoking;

/// 是否正在调用`nextCard`方法
/// 避免在短时间内多次调用nextCard方法，必须`nextCard`完成，才能继续下一次`nextCard`
@property (nonatomic, assign) BOOL isNexting;

@end

@implementation YHDragCardContainer

- (void)dealloc{
    //NSLog(@"%@ dealloc",NSStringFromClass([self class]));
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
    [self reloadData:NO];
}

#pragma mark Setter
- (void)setDisableDrag:(BOOL)disableDrag{
    _disableDrag = disableDrag;
    [self.infos enumerateObjectsUsingBlock:^(YHDragCardInfo * _Nonnull info, NSUInteger idx, BOOL * _Nonnull stop) {
        if (_disableDrag) {
            [self removePanGesture:info.card];
        } else {
            [self addPanGesture:info.card];
        }
    }];
}

- (void)setDisableClick:(BOOL)disableClick{
    _disableClick = disableClick;
    [self.infos enumerateObjectsUsingBlock:^(YHDragCardInfo * _Nonnull info, NSUInteger idx, BOOL * _Nonnull stop) {
        if (_disableClick) {
            [self removeTapGesture:info.card];
        } else {
            [self addTapGesture:info.card];
        }
    }];
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
    
    NSAssert(cardHeight > 0, @"请检查`cardSpacing`的取值");
    
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
        
        
        YHDragCardInfo *info = [[YHDragCardInfo alloc] initWithCard:card transform:card.transform frame:card.frame];
        [self.infos addObject:info];
        
        YHDragCardStableInfo *stableInfo = [[YHDragCardStableInfo alloc] initWithTransform:card.transform frame:card.frame];
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
    
    UIView *topCard = self.infos.firstObject.card;
    if (topCard) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(dragCard:didDisplayCard:withIndex:)]) {
            [self.delegate dragCard:self didDisplayCard:topCard withIndex:self.currentIndex];
        }
    }
}

- (void)installNextCard{
    int maxCount = [self.dataSource numberOfCountInDragCard:self];
    int showCount = MIN(maxCount, self.visibleCount);
    if (showCount <= 0) { return; }
    
    UIView *card = nil;
    
    // 判断
    if (!self.infiniteLoop) {
        if (self.currentIndex + showCount >= maxCount ) { return; } // 无剩余卡片可滑,return
        card = [self.dataSource dragCard:self indexOfCard:(self.currentIndex + showCount)];
    } else {
        if (maxCount > showCount) {
            // 无剩余卡片可以滑动，把之前滑出去的，加在最下面
            if (self.currentIndex + showCount >= maxCount) {
                card = [self.dataSource dragCard:self indexOfCard:(self.currentIndex + showCount - maxCount)];
            } else {
                // 还有剩余卡片可以滑动
                card = [self.dataSource dragCard:self indexOfCard:(self.currentIndex + showCount)];
            }
        } else {
            // 滑出去的那张，放在最下面
            card = [self.dataSource dragCard:self indexOfCard:(self.currentIndex)];
        }
    }
    
    if (!card) { return; }
    
    UIView *bottomCard = self.infos.lastObject.card;
    if (!bottomCard) { return; }
    
    card.userInteractionEnabled = NO;
    card.layer.anchorPoint = CGPointMake(0.5, 1.0);
    [self insertSubview:card atIndex:0];
    
    card.transform = CGAffineTransformIdentity;
    card.transform = bottomCard.transform;
    card.frame = bottomCard.frame;
    
    YHDragCardInfo *info = [[YHDragCardInfo alloc] initWithCard:card transform:card.transform frame:card.frame];
    [self.infos addObject:info];
    
    if (!self.disableDrag) {
        [self addPanGesture:card];
    }
    if (!self.disableClick) {
        [self addTapGesture:card];
    }
}


- (void)_nextCard:(YHDragCardDirectionType)direction{
    if (_isNexting) { return; }
    switch (direction) {
        case YHDragCardDirectionTypeRight:
        {
            [self horizontalNextCard:YES];
        }
            break;
        case YHDragCardDirectionTypeLeft:
        {
            [self horizontalNextCard:NO];
        }
            break;
        case YHDragCardDirectionTypeUp:
        {
            [self verticalNextCard:YES];
        }
            break;
        case YHDragCardDirectionTypeDown:
        {
            [self verticalNextCard:NO];
        }
            break;
        default:
            break;
    }
}

- (void)_revoke:(YHDragCardDirectionType)direction{
    __weak typeof(self) weakSelf = self;
    
    if (self.currentIndex <= 0) { return; }
    if (direction == YHDragCardDirectionTypeDefault) { return; }
    if (self.isRevoking) { return; }
    if (self.removeDirection == YHDragCardRemoveDirectionHorizontal) {
        if (direction == YHDragCardDirectionTypeUp || direction == YHDragCardDirectionTypeDown) { return; }
    }
    if (self.removeDirection == YHDragCardRemoveDirectionVertical) {
        if (direction == YHDragCardDirectionTypeLeft || direction == YHDragCardDirectionTypeRight) { return; }
    }
    
    UIView *topCard = self.infos.firstObject.card;
    if (!topCard) { return; }
    
    UIView *card = [self.dataSource dragCard:self indexOfCard:self.currentIndex - 1];
    card.userInteractionEnabled = NO;
    card.layer.anchorPoint = CGPointMake(0.5, 1.0);
    [self addSubview:card];
    
    if (!self.disableDrag) {
        [self addPanGesture:card];
    }
    if (!self.disableClick) {
        [self addTapGesture:card];
    }
    
    card.transform = CGAffineTransformIdentity;
    card.frame = topCard.frame;
    
    if (self.removeDirection == YHDragCardRemoveDirectionHorizontal) {
        CGFloat flag = 1.0;
        if (direction == YHDragCardDirectionTypeLeft) {
            flag = -1.0;
        } else if (direction == YHDragCardDirectionTypeRight) {
            flag = 1.0;
        }
        card.transform = CGAffineTransformMakeRotation([self correctRemoveMaxAngleAndToRadius] * flag);
    } else {
        // 垂直方向不做处理
        card.transform = CGAffineTransformIdentity;
    }
    
    if (self.removeDirection == YHDragCardRemoveDirectionHorizontal) {
        CGFloat flag = 2.0;
        if (direction == YHDragCardDirectionTypeLeft) {
            flag = -0.5;
        } else if (direction == YHDragCardDirectionTypeRight) {
            flag = 1.5;
        }
        CGFloat tmpWidth = YHDrageContainer_ScreenWidth * flag;
        CGFloat tmpHeight = self.initialFirstCardCenter.y - 20.0;
        card.center = CGPointMake(tmpWidth, tmpHeight);
    } else {
        CGFloat flag = 2.0;
        if (direction == YHDragCardDirectionTypeUp) {
            flag = -1.0;
        } else if (direction == YHDragCardDirectionTypeDown) {
            flag = 2.0;
        }
        CGFloat tmpWidth = self.initialFirstCardCenter.x;
        CGFloat tmpHeight = YHDrageContainer_ScreenHeight * flag;
        card.center = CGPointMake(tmpWidth, tmpHeight);
    }
    
    self.infos.firstObject.card.userInteractionEnabled = NO;
    
    YHDragCardInfo *info = [[YHDragCardInfo alloc] initWithCard:card transform:topCard.transform frame:topCard.frame];
    [self.infos insertObject:info atIndex:0];
    
    self.isRevoking = YES;
    
    void(^animation)(void) = ^() {
        card.center = weakSelf.initialFirstCardCenter;
        card.transform = CGAffineTransformIdentity;
        
        for (int index = 0; index < weakSelf.infos.count; index ++) {
            YHDragCardInfo *info = weakSelf.infos[index];
            if (weakSelf.infos.count <= weakSelf.visibleCount) {
                if (index == 0) { continue; }
            } else {
                if (index == weakSelf.infos.count - 1 || index == 0) { continue; }
            }
            
            /**********************************************************************
                           4 3  2 1 0
            stableInfos    🀫 🀫 🀫 🀫 🀫
                           
                           5 4 3  2 1 0
            infos          🀫 🀫 🀫 🀫 🀫 🀫👈这个卡片新添加的
            ***********************************************************************/
            YHDragCardStableInfo *willInfo = weakSelf.stableInfos[index];
            
            info.card.transform = willInfo.transform;
            
            CGRect frame = info.card.frame;
            frame.origin.y = willInfo.frame.origin.y;
            info.card.frame = frame;
        }
    };
    
    [UIView animateWithDuration:0.4 animations:^{
        animation();
    } completion:^(BOOL finished) {
        for (int index = 0; index < weakSelf.infos.count; index ++) {
            YHDragCardInfo *info = weakSelf.infos[index];
            if (weakSelf.infos.count <= weakSelf.visibleCount) {
                if (index == 0) { continue; }
            } else {
                if (index == weakSelf.infos.count - 1 || index == 0) { continue; }
            }
            
            YHDragCardStableInfo *willInfo = weakSelf.stableInfos[index];
            
            CGAffineTransform willTransform = willInfo.transform;
            CGRect willFrame = willInfo.frame;
            
            info.transform = willTransform;
            info.frame = willFrame;
        }
        
        UIView *bottomCard = weakSelf.infos.lastObject.card;
        if (!bottomCard) { return ; }
        
        // 移除最底部的卡片
        if (weakSelf.infos.count > weakSelf.visibleCount) {
            [bottomCard removeFromSuperview];
            [weakSelf.infos removeLastObject];
        }
        
        weakSelf.currentIndex --;
        
        card.userInteractionEnabled = YES;
        
        weakSelf.isRevoking = NO;
        
        // 显示顶层卡片的回调
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(dragCard:didDisplayCard:withIndex:)]) {
            [weakSelf.delegate dragCard:weakSelf didDisplayCard:card withIndex:weakSelf.currentIndex];
        }
    }];
    
}

- (void)horizontalNextCard:(BOOL)isRight{
    if (self.removeDirection == YHDragCardRemoveDirectionVertical) { return; }
    [self installNextCard];
    CGFloat width = 150.0;
    self.isNexting = YES;
    [self disappear:(isRight ? width : -width) verticalMoveDistance:-10.0 isAuto:YES completionBlock:nil];
}

- (void)verticalNextCard:(BOOL)isUp{
    if (self.removeDirection == YHDragCardRemoveDirectionHorizontal) { return; }
    [self installNextCard];
    self.isNexting = YES;
    [self disappear:0.0 verticalMoveDistance:(isUp ? -30.0 : 30.0) isAuto:YES completionBlock:nil];
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
    return spacing;
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
    UIView *card = self.infos.firstObject.card;
    if (!card) { return; }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragCard:didSlectCard:withIndex:)]) {
        [self.delegate dragCard:self didSlectCard:card withIndex:self.currentIndex];
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)panGesture{
    UIView *cardView = panGesture.view;
    if (!cardView) { return; }
    CGPoint movePoint = [panGesture translationInView:self];
    CGPoint velocity = [panGesture velocityInView:self];
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self installNextCard];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint currentPoint = CGPointMake(cardView.center.x + movePoint.x, cardView.center.y + movePoint.y);
            // 设置手指拖住的那张卡牌的位置
            cardView.center = currentPoint;
            
            // 垂直方向上的滑动比例
            CGFloat verticalMoveDistance = cardView.center.y - self.initialFirstCardCenter.y;
            CGFloat verticalRatio = verticalMoveDistance / [self correctVerticalRemoveDistance];
            if (verticalRatio < -1.0) {
                verticalRatio = -1.0;
            } else if (verticalRatio > 1.0) {
                verticalRatio = 1.0;
            }
            
            // 水平方向上的滑动比例
            CGFloat horizontalMoveDistance = cardView.center.x - self.initialFirstCardCenter.x;
            CGFloat horizontalRatio = horizontalMoveDistance / [self correctHorizontalRemoveDistance];
            
            if (horizontalRatio < -1.0) {
                horizontalRatio = -1.0;
            } else if (horizontalRatio > 1.0) {
                horizontalRatio = 1.0;
            }
            
            // 设置手指拖住的那张卡牌的旋转角度
            CGFloat rotationAngle = horizontalRatio * [self correctRemoveMaxAngleAndToRadius];
            cardView.transform = CGAffineTransformMakeRotation(rotationAngle);
            // 复位
            [panGesture setTranslation:CGPointZero inView:self];
            
            if (self.removeDirection == YHDragCardRemoveDirectionHorizontal) {
                [self moving:ABS(horizontalRatio)];
            } else {
                [self moving:ABS(verticalRatio)];
            }
            
            YHDragCardDirectionType horizontal = YHDragCardDirectionTypeDefault;
            YHDragCardDirectionType vertical = YHDragCardDirectionTypeDefault;
            
            if (horizontalRatio > 0.0) {
                horizontal = YHDragCardDirectionTypeRight;
            } else if (horizontalRatio < 0.0) {
                horizontal = YHDragCardDirectionTypeLeft;
            }
            if (verticalRatio > 0.0) {
                vertical = YHDragCardDirectionTypeDown;
            } else if (verticalRatio < 0.0) {
                vertical = YHDragCardDirectionTypeUp;
            }
            
            // 滑动过程中的回调
            YHDragCardDirection *direction = [[YHDragCardDirection alloc] initWithHorizontal:horizontal vertical:vertical horizontalRatio:horizontalRatio verticalRatio:verticalRatio];
            if (self.delegate && [self.delegate respondsToSelector:@selector(dragCard:currentCard:withIndex:currentCardDirection:canRemove:)]) {
                [self.delegate dragCard:self currentCard:cardView withIndex:self.currentIndex currentCardDirection:direction canRemove:NO];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGFloat horizontalMoveDistance = cardView.center.x - self.initialFirstCardCenter.x;
            CGFloat verticalMoveDistance = cardView.center.y - self.initialFirstCardCenter.y;
            if (self.removeDirection == YHDragCardRemoveDirectionHorizontal) {
                if ((ABS(horizontalMoveDistance) > self.horizontalRemoveDistance || ABS(velocity.x) > self.horizontalRemoveVelocity) &&
                    ABS(verticalMoveDistance) > 0.1 &&  // 避免分母为0
                    ABS(horizontalMoveDistance) / ABS(verticalMoveDistance) >= tan([self correctDemarcationAngle])) {
                    [self disappear:horizontalMoveDistance verticalMoveDistance:verticalMoveDistance isAuto:NO completionBlock:nil];
                } else {
                    [self restore];
                }
            } else {
                if ((ABS(verticalMoveDistance) > self.horizontalRemoveDistance || ABS(velocity.y) > self.verticalRemoveVelocity) &&
                    ABS(verticalMoveDistance) > 0.1 && // 避免分母为0
                    ABS(horizontalMoveDistance) / ABS(verticalMoveDistance) <= tan([self correctDemarcationAngle])) {
                    [self disappear:horizontalMoveDistance verticalMoveDistance:verticalMoveDistance isAuto:NO completionBlock:nil];
                } else {
                    [self restore];
                }
            }
        }
            break;
        case UIGuidedAccessErrorFailed:
        case UIGestureRecognizerStateCancelled:
        {
            [self restore];
        }
            break;
        default:
            break;
    }
}

#pragma mark Pan Gesture Methods
- (void)moving:(CGFloat)_ratio{
    CGFloat ratio = _ratio;
    if (_ratio < 0.0) {
        ratio = 0.0;
    } else if (_ratio > 1.0) {
        ratio = 1.0;
    }
    
    for (int index = 0; index < self.infos.count; index ++) {
        YHDragCardInfo *info = self.infos[index];
        if (self.infos.count <= self.visibleCount) {
            if (index == 0) { continue; }
        } else {
            if (index == 0 || index == self.infos.count - 1) { continue; }
        }
        YHDragCardInfo *willInfo = self.infos[index - 1];
        
        CGAffineTransform currentTransform = info.transform;
        CGRect currentFrame = info.frame;
        
        CGAffineTransform willTransform = willInfo.transform;
        CGRect willFrame = willInfo.frame;
        
        info.card.transform = CGAffineTransformMakeScale(currentTransform.a - (currentTransform.a - willTransform.a) * ratio, currentTransform.d - (currentTransform.d - willTransform.d) * ratio);
        
        CGRect frame = info.card.frame;
        frame.origin.y = currentFrame.origin.y - (currentFrame.origin.y - willFrame.origin.y) * ratio;
        info.card.frame = frame;
    }
}


- (void)disappear:(CGFloat)horizontalMoveDistance verticalMoveDistance:(CGFloat)verticalMoveDistance isAuto:(BOOL)isAuto completionBlock:(void(^_Nullable)(void))completionBlock{
    __weak typeof(self) weakSelf = self;
    
    void(^animation)(void) = ^(void) {
        UIView *topCard = weakSelf.infos.firstObject.card;
        if (topCard) {
            if (weakSelf.removeDirection == YHDragCardRemoveDirectionHorizontal) {
                int flag = 0;
                if (horizontalMoveDistance > 0.0) {
                    flag = 2; // 右边滑出
                } else {
                    flag = -1; // 左边滑出
                }
                CGFloat tmpWidth = YHDrageContainer_ScreenWidth * flag;
                CGFloat tmpHeight = (verticalMoveDistance / horizontalMoveDistance * tmpWidth) + weakSelf.initialFirstCardCenter.y;
                topCard.center = CGPointMake(tmpWidth, tmpHeight);
            } else {
                int flag = 0;
                if (verticalMoveDistance > 0.0) {
                    flag = 2; // 向下滑出
                } else {
                    flag = -1; // 向上滑出
                }
                CGFloat tmpHeight = YHDrageContainer_ScreenHeight * flag;
                CGFloat tmpWidth = (horizontalMoveDistance / verticalMoveDistance * tmpHeight) + weakSelf.initialFirstCardCenter.x;
                topCard.center = CGPointMake(tmpWidth, tmpHeight);
            }
        }
        // 1、infos数量小于等于visibleCount，表明不会再增加新卡片了
        // 2、infos数量大于visibleCount（infos数量最多只比visibleCount多1）
        for (int index = 0; index < weakSelf.infos.count; index ++) {
            YHDragCardInfo *info = weakSelf.infos[index];
            if (weakSelf.infos.count <= weakSelf.visibleCount) {
                if (index == 0) { continue; }
            } else {
                if (index == 0 || index == weakSelf.infos.count - 1) { continue; }
            }
            YHDragCardInfo *willInfo = weakSelf.infos[index - 1];
            info.card.transform = willInfo.transform;
            
            CGRect frame = info.card.frame;
            frame.origin.y = willInfo.frame.origin.y;
            info.card.frame = frame;
        }
    };
    
    
    if (isAuto) {
        [UIView animateWithDuration:0.2 animations:^{
            UIView *topCard = self.infos.firstObject.card;
            if (topCard) {
                if (self.removeDirection == YHDragCardRemoveDirectionHorizontal) {
                    topCard.transform = CGAffineTransformMakeRotation(horizontalMoveDistance > 0.0 ? [self correctRemoveMaxAngleAndToRadius] : -[self correctRemoveMaxAngleAndToRadius]);
                } else {
                    // 垂直方向不做处理
                }
            }
        } completion:nil];
    }
    
    if (isAuto) {
        [self zoomInAndOut:horizontalMoveDistance verticalMoveDistance:verticalMoveDistance canRemove:true];
    } else {
        [self zoomIn:true];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        animation();
    } completion:^(BOOL finished) {
        if (!finished) { return ; }
        // 交换每个info的位置信息
        for (int index = (int)self.infos.count - 1; index >= 0; index --) { // 倒叙
            YHDragCardInfo *info = self.infos[index];
            if (self.infos.count <= self.visibleCount) {
                if (index == 0) { continue; }
            } else {
                if (index == 0 || index == self.infos.count - 1) { continue; }
            }
            YHDragCardInfo *willInfo = weakSelf.infos[index - 1];
            
            CGAffineTransform willTransform = willInfo.transform;
            CGRect willFrame = willInfo.frame;
            
            info.transform = willTransform;
            info.frame = willFrame;
        }
        
        self.isNexting = NO;
        
        YHDragCardInfo *info = self.infos.firstObject;
        if (!info) { return; }
        
        [info.card removeFromSuperview];
        [self.infos removeObjectAtIndex:0];
        
        // 卡片滑出去的回调
        if (self.delegate && [self.delegate respondsToSelector:@selector(dragCard:didRemoveCard:withIndex:)]) {
            [self.delegate dragCard:self didRemoveCard:info.card withIndex:self.currentIndex];
        }
        
        // 顶部的卡片Remove
        if (self.currentIndex == [self.dataSource numberOfCountInDragCard:self] - 1) {
            // 卡片只有最后一张了，此时闭包不回调出去
            // 最后一张卡片移除出去的回调
            if (self.delegate && [self.delegate respondsToSelector:@selector(dragCard:didFinishRemoveLastCard:)]) {
                [self.delegate dragCard:self didFinishRemoveLastCard:info.card];
            }
            
            if (self.infiniteLoop) {
                UIView *tmpTopCard = self.infos.firstObject.card;
                if (tmpTopCard) {
                    self.currentIndex = 0; // 如果最后一个卡片滑出去了，且可以无限滑动，那么把索引置为0
                    tmpTopCard.userInteractionEnabled = YES;
                    if (self.delegate && [self.delegate respondsToSelector:@selector(dragCard:didDisplayCard:withIndex:)]) {
                        [self.delegate dragCard:self didDisplayCard:tmpTopCard withIndex:self.currentIndex];
                    }
                }
            }
        } else {
            // 如果不是最后一张卡片移出去，则把索引+1
            self.currentIndex ++;
            self.infos.firstObject.card.userInteractionEnabled = YES;
            // 显示当前卡片的回调
            UIView *tmpTopCard = self.infos.firstObject.card;
            if (tmpTopCard) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(dragCard:didDisplayCard:withIndex:)]) {
                    [self.delegate dragCard:self didDisplayCard:tmpTopCard withIndex:self.currentIndex];
                }
            }
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}

- (void)restore{
    [self zoomIn:NO];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.infos enumerateObjectsUsingBlock:^(YHDragCardInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.card.transform = obj.transform;
            obj.card.frame = obj.frame;
        }];
    } completion:^(BOOL finished) {
        if (!finished) { return ; }
        if (self.infos.count > self.visibleCount) {
            YHDragCardInfo *info = self.infos.lastObject;
            [info.card removeFromSuperview];
            [self.infos removeLastObject];
        }
    }];
}


#pragma mark Zoom
- (void)zoomIn:(BOOL)canRemove{
    UIView *topCard = self.infos.firstObject.card;
    if (!topCard) { return; }
    [UIView animateWithDuration:0.2 animations:^{
        YHDragCardDirection *direction = [[YHDragCardDirection alloc] initWithHorizontal:YHDragCardDirectionTypeDefault vertical:YHDragCardDirectionTypeDefault horizontalRatio:0.0 verticalRatio:0.0];
        if ([self.delegate respondsToSelector:@selector(dragCard:currentCard:withIndex:currentCardDirection:canRemove:)]) {
            [self.delegate dragCard:self currentCard:topCard withIndex:self.currentIndex currentCardDirection:direction canRemove:canRemove];
        }
    } completion:nil];
}

- (void)zoomInAndOut:(CGFloat)horizontalMoveDistance verticalMoveDistance:(CGFloat)verticalMoveDistance canRemove:(BOOL)canRemove{
    UIView *topCard = self.infos.firstObject.card;
    if (!topCard) { return; }
    
    YHDragCardDirectionType horizontal = horizontalMoveDistance > 0.0 ? YHDragCardDirectionTypeLeft : YHDragCardDirectionTypeLeft;
    YHDragCardDirectionType vertical = verticalMoveDistance > 0.0 ? YHDragCardDirectionTypeDown : YHDragCardDirectionTypeUp;
    CGFloat horizontalRatio = horizontalMoveDistance > 0.0 ? 1.0 : -1.0;
    CGFloat verticalRatio = verticalMoveDistance > 0.0 ? 1.0 : -1.0;
    
    YHDragCardDirection *direction = [[YHDragCardDirection alloc] initWithHorizontal:horizontal vertical:vertical horizontalRatio:horizontalRatio verticalRatio:verticalRatio];
    
    YHDragCardDirection *direction1 = [[YHDragCardDirection alloc] initWithHorizontal:YHDragCardDirectionTypeDefault vertical:YHDragCardDirectionTypeDefault horizontalRatio:0.0 verticalRatio:0.0];
    
    
    [UIView animateWithDuration:0.2 animations:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(dragCard:currentCard:withIndex:currentCardDirection:canRemove:)]) {
            [self.delegate dragCard:self currentCard:topCard withIndex:self.currentIndex currentCardDirection:direction canRemove:canRemove];
        }
    } completion:^(BOOL finished) {
        if (!finished) { return ; }
        // 复原
        [UIView animateWithDuration:0.2 animations:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(dragCard:currentCard:withIndex:currentCardDirection:canRemove:)]) {
                [self.delegate dragCard:self currentCard:topCard withIndex:self.currentIndex currentCardDirection:direction1 canRemove:canRemove];
            }
        } completion:nil];
    }];
}
@end

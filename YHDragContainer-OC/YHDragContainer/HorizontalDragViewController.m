//
//  HorizontalDragViewController.m
//  YHDragContainer
//
//  Created by apple on 2019/10/8.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "HorizontalDragViewController.h"
#import "YHDragCardContainer.h"

@interface HorizontalDragViewController () <YHDragCardDataSource, YHDragCardDelegate> {
    BOOL _disableDrag;
}
@property (nonatomic, strong) NSArray<NSString *> *models;
@property (nonatomic, strong) YHDragCardContainer *card;
@property (nonatomic, strong) UIBarButtonItem *reloadItem;
@property (nonatomic, strong) UIButton *revokeButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *disableButton;
@property (nonatomic, strong) UIView *stateView;
@end

@implementation HorizontalDragViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.models = @[@"水星",
                    @"金星",
                    @"地球",
                    @"火星",
                    @"木星"];
    
    self.navigationItem.rightBarButtonItem = self.reloadItem;
    
    [self.view addSubview:self.card];
    [self.view addSubview:self.revokeButton];
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.disableButton];
    [self.view addSubview:self.stateView];
}

#pragma mark YHDragCardDataSource
- (int)numberOfCountInDragCard:(YHDragCardContainer *)dragCard{
    return (int)self.models.count;
}

- (UIView *)dragCard:(YHDragCardContainer *)dragCard indexOfCard:(int)index{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize:50];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor orangeColor];
    label.layer.cornerRadius = 5.0;
    label.layer.borderWidth = 1.0;
    label.layer.borderColor = [UIColor blackColor].CGColor;
    label.layer.masksToBounds = YES;
    label.text = [NSString stringWithFormat:@"%d -- %@", index, self.models[index]];
    return label;
}

#pragma mark YHDragCardDelegate
- (void)dragCard:(YHDragCardContainer *)dragCard didDisplayCard:(UIView *)card withIndex:(int)index{
    self.navigationItem.title = [NSString stringWithFormat:@"%d/%d", index + 1, (int)self.models.count];
}

- (void)dragCard:(YHDragCardContainer *)dragCard didSlectCard:(UIView *)card withIndex:(int)index{
    NSLog(@"点击卡片索引:%d", index);
}

- (void)dragCard:(YHDragCardContainer *)dragCard didRemoveCard:(UIView *)card withIndex:(int)index{
    NSLog(@"索引为%d的卡片滑出去了", index);
}

- (void)dragCard:(YHDragCardContainer *)dragCard didFinishRemoveLastCard:(UIView *)card{
    NSLog(@"最后一张卡片滑出去了");
    [self reload];
}

- (void)dragCard:(YHDragCardContainer *)dragCard currentCard:(UIView *)card withIndex:(int)index currentCardDirection:(YHDragCardDirection *)direction canRemove:(BOOL)canRemove{
    CGFloat ratio = ABS(direction.horizontalRatio) * 0.2 + 1.0;
    self.stateView.transform = CGAffineTransformMakeScale(ratio, ratio);
}

#pragma mark Action
// 刷新
- (void)reload{
    [self.card reloadData:YES];
}

// 撤销
- (void)revokeAction{
    [self.card revoke:YHDragCardDirectionTypeLeft]; // 从左边撤销
}

// 下一张
- (void)nextAction{
    [self.card nextCard:YHDragCardDirectionTypeRight]; // 从右边滑出去
}

// 禁用拖动&&启用拖动
- (void)disableDragAction{
    _disableDrag = !_disableDrag;
    [self setDisableDragButtonState];
    
    self.card.disableDrag = _disableDrag;
}

- (void)setDisableDragButtonState{
    NSString *title = @"";
    if (_disableDrag) {
        title = @"启用拖动手势";
    } else {
        title = @"禁用拖动手势";
    }
    [self.disableButton setTitle:title forState:UIControlStateNormal];
}
#pragma mark Getter
- (YHDragCardContainer *)card{
    if (!_card) {
        _card = [[YHDragCardContainer alloc] initWithFrame:CGRectMake(50, [UIApplication sharedApplication].statusBarFrame.size.height+44+40, self.view.frame.size.width - 100, 400)];
        _card.delegate = self;
        _card.dataSource = self;
        _card.minScale = 0.9;
        _card.removeDirection = YHDragCardRemoveDirectionHorizontal;
    }
    return _card;
}

- (UIBarButtonItem *)reloadItem{
    if (!_reloadItem) {
        _reloadItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(reload)];
    }
    return _reloadItem;
}

- (UIButton *)revokeButton{
    if (!_revokeButton) {
        _revokeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_revokeButton setTitle:@"撤销" forState:UIControlStateNormal];
        _revokeButton.backgroundColor = [UIColor grayColor];
        [_revokeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _revokeButton.frame = CGRectMake(30, self.card.frame.origin.y + self.card.frame.size.height + 40, 100, 40);
        [_revokeButton addTarget:self action:@selector(revokeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _revokeButton;
}

- (UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_nextButton setTitle:@"下一张" forState:UIControlStateNormal];
        _nextButton.backgroundColor = [UIColor grayColor];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 30.0 - 100.0, self.card.frame.origin.y + self.card.frame.size.height + 40, 100, 40);
        [_nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

- (UIButton *)disableButton{
    if (!_disableButton) {
        _disableButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _disableButton.backgroundColor = [UIColor grayColor];
        [_disableButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _disableButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 120.0) / 2.0, self.card.frame.origin.y + self.card.frame.size.height + 40, 120, 40);
        [_disableButton addTarget:self action:@selector(disableDragAction) forControlEvents:UIControlEventTouchUpInside];
        [self setDisableDragButtonState];
    }
    return _disableButton;
}

- (UIView *)stateView{
    if (!_stateView) {
        _stateView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 100.0) / 2.0, self.revokeButton.frame.origin.y+self.revokeButton.frame.size.height+40, 100, 100)];
        _stateView.backgroundColor = [UIColor purpleColor];
        _stateView.layer.cornerRadius = 100.0 / 2.0;
        _stateView.layer.masksToBounds = YES;
    }
    return _stateView;
}

@end

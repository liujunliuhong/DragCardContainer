//
//  InfiniteLoopDragViewController.m
//  YHDragContainer
//
//  Created by apple on 2019/10/8.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "InfiniteLoopDragViewController.h"
#import "YHDragCardContainer.h"

@interface InfiniteLoopDragViewController () <YHDragCardDataSource, YHDragCardDelegate>
@property (nonatomic, strong) NSArray<NSString *> *models;
@property (nonatomic, strong) YHDragCardContainer *card;
@end

@implementation InfiniteLoopDragViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.models = @[@"水星",
                    @"金星",
                    @"地球",
                    @"火星",
                    @"木星"];
    
    [self.view addSubview:self.card];
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

#pragma mark Getter
- (YHDragCardContainer *)card{
    if (!_card) {
        _card = [[YHDragCardContainer alloc] initWithFrame:CGRectMake(50, [UIApplication sharedApplication].statusBarFrame.size.height+44+40, self.view.frame.size.width - 100, 400)];
        _card.delegate = self;
        _card.dataSource = self;
        _card.minScale = 0.9;
        _card.removeDirection = YHDragCardRemoveDirectionHorizontal;
        _card.infiniteLoop = YES; // 无限滑动
    }
    return _card;
}


@end

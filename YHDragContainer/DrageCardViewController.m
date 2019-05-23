//
//  DrageCardViewController.m
//  YHDragContainer
//
//  Created by 银河 on 2019/5/23.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "DrageCardViewController.h"
#import "YHDragCardContainer.h"

#define RandomColor            [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

@interface DrageCardViewController () <YHDragCardContainerDataSource, YHDragCardContainerDelegate>
@property (nonatomic, strong) YHDragCardContainer *dragContainer;
@property (nonatomic, strong) UIView *testView;

@end

@implementation DrageCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dragContainer = [[YHDragCardContainer alloc] initWithFrame:CGRectMake(30, 100, [UIScreen mainScreen].bounds.size.width - 30.0 * 2, 400) config:[[YHDragCardConfig alloc] init]];
    self.dragContainer.dataSource = self;
    self.dragContainer.delegate = self;
    [self.view addSubview:self.dragContainer];
    
    
    [self.dragContainer reloadData];
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 addTarget:self action:@selector(left) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"左边" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 addTarget:self action:@selector(right) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitle:@"右边" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:btn2];
    
    btn1.frame = CGRectMake(20, CGRectGetMaxY(self.dragContainer.frame) + 40, 100, 50);
    btn2.frame = CGRectMake(self.view.frame.size.width - 20 - 100, CGRectGetMaxY(self.dragContainer.frame) + 40, 100, 50);
    
    self.testView = [[UIView alloc] init];
    self.testView.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height - 125);
    self.testView.bounds = CGRectMake(0, 0, 75, 75);
    self.testView.layer.cornerRadius = 75.0 / 2.0;
    self.testView.layer.masksToBounds = YES;
    self.testView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.testView];
}

- (void)left{
    [self.dragContainer scrollToDirection:YHDragCardDirection_Left];
}

- (void)right{
    [self.dragContainer scrollToDirection:YHDragCardDirection_Right];
}
#pragma mark ------------------ YHDragCardContainerDataSource ------------------
- (int)numberOfCardWithCardContainer:(YHDragCardContainer *)cardContainer{
    return 10;
}
- (UIView *)cardContainer:(YHDragCardContainer *)cardContainer viewForIndex:(int)index{
    NSLog(@"创建索引值%d的view", index);
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = RandomColor;
    return view;
}

#pragma mark ------------------ YHDragCardContainerDelegate ------------------
- (void)cardContainer:(YHDragCardContainer *)cardContainer didScrollToIndex:(int)index{
    NSLog(@"当前滑到的索引:%d", index);
}

- (void)cardContainerDidFinishDragLastCard:(YHDragCardContainer *)cardContainer{
    NSLog(@"滑完了");
    // 滑完了，重新请求数据
    [cardContainer reloadData];
}

- (void)cardContainer:(YHDragCardContainer *)cardContainer dragDirection:(YHDragCardDirection)dragDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio{
    NSLog(@"widthRatio:%f     heightRatio:%f", widthRatio, heightRatio);
    CGFloat scale = ABS(widthRatio);
    if (scale > 0.15) {
        scale = 0.15;
    } else if (scale < 0) {
        scale = 1.0;
    }
    self.testView.transform = CGAffineTransformMakeScale(1+scale, 1+scale);
}

- (void)cardContainer:(YHDragCardContainer *)cardContainer didSelectedIndex:(int)index{
    NSLog(@"点击索引:%d", index);
}

@end

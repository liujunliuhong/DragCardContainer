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

@property (nonatomic, strong) YHDragCardConfig *config;

@property (nonatomic, assign) BOOL isDisable;
@end

@implementation DrageCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.isDisable = YES;
    
    self.config = [[YHDragCardConfig alloc] init];
    
    self.dragContainer = [[YHDragCardContainer alloc] initWithFrame:CGRectMake(30, 100, [UIScreen mainScreen].bounds.size.width - 30.0 * 2, 400) config:self.config];
    self.dragContainer.dataSource = self;
    self.dragContainer.delegate = self;
    self.dragContainer.isDisablePanGesture = self.isDisable;
    [self.view addSubview:self.dragContainer];
    
    
    [self.dragContainer reloadData];
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 addTarget:self action:@selector(left) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"从左边滑出" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor purpleColor];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 addTarget:self action:@selector(right) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitle:@"从右边滑出" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor orangeColor];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    
    btn1.frame = CGRectMake(0, CGRectGetMaxY(self.dragContainer.frame) + 40, 120, 50);
    btn2.frame = CGRectMake(self.view.frame.size.width - 20 - 100, CGRectGetMaxY(self.dragContainer.frame) + 40, 120, 50);
    
    self.testView = [[UIView alloc] init];
    self.testView.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height - 125);
    self.testView.bounds = CGRectMake(0, 0, 75, 75);
    self.testView.layer.cornerRadius = 75.0 / 2.0;
    self.testView.layer.masksToBounds = YES;
    self.testView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.testView];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 addTarget:self action:@selector(revoke) forControlEvents:UIControlEventTouchUpInside];
    btn3.center = CGPointMake(self.view.frame.size.width / 2.0, btn1.center.y);
    btn3.bounds = CGRectMake(0, 0, 120, 50);
    [btn3 setTitle:@"撤销" forState:UIControlStateNormal];
    btn3.backgroundColor = [UIColor redColor];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn4 addTarget:self action:@selector(disableSwitch:) forControlEvents:UIControlEventTouchUpInside];
    btn4.center = CGPointMake(self.view.frame.size.width / 2.0, btn3.center.y + 25+25+25);
    btn4.bounds = CGRectMake(0, 0, 250, 50);
    btn4.backgroundColor = [UIColor grayColor];
    [btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn4.tag = 200;
    [self.view addSubview:btn4];
    
    [self setDisableSwitchState];
}





- (void)left{
    [self.dragContainer scrollToDirection:YHDragCardDirection_Left];
}

- (void)right{
    [self.dragContainer scrollToDirection:YHDragCardDirection_Right];
}

- (void)revoke{
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = RandomColor;
    [self.dragContainer revokeWithCardView:cardView fromDirection:YHDragCardDirection_Right];
}


- (void)disableSwitch:(UIButton *)sender{
    self.isDisable = !self.isDisable;
    self.dragContainer.isDisablePanGesture = self.isDisable;
    [self setDisableSwitchState];
}

- (void)setDisableSwitchState{
    UIButton *btn = (UIButton *)[self.view viewWithTag:200];
    if (self.isDisable) {
        [btn setTitle:@"拖动手势已禁用" forState:UIControlStateNormal];
    } else {
        [btn setTitle:@"拖动手势已开启" forState:UIControlStateNormal];
    }
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
    self.navigationItem.title = [NSString stringWithFormat:@"%d/%d", index+1, 10];
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

- (void)cardContainerDidDragOut:(YHDragCardContainer *)cardContainer withDragDirection:(YHDragCardDirection)dragDirection withVerticalDragDirection:(YHDragCardDirection)verticalDragDirection currentCardIndex:(int)currentCardIndex{
    
}

- (void)cardContainer:(YHDragCardContainer *)cardContainer didSelectedIndex:(int)index{
    NSLog(@"点击索引:%d", index);
}

@end

//
//  OCDemoViewController.m
//  YHDragContainer
//
//  Created by apple on 2020/4/21.
//  Copyright © 2020 yinhe. All rights reserved.
//

#import "OCDemoViewController.h"
#import "YHDragContainer-Swift.h"

@interface OCDemoViewController () <YHDragCardDelegate, YHDragCardDataSource>
@property (nonatomic, strong) YHDragCard *card;
@property (nonatomic, strong) NSArray<NSString *> *models;
@end

@implementation OCDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.card];
    
    [self.card reloadDataWithAnimation:YES];
}

#pragma mark - YHDragCardDataSource
- (NSInteger)numberOfCount:(YHDragCard *)dragCard{
    return self.models.count;
}

- (YHDragCardCell *)dragCard:(YHDragCard *)dragCard indexOfCell:(NSInteger)index{
    DemoCell *cell = (DemoCell *)[dragCard dequeueReusableCellWithIdentifier:@"OC_ID"];
    if (!cell) {
        cell = [[DemoCell alloc] initWithReuseIdentifier:@"OC_ID"];
    }
    NSString *text = [NSString stringWithFormat:@"索引：%ld\n\n%@", index, self.models[index]];
    [cell setWithTitle:text];
    return cell;
}

#pragma mark - YHDragCardDelegate
- (void)dragCard:(YHDragCard *)dragCard didDisplayCell:(YHDragCardCell *)cell withIndexAt:(NSInteger)index{
    NSString *text = [NSString stringWithFormat:@"当前卡片索引：%ld/%ld", index + 1, self.models.count];
    self.navigationItem.title = text;
    
}

- (void)dragCard:(YHDragCard *)dragCard didSelectIndexAt:(NSInteger)index with:(YHDragCardCell *)cell{
    NextViewController *vc = [[NextViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getter
- (YHDragCard *)card{
    if (!_card) {
        _card = [[YHDragCard alloc] initWithFrame:CGRectMake(50.0, [UIApplication sharedApplication].statusBarFrame.size.height + 44.0 + 40.0, [UIScreen mainScreen].bounds.size.width - 50.0 * 2.0, 400.0)];
        _card.delegate = self;
        _card.dataSource = self;
    }
    return _card;
}

- (NSArray<NSString *> *)models{
    if (!_models) {
        _models = @[@"水星",
                    @"金星",
                    @"地球",
                    @"火星",
                    @"木星",
                    @"土星",
                    @"天王星",
                    @"海王星",
                    @"木卫一",
                    @"土卫二"];
    }
    return _models;
}


@end

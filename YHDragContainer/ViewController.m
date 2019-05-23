//
//  ViewController.m
//  YHDragContainer
//
//  Created by 银河 on 2019/5/23.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "ViewController.h"
#import "DrageCardViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.label = [[UILabel alloc] initWithFrame:self.view.bounds];
    self.label.text = @"点击屏幕";
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont boldSystemFontOfSize:25];
    [self.view addSubview:self.label];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    DrageCardViewController *vc = [[DrageCardViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end

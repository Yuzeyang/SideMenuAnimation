//
//  ViewController.m
//  SideAnimation
//
//  Created by 宫城 on 15/10/24.
//  Copyright © 2015年 宫城. All rights reserved.
//

#import "ViewController.h"
#import "SideView.h"

@interface ViewController ()

@property (nonatomic, strong) SideView *sideView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    _sideView = [[SideView alloc] initWithTitleItems:@[@"首页",@"消息",@"推荐",@"更多",@"1",@"2",@"3"]];
    _sideView.menuBtnClick = ^(NSString *title) {
        NSLog(@"title %@",title);
    };
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(200, 300, 100, 100)];
    [btn setTitle:@"trigger" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor orangeColor]];
    [btn addTarget:self action:@selector(showSideView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panShowSideView:)];
    [self.view addGestureRecognizer:panGes];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showSideView:(id)sender {
    [_sideView trigger];
}

- (void)panShowSideView:(UIPanGestureRecognizer *)panGes {
    CGPoint translationPoint = [panGes translationInView:self.view];
    CGPoint velocityPoint = [panGes velocityInView:self.view];
    if (translationPoint.x > 0 && (velocityPoint.x > 500 && fabs(velocityPoint.y) < 600)) {
        [_sideView trigger];
    }
}

@end

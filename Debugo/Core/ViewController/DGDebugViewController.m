//
//  DGDebugViewController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGDebugViewController.h"
#import "DGTabBarController.h"
#import "DGAssistant.h"

@interface DGDebugViewController ()

@property (nonatomic, weak) DGTabBarController *tabBarController;

@property (nonatomic, weak) UIView *contentView;

@end

@implementation DGDebugViewController

- (void)dealloc {
    DGLogFunction;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(debugWindowWillShow:) name:DGDebugWindowWillShowNotificationKey object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(debugWindowDidHidden:) name:DGDebugWindowDidHiddenNotificationKey object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DGTabBarController *tabBarVC = [DGTabBarController new];
    [self addChildViewController:tabBarVC];
    [self.view addSubview:tabBarVC.view];
    self.contentView = tabBarVC.view;
    self.tabBarController = tabBarVC;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.contentView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
}

#pragma mark - notification
- (void)debugWindowWillShow:(NSNotification *)sender {
    // Window 隐藏再显示，不会调用 viewWillAppear；为了保证调用子控制器的 viewWillAppear，window 显示的时候重新添加
    if (self.contentView && !self.contentView.superview) {
        [self.view addSubview:self.contentView];
    }
}

- (void)debugWindowDidHidden:(NSNotification *)sender {
    if (self.contentView) {
        [self.contentView removeFromSuperview];
    }
}

@end

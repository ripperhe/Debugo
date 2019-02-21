//
//  DGViewController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGViewController.h"
#import "DGTabBarController.h"
#import "DGAssistant.h"

#define kTopMargin kDGStatusBarHeight
#define kBottomMargin (130.0 + kDGBottomSafeMargin)
#define kLeftMargin 5.0
#define kContentCornerRadius 13.0

@interface DGViewController ()

@property (nonatomic, weak) DGTabBarController *testTabBarController;

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIView *tapCloseView;

@end

@implementation DGViewController

- (void)dealloc
{
    DGLogFunction;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(debugWindowWillShow:) name:DGDebugWindowWillShowNotificationKey object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(debugWindowDidHidden:) name:DGDebugWindowDidHiddenNotificationKey object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isFullScreen = DGAssistant.shared.configuration.isFullScreen;
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    [self tapCloseView];
    
    DGTabBarController *tabBarVC = [DGTabBarController new];
    tabBarVC.view.clipsToBounds = YES;
    [self addChildViewController:tabBarVC];
    [self.view addSubview:tabBarVC.view];
    self.contentView = tabBarVC.view;
    self.testTabBarController = tabBarVC;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self adjustcontentView];
    
    CGFloat h = kBottomMargin > 15 ? kBottomMargin - 15 : kBottomMargin;
    self.tapCloseView.frame = CGRectMake(0, self.view.frame.size.height - h, self.view.frame.size.width, h);
}

- (void)adjustcontentView
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if (self.isFullScreen) {
        self.contentView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
        self.contentView.layer.cornerRadius = 0;
    }else{
        self.contentView.frame = CGRectMake(kLeftMargin, kTopMargin, screenSize.width - 2 * kLeftMargin, screenSize.height - kTopMargin - kBottomMargin);
        self.contentView.layer.cornerRadius = kContentCornerRadius;
    }
}

#pragma mark - notification
- (void)debugWindowWillShow:(NSNotification *)sender
{
//    DGLogFuction;
    // Window 隐藏再显示，不会调用 viewWillAppear；为了保证调用子控制器的 viewWillAppear，window 显示的时候重新添加
    if (self.contentView && !self.contentView.superview) {
        [self.view addSubview:self.contentView];
    }
}

- (void)debugWindowDidHidden:(NSNotification *)sender
{
//    DGLogFuction;
    if (self.contentView) {
        [self.contentView removeFromSuperview];
    }
}

#pragma mark - setter
- (void)setIsFullScreen:(BOOL)isFullScreen
{
    if (_isFullScreen != isFullScreen) {
        _isFullScreen = isFullScreen;
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:.25 animations:^{
            [weakSelf adjustcontentView];
        }];
    }
}

#pragma mark - getter
- (UIView *)tapCloseView
{
    if (!_tapCloseView) {
        UIView *tapCloseView = [[UIView alloc] init];
        tapCloseView.userInteractionEnabled = YES;
        // gesture
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeDebugViewController)];
        [tapCloseView addGestureRecognizer:tgr];
        [self.view addSubview:tapCloseView];
        _tapCloseView = tapCloseView;
    }
    return _tapCloseView;
}

#pragma mark - event
- (void)closeDebugViewController
{
    [DGAssistant.shared closeDebugViewControllerContainerWindow];
}

@end

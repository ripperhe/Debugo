//
//  DGQuickLoginViewController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGQuickLoginViewController.h"
#import "DGAccountViewController.h"
#import "DGNavigationController.h"
#import "DGAssistant.h"

#define kTopMargin kDGStatusBarHeight
#define kBottomMargin (130.0 + kDGBottomSafeMargin)
#define kLeftMargin 5.0
#define kContentCornerRadius 13.0

@interface DGQuickLoginViewController ()

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIView *tapCloseView;

@end

@implementation DGQuickLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    
    // content view
    DGAccountViewController *accountVC = [[DGAccountViewController alloc] initWithStyle:UITableViewStyleGrouped];
    DGNavigationController *navVC = [[DGNavigationController alloc] initWithRootViewController:accountVC];
    [self addChildViewController:navVC];
    [self.view addSubview:navVC.view];
    self.contentView = navVC.view;
    self.contentView.layer.cornerRadius = kContentCornerRadius;
    self.contentView.clipsToBounds = YES;
    
    // tap view
    [self tapCloseView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.contentView.frame = CGRectMake(kLeftMargin, kTopMargin, [UIScreen mainScreen].bounds.size.width - 2 * kLeftMargin, [UIScreen mainScreen].bounds.size.height - kTopMargin - kBottomMargin);

    CGFloat h = kBottomMargin > 15 ? kBottomMargin - 15 : kBottomMargin;
    self.tapCloseView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - h, UIScreen.mainScreen.bounds.size.width, h);
}

#pragma mark - getter
- (UIView *)tapCloseView
{
    if (!_tapCloseView) {
        UIView *tapCloseView = [[UIView alloc] init];
        tapCloseView.userInteractionEnabled = YES;
        // gesture
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeLoginViewController)];
        [tapCloseView addGestureRecognizer:tgr];
        [self.view addSubview:tapCloseView];
        _tapCloseView = tapCloseView;
    }
    return _tapCloseView;
}

#pragma mark - event
- (void)closeLoginViewController
{
    [DGAssistant.shared removeLoginViewControllerContainerWindow];
}

@end

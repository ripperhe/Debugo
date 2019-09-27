//
//  DGAccountBackViewController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGAccountBackViewController.h"
#import "DGAccountListViewController.h"
#import "DGNavigationController.h"
#import "DGAccountPlugin.h"
#import "DGAnimationDelegate.h"

#define kBottomMargin (100.0 + kDGBottomSafeMargin)
#define kLeftMargin 10

@interface DGAccountBackViewController ()

@property (nonatomic, weak) UIView *contentView;

@end

@implementation DGAccountBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    DGNavigationController *navVC = [[DGNavigationController alloc] initWithRootViewController:[DGAccountListViewController new]];
    navVC.view.layer.cornerRadius = 13.0;
    navVC.view.clipsToBounds = YES;
    navVC.view.frame = CGRectMake(kLeftMargin,
                                  kDGScreenH,
                                  [UIScreen mainScreen].bounds.size.width - 2 * kLeftMargin,
                                  [UIScreen mainScreen].bounds.size.height - kDGStatusBarHeight - kBottomMargin);
    [self addChildViewController:navVC];
    [self.view addSubview:navVC.view];
    self.contentView = navVC.view;
    
    [UIView animateWithDuration:.2 animations:^{
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
        self.contentView.dg_y = kDGStatusBarHeight + 10;
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.contentView.frame = CGRectMake(kLeftMargin,
                                        kDGStatusBarHeight + 10,
                                        [UIScreen mainScreen].bounds.size.width - 2 * kLeftMargin,
                                        [UIScreen mainScreen].bounds.size.height - kDGStatusBarHeight - kBottomMargin);
}

- (void)dismissWithAnimation:(void (^)(void))completion {
    [UIView animateWithDuration:.2 animations:^{
        self.view.backgroundColor = [UIColor clearColor];
        self.contentView.dg_y = kDGScreenH;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

@end

//
//  DGPreviewTransitionViewController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGPreviewTransitionViewController.h"

@interface DGPreviewTransitionViewController ()

@property (nonatomic, weak) UIView *containerView;
@end

/// Preview Transition View Controller was created because of a bug in QLPreviewController. It seems that QLPreviewController has issues being presented from a 3D touch peek-pop gesture and is produced an unbalanced presentation warning. By wrapping it in a container, we are solving this issue.

@implementation DGPreviewTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addChildViewController:self.quickLookPreviewController];
    [self.containerView addSubview:self.quickLookPreviewController.view];
    self.quickLookPreviewController.view.frame = self.containerView.bounds;
    [self.quickLookPreviewController didMoveToParentViewController:self];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.containerView.frame = self.view.bounds;
}

#pragma mark - getter
- (UIView *)containerView
{
    if (!_containerView) {
        UIView *containerView = [[UIView alloc] init];
        [self.view addSubview:containerView];
        _containerView = containerView;
    }
    return _containerView;
}

- (QLPreviewController *)quickLookPreviewController
{
    if (!_quickLookPreviewController) {
        QLPreviewController *quickLookPreviewController = [QLPreviewController new];
        _quickLookPreviewController = quickLookPreviewController;
    }
    return _quickLookPreviewController;
}


@end

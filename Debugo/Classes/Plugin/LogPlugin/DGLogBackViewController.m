//
//  DGLogBackViewController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGLogBackViewController.h"
#import "DGTypeListViewController.h"
#import "DGNavigationController.h"
#import "DGLogPlugin.h"
#import "DGAnimationDelegate.h"

static CGFloat const kDGLogCardInset = 18.0;
static CGFloat const kDGLogCardRadius = 16.0;

@interface DGLogBackViewController ()

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, assign) BOOL dismissing;

@end

@implementation DGLogBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIView *shadowView = [[UIView alloc] init];
    shadowView.backgroundColor = [UIColor whiteColor];
    shadowView.layer.cornerRadius = kDGLogCardRadius;
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowView.layer.shadowOpacity = 0.18;
    shadowView.layer.shadowRadius = 12;
    shadowView.layer.shadowOffset = CGSizeMake(0, 6);
    [self.view addSubview:shadowView];
    self.shadowView = shadowView;
    
    DGNavigationController *navVC = [[DGNavigationController alloc] initWithRootViewController:[DGTypeListViewController new]];
    navVC.view.backgroundColor = [UIColor whiteColor];
    navVC.view.clipsToBounds = YES;
    navVC.view.layer.cornerRadius = kDGLogCardRadius;
    [self addChildViewController:navVC];
    [self.view addSubview:navVC.view];
    self.contentView = navVC.view;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.dismissing) {
        return;
    }
    CGRect card = [self cardFrame];
    self.shadowView.frame = card;
    self.contentView.frame = card;
    self.shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.shadowView.bounds cornerRadius:kDGLogCardRadius].CGPath;
}

- (CGRect)cardFrame {
    return CGRectInset(self.view.bounds, kDGLogCardInset, kDGLogCardInset);
}

- (void)refreshHeight:(CGFloat)height {
    if (nil == self.contentView) {
        return;
    }
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)dismissWithAnimation:(void (^)(void))completion {
    self.dismissing = YES;
    [UIView animateWithDuration:.2 animations:^{
        CGRect frame = self.contentView.frame;
        frame.origin.y = CGRectGetHeight(self.view.bounds);
        self.contentView.frame = frame;
        self.shadowView.frame = frame;
        self.shadowView.alpha = 0;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

@end

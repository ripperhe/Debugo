//
//  DGTouchPluginViewController.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/12.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGTouchPluginViewController.h"
#import "DGCommon.h"
#import "DGSwitchCellView.h"
#import "DGTouchPlugin.h"

@interface DGTouchPluginViewController ()

@property (nonatomic, strong) DGSwitchCellView *switchCellView;

@end

@implementation DGTouchPluginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kDGBackgroundColor;
    
    self.switchCellView = [DGSwitchCellView dg_make:^(DGSwitchCellView * switchCellView) {
        switchCellView.label.text = @"是否开启触摸监听";
        [switchCellView.switchView setOn:[DGTouchPlugin pluginSwitch]];
        [switchCellView setSwitchValueChangedBlock:^(UISwitch * _Nonnull switchView) {
            [DGTouchPlugin setPluginSwitch:switchView.isOn];
        }];
    }];
    [self.view addSubview:self.switchCellView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.switchCellView.frame = CGRectMake(0, kDGNavigationTotalHeight + 20, kDGScreenW, [DGSwitchCellView expectHeight]);
}

@end

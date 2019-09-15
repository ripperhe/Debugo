//
//  CustomPlugin2ViewController.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/15.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "CustomPlugin2ViewController.h"
#import "CustomPlugin2.h"
#import "DGCommon.h"
#import "DGSwitchCellView.h"

@interface CustomPlugin2ViewController ()

@property (nonatomic, strong) DGSwitchCellView *switchCellView;

@end

@implementation CustomPlugin2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [CustomPlugin2 pluginName];
    self.view.backgroundColor = kDGBackgroundColor;
    
    self.switchCellView = [DGSwitchCellView dg_make:^(DGSwitchCellView * switchCellView) {
        switchCellView.label.text = @"是否开启自定义工具2";
        [switchCellView.switchView setOn:[CustomPlugin2 pluginSwitch]];
        [switchCellView setSwitchValueChangedBlock:^(UISwitch * _Nonnull switchView) {
            [CustomPlugin2 setPluginSwitch:switchView.isOn];
        }];
    }];
    [self.view addSubview:self.switchCellView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.switchCellView.frame = CGRectMake(0, kDGNavigationTotalHeight + 20, kDGScreenW, [DGSwitchCellView expectHeight]);
}

@end

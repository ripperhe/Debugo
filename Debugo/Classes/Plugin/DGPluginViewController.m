
//
//  DGPluginViewController.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/8.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGPluginViewController.h"
#import "DGAssistant.h"
#import "DGAppInfoViewController.h"
#import "DGAccountManager.h"

@interface DGPluginViewController ()

@end

@implementation DGPluginViewController

- (void)setupDatasouce {
    [self addGrid:^(DGCommonGridConfiguration * _Nonnull configuration) {
        configuration.title = @"APP信息";
        configuration.imageName = @"app";
        configuration.selectedPushViewControllerClass = DGAppInfoViewController.class;
    }];
    
    [self addGrid:^(DGCommonGridConfiguration * _Nonnull configuration) {
        configuration.title = @"快速登录";
        configuration.imageName = @"app";
        [configuration setSelectedBlock:^{
            [DGAssistant.shared closeDebugWindow];
            [DGAccountManager.shared showLoginWindow];
        }];
    }];
    
}

@end

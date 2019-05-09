//
//  DGNavigationController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGNavigationController.h"
#import "DGAssistant.h"

@interface DGNavigationController ()

@end

@implementation DGNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = !DGAssistant.shared.configuration.isShowBottomBarWhenPushed;
    }

    [super pushViewController:viewController animated:animated];
}

@end

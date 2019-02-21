//
//  LoginSuccessViewController.m
//  Debugo_Example
//
//  Created by ripper on 2018/9/21.
//  Copyright © 2018年 ripperhe. All rights reserved.
//

#import "LoginSuccessViewController.h"
#import "Debugo.h"

@interface LoginSuccessViewController ()

@end

@implementation LoginSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setHidesBackButton:YES];
    if (self.accountInfo.count) {
        self.title = self.accountInfo.allKeys.firstObject;
    }
}

- (IBAction)clickLogout:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    /**
     💥 退出成功之后发送登陆成功的通知
     * Debugo 会重新显示出 login bubble
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:DGDebugoDidLogoutSuccessNotification
                                                        object:nil];
    // 或者
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"DGDebugoDidLogoutSuccessNotification"
//                                                        object:nil];
}

@end

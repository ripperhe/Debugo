//
//  LoginViewController.m
//  Debugo_Example
//
//  Created by ripper on 2018/9/21.
//  Copyright © 2018年 ripperhe. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginSuccessViewController.h"
#import "Debugo.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)clickLogin:(id)sender {
    
    if (self.accountTF.text.length && self.passwordTF.text.length) {
        [self sendLoginRequestWithAccount:self.accountTF.text password:self.passwordTF.text];
        self.accountTF.text = @"";
        self.passwordTF.text = @"";
    }
}

- (void)sendLoginRequestWithAccount:(NSString *)account password:(NSString *)password {
    NSLog(@"LoginVC accout : %@   password : %@", account, password);
    
    // 模拟网络请求
    UIView *blackView = [[UIView alloc] initWithFrame:self.view.bounds];
    blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.7];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.center = CGPointMake(blackView.frame.size.width / 2.0, blackView.frame.size.height / 2.0);
    [indicatorView startAnimating];
    [blackView addSubview:indicatorView];
    [self.navigationController.view addSubview:blackView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // remove indicator
        [blackView removeFromSuperview];
        
        // push
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        LoginSuccessViewController *loginSuccessVC = [board instantiateViewControllerWithIdentifier:@"LoginSuccessViewController"];
        loginSuccessVC.accountInfo = @{account:password};
        [self.navigationController pushViewController:loginSuccessVC animated:YES];
        
        
        /**
         ☄️ 登陆成功之后调用登陆成功的方法，携带上账号信息
         * 1. Debugo 会关闭 login bubble
         * 2. 保存账号数据到沙盒 Library/Caches/com.ripperhe.debugo/ 内
         */
        [DGDebugo loginSuccessWithAccount:[DGAccount accountWithUsername:account password:password]];
    });
    
}


@end

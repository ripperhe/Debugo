//
//  ViewController.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/2/20.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "Debugo_Example_ObjectiveC-Swift.h"
#import <Debugo/Debugo.h>
#import <AFNetworking/AFNetworking.h>

@interface ViewController ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) UILabel *resultLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sessionManager = [AFHTTPSessionManager manager];
    [DGAFNetworkingPlugin monitorSessionManager:self.sessionManager];
    DGAFNetworkingPlugin.listModules = DGAFNetworkingListModuleURI | DGAFNetworkingListModuleResponseHeaders | DGAFNetworkingListModuleResponseBody;
    DGAlamofirePlugin.listModules = DGAFNetworkingListModuleURI | DGAFNetworkingListModuleResponseHeaders | DGAFNetworkingListModuleResponseBody;

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 248)];
    UIButton *logButton = [self headerButtonWithTitle:@"写入一条 Log" action:@selector(writeLog) y:16];
    UIButton *afnButton = [self headerButtonWithTitle:@"AFNetworking 请求" action:@selector(sendAFNetworkingRequest) y:72];
    UIButton *alamofireButton = [self headerButtonWithTitle:@"Alamofire 请求" action:@selector(sendAlamofireRequest) y:128];
    [header addSubview:logButton];
    [header addSubview:afnButton];
    [header addSubview:alamofireButton];

    UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 184, CGRectGetWidth(self.view.bounds) - 32, 48)];
    resultLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    resultLabel.font = [UIFont systemFontOfSize:13];
    resultLabel.textColor = [UIColor secondaryLabelColor];
    resultLabel.numberOfLines = 2;
    resultLabel.text = @"点击上方按钮请求 https://dummyjson.com/products";
    [header addSubview:resultLabel];
    self.resultLabel = resultLabel;

    self.tableView.tableHeaderView = header;
}

- (UIButton *)headerButtonWithTitle:(NSString *)title action:(SEL)action y:(CGFloat)y {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(16, y, CGRectGetWidth(self.view.bounds) - 32, 44);
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 8;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)writeLog {
    DGLogTypeModel *model = [DGLogTypeModel new];
    model.typeID = (int)DGLogPlugin.shared.arrayM.count + 1;
    model.dg_dic = @{
        @"message": @"来自 Example 的一条日志",
        @"time": [NSDate date].description,
    };
    [DGLogPlugin.shared addTypeModel:model];
}

- (void)updateResult:(NSString *)text {
    if (!NSThread.isMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateResult:text];
        });
        return;
    }
    self.resultLabel.text = text;
}

- (NSString *)productSummaryFromResponse:(id)responseObject stack:(NSString *)stack {
    if (![responseObject isKindOfClass:NSDictionary.class]) {
        return [NSString stringWithFormat:@"%@ 成功，但返回数据格式不符合预期", stack];
    }
    NSDictionary *json = (NSDictionary *)responseObject;
    NSArray *products = json[@"products"];
    NSUInteger count = [products isKindOfClass:NSArray.class] ? products.count : 0;
    NSNumber *total = json[@"total"];
    if ([total isKindOfClass:NSNumber.class]) {
        return [NSString stringWithFormat:@"%@ 成功，本页 %lu 个商品，共 %@ 个", stack, (unsigned long)count, total];
    }
    return [NSString stringWithFormat:@"%@ 成功，商品数 %lu", stack, (unsigned long)count];
}

- (void)sendAFNetworkingRequest {
    [self updateResult:@"AFNetworking 请求中…"];
    [self.sessionManager GET:@"https://dummyjson.com/products"
                  parameters:nil
                     headers:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self updateResult:[self productSummaryFromResponse:responseObject stack:@"AFNetworking"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self updateResult:[NSString stringWithFormat:@"AFNetworking 失败：%@", error.localizedDescription]];
    }];
}

- (void)sendAlamofireRequest {
    [self updateResult:@"Alamofire 请求中…"];
    [DGExampleNetworkClient requestProductsWithCompletion:^(NSString * _Nonnull text) {
        [self updateResult:text];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self clickGoToTestLogin];
    }
}

- (void)clickGoToTestLogin {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LoginViewController *loginVC = [board instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:loginVC animated:YES];
}

@end

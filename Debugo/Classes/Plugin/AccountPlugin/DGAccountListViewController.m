//
//  DGAccountListViewController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGAccountListViewController.h"
#import "DGAccountPlugin.h"

@interface DGAccountListViewController ()

@property (nonatomic, strong) NSMutableArray <NSArray <DGAccount *>*>*dataArray;

@end

@implementation DGAccountListViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    
    if (DGAccountPlugin.shared.configuration.isProductionEnvironment) {
        self.title = @"快速登陆 (生产环境)";
    }else{
        self.title = @"快速登陆 (开发环境)";
    }
    
    if (!self.dataArray.count) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 80)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"现在还没有账号，请添加账号~";
        self.tableView.tableFooterView = label;
    }else {
        self.tableView.tableFooterView = nil;
    }
}

- (void)close {
    [DGAccountPlugin setPluginSwitch:NO];
}

#pragma mark - data
- (NSMutableArray<NSArray<DGAccount *> *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
        NSArray *temporaryArray = DGAccountPlugin.shared.cacheAccountDic.reverseSortedValues;
        if (temporaryArray.count) {
            temporaryArray.dg_extCopyObj = @"缓存账号";
            [_dataArray addObject:temporaryArray];
        }
        
        NSArray *commonArray = DGAccountPlugin.shared.currentCommonAccountArray.copy;
        if (commonArray.count) {
            commonArray.dg_extCopyObj = @"共享账号";
            [_dataArray addObject:commonArray];
        }
    }
    return _dataArray;
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray objectAtIndex:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DGAccount *account = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.detailTextLabel.textColor = kDGHighlightColor;
    }
    cell.textLabel.text = account.username;
    cell.detailTextLabel.text = account.password;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    kDGImpactFeedback
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DGAccount *account = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [DGAccountPlugin setPluginSwitch:NO];
    if (DGAccountPlugin.shared.configuration.executeLoginBlock) {
        DGAccountPlugin.shared.configuration.executeLoginBlock(account);
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.dataArray objectAtIndex:section].dg_extCopyObj;
}

@end

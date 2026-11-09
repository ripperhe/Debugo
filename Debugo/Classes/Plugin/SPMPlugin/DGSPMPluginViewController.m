//
//  DGSPMPluginViewController.m
//  Debugo
//
//  Created by ripper on 2026/11/9.
//  Copyright © 2026 ripperhe. All rights reserved.
//

#import "DGSPMPluginViewController.h"
#import "DGSPMPlugin.h"
#import "DGCommon.h"

@interface DGSPMPluginViewController ()

@property (nonatomic, strong) NSArray<DGSPMModel *> *dataArray;

@end

@implementation DGSPMPluginViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.title = [DGSPMPlugin pluginName];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!DGBuildInfo.shared.spmResolvedFileExist) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"如需获取 Swift Package Manager 信息，进入网页查看 🚀" forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, 0, 80)];
        [button dg_addReceiverForControlEvents:UIControlEventTouchUpInside handler:^(id  _Nonnull sender) {
            NSURL *url = [NSURL URLWithString:DGBuildInfo.shared.configURL];
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }];
        self.tableView.tableFooterView = button;
        return;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:DGBuildInfo.shared.spmResolvedFileName ofType:nil];
    self.dataArray = [DGSPMPlugin parsePackageResolvedWithPath:path];
    if (!self.dataArray.count) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 80)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"没有依赖的 Swift Package~";
        self.tableView.tableFooterView = label;
        return;
    }
    
    // 仅对 GitHub 仓库尽力拉取最新版本；失败保持空白
    NSInteger totalCount = self.dataArray.count;
    __block NSInteger finishedCount = 0;
    [self.dataArray enumerateObjectsUsingBlock:^(DGSPMModel * _Nonnull package, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!package.isGitHub) {
            finishedCount++;
            if (finishedCount >= totalCount) {
                [self.tableView reloadData];
            }
            return;
        }
        dg_weakify(self)
        [DGSPMPlugin queryLatestVersionForPackage:package completion:^(NSString * _Nullable latestVersion, NSError * _Nullable error) {
            dg_strongify(self)
            if (latestVersion.length) {
                package.latestVersion = latestVersion;
            }
            finishedCount++;
            if (finishedCount >= totalCount) {
                [self.tableView reloadData];
            }
        }];
    }];
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DGSPMModel *package = [self.dataArray objectAtIndex:indexPath.row];
    
    static NSString *cellID = @"spm.cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.detailTextLabel.numberOfLines = 0;
        cell.accessoryView = [UILabel new];
    }
    
    NSString *version = package.version ?: @"—";
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", package.name, version];
    cell.detailTextLabel.text = package.location;
    
    [cell.accessoryView dg_put:^(UILabel *label) {
        label.text = nil;
        if (package.latestVersion.length) {
            NSString *current = package.resolvedVersion.length ? package.resolvedVersion : package.version;
            if (current.length &&
                [DGSPMPlugin compareVersionA:current withVersionB:package.latestVersion] == NSOrderedAscending) {
                label.textColor = kDGHighlightColor;
            } else {
                label.textColor = UIColor.grayColor;
            }
            label.text = package.latestVersion;
            [label sizeToFit];
        }
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DGSPMModel *package = [self.dataArray objectAtIndex:indexPath.row];
    NSString *url = package.location;
    if (!url.length) {
        return;
    }
    // git@github.com:owner/repo.git -> https
    if ([url.lowercaseString hasPrefix:@"git@github.com:"]) {
        NSString *path = [url substringFromIndex:@"git@github.com:".length];
        if ([path hasSuffix:@".git"]) {
            path = [path substringToIndex:path.length - 4];
        }
        url = [NSString stringWithFormat:@"https://github.com/%@", path];
    } else if ([url hasSuffix:@".git"]) {
        url = [url substringToIndex:url.length - 4];
    }
    DGLog(@"\n%@", url);
    [UIPasteboard generalPasteboard].string = url;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Packages (%lu)", (unsigned long)self.dataArray.count];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).textLabel.text = [NSString stringWithFormat:@"Packages (%lu)", (unsigned long)self.dataArray.count];
    }
}

@end

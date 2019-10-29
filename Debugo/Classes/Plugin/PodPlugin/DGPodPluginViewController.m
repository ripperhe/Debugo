//
//  DGPodPluginViewController.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/10/25.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGPodPluginViewController.h"
#import "DGPodPlugin.h"
#import "DGCommon.h"

@interface DGPodPluginViewController ()

/// podfile.lock 安装的库
@property (nonatomic, strong) NSArray<DGSpecRepoModel *> *dataArray;

@end

@implementation DGPodPluginViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.title = [DGPodPlugin pluginName];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 判断是否有 lock 文件
    if (!DGBuildInfo.shared.cocoaPodsLockFileExist) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"如需获取 CocoaPods 信息，进入网页查看 🚀" forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, 0, 80)];
        [button dg_addReceiverForControlEvents:UIControlEventTouchUpInside handler:^(id  _Nonnull sender) {
            NSURL *url = [NSURL URLWithString:DGBuildInfo.shared.configURL];
            [[UIApplication sharedApplication] openURL:url];
        }];
        self.tableView.tableFooterView = button;
        return;
    }
    
    // 解析 lock 文件
    NSString *path = [[NSBundle mainBundle] pathForResource:DGBuildInfo.shared.cocoaPodsLockFileName ofType:nil];
    self.dataArray = [DGPodPlugin parsePodfileLockWithPath:path];
    if (!self.dataArray.count || !self.dataArray.firstObject.pods.count) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 80)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"没有依赖的 CocoaPods 三方库~";
        self.tableView.tableFooterView = label;
        return;
    }
    
    // 请求 pod 最新版本
    [self.dataArray enumerateObjectsUsingBlock:^(DGSpecRepoModel * _Nonnull repoObj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (repoObj.isOfficial) {
            // cocoapods 官方库
            NSInteger totalCount = repoObj.pods.count;
            __block NSInteger currentCount = 0;
            [repoObj.pods enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, DGPodModel * _Nonnull podObj, NSUInteger idx, BOOL * _Nonnull stop) {
                dg_weakify(self)
                [DGPodPlugin queryLatestPodInfoFromCocoaPodsSpecRepoWithPodName:key completion:^(NSDictionary * _Nullable podInfo, NSError * _Nullable error) {
                    dg_strongify(self)
                    if (podInfo) {
                        NSString *version = [podInfo objectForKey:@"version"];
                        NSString *homepage = [podInfo objectForKey:@"homepage"];
                        if (version.length) {
                            podObj.latestVersion = version;
                        }
                        if (homepage.length) {
                            podObj.homepage = homepage;
                        }
                    }
                    // 无论成功失败，累计次数并刷新
                    currentCount++;
                    if (currentCount >= totalCount) {
                        [self.tableView reloadData];
                    }
                }];
            }];
        }else if (repoObj.isRemote && DGPodPlugin.shared.configuration.gitLabSpecRepoRequestInfoBlock) {
            // gitlab 私有库
            DGGitLabSpecRepoRequestInfo *reuqestInfo = DGPodPlugin.shared.configuration.gitLabSpecRepoRequestInfoBlock(repoObj.url);
            if (reuqestInfo) {
                dg_weakify(self)
                [DGPodPlugin queryLatestPodInfoFromGitLabSpecRepoWithRequestInfo:reuqestInfo completion:^(DGSpecRepoModel * _Nullable specRepo, NSError * _Nullable error) {
                    dg_strongify(self)
                    if (specRepo) {
                        [repoObj.pods enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, DGPodModel * _Nonnull podObj, NSUInteger idx, BOOL * _Nonnull stop) {
                            DGPodModel *latestPod = [specRepo.pods objectForKey:podObj.name];
                            podObj.latestVersion = latestPod.latestVersion;
                            podObj.specFilePath = latestPod.specFilePath;
                        }];
                        [self.tableView reloadData];
                    }
                }];
            }
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DGSpecRepoModel *repo = [self.dataArray objectAtIndex:section];
    return repo.pods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DGSpecRepoModel *repo = [self.dataArray objectAtIndex:indexPath.section];
    DGPodModel *pod = [repo.pods objectAtIndex:indexPath.row];
    
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.detailTextLabel.numberOfLines = 0;
        cell.accessoryView = [UILabel new];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", pod.name, pod.version];
    if (pod.subPods.count) {
        NSString *string = [NSString stringWithFormat:@"∙ %@", [NSString dg_stringByCombineComponents:pod.subPods.sortedKeys separatedString:@"\n∙ "]];
        cell.detailTextLabel.text = string;
    }else {
        cell.detailTextLabel.text = nil;
    }
    [cell.accessoryView dg_put:^(UILabel * label) {
        label.text = nil;
        if (pod.latestVersion) {
            if ([DGPodPlugin compareVersionA:pod.version withVersionB:pod.latestVersion] == NSOrderedAscending) {
                label.textColor = kDGHighlightColor;
            }else {
                label.textColor = UIColor.grayColor;
            }
            label.text = pod.latestVersion;
            [label sizeToFit];
        }
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DGSpecRepoModel *repo = [self.dataArray objectAtIndex:indexPath.section];
    DGPodModel *pod = [repo.pods objectAtIndex:indexPath.row];
    NSString *url = nil;
    if (repo.isOfficial) {
        if (pod.homepage) {
            url = pod.homepage;
        }else if (pod.name) {
            url = [NSString stringWithFormat:@"https://cocoapods.org/pods/%@", pod.name];
        }
    }else if (repo.isRemote) {
        if (pod.specFilePath) {
            url = [NSString stringWithFormat:@"%@/tree/master/%@", [repo.url substringToIndex:repo.url.length - 4], pod.specFilePath];
        }else {
            url = [NSString stringWithFormat:@"%@/tree/master/%@", [repo.url substringToIndex:repo.url.length - 4], pod.name];
        }
    }
    if (url.length) {
        DGLog(@"\n%@", url);
        // iOS 模拟器和真机剪切板不互通的问题 https://stackoverflow.com/questions/15188852/copy-and-paste-text-into-ios-simulator
        // Xcode 10 解决了这个问题：模拟器导航栏->Edit->Automatically Sync Pasteboard
        [UIPasteboard generalPasteboard].string = url;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    DGSpecRepoModel *repo = [self.dataArray objectAtIndex:section];
    return repo.url;
}

// https://stackoverflow.com/questions/18912980/uitableview-titleforheaderinsection-shows-all-caps/39504215#39504215
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        DGSpecRepoModel *repo = [self.dataArray objectAtIndex:section];
        ((UITableViewHeaderFooterView *)view).textLabel.text = repo.url;
    }
}

@end

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
    
    if (!DGBuildInfo.shared.cocoaPodsLockFileExist) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"如需获取 CcocoaPods 信息，进入网页查看 🚀" forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, 0, 80)];
        [button dg_addReceiverForControlEvents:UIControlEventTouchUpInside handler:^(id  _Nonnull sender) {
            NSURL *url = [NSURL URLWithString:DGBuildInfo.shared.configURL];
            [[UIApplication sharedApplication] openURL:url];
        }];
        self.tableView.tableFooterView = button;
        return;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:DGBuildInfo.shared.cocoaPodsLockFileName ofType:nil];
    self.dataArray = [DGPodPlugin parsePodfileLockWithPath:path];
    if (!self.dataArray.count || !self.dataArray.firstObject.pods.count) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 80)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"没有依赖的 CocoaPods 三方库~";
        self.tableView.tableFooterView = label;
    }
    
    [self.tableView reloadData];
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
        UILabel *latestLabel = [UILabel new];
        latestLabel.textColor = UIColor.greenColor;
//        latestLabel.text = @"99.99.99";
//        [latestLabel sizeToFit];
//        latestLabel.text = nil;
        cell.accessoryView = latestLabel;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", pod.name, pod.version];
    if (pod.subPods.count) {
        NSString *string = [NSString stringWithFormat:@"∙ %@", [NSString dg_stringByCombineComponents:pod.subPods.sortedKeys separatedString:@"\n∙ "]];
        cell.detailTextLabel.text = string;
    }else {
        cell.detailTextLabel.text = nil;
    }
    ((UILabel *)cell.accessoryView).text = nil;
    if (repo.isOfficial) {
        dg_weakify(cell)
        [DGPodPlugin queryLatestPodInfoFromCocoaPodsSpecRepoWithName:pod.name completion:^(NSDictionary * _Nullable podInfo, NSError * _Nullable error) {
            dg_strongify(cell)
            if (podInfo) {
                NSString *name = [podInfo objectForKey:@"name"];
                NSString *version = [podInfo objectForKey:@"version"];
                if ([cell.textLabel.text hasPrefix:name]) {
                    ((UILabel *)cell.accessoryView).text = version;
                    [((UILabel *)cell.accessoryView) sizeToFit];
                }
            }
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DGSpecRepoModel *repo = [self.dataArray objectAtIndex:indexPath.section];
    DGPodModel *pod = [repo.pods objectAtIndex:indexPath.row];
    if (repo.isOfficial) {
        if (pod.name) {
            NSString *url = [NSString stringWithFormat:@"https://cocoapods.org/pods/%@", pod.name];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }else if (repo.isRemote) {
        NSString *url = [NSString stringWithFormat:@"%@/tree/master/%@", [repo.url substringToIndex:repo.url.length - 4], pod.name];
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

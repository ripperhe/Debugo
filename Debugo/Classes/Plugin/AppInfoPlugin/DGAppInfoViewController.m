//
//  DGAppInfoViewController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGAppInfoViewController.h"
#import "DGCommon.h"
#import "DGAppInfoPlugin.h"

@interface DGAppInfoViewController ()

@property (nonatomic, strong) NSArray<DGOrderedDictionary *> *dataArray;

@end

@implementation DGAppInfoViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [DGAppInfoPlugin pluginName];
    dg_weakify(self)
    self.navigationItem.rightBarButtonItem = [[DGShareBarButtonItem alloc] initWithViewController:self shareFilePathsWhenClickedBlock:^NSArray<NSString *> * _Nonnull(DGShareBarButtonItem * _Nonnull item) {
        dg_strongify(self)
        if (!self) return nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self plistCachePath]]) {
            return @[[self plistCachePath]];
        }else {
            return nil;
        }
    }];
    [self setupDatasource];
    [self.tableView reloadData];
}

- (void)setupDatasource {
    DGOrderedDictionary *bundleDictionary = [[DGOrderedDictionary alloc] initWithKeysAndObjects:
                                             @"Bundle Name", [self getBundleInfo:@"CFBundleName"],
                                             @"Display Name", [self getBundleInfo:@"CFBundleDisplayName"],
                                             @"Identifier", [self getBundleInfo:@"CFBundleIdentifier"],
                                             @"Build", [self getBundleInfo:@"CFBundleVersion"],
                                             @"Version", [self getBundleInfo:@"CFBundleShortVersionString"],
                                             @"Deployment Target", [self getBundleInfo:@"MinimumOSVersion"],
                                             nil];
    bundleDictionary.dg_extCopyObj = @"Bundle信息";
    
    DGOrderedDictionary *deviceDictionary = [[DGOrderedDictionary alloc] initWithKeysAndObjects:
                                             @"Name", [UIDevice currentDevice].name,
                                             @"Model Identifier", DGDevice.currentDevice.identifier,
                                             @"Model Name", DGDevice.currentDevice.isSimulator?DGDevice.currentDevice.simulatorName:DGDevice.currentDevice.name,
                                             @"System Version", [NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion],
                                             @"Screen Inch",  DGDevice.currentDevice.isSimulator?DGDevice.currentDevice.simulatorScreenInch:DGDevice.currentDevice.screenInch,
                                             @"Screen Pt", [NSString stringWithFormat:@"%.0f*%.0f", [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height],
                                             @"Screen Px", [NSString stringWithFormat:@"%.0f*%.0f", [UIScreen mainScreen].nativeBounds.size.width, [UIScreen mainScreen].nativeBounds.size.height],
                                             @"Screen Scale", [NSString stringWithFormat:@"%g", [UIScreen mainScreen].scale],
                                             @"Screen Native Scale", [NSString stringWithFormat:@"%g", [UIScreen mainScreen].nativeScale],
                                             @"Current Locale", [[NSLocale currentLocale] localeIdentifier],
                                             @"Local Timezone", [[NSTimeZone localTimeZone] name],
                                             nil];
    deviceDictionary.dg_extCopyObj = @"设备信息";
    
    DGOrderedDictionary *buildDictionary = [self getBuildInfoDictionary];
    
    self.dataArray = @[bundleDictionary, deviceDictionary, buildDictionary];
    
    // 缓存plist文件到本地，方便分享
    [[NSFileManager defaultManager] removeItemAtPath:[self plistCachePath] error:nil];
    NSMutableDictionary *plistContentDic = [NSMutableDictionary dictionary];
    [self.dataArray enumerateObjectsUsingBlock:^(DGOrderedDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [plistContentDic setObject:obj.keysAndObjects forKey:obj.dg_extCopyObj];
    }];
    [plistContentDic writeToFile:[self plistCachePath] atomically:YES];
}

- (NSString *)getBundleInfo:(NSString *)key {
    NSString *value = [NSBundle.mainBundle.infoDictionary objectForKey:key];
    if (value.length) {
        return value;
    }
    return @"未知";
}

- (DGOrderedDictionary *)getBuildInfoDictionary {
    DGOrderedDictionary *buildInfoDictionary = nil;
    NSString *defaultString = @"未知";
    if (DGBuildInfo.shared.scriptVersion){
        NSString *plistUpdateTimestamp = DGBuildInfo.shared.plistUpdateTimestamp;
        if (plistUpdateTimestamp.length) {
            plistUpdateTimestamp = [[NSDate dateWithTimeIntervalSince1970:plistUpdateTimestamp.doubleValue] dg_dateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
        plistUpdateTimestamp = plistUpdateTimestamp?:defaultString;
        NSString *buildConfiguration = DGBuildInfo.shared.buildConfiguration?:defaultString;
        NSString *computerUser = DGBuildInfo.shared.computerUser?:defaultString;
        NSString *computerUUID = DGBuildInfo.shared.computerUUID?:defaultString;
        if (DGBuildInfo.shared.gitEnable) {
            NSString *gitBranch = DGBuildInfo.shared.gitBranch?:defaultString;
            NSString *gitLastCommitMessage = DGBuildInfo.shared.gitLastCommitMessage?:defaultString;
            NSString *gitLastCommitAbbreviatedHash = DGBuildInfo.shared.gitLastCommitAbbreviatedHash?:defaultString;
            NSString *gitLastCommitUser = DGBuildInfo.shared.gitLastCommitUser?:defaultString;
            NSString *gitLastCommitTimestamp = DGBuildInfo.shared.gitLastCommitTimestamp;
            if (gitLastCommitTimestamp.length) {
                gitLastCommitTimestamp = [[NSDate dateWithTimeIntervalSince1970:gitLastCommitTimestamp.doubleValue] dg_dateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            }
            gitLastCommitTimestamp = gitLastCommitTimestamp?:@"未知";
            
            buildInfoDictionary = [[DGOrderedDictionary alloc] initWithKeysAndObjects:
                                   @"Update Date", plistUpdateTimestamp,
                                   @"Build Configuration", buildConfiguration,
                                   @"Computer User", computerUser,
                                   @"Computer UUID", computerUUID,
                                   @"Git Branch", gitBranch,
                                   @"Git Last Commit Message", gitLastCommitMessage,
                                   @"Git Last Commit Hash", gitLastCommitAbbreviatedHash,
                                   @"Git Last Commit User", gitLastCommitUser,
                                   @"Git Last Commit Date", gitLastCommitTimestamp,
                                   nil];
        }else{
            buildInfoDictionary = [[DGOrderedDictionary alloc] initWithKeysAndObjects:
                                   @"Update Date", plistUpdateTimestamp,
                                   @"Build Configuration", buildConfiguration,
                                   @"Computer User", computerUser,
                                   @"Computer UUID", computerUUID,
                                   nil];
        }
    }else{
        buildInfoDictionary = [[DGOrderedDictionary alloc] initWithKeysAndObjects:
                               @"如需获取，进入网页查看 🚀", @"",
                               nil];
        buildInfoDictionary.dg_extStrongObj = @(YES);
    }
    buildInfoDictionary.dg_extCopyObj = @"编译信息";
    return buildInfoDictionary;
}

- (NSString *)plistCachePath {
    static NSString *_path = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *fileName = [NSString stringWithFormat:@"%@-app-info.plist", [self getBundleInfo:@"CFBundleName"]];
        _path = [DGCache.shared.debugoPath stringByAppendingPathComponent:fileName];
    });
    return _path;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray objectAtIndex:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        if (kDGScreenMin < 375) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.detailTextLabel.textColor = [UIColor colorWithRed:0.556863 green:0.556863 blue:0.576471 alpha:1];
            cell.detailTextLabel.numberOfLines = 0;
        }else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    DGOrderedDictionary *sectionDictionary = self.dataArray[indexPath.section];
    cell.textLabel.text = [sectionDictionary keyAtIndex:indexPath.row];
    cell.detailTextLabel.text = [sectionDictionary objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DGOrderedDictionary *sectionDictionary = self.dataArray[indexPath.section];
    NSNumber *flag = sectionDictionary.dg_extStrongObj;
    if (flag && [flag boolValue]) {
        DGLog(@"\n%@", DGBuildInfo.shared.configURL);
        NSURL *url = [NSURL URLWithString:DGBuildInfo.shared.configURL];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.dataArray[section].dg_extCopyObj;
}

// https://stackoverflow.com/questions/18912980/uitableview-titleforheaderinsection-shows-all-caps/39504215#39504215
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).textLabel.text = self.dataArray[section].dg_extCopyObj;
    }
}

@end

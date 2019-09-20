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
    bundleDictionary.dg_copyExtObj = @"Bundle信息";
    
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
    deviceDictionary.dg_copyExtObj = @"设备信息";
    
    DGOrderedDictionary *buildDictionary = [self getBuildInfoDictionary];
    
    self.dataArray = @[bundleDictionary, deviceDictionary, buildDictionary];
    
    // 缓存plist文件到本地，方便分享
    [[NSFileManager defaultManager] removeItemAtPath:[self plistCachePath] error:nil];
    NSMutableDictionary *plistContentDic = [NSMutableDictionary dictionary];
    [self.dataArray enumerateObjectsUsingBlock:^(DGOrderedDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [plistContentDic setObject:obj.keysAndObjects forKey:obj.dg_copyExtObj];
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
    /**
     Build info plist（存储在 bundle 中）以下为所有 key 值:
     * ScriptVersion                    脚本版本
     * PlistUpdateTimestamp             plist 文件更新时间（build 时间）
     * BuildConfiguration               编译配置
     * ComputerUser                     编译包的电脑 当前用户名
     * ComputerUUID                     编译包的电脑 UUID
     * GitEnable                        编译包的电脑 是否安装 git
     * GitBranch                        当前 git 分支
     * GitLastCommitAbbreviatedHash     最后一次提交的缩写 hash
     * GitLastCommitUser                最后一次提交的用户
     * GitLastCommitTimestamp           最后一次提交的时间
     */

    DGOrderedDictionary *buildInfoDictionary = nil;
    DGPlister *plister = nil;
    // build info plister (从 bundle 中获取)
    NSString *buildInfoPlistPath = [[NSBundle mainBundle] pathForResource:@"com.ripperhe.debugo.build.info" ofType:@"plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:buildInfoPlistPath]) {
        plister = [[DGPlister alloc] initWithFilePath:buildInfoPlistPath readonly:YES];
    }
    if (plister){
        NSString *(^nilOrEmptyHandler)(void) = ^(void) {
            return @"未知";
        };
        
        NSString *plistUpdateTimestamp = [plister stringForKey:@"PlistUpdateTimestamp"];
        if (plistUpdateTimestamp.length) {
            plistUpdateTimestamp = [[NSDate dateWithTimeIntervalSince1970:plistUpdateTimestamp.doubleValue] dg_dateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
        plistUpdateTimestamp = plistUpdateTimestamp?:@"未知";
        NSString *buildConfiguration = [plister stringForKey:@"BuildConfiguration" nilOrEmpty:nilOrEmptyHandler];
        NSString *computerUser = [plister stringForKey:@"ComputerUser" nilOrEmpty:nilOrEmptyHandler];
        NSString *computerUUID = [plister stringForKey:@"ComputerUUID" nilOrEmpty:nilOrEmptyHandler];
        
        BOOL gitEnable = [plister boolForKey:@"GitEnable"];
        if (gitEnable) {
            NSString *gitBranch = [plister stringForKey:@"GitBranch" nilOrEmpty:nilOrEmptyHandler];
            NSString *gitLastCommitAbbreviatedHash = [plister stringForKey:@"GitLastCommitAbbreviatedHash" nilOrEmpty:nilOrEmptyHandler];
            NSString *gitLastCommitUser = [plister stringForKey:@"GitLastCommitUser" nilOrEmpty:nilOrEmptyHandler];
            NSString *gitLastCommitTimestamp = [plister stringForKey:@"GitLastCommitTimestamp"];
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
        buildInfoDictionary.dg_strongExtObj = @(YES);
    }
    buildInfoDictionary.dg_copyExtObj = @"编译信息";
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
    NSNumber *flag = sectionDictionary.dg_strongExtObj;
    if (flag && [flag boolValue]) {
        NSURL *url = [NSURL URLWithString:@"https://github.com/ripperhe/Debugo/blob/master/docs/build-info.md"];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.dataArray[section].dg_copyExtObj;
}

// https://stackoverflow.com/questions/18912980/uitableview-titleforheaderinsection-shows-all-caps/39504215#39504215
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).textLabel.text = self.dataArray[section].dg_copyExtObj;
    }
}

@end

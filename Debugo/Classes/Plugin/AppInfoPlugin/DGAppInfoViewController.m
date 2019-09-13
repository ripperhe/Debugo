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

@interface DGAppInfoViewController ()

@property (nonatomic, strong) DGPlister *buildPlister;
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
    
    // navigationItem
    dg_weakify(self)
    self.navigationItem.rightBarButtonItem = [[DGShareBarButtonItem alloc] initWithViewController:self clickedShareURLsBlock:^NSArray<NSURL *> * _Nonnull(DGShareBarButtonItem * _Nonnull item) {
        dg_strongify(self)
        if (!self) return nil;
        NSString *fileName = [NSString stringWithFormat:@"%@-info-%@.plist", [self getBundleInfo:@"CFBundleName"], [[NSDate date] dg_dateStringWithFormat:@"yyyy-MM-dd-HH-mm-ss"]];
        NSURL *fileURL = [NSURL fileURLWithPath:[DGFilePath.temporaryDirectory stringByAppendingPathComponent:fileName]];
        NSArray<DGOrderedDictionary *> *dataArray = self.dataArray.copy;
        NSMutableDictionary *plistContentDic = [NSMutableDictionary dictionary];
        [dataArray enumerateObjectsUsingBlock:^(DGOrderedDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [plistContentDic setObject:obj.keysAndObjects forKey:obj.dg_copyExtObj];
        }];
        BOOL result = [plistContentDic writeToFile:fileURL.path atomically:YES];
        if (result) {
            return @[fileURL];
        }
        return nil;
    }];
    
    // build info plister (从 bundle 中获取)
    NSString *buildInfoPlistPath = [[NSBundle mainBundle] pathForResource:@"com.ripperhe.debugo.build.info" ofType:@"plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:buildInfoPlistPath]) {
        self.buildPlister = [[DGPlister alloc] initWithFilePath:buildInfoPlistPath readonly:YES];
    }
    
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
}

- (NSString *)getBundleInfo:(NSString *)key {
    NSString *value = [NSBundle.mainBundle.infoDictionary objectForKey:key];
    if (value.length) {
        return value;
    }
    return @"unknown";
}

- (DGOrderedDictionary *)getBuildInfoDictionary {
    DGOrderedDictionary *buildInfoDictionary = nil;
    DGPlister *plister = self.buildPlister;
    if (plister){
        NSString *(^nilOrEmptyHandler)(void) = ^(void) {
            return @"unknown";
        };
        
        NSString *plistUpdateTimestamp = [plister stringForKey:@"PlistUpdateTimestamp"];
        if (plistUpdateTimestamp.length) {
            plistUpdateTimestamp = [[NSDate dateWithTimeIntervalSince1970:plistUpdateTimestamp.doubleValue] dg_dateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
        plistUpdateTimestamp = plistUpdateTimestamp?:@"unknown";
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
            gitLastCommitTimestamp = gitLastCommitTimestamp?:@"unknown";
            
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
                               @"获取编译信息需要添加脚本，请进入网页查看", @"https://ripperhe.com/Debugo/#/Guide/build-info",
                               nil];
    }
    buildInfoDictionary.dg_copyExtObj = @"编译信息";
    return buildInfoDictionary;
}

#pragma mark - event

- (void)clickedCopyBtn:(UIButton *)sender {
    kDGImpactFeedback
    NSIndexPath *indexPath = sender.dg_strongExtObj;
    
    // iOS 模拟器和真机剪切板不互通的问题 https://stackoverflow.com/questions/15188852/copy-and-paste-text-into-ios-simulator
    // Xcode 10 解决了这个问题：模拟器导航栏->Edit->Automatically Sync Pasteboard
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [self.tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray objectAtIndex:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.numberOfLines = 0;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setImage:[DGBundle imageNamed:@"copy"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0, 0, 44, 44)];
        [btn addTarget:self action:@selector(clickedCopyBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = btn;
    }
    DGOrderedDictionary *sectionDictionary = self.dataArray[indexPath.section];
    cell.textLabel.text = [sectionDictionary keyAtIndex:indexPath.row];
    cell.detailTextLabel.text = [sectionDictionary objectAtIndex:indexPath.row];
    cell.accessoryView.dg_strongExtObj = indexPath;
    return cell;
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

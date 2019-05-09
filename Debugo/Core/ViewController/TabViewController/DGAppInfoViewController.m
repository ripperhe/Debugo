//
//  DGAppInfoViewController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGAppInfoViewController.h"
#import "DGCache.h"
#import "DGAssistant.h"

static NSString *kDGCellID = @"kDGCellID";
static NSString *kDGCellTitle = @"kDGCellTitle";
static NSString *kDGCellValue = @"kDGCellValue";

@interface DGAppInfoViewController ()

@property (nonatomic, strong) NSArray <NSArray *>*dataArray;

@end

@implementation DGAppInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // navigationItem
    __weak typeof(self) weakSelf = self;
    self.navigationItem.rightBarButtonItem = [[DGShareBarButtonItem alloc] initWithViewController:self clickedShareURLsBlock:^NSArray<NSURL *> * _Nonnull(DGShareBarButtonItem * _Nonnull item) {
        if (!weakSelf) return nil;
        NSString *fileName = [NSString stringWithFormat:@"%@-info-%@.plist", [self getBundleInfo:@"CFBundleName"], [[NSDate date] dg_dateStringWithFormat:@"yyyy-MM-dd-HH-mm-ss"]];
        NSURL *fileURL = [NSURL fileURLWithPath:[DGFilePath.temporaryDirectory stringByAppendingPathComponent:fileName]];
        NSArray *dataArray = weakSelf.dataArray.copy;
        NSMutableDictionary *plistContentDic = [NSMutableDictionary dictionary];
        for (NSArray *sectionArray in dataArray) {
            NSMutableDictionary *sectionDic = [NSMutableDictionary dictionary];
            for (NSDictionary *row in sectionArray) {
                [sectionDic setObject:row[kDGCellValue] forKey:row[kDGCellTitle]];
            }
            [plistContentDic setObject:sectionDic forKey:sectionArray.dg_copyExtObj];
        }
        BOOL result = [plistContentDic writeToFile:fileURL.path atomically:YES];
        if (result) {
            return @[fileURL];
        }
        return nil;
    }];
}

#pragma mark - data

- (NSArray<NSArray *> *)dataArray {
    if (!_dataArray) {
        NSArray *budleArray = @[
                                @{kDGCellTitle:@"Bundle Name", kDGCellValue:[self getBundleInfo:@"CFBundleName"]},
                                @{kDGCellTitle:@"Display Name", kDGCellValue:[self getBundleInfo:@"CFBundleDisplayName"]},
                                @{kDGCellTitle:@"Identifier", kDGCellValue:[self getBundleInfo:@"CFBundleIdentifier"]},
                                @{kDGCellTitle:@"Build", kDGCellValue:[self getBundleInfo:@"CFBundleVersion"]},
                                @{kDGCellTitle:@"Version", kDGCellValue:[self getBundleInfo:@"CFBundleShortVersionString"]},
                                @{kDGCellTitle:@"Deployment Target", kDGCellValue:[self getBundleInfo:@"MinimumOSVersion"]},
                                ];
        budleArray.dg_copyExtObj = @"Bundle";
        
        NSArray *deviceArray = @[
                                 @{kDGCellTitle:@"Name", kDGCellValue:[UIDevice currentDevice].name},
                                 @{kDGCellTitle:@"Model Identifier", kDGCellValue:DGDevice.currentDevice.identifier},
                                 @{kDGCellTitle:@"Model Name", kDGCellValue:DGDevice.currentDevice.isSimulator?DGDevice.currentDevice.simulatorName:DGDevice.currentDevice.name},
                                 @{kDGCellTitle:@"System Version", kDGCellValue:[NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion]},
                                 @{kDGCellTitle:@"Screen Inch", kDGCellValue:DGDevice.currentDevice.isSimulator?DGDevice.currentDevice.simulatorScreenInch:DGDevice.currentDevice.screenInch},
                                 @{kDGCellTitle:@"Screen Pt", kDGCellValue:[NSString stringWithFormat:@"%.0f*%.0f", [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height]},
                                 @{kDGCellTitle:@"Screen Px", kDGCellValue:[NSString stringWithFormat:@"%.0f*%.0f", [UIScreen mainScreen].nativeBounds.size.width, [UIScreen mainScreen].nativeBounds.size.height]},
                                 @{kDGCellTitle:@"Screen Scale", kDGCellValue:[NSString stringWithFormat:@"%g", [UIScreen mainScreen].scale]},
                                 @{kDGCellTitle:@"Screen Native Scale", kDGCellValue:[NSString stringWithFormat:@"%g", [UIScreen mainScreen].nativeScale]},
                                 @{kDGCellTitle:@"Current Locale", kDGCellValue:[[NSLocale currentLocale] localeIdentifier]},
                                 @{kDGCellTitle:@"Local Timezone", kDGCellValue:[NSTimeZone localTimeZone].name},
                                 ];
        deviceArray.dg_copyExtObj = @"Device";

        NSArray *buildArray = [self getBuildInfoArray];
        _dataArray = @[budleArray, deviceArray, buildArray];
    }
    return _dataArray;
}

- (NSString *)getBundleInfo:(NSString *)key {
    NSString *value = [NSBundle.mainBundle.infoDictionary objectForKey:key];
    if (value.length) {
        return value;
    }
    return @"unknown";
}

- (NSArray *)getBuildInfoArray {
    DGLog(@"%@", DGCache.shared.buildInfoPlister);

    NSArray *buildInfoArray = nil;
    DGPlister *plister = DGCache.shared.buildInfoPlister;
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
        NSString *computerHostname = [plister stringForKey:@"ComputerHostname" nilOrEmpty:nilOrEmptyHandler];
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
            
            buildInfoArray = @[
                             @{kDGCellTitle:@"Update Date", kDGCellValue:plistUpdateTimestamp },
                             @{kDGCellTitle:@"Build Configuration", kDGCellValue:buildConfiguration},
                             @{kDGCellTitle:@"Computer User", kDGCellValue:computerUser},
                             @{kDGCellTitle:@"Computer Hostname", kDGCellValue:computerHostname },
                             @{kDGCellTitle:@"Computer UUID", kDGCellValue:computerUUID },
                             @{kDGCellTitle:@"Git Branch", kDGCellValue:gitBranch },
                             @{kDGCellTitle:@"Git Last Commit Hash", kDGCellValue:gitLastCommitAbbreviatedHash },
                             @{kDGCellTitle:@"Git Last Commit User", kDGCellValue:gitLastCommitUser },
                             @{kDGCellTitle:@"Git Last Commit Date", kDGCellValue:gitLastCommitTimestamp },
                             ];
        }else{
            buildInfoArray = @[
                             @{kDGCellTitle:@"Update Date", kDGCellValue:plistUpdateTimestamp },
                             @{kDGCellTitle:@"Computer Hostname", kDGCellValue:computerHostname },
                             @{kDGCellTitle:@"Computer UUID", kDGCellValue:computerUUID },
                             ];
        }
    }else{
        buildInfoArray = @[
                         @{kDGCellTitle:@"Please visit the website for details.", kDGCellValue:@"https://ripperhe.com/Debugo/#/Guide/build-info"},
                         ];
    }
    buildInfoArray.dg_copyExtObj = @"Build Info";
    return buildInfoArray;
}

#pragma mark - event

- (void)clickedCopyBtn:(UIButton *)sender {
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [feedBackGenertor impactOccurred];
    }
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDGCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kDGCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.numberOfLines = 0;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setImage:[DGBundle imageNamed:@"copy"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0, 0, 44, 44)];
        [btn addTarget:self action:@selector(clickedCopyBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = btn;
    }
    NSDictionary *data = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = data[kDGCellTitle];
    cell.detailTextLabel.text = data[kDGCellValue];
    cell.accessoryView.dg_strongExtObj = indexPath;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    DGPopOverMenuConfiguration *config = [DGPopOverMenuConfiguration defaultConfiguration];
//    config.textAlignment = NSTextAlignmentCenter;
//    [DGPopOverMenu showForSender:cell
//                   withMenuArray:@[@"Copy"]
//                      imageArray:nil
//                   configuration:config
//                       doneBlock:^(NSInteger selectedIndex) {
//                           // iOS 模拟器和真机剪切板不互通的问题 https://stackoverflow.com/questions/15188852/copy-and-paste-text-into-ios-simulator
//                           // Xcode 10 解决了这个问题：模拟器导航栏->Edit->Automatically Sync Pasteboard
//                           UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//                           pasteboard.string = cell.detailTextLabel.text;
//                       }
//                    dismissBlock:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.dataArray[section].dg_copyExtObj;
}

@end

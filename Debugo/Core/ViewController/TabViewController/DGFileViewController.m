//
//  DGFileViewController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGFileViewController.h"
#import "DGAssistant.h"
#import "DGFileBrowser.h"
#import "DGPreviewManager.h"
#import "DGFileInfoViewController.h"

static NSString *kDGCellID = @"kDGCellID";
static NSString *kDGCellTitle = @"kDGCellTitle";
static NSString *kDGCellSubtitle = @"kDGCellSubtitle";
static NSString *kDGCellValue = @"kDGCellValue";

@interface DGFileViewController ()

@property (nonatomic, strong) NSArray <NSArray <NSDictionary *>*>*dataArray;

@property (nonatomic, strong) DGFBFileDatabaseFileUIConfigBlock databaseUIConfigBlock;

@end

@implementation DGFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置数据库UI配置
    [self setDatabaseUIConfigBlock:^DGDatabaseUIConfig *(DGFBFile *file) {
        DGDatabaseUIConfig *config = nil;
        if ([DGDebugo.shared.delegate respondsToSelector:@selector(debugoDatabaseUIConfigForDatabaseURL:)]) {
            config = [DGDebugo.shared.delegate debugoDatabaseUIConfigForDatabaseURL:file.fileURL];
        }
        return config;
    }];
}

- (NSArray *)dataArray
{
    if (!_dataArray) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        // genaral
        DGFBFile *sandboxFile = [[DGFBFile alloc] initWithFileURL:[NSURL URLWithString:NSHomeDirectory()]];
        DGFBFile *bundleFile = [[DGFBFile alloc] initWithFileURL:[[NSBundle mainBundle] bundleURL]];
        NSArray *generalArray = @[
                       @{kDGCellTitle:@"Sandbox",
                         kDGCellSubtitle:@"App Home Folder",
                         kDGCellValue:sandboxFile},
                       @{kDGCellTitle:@"Bundle",
                         kDGCellSubtitle:bundleFile.fileURL.path.lastPathComponent,
                         kDGCellValue:bundleFile},
                       ];
        [array addObject:generalArray];
        
        // db shortcut
        NSArray <NSURL *>*shortcutDBURLs = DGAssistant.shared.configuration.shortcutForDatabaseURLs.copy;
        NSMutableArray *shortcutDBFiles = [NSMutableArray array];
        for (NSURL *url in shortcutDBURLs) {
            NSArray *files = [self parseURL:url forType:DGFBFileTypeDB];
            if (files.count) {
                [shortcutDBFiles addObjectsFromArray:files];
            }
        }
        if (shortcutDBFiles.count) {
            shortcutDBFiles.dg_copyExtObj = @"Database shortcut";
            [array addObject:shortcutDBFiles];
        }
        
        // # shortcut
        NSArray <NSURL *>*shortcutMixURLs = DGAssistant.shared.configuration.shortcutForAnyURLs.copy;
        NSMutableArray *shortcutMixFiles = [NSMutableArray array];
        for (NSURL *url in shortcutMixURLs) {
            DGFBFile *file = [[DGFBFile alloc] initWithFileURL:url];
            [shortcutMixFiles addObject:@{kDGCellTitle:file.displayName, kDGCellValue:file}];
        }
        if (shortcutMixFiles.count) {
            shortcutMixFiles.dg_copyExtObj = @"# shortcut";
            [array addObject:shortcutMixFiles];
        }
        
        _dataArray = array.copy;
    }
    return _dataArray;
}

- (NSArray <NSDictionary <NSString *, DGFBFile *>*>*)parseURL:(NSURL *)url forType:(DGFBFileType)type {
    BOOL isDirectory = NO;
    BOOL isExist = [NSFileManager.defaultManager fileExistsAtPath:url.path isDirectory:&isDirectory];
    if (!isExist) {
        return nil;
    }
    
    if (!isDirectory) {
        DGFBFile *file = [[DGFBFile alloc] initWithFileURL:url];
        if (file.type == type) {
            return @[@{kDGCellTitle:file.displayName, kDGCellValue:file}];
        }
        return nil;
    }else {
        NSMutableArray *files = [NSMutableArray array];
        NSArray <NSURL *>*fileURLs = [NSArray array];
        NSError *error;
        fileURLs = [NSFileManager.defaultManager contentsOfDirectoryAtURL:url includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
        if (error) {
            NSLog(@"%@ %s error:%@", self, __func__, error);
            return nil;
        }
        for (NSURL *URL in fileURLs) {
            DGFBFile *file = [[DGFBFile alloc] initWithFileURL:URL];
            if (file.type == type) {
                [files addObject:@{kDGCellTitle:file.displayName, kDGCellValue:file}];
            }
        }
        [files sortUsingComparator:^NSComparisonResult(NSDictionary *  _Nonnull obj1, NSDictionary *  _Nonnull obj2) {
            return [obj1[kDGCellTitle] compare:obj2[kDGCellTitle]];
        }];
        return files;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDGCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kDGCellID];
        cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    
    NSDictionary *data = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = data[kDGCellTitle];
    cell.detailTextLabel.text = [data objectForKey:kDGCellSubtitle];
    DGFBFile *file = [data objectForKey:kDGCellValue];
    cell.imageView.image = file.image;
    if (file.isDirectory) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView.userInteractionEnabled = NO;
    }else {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        cell.accessoryView.userInteractionEnabled = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = self.dataArray[indexPath.section][indexPath.row];
    DGFBFile *file = [data objectForKey:kDGCellValue];
    if (file.isDirectory) {
        DGFileListViewController *fileListViewController = [[DGFileListViewController alloc] initWithInitialURL:file.fileURL showCancelButton:NO];
        fileListViewController.allowEditing = YES;
        fileListViewController.databaseFileUIConfig = self.databaseUIConfigBlock;
        [self.navigationController pushViewController:fileListViewController animated:YES];
    } else {
        DGDatabaseUIConfig *config = nil;
        if (file.type == DGFBFileTypeDB) {
            config = self.databaseUIConfigBlock(file);
        }
        DGPreviewManager *manager = [[DGPreviewManager alloc] init];
        UIViewController *previewVC = [manager previewViewControllerForFile:file fromNavigation:YES uiConfig:config];
        [self.navigationController pushViewController:previewVC animated:YES];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = self.dataArray[indexPath.section][indexPath.row];
    DGFBFile *file = [data objectForKey:kDGCellValue];
    if (file.isDirectory) {
        NSAssert(0, @"😳 不可能吧");
    }else {
        DGFileInfoViewController *fileInfoVC = [[DGFileInfoViewController alloc] initWithFile:file];
        [self.navigationController pushViewController:fileInfoVC animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.dataArray[section].dg_copyExtObj;
}

@end

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
#import "DGPreviewManager.h"
#import "DGFileInfoViewController.h"
#import "DGFileParser.h"

static NSString *kDGCellID = @"kDGCellID";
static NSString *kDGCellTitle = @"kDGCellTitle";
static NSString *kDGCellSubtitle = @"kDGCellSubtitle";
static NSString *kDGCellValue = @"kDGCellValue";

@interface DGFileViewController ()

@property (nonatomic, strong) DGFileConfiguration *configuration;
@property (nonatomic, strong) NSArray <NSArray <NSDictionary *>*>*dataArray;

@end

@implementation DGFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 进页面刷新
    self.dataArray = nil;
    [self.tableView reloadData];
}

#pragma mark - getter

- (DGFileConfiguration *)configuration {
    if (!_configuration) {
        DGFileConfiguration *configuration = [DGFileConfiguration new];
        configuration.allowEditing = YES;
        [configuration setDatabaseFilePreviewConfigurationBlock:^DGDatabasePreviewConfiguration *(DGFBFile *file) {
            DGDatabasePreviewConfiguration *config = nil;
            if ([DGDebugo.shared.delegate respondsToSelector:@selector(debugoDatabasePreviewConfigurationForDatabaseURL:)]) {
                config = [DGDebugo.shared.delegate debugoDatabasePreviewConfigurationForDatabaseURL:file.fileURL];
            }
            return config;
        }];
        _configuration = configuration;
    }
    return _configuration;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        NSMutableArray *array = [NSMutableArray array];
        
        // genaral
        DGFBFile *sandboxFile = [[DGFBFile alloc] initWithURL:[NSURL fileURLWithPath:NSHomeDirectory()]];
        DGFBFile *bundleFile = [[DGFBFile alloc] initWithURL:[[NSBundle mainBundle] bundleURL]];
        NSArray *generalArray = @[
                       @{kDGCellTitle:@"Sandbox",
                         kDGCellSubtitle:@"App Home Folder",
                         kDGCellValue:sandboxFile},
                       @{kDGCellTitle:@"Bundle",
                         kDGCellSubtitle:bundleFile.displayName,
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
            DGFBFile *file = [[DGFBFile alloc] initWithURL:url];
            [shortcutMixFiles addObject:@{kDGCellTitle:file.displayName, kDGCellValue:file}];
        }
        if (shortcutMixFiles.count) {
            shortcutMixFiles.dg_copyExtObj = @"# Shortcut";
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
        DGFBFile *file = [[DGFBFile alloc] initWithURL:url];
        if (file.type == type) {
            return @[@{kDGCellTitle:file.displayName, kDGCellValue:file}];
        }
        return nil;
    }else {
        DGFileConfiguration *configuration = [DGFileConfiguration new];
        configuration.allowedFileTypes = @[@(type)];
        NSArray <DGFBFile *>*files = [DGFileParser filesForDirectory:url configuration:configuration errorHandler:^(NSError *error) {
            NSLog(@"%@ %s error:%@", self, __func__, error);
        }];
        NSMutableArray *fileDicArray = [NSMutableArray arrayWithCapacity:files.count];
        for (DGFBFile *file in files) {
            [fileDicArray addObject:@{kDGCellTitle:file.displayName, kDGCellValue:file}];
        }
        return fileDicArray;
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
    DGFBFile *file = [data objectForKey:kDGCellValue];
    cell.textLabel.text = data[kDGCellTitle];
    cell.detailTextLabel.text = [data objectForKey:kDGCellSubtitle]?:file.simpleInfo;
    cell.imageView.image = file.image;
    cell.accessoryType = file.isDirectory ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryDetailButton;
    cell.accessoryView.userInteractionEnabled = !file.isDirectory;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *data = self.dataArray[indexPath.section][indexPath.row];
    DGFBFile *file = [data objectForKey:kDGCellValue];;
    UIViewController *previewViewController = [DGPreviewManager previewViewControllerForFile:file configuration:self.configuration];
    [self.navigationController pushViewController:previewViewController animated:YES];
    DGLog(@"%@", file.fileURL.path);
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = self.dataArray[indexPath.section][indexPath.row];
    DGFBFile *file = [data objectForKey:kDGCellValue];
    DGFileInfoViewController *fileInfoVC = [[DGFileInfoViewController alloc] initWithFile:file];
    [self.navigationController pushViewController:fileInfoVC animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.dataArray[section].dg_copyExtObj;
}

@end

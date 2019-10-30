//
//  DGFileViewController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGFileViewController.h"
#import "DGEntrance.h"
#import "DGPreviewManager.h"
#import "DGFileInfoViewController.h"
#import "DGFileParser.h"
#import "DGFileTableViewCell.h"
#import "DGFilePlugin.h"
#import "DGCommon.h"

@interface DGFileViewController ()

@property (nonatomic, strong) NSArray<NSArray<DGFile *> *> *dataArray;
@property (nonatomic, strong) DGFilePreviewConfiguration *previewConfiguration;

@end

@implementation DGFileViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.title = [DGFilePlugin pluginName];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 进页面刷新
    self.dataArray = nil;
    [self.tableView reloadData];
}

#pragma mark - getter

- (NSArray *)dataArray {
    if (!_dataArray) {
        NSMutableArray *array = [NSMutableArray array];
        
        // genaral
        DGFile *sandboxFile = [[DGFile alloc] initWithURL:DGPathFetcher.sandboxDirectoryURL];
        [sandboxFile setDisplayName:@"Sandbox"];
        DGFile *bundleFile = [[DGFile alloc] initWithURL:DGPathFetcher.bundleDirectoryURL];
        [bundleFile setDisplayName:@"Bundle"];
        NSArray *generalArray = @[sandboxFile, bundleFile];
        [array addObject:generalArray];
        
        // db shortcut
        NSArray<NSString *> *shortcutForDatabasePaths = DGFilePlugin.shared.configuration.shortcutForDatabasePaths.copy;
        NSMutableArray *shortcutDBFiles = [NSMutableArray array];
        [shortcutForDatabasePaths enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *files = [DGFileParser filesForPath:obj forType:DGFileTypeDB errorHandler:nil];
            if (files.count) {
                [shortcutDBFiles addObjectsFromArray:files];
            }
        }];
        if (shortcutDBFiles.count) {
            shortcutDBFiles.dg_extCopyObj = @"数据库捷径";
            [array addObject:shortcutDBFiles];
        }
        
        // # shortcut
        NSArray <NSString *>*shortcutForAnyPaths = DGFilePlugin.shared.configuration.shortcutForAnyPaths.copy;
        NSMutableArray *shortcutForAnyFiles = [NSMutableArray array];
        [shortcutForAnyPaths enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DGFile *file = [[DGFile alloc] initWithPath:obj];
            if (file) {
                [shortcutForAnyFiles addObject:file];
            }
        }];
        if (shortcutForAnyFiles.count) {
            shortcutForAnyFiles.dg_extCopyObj = @"捷径";
            [array addObject:shortcutForAnyFiles];
        }
        
        _dataArray = array.copy;
    }
    return _dataArray;
}

- (DGFilePreviewConfiguration *)previewConfiguration {
    if (!_previewConfiguration) {
        DGFilePreviewConfiguration *configuration = [DGFilePreviewConfiguration new];
        // 设置数据库预览
        [configuration setDatabaseFilePreviewConfigurationBlock:^DGDatabasePreviewConfiguration *(DGFile *file) {
            if (DGFilePlugin.shared.configuration.databaseFilePreviewConfigurationBlock) {
                DGDatabasePreviewConfiguration *config = DGFilePlugin.shared.configuration.databaseFilePreviewConfigurationBlock(file.filePath);
                return config;
            }
            return nil;
        }];
        _previewConfiguration = configuration;
    }
    return _previewConfiguration;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kDGCellID = @"cell";
    DGFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDGCellID];
    if (!cell) {
        cell = [[DGFileTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kDGCellID];
    }
    DGFile *file = self.dataArray[indexPath.section][indexPath.row];;
    [cell refreshWithFile:file];
    if (indexPath.section == 0) cell.detailTextLabel.text = file.fileName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    DGFile *file = self.dataArray[indexPath.section][indexPath.row];;;
    UIViewController *previewViewController = [DGPreviewManager previewViewControllerForFile:file configuration:self.previewConfiguration];
    [self.navigationController pushViewController:previewViewController animated:YES];
    DGLog(@"\n%@", file.fileURL.path);
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    DGFile *file = self.dataArray[indexPath.section][indexPath.row];
    DGFileInfoViewController *fileInfoVC = [[DGFileInfoViewController alloc] initWithFile:file];
    [self.navigationController pushViewController:fileInfoVC animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.dataArray[section].dg_extCopyObj;
}

@end

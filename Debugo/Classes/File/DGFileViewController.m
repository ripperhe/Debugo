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
#import "DGFileTableViewCell.h"

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
        [configuration setDatabaseFilePreviewConfigurationBlock:^DGDatabasePreviewConfiguration *(DGFile *file) {
            DGDatabasePreviewConfiguration *config = nil;
            if (DGAssistant.shared.configuration.fileConfiguration.databasePreviewConfigurationFetcher) {
                DGAssistant.shared.configuration.fileConfiguration.databasePreviewConfigurationFetcher(file.fileURL);
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
        DGFile *sandboxFile = [[DGFile alloc] initWithURL:DGFilePath.sandboxDirectoryURL];
        [sandboxFile setDisplayName:@"Sandbox"];
        DGFile *bundleFile = [[DGFile alloc] initWithURL:DGFilePath.bundleDirectoryURL];
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
        NSArray <NSString *>*shortcutForDatabasePaths = DGAssistant.shared.configuration.fileConfiguration.shortcutForDatabasePaths.copy;
        NSMutableArray *shortcutDBFiles = [NSMutableArray array];
        [shortcutForDatabasePaths enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *files = [self parsePath:obj forType:DGFileTypeDB];
            if (files.count) {
                [shortcutDBFiles addObjectsFromArray:files];
            }
        }];
        if (shortcutDBFiles.count) {
            shortcutDBFiles.dg_copyExtObj = @"数据库捷径";
            [array addObject:shortcutDBFiles];
        }
        
        // # shortcut
        NSArray <NSString *>*shortcutForAnyPaths = DGAssistant.shared.configuration.fileConfiguration.shortcutForAnyPaths.copy;
        NSMutableArray *shortcutForAnyFiles = [NSMutableArray array];
        [shortcutForAnyPaths enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DGFile *file = [[DGFile alloc] initWithPath:obj];
            if (file) {
                [shortcutForAnyFiles addObject:@{kDGCellTitle:file.displayName, kDGCellValue:file}];
            }
        }];
        if (shortcutForAnyFiles.count) {
            shortcutForAnyFiles.dg_copyExtObj = @"捷径";
            [array addObject:shortcutForAnyFiles];
        }
        
        _dataArray = array.copy;
    }
    return _dataArray;
}

- (NSArray <NSDictionary <NSString *, DGFile *>*>*)parsePath:(NSString *)path forType:(DGFileType)type {
    DGFile *parseFile = [[DGFile alloc] initWithPath:path];
    if (!parseFile) return nil;
    if (parseFile.isDirectory) {
        if (type == DGFileTypeDirectory) return @[@{kDGCellTitle:parseFile.displayName, kDGCellValue:parseFile}];
        DGFileConfiguration *configuration = [DGFileConfiguration new];
        configuration.allowedFileTypes = @[@(type)];
        NSArray <DGFile *>*files = [DGFileParser filesForDirectory:parseFile.fileURL configuration:configuration errorHandler:^(NSError *error) {
            DGLog(@"获取文件失败 error:%@", error);
        }];
        NSMutableArray *fileDicArray = [NSMutableArray arrayWithCapacity:files.count];
        for (DGFile *file in files) {
            [fileDicArray addObject:@{kDGCellTitle:file.displayName, kDGCellValue:file}];
        }
        return fileDicArray;
    }else if (parseFile.type == type) {
        return @[@{kDGCellTitle:parseFile.displayName, kDGCellValue:parseFile}];
    }
    return nil;
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
    NSDictionary *data = self.dataArray[indexPath.section][indexPath.row];
    DGFile *file = [data objectForKey:kDGCellValue];
    [cell refreshWithFile:file];
    if ([data objectForKey:kDGCellSubtitle]) {
        cell.detailTextLabel.text = [data objectForKey:kDGCellSubtitle];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *data = self.dataArray[indexPath.section][indexPath.row];
    DGFile *file = [data objectForKey:kDGCellValue];;
    UIViewController *previewViewController = [DGPreviewManager previewViewControllerForFile:file configuration:self.configuration];
    [self.navigationController pushViewController:previewViewController animated:YES];
    DGLog(@"\n%@", file.fileURL.path);
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = self.dataArray[indexPath.section][indexPath.row];
    DGFile *file = [data objectForKey:kDGCellValue];
    DGFileInfoViewController *fileInfoVC = [[DGFileInfoViewController alloc] initWithFile:file];
    [self.navigationController pushViewController:fileInfoVC animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.dataArray[section].dg_copyExtObj;
}

@end

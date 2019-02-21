//
//  DGFileBrowser.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGFileBrowser.h"
#import "DGFileParser.h"

@interface DGFileBrowser ()

@property (nonatomic, strong) DGFileListViewController *fileList;

@end

@implementation DGFileBrowser

- (instancetype)init
{
    NSURL *URL = [DGFileParser shareInstance].documentsURL;
    return [self initWithInitialURL:URL allowEditing:YES showCancelButton:YES];
}

- (instancetype)initWithInitialURL:(NSURL *)initialURL allowEditing:(BOOL)allowEditing showCancelButton:(BOOL)showCancelButton
{
    NSURL * validInitialURL = initialURL ?: [DGFileParser shareInstance].documentsURL;
    DGFileListViewController *fileListViewController = [[DGFileListViewController alloc] initWithInitialURL:validInitialURL showCancelButton:showCancelButton];
    fileListViewController.allowEditing = allowEditing;

    self = [super initWithRootViewController:fileListViewController];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.fileList = fileListViewController;
    }
    return self;
}

#pragma mark - setter
- (void)setExcludesFileExtensions:(NSArray <NSString *>*)excludesFileExtensions
{
    _excludesFileExtensions = excludesFileExtensions;
    
    [DGFileParser shareInstance].excludesFileExtensions = excludesFileExtensions;
}

- (void)setExcludesFileURLs:(NSArray<NSURL *> *)excludesFileURLs
{
    _excludesFileURLs = excludesFileURLs;
    
    [DGFileParser shareInstance].excludesFileURLs = excludesFileURLs;
}

- (void)setDidSelectFileBlock:(DGFBFileDidSelectFileBlock)didSelectFile
{
    self.fileList.didSelectFile = didSelectFile;
}

- (void)setDatabaseFileUIConfigBlock:(DGFBFileDatabaseFileUIConfigBlock)databaseFileUIConfig
{
    self.fileList.databaseFileUIConfig = databaseFileUIConfig;
}

@end

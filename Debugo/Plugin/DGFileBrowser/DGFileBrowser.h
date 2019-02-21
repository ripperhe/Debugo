//
//  DGFileBrowser.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGFileListViewController.h"

@interface DGFileBrowser : UINavigationController

/// File types to exclude from the file browser.
@property (nonatomic, strong) NSArray <NSString *>*excludesFileExtensions;

/// File paths to exclude from the file browser.
@property (nonatomic, strong) NSArray <NSURL *>*excludesFileURLs;

- (instancetype)initWithInitialURL:(NSURL *)initialURL allowEditing:(BOOL)allowEditing showCancelButton:(BOOL)showCancelButton;
- (void)setDidSelectFileBlock:(DGFBFileDidSelectFileBlock)didSelectFile;
- (void)setDatabaseFileUIConfigBlock:(DGFBFileDatabaseFileUIConfigBlock)databaseFileUIConfig;

@end

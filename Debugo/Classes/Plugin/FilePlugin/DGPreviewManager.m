//
//  DGPreviewManager.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGPreviewManager.h"
#import "DGFolderPreviewViewController.h"
#import "DGWebviewPreviewViewContoller.h"
#import "DGDefaultPreviewViewController.h"
#import "DGDatabasePreviewViewController.h"

@implementation DGPreviewManager

+ (UIViewController *)previewViewControllerForFile:(DGFile *)file configuration:(DGFilePreviewConfiguration *)configuration {
    switch (file.type) {
        case DGFileTypeDirectory: {
            DGFolderPreviewViewController *fileListViewController = [[DGFolderPreviewViewController alloc] initWithFile:file configuration:configuration];
            return fileListViewController;
        }
            break;
        case DGFileTypePLIST:
        case DGFileTypeJSON: {
            DGWebviewPreviewViewContoller *webviewPreviewViewContoller = [DGWebviewPreviewViewContoller new];
            webviewPreviewViewContoller.file = file;
            return webviewPreviewViewContoller;
        }
            break;
        case DGFileTypeDB: {
            DGDatabasePreviewViewController *databasePreviewViewController = [DGDatabasePreviewViewController new];
            databasePreviewViewController.file = file;
            id config = configuration.databaseFilePreviewConfigurationBlock?configuration.databaseFilePreviewConfigurationBlock(file):nil;
            databasePreviewViewController.previewConfiguration = config;
            return databasePreviewViewController;
        }
            break;
        default: {
            DGDefaultPreviewViewController *previewTransitionViewController = [DGDefaultPreviewViewController new];
            previewTransitionViewController.file = file;
            return previewTransitionViewController;
        }
            break;
    }
}

@end




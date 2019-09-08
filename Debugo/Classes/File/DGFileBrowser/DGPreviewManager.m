//
//  DGPreviewManager.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGPreviewManager.h"
#import "DGFileListViewController.h"
#import "DGWebviewPreviewViewContoller.h"
#import "DGDefaultPreviewViewController.h"
#import "DGDatabasePreviewViewController.h"

@implementation DGPreviewManager

+ (UIViewController *)previewViewControllerForFile:(DGFBFile *)file configuration:(DGFileConfiguration *)configuration {
    switch (file.type) {
        case DGFBFileTypeDirectory: {
            DGFileListViewController *fileListViewController = [[DGFileListViewController alloc] initWithInitialURL:file.fileURL configuration:configuration];
            return fileListViewController;
        }
            break;
        case DGFBFileTypePLIST:
        case DGFBFileTypeJSON: {
            DGWebviewPreviewViewContoller *webviewPreviewViewContoller = [DGWebviewPreviewViewContoller new];
            webviewPreviewViewContoller.file = file;
            return webviewPreviewViewContoller;
        }
            break;
        case DGFBFileTypeDB: {
            DGDatabasePreviewViewController *databasePreviewViewController = [DGDatabasePreviewViewController new];
            databasePreviewViewController.file = file;
            databasePreviewViewController.previewConfiguration = configuration.databaseFilePreviewConfigurationBlock?configuration.databaseFilePreviewConfigurationBlock(file):nil;
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




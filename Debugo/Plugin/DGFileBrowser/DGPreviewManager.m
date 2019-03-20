//
//  DGPreviewManager.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGPreviewManager.h"
#import "DGWebviewPreviewViewContoller.h"
#import "DGDefaultPreviewViewController.h"
#import "DGDatabasePreviewViewController.h"

@implementation DGPreviewManager

- (UIViewController *)previewViewControllerForFile:(DGFBFile *)file fromNavigation:(BOOL)fromNavigation uiConfig:(DGDatabaseUIConfig *)uiConfig
{
    switch (file.type) {
        case DGFBFileTypePLIST:
        case DGFBFileTypeJSON: {
            DGWebviewPreviewViewContoller *webviewPreviewViewContoller = [DGWebviewPreviewViewContoller new];
            webviewPreviewViewContoller.file = file;
            return webviewPreviewViewContoller;
        }
            break;
        case DGFBFileTypeDB: {
            DGDatabasePreviewViewController *databasePreviewViewController = [[DGDatabasePreviewViewController alloc] initWithFile:file databaseUIConfig:uiConfig];
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




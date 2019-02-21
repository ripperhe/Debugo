//
//  DGPreviewManager.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGPreviewManager.h"
#import <QuickLook/QuickLook.h>
#import "DGFBFile.h"
#import "DGWebviewPreviewViewContoller.h"
#import "DGPreviewTransitionViewController.h"
#import "DGDatabasePreviewViewController.h"

@interface DGPreviewItem: NSObject<QLPreviewItem>

/*!
 * @abstract The URL of the item to preview.
 * @discussion The URL must be a file URL.
 */
@property (nonatomic, strong) NSURL *fileURL;
@end

@implementation DGPreviewItem

- (NSURL *)previewItemURL
{
    if (self.fileURL) {
        return self.fileURL;
    }
    return nil;
}
@end

#pragma mark -

@interface DGPreviewManager ()<QLPreviewControllerDataSource>
@property (nonatomic, strong) NSURL *fileURL;
@end

@implementation DGPreviewManager

- (UIViewController *)previewViewControllerForFile:(DGFBFile *)file fromNavigation:(BOOL)fromNavigation uiConfig:(DGDatabaseUIConfig *)uiConfig
{
    if (file.type == DGFBFileTypePLIST || file.type == DGFBFileTypeJSON) {
        DGWebviewPreviewViewContoller *webviewPreviewViewContoller = [DGWebviewPreviewViewContoller new];
        webviewPreviewViewContoller.file = file;
        return webviewPreviewViewContoller;
    }else if (file.type == DGFBFileTypeDB) {
        DGDatabasePreviewViewController *databasePreviewViewController = [[DGDatabasePreviewViewController alloc] initWithFile:file databaseUIConfig:uiConfig];
        return databasePreviewViewController;
    }else {
        DGPreviewTransitionViewController *previewTransitionViewController = [DGPreviewTransitionViewController new];
        previewTransitionViewController.quickLookPreviewController.dataSource = self;
        
        self.fileURL = file.fileURL;
        if (fromNavigation) {
            return previewTransitionViewController.quickLookPreviewController;
        }else{
            return previewTransitionViewController;
        }
    }
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    DGPreviewItem *item = [[DGPreviewItem alloc] init];
    if (self.fileURL) {
        item.fileURL = self.fileURL;
    }
    return item;
}

@end




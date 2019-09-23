//
//  DGDefaultPreviewViewController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGDefaultPreviewViewController.h"

@interface DGDefaultPreviewViewController ()<QLPreviewControllerDataSource>

@end

@implementation DGDefaultPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = self;
}

- (void)setFile:(DGFile *)file {
    _file = file;
    self.title = file.displayName;
}

#pragma mark - QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.file;
}

@end

//
//  DGDefaultPreviewViewController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGDefaultPreviewViewController.h"
#import "DGBase.h"

@interface DGPreviewItem: NSObject<QLPreviewItem>

/*!
 * @abstract The URL of the item to preview.
 * @discussion The URL must be a file URL.
 */
@property (nonatomic, strong) NSURL *fileURL;
@end

@implementation DGPreviewItem

- (NSURL *)previewItemURL {
    if (self.fileURL) {
        return self.fileURL;
    }
    return nil;
}
@end

@interface DGDefaultPreviewViewController ()<QLPreviewControllerDataSource>

@property (nonatomic, weak) UIView *containerView;
@end

/// Preview Transition View Controller was created because of a bug in QLPreviewController. It seems that QLPreviewController has issues being presented from a 3D touch peek-pop gesture and is produced an unbalanced presentation warning. By wrapping it in a container, we are solving this issue.

@implementation DGDefaultPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.file.fileURL.lastPathComponent;
    
    // Add share button
    __weak typeof(self) weakSelf = self;
    DGShareBarButtonItem *shareBarButtonItem = [[DGShareBarButtonItem alloc] initWithViewController:self clickedShareURLsBlock:^NSArray<NSURL *> * _Nonnull(DGShareBarButtonItem * _Nonnull item) {
        return @[weakSelf.file.fileURL];
    }];
    self.navigationItem.rightBarButtonItem = shareBarButtonItem;

    // For set lineBreakMode
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = self.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.navigationItem.titleView = titleLabel;
    
    self.quickLookPreviewController.dataSource = self;
    [self addChildViewController:self.quickLookPreviewController];
    [self.containerView addSubview:self.quickLookPreviewController.view];
    [self.quickLookPreviewController didMoveToParentViewController:self];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.containerView.frame = self.view.bounds;
    self.quickLookPreviewController.view.frame = self.containerView.bounds;
}

#pragma mark - getter
- (UIView *)containerView
{
    if (!_containerView) {
        UIView *containerView = [[UIView alloc] init];
        [self.view addSubview:containerView];
        _containerView = containerView;
    }
    return _containerView;
}

- (QLPreviewController *)quickLookPreviewController
{
    if (!_quickLookPreviewController) {
        QLPreviewController *quickLookPreviewController = [QLPreviewController new];
        _quickLookPreviewController = quickLookPreviewController;
    }
    return _quickLookPreviewController;
}

#pragma mark - QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    DGPreviewItem *item = [[DGPreviewItem alloc] init];
    if (self.file.fileURL) {
        item.fileURL = self.file.fileURL;
    }
    return item;
}

@end

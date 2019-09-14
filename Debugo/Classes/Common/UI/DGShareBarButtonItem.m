//
//  DGShareBarButtonItem.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/3/20.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGShareBarButtonItem.h"
#import "DGCommon.h"

@implementation DGShareBarButtonItem

- (instancetype)initWithViewController:(UIViewController *)viewController shareFilePathsWhenClickedBlock:(NSArray<NSString *> * _Nonnull (^)(DGShareBarButtonItem * _Nonnull))shareFilePathsWhenClickedBlock {
    self = [super initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareFile:)];
    if (self) {
        self.viewController = viewController;
        self.shareFilePathsWhenClickedBlock = shareFilePathsWhenClickedBlock;
    }
    return self;
}

#pragma mark - share
- (void)shareFile:(UIBarButtonItem *)sender {
    if (!self.viewController) return;
    if (!self.shareFilePathsWhenClickedBlock) return;
    
    UIViewController *viewController = self.viewController;
    NSArray<NSString *> *paths = self.shareFilePathsWhenClickedBlock(self);
    if (!paths.count) return;
    NSMutableArray *urls = [NSMutableArray arrayWithCapacity:paths.count];
    [paths enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [urls addObject:[NSURL fileURLWithPath:obj]];
    }];
    
    // TODO: 微信和QQ分享时页面卡死的处理
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:urls applicationActivities:nil];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
        && [activityViewController respondsToSelector:@selector(popoverPresentationController)]) {
        activityViewController.popoverPresentationController.barButtonItem = sender;
    }
    [activityViewController setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        DGLog(@"%@", activityError);
    }];
    [viewController presentViewController:activityViewController animated:YES completion:nil];
}

@end

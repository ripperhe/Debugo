//
//  DGShareBarButtonItem.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/3/20.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGShareBarButtonItem.h"

@implementation DGShareBarButtonItem

- (instancetype)initWithViewController:(UIViewController *)viewController clickedShareURLsBlock:(NSArray <NSURL *>* (^)(DGShareBarButtonItem *item))clickedShareURLsBlock
{
    self = [super initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareFile:)];
    if (self) {
        self.viewController = viewController;
        self.clickedShareURLsBlock = clickedShareURLsBlock;
    }
    return self;
}

#pragma mark - share
- (void)shareFile:(UIBarButtonItem *)sender
{
    if (!self.clickedShareURLsBlock) return;
    if (!self.viewController) return;
    
    UIViewController *viewController = self.viewController;
    NSArray *items = self.clickedShareURLsBlock(self);
    if (!items.count) return;
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
        && [activityViewController respondsToSelector:@selector(popoverPresentationController)]) {
        activityViewController.popoverPresentationController.barButtonItem = sender;
    }
    [viewController presentViewController:activityViewController animated:YES completion:nil];
}

@end

//
//  DGFileBrowser.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGFileBrowser.h"
#import "DGBase.h"
#import "DGFileListViewController.h"

@implementation DGFileBrowser

- (instancetype)init
{
    return [self initWithInitialURL:nil configuration:[DGFileConfiguration new]];
}

- (instancetype)initWithInitialURL:(NSURL *)initialURL configuration:(DGFileConfiguration *)configuration
{
    
    NSURL * validInitialURL = initialURL ?: DGFilePath.sandboxDirectoryURL;
    DGFileListViewController *fileListViewController = [[DGFileListViewController alloc] initWithInitialURL:validInitialURL configuration:configuration];
    self = [super initWithRootViewController:fileListViewController];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        self->_configuration = configuration;
    }
    return self;
}

@end

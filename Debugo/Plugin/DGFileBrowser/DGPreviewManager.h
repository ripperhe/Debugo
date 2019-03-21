//
//  DGPreviewManager.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGFileConfiguration.h"

@interface DGPreviewManager : NSObject

+ (UIViewController *)previewViewControllerForFile:(DGFBFile *)file configuration:(DGFileConfiguration *)configuration;

@end

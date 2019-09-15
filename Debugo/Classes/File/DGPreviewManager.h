//
//  DGPreviewManager.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGFilePreviewConfiguration.h"

@interface DGPreviewManager : NSObject

+ (UIViewController *)previewViewControllerForFile:(DGFile *)file configuration:(DGFilePreviewConfiguration *)configuration;

@end

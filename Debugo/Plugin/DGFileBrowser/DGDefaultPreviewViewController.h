//
//  DGDefaultPreviewViewController.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import "DGFBFile.h"

@interface DGDefaultPreviewViewController : UIViewController
@property (nonatomic, strong) DGFBFile *file;
@property (nonatomic, strong) QLPreviewController *quickLookPreviewController;
@end

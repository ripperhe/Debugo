//
//  DGFolderPreviewViewController.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGFilePreviewConfiguration.h"
#import "DGFileTableViewCell.h"

@interface DGFolderPreviewViewController : UITableViewController

- (instancetype)initWithFile:(DGFile *)file configuration:(DGFilePreviewConfiguration *)configuration;

@end

//
//  DGFileListViewController.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGFileConfiguration.h"
#import "DGFileTableViewCell.h"

@interface DGFileListViewController : UITableViewController

@property (nonatomic, strong) DGFileConfiguration *configuration;

- (instancetype)initWithInitialURL:(NSURL *)initialURL configuration:(DGFileConfiguration *)configuration;

@end

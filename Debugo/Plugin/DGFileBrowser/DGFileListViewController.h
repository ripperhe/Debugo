//
//  DGFileListViewController.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGFBFile.h"
#import "DGDatabaseUIConfig.h"

typedef void (^DGFBFileDidSelectFileBlock)(DGFBFile *file);
typedef DGDatabaseUIConfig * (^DGFBFileDatabaseFileUIConfigBlock)(DGFBFile *file);

@interface DGFileListViewController : UIViewController

// Data
@property (nonatomic, copy) DGFBFileDidSelectFileBlock didSelectFile;
@property (nonatomic, copy) DGFBFileDatabaseFileUIConfigBlock databaseFileUIConfig;
@property (nonatomic, assign) BOOL allowEditing;

- (instancetype)initWithInitialURL:(NSURL *)initialURL;
- (instancetype)initWithInitialURL:(NSURL *)initialURL showCancelButton:(BOOL)showCancelButton;

@end

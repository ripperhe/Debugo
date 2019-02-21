//
//  DGDatabasePreviewViewController.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/9.
//  Copyright © 2019 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGFBFile.h"
#import "DGDatabaseUIConfig.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Reference:
 * https://github.com/YanPengImp/DatabaseVisual
 */
@interface DGDatabasePreviewViewController : UITableViewController

@property (nonatomic, strong, readonly) DGFBFile *file;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithStyle:(UITableViewStyle)style NS_UNAVAILABLE;
- (instancetype)initWithFile:(DGFBFile *)file databaseUIConfig:(nullable DGDatabaseUIConfig *)uiConfig;

@end

NS_ASSUME_NONNULL_END

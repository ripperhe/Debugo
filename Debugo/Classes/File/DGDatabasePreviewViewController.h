//
//  DGDatabasePreviewViewController.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/9.
//  Copyright © 2019 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGFile.h"
#import "DGDatabasePreviewConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Reference:
 * https://github.com/YanPengImp/DatabaseVisual
 */
@interface DGDatabasePreviewViewController : UITableViewController

@property (nonatomic, strong) DGFile *file;
@property (nonatomic, strong) DGDatabasePreviewConfiguration *previewConfiguration;

@end

NS_ASSUME_NONNULL_END

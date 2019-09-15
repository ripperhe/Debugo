//
//  DGDatabaseTableContentViewController.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/9.
//  Copyright © 2019 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGDatabaseOperation.h"
#import "DGDatabasePreviewConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGDatabaseTableContentViewController : UIViewController

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDatabaseOperation:(DGDatabaseOperation *)operation table:(DGDatabaseTableInfo *)table previewConfiguration:(nullable DGDatabasePreviewConfiguration *)previewConfiguration;

@end

NS_ASSUME_NONNULL_END

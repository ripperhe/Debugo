//
//  DGDatabaseTableInfoViewController.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/10.
//  Copyright © 2019 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGDatabaseTableInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGDatabaseTableInfoViewController : UITableViewController

@property (nonatomic, strong, readonly) DGDatabaseTableInfo *table;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithStyle:(UITableViewStyle)style NS_UNAVAILABLE;
- (instancetype)initWithTable:(DGDatabaseTableInfo *)table;

@end

NS_ASSUME_NONNULL_END

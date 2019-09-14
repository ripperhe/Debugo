//
//  DGFileInfoViewController.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/10.
//  Copyright © 2019 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGFile.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGFileInfoViewController : UITableViewController

@property (nonatomic, strong, readonly) DGFile *file;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithStyle:(UITableViewStyle)style NS_UNAVAILABLE;
- (instancetype)initWithFile:(DGFile *)file;

@end

NS_ASSUME_NONNULL_END

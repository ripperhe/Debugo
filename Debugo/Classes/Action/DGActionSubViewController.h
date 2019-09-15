//
//  DGActionSubViewController.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/22.
//  Copyright © 2019 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGActionSubViewController : UITableViewController

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithActions:(NSArray <DGAction *>*)actions;

@end

NS_ASSUME_NONNULL_END

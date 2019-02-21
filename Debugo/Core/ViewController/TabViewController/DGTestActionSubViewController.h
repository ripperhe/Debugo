//
//  DGTestActionSubViewController.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/22.
//  Copyright © 2019 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DGTestAction;


NS_ASSUME_NONNULL_BEGIN

@interface DGTestActionSubViewController : UITableViewController


+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithActions:(NSArray <DGTestAction *>*)actions;


@end

NS_ASSUME_NONNULL_END

//
//  DGDebugWindow.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/15.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGWindow.h"
#import "DGDebugViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGDebugWindow : DGWindow

/// 根控制器
@property (nonatomic, strong, readonly) DGDebugViewController *debugViewController;

@end

NS_ASSUME_NONNULL_END

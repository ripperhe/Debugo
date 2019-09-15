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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property(nullable, nonatomic, strong) DGDebugViewController *rootViewController;
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END

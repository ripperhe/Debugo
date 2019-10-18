//
//  DGActionPluginConfiguration.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/15.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGActionPluginConfiguration.h"

@interface DGActionPluginConfiguration()

@property (nonatomic, strong) NSMutableArray<DGAction *> *commonActions;

@end

@implementation DGActionPluginConfiguration

- (NSMutableArray<DGAction *> *)commonActions {
    if (!_commonActions) {
        _commonActions = [NSMutableArray array];
    }
    return _commonActions;
}

- (void)addCommonActionWithTitle:(NSString *)title handler:(DGActionHandlerBlock)handler {
    [self.commonActions addObject:[DGAction actionWithTitle:title autoClose:YES handler:handler]];
}

- (void)addCommonActionWithTitle:(NSString *)title handler:(DGActionHandlerBlock)handler autoClose:(BOOL)autoClose {
    [self.commonActions addObject:[DGAction actionWithTitle:title autoClose:autoClose handler:handler]];
}

- (NSArray<DGAction *> *)getAllCommonActions {
    return self.commonActions;
}

@end

//
//  DGAnimationDelegate.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/13.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGAnimationDelegate.h"

@implementation DGAnimationDelegate

+ (instancetype)animationDelegateWithDidStart:(void (^)(CAAnimation * _Nonnull))startBlock didStop:(void (^)(CAAnimation * _Nonnull, BOOL))stopBlock {
    DGAnimationDelegate *delegate = [self new];
    delegate.didStartBlock = startBlock;
    delegate.didStopBlock = stopBlock;
    return delegate;
}

- (void)animationDidStart:(CAAnimation *)anim {
    if (self.didStartBlock) {
        self.didStartBlock(anim);
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.didStopBlock) {
        self.didStopBlock(anim, flag);
    }
}

@end

//
//  DGAnimationDelegate.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/13.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGAnimationDelegate : NSObject<CAAnimationDelegate>

@property (nonatomic, copy) void(^didStartBlock)(CAAnimation *animation);
@property (nonatomic, copy) void(^didStopBlock)(CAAnimation *animation, BOOL finishFlag);

+ (instancetype)animationDelegateWithDidStart:(nullable void (^)(CAAnimation *animation))startBlock didStop:(nullable void (^)(CAAnimation *animation, BOOL finishFlag))stopBlock;

@end

NS_ASSUME_NONNULL_END

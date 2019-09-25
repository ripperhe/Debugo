//
//  UIControl+Debugo.h
//  StaticTableView
//
//  Created by ripper on 2019/9/25.
//  Copyright © 2019 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGReceiver : NSObject

@property (nonatomic, copy) void(^handler)(id sender);
@property (nonatomic, assign) UIControlEvents controlEvents;

- (void)receiveAction:(id)sender;

@end

@interface UIControl (DGStaticProvider)

- (DGReceiver *)dg_addReceiverForControlEvents:(UIControlEvents)controlEvents handler:(void (^)(id sender))handler;

- (void)dg_removeReceiver:(DGReceiver *)receiver;

- (void)dg_removeAllReceivers;

@end

NS_ASSUME_NONNULL_END

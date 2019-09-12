//
//  DGTouchWindow.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGTouchWindow.h"
#import <objc/runtime.h>
#import "DGTouchFingerView.h"

static const void* kDGFingerViewAssociatedKey = &kDGFingerViewAssociatedKey;

@interface DGTouchWindow ()

@property (nonatomic, weak) UIView *touchesView;

@end

@implementation DGTouchWindow

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.name = @"DGTouchPlugin Window";
        self.windowLevel = CGFLOAT_MAX;
        self.userInteractionEnabled = NO;
        self.rootViewController = [UIViewController new];
        self.rootViewController.view.userInteractionEnabled = NO;
        self.touchesView = self.rootViewController.view;
    }
    return self;
}

#pragma mark - event

- (void)displayEvent:(UIEvent *)event {
    NSSet *touches = [event allTouches];
    for (UITouch *touch in touches) {
        if (touch.phase == UITouchPhaseCancelled || touch.phase == UITouchPhaseEnded) {
            [self removeFingerViewForTouch:touch];
        } else {
            [self updateFingerViewForTouch:touch];
        }
    }
}

- (void)updateFingerViewForTouch:(UITouch *)touch {
    DGTouchFingerView *fingerView = objc_getAssociatedObject(touch, kDGFingerViewAssociatedKey);
    CGPoint point = [touch locationInView:self.touchesView];
    if (!fingerView) {
        fingerView = [[DGTouchFingerView alloc] initWithPoint:point];
        objc_setAssociatedObject(touch, kDGFingerViewAssociatedKey, fingerView, OBJC_ASSOCIATION_ASSIGN);
        [self.touchesView addSubview:fingerView];
    }
    [fingerView updateWithTouch:touch];
}

- (void)removeFingerViewForTouch:(UITouch *)touch {
    DGTouchFingerView * fingerView = objc_getAssociatedObject (touch, kDGFingerViewAssociatedKey);
    if (fingerView) {
        objc_setAssociatedObject(touch, kDGFingerViewAssociatedKey, nil, OBJC_ASSOCIATION_ASSIGN);
        [fingerView removeFromSuperviewWithAnimation];
    }
}

@end

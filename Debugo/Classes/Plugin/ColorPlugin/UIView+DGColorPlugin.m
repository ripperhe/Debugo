//
//  UIView+DGColorPlugin.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/26.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "UIView+DGColorPlugin.h"
#import <objc/runtime.h>
#import "DGCommon.h"
#import "DebugoEnable.h"

@implementation UIView (DGColorPlugin)

#if DebugoCanBeEnabled

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self dg_swizzleInstanceMethod:@selector(layoutSubviews) newSelector:@selector(dg_layoutSubviews)];
    });
}

- (void)dg_layoutSubviews {
    [self dg_layoutSubviews];
    [UIView __dg_renderView:self];
}

#pragma mark - render

+ (void)__dg_renderView:(UIView *)view {
    if (view.dg_renderType > 0) {
        // 需要渲染
        view.dg_hasBeenRendered = YES;
        if (view.dg_renderType == DGRenderTypeLeaves) {
            if (view.dg_hasDebugColor) {
                view.dg_hasDebugColor = NO;
                view.backgroundColor = view.dg_originalColor;
                view.dg_originalColor = nil;
            }
        }else {
            if (!view.dg_hasDebugColor) {
                view.dg_hasDebugColor = YES;
                view.dg_originalColor = view.backgroundColor;
            }
            view.backgroundColor = [view __dg_debugColor];
        }
        [UIView __dg_renderSubviewsForView:view];
    }else {
        // 需要还原
        if (view.dg_hasBeenRendered) {
            view.dg_hasBeenRendered = NO;
            if (view.dg_hasDebugColor) {
                view.dg_hasDebugColor = NO;
                view.backgroundColor = view.dg_originalColor;
                view.dg_originalColor = nil;
            }
            [UIView __dg_renderSubviewsForView:view];
        }
    }
}

+ (void)__dg_renderSubviewsForView:(UIView *)view {
    NSArray<UIView *> *subviews = nil;
    if (@available(iOS 9.0, *)) {
        if ([view isKindOfClass:[UIStackView class]]) {
            subviews = ((UIStackView *)view).arrangedSubviews;
        }else {
            subviews = view.subviews;
        }
    }else {
        subviews = view.subviews;
    }
    [subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.dg_colorType = view.dg_colorType;
        if (view.dg_renderType > 0) {
            obj.dg_renderType = DGRenderTypeContainerAndLeaves;
        }else {
            obj.dg_renderType = DGRenderTypeNone;
        }
        [UIView __dg_renderView:obj];
    }];
}

- (UIColor *)__dg_debugColor {
    if (self.dg_colorType == DGColorTypeRandomColor) {
        return [UIColor dg_lightRandomColor];
    }else if (self.dg_colorType == DGColorTypeRandomColorWithAlpha) {
        return [[UIColor dg_randomColor] colorWithAlphaComponent:0.3];
    }else {
        return [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.3];
    }
}

#endif

#pragma mark - setter getter

static const void * kAssociatedObjectKey_debugRenderType = &kAssociatedObjectKey_debugRenderType;
- (DGRenderType)dg_renderType {
#if DebugoCanBeEnabled
    return [objc_getAssociatedObject(self, kAssociatedObjectKey_debugRenderType) integerValue];
#else
    return DGRenderTypeNone;
#endif
}

- (void)setDg_renderType:(DGRenderType)dg_renderType {
#if DebugoCanBeEnabled
    objc_setAssociatedObject(self, kAssociatedObjectKey_debugRenderType, @(dg_renderType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    // 只要设置就刷新，因为可能需要还原
    [self setNeedsLayout];
#endif
}

static const void * kAssociatedObjectKey_debugColorType = &kAssociatedObjectKey_debugColorType;
- (DGColorType)dg_colorType {
#if DebugoCanBeEnabled
    return [objc_getAssociatedObject(self, kAssociatedObjectKey_debugColorType) integerValue];
#else
    return DGColorTypeRandomColor;
#endif
}

- (void)setDg_colorType:(DGColorType)dg_colorType {
#if DebugoCanBeEnabled
    objc_setAssociatedObject(self, kAssociatedObjectKey_debugColorType, @(dg_colorType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.dg_renderType > 0) {
        [self setNeedsLayout];
    }
#endif
}

static const void * kAssociatedObjectKey_hasBeenRendered = &kAssociatedObjectKey_hasBeenRendered;
- (BOOL)dg_hasBeenRendered {
#if DebugoCanBeEnabled
    return [objc_getAssociatedObject(self, kAssociatedObjectKey_hasBeenRendered) integerValue];
#else
    return NO;
#endif
}

- (void)setDg_hasBeenRendered:(BOOL)dg_hasBeenRendered {
#if DebugoCanBeEnabled
    objc_setAssociatedObject(self, kAssociatedObjectKey_hasBeenRendered, @(dg_hasBeenRendered), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#endif
}

static const void * kAssociatedObjectKey_hasDebugColor = &kAssociatedObjectKey_hasDebugColor;
- (BOOL)dg_hasDebugColor {
#if DebugoCanBeEnabled
    BOOL value = [objc_getAssociatedObject(self, kAssociatedObjectKey_hasDebugColor) boolValue];
    return value;
#else
    return NO;
#endif
}

- (void)setDg_hasDebugColor:(BOOL)dg_hasDebugColor {
#if DebugoCanBeEnabled
    objc_setAssociatedObject(self, kAssociatedObjectKey_hasDebugColor, @(dg_hasDebugColor), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#endif
}

static const void * kAssociatedObjectKey_originalColor = &kAssociatedObjectKey_originalColor;
- (UIColor *)dg_originalColor {
#if DebugoCanBeEnabled
    return objc_getAssociatedObject(self, kAssociatedObjectKey_originalColor);
#else
    return nil;
#endif
}

- (void)setDg_originalColor:(UIColor * _Nullable)dg_originalColor {
#if DebugoCanBeEnabled
    objc_setAssociatedObject(self, kAssociatedObjectKey_originalColor, dg_originalColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#endif
}

@end

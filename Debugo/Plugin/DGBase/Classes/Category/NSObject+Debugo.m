//
//  NSObject+DGSuspensionView.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "NSObject+Debugo.h"
#import <objc/runtime.h>

static const void *kDGStrongExtObjKey = &kDGStrongExtObjKey;
static const void *kDGWeakExtObjKey = &kDGWeakExtObjKey;
static const void *kDGCopyExtObjKey = &kDGCopyExtObjKey;

@implementation NSObject (Debugo)


- (void)setDg_strongExtObj:(id)dg_strongExtObj
{
    objc_setAssociatedObject(self, kDGStrongExtObjKey, dg_strongExtObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)dg_strongExtObj
{
    return objc_getAssociatedObject(self, kDGStrongExtObjKey);
}

- (void)setDg_weakExtObj:(id)dg_weakExtObj
{
    objc_setAssociatedObject(self, kDGWeakExtObjKey, dg_weakExtObj, OBJC_ASSOCIATION_ASSIGN);
}

- (id)dg_weakExtObj
{
    return objc_getAssociatedObject(self, kDGWeakExtObjKey);
}

- (void)setDg_copyExtObj:(id)dg_copyExtObj
{
    objc_setAssociatedObject(self, kDGCopyExtObjKey, dg_copyExtObj, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id)dg_copyExtObj
{
    return objc_getAssociatedObject(self, kDGCopyExtObjKey);
}

+ (void)dg_swizzleInstanceMethod:(SEL)originalSelector newSelector:(SEL)newSelector {
    @synchronized (self) {
        Class class = [self class];
        
        [[self class] dg_swizzleInstanceMethod:originalSelector newSelector:newSelector inClass:class];
    }
}

+ (void)dg_swizzleInstanceMethod:(SEL)originalSelector newSelector:(SEL)newSelector inClass:(Class)class {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method newMethod = class_getInstanceMethod(class, newSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

+ (void)dg_swizzleClassMethod:(SEL)originalSelector newSelector:(SEL)newSelector {
    @synchronized (self) {
        Class class = object_getClass((id)self);
        
        [self dg_swizzleClassMethod:originalSelector newSelector:newSelector inClass:class];
    }
}

+ (void)dg_swizzleClassMethod:(SEL)originalSelector newSelector:(SEL)newSelector inClass:(Class)class {
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method newMethod = class_getInstanceMethod(class, newSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

@end

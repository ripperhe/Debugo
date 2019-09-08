//
//  NSObject+Debugo.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "NSObject+Debugo.h"
#import <objc/runtime.h>

@implementation NSObject (Debugo)

static const void *kAssociatedObjectKey_strongExtObj = &kAssociatedObjectKey_strongExtObj;
- (void)setDg_strongExtObj:(id)dg_strongExtObj {
    objc_setAssociatedObject(self, kAssociatedObjectKey_strongExtObj, dg_strongExtObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)dg_strongExtObj {
    return objc_getAssociatedObject(self, kAssociatedObjectKey_strongExtObj);
}

static const void *kAssociatedObjectKey_weakExtObj = &kAssociatedObjectKey_weakExtObj;
- (void)setDg_weakExtObj:(id)dg_weakExtObj {
    objc_setAssociatedObject(self, kAssociatedObjectKey_weakExtObj, dg_weakExtObj, OBJC_ASSOCIATION_ASSIGN);
}

- (id)dg_weakExtObj {
    return objc_getAssociatedObject(self, kAssociatedObjectKey_weakExtObj);
}

static const void *kAssociatedObjectKey_copyExtObj = &kAssociatedObjectKey_copyExtObj;
- (void)setDg_copyExtObj:(id)dg_copyExtObj {
    objc_setAssociatedObject(self, kAssociatedObjectKey_copyExtObj, dg_copyExtObj, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id)dg_copyExtObj {
    return objc_getAssociatedObject(self, kAssociatedObjectKey_copyExtObj);
}

@end

@implementation NSObject (Debugo_Runtime)

+ (void)dg_swizzleInstanceMethod:(SEL)originalSelector newSelector:(SEL)newSelector {
    @synchronized (self) {
        Class class = [self class];
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method newMethod = class_getInstanceMethod(class, newSelector);
        
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, newMethod);
        }
    }
}

+ (void)dg_swizzleClassMethod:(SEL)originalSelector newSelector:(SEL)newSelector {
    @synchronized (self) {
        Class class = object_getClass((id)self);
        
        Method originalMethod = class_getClassMethod(class, originalSelector);
        Method newMethod = class_getInstanceMethod(class, newSelector);
        
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, newMethod);
        }
    }
}

@end

@implementation NSObject (Debugo_Make)

+ (instancetype)dg_make:(void (^)(id))block {
    NSObject *obj = [self new];
    block(obj);
    return obj;
}

- (id)dg_put:(void (^)(id))block {
    block(self);
    return self;
}

@end

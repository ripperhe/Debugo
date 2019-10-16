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

static const void *kAssociatedObjectKey_extStrongObj = &kAssociatedObjectKey_extStrongObj;
- (void)setDg_extStrongObj:(id)dg_extStrongObj {
    objc_setAssociatedObject(self, kAssociatedObjectKey_extStrongObj, dg_extStrongObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)dg_extStrongObj {
    return objc_getAssociatedObject(self, kAssociatedObjectKey_extStrongObj);
}

static const void *kAssociatedObjectKey_extWeakObj = &kAssociatedObjectKey_extWeakObj;
- (void)setDg_extWeakObj:(id)dg_extWeakObj {
    objc_setAssociatedObject(self, kAssociatedObjectKey_extWeakObj, dg_extWeakObj, OBJC_ASSOCIATION_ASSIGN);
}

- (id)dg_extWeakObj {
    return objc_getAssociatedObject(self, kAssociatedObjectKey_extWeakObj);
}

static const void *kAssociatedObjectKey_extCopyObj = &kAssociatedObjectKey_extCopyObj;
- (void)setDg_extCopyObj:(id)dg_extCopyObj {
    objc_setAssociatedObject(self, kAssociatedObjectKey_extCopyObj, dg_extCopyObj, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id)dg_extCopyObj {
    return objc_getAssociatedObject(self, kAssociatedObjectKey_extCopyObj);
}

static const void *kAssociatedObjectKey_extArray = &kAssociatedObjectKey_extArray;
- (void)setDg_extArray:(NSMutableArray *)dg_extArray {
    objc_setAssociatedObject(self, kAssociatedObjectKey_extArray, dg_extArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)dg_extArray {
    NSMutableArray *array = objc_getAssociatedObject(self, kAssociatedObjectKey_extArray);
    if (!array) {
        array = [NSMutableArray array];
        [self setDg_extArray:array];
    }
    return array;
}

static const void *kAssociatedObjectKey_extDictionary = &kAssociatedObjectKey_extDictionary;
- (void)setDg_extDictionary:(NSMutableDictionary *)dg_extDictionary {
    objc_setAssociatedObject(self, kAssociatedObjectKey_extDictionary, dg_extDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)dg_extDictionary {
    NSMutableDictionary *dic = objc_getAssociatedObject(self, kAssociatedObjectKey_extDictionary);
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
        [self setDg_extDictionary:dic];
    }
    return dic;
}

static const void *kAssociatedObjectKey_extHash = &kAssociatedObjectKey_extHash;
- (void)setDg_extHash:(NSHashTable *)dg_extHash {
    objc_setAssociatedObject(self, kAssociatedObjectKey_extHash, dg_extHash, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSHashTable *)dg_extHash {
    NSHashTable *hash = objc_getAssociatedObject(self, kAssociatedObjectKey_extHash);
    if (!hash) {
        hash = [NSHashTable hashTableWithOptions:NSHashTableWeakMemory];
        [self setDg_extHash:hash];
    }
    return hash;
}

static const void *kAssociatedObjectKey_extMap = &kAssociatedObjectKey_extMap;
- (void)setDg_extMap:(NSMapTable *)dg_extMap {
    objc_setAssociatedObject(self, kAssociatedObjectKey_extMap, dg_extMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMapTable *)dg_extMap {
    NSMapTable *map = objc_getAssociatedObject(self, kAssociatedObjectKey_extMap);
    if (!map) {
        map = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableWeakMemory];
        [self setDg_extMap:map];
    }
    return map;
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

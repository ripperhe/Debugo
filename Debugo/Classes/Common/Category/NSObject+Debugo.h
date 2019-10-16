//
//  NSObject+Debugo.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSObject (Debugo)

/// 扩展 strong 属性
@property (nonatomic, strong) id dg_extStrongObj;
/// 扩展 weak 属性
@property (nonatomic, weak) id dg_extWeakObj;
/// 扩展 copy 属性
@property (nonatomic, copy) id dg_extCopyObj;
/// 扩展可变数组，懒加载初始化
@property (nonatomic, strong) NSMutableArray *dg_extArray;
/// 扩展可变字典，懒加载初始化
@property (nonatomic, strong) NSMutableDictionary *dg_extDictionary;
/// 扩展弱引用 value 的 hash table，懒加载初始化
@property (nonatomic, strong) NSHashTable *dg_extHash;
/// 扩展强引用 key，弱引用 value 的 map table，懒加载初始化
@property (nonatomic, strong) NSMapTable *dg_extMap;

@end

@interface NSObject (Debugo_Runtime)

+ (void)dg_swizzleInstanceMethod:(SEL)originalSelector newSelector:(SEL)newSelector;

+ (void)dg_swizzleClassMethod:(SEL)originalSelector newSelector:(SEL)newSelector;

@end

@interface NSObject (Debugo_Make)

+ (instancetype)dg_make:(void (^)(id obj))block;

- (id)dg_put:(void (^)(id obj))block;

@end

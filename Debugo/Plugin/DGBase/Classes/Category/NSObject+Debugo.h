//
//  NSObject+DGSuspensionView.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSObject (Debugo)

@property (nonatomic, strong) id dg_strongExtObj;
@property (nonatomic, weak) id dg_weakExtObj;
@property (nonatomic, copy) id dg_copyExtObj;

+ (void)dg_swizzleInstanceMethod:(SEL)originalSelector newSelector:(SEL)newSelector;
+ (void)dg_swizzleInstanceMethod:(SEL)originalSelector newSelector:(SEL)newSelector inClass:(Class)class;

+ (void)dg_swizzleClassMethod:(SEL)originalSelector newSelector:(SEL)newSelector;
+ (void)dg_swizzleClassMethod:(SEL)originalSelector newSelector:(SEL)newSelector inClass:(Class)class;

@end

//
//  DGBundle.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGBundle.h"

@implementation DGBundle

+ (NSBundle *)bundle {
    static NSBundle *_bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 利用 cocoapods 安装，不使用 framework 的情况下 就是 main bundle
        // 使用  use_frameworks! 则会生成 Debugo.framework
        // 而 Debugo.bundle 在 Debugo.framework 内部，所以直接使用 [NSBundle mainBundle] 不行
        NSBundle *selfBundle = [NSBundle bundleForClass:[self class]];
        NSString *bundlePath = [selfBundle pathForResource:@"Debugo" ofType:@"bundle"];
        _bundle = [NSBundle bundleWithPath:bundlePath];
    });
    return _bundle;
}

+ (UIImage *)imageNamed:(NSString *)name; {
    NSBundle *bundle = self.bundle;
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    NSAssert(image, @"DGBundle：name 为 %@ 的图片找不到", name);
    return image;
}

@end

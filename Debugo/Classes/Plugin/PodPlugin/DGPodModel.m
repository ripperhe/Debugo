//
//  DGPodModel.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/10/24.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGPodModel.h"

@interface DGPodModel ()
{
    NSString *_realName;
    NSString *_realVersion;
}

@end

@implementation DGPodModel

- (NSString *)name {
    if (_realName.length) {
        return _realName;
    }
    DGPodModel *sub = self.subPods.sortedValues.firstObject;
    if (sub.name.length) {
        NSString *name = [sub.name stringByDeletingLastPathComponent];
        if (name.length) {
            return name;
        }
    }
    return nil;
}

- (void)setName:(NSString *)name {
    _realName = name;
    if ([name containsString:@"/"]) {
        self.nameComponents = [name componentsSeparatedByString:@"/"];
    }else {
        self.nameComponents = @[name];
    }
}

- (NSString *)version {
    if (_realVersion.length) {
        return _realVersion;
    }
    DGPodModel *sub = self.subPods.sortedValues.firstObject;
    if (sub.version.length) {
        return sub.version;
    }
    return nil;
}

- (void)setVersion:(NSString *)version {
    _realVersion = version;
}

- (DGOrderedDictionary<NSString *,DGPodModel *> *)subPods {
    if (!_subPods) {
        _subPods = [DGOrderedDictionary dictionary];
    }
    return _subPods;
}

@end

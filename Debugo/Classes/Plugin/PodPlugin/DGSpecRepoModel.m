//
//  DGSpecRepoModel.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/10/25.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGSpecRepoModel.h"

@implementation DGSpecRepoModel

- (void)setUrl:(NSString *)url {
    _url = url;
    NSString *lowercaseString = url.lowercaseString;
    if ([lowercaseString hasPrefix:@"https://github.com/cocoapods/specs.git"] ||
        [lowercaseString hasPrefix:@"https://cdn.cocoapods.org"] || [lowercaseString hasPrefix:@"trunk"]) {
        _isOfficial = YES;
    }else {
        _isOfficial = NO;
    }
    if ([lowercaseString hasPrefix:@"http"]) {
        _isRemote = YES;
    }else {
        _isRemote = NO;
    }
}

- (DGOrderedDictionary<NSString *,DGPodModel *> *)pods {
    if (!_pods) {
        _pods = [DGOrderedDictionary dictionary];
    }
    return _pods;
}

@end

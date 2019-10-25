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
    if ([url hasPrefix:@"https://github.com/cocoapods/specs.git"]) {
        _isOfficial = YES;
    }else {
        _isOfficial = NO;
    }
    if ([url hasPrefix:@"http"]) {
        _isRemote = YES;
    }else {
        _isRemote = NO;
    }
}

- (NSMutableArray<DGPodModel *> *)pods {
    if (!_pods) {
        _pods = [NSMutableArray array];
    }
    return _pods;
}

@end

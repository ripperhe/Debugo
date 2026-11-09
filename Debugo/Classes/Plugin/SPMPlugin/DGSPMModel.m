//
//  DGSPMModel.m
//  Debugo
//
//  Created by ripper on 2026/11/9.
//  Copyright © 2026 ripperhe. All rights reserved.
//

#import "DGSPMModel.h"

@interface DGSPMModel ()
{
    NSString *_displayVersion;
}
@property (nonatomic, copy, nullable, readwrite) NSString *gitHubOwner;
@property (nonatomic, copy, nullable, readwrite) NSString *gitHubRepo;
@property (nonatomic, assign, readwrite) BOOL isGitHub;
@end

@implementation DGSPMModel

- (void)setLocation:(NSString *)location {
    _location = [location copy];
    [self dg_parseGitHubFromLocation:_location];
    NSString *fromLocation = [self dg_displayNameFromLocation:_location identity:_identity];
    if (fromLocation.length) {
        // location 更能保留原始大小写（identity 常为全小写）
        _name = fromLocation;
    }
}

- (void)setIdentity:(NSString *)identity {
    _identity = [identity copy];
    if (!_name.length) {
        _name = [self dg_displayNameFromLocation:_location identity:_identity];
    }
}

- (NSString *)version {
    if (_displayVersion.length) {
        return _displayVersion;
    }
    if (self.resolvedVersion.length) {
        return self.resolvedVersion;
    }
    NSString *shortRev = nil;
    if (self.revision.length >= 7) {
        shortRev = [self.revision substringToIndex:7];
    } else {
        shortRev = self.revision;
    }
    if (self.branch.length && shortRev.length) {
        return [NSString stringWithFormat:@"%@@%@", self.branch, shortRev];
    }
    if (self.branch.length) {
        return self.branch;
    }
    return shortRev;
}

- (void)setVersion:(NSString *)version {
    _displayVersion = [version copy];
}

- (void)dg_parseGitHubFromLocation:(NSString *)location {
    self.isGitHub = NO;
    self.gitHubOwner = nil;
    self.gitHubRepo = nil;
    if (!location.length) {
        return;
    }
    NSString *lower = location.lowercaseString;
    NSString *path = nil;
    if ([lower hasPrefix:@"https://github.com/"]) {
        path = [location substringFromIndex:@"https://github.com/".length];
    } else if ([lower hasPrefix:@"http://github.com/"]) {
        path = [location substringFromIndex:@"http://github.com/".length];
    } else if ([lower hasPrefix:@"git@github.com:"]) {
        path = [location substringFromIndex:@"git@github.com:".length];
    } else if ([lower hasPrefix:@"ssh://git@github.com/"]) {
        path = [location substringFromIndex:@"ssh://git@github.com/".length];
    }
    if (!path.length) {
        return;
    }
    if ([path hasSuffix:@".git"]) {
        path = [path substringToIndex:path.length - 4];
    }
    // strip query / fragment
    NSRange cut = [path rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"?#"]];
    if (cut.location != NSNotFound) {
        path = [path substringToIndex:cut.location];
    }
    NSArray<NSString *> *parts = [path componentsSeparatedByString:@"/"];
    if (parts.count < 2) {
        return;
    }
    NSString *owner = parts[0];
    NSString *repo = parts[1];
    if (!owner.length || !repo.length) {
        return;
    }
    self.isGitHub = YES;
    self.gitHubOwner = owner;
    self.gitHubRepo = repo;
}

- (NSString *)dg_displayNameFromLocation:(NSString *)location identity:(NSString *)identity {
    if (location.length) {
        NSString *last = location.lastPathComponent;
        if ([last.lowercaseString hasSuffix:@".git"]) {
            last = [last substringToIndex:last.length - 4];
        }
        if (last.length) {
            return last;
        }
    }
    return identity.length ? identity : @"Unknown";
}

@end

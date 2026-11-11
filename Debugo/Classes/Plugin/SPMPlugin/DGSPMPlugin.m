//
//  DGSPMPlugin.m
//  Debugo
//
//  Created by ripper on 2026/11/9.
//  Copyright © 2026 ripperhe. All rights reserved.
//

#import "DGSPMPlugin.h"
#import "DGSPMPluginViewController.h"
#import "DGPodPlugin.h"
#import "DGCommon.h"

@implementation DGSPMPlugin

+ (NSString *)pluginName {
    return @"Swift Package Manager";
}

+ (UIImage *)pluginImage {
    return [DGBundle imageNamed:@"plugin_spm"];
}

+ (UIImage *)pluginTabBarImage:(BOOL)isSelected {
    if (isSelected) {
        return [DGBundle imageNamed:@"tab_spm_selected"];
    }
    return [DGBundle imageNamed:@"tab_spm_normal"];
}

+ (UIViewController *)pluginViewController {
    return [DGSPMPluginViewController new];
}

#pragma mark - Parse

+ (NSArray<DGSPMModel *> *)parsePackageResolvedWithPath:(NSString *)path {
    @try {
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (!data.length) {
            return nil;
        }
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error || ![json isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        NSDictionary *root = (NSDictionary *)json;
        NSNumber *versionNumber = root[@"version"];
        NSInteger formatVersion = versionNumber ? versionNumber.integerValue : 0;
        
        NSArray *pins = nil;
        if (formatVersion >= 2) {
            // v2 / v3: { "pins": [ ... ], "version": 3 }
            pins = root[@"pins"];
        } else {
            // v1: { "object": { "pins": [ ... ] }, "version": 1 }
            NSDictionary *object = root[@"object"];
            if ([object isKindOfClass:[NSDictionary class]]) {
                pins = object[@"pins"];
            }
            if (![pins isKindOfClass:[NSArray class]]) {
                // 兜底：有些工具可能直接给 pins
                pins = root[@"pins"];
            }
        }
        if (![pins isKindOfClass:[NSArray class]] || !pins.count) {
            return nil;
        }
        
        NSMutableArray<DGSPMModel *> *packages = [NSMutableArray arrayWithCapacity:pins.count];
        for (id item in pins) {
            if (![item isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            DGSPMModel *model = [self parsePinDictionary:(NSDictionary *)item formatVersion:formatVersion];
            if (model) {
                [packages addObject:model];
            }
        }
        
        // 按展示名排序，方便浏览
        [packages sortUsingComparator:^NSComparisonResult(DGSPMModel * _Nonnull obj1, DGSPMModel * _Nonnull obj2) {
            return [obj1.name.lowercaseString compare:obj2.name.lowercaseString];
        }];
        return packages.count ? packages : nil;
    } @catch (NSException *exception) {
        return nil;
    }
}

+ (DGSPMModel *)parsePinDictionary:(NSDictionary *)pin formatVersion:(NSInteger)formatVersion {
    DGSPMModel *model = [DGSPMModel new];
    NSDictionary *state = nil;
    if ([pin[@"state"] isKindOfClass:[NSDictionary class]]) {
        state = pin[@"state"];
    }
    
    if (formatVersion >= 2) {
        model.identity = [self dg_stringValue:pin[@"identity"]];
        model.location = [self dg_stringValue:pin[@"location"]];
        model.kind = [self dg_stringValue:pin[@"kind"]];
    } else {
        // v1
        model.identity = [self dg_stringValue:pin[@"package"]];
        model.location = [self dg_stringValue:pin[@"repositoryURL"]];
        if (!model.identity.length) {
            model.identity = [self dg_stringValue:pin[@"identity"]];
        }
        if (!model.location.length) {
            model.location = [self dg_stringValue:pin[@"location"]];
        }
    }
    
    if (!model.identity.length && !model.location.length) {
        return nil;
    }
    
    if ([state isKindOfClass:[NSDictionary class]]) {
        model.resolvedVersion = [self dg_stringValue:state[@"version"]];
        model.revision = [self dg_stringValue:state[@"revision"]];
        model.branch = [self dg_stringValue:state[@"branch"]];
        // 有明确 version 时直接作为展示版本
        if (model.resolvedVersion.length) {
            model.version = model.resolvedVersion;
        }
    }
    
    // 触发 name / github 解析
    if (model.location) {
        model.location = model.location;
    } else if (model.identity) {
        model.identity = model.identity;
    }
    return model;
}

+ (NSString *)dg_stringValue:(id)value {
    if ([value isKindOfClass:[NSString class]]) {
        NSString *string = (NSString *)value;
        return string.length ? string : nil;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)value stringValue];
    }
    return nil;
}

#pragma mark - Latest version (GitHub)

+ (void)queryLatestVersionForPackage:(DGSPMModel *)package completion:(void (^)(NSString * _Nullable, NSError * _Nullable))completion {
    if (!completion) {
        return;
    }
    if (!package.isGitHub || !package.gitHubOwner.length || !package.gitHubRepo.length) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, nil);
        });
        return;
    }
    
    NSString *owner = package.gitHubOwner;
    NSString *repo = package.gitHubRepo;
    NSString *releaseURLString = [NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/releases/latest", owner, repo];
    
    [self dg_getJSONFromURLString:releaseURLString completion:^(id  _Nullable json, NSError * _Nullable error) {
        NSString *tag = nil;
        if ([json isKindOfClass:[NSDictionary class]]) {
            tag = [self dg_stringValue:json[@"tag_name"]];
        }
        if (tag.length) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion([self dg_normalizedVersionTag:tag], nil);
            });
            return;
        }
        
        // releases 没有（或 404）时回退 tags
        NSString *tagsURLString = [NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/tags?per_page=30", owner, repo];
        [self dg_getJSONFromURLString:tagsURLString completion:^(id  _Nullable tagsJSON, NSError * _Nullable tagsError) {
            NSString *best = [self dg_pickLatestSemanticTagFromTagsJSON:tagsJSON];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(best, best ? nil : (tagsError ?: error));
            });
        }];
    }];
}

+ (void)dg_getJSONFromURLString:(NSString *)urlString completion:(void (^)(id _Nullable json, NSError * _Nullable error))completion {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.timeoutInterval = 15;
    // 未认证请求限流较低；标明 Accept，失败时静默即可
    [request setValue:@"application/vnd.github+json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"Debugo-SPMPlugin" forHTTPHeaderField:@"User-Agent"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error || !data.length) {
            completion(nil, error);
            return;
        }
        NSInteger status = 0;
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            status = [(NSHTTPURLResponse *)response statusCode];
        }
        if (status == 403 || status == 429) {
            // rate limit：软失败
            completion(nil, error);
            return;
        }
        if (status >= 400) {
            completion(nil, error);
            return;
        }
        NSError *serialError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serialError];
        completion(serialError ? nil : json, serialError);
    }];
    [task resume];
}

+ (NSString *)dg_normalizedVersionTag:(NSString *)tag {
    if (!tag.length) {
        return nil;
    }
    NSString *result = tag;
    if ([result.lowercaseString hasPrefix:@"v"] && result.length > 1) {
        unichar second = [result characterAtIndex:1];
        if (second >= '0' && second <= '9') {
            result = [result substringFromIndex:1];
        }
    }
    return result;
}

+ (NSString *)dg_pickLatestSemanticTagFromTagsJSON:(id)tagsJSON {
    if (![tagsJSON isKindOfClass:[NSArray class]]) {
        return nil;
    }
    NSString *best = nil;
    for (id item in (NSArray *)tagsJSON) {
        if (![item isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        NSString *name = [self dg_stringValue:item[@"name"]];
        NSString *normalized = [self dg_normalizedVersionTag:name];
        if (!normalized.length) {
            continue;
        }
        // 跳过明显非版本号的 tag
        unichar first = [normalized characterAtIndex:0];
        if (first < '0' || first > '9') {
            continue;
        }
        if (!best) {
            best = normalized;
            continue;
        }
        if ([self compareVersionA:best withVersionB:normalized] == NSOrderedAscending) {
            best = normalized;
        }
    }
    return best;
}

+ (NSComparisonResult)compareVersionA:(NSString *)versionA withVersionB:(NSString *)versionB {
    return [DGPodPlugin compareVersionA:versionA ?: @"" withVersionB:versionB ?: @""];
}

@end

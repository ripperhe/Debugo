//
//  DGPodPlugin.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/10/25.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGPodPlugin.h"
#import "DGPodPluginViewController.h"

@implementation DGPodPlugin

+ (NSString *)pluginName {
    return @"CocoaPods";
}

+ (UIImage *)pluginImage {
    return [DGBundle imageNamed:@"plugin_pod"];
}

+ (UIImage *)pluginTabBarImage:(BOOL)isSelected {
    if (isSelected) {
        return [DGBundle imageNamed:@"tab_pod_selected"];
    }
    return [DGBundle imageNamed:@"tab_pod_normal"];
}

+ (UIViewController *)pluginViewController {
    return [DGPodPluginViewController new];
}

#pragma mark -

static DGPodPlugin *_instance;
+ (instancetype)shared {
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[self alloc] init];
        });
    }
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (NSArray<DGSpecRepoModel *> *)parsePodfileLockWithPath:(NSString *)path {
    @try {
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        content = [content stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSArray<NSString *> *components = [content componentsSeparatedByString:@"\n"];
        
        NSMutableArray<DGSpecRepoModel *> *specRepos = [NSMutableArray array];
        DGPodModel *totalPod = [DGPodModel new];
        __block BOOL isPod = NO;
        __block BOOL isSpecRepo = NO;
        __block DGSpecRepoModel *currentSpecRepo = nil;
        [components enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 控制头部
            if (obj.length && ![obj hasPrefix:@"  "]) {
                // 没有空格就是头部
                if ([obj hasPrefix:@"PODS:"]) {
                    isPod = YES;
                }else {
                    isPod = NO;
                }
                
                if ([obj hasPrefix:@"SPEC REPOS:"]) {
                    isSpecRepo = YES;
                }else {
                    isSpecRepo = NO;
                }
            }
            // 读取内容
            if (isPod && [obj hasPrefix:@"  - "]) {
                DGPodModel *pod = [self parsePodString:obj];
                if (pod) {
                    __block DGPodModel *parentPod = totalPod;
                    [pod.nameComponents enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        DGPodModel *subPod = [parentPod.subPods objectForKey:obj];
                        if (!subPod) {
                            subPod = [DGPodModel new];
                            [parentPod.subPods setObject:subPod forKey:obj];
                        }
                        if (idx == pod.nameComponents.count - 1) {
                            // 最后一个，更新
                            subPod.name = pod.name;
                            subPod.version = pod.version;
                        }else {
                            // 继续往下找
                            parentPod = subPod;
                        }
                    }];
                }
                
            }
            if (isSpecRepo && [obj hasPrefix:@"  "]) {
                if (![obj hasPrefix:@"    "]) {
                    // spec
                    NSString *url = [obj stringByReplacingOccurrencesOfString:@" " withString:@""];
                    if (url.length > 1) {
                        url = [url substringToIndex:url.length - 1];
                    }
                    if (url.length) {
                        currentSpecRepo = [DGSpecRepoModel new];
                        currentSpecRepo.url = url;
                        [specRepos addObject:currentSpecRepo];
                    }
                } if ([obj hasPrefix:@"    - "]) {
                    // pod
                    NSString *podName = [obj substringFromIndex:6];
                    if (podName.length) {
                        DGPodModel *currentPod = [totalPod.subPods objectForKey:podName];
                        if (currentPod && currentSpecRepo) {
                            [currentSpecRepo.pods setObject:currentPod forKey:podName];
                        }
                    }
                }
            }
        }];
        
        return specRepos.count ? specRepos : nil;
    } @catch (NSException *exception) {
        return nil;
    }
}

+ (DGPodModel *)parsePodString:(NSString *)podString {
    @try {
        // "  - AFNetworking (3.2.1):"
        // "  - AFNetworking/NSURLSession (3.2.1):"
        DGPodModel *pod = [DGPodModel new];
        
        // version
        __block NSInteger podNameEnd = 0;
        NSRegularExpression *versionRegex = [NSRegularExpression regularExpressionWithPattern:@" \\([0-9a-zA-Z.]+\\)" options:NSRegularExpressionCaseInsensitive error:nil];
        [versionRegex enumerateMatchesInString:podString options:NSMatchingReportCompletion range:NSMakeRange(0, podString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (result) {
                NSString *version = [podString substringWithRange:result.range];
                if (version.length > 3) {
                    version = [version substringWithRange:NSMakeRange(2, version.length - 3)];
                    podNameEnd = result.range.location;
                    pod.version = version;
                }
                *stop = YES;
            }
        }];
        
        /// name
        if (!podNameEnd) {
            return nil;
        }
        NSString *podName = [podString substringToIndex:podNameEnd];
        podName = [podName substringFromIndex:4];
        pod.name = podName;
        return pod;

    } @catch (NSException *exception) {
        return nil;
    }
}

+ (void)queryLatestPodInfoFromCocoaPodsSpecRepoWithPodName:(NSString *)podName completion:(void (^)(NSDictionary * _Nullable, NSError * _Nullable))completion {
    if (!podName) {
        completion(nil, nil);
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"https://trunk.cocoapods.org/api/v1/pods/%@/specs/latest", podName];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *callbackResult = nil;
        NSError *callbackError = nil;
        if (!error) {
            NSError *serialError = nil;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:&serialError];
            if (!serialError && [dictionary isKindOfClass:[NSDictionary class]]) {
                callbackResult = dictionary;
            }else {
                callbackError = serialError;
            }
        }else {
            callbackError = error;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(callbackResult, callbackError);
        });
    }];
    [sessionDataTask resume];
}

+ (void)queryLatestPodInfoFromGitLabSpecRepoWithRequestInfo:(DGGitLabSpecRepoRequestInfo *)requestInfo completion:(void (^)(DGSpecRepoModel * _Nullable specRepo, NSError * _Nullable error))completion {
    if (!requestInfo.website.length ||
        !requestInfo.repoId.length ||
        !requestInfo.privateToken.length) {
        completion(nil, nil);
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/v3/projects/%@/repository/tree?ref=master&recursive=yes", requestInfo.website, requestInfo.repoId];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setValue:requestInfo.privateToken forHTTPHeaderField:@"PRIVATE-TOKEN"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        DGSpecRepoModel *callbackResult = nil;
        NSError *callbackError = nil;
        callbackError = error;
        if (!error) {
            NSError *serialError = nil;
            id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serialError];
            if (serialError) {
                callbackError = serialError;
            }else {
                DGSpecRepoModel *repo = [self parseGitLabPrivateSpecRepoJsonData:obj];
                if (repo) {
                    callbackResult = repo;
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(callbackResult, callbackError);
        });
    }];
    [sessionDataTask resume];
}

+ (DGSpecRepoModel *)parseGitLabPrivateSpecRepoJsonData:(id)responseObject {
    NSArray<NSDictionary *> *array = nil;
    @try {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            array = responseObject;
        }else if ([responseObject isKindOfClass:[NSData class]]) {
            NSError *serialError = nil;
            NSArray *result = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableLeaves) error:&serialError];
            if (!serialError && [result isKindOfClass:NSArray.class]) {
                array = result;
            }
        }
        if (!array.count) {
            return nil;
        }
        
    } @catch (NSException *exception) {
        return nil;
    }
    
    DGSpecRepoModel *repo = [DGSpecRepoModel new];
    [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:NSDictionary.class]) {
            return;
        }
        
        NSString *name = [obj objectForKey:@"name"];
        if (![name isKindOfClass:NSString.class] || ![name hasSuffix:@".podspec"]) {
            return;
        }
        NSString *path = [obj objectForKey:@"path"];
        if (![path isKindOfClass:NSString.class]) {
            return;
        }
        NSArray<NSString *> *components = [path componentsSeparatedByString:@"/"];
        if (components.count != 3) {
            return;
        }
        NSString *podName =components[0];
        if (![podName isKindOfClass:NSString.class] || !podName.length) {
            return;
        }
        NSString *podVersion = components[1];
        if (![podVersion isKindOfClass:NSString.class] || !podVersion.length) {
            return;
        }
        
        DGPodModel *currentPod = [repo.pods objectForKey:podName];
        if (!currentPod) {
            currentPod = [DGPodModel new];
            currentPod.name = podName;
            currentPod.latestVersion = podVersion;
            currentPod.specFilePath = path;
            [repo.pods setObject:currentPod forKey:podName];
        }else {
            // 比较 version，取最大的
            if ([self compareVersionA:podVersion withVersionB:currentPod.latestVersion] == NSOrderedDescending) {
                currentPod.latestVersion = podVersion;
                currentPod.specFilePath = path;
            }
        }
    }];
    return repo.pods.count ? repo : nil;
}

+ (NSComparisonResult)compareVersionA:(NSString *)versionA withVersionB:(NSString *)versionB {
    __block NSComparisonResult result = NSOrderedAscending;
    __block BOOL hasResult = NO;
    NSArray<NSString *> *componentsA = [versionA componentsSeparatedByString:@"."];
    NSArray<NSString *> *componentsB = [versionB componentsSeparatedByString:@"."];
    [componentsA enumerateObjectsUsingBlock:^(NSString * _Nonnull objA, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= componentsB.count) {
            *stop = YES;
            return;
        }
        NSString *objB = [componentsB objectAtIndex:idx];
        if (objA.intValue != objB.intValue) {
            hasResult = YES;
            if (objA.intValue < objB.intValue) {
                result = NSOrderedAscending;
            }else {
                result = NSOrderedDescending;
            }
            *stop = YES;
        }
    }];
    if (hasResult) {
        return result;
    }
    if (componentsA.count < componentsB.count) {
        return NSOrderedAscending;
    }else if (componentsA.count == componentsB.count) {
        return NSOrderedSame;
    }else {
        return NSOrderedDescending;
    }
}

@end


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

+ (Class)pluginViewControllerClass {
    return DGPodPluginViewController.class;
}

#pragma mark -
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
                            [currentSpecRepo.pods addObject:currentPod];
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

+ (void)queryLatestPodInfoFromCocoaPodsSpecRepoWithName:(NSString *)podName completion:(void (^)(NSDictionary * _Nullable, NSError * _Nullable))completion {
    if (!podName) {
        completion(nil, nil);
        return;
    }

    static NSMutableDictionary *_podInfoCachePool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _podInfoCachePool = [NSMutableDictionary dictionary];
    });
    
    if ([_podInfoCachePool objectForKey:podName]) {
        completion([_podInfoCachePool objectForKey:podName], nil);
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
                [_podInfoCachePool setObject:dictionary forKey:podName];
                callbackResult = dictionary;
//                completion(dictionary, nil);
            }else {
                callbackError = serialError;
//                completion(nil, serialError);
            }
        }else {
            callbackError = error;
//            completion(nil, error);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(callbackResult, callbackError);
        });
    }];
    [sessionDataTask resume];

}

@end


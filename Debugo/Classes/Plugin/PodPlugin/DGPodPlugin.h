//
//  DGPodPlugin.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/10/25.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGPlugin.h"
#import "DGSpecRepoModel.h"
#import "DGPodModel.h"
#import "DGPodPluginConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGPodPlugin : DGPlugin

@property (nonatomic, strong) DGPodPluginConfiguration *configuration;

+ (instancetype)shared;

/// 解析 podfile.lock 文件
+ (nullable NSArray<DGSpecRepoModel *> *)parsePodfileLockWithPath:(NSString *)path;

/// 从 CocoaPods 官方库获取某个 pod 最新版本信息
+ (void)queryLatestPodInfoFromCocoaPodsSpecRepoWithPodName:(NSString *)podName completion:(void (^)(NSDictionary * _Nullable podInfo, NSError * _Nullable error))completion;

/// 从某个 GitLab 私有 spec 库获取所有 pod 最新版本信息
+ (void)queryLatestPodInfoFromGitLabSpecRepoWithRequestInfo:(DGGitLabSpecRepoRequestInfo *)requestInfo completion:(void (^)(DGSpecRepoModel * _Nullable specRepo, NSError * _Nullable error))completion;

/// 比较两个版本大小
+ (NSComparisonResult)compareVersionA:(NSString *)versionA withVersionB:(NSString *)versionB;

@end

NS_ASSUME_NONNULL_END

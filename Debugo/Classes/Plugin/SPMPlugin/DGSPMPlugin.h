//
//  DGSPMPlugin.h
//  Debugo
//
//  Created by ripper on 2026/11/9.
//  Copyright © 2026 ripperhe. All rights reserved.
//

#import "DGPlugin.h"
#import "DGSPMModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGSPMPlugin : DGPlugin

/// 解析 Package.resolved（支持 v1 / v2 / v3）
+ (nullable NSArray<DGSPMModel *> *)parsePackageResolvedWithPath:(NSString *)path;

/// 从 GitHub Releases / Tags 查询最新版本（非 GitHub 或失败时 latest 为空）
+ (void)queryLatestVersionForPackage:(DGSPMModel *)package completion:(void (^)(NSString * _Nullable latestVersion, NSError * _Nullable error))completion;

/// 比较两个版本大小（复用 CocoaPods 插件规则）
+ (NSComparisonResult)compareVersionA:(NSString *)versionA withVersionB:(NSString *)versionB;

@end

NS_ASSUME_NONNULL_END

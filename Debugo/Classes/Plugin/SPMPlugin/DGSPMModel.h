//
//  DGSPMModel.h
//  Debugo
//
//  Created by ripper on 2026/11/9.
//  Copyright © 2026 ripperhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGSPMModel : NSObject

/// Package.resolved 中的 identity（或 v1 的 package）
@property (nonatomic, copy) NSString *identity;
/// 展示名（优先取 location 最后一段）
@property (nonatomic, copy) NSString *name;
/// 仓库地址
@property (nonatomic, copy, nullable) NSString *location;
/// 当前版本（有 version 优先；否则 branch@短 hash / 短 hash）
@property (nonatomic, copy, nullable) NSString *version;
/// 原始 version 字段
@property (nonatomic, copy, nullable) NSString *resolvedVersion;
@property (nonatomic, copy, nullable) NSString *revision;
@property (nonatomic, copy, nullable) NSString *branch;
@property (nonatomic, copy, nullable) NSString *kind;

// 网络请求获取
@property (nonatomic, copy, nullable) NSString *latestVersion;

/// 是否为 GitHub 远程仓库（可用于查最新版本）
@property (nonatomic, assign, readonly) BOOL isGitHub;

/// 解析后的 GitHub owner/repo，非 GitHub 时为 nil
@property (nonatomic, copy, nullable, readonly) NSString *gitHubOwner;
@property (nonatomic, copy, nullable, readonly) NSString *gitHubRepo;

@end

NS_ASSUME_NONNULL_END

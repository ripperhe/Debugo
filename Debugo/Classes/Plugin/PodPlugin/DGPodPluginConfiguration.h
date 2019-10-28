//
//  DGPodPluginConfiguration.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/10/25.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGGitLabSpecRepoRequestInfo : NSObject

/// gitlab 私有库网址; e.g. @"https://gitlab.example.com"
@property (nonatomic, copy) NSString *website;
/// spec repo id; e.g. @"182"
@property (nonatomic, copy) NSString *repoId;
/// gitlab token; e.g. @"ozx_6hEs1J7G5E9ZFHhn"
@property (nonatomic, copy) NSString *privateToken;

@end

@interface DGPodPluginConfiguration : NSObject

/// 配置私有的 gitlab spec 库的信息
@property (nonatomic, copy) DGGitLabSpecRepoRequestInfo * _Nullable (^gitLabSpecRepoRequestInfoBlock)(NSString *specRepoUrl);

@end

NS_ASSUME_NONNULL_END

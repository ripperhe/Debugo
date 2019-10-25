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

NS_ASSUME_NONNULL_BEGIN

@interface DGPodPlugin : DGPlugin

/// 解析 podfile.lock 文件
+ (NSArray<DGSpecRepoModel *> *)parsePodfileLockWithPath:(NSString *)path;

/// 从 CocoaPods 官方库请求某个库最新版本信息
+ (void)queryLatestPodInfoFromCocoaPodsSpecRepoWithName:(NSString *)podName completion:(void (^)(NSDictionary * _Nullable podInfo, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END

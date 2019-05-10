//
//  NSFileManager+Debugo.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/10.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (Debugo)

/** 单个文件大小，返回字节 */
- (long long)dg_fileSizeAtPath:(NSString *)path;

/** 递归遍历文件夹来计算文件夹大小，返回字节 */
- (long long)dg_folderSizeAtPath:(NSString *)path;

/** 异步获取文件夹大小，completion 回调字节 */
- (void)dg_asyncCalculateFolderSizeAtPath:(NSString *)path completion:(void (^)(long long size))completion;

@end

NS_ASSUME_NONNULL_END

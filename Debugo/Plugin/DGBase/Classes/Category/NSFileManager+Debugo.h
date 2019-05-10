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

/** 单个文件的大小，返回字节 */
- (long long)dg_fileSizeAtPath:(NSString *)filePath;

/** 遍历文件夹获得文件夹大小，返回字节 */
- (long long)dg_folderSizeAtPath:(NSString *)folderPath;

@end

NS_ASSUME_NONNULL_END

//
//  NSFileManager+Debugo.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/10.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "NSFileManager+Debugo.h"

@implementation NSFileManager (Debugo)

- (long long)dg_fileSizeAtPath:(NSString *)filePath {
    if (![self fileExistsAtPath:filePath]) return 0;
    return [[self attributesOfItemAtPath:filePath error:nil] fileSize];
}

- (long long)dg_folderSizeAtPath:(NSString *)folderPath {
    long long folderSize = 0;
    @try {
        BOOL isDirectory = NO;
        if (![self fileExistsAtPath:folderPath isDirectory:&isDirectory]) return 0;
        if (!isDirectory) return [self dg_fileSizeAtPath:folderPath];
        NSArray *items = [self contentsOfDirectoryAtPath:folderPath error:nil];
        for (int i = 0; i < items.count; i++) {
            BOOL subIsDir;
            NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:items[i]];
            [self fileExistsAtPath:fileAbsolutePath isDirectory:&subIsDir];
            if (subIsDir == YES) {
                // 文件夹就递归计算
                folderSize += [self dg_folderSizeAtPath:fileAbsolutePath];
            } else {
                // 文件直接计算
                folderSize += [self dg_fileSizeAtPath:fileAbsolutePath];
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"NSFileManager dg_folderSizeAtPath 获取文件夹大小异常: %@", exception);
    } @finally {
        return folderSize;
    }
}

@end

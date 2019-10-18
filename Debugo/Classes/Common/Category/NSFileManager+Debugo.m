//
//  NSFileManager+Debugo.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/10.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "NSFileManager+Debugo.h"
#import "DGTool.h"

@implementation NSFileManager (Debugo)

- (long long)dg_fileSizeAtPath:(NSString *)path {
    if (![self fileExistsAtPath:path]) return 0;
    return [[self attributesOfItemAtPath:path error:nil] fileSize];
}

- (long long)dg_folderSizeAtPath:(NSString *)path {
    long long folderSize = 0;
    @try {
        BOOL isDirectory = NO;
        if (![self fileExistsAtPath:path isDirectory:&isDirectory]) return 0;
        if (!isDirectory) return [self dg_fileSizeAtPath:path];
        NSArray *items = [self contentsOfDirectoryAtPath:path error:nil];
        for (int i = 0; i < items.count; i++) {
            BOOL subIsDir;
            NSString *fileAbsolutePath = [path stringByAppendingPathComponent:items[i]];
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

- (void)dg_asyncCalculateFolderSizeAtPath:(NSString *)path completion:(void (^)(long long size))completion {
    dg_weakify(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dg_strongify(self)
        long long size = [self dg_folderSizeAtPath:path];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(size);
        });
    });
}

@end

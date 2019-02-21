//
//  DGFileParser.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGFileParser.h"

@interface DGFileParser()

@end

@implementation DGFileParser

static DGFileParser *_instance;
+ (instancetype)shareInstance
{
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[DGFileParser alloc] init];
        });
    }
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (NSFileManager *)fileManager
{
    return NSFileManager.defaultManager;
}

- (NSURL *)documentsURL
{
    return [[self.fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
}

- (NSArray <DGFBFile *>*)filesForDirectory:(NSURL *)direcotryURL errorHandler:(void (NS_NOESCAPE^)(NSError * error))errorHandler
{
    NSLog(@"%@", direcotryURL.path);

    BOOL isDirectory = NO;
    BOOL isExist = [self.fileManager fileExistsAtPath:direcotryURL.path isDirectory:&isDirectory];
    if (!isExist || !isDirectory) {
        return nil;
    }
    
    NSMutableArray <DGFBFile *>*files = [NSMutableArray array];
    NSArray <NSURL *>*fileURLs = [NSArray array];
    
    // get contents
    NSError *error;
    fileURLs = [self.fileManager contentsOfDirectoryAtURL:direcotryURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
    if (error) {
        NSLog(@"%@ %s error:%@", self, __func__, error);
        errorHandler(error);
        return files;
    }
    
    // parse
    for (NSURL *URL in fileURLs) {
        DGFBFile *file = [[DGFBFile alloc] initWithFileURL:URL];
        if (file.fileExtension.length) {
            if ([self.excludesFileExtensions containsObject:file.fileExtension]) {
                continue;
            }
        }
        if ([self.excludesFileURLs containsObject:file.fileURL]) {
            continue;
        }
        if (file.displayName.length) {
            [files addObject:file];
        }
    }
    
    // sort
    [files sortUsingComparator:^NSComparisonResult(DGFBFile *  _Nonnull obj1, DGFBFile *  _Nonnull obj2) {
        return [obj1.displayName compare:obj2.displayName];
    }];
    return files;
}


@end

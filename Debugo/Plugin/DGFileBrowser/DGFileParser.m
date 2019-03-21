//
//  DGFileParser.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGFileParser.h"

@implementation DGFileParser

+ (NSArray <DGFBFile *>*)filesForDirectory:(NSURL *)direcotryURL configuration:(DGFileConfiguration *)configuration errorHandler:(void (NS_NOESCAPE^)(NSError *))errorHandler
{
    BOOL isDirectory = NO;
    BOOL isExist = [NSFileManager.defaultManager fileExistsAtPath:direcotryURL.path isDirectory:&isDirectory];
    if (!isExist || !isDirectory) {
        return nil;
    }
    
    NSMutableArray <DGFBFile *>*files = [NSMutableArray array];
    NSArray <NSURL *>*fileURLs = [NSArray array];
    
    // get contents
    NSError *error;
    fileURLs = [NSFileManager.defaultManager contentsOfDirectoryAtURL:direcotryURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
    if (error) {
        NSLog(@"%@ %s error:%@", self, __func__, error);
        errorHandler(error);
        return files;
    }
    
    // parse
    for (NSURL *URL in fileURLs) {
        DGFBFile *file = [[DGFBFile alloc] initWithURL:URL];
        
        if (configuration.allowedFileTypes.count) {
            if (![configuration.allowedFileTypes containsObject:@(file.type)]) {
                continue;
            }
        }
        if (file.fileExtension.length) {
            if ([configuration.excludesFileExtensions containsObject:file.fileExtension]) {
                continue;
            }
        }
        if ([configuration.excludesFileURLs containsObject:file.fileURL]) {
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

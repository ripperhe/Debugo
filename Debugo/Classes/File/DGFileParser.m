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

+ (NSArray<DGFile *> *)filesForDirectory:(NSURL *)direcotryURL configuration:(DGFilePreviewConfiguration *)configuration errorHandler:(void (NS_NOESCAPE^)(NSError *))errorHandler {
    BOOL isDirectory = NO;
    BOOL isExist = [NSFileManager.defaultManager fileExistsAtPath:direcotryURL.path isDirectory:&isDirectory];
    if (!isExist || !isDirectory) {
        return nil;
    }
    
    NSMutableArray <DGFile *>*files = [NSMutableArray array];
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
        DGFile *file = [[DGFile alloc] initWithURL:URL];
        
        if (configuration.allowedFileTypes.count) {
            if (![configuration.allowedFileTypes containsObject:@(file.type)]) {
                continue;
            }
        }
        if (configuration.ignoredFileTypes.count) {
            if ([configuration.ignoredFileTypes containsObject:@(file.type)]) {
                continue;
            }
        }
        if (file.displayName.length) {
            [files addObject:file];
        }
    }
    
    // sort
    [files sortUsingComparator:^NSComparisonResult(DGFile *  _Nonnull obj1, DGFile *  _Nonnull obj2) {
        return [obj1.displayName compare:obj2.displayName];
    }];
    return files;
}

+ (NSArray<DGFile *> *)filesForPath:(NSString *)path forType:(DGFileType)type errorHandler:(void (NS_NOESCAPE^)(NSError * error))errorHandler {
    DGFile *parseFile = [[DGFile alloc] initWithPath:path];
    if (!parseFile) return nil;
    if (parseFile.isDirectory) {
        if (type == DGFileTypeDirectory) return @[parseFile];
        DGFilePreviewConfiguration *configuration = [DGFilePreviewConfiguration new];
        configuration.allowedFileTypes = @[@(type)];
        NSArray<DGFile *> *files = [self filesForDirectory:parseFile.fileURL configuration:configuration errorHandler:errorHandler];
        return files.count ? files : nil;
    }else if (parseFile.type == type) {
        return @[parseFile];
    }
    return nil;
}

@end

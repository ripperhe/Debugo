//
//  DGPathFetcher.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/2/22.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGPathFetcher : NSObject

+ (NSString *)bundleDirectory;
+ (NSURL *)bundleDirectoryURL;

+ (NSString *)sandboxDirectory;
+ (NSURL *)sandboxDirectoryURL;

+ (NSString *)documentsDirectory;
+ (NSURL *)documentsDirectoryURL;

+ (NSString *)libraryDirectory;
+ (NSURL *)libraryDirectoryURL;

+ (NSString *)cachesDirectory;
+ (NSURL *)cachesDirectoryURL;

+ (NSString *)temporaryDirectory;
+ (NSURL *)temporaryDirectoryURL;

+ (NSString *)userDefaultsPlistFilePath;
+ (NSURL *)userDefaultsPlistFileURL;

@end

NS_ASSUME_NONNULL_END

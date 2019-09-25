//
//  DGPathFetcher.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/2/22.
//  Copyright © 2019 ripperhe. All rights reserved.
//

/**
 ➜  App Sandbox tree .
 .
 ├── Documents
 ├── Library
 │   ├── Caches
 │   └── Preferences
 │       └── com.ripperhe.debugo.plist
 ├── SystemData
 └── tmp
 */

#import "DGPathFetcher.h"

@implementation DGPathFetcher

+ (NSString *)bundleDirectory {
    return [[NSBundle mainBundle] bundlePath];
}

+ (NSURL *)bundleDirectoryURL {
    return [[NSBundle mainBundle] bundleURL];
}

+ (NSString *)sandboxDirectory {
    return NSHomeDirectory();
}

+ (NSURL *)sandboxDirectoryURL {
    return [NSURL fileURLWithPath:NSHomeDirectory() isDirectory:YES];
}

+ (NSString *)documentsDirectory {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSURL *)documentsDirectoryURL {
    return [NSURL fileURLWithPath:[self documentsDirectory] isDirectory:YES];
}

+ (NSString *)libraryDirectory {
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSURL *)libraryDirectoryURL {
    return [NSURL fileURLWithPath:[self libraryDirectory] isDirectory:YES];
}

+ (NSString *)cachesDirectory {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSURL *)cachesDirectoryURL {
    return [NSURL fileURLWithPath:[self cachesDirectory] isDirectory:YES];
}

+ (NSString *)temporaryDirectory {
    return NSTemporaryDirectory();
}

+ (NSURL *)temporaryDirectoryURL {
    return [NSURL fileURLWithPath:[self temporaryDirectory] isDirectory:YES];
}

+ (NSString *)userDefaultsPlistFilePath {
    NSString *bundleIdentifier = [NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleIdentifier"];
    return [NSString stringWithFormat:@"%@/Preferences/%@.plist", [self libraryDirectory], bundleIdentifier];
}

+ (NSURL *)userDefaultsPlistFileURL {
    return [NSURL fileURLWithPath:[self userDefaultsPlistFilePath] isDirectory:NO];
}

@end

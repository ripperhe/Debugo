//
//  DGFilePath.m
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
 │       └── com.picooc.picooc.plist
 ├── SystemData
 └── tmp
 */

#import "DGFilePath.h"

@implementation DGFilePath

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
    return [NSURL URLWithString:NSHomeDirectory()];
}

+ (NSString *)documentsDirectory {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSURL *)documentsDirectoryURL {
    return [NSURL URLWithString:[self documentsDirectory]];
}

+ (NSString *)libraryDirectory {
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSURL *)libraryDirectoryURL {
    return [NSURL URLWithString:[self libraryDirectory]];
}

+ (NSString *)cachesDirectory {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSURL *)cachesDirectoryURL {
    return [NSURL URLWithString:[self cachesDirectory]];
}

+ (NSString *)userDefaultsPlistFilePath {
    NSString *bundleIdentifier = [NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleIdentifier"];
    return [NSString stringWithFormat:@"%@/Preferences/%@.plist", [self libraryDirectory], bundleIdentifier];
}

+ (NSURL *)userDefaultsPlistFileURL {
    return [NSURL fileURLWithPath:[self userDefaultsPlistFilePath]];
}

@end

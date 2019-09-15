//
//  DGFileParser.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGFilePreviewConfiguration.h"

@interface DGFileParser : NSObject

+ (NSArray<DGFile *> *)filesForDirectory:(NSURL *)direcotryURL configuration:(DGFilePreviewConfiguration *)configuration errorHandler:(void (NS_NOESCAPE^)(NSError * error))errorHandler;

+ (NSArray<DGFile *> *)filesForPath:(NSString *)path forType:(DGFileType)type errorHandler:(void (NS_NOESCAPE^)(NSError * error))errorHandler;

@end

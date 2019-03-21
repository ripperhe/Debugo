//
//  DGFileParser.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGFileConfiguration.h"

@interface DGFileParser : NSObject

+ (NSArray <DGFBFile *>*)filesForDirectory:(NSURL *)direcotryURL configuration:(DGFileConfiguration *)configuration errorHandler:(void (NS_NOESCAPE^)(NSError * error))errorHandler;

@end

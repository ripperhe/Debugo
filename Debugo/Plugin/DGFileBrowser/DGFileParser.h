//
//  DGFileParser.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGFBFile.h"

@interface DGFileParser : NSObject

@property (nonatomic, strong) NSArray <NSString *>*excludesFileExtensions;
@property (nonatomic, strong) NSArray <NSURL *>*excludesFileURLs;

+ (instancetype)shareInstance;
- (NSFileManager *)fileManager;
- (NSURL *)documentsURL;
- (NSArray <DGFBFile *>*)filesForDirectory:(NSURL *)direcotryURL errorHandler:(void (NS_NOESCAPE^)(NSError * error))errorHandler;

@end

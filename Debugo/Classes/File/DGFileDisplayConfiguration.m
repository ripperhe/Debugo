//
//  DGFileConfiguration.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/31.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGFileDisplayConfiguration.h"
#import "DGBase.h"

@implementation DGFileDisplayConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        _shortcutForDatabaseURLs = @[DGFilePath.documentsDirectoryURL];
        _shortcutForAnyURLs = @[DGFilePath.userDefaultsPlistFileURL];
    }
    return self;
}

@end

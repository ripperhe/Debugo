//
//  DGFilePreviewConfiguration.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/31.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGFilePluginConfiguration.h"
#import "DGCommon.h"

@implementation DGFilePluginConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        _shortcutForDatabasePaths = @[DGPathFetcher.documentsDirectory];
        _shortcutForAnyPaths = @[DGPathFetcher.userDefaultsPlistFilePath];
    }
    return self;
}

@end

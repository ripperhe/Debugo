//
//  DGFileConfiguration.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/3/21.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGFBFile.h"
#import "DGDatabasePreviewConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGFileConfiguration : NSObject

@property (nonatomic, strong) NSArray <NSNumber *>*allowedFileTypes;

@property (nonatomic, strong) NSArray <NSNumber *>*ignoredFileTypes;

@property (nonatomic, assign) BOOL allowEditing;

@property (nonatomic, copy) void(^didSelectFileBlock)(DGFBFile *file);

@property (nonatomic, copy) DGDatabasePreviewConfiguration * _Nullable(^databaseFilePreviewConfigurationBlock)(DGFBFile *file);

@end

NS_ASSUME_NONNULL_END

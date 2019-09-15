//
//  DGFilePreviewConfiguration.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/3/21.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGFile.h"
#import "DGDatabasePreviewConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGFilePreviewConfiguration : NSObject

@property (nonatomic, strong) NSArray <NSNumber *>*allowedFileTypes;

@property (nonatomic, strong) NSArray <NSNumber *>*ignoredFileTypes;

@property (nonatomic, assign) BOOL forbidEditing;

@property (nonatomic, copy) void(^didSelectFileBlock)(DGFile *file);

@property (nonatomic, copy) DGDatabasePreviewConfiguration * _Nullable(^databaseFilePreviewConfigurationBlock)(DGFile *file);

@end

NS_ASSUME_NONNULL_END

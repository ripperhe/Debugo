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

typedef void (^DGFBFileDidSelectFileBlock)(DGFBFile *file);
typedef DGDatabasePreviewConfiguration * (^DGDatabaseFilePreviewConfigurationBlock)(DGFBFile *file);

NS_ASSUME_NONNULL_BEGIN

@interface DGFileConfiguration : NSObject

@property (nonatomic, strong) NSArray <NSNumber *>*allowedFileTypes;

/// File types to exclude from the file browser.
@property (nonatomic, strong) NSArray <NSString *>*excludesFileExtensions;

/// File paths to exclude from the file browser.
@property (nonatomic, strong) NSArray <NSURL *>*excludesFileURLs;

@property (nonatomic, assign) BOOL allowEditing;

@property (nonatomic, copy) DGFBFileDidSelectFileBlock didSelectFileBlock;

@property (nonatomic, copy) DGDatabaseFilePreviewConfigurationBlock databaseFilePreviewConfigurationBlock;

@end

NS_ASSUME_NONNULL_END

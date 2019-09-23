//
//  DGFile.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

typedef NS_ENUM(NSUInteger, DGFileType) {
    DGFileTypeDefault,
    DGFileTypeDirectory,
    DGFileTypeImage,
    DGFileTypeAudio,
    DGFileTypeVideo,
    DGFileTypePDF,
    DGFileTypeJSON,
    DGFileTypePLIST,
    DGFileTypeZIP,
    DGFileTypeDB
};

NS_ASSUME_NONNULL_BEGIN

@interface DGFile : NSObject<QLPreviewItem>

@property (nonatomic, strong, readonly) NSURL *fileURL;
@property (nonatomic, strong, readonly) NSString *filePath;
@property (nonatomic, copy, readonly) NSString *fileName;
@property (nonatomic, copy, nullable, readonly) NSString *fileExtension;
@property (nonatomic, assign, readonly) DGFileType type;
@property (nonatomic, assign, readonly) BOOL isDirectory;
@property (nonatomic, copy) NSString *displayName;

- (instancetype)initWithPath:(NSString *)path;
- (instancetype)initWithURL:(NSURL *)URL;
- (void)deleteWithErrorHandler:(void (NS_NOESCAPE^)(NSError * error))errorHandler;
- (BOOL)isExist;
- (NSDictionary *)fileAttributes;
- (void)calculateSize:(void (^)(long long size))completion;
- (nullable NSString *)simpleInfo;
- (UIImage *)image;

@end

NS_ASSUME_NONNULL_END

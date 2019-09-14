//
//  DGFBFile.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

typedef NS_ENUM(NSUInteger, DGFBFileType) {
    DGFBFileTypeDefault,
    DGFBFileTypeDirectory,
    DGFBFileTypeImage,
    DGFBFileTypeAudio,
    DGFBFileTypeVideo,
    DGFBFileTypePDF,
    DGFBFileTypeJSON,
    DGFBFileTypePLIST,
    DGFBFileTypeZIP,
    DGFBFileTypeDB
};

NS_ASSUME_NONNULL_BEGIN

@interface DGFBFile : NSObject<QLPreviewItem>

@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, copy, nullable) NSString *fileExtension;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, assign) BOOL isDirectory;
@property (nonatomic, assign) DGFBFileType type;

- (instancetype)initWithURL:(NSURL *)URL;
- (void)deleteWithErrorHandler:(void (NS_NOESCAPE^)(NSError * error))errorHandler;
- (BOOL)isExist;
- (NSDictionary *)fileAttributes;
- (void)calculateSize:(void (^)(long long size))completion;
- (nullable NSString *)simpleInfo;
- (UIImage *)image;

@end

NS_ASSUME_NONNULL_END

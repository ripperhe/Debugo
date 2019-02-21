//
//  DGFBFile.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DGFBFileType) {
    DGFBFileTypeDirectory, // directory
    DGFBFileTypeGIF,
    DGFBFileTypeJPG,
    DGFBFileTypeJSON,
    DGFBFileTypePDF,
    DGFBFileTypePLIST,
    DGFBFileTypePNG,
    DGFBFileTypeZIP,
    DGFBFileTypeDB,
    DGFBFileTypeDefault, // file
};


@interface DGFBFile : NSObject

@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, assign) BOOL isDirectory;
@property (nonatomic, copy) NSString *fileExtension;
@property (nonatomic, strong) NSDictionary *fileAttributes;
@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, assign) DGFBFileType type;

- (instancetype)initWithFileURL:(NSURL *)fileURL;
- (UIImage *)image;
- (void)deleteWithErrorHandler:(void (NS_NOESCAPE^)(NSError * error))errorHandler;

@end

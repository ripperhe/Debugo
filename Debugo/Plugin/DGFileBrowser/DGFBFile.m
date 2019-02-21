//
//  DGFBFile.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGFBFile.h"
#import "DGBase.h"

@implementation DGFBFile

- (instancetype)initWithFileURL:(NSURL *)fileURL
{
    if (self = [super init]) {
        self.fileURL = fileURL;
        BOOL isDirectory = [self checkDirectoryWithURL:fileURL];
        self.isDirectory = isDirectory;
        if (self.isDirectory) {
            self.fileAttributes = nil;
            self.fileExtension = nil;
            self.type = DGFBFileTypeDirectory;
        }else{
            self.fileAttributes = [self getFileAttributesWithURL:self.fileURL];
            self.fileExtension = self.fileURL.pathExtension;
            if (self.fileExtension.length) {
                self.type = [self typeForPathExtension:self.fileExtension];
            }else{
                self.type = DGFBFileTypeDefault;
            }
        }
        self.displayName = fileURL.lastPathComponent;
    }
    return self;
}

- (void)deleteWithErrorHandler:(void (NS_NOESCAPE^)(NSError * error))errorHandler
{
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtURL:self.fileURL error:&error];
    if (error) {
        NSLog(@"An error occured when trying to delete file:%@ error:%@", self.fileURL.path, error);
        errorHandler(error);
    }
}

- (BOOL)checkDirectoryWithURL:(NSURL *)fileURL
{
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:fileURL.path isDirectory:&isDirectory];
//    NSString *resourceValue;
//    NSError *error;
//    if ([fileURL getResourceValue:&resourceValue forKey:NSURLFileResourceTypeKey error:&error]) {
//        if (!error && resourceValue == NSURLFileResourceTypeDirectory) {
//            isDirectory = YES;
//        }
//    }
//    if (error) {
//        NSLog(@"%@ %s error:%@", self, __func__, error);
//    }
    return isDirectory;
}

- (NSDictionary *)getFileAttributesWithURL:(NSURL *)fileURL
{
    NSString *path = fileURL.path;
    NSError *error;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    if (error) {
        NSLog(@"%@ %s error:%@", self, __func__, error);
    }
    return attributes;
}

- (DGFBFileType)typeForPathExtension:(NSString *)pathExtension
{
    if ([pathExtension isEqualToString:@"gif"]) {
        return DGFBFileTypeGIF;
    }else if ([pathExtension isEqualToString:@"jpg"]) {
        return DGFBFileTypeJPG;
    }else if ([pathExtension isEqualToString:@"json"]) {
        return DGFBFileTypeJSON;
    }else if ([pathExtension isEqualToString:@"pdf"]) {
        return DGFBFileTypePDF;
    }else if ([pathExtension isEqualToString:@"plist"]) {
        return DGFBFileTypePLIST;
    }else if ([pathExtension isEqualToString:@"png"]) {
        return DGFBFileTypePNG;
    }else if ([pathExtension isEqualToString:@"zip"]) {
        return DGFBFileTypeZIP;
    }else if ([pathExtension isEqualToString:@"db"]
              || [pathExtension isEqualToString:@"sqlite"]
              || [pathExtension isEqualToString:@"sqlite3"]) {
        return DGFBFileTypeDB;
    }
    return DGFBFileTypeDefault;
}

- (UIImage *)image
{
    DGFBFileType type = self.type;
    NSString *fileName = nil;
    switch (type) {
        case DGFBFileTypeDirectory:
            fileName = @"file_folder";
            break;
        case DGFBFileTypeGIF:
        case DGFBFileTypeJPG:
        case DGFBFileTypePNG:
            fileName = @"file_image";
            break;
        case DGFBFileTypePDF:
            fileName = @"file_pdf";
            break;
        case DGFBFileTypeZIP:
            fileName = @"file_zip";
            break;
        case DGFBFileTypeDB:
            fileName = @"file_database";
            break;
        default:
            fileName = @"file_file";
            break;
    }
    UIImage *image = [DGBundle imageNamed:fileName];
    return image;
}


@end

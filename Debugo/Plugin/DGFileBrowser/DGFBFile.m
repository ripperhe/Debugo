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

- (instancetype)initWithURL:(NSURL *)URL
{
    if (self = [super init]) {
        self.fileURL = URL;
        BOOL isDirectory = [self checkDirectoryWithURL:URL];
        self.isDirectory = isDirectory;
        self.fileAttributes = [self getFileAttributesWithURL:URL];
        if (self.isDirectory) {
            self.fileExtension = nil;
            self.type = DGFBFileTypeDirectory;
        }else{
            self.fileExtension = self.fileURL.pathExtension;
            self.type = [self typeForPathExtension:self.fileExtension];
        }
        self.displayName = URL.lastPathComponent;
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
    if (!pathExtension.length) return DGFBFileTypeDefault;
    
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
    static NSMutableDictionary *_cachedImageDic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cachedImageDic = [NSMutableDictionary dictionary];
    });
    
    DGFBFileType type = self.type;
    NSString *imageName = nil;
    switch (type) {
        case DGFBFileTypeDirectory:
            imageName = @"file_folder";
            break;
        case DGFBFileTypeGIF:
        case DGFBFileTypeJPG:
        case DGFBFileTypePNG:
            imageName = @"file_image";
            break;
        case DGFBFileTypePDF:
            imageName = @"file_pdf";
            break;
        case DGFBFileTypeZIP:
            imageName = @"file_zip";
            break;
        case DGFBFileTypeDB:
            imageName = @"file_database";
            break;
        default:
            imageName = @"file_file";
            break;
    }
    UIImage *image = [_cachedImageDic objectForKey:imageName];
    if (!image) {
        image = [DGBundle imageNamed:imageName];
        [_cachedImageDic setObject:image forKey:imageName];
    }
    return image;
}

- (NSString *)simpleInfo {
    if (!self.fileAttributes.fileModificationDate) return nil;
    
    NSString *dateInfo = [self.fileAttributes.fileModificationDate dg_dateStringWithFormat:@"yyyy/MM/dd"];
    if ([dateInfo isEqualToString:@"1970/01/01"]) return @"Unknown";
    
    if (self.isDirectory) return dateInfo;
    
    NSString *sizeInfo = [@(self.fileAttributes.fileSize) dg_sizeString];
    return [dateInfo stringByAppendingFormat:@" - %@", sizeInfo];
}

- (BOOL)isExist {
    return [[NSFileManager defaultManager] fileExistsAtPath:self.fileURL.path];
}

#pragma mark - QLPreviewItem

- (NSURL *)previewItemURL {
    return self.fileURL;
}

- (NSString *)previewItemTitle {
    return self.displayName;
}

@end

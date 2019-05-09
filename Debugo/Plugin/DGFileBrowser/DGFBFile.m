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

- (instancetype)initWithURL:(NSURL *)URL {
    if (self = [super init]) {
        self.fileURL = URL;
        self.isDirectory = [self checkDirectoryWithURL:URL];
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

- (void)deleteWithErrorHandler:(void (NS_NOESCAPE^)(NSError * error))errorHandler {
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtURL:self.fileURL error:&error];
    if (error) {
        NSLog(@"An error occured when trying to delete file:%@ error:%@", self.fileURL.path, error);
        errorHandler(error);
    }
}

- (BOOL)checkDirectoryWithURL:(NSURL *)fileURL {
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

// 单个文件的大小
- (long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:filePath]) return 0;
    return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
}

// 遍历文件夹获得文件夹大小，返回字节
- (long long)folderSizeAtPath:(NSString *)folderPath {
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if (![manager fileExistsAtPath:folderPath isDirectory:&isDirectory]) return 0;
    if (!isDirectory) return [self fileSizeAtPath:folderPath];
    long long folderSize = 0;
    NSArray *items = [manager contentsOfDirectoryAtPath:folderPath error:nil];
    for (int i = 0; i < items.count; i++) {
        BOOL subIsDir;
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:items[i]];
        [manager fileExistsAtPath:fileAbsolutePath isDirectory:&subIsDir];
        if (subIsDir == YES) {
            // 文件夹就递归计算
            folderSize += [self folderSizeAtPath:fileAbsolutePath];
        } else {
            // 文件直接计算
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
    }
    return folderSize;
}

- (NSDictionary *)fileAttributes {
    if (!self.isExist) {
        return nil;
    }
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = self.fileURL.path;
    NSError *error;
    NSDictionary *attributes = [manager attributesOfItemAtPath:path error:&error];
    if (error) {
        NSLog(@"%@<%p> %@ error:%@", [self class], self, NSStringFromSelector(_cmd), error);
    }else {
        if (self.isDirectory) {
            long long folderSize = [self folderSizeAtPath:path];
            NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:attributes];
            [newDic setObject:@(folderSize) forKey:NSFileSize];
            attributes = newDic.copy;
        }
    }
    return attributes;
}

- (DGFBFileType)typeForPathExtension:(NSString *)pathExtension {
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

- (UIImage *)image {
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

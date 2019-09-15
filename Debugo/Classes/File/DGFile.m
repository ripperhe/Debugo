//
//  DGFile.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGFile.h"
#import "DGCommon.h"

@implementation DGFile

- (instancetype)initWithPath:(NSString *)path {
    return [self initWithURL:[NSURL fileURLWithPath:path]];
}

- (instancetype)initWithURL:(NSURL *)URL {
    if (!URL.path.length) return nil;
    if (self = [super init]) {
        _fileURL = URL;
        _filePath = URL.path;
        if (![self isExist]) return nil;
        _fileName = URL.lastPathComponent;
        _isDirectory = [self checkDirectoryWithPath:URL.path];
        if (_isDirectory) {
            _fileExtension = nil;
            _type = DGFileTypeDirectory;
        }else{
            _fileExtension = _filePath.pathExtension;
            _type = [self typeForPathExtension:_fileExtension];
        }
        _displayName = _fileName;
    }
    return self;
}

- (void)deleteWithErrorHandler:(void (NS_NOESCAPE^)(NSError * error))errorHandler {
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtURL:self.fileURL error:&error];
    if (error) {
        DGLog(@"删除文件失败:%@ error:%@", self.filePath, error);
        errorHandler(error);
    }
}

- (BOOL)checkDirectoryWithPath:(NSString *)filePath {
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    return isDirectory;
}

- (NSDictionary *)fileAttributes {
    if (!self.isExist) return nil;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = self.filePath;
    NSError *error;
    NSDictionary *attributes = [manager attributesOfItemAtPath:path error:&error];
    if (error) {
        DGLog(@"获取文件属性失败:%@ error:%@", self.filePath, error);
    }
    return attributes;
}

- (void)calculateSize:(void (^)(long long size))completion {
    if (self.isDirectory) {
        [[NSFileManager defaultManager] dg_asyncCalculateFolderSizeAtPath:self.filePath completion:completion];
    }else {
        long long size = [[NSFileManager defaultManager] dg_fileSizeAtPath:self.filePath];
        completion(size);
    }
}

- (DGFileType)typeForPathExtension:(NSString *)pathExtension {
    if (!pathExtension.length) return DGFileTypeDefault;
    
    static NSSet *_imageSet = nil;
    static NSSet *_audioSet = nil;
    static NSSet *_dbSet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _imageSet = [NSSet setWithObjects:@"png", @"jpg", @"jpeg", @"gif", nil];
        _audioSet = [NSSet setWithObjects:@"mp3", @"m4a", nil];
        _dbSet = [NSSet setWithObjects:@"db", @"database", @"sqlite", @"sqlite3", nil];
    });
    
    if ([_imageSet containsObject:pathExtension]) {
        return DGFileTypeImage;
    }else if ([_audioSet containsObject:pathExtension]) {
        return DGFileTypeAudio;
    }else if ([pathExtension isEqualToString:@"mp4"]) {
        return DGFileTypeVideo;
    }else if ([pathExtension isEqualToString:@"pdf"]) {
        return DGFileTypePDF;
    }else if ([pathExtension isEqualToString:@"plist"]) {
        return DGFileTypePLIST;
    }else if ([pathExtension isEqualToString:@"json"]) {
        return DGFileTypeJSON;
    }else if ([pathExtension isEqualToString:@"zip"]) {
        return DGFileTypeZIP;
    }else if ([_dbSet containsObject:pathExtension]) {
        return DGFileTypeDB;
    }
    return DGFileTypeDefault;
}

- (UIImage *)image {
    static NSMutableDictionary *_cachedImageDic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cachedImageDic = [NSMutableDictionary dictionary];
    });
    
    DGFileType type = self.type;
    NSString *imageName = nil;
    switch (type) {
        case DGFileTypeDefault:
            imageName = @"file_default";
            break;
        case DGFileTypeDirectory:
            imageName = @"file_folder";
            break;
        case DGFileTypeImage:
            imageName = @"file_image";
            break;
        case DGFileTypeAudio:
            imageName = @"file_audio";
            break;
        case DGFileTypeVideo:
            imageName = @"file_video";
            break;
        case DGFileTypePDF:
            imageName = @"file_pdf";
            break;
        case DGFileTypeJSON:
            imageName = @"file_json";
            break;
        case DGFileTypePLIST:
            imageName = @"file_plist";
            break;
        case DGFileTypeZIP:
            imageName = @"file_zip";
            break;
        case DGFileTypeDB:
            imageName = @"file_database";
            break;
        default:
            imageName = @"file_default";
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
    NSDictionary *fileAttributes = [self fileAttributes];
    if (!fileAttributes.fileModificationDate) return nil;
    
    NSString *dateInfo = [fileAttributes.fileModificationDate dg_dateStringWithFormat:@"yyyy/MM/dd"];
    if ([dateInfo isEqualToString:@"1970/01/01"]) return @"未知";
    
    if (self.isDirectory) return dateInfo;
    
    NSString *sizeInfo = [@(fileAttributes.fileSize) dg_sizeString];
    return [dateInfo stringByAppendingFormat:@" - %@", sizeInfo];
}

- (BOOL)isExist {
    return [[NSFileManager defaultManager] fileExistsAtPath:self.filePath];
}

#pragma mark - QLPreviewItem

- (NSURL *)previewItemURL {
    return self.fileURL;
}

- (NSString *)previewItemTitle {
    return self.displayName;
}

@end

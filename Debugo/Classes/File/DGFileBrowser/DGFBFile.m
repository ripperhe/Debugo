//
//  DGFBFile.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGFBFile.h"
#import "DGCommon.h"

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
    return isDirectory;
}

- (NSDictionary *)fileAttributes {
    if (!self.isExist) return nil;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = self.fileURL.path;
    NSError *error;
    NSDictionary *attributes = [manager attributesOfItemAtPath:path error:&error];
    if (error) {
        NSLog(@"%@<%p> %@ error:%@", [self class], self, NSStringFromSelector(_cmd), error);
    }
    return attributes;
}

- (void)calculateSize:(void (^)(long long size))completion {
    if (self.isDirectory) {
        [[NSFileManager defaultManager] dg_asyncCalculateFolderSizeAtPath:self.fileURL.path completion:completion];
    }else {
        long long size = [[NSFileManager defaultManager] dg_fileSizeAtPath:self.fileURL.path];
        completion(size);
    }
}

- (DGFBFileType)typeForPathExtension:(NSString *)pathExtension {
    if (!pathExtension.length) return DGFBFileTypeDefault;
    
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
        return DGFBFileTypeImage;
    }else if ([_audioSet containsObject:pathExtension]) {
        return DGFBFileTypeAudio;
    }else if ([pathExtension isEqualToString:@"mp4"]) {
        return DGFBFileTypeVideo;
    }else if ([pathExtension isEqualToString:@"pdf"]) {
        return DGFBFileTypePDF;
    }else if ([pathExtension isEqualToString:@"plist"]) {
        return DGFBFileTypePLIST;
    }else if ([pathExtension isEqualToString:@"json"]) {
        return DGFBFileTypeJSON;
    }else if ([pathExtension isEqualToString:@"zip"]) {
        return DGFBFileTypeZIP;
    }else if ([_dbSet containsObject:pathExtension]) {
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
        case DGFBFileTypeDefault:
            imageName = @"file_default";
        case DGFBFileTypeDirectory:
            imageName = @"file_folder";
            break;
        case DGFBFileTypeImage:
            imageName = @"file_image";
            break;
        case DGFBFileTypeAudio:
            imageName = @"file_audio";
            break;
        case DGFBFileTypeVideo:
            imageName = @"file_video";
            break;
        case DGFBFileTypePDF:
            imageName = @"file_pdf";
            break;
        case DGFBFileTypeJSON:
            imageName = @"file_json";
            break;
        case DGFBFileTypePLIST:
            imageName = @"file_plist";
            break;
        case DGFBFileTypeZIP:
            imageName = @"file_zip";
            break;
        case DGFBFileTypeDB:
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

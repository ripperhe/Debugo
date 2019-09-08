//
//  DGPlister.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGPlister.h"

@interface DGPlister()

@property (nonatomic, assign) BOOL isReadonly;

@end

@implementation DGPlister

- (instancetype)initWithFilePath:(NSString *)filePath readonly:(BOOL)readonly {
    if (![filePath hasSuffix:@".plist"]) {
        NSAssert(0, @"DGPlister: filePath error");
        return nil;
    }
    
    self = [super init];
    if (self) {
        self->_filePath = filePath;
        self.isReadonly = readonly;

        BOOL isDirectory = NO;
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];

        if (isExist) {
            if (isDirectory) {
                return nil;
            }
            
            // read
            if (![self read]) {
                return nil;
            }
        }else{
            // create
            if (self.isReadonly) {
                return nil;
            }

            if (![self writeDictionary:[NSDictionary dictionary]]) {
                return nil;
            }
        }
    }
    return self;
}

- (NSMutableDictionary *)read {
    NSData *data = [NSData dataWithContentsOfFile:self.filePath];
    if (!data) {
        // 读取数据错误
        NSAssert(0, @"DGPlister: 读取数据失败");
        return nil;
    }
    
    NSError *error = nil;
    NSObject *obj = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:nil error:&error];
    
    if (!error) {
        // 解析数据成功
        if ([obj isKindOfClass:[NSMutableDictionary class]]) {
            // NSMutableDictionary 类型
            return (NSMutableDictionary *)obj;
        }else if ([obj isKindOfClass:[NSMutableArray class]]) {
            // NSMutableArray 类型
            NSAssert(0, @"DGPlister: 不支持 Root Type 为 NSArray 类型的 plist 文件");
            return nil;
        }else{
            // 其他类型 未知数据
            NSAssert(0, @"DGPlister: 读取到未知数据");
            return nil;
        }
    }else {
        // 解析数据错误
        NSAssert(0, @"DGPlister: 解析数据错误\n%@", error);
        return nil;
    }
}

- (BOOL)writeDictionary:(NSDictionary *)dictionary {
    if (!dictionary) return NO;
    if (self.isReadonly) return NO;
    
    BOOL isSuccess = [dictionary writeToFile:self.filePath atomically:YES];
    
    if (isSuccess) {
        return YES;
    }else{
        // 写入失败，判断是否为没有文件夹造成的
        NSString *dirPath = [self.filePath stringByDeletingLastPathComponent];
        if (!dirPath.length) {
            NSAssert(0, @"DGPlister: filePath error");
            return NO;
        }
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:dirPath];
        if (!isExist) {
            // 先创建文件夹
            NSError *error = nil;
            BOOL isSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
            if (isSuccess) {
                // 创建文件夹成功
                BOOL isSuccess = [dictionary writeToFile:self.filePath atomically:YES];
                if (isSuccess) {
                    // 写入成功
                    return YES;
                }else{
                    NSAssert(0, @"DGPlister: 写入文件失败 %@", self.filePath);
                    return NO;
                }
            }else{
                // 创建文件夹失败
                if (error) {
                    NSAssert(0, @"DGPlister: 创建文件夹失败 %@", error);
                }
                return NO;
            }
        }else {
            NSAssert(0, @"DGPlister: 写入文件失败 %@", self.filePath);
            return NO;
        }
    }
}

- (BOOL)containsKey:(NSString *)key {
    return [self.read objectForKey:key] ? YES : NO;
}

- (BOOL)removeAllObjects {
    return [self writeDictionary:[NSDictionary dictionary]];
}

- (BOOL)removeObjectForKey:(NSString *)key {
    NSMutableDictionary *dic = [self read];
    if (!dic) return NO;
    
    [dic removeObjectForKey:key];
    return [self writeDictionary:dic];
}

#pragma mark - setter
- (BOOL)setObject:(id)obj forKey:(NSString *)key {
    NSMutableDictionary *dic = [self read];
    if (!dic) return NO;

    [dic setObject:[obj copy] forKey:key];
    return [self writeDictionary:dic];
}

- (BOOL)setDictionary:(NSDictionary *)dictionary forKey:(NSString *)key {
    return [self setObject:dictionary forKey:key];
}

- (BOOL)setArray:(NSArray *)value forKey:(NSString *)key {
    return [self setObject:value forKey:key];
}

- (BOOL)setString:(NSString *)value forKey:(NSString *)key {
    return [self setObject:value forKey:key];
}

- (BOOL)setBool:(BOOL)value forKey:(NSString *)key {
    return [self setObject:@(value) forKey:key];
}

- (BOOL)setInteger:(NSInteger)value forKey:(NSString *)key {
    return [self setObject:@(value) forKey:key];
}

- (BOOL)setFloat:(float)value forKey:(NSString *)key {
    return [self setObject:@(value) forKey:key];
}

- (BOOL)setDouble:(double)value forKey:(NSString *)key {
    return [self setObject:@(value) forKey:key];
}

#pragma mark - getter

- (nullable id)objectForKey:(NSString *)key {
    NSMutableDictionary *dic = [self read];
    if (!dic) return nil;
    return [dic objectForKey:key];
}

- (nullable id)objectForKey:(NSString *)key nilHandler:(nullable id (NS_NOESCAPE^)(void))nilHandler {
    id obj = [self objectForKey:key];
    if (!obj) {
        // nil
        if (nilHandler) {
            return nilHandler();
        }
    }
    return obj;
}

- (nullable NSDictionary<NSString *, id> *)dictionaryForKey:(NSString *)key {
    NSDictionary *dic = [self objectForKey:key];
    if (dic != nil && ![dic isKindOfClass:[NSDictionary class]]) {
        NSLog(@"DGPlister: %@ %@ value type error", NSStringFromSelector(_cmd), key);
        return nil;
    }
    return dic;
}

- (nullable NSMutableDictionary<NSString *, id> *)mutableDictionaryForKey:(NSString *)key {
    NSDictionary *dic = [self objectForKey:key];
    if (dic != nil && ![dic isKindOfClass:[NSDictionary class]]) {
        NSLog(@"DGPlister: %@ %@ value type error", NSStringFromSelector(_cmd), key);
        return nil;
    }
    return [dic mutableCopy];
}

- (nullable NSArray *)arrayForKey:(NSString *)key {
    NSArray *arr = [self objectForKey:key];
    if (arr != nil && ![arr isKindOfClass:[NSArray class]]) {
        NSLog(@"DGPlister: %@ %@ value type error", NSStringFromSelector(_cmd), key);
        return nil;
    }
    return arr;
}

- (nullable NSMutableArray *)mutableArrayForKey:(NSString *)key {
    NSArray *arr = [self objectForKey:key];
    if (arr != nil && ![arr isKindOfClass:[NSArray class]]) {
        NSLog(@"DGPlister: %@ %@ value type error", NSStringFromSelector(_cmd), key);
        return nil;
    }
    return [arr mutableCopy];
}

- (nullable NSString *)stringForKey:(NSString *)key {
    NSString *str = [self objectForKey:key];
    if (str != nil && ![str isKindOfClass:[NSString class]]) {
        NSLog(@"DGPlister: %@ %@ value type error", NSStringFromSelector(_cmd), key);
        return nil;
    }
    return str;
}

- (nullable NSString *)stringForKey:(NSString *)key nilOrEmpty:(nullable NSString * (NS_NOESCAPE^)(void))nilOrEmptyHandler {
    NSString *str = [self stringForKey:key];
    if (!str.length) {
        // nil or empty
        if (nilOrEmptyHandler) {
            return nilOrEmptyHandler();
        }
    }
    return str;
}

- (BOOL)boolForKey:(NSString *)key {
    NSNumber *number = [self objectForKey:key];
    if (number != nil && ![number isKindOfClass:[NSNumber class]]) {
        NSLog(@"DGPlister: %@ %@ value type error", NSStringFromSelector(_cmd), key);
        return NO;
    }
    return [number boolValue];
}

- (NSInteger)integerForKey:(NSString *)key {
    NSNumber *number = [self objectForKey:key];
    if (number != nil && ![number isKindOfClass:[NSNumber class]]) {
        NSLog(@"DGPlister: %@ %@ value type error", NSStringFromSelector(_cmd), key);
        return 0;
    }
    return [number integerValue];
}

- (float)floatForKey:(NSString *)key {
    NSNumber *number = [self objectForKey:key];
    if (number != nil && ![number isKindOfClass:[NSNumber class]]) {
        NSLog(@"DGPlister: %@ %@ value type error", NSStringFromSelector(_cmd), key);
        return 0;
    }
    return [number floatValue];
}

- (double)doubleForKey:(NSString *)key {
    NSNumber *number = [self objectForKey:key];
    if (number != nil && ![number isKindOfClass:[NSNumber class]]) {
        NSLog(@"DGPlister: %@ %@ value type error", NSStringFromSelector(_cmd), key);
        return 0;
    }
    return [number doubleValue];
}

#pragma mark -

- (NSString *)description {
    NSDictionary *dic = [self read];
    return [NSString stringWithFormat:@"%@ \nfilePath: %@, \ncontent: \n%@", [super description], self.filePath, dic.description];
}

@end

//
//  DGPlister.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGPlister : NSObject

@property (nonatomic, copy, readonly) NSString *filePath;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 初始化（仅支持字典类型的 plist 文件）

 @param filePath plist文件路径
 @param readonly YES, 只读取，不写入; NO，可读取可写入，如果文件不存在，则创建一个
 @return 如果一切正常，返回DGPlister对象；如果文件读取或写入出错，返回空值
 */
- (instancetype)initWithFilePath:(NSString *)filePath readonly:(BOOL)readonly;

- (NSMutableDictionary *)read;
- (BOOL)writeDictionary:(NSDictionary *)dictionary;

- (BOOL)containsKey:(NSString *)key;

- (BOOL)removeAllObjects;
- (BOOL)removeObjectForKey:(NSString *)key;

///------------------------------------------------
/// write
///------------------------------------------------

- (BOOL)setObject:(id)obj forKey:(NSString *)key;

- (BOOL)setDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;

- (BOOL)setArray:(NSArray *)value forKey:(NSString *)key;

- (BOOL)setString:(NSString *)value forKey:(NSString *)key;

- (BOOL)setBool:(BOOL)value forKey:(NSString *)key;

- (BOOL)setInteger:(NSInteger)value forKey:(NSString *)key;

- (BOOL)setFloat:(float)value forKey:(NSString *)key;

- (BOOL)setDouble:(double)value forKey:(NSString *)key;

///------------------------------------------------
/// read
///------------------------------------------------

- (nullable id)objectForKey:(NSString *)key;
- (nullable id)objectForKey:(NSString *)key nilHandler:(nullable id (NS_NOESCAPE^)(void))nilHandler;

- (nullable NSDictionary<NSString *, id> *)dictionaryForKey:(NSString *)key;
- (nullable NSMutableDictionary<NSString *, id> *)mutableDictionaryForKey:(NSString *)key;

- (nullable NSArray *)arrayForKey:(NSString *)key;
- (nullable NSMutableArray *)mutableArrayForKey:(NSString *)key;

- (nullable NSString *)stringForKey:(NSString *)key;
- (nullable NSString *)stringForKey:(NSString *)key nilOrEmpty:(nullable NSString * (NS_NOESCAPE^)(void))nilOrEmptyHandler;

- (BOOL)boolForKey:(NSString *)key;

- (NSInteger)integerForKey:(NSString *)key;

- (float)floatForKey:(NSString *)key;

- (double)doubleForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

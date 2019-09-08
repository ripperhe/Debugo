//
//  DGOrderedDictionary.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 An ordered dictionary.
 
 Inspired by http://www.cocoawithlove.com/2008/12/ordereddictionary-subclassing-cocoa.html
 */

@interface DGOrderedDictionary<__covariant KeyType, __covariant ObjectType> : NSObject<NSMutableCopying>

/** When updating the value of the existing key, move the subscript to the end. Default is NO. */
@property (nonatomic, assign) BOOL moveToLastWhenUpdateValue;

+ (instancetype)dictionary;
+ (instancetype)dictionaryWithCapacity:(NSUInteger)numItems;
- (instancetype)init;
- (instancetype)initWithCapacity:(NSUInteger)numItems;
/** ⚠️ The value of the sortedKeys element must be one-to-one correspondence with the key value of keysAndObjects. */
- (instancetype)initWithSortedKeys:(NSArray <KeyType>*)sortedKeys keysAndObjects:(NSDictionary <KeyType, ObjectType>*)keysAndObjects;

- (void)setObject:(ObjectType)anObject forKey:(KeyType)aKey;
- (void)setObject:(ObjectType)anObject atIndex:(NSUInteger)anIndex;
- (void)insertObject:(ObjectType)anObject forKey:(KeyType)aKey atIndex:(NSUInteger)anIndex;

- (void)removeObjectForKey:(KeyType)aKey;
- (void)removeObjectAtIndex:(NSUInteger)anIndex;
- (void)removeAllObjects;

- (NSUInteger)count;

- (NSDictionary <KeyType, ObjectType>*)keysAndObjects;

- (KeyType)keyAtIndex:(NSUInteger)anIndex;

- (ObjectType)objectForKey:(KeyType)aKey;
- (ObjectType)objectAtIndex:(NSUInteger)anIndex;

- (NSArray <KeyType>*)allKeys;
- (NSArray <ObjectType>*)allValues;

- (NSArray <KeyType>*)sortedKeys;
- (NSArray <KeyType>*)reverseSortedKeys;

- (NSArray <ObjectType>*)sortedValues;
- (NSArray <ObjectType>*)reverseSortedValues;

- (NSEnumerator <ObjectType>*)keyEnumerator;
- (NSEnumerator <ObjectType>*)reverseKeyEnumerator;

- (void)enumerateKeysAndObjectsUsingBlock:(void (NS_NOESCAPE ^)(KeyType key, ObjectType obj, NSUInteger idx, BOOL *stop))block;
- (void)reverseEnumerateKeysAndObjectsUsingBlock:(void (NS_NOESCAPE ^)(KeyType key, ObjectType obj, NSUInteger idx, BOOL *stop))block;

@end

NS_ASSUME_NONNULL_END

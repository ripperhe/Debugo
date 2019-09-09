//
//  DGAccount.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGAccount : NSObject

/** App 账号的用户名 */
@property (nonatomic, copy) NSString *username;
/** App 账号的密码 */
@property (nonatomic, copy) NSString *password;

+ (instancetype)accountWithUsername:(NSString *)username password:(NSString *)password;
- (BOOL)isValid;

@end

NS_ASSUME_NONNULL_END

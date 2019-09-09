//
//  DGAccountPluginConfiguration.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/31.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGAccount.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGAccountPluginConfiguration : NSObject

/** 区分目前的账号环境；默认为 NO，即开发环境 */
@property (nonatomic, assign) BOOL isProductionEnvironment;
/** 公用开发环境账号 */
@property (nullable, nonatomic, strong) NSArray <DGAccount *>*commonDevelopmentAccounts;
/** 公用线上环境账号；如果不需要, 只设置开发环境账号即可 */
@property (nullable, nonatomic, strong) NSArray <DGAccount *>*commonProductionAccounts;

/** 使用 login bubble 选中列表中的某个账号时，会调用这个 block，并传回账号信息，你需要在这个 block 中实现自动登录 */
@property (nonatomic, copy) void(^execLoginCallback)(DGAccount *account);

@end

NS_ASSUME_NONNULL_END

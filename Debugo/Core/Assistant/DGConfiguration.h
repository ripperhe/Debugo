//
//  DGConfiguration.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DGTestAction.h"
#import "DGAccount.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGConfiguration : NSObject

///------------------------------------------------
/// test action
///------------------------------------------------

/** 公用 test action */
@property (nullable, nonatomic, strong) NSArray <DGTestAction *>*commonTestActions;


///------------------------------------------------
/// file
///------------------------------------------------

/** 自定义快捷显示数据库文件（数据库文件或包含数据库的文件夹） */
@property (nonatomic, strong) NSArray <NSURL *>*shortcutForDatabaseURLs;
/** 自定义快捷显示任意文件（文件或文件夹均可） */
@property (nonatomic, strong) NSArray <NSURL *>*shortcutForAnyURLs;


///------------------------------------------------
/// setting 以下设置均可在设置页面开启; 如需强制开启，可在代码中设置
///------------------------------------------------

/** Debug 页面是否全屏显示; 默认为 NO */
@property (nonatomic, assign) BOOL isFullScreen;
/** 是否在 debug bubble 显示 FPS; 默认为 NO */
@property (nonatomic, assign) BOOL isOpenFPS;
/** 是否显示 touch 效果; 默认为 NO */
@property (nonatomic, assign) BOOL isShowTouches;


///------------------------------------------------
/// quick login
///------------------------------------------------

/** 是否需要快速登陆的 login bubble; 如果设置为 NO, 后续设置均无效 */
@property (nonatomic, assign) BOOL needLoginBubble;
/** 初始化 Debugo 时是否为登陆状态; 用于判断当前是否需要开启 login bubble */
@property (nonatomic, assign) BOOL haveLoggedIn;
/** 区分目前的账号环境；默认为测试环境, 也就是 YES */
@property (nonatomic, assign) BOOL accountEnvironmentIsBeta;
/** 公用测试环境账号 */
@property (nullable, nonatomic, strong) NSArray <DGAccount *>*commonBetaAccounts;
/** 公用线上环境账号, 如果不需要, 只填写测试环境账号即可 */
@property (nullable, nonatomic, strong) NSArray <DGAccount *>*commonOfficialAccounts;


@end

NS_ASSUME_NONNULL_END

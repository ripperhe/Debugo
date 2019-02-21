//
//  DGDevice.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DGDeviceType) {
    DGDeviceTypeUnknown,
    DGDeviceTypeSimulator,        // i386 x86_64
    
    DGDeviceType_iPhone_4,        // iPhone3,1 iPhone3,2 iPhone3,3
    DGDeviceType_iPhone_4S,       // iPhone4,1
    DGDeviceType_iPhone_5,        // iPhone5,1 iPhone5,2
    DGDeviceType_iPhone_5c,       // iPhone5,3 iPhone5,4
    DGDeviceType_iPhone_5s,       // iPhone6,1 iPhone6,2
    DGDeviceType_iPhone_6,        // iPhone7,2
    DGDeviceType_iPhone_6_Plus,   // iPhone7,1
    DGDeviceType_iPhone_6s,       // iPhone8,1
    DGDeviceType_iPhone_6s_Plus,  // iPhone8,2
    DGDeviceType_iPhone_SE,       // iPhone8,4
    DGDeviceType_iPhone_7,        // iPhone9,1 iPhone9,3
    DGDeviceType_iPhone_7_Plus,   // iPhone9,2 iPhone9,4
    DGDeviceType_iPhone_8,        // iPhone10,1 iPhone10,4
    DGDeviceType_iPhone_8_Plus,   // iPhone10,2 iPhone10,5
    DGDeviceType_iPhone_X,        // iPhone10,3 iPhone10,6
    DGDeviceType_iPhone_XR,       // iPhone11,8
    DGDeviceType_iPhone_XS,       // iPhone11,2
    DGDeviceType_iPhone_XS_Max,   // iPhone11,4 iPhone11,6
};

@interface DGDevice : NSObject

/** e.g. "iPhone10,3" */
@property (nonatomic, copy, readonly) NSString *identifier;
/** e.g. "iPhone X (Global)" */
@property (nullable, nonatomic, copy, readonly) NSString *name;
/** e.g. "5.8" */
@property (nullable, nonatomic, copy, readonly) NSString *screenInch;
/** e.g. DGDeviceType_iPhone_XS */
@property (nonatomic, assign, readonly) DGDeviceType type;

///------------------------------------------------
/// Only the simulator has value.
///------------------------------------------------

/** simulator identifier e.g. "iPhone10,3" */
@property (nullable, nonatomic, copy, readonly) NSString *simulatorIdentifier;
/** simulator name e.g. "iPhone X (Global)" */
@property (nullable, nonatomic, copy, readonly) NSString *simulatorName;
/** simulator screen inch e.g. "5.8" */
@property (nullable, nonatomic, copy, readonly) NSString *simulatorScreenInch;
/** simulator type e.g. DGDeviceType_iPhone_XS */
@property (nonatomic, assign, readonly) DGDeviceType simulatorType;

+ (instancetype)currentDevice;

- (BOOL)isSimulator;

/** 物理屏幕是否为刘海屏（不代表布局是刘海布局） */
- (BOOL)isNotch;

/** 布局是否为刘海 */
- (BOOL)isNotchUI;

@end


/**
 利用硬件信息布局UI可能会有几个问题：
 1. 发布新硬件的时候无法识别
 2. 没有设置当前类型设备启动图的时候，按照当前硬件类型来适配，[UIScreen mainScreen].bounds可能跟当前机型物理屏幕不对应
 3. 放大模式的时候，问题同2
 */

NS_ASSUME_NONNULL_END

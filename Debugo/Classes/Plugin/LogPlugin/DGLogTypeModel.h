//
//  DGLogTypeModel.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGLogTypeModel : NSObject

@property (nonatomic, assign) int typeID;

@property (nonatomic, copy) NSDictionary *dg_dic;

@end

NS_ASSUME_NONNULL_END

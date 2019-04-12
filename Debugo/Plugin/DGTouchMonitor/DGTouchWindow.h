//
//  DGTouchWindow.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DGSuspensionContainer.h"

@interface DGTouchWindow : DGSuspensionContainer

- (void)displayEvent:(UIEvent *)event;

@end

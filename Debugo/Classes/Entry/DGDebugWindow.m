//
//  DGDebugWindow.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/15.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGDebugWindow.h"

@implementation DGDebugWindow
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        DGDebugViewController *debugVC = [[DGDebugViewController alloc] init];
        self.name = @"Debug Window";
        self.rootViewController = debugVC;
        self.windowLevel = 1999999;
    }
    return self;
}

@end

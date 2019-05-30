//
//  DGMetaMacro.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/10.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#ifndef DGMetaMacro_h
#define DGMetaMacro_h

#define dg_weakify(var) __weak typeof(var) dg_weak_##var = var;
#define dg_strongify(var) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(var) var = dg_weak_##var; \
_Pragma("clang diagnostic pop")

#endif /* DGMetaMacro_h */

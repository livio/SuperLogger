//
//  SLLogMacros.h
//  SuperLogger
//
//  Created by Joel Fischer on 7/23/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import "SLLoggerController.h"

#if DEBUG
#define SLogV(...)
#define SLogD(...)
#else
#define SLogV(...)
#define SLogD(...)
#endif

#define SLogR(...)
#define SLogE(...)

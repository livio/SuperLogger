//
//  SLLogMacros.h
//  SuperLogger
//
//  Created by Joel Fischer on 7/23/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import "SLLoggerController.h"

#if DEBUG
#define SLogTrace() // TODO
#define SLogV(...) // TODO
#define SLogD(...) // TODO
#else
#define SLogTrace()
#define SLogV(...)
#define SLogD(...)
#endif

#define SLogR(...) // TODO
#define SLogE(...) // TODO

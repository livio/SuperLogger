//
//  SLLogSearch.h
//  SuperLogger
//
//  Created by Joel Fischer on 7/20/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SLGlobals.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SLLogSearch <NSObject>

// TODO
// http://nshipster.com/search-kit/
// https://github.com/indragiek/SNRSearchIndex

/**
 *  Search for logs that match a filter among the stored logs. If successful, this method will return nil for the error, and an NSArray. If the method fails, it will return an error and an empty NSArray. Note that the array could be empty whether or not it succeeded.
 *
 *  @warning: This will run on a concurrent queue, whereas logging will occur on a serial queue.
 *
 *  @param filterBlock An array of filters to run over the stored logs. The return array should only return the logs that pass the filters.
 *  @param error       The error if the search failed for any reason other than returning no logs.
 *
 *  @return An array of logs that passed the filter.
 */
- (NSArray *)searchStoredLogsWithFilter:(NSArray<SLLogFilterBlock> *)filterBlock error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END

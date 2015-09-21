//
//  SLWebLoggerConnection.m
//  SuperLogger
//
//  Created by Joel Fischer on 9/18/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import "SLWebLoggerConnection.h"

@import SuperSocket;


@implementation SLWebLoggerConnection

#pragma mark - Overrides

/**
 *  Called by LHSServer
 */
- (NSObject<LHSResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
    // We need to do a replacement on the javascript that can start the connection to us – the server – so that it always points to the right address.
    if ([path isEqualToString:@"/logsocket.js"]) {
        NSString *wslocation = nil;
        NSString *scheme = [asyncSocket isSecure] ? @"wss" : @"ws";
        NSString *socketHost = [request headerField:@"Host"];
        
        // We need to determine if we're running in simulator (localhost) or on device (remote host)
        if (socketHost == nil) {
            NSString *port = [NSString stringWithFormat:@"%@", @(asyncSocket.localPort)];
            wslocation = [NSString stringWithFormat:@"%@://localhost:%@/logsocket", scheme, port];
        } else {
            wslocation = [NSString stringWithFormat:@"%@://%@/logsocket", scheme, socketHost];
        }
        
        NSDictionary *replacements = @{@"WEBSOCKET_URL": wslocation};
        
        return [[LHSDynamicFileResponse alloc] initWithFilePath:[self filePathForURI:path] forConnection:self separator:@"%%" replacementDictionary:replacements];
    }
    
    return [super httpResponseForMethod:method URI:path];
}

/**
 *  Called by LHSServer
 */
- (LHSWebSocket *)webSocketForURI:(NSString *)path {
    if ([path isEqualToString:@"/logsocket"]) {
        return [[LHSWebSocket alloc] initWithRequest:request socket:asyncSocket];
    }
    
    return [super webSocketForURI:path];
}

@end

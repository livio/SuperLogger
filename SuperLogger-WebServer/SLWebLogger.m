//
//  SLWebLogger.m
//  SuperLogger
//
//  Created by Joel Fischer on 9/14/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import "SLWebLogger.h"

#import "UIDevice+IPAddress.h"
#import <LivioHTTPServer/LivioHTTPServer.h>

#import "SLWebLoggerConnection.h"


NS_ASSUME_NONNULL_BEGIN

@interface SLWebLogger () <LHSWebSocketDelegate, LHSServerDelegate>

@property (assign, nonatomic) UInt16 port;
@property (strong, nonatomic) LHSServer *server;

@end


@implementation SLWebLogger

#pragma mark - Lifecycle

- (instancetype)init {
    return [self initWithPort:12346];
}

- (instancetype)initWithPort:(UInt16)port {
    self = [super init];
    
    _logInRelease = NO;
    _port = port;
    _server = [[LHSServer alloc] initWithDelegate:self];
    
    return self;
}

+ (instancetype)logger {
    return [[self alloc] init];
}

+ (instancetype)loggerWithPort:(UInt16)port {
    return [[self alloc] initWithPort:port];
}


#pragma mark - SLLogger Protocol

- (BOOL)setupLogger {
    if (self.port != 0) {
        [self.server setPort:self.port];
    }
    
    [self.server setType:@"_http._tcp."];
    [self.server setConnectionClass:[SLWebLoggerConnection class]];
    
    // Grab the root path of the website folder
    NSString *sitePath = [[NSBundle bundleForClass:[self class]].resourcePath stringByAppendingPathComponent:@"site"];
    [self.server setDocumentRoot:sitePath];
    
    NSError *error = nil;
    BOOL serverStarted = [self.server start:&error];
    [self.server republishBonjour];
    
    if (!serverStarted) {
        NSLog(@"Error starting server: %@", error);
    }
    
    return serverStarted;
}

- (void)logWithLog:(SLLog *)log formattedLog:(NSString *)stringLog {
    for (LHSWebSocket *webSocket in self.server.webSockets) {
        [webSocket sendMessage:stringLog];
    }
}

- (void)teardownLogger {
    [self.server stop];
}


#pragma mark - Readonly Properties

- (nullable NSString *)serverURLForType:(IPType)ipAddressType {
    if (!self.server.isRunning) {
        return nil;
    } else {
        switch (ipAddressType) {
            case IPTypeV4: {
                return [NSString stringWithFormat:@"http://%@:%@", [UIDevice currentIPAddressAndPreferIPv4:YES], @(self.port)];
            } break;
            case IPTypeV6: {
                return [NSString stringWithFormat:@"http://%@:%@", [UIDevice currentIPAddressAndPreferIPv4:NO], @(self.port)];
            } break;
            default: {
                NSAssert(NO, @"Unknown enum type: %@, @: %@", @(ipAddressType), [NSString stringWithUTF8String:__PRETTY_FUNCTION__]);
            } break;
        }
        
    }
}


#pragma mark - LHSServerDelegate
#pragma mark Server

- (void)serverDidStop:(LHSServer *)server {
    NSLog(@"SLWebLogger server did stop");
}

#pragma mark Bonjour

- (void)server:(LHSServer *)server bonjourDidPublish:(NSNetService *)netService {
    NSLog(@"SLWebLogger bonjour published: %@:%@", [UIDevice currentIPAddressAndPreferIPv4:YES], @(netService.port));
}

- (void)server:(LHSServer *)server bonjourPublishFailed:(NSNetService *)netService error:(NSDictionary *)errorDictionary {
    NSLog(@"SLWebLogger bonjour failed to publish: hostname: %@, type:%@, domain: %@\n"
          "Error Dict: %@", netService.hostName, netService.type, netService.domain, errorDictionary);
}

#pragma mark Connection

- (void)server:(LHSServer *)server connectionDidStart:(LHSConnection *)connection {
    NSLog(@"SLWebLogger server new connection: %@", connection);
}

- (void)server:(LHSServer *)server connectionDidClose:(LHSConnection *)connection {
    NSLog(@"SLWebLogger server connection closed: %@", connection);
}

#pragma mark WebSocket

- (void)server:(LHSServer *)server webSocketDidOpen:(LHSWebSocket *)socket {
    NSLog(@"SLWebLogger server websocket opened: %@", socket);
    socket.delegate = self;
    
    for (LHSWebSocket *webSocket in self.server.webSockets) {
        [webSocket sendMessage:@"test message"];
    }
}

- (void)server:(LHSServer *)server webSocketDidClose:(LHSWebSocket *)socket {
    NSLog(@"SLWebLogger server websocket closed: %@", socket);
}


#pragma mark - LHSWebSocketDelegate

- (void)webSocket:(LHSWebSocket *)socket didReceiveMessage:(NSString *)msg {
    NSLog(@"SLWebLogger server websocket: %@, message: %@", socket, msg);
}

- (void)webSocket:(LHSWebSocket *)socket didReceiveData:(NSData *)data {
    NSLog(@"SLWebLogger server websocket: %@, message: %@", socket, data);
}

- (void)webSocketDidClose:(LHSWebSocket *)ws {
    NSLog(@"SLWebLogger websocket did close: %@", ws);
}

@end

NS_ASSUME_NONNULL_END

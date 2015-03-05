//
//  MongooseServer.m
//
//  Created by SangChan on 2015. 3. 4..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import "MongooseServer.h"
#import "mongoose.h"
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

#define SERVER_ON  0
#define SERVER_OFF 1

@interface MongooseServer() {
    int _port;
    NSString *_rootPath;
    NSString *_startPage;
    struct mg_server *server;
    int s_received_signal;
}

@end

@implementation MongooseServer

static MongooseServer *sharedServer = nil;
+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedServer = [[super alloc] init];
    });
    return sharedServer;
}

-(void)setRootPath:(NSString *)rootPath
{
    _rootPath = rootPath;
}

-(void)setPort:(int)port
{
    _port = port;
}

-(void)start
{
    server = mg_create_server(NULL, NULL);
    s_received_signal = SERVER_ON;
    mg_set_option(server, "listening_port", [[NSString stringWithFormat:@"%d",_port]UTF8String]);
    mg_set_option(server, "document_root", [_rootPath UTF8String]);
    NSLog(@"Mongoose Server is running on http://%@:%d", [self localIPAddress],_port);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self pollingServer];
    });
}

-(void)pollingServer
{
    while (s_received_signal == SERVER_ON) {
        mg_poll_server(server, 100);
    }
}

-(void)pause
{
    s_received_signal = SERVER_OFF;
}

-(void)resume
{
    s_received_signal = SERVER_ON;
}

-(void)stop
{
    s_received_signal = SERVER_OFF;
    mg_destroy_server(&server);
}

// Return the localized IP address - From Erica Sadun's cookbook
- (NSString *) localIPAddress
{
    char baseHostName[255];
    gethostname(baseHostName, 255);
    
    // Adjust for iPhone -- add .local to the host name
    char hn[255];
    sprintf(hn, "%s.local", baseHostName);
    
    struct hostent *host = gethostbyname(hn);
    if (host == NULL)
    {
        herror("resolv");
        return NULL;
    }
    else {
        struct in_addr **list = (struct in_addr **)host->h_addr_list;
        return [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSASCIIStringEncoding];
    }
    
    return NULL;
}

@end

//
//  MongooseServer.h
//
//  Created by SangChan on 2015. 3. 4..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MongooseServer : NSObject

+(id)sharedInstance;
-(void)setRootPath:(NSString *)root;
-(void)setPort:(int)port;
-(void)start;
-(void)pause;
-(void)resume;
-(void)stop;

@end

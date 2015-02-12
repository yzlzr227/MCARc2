//
//  CommunicatingWithServer.m
//  MCARc2
//
//  Created by Zhuoran Li on 12/23/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

#import "CommunicatingWithServer.h"

@implementation CommunicatingWithServer
//http://192.168.0.114:8080/mcar/handleServlet
//
//http://192.168.0.114:8080/mcar/handleServlet

+(NSURL *)getTheOrderURL{
    NSURL *url;
    url = [[NSURL alloc] initWithString:@"http://172.16.24.52:8080/mcar/handleServlet"];
    return url;
}
+(NSURL *)reportLocationURL{
    NSURL *url;
    url = [[NSURL alloc] initWithString:@"http://172.16.24.52:8080/mcar/handleServlet"];

    return url;
}
@end

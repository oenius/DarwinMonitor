//
//  MANetworkMonitor.h
//  YiJieDai
//
//  Created by YURI_JOU on 15/11/4.
//  Copyright © 2015年 oenius. All rights reserved.
//

#import "DarwinMonitor.h"

#import <Foundation/Foundation.h>

@interface DMNetworkMonitor : NSURLProtocol<NSURLConnectionDelegate>

@property (nonatomic, weak) id <DMPrintableDelegate> delegate;

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *mutableData;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSURLRequest *nrequest;

+ (instancetype)monitor;

@end

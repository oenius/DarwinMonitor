//
//  MANetworkMonitor.m
//  YiJieDai
//
//  Created by YURI_JOU on 15/11/4.
//  Copyright © 2015年 oenius. All rights reserved.
//

#import "DMNetworkMonitor.h"

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface DMNetworkMonitor()

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSMutableString *info;

@end

@implementation DMNetworkMonitor

+ (instancetype)monitor
{
  static DMNetworkMonitor *monitor;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    monitor = [[self.class alloc]init];
  });
  return monitor;
}

- (instancetype)init
{
  self = [super init];
  if(self)
  {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishLaunch:) name:UIApplicationDidFinishLaunchingNotification object:nil];
  }
  return self;
}

- (NSMutableString *)info
{
  if(!_info)
  {
    _info = [[NSMutableString alloc]initWithCapacity:10];
  }
  return _info;
}

- (void)didFinishLaunch:(NSNotification *)notification
{
  [NSURLProtocol registerClass:[self class]];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
  if ([NSURLProtocol propertyForKey:@"DMNetworkMonitorKey" inRequest:request]) {
    return NO;
  }
  
  return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
  return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
  return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading {
  NSMutableURLRequest *newRequest = [self.request mutableCopy];

  [NSURLProtocol setProperty:@YES forKey:@"DMNetworkMonitorKey" inRequest:newRequest];
  [NSURLProtocol setProperty:[NSDate date] forKey:@"DMNetworkMonitorTimeKey" inRequest:newRequest];
  
  self.nrequest = newRequest;
  self.connection = [NSURLConnection connectionWithRequest:newRequest delegate:self];
  
  [self logRequest:newRequest];
}

- (void)logRequest:(NSURLRequest *)request
{
  self.info = [[NSMutableString alloc]initWithCapacity:10];
  
  NSString *method = [NSString stringWithFormat:@"Request: %@ %@",request.HTTPMethod, request.URL.absoluteString];
  NSLog(@"%@",method);
  
  [self.info appendString:method];
  
  [self logMonitor];
  NSDictionary *headers = [request allHTTPHeaderFields];
  [self logHeaders:headers];
}

- (void)logMonitor
{
  if([[DMNetworkMonitor monitor].delegate respondsToSelector:@selector(monitor:write:info:atTime:)])
  {
    NSDate *time = [NSURLProtocol propertyForKey:@"DMNetworkMonitorTimeKey" inRequest:self.nrequest];
    [[DMNetworkMonitor monitor].delegate monitor:self write:self.nrequest.URL.absoluteString info:self.info atTime:time];
  }
}

- (void)logHeaders:(NSDictionary *)headers
{
  NSLog(@"HEADERS FIELD: [");
  [self.info appendString:@"HEADERS FIELD: [\n"];
  
  [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    
    NSLog(@"%@ : %@", key, obj);
    NSString *value = [NSString stringWithFormat:@"%@ : %@", key, obj];
    
    [self.info appendString:value];
  }];
  
  NSLog(@"]");
  [self.info appendString:@"]"];
  
  [self logMonitor];
}

- (void)stopLoading {
  [self.connection cancel];
  self.connection = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
  
  self.response = response;
  self.mutableData = [[NSMutableData alloc] init];
  
}


- (void)logResponse:(NSURLResponse *)response data:(NSData *)data
{
  if(response.URL.absoluteString)
  {
    NSLog(@"RESPONSE URL: %@",response.URL.absoluteString);
    NSString *value = [NSString stringWithFormat:@"RESPONSE URL: %@",response.URL.absoluteString];
    [self.info appendString:value];
  }
  
  if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
    NSInteger plainCode = [(NSHTTPURLResponse *)response statusCode];
    NSString *statusCode = [NSHTTPURLResponse localizedStringForStatusCode:plainCode];
    NSLog(@"STATUS CODE: %ld %@",plainCode, statusCode);
    NSString *value = [NSString stringWithFormat:@"STATUS CODE: %ld %@",plainCode, statusCode];
    [self.info appendString:value];
    NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
    [self logHeaders:headers];
  }
  
  if(data)
  {

    @try {
      NSError *error;
      id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
      id pretty = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
      NSString *prettyStr = [[NSString alloc]initWithData:pretty encoding:NSUTF8StringEncoding];
      
      if(prettyStr && !error)
      {
        NSLog(@"JSON DATA: %@",prettyStr);
        NSString *value = [NSString stringWithFormat:@"JSON DATA: %@",prettyStr];
//        [self.info appendString:value];
      }
    }
    @catch (NSException *exception)
    {
      NSString *prettyStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
      NSLog(@"DATA: %@",prettyStr);
      NSString *value = [NSString stringWithFormat:@"DATA: %@",prettyStr];
      [self.info appendString:value];
    }
  }
  
  [self logMonitor];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [self.client URLProtocol:self didLoadData:data];
    [self.mutableData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  [self.client URLProtocolDidFinishLoading:self];
  [self logResponse:self.response data:self.mutableData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  [self.client URLProtocol:self didFailWithError:error];
}

@end

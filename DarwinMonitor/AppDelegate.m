//
//  AppDelegate.m
//  DarwinMonitor
//
//  Created by YURI_JOU on 16/4/8.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "AppDelegate.h"
#import <SVProgressHUD.h>
#import "KSSystemInfo.h"

@interface AppDelegate ()

@end



@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.

//  NSSetUncaughtExceptionHandler(&HandleException);
//  
//  struct sigaction signalAction;
//  memset(&signalAction, 0, sizeof(signalAction));
//  signalAction.sa_handler = &HandleSignal;
//  
//  sigaction(SIGABRT, &signalAction, NULL);
//  sigaction(SIGILL, &signalAction, NULL);
//  sigaction(SIGBUS, &signalAction, NULL);
//  sigaction(SIGSEGV, &signalAction, NULL);
  

  return YES;
}

void HandleException(NSException *exception) {
  NSLog(@"App crashing with exception: %@", exception);
  //Save somewhere that your app has crashed.
  
  [SVProgressHUD showWithStatus:@"appp crashing"];
  
  NSString *crashs = [NSString stringWithFormat:@"We received a signal: %@", [NSThread callStackSymbols]];
  [SVProgressHUD showWithStatus:crashs];
  
  
  
}

void HandleSignal(int signal) {
  NSLog(@"We received a signal: %@", [NSThread callStackSymbols]);
  
  NSString *crashs = [NSString stringWithFormat:@"We received a signal: %@", [NSThread callStackSymbols]];
  
  //Save somewhere that your app has crashed.
}

//void InstallUncaughtExceptionHandler()
//{
//  signal(SIGABRT, MySignalHandler);
//  signal(SIGILL, MySignalHandler);
//  signal(SIGSEGV, MySignalHandler);
//  signal(SIGFPE, MySignalHandler);
//  signal(SIGBUS, MySignalHandler);
//  signal(SIGPIPE, MySignalHandler);
//}


- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

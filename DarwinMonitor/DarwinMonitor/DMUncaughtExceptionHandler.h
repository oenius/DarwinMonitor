//
//  DMUncaughtExceptionHandler.h
//  DarwinMonitor
//
//  Created by YURI_JOU on 16/4/12.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMUncaughtExceptionHandler : NSObject{
  BOOL dismissed;
}

void InstallUncaughtExceptionHandler();

@end

//
//  NSDate+DMExtra.h
//  DarwinMonitor
//
//  Created by YURI_JOU on 16/4/14.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DMExtra)

- (NSString *)stringWithDateFormatString:(NSString *)formateString;

+ (NSDate *)dateWithString:(NSString *)string
           formatterString:(NSString *)formatterString;
@end

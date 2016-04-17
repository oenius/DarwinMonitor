//
//  NSDate+DMExtra.m
//  DarwinMonitor
//
//  Created by YURI_JOU on 16/4/14.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "NSDate+DMExtra.h"

@implementation NSDate (DMExtra)

- (NSString *)stringWithDateFormatString:(NSString *)formateString
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  
  NSLocale * locale = [NSLocale currentLocale];
  [formatter setLocale:locale];
  [formatter setTimeZone:[NSTimeZone localTimeZone]];
  
  [formatter setDateFormat:formateString];
  return [formatter stringFromDate:self];
}

+ (NSDate *)dateWithString:(NSString *)string
           formatterString:(NSString *)formatterString
{
  NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
  
  NSLocale * locale = [NSLocale currentLocale];
  
  [formatter setLocale:locale];
  [formatter setTimeZone:[NSTimeZone localTimeZone]];
  
  [formatter setDateFormat:formatterString];
  return [formatter dateFromString:string];
}


@end

//
//  MAFPSMonitor.h
//  YiJieDai
//
//  Created by YURI_JOU on 15/11/2.
//  Copyright © 2015年 oenius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DMFPSMonitor : NSObject

@property (nonatomic, copy) void(^fpsBlock)(CGFloat);

@end
 
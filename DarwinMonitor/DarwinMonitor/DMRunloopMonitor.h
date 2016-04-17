//
//  DMRunloopMonitor.h
//  DarwinMonitor
//
//  Created by YURI_JOU on 16/4/11.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMRunloopMonitor : NSObject

@property (nonatomic, copy)void(^handleBadHappened)(void);

- (void)start;

@end

//
//  UIView+DMExtra.h
//  DarwinMonitor
//
//  Created by YURI_JOU on 16/4/13.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DMExtra)

-(CGSize)size;
-(CGPoint)origin;

-(CGFloat)x;
-(CGFloat)y;
-(CGFloat)width;
-(CGFloat)height;

-(void)setX:(CGFloat)newX;
-(void)setY:(CGFloat)newY;
-(void)setWidth:(CGFloat)newWidth;
-(void)setHeight:(CGFloat)newHeight;

+ (id)loadClass:(Class)iclass from:(NSString *)nibName;
@end

//
//  UIView+DMExtra.m
//  DarwinMonitor
//
//  Created by YURI_JOU on 16/4/13.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "UIView+DMExtra.h"

@implementation UIView (DMExtra)

/*
 STRUCTs
 */
-(CGSize)size{
  return self.frame.size;
}

-(CGPoint)origin{
  return self.frame.origin;
}

/*
 GETTERs
 */
-(CGFloat)x{
  return self.origin.x;
}

-(CGFloat)y{
  return self.origin.y;
}

-(CGFloat)width{
  return self.size.width;
}

-(CGFloat)height{
  return self.size.height;
}

/*
 SETTERs
 */
-(void)setX:(CGFloat)newX{
  self.frame = CGRectMake(newX, self.y, self.width, self.height);
}

-(void)setY:(CGFloat)newY{
  self.frame = CGRectMake(self.x, newY, self.width, self.height);
}

-(void)setWidth:(CGFloat)newWidth{
  self.frame = CGRectMake(self.x, self.y, newWidth, self.height);
}

-(void)setHeight:(CGFloat)newHeight{
  self.frame = CGRectMake(self.x, self.y, self.width, newHeight);
}

+ (id)loadClass:(Class) iclass from:(NSString *)nibName
{
  NSArray *views = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
  
  for (UIView *view in views)
  {
    if ([view isMemberOfClass:iclass])   return view;
  }
  return nil;
}

@end

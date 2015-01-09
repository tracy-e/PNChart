//
//  NSBezierPath+CGPath.h
//  PNChartOSXDemo
//
//  Created by TracyYih on 15/1/9.
//  Copyright (c) 2015年 esoftmobile.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSBezierPath (CGPath)

- (CGPathRef)CGPath;

@end
//
//  PNPieChartDataItem.h
//  PNChartDemo
//
//  Created by Hang Zhang on 14-5-5.
//  Copyright (c) 2014年 kevinzhow. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PNPieChartDataItem : NSObject

+ (instancetype)dataItemWithValue:(CGFloat)value
                            color:(NSColor*)color;

+ (instancetype)dataItemWithValue:(CGFloat)value
                            color:(NSColor*)color
                      description:(NSString *)description;

@property (nonatomic) CGFloat   value;
@property (nonatomic) NSColor  *color;
@property (nonatomic) NSString *textDescription;

@end

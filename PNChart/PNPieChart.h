//
//  PNPieChart.h
//  PNChartDemo
//
//  Created by Hang Zhang on 14-5-5.
//  Copyright (c) 2014年 kevinzhow. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PNPieChartDataItem.h"

@interface PNPieChart : NSView

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;

@property (nonatomic, readonly) NSArray	*items;

/** Default is 18-point Avenir Medium. */
@property (nonatomic) NSFont  *descriptionTextFont;

/** Default is white. */
@property (nonatomic) NSColor *descriptionTextColor;

/** Default is black, with an alpha of 0.4. */
@property (nonatomic) NSColor *descriptionTextShadowColor;

/** Default is CGSizeMake(0, 1). */
@property (nonatomic) CGSize   descriptionTextShadowOffset;

/** Default is 1.0. */
@property (nonatomic) NSTimeInterval duration;

- (void)strokeChart;

@end

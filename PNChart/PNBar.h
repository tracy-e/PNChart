//
//  PNBar.h
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface PNBar : NSControl

- (void)rollBack;

@property (nonatomic) float grade;
@property (nonatomic) NSColor *backgroundColor;
@property (nonatomic) CAShapeLayer *chartLine;
@property (nonatomic) NSColor *barColor;
@property (nonatomic) NSColor *barColorGradientStart;
@property (nonatomic) CGFloat barRadius;
@property (nonatomic) CAShapeLayer *gradientMask;

@end

//
//  PNChartLabel.m
//  PNChart
//
//  Created by kevin on 10/3/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNChartLabel.h"

@implementation PNChartLabel

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self) {
        self.font               = [NSFont boldSystemFontOfSize:10.0f];
        self.alignment          = NSCenterTextAlignment;
        self.drawsBackground    = NO;
        self.editable           = NO;
        self.bezeled            = NO;
        self.selectable         = NO;
    }
    
    return self;
}



@end

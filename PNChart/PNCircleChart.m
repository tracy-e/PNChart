//
//  PNCircleChart.m
//  PNChartDemo
//
//  Created by kevinzhow on 13-11-30.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNCircleChart.h"

static NSTimeInterval const kCountingSteps = 30.0;

@interface PNCircleChart ()
@property (nonatomic) float progress;
@property (nonatomic) float lastValue;
@property (nonatomic) float fromValue;
@property (nonatomic) float toValue;
@end

@implementation PNCircleChart

- (id)initWithFrame:(CGRect)frame total:(NSNumber *)total current:(NSNumber *)current clockwise:(BOOL)clockwise shadow:(BOOL)hasBackgroundShadow {
    
    return [self initWithFrame:frame
                         total:total
                       current:current
                     clockwise:clockwise
                        shadow:shadow
                   shadowColor:PNGreen
          displayCountingLabel:YES
             overrideLineWidth:@8.0f];
    
}

- (id)initWithFrame:(CGRect)frame total:(NSNumber *)total current:(NSNumber *)current clockwise:(BOOL)clockwise shadow:(BOOL)hasBackgroundShadow shadowColor:(NSColor *)backgroundShadowColor {
    
    return [self initWithFrame:frame
                         total:total
                       current:current
                     clockwise:clockwise
                        shadow:shadow
                   shadowColor:backgroundShadowColor
          displayCountingLabel:YES
             overrideLineWidth:@8.0f];
    
}

- (id)initWithFrame:(CGRect)frame total:(NSNumber *)total current:(NSNumber *)current clockwise:(BOOL)clockwise shadow:(BOOL)hasBackgroundShadow shadowColor:(NSColor *)backgroundShadowColor displayCountingLabel:(BOOL)displayCountingLabel {
    
    return [self initWithFrame:frame
                         total:total
                       current:current
                     clockwise:clockwise
                        shadow:shadow
                   shadowColor:PNGreen
          displayCountingLabel:displayCountingLabel
             overrideLineWidth:@8.0f];
    
}

- (id)initWithFrame:(CGRect)frame
              total:(NSNumber *)total
            current:(NSNumber *)current
          clockwise:(BOOL)clockwise
             shadow:(BOOL)hasBackgroundShadow
        shadowColor:(NSColor *)backgroundShadowColor
displayCountingLabel:(BOOL)displayCountingLabel
  overrideLineWidth:(NSNumber *)overrideLineWidth
{
    self = [super initWithFrame:frame];

    if (self) {
        _total = total;
        _current = current;
        _strokeColor = PNFreshGreen;
        _duration = 1.0;
        _chartType = PNChartFormatTypePercent;
        
        _displayCountingLabel = displayCountingLabel;
        _lineWidth = overrideLineWidth;
        
        self.wantsLayer = YES;
        CGFloat startAngle = clockwise ? 90.0f : -270.0f;
        CGFloat endAngle = clockwise ? 90.01f : -270.01f;
        
        CGMutablePathRef mutablePath = CGPathCreateMutable();
        CGPathAddArc(mutablePath,
                     NULL,
                     self.bounds.size.width/2.0f,
                     self.bounds.size.height/2.0f,
                     (self.frame.size.height * 0.5) - [_lineWidth floatValue],
                     DEGREES_TO_RADIANS(startAngle),
                     DEGREES_TO_RADIANS(endAngle),
                     clockwise);

        _circle               = [CAShapeLayer layer];
        _circle.path          = mutablePath;
        _circle.lineCap       = kCALineCapRound;
        _circle.fillColor     = [NSColor clearColor].CGColor;
        _circle.lineWidth     = [_lineWidth floatValue];
        _circle.zPosition     = 1;

        _circleBackground             = [CAShapeLayer layer];
        _circleBackground.path        = mutablePath;
        _circleBackground.lineCap     = kCALineCapRound;
        _circleBackground.fillColor   = [NSColor clearColor].CGColor;
        _circleBackground.lineWidth   = [_lineWidth floatValue];
        _circleBackground.strokeColor = (hasBackgroundShadow ? backgroundShadowColor.CGColor : [NSColor clearColor].CGColor);
        _circleBackground.strokeEnd   = 1.0;
        _circleBackground.zPosition   = -1;

        [self.layer addSublayer:_circle];
        [self.layer addSublayer:_circleBackground];

        NSFont *font = [NSFont boldSystemFontOfSize:16.0f];
        CGFloat height = font.pointSize;
        _countingLabel = [[PNChartLabel alloc] initWithFrame:CGRectZero];
        [_countingLabel setFont:font];
        [_countingLabel setTextColor:[NSColor grayColor]];
        _countingLabel.frame = CGRectMake(CGRectGetWidth(self.bounds) / 2 - 50.0f,
                                          (CGRectGetHeight(self.bounds) - height) / 2,
                                          100.0,
                                          height);
        if (_displayCountingLabel) {
            [self addSubview:_countingLabel];
        }
    }

    return self;
}


- (void)strokeChart
{
    // Add counting label

    if (_displayCountingLabel) {
        NSString *format;
        switch (self.chartType) {
            case PNChartFormatTypePercent:
                format = @"%d%%";
                break;
            case PNChartFormatTypeDollar:
                format = @"$%d";
                break;
            case PNChartFormatTypeNone:
            default:
                format = @"%d";
                break;
        }
        [self addSubview:self.countingLabel];
    }


    // Add circle params

    _circle.lineWidth   = [_lineWidth floatValue];
    _circleBackground.lineWidth = [_lineWidth floatValue];
    _circleBackground.strokeEnd = 1.0;
    _circle.strokeColor = _strokeColor.CGColor;

    // Add Animation
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = self.duration;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @0.0f;
    pathAnimation.toValue = @([_current floatValue] / [_total floatValue]);
    [_circle addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    _circle.strokeEnd   = [_current floatValue] / [_total floatValue];

    [self countingLabelFromValue:0 toValue:[_current floatValue] withDuration:1.0];

    // Check if user wants to add a gradient from the start color to the bar color
    if (_strokeColorGradientStart) {

        // Add gradient
        self.gradientMask = [CAShapeLayer layer];
        self.gradientMask.fillColor = [[NSColor clearColor] CGColor];
        self.gradientMask.strokeColor = [[NSColor blackColor] CGColor];
        self.gradientMask.lineWidth = _circle.lineWidth;
        self.gradientMask.lineCap = kCALineCapRound;
        CGRect gradientFrame = CGRectMake(0, 0, 2*self.bounds.size.width, 2*self.bounds.size.height);
        self.gradientMask.frame = gradientFrame;
        self.gradientMask.path = _circle.path;

        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.startPoint = CGPointMake(0.5,1.0);
        gradientLayer.endPoint = CGPointMake(0.5,0.0);
        gradientLayer.frame = gradientFrame;
        NSColor *endColor = (_strokeColor ? _strokeColor : [NSColor greenColor]);
        NSArray *colors = @[
                            (id)endColor.CGColor,
                            (id)_strokeColorGradientStart.CGColor
                            ];
        gradientLayer.colors = colors;

        [gradientLayer setMask:self.gradientMask];

        [_circle addSublayer:gradientLayer];

        self.gradientMask.strokeEnd = [_current floatValue] / [_total floatValue];

        [self.gradientMask addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    }
}



- (void)growChartByAmount:(NSNumber *)growAmount
{
    NSNumber *updatedValue = [NSNumber numberWithFloat:[_current floatValue] + [growAmount floatValue]];

    // Add animation
    [self updateChartByCurrent:updatedValue];
}


-(void)updateChartByCurrent:(NSNumber *)current{
    // Add animation
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = self.duration;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @([_current floatValue] / [_total floatValue]);
    pathAnimation.toValue = @([current floatValue] / [_total floatValue]);
    _circle.strokeEnd   = [current floatValue] / [_total floatValue];
    
    if (_strokeColorGradientStart) {
        self.gradientMask.strokeEnd = _circle.strokeEnd;
        [self.gradientMask addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    }
    [_circle addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    if (_displayCountingLabel) {
        [self countingLabelFromValue:fmin([_current floatValue], [_total floatValue])
                             toValue:fmin([current floatValue], [_total floatValue])
                        withDuration:self.duration];
    }
    
    _current = current;
}

- (void)countingLabelFromValue:(float)from toValue:(float)to withDuration:(NSTimeInterval)interval
{
    self.progress = 0;
    self.lastValue = from;
    self.fromValue = from;
    self.toValue = to;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval / kCountingSteps
                                                      target:self
                                                    selector:@selector(updateCountingLabel:)
                                                    userInfo:nil
                                                     repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
}

- (void)updateCountingLabel:(NSTimer *)timer
{
    self.progress += 1 / kCountingSteps;
    if (self.progress > 1) {
        [timer invalidate];
        self.lastValue = self.toValue;
    } else {
        self.lastValue += (self.toValue - self.fromValue) / kCountingSteps;
    }
    
    NSString *format;
    switch (self.chartType) {
        case PNChartFormatTypePercent:
            format = @"%d%%";
            break;
        case PNChartFormatTypeDollar:
            format = @"$%d";
            break;
        case PNChartFormatTypeNone:
        default:
            format = @"%d";
            break;
    }
    _countingLabel.stringValue = [NSString stringWithFormat:format, (int)self.lastValue];
}

@end

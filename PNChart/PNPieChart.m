//
//  PNPieChart.m
//  PNChartDemo
//
//  Created by Hang Zhang on 14-5-5.
//  Copyright (c) 2014年 kevinzhow. All rights reserved.
//

#import "PNPieChart.h"
#import <QuartzCore/QuartzCore.h>
#import "PNChartLabel.h"

@class PNChartLabel;

@interface PNPieChart()

@property (nonatomic, readwrite) NSArray	*items;
@property (nonatomic) CGFloat total;
@property (nonatomic) CGFloat currentTotal;

@property (nonatomic) CGFloat outerCircleRadius;
@property (nonatomic) CGFloat innerCircleRadius;

@property (nonatomic) NSView  *contentView;
@property (nonatomic) CAShapeLayer *pieLayer;
@property (nonatomic) NSMutableArray *descriptionLabels;

- (void)loadDefault;

- (PNChartLabel *)descriptionLabelForItemAtIndex:(NSUInteger)index;
- (PNPieChartDataItem *)dataItemForIndex:(NSUInteger)index;

- (CAShapeLayer *)newCircleLayerWithRadius:(CGFloat)radius
                               borderWidth:(CGFloat)borderWidth
                                 fillColor:(NSColor *)fillColor
                               borderColor:(NSColor *)borderColor
                           startPercentage:(CGFloat)startPercentage
                             endPercentage:(CGFloat)endPercentage;


@end


@implementation PNPieChart

-(id)initWithFrame:(CGRect)frame items:(NSArray *)items{
	self = [self initWithFrame:frame];
	if(self){
        self.wantsLayer = YES;
		_items = [NSArray arrayWithArray:items];
		_outerCircleRadius = CGRectGetWidth(self.bounds)/2;
		_innerCircleRadius  = CGRectGetWidth(self.bounds)/6;
		
		_descriptionTextColor = [NSColor whiteColor];
		_descriptionTextFont  = [NSFont fontWithName:@"Avenir-Medium" size:18.0];
        _descriptionTextShadowColor = [[NSColor blackColor] colorWithAlphaComponent:0.4];
        _descriptionTextShadowOffset =  CGSizeMake(0, 1);
		_duration = 1.0;
        
		[self loadDefault];
	}
	
	return self;
}


- (void)loadDefault{
	_currentTotal = 0;
	_total       = 0;
	
	[_contentView removeFromSuperview];
	_contentView = [[NSView alloc] initWithFrame:self.bounds];
	[self addSubview:_contentView];
    [_descriptionLabels removeAllObjects];
	_descriptionLabels = [NSMutableArray new];
	
	_pieLayer = [CAShapeLayer layer];
	[_contentView.layer addSublayer:_pieLayer];
}

#pragma mark -

- (void)strokeChart{
	[self loadDefault];
	
	[self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		_total +=((PNPieChartDataItem *)obj).value;
	}];
	
	PNPieChartDataItem *currentItem;
	CGFloat currentValue = 0;
	for (int i = 0; i < _items.count; i++) {
		currentItem = [self dataItemForIndex:i];
		
		
		CGFloat startPercnetage = currentValue/_total;
		CGFloat endPercentage   = (currentValue + currentItem.value)/_total;
		
		CAShapeLayer *currentPieLayer =	[self newCircleLayerWithRadius:_innerCircleRadius + (_outerCircleRadius - _innerCircleRadius)/2
                                                           borderWidth:_outerCircleRadius - _innerCircleRadius
                                                             fillColor:[NSColor clearColor]
                                                           borderColor:currentItem.color
                                                       startPercentage:startPercnetage
                                                         endPercentage:endPercentage];
		[_pieLayer addSublayer:currentPieLayer];
		
		currentValue+=currentItem.value;
		
	}
	
	[self maskChart];
	
	currentValue = 0;
    for (int i = 0; i < _items.count; i++) {
		currentItem = [self dataItemForIndex:i];
		PNChartLabel *descriptionLabel = [self descriptionLabelForItemAtIndex:i];
		[_contentView addSubview:descriptionLabel];
		currentValue+=currentItem.value;
        [_descriptionLabels addObject:descriptionLabel];
	}
}

- (PNChartLabel *)descriptionLabelForItemAtIndex:(NSUInteger)index{
	PNPieChartDataItem *currentDataItem = [self dataItemForIndex:index];
    CGFloat distance = _innerCircleRadius + (_outerCircleRadius - _innerCircleRadius) / 2;
    CGFloat centerPercentage =(_currentTotal + currentDataItem.value /2 ) / _total;
    CGFloat rad = centerPercentage * 2 * M_PI;
    
	_currentTotal += currentDataItem.value;
	
    PNChartLabel *descriptionLabel = [[PNChartLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
    descriptionLabel.alignment = NSLeftTextAlignment;
    NSString *titleText = currentDataItem.textDescription;
    if(!titleText){
        titleText = [NSString stringWithFormat:@"%.0f%%",currentDataItem.value/ _total * 100];
        descriptionLabel.stringValue = titleText ;
    }
    else {
        NSString* str = [NSString stringWithFormat:@"%.0f%%\n",currentDataItem.value/ _total * 100];
        str = [str stringByAppendingString:titleText];
        descriptionLabel.stringValue = str ;
    }
    
    CGPoint center = CGPointMake(_outerCircleRadius + distance * sin(rad),
                                 _outerCircleRadius + distance * cos(rad));
    
    descriptionLabel.font = _descriptionTextFont;
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSCenterTextAlignment;
    CGSize labelSize = [descriptionLabel.stringValue sizeWithAttributes:@{NSFontAttributeName:descriptionLabel.font,
                                                                          NSParagraphStyleAttributeName: style}];
    labelSize.width += 10;
    descriptionLabel.usesSingleLineMode = NO;
    descriptionLabel.textColor = _descriptionTextColor;
    descriptionLabel.layer.shadowColor = [_descriptionTextShadowColor CGColor];
    descriptionLabel.layer.shadowOffset = _descriptionTextShadowOffset;
    descriptionLabel.alignment = NSCenterTextAlignment;
    descriptionLabel.frame = CGRectMake(center.x - labelSize.width / 2,
                                        center.y - labelSize.height / 2,
                                        labelSize.width,
                                        labelSize.height);
    descriptionLabel.alphaValue = 0;
	return descriptionLabel;
}

- (PNPieChartDataItem *)dataItemForIndex:(NSUInteger)index{
	return self.items[index];
}

#pragma mark private methods

- (CAShapeLayer *)newCircleLayerWithRadius:(CGFloat)radius
                               borderWidth:(CGFloat)borderWidth
                                 fillColor:(NSColor *)fillColor
                               borderColor:(NSColor *)borderColor
                           startPercentage:(CGFloat)startPercentage
                             endPercentage:(CGFloat)endPercentage{
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds));

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, center.x, center.y, radius, M_PI_2, -M_PI_2 * 3, YES);
    
    circle.fillColor   = fillColor.CGColor;
    circle.strokeColor = borderColor.CGColor;
    circle.strokeStart = startPercentage;
    circle.strokeEnd   = endPercentage;
    circle.lineWidth   = borderWidth;
    circle.path        = path;
    
	
	return circle;
}

- (void)maskChart{
	CAShapeLayer *maskLayer =	[self newCircleLayerWithRadius:_innerCircleRadius + (_outerCircleRadius - _innerCircleRadius)/2
                                                 borderWidth:_outerCircleRadius - _innerCircleRadius
                                                   fillColor:[NSColor clearColor]
                                                 borderColor:[NSColor blackColor]
                                             startPercentage:0
                                               endPercentage:1];
	
	_pieLayer.mask = maskLayer;
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	animation.duration  = _duration;
	animation.fromValue = @0;
	animation.toValue   = @1;
    animation.delegate  = self;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	animation.removedOnCompletion = YES;
	[maskLayer addAnimation:animation forKey:@"circleAnimation"];
}

- (void)createArcAnimationForLayer:(CAShapeLayer *)layer ForKey:(NSString *)key fromValue:(NSNumber *)from toValue:(NSNumber *)to Delegate:(id)delegate
{
	CABasicAnimation *arcAnimation = [CABasicAnimation animationWithKeyPath:key];
	arcAnimation.fromValue = @0;
	[arcAnimation setToValue:to];
	[arcAnimation setDelegate:delegate];
	[arcAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
	[layer addAnimation:arcAnimation forKey:key];
	[layer setValue:to forKey:key];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [_descriptionLabels enumerateObjectsUsingBlock:^(NSView *view, NSUInteger idx, BOOL *stop) {
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:0.2];
        view.alphaValue = 1;
        [NSAnimationContext endGrouping];
    }];
}
@end

//
//  ChartViewController.m
//  PNChartOSXDemo
//
//  Created by TracyYih on 15/1/9.
//  Copyright (c) 2015年 esoftmobile.com. All rights reserved.
//

#import "ChartViewController.h"
#import "PNCircleChart.h"
#import "PNLineChart.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"

@interface ChartViewController ()

@property (nonatomic) PNLineChart *lineChart;
@property (nonatomic) PNCircleChart *circleChart;

@end

@implementation ChartViewController

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    [self loadChartView];
    self.titleLabel.stringValue = title;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)loadChartView {
    self.updateButton.hidden = YES;
    [self.lineChart removeFromSuperview];
    [self.circleChart removeFromSuperview];
    
    if ([self.title isEqualToString:@"Line Chart"]) {

        self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(20, 100, 360, 200.0)];
        self.lineChart.yLabelFormat = @"%1.1f";
        [self.lineChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 6",@"SEP 7"]];
        self.lineChart.showCoordinateAxis = YES;
        self.lineChart.xUnit = @"x";
        self.lineChart.yUnit = @"y";
        
        //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
        //Only if you needed
        self.lineChart.yFixedValueMax = 500;
        self.lineChart.yFixedValueMin = 1.0;
        
        // Line Chart #1
        NSArray * data01Array = @[@60.1, @160.1, @126.4, @262.2, @186.2, @127.2, @176.2];
        PNLineChartData *data01 = [PNLineChartData new];
        data01.color = PNFreshGreen;
        data01.alpha = 0.3f;
        data01.itemCount = data01Array.count;
        data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
        data01.getData = ^(NSUInteger index) {
            CGFloat yValue = [data01Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        
        // Line Chart #2
        NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2];
        PNLineChartData *data02 = [PNLineChartData new];
        data02.color = PNTwitterColor;
        data02.alpha = 0.5f;
        data02.itemCount = data02Array.count;
        data02.inflexionPointStyle = PNLineChartPointStyleSquare;
        data02.getData = ^(NSUInteger index) {
            CGFloat yValue = [data02Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        
        self.lineChart.chartData = @[data01, data02];
        [self.lineChart strokeChart];
//        self.lineChart.delegate = self;
        
        [self.view addSubview:self.lineChart];
        
        self.updateButton.hidden = NO;

    } else if ([self.title isEqualToString:@"Circle Chart"]) {
        
        self.circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 150, CGRectGetWidth(self.view.bounds), 150)
                                                          total:@100
                                                        current:@80
                                                      clockwise:YES
                                                         shadow:YES];
        [self.circleChart setStrokeColor:PNGreen];
        [self.circleChart setStrokeColorGradientStart:[NSColor blueColor]];
        [self.circleChart strokeChart];
        
        [self.view addSubview:self.circleChart];
        
        self.updateButton.hidden = NO;
    }
}

- (IBAction)changeValue:(id)sender {
    if ([self.title isEqualToString:@"Line Chart"]) {
        
        // Line Chart #1
        NSArray * data01Array = @[@(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300)];
        PNLineChartData *data01 = [PNLineChartData new];
        data01.color = PNFreshGreen;
        data01.itemCount = data01Array.count;
        data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
        data01.getData = ^(NSUInteger index) {
            CGFloat yValue = [data01Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        
        // Line Chart #2
        NSArray * data02Array = @[@(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300)];
        PNLineChartData *data02 = [PNLineChartData new];
        data02.color = PNTwitterColor;
        data02.itemCount = data02Array.count;
        data02.inflexionPointStyle = PNLineChartPointStyleSquare;
        data02.getData = ^(NSUInteger index) {
            CGFloat yValue = [data02Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        
        [self.lineChart setXLabels:@[@"DEC 1",@"DEC 2",@"DEC 3",@"DEC 4",@"DEC 5",@"DEC 6",@"DEC 7"]];
        [self.lineChart updateChartData:@[data01, data02]];

    } else if ([self.title isEqualToString:@"Circle Chart"]) {
        
        [self.circleChart updateChartByCurrent:@(arc4random() % 100)];
        
    }
}


@end
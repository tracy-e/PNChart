//
//  ChartViewController.m
//  PNChartOSXDemo
//
//  Created by TracyYih on 15/1/9.
//  Copyright (c) 2015年 esoftmobile.com. All rights reserved.
//

#import "ChartViewController.h"

#import "PNChart.h"

#define ARC4RANDOM_MAX 0x100000000


@interface ChartViewController ()

@property (nonatomic) PNLineChart *lineChart;
@property (nonatomic) PNCircleChart *circleChart;
@property (nonatomic) PNBarChart *barChart;
@property (nonatomic) PNPieChart *pieChart;
@property (nonatomic) PNScatterChart *scatterChart;
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
    [self.barChart removeFromSuperview];
    [self.circleChart removeFromSuperview];
    [self.pieChart removeFromSuperview];
    [self.scatterChart removeFromSuperview];
    
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

    } else if ([self.title isEqualToString:@"Bar Chart"]) {
    
        self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(50, 135.0, 320, 200.0)];
        self.barChart.yLabelFormatter = ^(CGFloat yValue){
            CGFloat yValueParsed = yValue;
            NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
            return labelText;
        };
        self.barChart.labelMarginTop = 5.0;
        [self.barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 6",@"SEP 7"]];
        self.barChart.rotateForXAxisText = true ;
        [self.barChart setYValues:@[@1,@24,@12,@18,@30,@10,@21]];
        [self.barChart setStrokeColors:@[PNGreen,PNGreen,PNRed,PNGreen,PNGreen,PNYellow,PNGreen]];
        // Adding gradient
        self.barChart.barColorGradientStart = [NSColor blueColor];
        
        [self.barChart strokeChart];
        
//        self.barChart.delegate = self;
        
        [self.view addSubview:self.barChart];
        
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
    } else if ([self.title isEqualToString:@"Pie Chart"]) {
        
        NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNLightGreen],
                           [PNPieChartDataItem dataItemWithValue:20 color:PNFreshGreen description:@"WWDC"],
                           [PNPieChartDataItem dataItemWithValue:40 color:PNDeepGreen description:@"GOOG I/O"],
                           ];
        
        self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(100, 100, 200.0, 200.0) items:items];
        self.pieChart.descriptionTextColor = [NSColor whiteColor];
        self.pieChart.descriptionTextFont  = [NSFont fontWithName:@"Avenir-Medium" size:11.0];
        self.pieChart.descriptionTextShadowColor = [NSColor clearColor];
        [self.pieChart strokeChart];
        
        [self.view addSubview:self.pieChart];
    } else if ([self.title isEqualToString:@"Scatter Chart"]) {
        
        self.scatterChart = [[PNScatterChart alloc] initWithFrame:CGRectMake(50, 100, 300, 200)];
        [self.scatterChart setAxisXWithMinimumValue:20 andMaxValue:100 toTicks:6];
        [self.scatterChart setAxisYWithMinimumValue:20 andMaxValue:50 toTicks:5];
        
        NSArray * data01Array = [self randomSetOfObjects];
        PNScatterChartData *data01 = [PNScatterChartData new];
        data01.strokeColor = PNGreen;
        data01.fillColor = PNFreshGreen;
        data01.size = 2;
        data01.itemCount = [[data01Array objectAtIndex:0] count];
        data01.inflexionPointStyle = PNScatterChartPointStyleCircle;
        __block NSMutableArray *XAr1 = [NSMutableArray arrayWithArray:[data01Array objectAtIndex:0]];
        __block NSMutableArray *YAr1 = [NSMutableArray arrayWithArray:[data01Array objectAtIndex:1]];
        data01.getData = ^(NSUInteger index) {
            CGFloat xValue = [[XAr1 objectAtIndex:index] floatValue];
            CGFloat yValue = [[YAr1 objectAtIndex:index] floatValue];
            return [PNScatterChartDataItem dataItemWithX:xValue AndWithY:yValue];
        };
        
        [self.scatterChart setup];
        self.scatterChart.chartData = @[data01];
        /***
         this is for drawing line to compare
         CGPoint start = CGPointMake(20, 35);
         CGPoint end = CGPointMake(80, 45);
         [self.scatterChart drawLineFromPoint:start ToPoint:end WithLineWith:2 AndWithColor:PNBlack];
         ***/
//        self.scatterChart.delegate = self;

        [self.view addSubview:self.scatterChart];

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

    } else if ([self.title isEqualToString:@"Bar Chart"]) {
        
        [self.barChart setXLabels:@[@"Jan 1",@"Jan 2",@"Jan 3",@"Jan 4",@"Jan 5",@"Jan 6",@"Jan 7"]];
        [self.barChart updateChartData:@[@(arc4random() % 30),@(arc4random() % 30),@(arc4random() % 30),@(arc4random() % 30),@(arc4random() % 30),@(arc4random() % 30),@(arc4random() % 30)]];
        
    } else if ([self.title isEqualToString:@"Circle Chart"]) {
        
        [self.circleChart updateChartByCurrent:@(arc4random() % 100)];
        
    }
}


/* this function is used only for creating random points */
- (NSArray *) randomSetOfObjects{
    NSMutableArray *array = [NSMutableArray array];
    NSString *LabelFormat = @"%1.f";
    NSMutableArray *XAr = [NSMutableArray array];
    NSMutableArray *YAr = [NSMutableArray array];

    for (int i = 0; i < 25 ; i++) {
        [XAr addObject:[NSString stringWithFormat:LabelFormat,(((double)arc4random() / ARC4RANDOM_MAX) * (self.scatterChart.AxisX_maxValue - self.scatterChart.AxisX_minValue) + self.scatterChart.AxisX_minValue)]];
        [YAr addObject:[NSString stringWithFormat:LabelFormat,(((double)arc4random() / ARC4RANDOM_MAX) * (self.scatterChart.AxisY_maxValue - self.scatterChart.AxisY_minValue) + self.scatterChart.AxisY_minValue)]];
    }
    
    [array addObject:XAr];
    [array addObject:YAr];
    return (NSArray*) array;
}

@end

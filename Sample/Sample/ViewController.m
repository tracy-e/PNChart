//
//  ViewController.m
//  PNChartOSXDemo
//
//  Created by TracyYih on 15/1/9.
//  Copyright (c) 2015年 esoftmobile.com. All rights reserved.
//

#import "ViewController.h"
#import "ChartViewController.h"

@interface ViewController ()

@property (nonatomic) NSArray *charts;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSView *ContainerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.charts = @[ @"Line Chart",
                     @"Bar Chart",
                     @"Circle Chart",
                     @"Pie Chart",
                     @"Scatter Chart"];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}

#pragma mark -
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger row = self.tableView.selectedRow;
    ChartViewController *controller = (ChartViewController *)self.childViewControllers[0];
    controller.title = self.charts[row];
}

#pragma mark -
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.charts count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return self.charts[row];
}

@end

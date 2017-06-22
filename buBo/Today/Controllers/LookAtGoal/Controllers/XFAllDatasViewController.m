//
//  XFAllDatasViewController.m
//  buBo
//
//  Created by mr.zhou on 2017/5/3.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFAllDatasViewController.h"
#import <RTRootNavigationController.h>
#import "buBo-Bridging-Header.h"
#import "buBo-Swift.h"
#import "XFLineChartViewDataFormatter.h"
#import "XFGreatChartsDataManager.h"

#import "XFAllDataModel.h"
#import "XFAllDataTableViewCell.h"
#import "XFLeftAxisDataFormatter.h"

@interface XFAllDatasViewController () <UITableViewDelegate,UITableViewDataSource,ChartViewDelegate>
@property (weak, nonatomic) IBOutlet LineChartView *lineChartView;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@property (nonatomic,strong) NSArray *models;

@property (nonatomic,strong) XFLineChartViewDataFormatter *dataFormatter;

@end

@implementation XFAllDatasViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//
    [self setupNavigationBar];
    
    self.dataFormatter = [[XFLineChartViewDataFormatter alloc] initForChart:self.lineChartView Goal:self.goal Date:[NSDate date]];
    
    self.title = self.goal.name;
    [self setupLineChartView];
    [self setAXis];
    self.lineChartView.data = [self setLineData];

    [self setupTableView];
}

-(void)setupNavigationBar {


    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationBack"] forBarMetrics:UIBarMetricsDefault ];
        
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // 设置左边按钮
    UIButton *menuButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 30, 30))];
    
    [menuButton setImage:[UIImage imageNamed:@"addGoal_back"] forState:(UIControlStateNormal)];
    
    [menuButton addTarget:self action:@selector(clickLeftButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;

}

-(void)clickLeftButton {

    [self.navigationController popViewControllerAnimated:YES];

}

-(void)setupLineChartView {

    self.lineChartView.delegate = self;
    self.lineChartView.chartDescription.enabled = NO;
    self.lineChartView.dragEnabled = NO;
    self.lineChartView.drawGridBackgroundEnabled = NO;
    self.lineChartView.scaleXEnabled = NO;
    self.lineChartView.scaleYEnabled = NO;
    self.lineChartView.drawBordersEnabled = NO;

}

-(void)setAXis {

    ChartYAxis *leftAxis = self.lineChartView.leftAxis;
    [leftAxis removeAllLimitLines];
    leftAxis.axisMinimum = 0;
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.labelCount = 5;
    leftAxis.drawGridLinesEnabled = NO;
    leftAxis.axisLineColor = [UIColor whiteColor];
    

    leftAxis.valueFormatter = [[XFLeftAxisDataFormatter alloc] init];
    
    self.lineChartView.rightAxis.enabled = NO;
    
    ChartXAxis *bottomAxis = self.lineChartView.xAxis;
    bottomAxis.labelPosition = XAxisLabelPositionBottom;
    bottomAxis.axisLineColor = [UIColor whiteColor];

    bottomAxis.labelCount = 30;
    
    bottomAxis.valueFormatter = self.dataFormatter;
    bottomAxis.drawGridLinesEnabled = NO;
    bottomAxis.labelTextColor = [UIColor blackColor];
    bottomAxis.labelFont = [UIFont systemFontOfSize:8];
    
    bottomAxis.forceLabelsEnabled = YES;
    self.lineChartView.legend.enabled = NO;
    

}

-(LineChartData *)setLineData {
    
    XFGreatChartsDataManager *manager = [XFGreatChartsDataManager shareManager];
    
    NSArray *timesArray = [manager getMonthDataWithDate:[NSDate date] Goal:self.goal];
//
//    NSArray *monthArr = manager.monthArr;
//
    // 设置y轴数据
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < 30; i++) {
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:[timesArray[29-i] integerValue]];
        [yVals addObject:entry];
    }
    
    LineChartDataSet *dataSet = [[LineChartDataSet alloc] initWithValues:yVals label:nil];
    
    dataSet.lineWidth = 1;
    dataSet.drawIconsEnabled = NO;
    [dataSet setColor:[UIColor colorWithRed:1.000 green:0.502 blue:0.000 alpha:1.000]];
    dataSet.circleColors = @[[UIColor colorWithRed:1.000 green:0.502 blue:0.000 alpha:1.000]];
    
    dataSet.circleRadius = 2;
    dataSet.drawValuesEnabled = NO;// 柱形图上面显示数值
    dataSet.drawCirclesEnabled = YES;
    dataSet.lineCapType = kCGLineCapRound;
    
    
    NSMutableArray *dataSets = [NSMutableArray array];
    [dataSets addObject:dataSet];
    
    LineChartData *data = [[LineChartData alloc] initWithDataSet:dataSet];
    
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];//文字字体
    [data setValueTextColor:[UIColor blackColor]];//文字颜色
//
    
    return data;
}

-(void) setupTableView {

    self.dataTableView.delegate = self;
    self.dataTableView.dataSource = self;
    
    self.dataTableView.separatorColor = [UIColor whiteColor];
    self.dataTableView.allowsSelection = NO;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.models.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XFAllDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFAllDataCell"];
    
    cell.model = self.models[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 30;
}

-(NSArray *)models {

    _models = [XFAllDataModel modelsWithDate:[NSDate date] Goal:self.goal];
    
    
    return _models;

}

@end

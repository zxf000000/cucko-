//
//  XFLookAtViewController.m
//  buBo
//
//  Created by mr.zhou on 2017/4/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFLookAtViewController.h"

#import <Masonry.h>
#import "XFGreatChartsDataManager.h"
#import "XFXAxisDateFormatter.h"
#import <RTRootNavigationController.h>


#import "XFAllDatasViewController.h"
#import "XFCoreDataManager.h"
#import "XFLeftAxisDataFormatter.h"

@interface XFLookAtViewController () <ChartViewDelegate>
@property (weak, nonatomic) IBOutlet BarChartView *barChartView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sinceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *iconClolorView;
@property (weak, nonatomic) IBOutlet UILabel *todayHoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *insistDays;
@property (weak, nonatomic) IBOutlet UILabel *actualEverydayLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastedSevenDaysLabel;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
// 点击暂停项目按钮
- (IBAction)onClickPauseButton:(id)sender;
// 点击所有数据按钮
- (IBAction)onClickAllDataButton:(id)sender;

@property (nonatomic,strong) NSArray *week;

@property (nonatomic,strong) NSArray *lastSevenDayTimes;

@end

@implementation XFLookAtViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsSelection = NO;
    
    NSInteger weekday = [XFGreatChartsDataManager getIndexsOfXAxisWithData:[NSDate date]];
    self.week = [XFGreatChartsDataManager getWeekWithWeekday:weekday];
    
    [self setupTopView];
    
    // 设置chartsView
    self.barChartView.backgroundColor = [UIColor whiteColor];
    
    self.barChartView.delegate = self;
    
    self.barChartView.chartDescription.enabled = NO;
    
    self.barChartView.borderColor = [UIColor whiteColor];
    self.barChartView.dragEnabled = NO;
    
    self.barChartView.scaleXEnabled = NO;
    self.barChartView.scaleYEnabled = NO;
    
    self.barChartView.pinchZoomEnabled = NO;
    
    [self.barChartView setExtraOffsetsWithLeft:5 top:-10 right:10 bottom:10];
    
    // 设置图例
    [self setAxis];
    self.barChartView.legend.enabled = NO;

    //    legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
//    legend.textColor = [UIColor blackColor];
//    // 水平方向位置
//    legend.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
//    // 垂直方向为止
//    legend.verticalAlignment = ChartLegendVerticalAlignmentBottom;
//    legend.orientation = ChartLegendOrientationHorizontal;
//    legend.drawInside = NO;
    
    self.barChartView.descriptionText = @"";
    
    self.barChartView.data = [self setData];
    
    [self.barChartView animateWithYAxisDuration:1];
    
    [self setupNavigationBar];

}

-(void)setupNavigationBar {

    self.title = @"目标详情";
        
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationBack"] forBarMetrics:(UIBarMetricsDefault)];

    
    UIButton *backButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 30, 30))];
    
    [backButton setImage:[UIImage imageNamed:@"addGoal_back"] forState:(UIControlStateNormal)];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [backButton addTarget:self action:@selector(popBack) forControlEvents:(UIControlEventTouchUpInside)];
    
}

- (void)popBack {

    [self.navigationController popViewControllerAnimated:YES];

}

-(void)setupTopView {
    
    self.nameLabel.text = self.goal.name;
    self.sinceLabel.text = [NSString stringWithFormat:@"从%@",self.goal.creatTime];
    self.iconView.image = (UIImage *)self.goal.pic;
    self.iconClolorView.image = [UIImage imageNamed:@"icon_backGround"];
    self.iconClolorView.layer.cornerRadius = 20;
    // 计算总时间
    NSDictionary *hoursDic = [NSJSONSerialization JSONObjectWithData:self.goal.beginAndEnd options:NSJSONReadingMutableContainers error:nil];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";


    __block NSInteger totalSeconds = 0.f;
    
    [hoursDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
       
        NSDate *beginTime = [[NSDateFormatter minuteDateFormatter] dateFromString:key];
        
        NSDate *endTime = [[NSDateFormatter minuteDateFormatter] dateFromString:obj];

        
        NSTimeInterval timeInterval = [endTime timeIntervalSinceDate:beginTime];

        
        totalSeconds += (NSInteger)timeInterval;
        
    }];
    
    self.todayHoursLabel.text = [NSString stringWithFormat:@"%.1f",totalSeconds/3600.f];

    
    // 获取坚持多少天
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:[dateFormatter dateFromString:self.goal.creatTime]];
    
    float totalDays = timeInterval/(3600.0 * 24.0) + 1.f;
    
    float actualEveryday = (totalSeconds/3600.f) / (float)totalDays;
    
    self.actualEverydayLabel.text = [NSString stringWithFormat:@"%.1fh",actualEveryday];
    
    self.insistDays.text = [NSString stringWithFormat:@"%.0f天",totalDays];
    // 取出最近7天数据
    float lastedSevenDaysHours = 0.f;
    
    self.lastSevenDayTimes = [[XFCoreDataManager shareManager] getLastSevenDaysTimesWithGoal:self.goal];
    
    for (int i = 0; i < 7 ; i++) {
        
        lastedSevenDaysHours += [self.lastSevenDayTimes[i] integerValue];
    
    }
    
    self.lastedSevenDaysLabel.text = [NSString stringWithFormat:@"%.1fh",(lastedSevenDaysHours/3600) / 7.f];
    
    
}


-(void)setAxis {
    // 设置X轴
    ChartXAxis *xAxis = self.barChartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.drawGridLinesEnabled = NO;
    xAxis.labelFont = [UIFont systemFontOfSize:10];
    xAxis.granularity = 1.0; // only intervals of 1 day
    xAxis.labelCount = 7;
    xAxis.axisLineColor = [UIColor whiteColor];

    xAxis.valueFormatter = [[XFXAxisDateFormatter alloc] initForChart:self.barChartView];
    
    // Y轴的数据样式
//    NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
//    leftAxisFormatter.minimumFractionDigits = 1;
//    leftAxisFormatter.maximumFractionDigits = 1;
//    leftAxisFormatter.negativeSuffix = @" h";
//    leftAxisFormatter.positiveSuffix = @" h";
    
    // 设置Y轴(左边)
    ChartYAxis *yAxis = self.barChartView.leftAxis;
    yAxis.drawGridLinesEnabled = NO;
    yAxis.axisMinValue = 0;

    yAxis.drawZeroLineEnabled = NO;
    yAxis.drawLimitLinesBehindDataEnabled = NO;
    yAxis.valueFormatter = [[XFLeftAxisDataFormatter alloc] init];
    yAxis.axisLineColor = [UIColor whiteColor];
    yAxis.forceLabelsEnabled = NO;
    // 设置Y(右边)
    ChartYAxis *rightAxis = self.barChartView.rightAxis;
    rightAxis.enabled = NO;
}

// 设置barCHartView数据
- (BarChartData *)setData {
    
    // 获取图标的数据-- 本周

//    NSArray *hoursArr = [XFGreatChartsDataManager getHoursOfWeek:self.week withGoalName:self.goal.name];

//    NSLog(@"%@",hoursDic);
    // X轴显示数据条数
    // Y轴的最大值
    // X轴上要展示的数据
    
    // 对应Y轴上要展示的数据
    NSMutableArray *yVals = [NSMutableArray array];
    
   double val = 0.f;
    
    int i = 1;
    
    for (i = 1; i<self.lastSevenDayTimes.count+1;i++) {
    
        val = [self.lastSevenDayTimes[i-1] floatValue];
        
        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:i y:val];
        [yVals addObject:entry];

    }
    // 创建BarChartDataSet对象,其中包含有Y轴数据信息,以及可以设置柱形样式
    BarChartDataSet *dataSet = [[BarChartDataSet alloc] initWithValues:yVals label:nil];
    
    dataSet.barBorderWidth = 0;
    dataSet.drawValuesEnabled = NO;// 柱形图上面显示数值
    [dataSet setColor:[UIColor colorWithRed:66/255.f green:255/255.f blue:224/255.f alpha:1]];// 柱形的颜色
    NSMutableArray *dataSets = [NSMutableArray array];
    [dataSets addObject:dataSet];
    
    // 创建barChartData对象
    BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
    [data setValueFont:[UIFont systemFontOfSize:12]];
    [data setValueTextColor:[UIColor orangeColor]];
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    // 自定义数据显示模式
//    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
//    [formatter setPositiveFormat:@"#0.0"];
//    [data setValueFormatter:formatter];
    
    return data;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10.f;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return @"";
}

- (IBAction)onClickPauseButton:(id)sender {
    
    if ([self.goal.name isEqualToString:@"固定"] || [self.goal.name isEqualToString:@"睡眠"] || [self.goal.name isEqualToString:@"浪费"] ) {
    
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        HUD.detailsLabel.text = @"此项目无需暂停";
        
        HUD.mode = MBProgressHUDModeText;
        
        [HUD hideAnimated:YES afterDelay:2];

        
        
    
    } else {
    
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        // 项目完成
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"完成项目" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            [[XFCoreDataManager shareManager] changeGoalStatusWithStatus:kGoalStatusDone Goal:self.goal];
            
        }];
        
        // 删除项目
        UIAlertAction *actionDelete = [UIAlertAction actionWithTitle:@"删除项目" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            // 删除目标
            [[XFCoreDataManager shareManager] changeGoalStatusWithStatus:kGoalStatusDeleted Goal:self.goal];
            
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            HUD.detailsLabel.text = @"已经从列表中删除项目";
            
            HUD.mode = MBProgressHUDModeText;
            
            [HUD hideAnimated:YES afterDelay:2];
            
        }];
        
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        
        [alertController addAction:doneAction];
        [alertController addAction:actionDelete];
        [alertController addAction:actionCancel];
        
        [self presentViewController:alertController animated:YES completion:nil];


    }
    
    
}

- (IBAction)onClickAllDataButton:(id)sender {
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"XFTodayStoryboard" bundle:nil];
    
    XFAllDatasViewController *allDataVC = [sb instantiateViewControllerWithIdentifier:@"XFAllDatasViewController"];
    
    allDataVC.goal = self.goal;
        
    [self.rt_navigationController pushViewController:allDataVC animated:YES complete:^(BOOL finished) {
        
        
    }];
    
}
@end

//
//  XFCountViewController.m
//  buBo
//
//  Created by mr.zhou on 2017/4/17.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFCountViewController.h"
#import "XFCountViewDataManager.h"
#import "XFCountViewChartDateFormatter.h"
#import "XFBestTimeCollectionViewCell.h"
#import "XFBestTimeDataModel.h"
#import "XFLeftAxisDataFormatter.h"

@interface XFCountViewController () <ChartViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *insistDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (weak, nonatomic) IBOutlet UIButton *dayAverageButton;
- (IBAction)onClickDayAverageButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *weekAverageButton;
@property (weak, nonatomic) IBOutlet UIButton *monthAverageButton;
- (IBAction)onClickWeekAverageButton:(id)sender;
- (IBAction)onClickMonthAverageButton:(id)sender;
@property (weak, nonatomic) IBOutlet LineChartView *averageChartView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleImageCenterConstraint;
@property (nonatomic,strong) XFCalendarCalculater *calcuater;
/**
 *  指定日期
 */
@property (nonatomic,strong) NSDate *date;

/**
 *  数据管理器
 */
@property (nonatomic,strong) XFCountViewDataManager *manager;
@property (weak, nonatomic) IBOutlet UIImageView *averageButtonSelecteView;
@property (weak, nonatomic) IBOutlet UIImageView *middleImageView;
/**
 *  选择范围的三个button
 */
@property (nonatomic,strong) NSArray *averageButtons;
/**
 *  最佳时间view
 */
@property (weak, nonatomic) IBOutlet UICollectionView *bestTimeVIew;

@property (nonatomic,strong) NSArray *bestTimeModels;

@end

@implementation XFCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavigationBar];
    
    self.manager = [XFCountViewDataManager shareManager];
    self.calcuater = [[XFCalendarCalculater alloc] init];
    
    self.date = [NSDate date];
    
    self.tableView.backgroundColor = kNavigationBarColor;
    
    [self setupAverageSelectedButtonView];

    [self setupDayAverageLabel];
    [self setupInsistDaysLabel];
    [self setupTotalTimesLabel];
    [self setupLineChartView];
    [self setupYvals];
    [self setupbestPeriodOfTimeChartView];
    
    [self setupBestTimeView];
    
}

-(void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    [self.bestTimeVIew reloadData];


}

-(void)setupBestTimeView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat height = 128;
    CGFloat width = (kScreenWidth - 50)/7;
    
    layout.itemSize = CGSizeMake(width, height);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.bestTimeVIew.collectionViewLayout = layout;
    
    self.bestTimeVIew.backgroundColor = [UIColor clearColor];
    
    self.bestTimeVIew.dataSource = self;


}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 7;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    XFBestTimeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFBestTimeCollectionViewCell" forIndexPath:indexPath];

    cell.model = self.bestTimeModels[indexPath.item];
    
    cell.colorViewHeightContraint.constant = 100 * cell.model.percent;

    
    return cell;

}

-(void)setupAverageSelectedButtonView {
    
    UIImage *image = [UIImage imageNamed:@"testBackImage"];
    
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    
    self.averageButtonSelecteView.image = image;
    
    UIImage *middleImage = [UIImage imageNamed:@"whiteCircle"];
    middleImage = [middleImage stretchableImageWithLeftCapWidth:middleImage.size.width/2 topCapHeight:middleImage.size.height/2];
    
    self.middleImageView.image = middleImage;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 7;
}

-(void)setupNavigationBar {

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationBack"] forBarMetrics:UIBarMetricsDefault ];
    
    self.title = @"统计";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // 设置左边按钮
    UIButton *menuButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 30, 30))];
    
    [menuButton setImage:[UIImage imageNamed:@"menu"] forState:(UIControlStateNormal)];
    
    [menuButton addTarget:self action:@selector(clickLeftButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;

}

-(void)clickLeftButton {
    
    if ([self.delegate respondsToSelector:@selector(countSlideViewDelegate)]) {
    
        [self.delegate countSlideViewDelegate];
    
    }

}

/**
 *  设置button的外观
 */
-(void)setupButtons {

    
    


}

/**
 *  设置最佳时段图表
 */
-(void)setupbestPeriodOfTimeChartView {
    


}

-(void)setupInsistDaysLabel {

    NSInteger days = [self.manager getInsistDays];
    
    self.insistDaysLabel.text = [NSString stringWithFormat:@"%zd 天",days];


}

-(void)setupTotalTimesLabel {
    
    NSInteger seconds = [self.manager getAllinsistSeconds];
    
    
    NSString *acturlyTime = @"";
    
    if (seconds <= 60) {
        
        acturlyTime = [NSString stringWithFormat:@"%zdsec",seconds];
        
        
    } else if (seconds > 60 && seconds <= 3600) {
        
        acturlyTime = [NSString stringWithFormat:@"%.1fmin",seconds/60.f];
        
        
    } else if (seconds > 3600 ) {
        
        acturlyTime = [NSString stringWithFormat:@"%.1fhr",seconds/3600.f];
        
        
    }
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%@",acturlyTime];


}

-(void)setupDayAverageLabel {
    
    NSInteger days = [self.manager getInsistDays];

    NSInteger seconds = [self.manager getAllinsistSeconds];

    if (days != 0) {
    
        
        NSString *acturlyTime = @"";
        
        if (seconds/days <= 60) {
            
            acturlyTime = [NSString stringWithFormat:@"%zdsec",seconds/days];
            
            
        } else if (seconds/days > 60 && seconds/days <= 3600) {
            
            acturlyTime = [NSString stringWithFormat:@"%.1fmin",seconds/days/60.f];
            
            
        } else if (seconds/days > 3600 ) {
            
            acturlyTime = [NSString stringWithFormat:@"%.1fhr",seconds/days/3600.f];
            
            
        }

        self.averageLabel.text = [NSString stringWithFormat:@"%@",acturlyTime];

    } else {
    
        self.averageLabel.text = [NSString stringWithFormat:@"%zd s",seconds];

    }
    
}

-(void)setupLineChartView {
    // 设置chartView
    self.averageChartView.delegate = self;
    

    self.averageChartView.chartDescription.enabled = NO;
    self.averageChartView.scaleYEnabled = NO;
    self.averageChartView.scaleXEnabled = NO;
    self.averageChartView.doubleTapToZoomEnabled = NO;
    
    self.averageChartView.legend.enabled = NO;
    // 设置X轴
    self.averageChartView.rightAxis.enabled = NO;
    
    ChartYAxis *leftAxis = self.averageChartView.leftAxis;
    
    leftAxis.inverted = NO;// 不翻转
    // 数据最小值---最大值要根据数据最大值来设置
    leftAxis.axisMinimum = 0;
    leftAxis.forceLabelsEnabled = YES;
    
    leftAxis.axisLineColor = [UIColor clearColor];
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;//label 位置
    leftAxis.labelTextColor = [UIColor colorWithWhite:0.800 alpha:1.000];
    leftAxis.labelFont = [UIFont systemFontOfSize:12];
    leftAxis.gridColor = [UIColor colorWithRed:1.000 green:0.502 blue:0.000 alpha:1.000];
    leftAxis.gridLineWidth = 1;
    // 数据格式有待设置
    
    // 设置x轴
    ChartXAxis *bottomAxis = self.averageChartView.xAxis;
    bottomAxis.granularityEnabled = NO;// 重复的值不显示
    bottomAxis.labelPosition = XAxisLabelPositionBottom;
    leftAxis.gridColor = [UIColor clearColor];
    bottomAxis.axisLineColor = [UIColor clearColor];
    bottomAxis.drawGridLinesEnabled = NO;
    bottomAxis.labelTextColor = [UIColor colorWithWhite:0.800 alpha:1.000];
    // 能够显示的数据数量
    self.averageChartView.maxVisibleCount = 100;
    
    // 设置y轴数据格式
    
    leftAxis.valueFormatter = [[XFLeftAxisDataFormatter alloc] init];

}

-(void)setupYvals {
    
    // 设置X轴展示的数据
    // 获取一周的日期
    NSArray *weekdays = [self.calcuater getAllWeekdaysForDate:self.date];
    
    NSMutableArray *weekdatStrs = [NSMutableArray array];
    
    for (NSInteger i = 0; i < weekdays.count;i ++) {
    
        [weekdatStrs addObject:[[NSDateFormatter dayDateFormatter] stringFromDate:weekdays[i]]];
        
    
    }
    
    ChartXAxis *bottomAxis = self.averageChartView.xAxis;

    XFCountViewChartDateFormatter *xAixsFormatter = [[XFCountViewChartDateFormatter alloc] initWithDayArray:weekdatStrs];
    
    bottomAxis.valueFormatter = xAixsFormatter;
    
    NSInteger xValsCount = 7;
    
    // 设置Y轴数据---首次显示一周数据
    NSMutableArray *yValus = [NSMutableArray array];
    
    NSArray *weekTimes = [self.manager getWeekDataFromDate:self.date];
    
    for ( NSInteger i = 0; i<xValsCount; i++) {
        
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:[weekTimes[i] integerValue]];
        
        [yValus addObject:entry];
        
    }
    
    LineChartDataSet *dataSet = [[LineChartDataSet alloc] initWithValues:yValus];
    
    dataSet.lineWidth = 2;

    [dataSet setColor:[UIColor colorWithRed:1.000 green:0.800 blue:0.400 alpha:1.000]];
    
    dataSet.drawValuesEnabled = NO;
    dataSet.drawCirclesEnabled = YES;
    dataSet.drawCircleHoleEnabled = NO;
    dataSet.circleRadius = 3;
    
    [dataSet setCircleColor:[UIColor colorWithRed:1.000 green:0.800 blue:0.400 alpha:1.000]];
    
    dataSet.valueTextColor = [UIColor colorWithRed:1.000 green:0.800 blue:0.400 alpha:1.000];
    
    NSMutableArray *dataSets = [NSMutableArray array];
    
    [dataSets addObject:dataSet];
    
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    
    self.averageChartView.data = data;

    [self.averageChartView animateWithYAxisDuration:0.25];

}

// 点击日均按钮
- (IBAction)onClickDayAverageButton:(id)sender {
    
    [self buttonAnimationWithButton:sender];
    
    [self setupYvals];
    
}

// 点击每周按钮
- (IBAction)onClickWeekAverageButton:(id)sender {
    
    [self buttonAnimationWithButton:sender];

    // 获取每周的数据
    NSArray *weekDatas = [self.manager getWeeksDataWithDate:self.date];
    // 获取八个周的第一天的日期
    // 获取本周的第一天
    NSDate *firstDate = [self.calcuater getFirstDayOfWeekWithDate:self.date];
    
    // 获取每个周的第一天
    NSMutableArray *weekFirstDays = [NSMutableArray array];
    
    for (NSInteger i = 7 ; i >=0 ;i-- ) {
    
        NSDate *tempDate = [self.calcuater getNextWeekdayWithDays:-7*i Date:firstDate];
        
        NSString *dateStr = [[NSDateFormatter dayDateFormatter] stringFromDate:tempDate];
        
        NSString *string1 = [dateStr substringWithRange:(NSMakeRange(5, 2))];
        
        NSString *string2 = [dateStr substringWithRange:(NSMakeRange(8, 2))];
        
        NSInteger month = [string1 integerValue];
        NSInteger day = [string2 integerValue];
        
        [weekFirstDays addObject:[NSString stringWithFormat:@"%zd月\n%zd日",month,day]];
    
    }
    
    XFCountViewChartDateFormatter *dateFormatter = [[XFCountViewChartDateFormatter alloc] initWithWeekArray:weekFirstDays];
    
    ChartXAxis *bottomAxis = self.averageChartView.xAxis;
    
    bottomAxis.valueFormatter = dateFormatter;
    
    // 设置数值
    NSInteger xVals_count = 8;
    NSMutableArray *yValus = [NSMutableArray array];

    for (NSInteger i = 0 ; i<xVals_count; i++) {
    
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:[weekDatas[i] integerValue]];
        
        [yValus addObject:entry];
    
    }
    
    LineChartDataSet *dataSet = [[LineChartDataSet alloc] initWithValues:yValus];
    
    dataSet.lineWidth = 2;
    
    [dataSet setColor:[UIColor colorWithRed:1.000 green:0.800 blue:0.400 alpha:1.000]];
    
    dataSet.drawValuesEnabled = NO;
    dataSet.drawCirclesEnabled = YES;
    dataSet.drawCircleHoleEnabled = NO;
    dataSet.circleRadius = 3;
    
    [dataSet setCircleColor:[UIColor colorWithRed:1.000 green:0.800 blue:0.400 alpha:1.000]];
    
    NSMutableArray *dataSets = [NSMutableArray array];
    
    [dataSets addObject:dataSet];
    
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    
    
    self.averageChartView.data = data;
    
    [self.averageChartView animateWithYAxisDuration:0.25];
    
    
}
// 点击每月按钮
- (IBAction)onClickMonthAverageButton:(id)sender {
    [self buttonAnimationWithButton:sender];

    // 获取每月的数据
    NSArray *monthDatas = [self.manager getMonthsDataWithDate:self.date];
    // 获去12个月的第一天的日期
    // 获取本月的第一天
    NSDate *firstDate = [self.calcuater getFirstDayWithDate:self.date];
    
    // 获取每个周的第一天
    NSMutableArray *monthFirstDays = [NSMutableArray array];
    
    for (NSInteger i = 11 ; i >=0 ;i-- ) {
        
        NSDate *tempDate = [self.calcuater getNextMonthDayWithMonth:-i Date:firstDate];
        
        NSString *dateStr = [[NSDateFormatter dayDateFormatter] stringFromDate:tempDate];
        
        NSString *string1 = [dateStr substringWithRange:(NSMakeRange(0, 4))];
        
        NSString *string2 = [dateStr substringWithRange:(NSMakeRange(5, 2))];
        
        NSInteger year = [string1 integerValue];
        NSInteger month = [string2 integerValue];
        
        [monthFirstDays addObject:[NSString stringWithFormat:@"%zd年\n%zd月",year,month]];
        
    }
    
    XFCountViewChartDateFormatter *dateFormatter = [[XFCountViewChartDateFormatter alloc] initWithMonthArray:monthFirstDays];
    
    ChartXAxis *bottomAxis = self.averageChartView.xAxis;
    
    bottomAxis.valueFormatter = dateFormatter;
    
    // 设置数值
    NSInteger xVals_count = 12;
    NSMutableArray *yValus = [NSMutableArray array];
    
    for (NSInteger i = 0 ; i<xVals_count; i++) {
        
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:[monthDatas[i] integerValue]];
        
        [yValus addObject:entry];
        
    }
    
    LineChartDataSet *dataSet = [[LineChartDataSet alloc] initWithValues:yValus];
    
    dataSet.lineWidth = 2;
    
    [dataSet setColor:[UIColor colorWithRed:1.000 green:0.800 blue:0.400 alpha:1.000]];
    
    dataSet.drawValuesEnabled = NO;
    dataSet.drawCirclesEnabled = YES;
    dataSet.drawCircleHoleEnabled = NO;
    dataSet.circleRadius = 3;
    
    [dataSet setCircleColor:[UIColor colorWithRed:1.000 green:0.800 blue:0.400 alpha:1.000]];
    
    NSMutableArray *dataSets = [NSMutableArray array];
    
    [dataSets addObject:dataSet];
    
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    
    
    self.averageChartView.data = data;
    
    [self.averageChartView animateWithYAxisDuration:0.25];

    
}

-(void)buttonAnimationWithButton:(UIButton *)button {
    
    for (UIButton *averageButton in self.averageButtons) {
    
        if (button == averageButton) {
        
            averageButton.userInteractionEnabled = NO;
            
            POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
            
            animation.toValue = [NSValue valueWithCGPoint:averageButton.center];
            
            [self.middleImageView pop_addAnimation:animation forKey:@""];
            
            POPSpringAnimation *colorAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLabelTextColor];
            
            colorAnimation.toValue = [UIColor whiteColor];
            
            [averageButton.titleLabel pop_addAnimation:colorAnimation forKey:@""];
            
        } else {
            
            averageButton.userInteractionEnabled = YES;
            
            POPSpringAnimation *colorAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLabelTextColor];
            
            colorAnimation.toValue = [UIColor colorWithWhite:0.800 alpha:1.000];
            
            [averageButton.titleLabel pop_addAnimation:colorAnimation forKey:@""];
        
        }
    
    }

}

-(NSArray *)averageButtons {

    if (_averageButtons == nil) {
    
        NSMutableArray *array = [NSMutableArray array];
        
        [array addObject:_dayAverageButton];
        [array addObject:_weekAverageButton];
        [array addObject:_monthAverageButton];
        
        _averageButtons = array.copy;
    
    }
    return _averageButtons;
}

-(NSArray *)bestTimeModels {

    if (_bestTimeModels == nil) {
        
        NSArray *array = [XFBestTimeDataModel allData];
        
        _bestTimeModels = array;
    }
    return _bestTimeModels;
}

@end

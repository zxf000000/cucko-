//
//  XFXAxisDateFormatter.m
//  buBo
//
//  Created by mr.zhou on 2017/5/2.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFXAxisDateFormatter.h"
#import "XFGreatChartsDataManager.h"

@interface XFXAxisDateFormatter ()

@property (nonatomic,strong) NSArray *months;

@property (nonatomic,strong) BarChartView *chart;

@end

@implementation XFXAxisDateFormatter

-(instancetype)initForChart:(BarChartView *)chart {

    if (self = [super init]) {
    
        _chart = chart;
        _months = @[@"Jan", @"Feb", @"Mar",
                    @"Apr", @"May", @"Jun",
                    @"Jul", @"Aug", @"Sep",
                    @"Oct", @"Nov", @"Dec"];
    }
    return self;
}

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    int days = (int)value;
    
    // 获取图标的数据-- 本周
    NSInteger weekday = [XFGreatChartsDataManager getIndexsOfXAxisWithData:[NSDate date]];
    
    NSArray *week = [XFGreatChartsDataManager getWeekWithWeekday:weekday];
    
    NSString *day = week[days - 1];
    
    NSArray *weekdays = [NSArray arrayWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日",nil];
        
    NSMutableArray *newWeekdays = [NSMutableArray array];
    
    for (NSInteger i = 0 ; i < weekdays.count ; i ++) {
        
        if (i<(7-weekday)) {
            
            [newWeekdays addObject:weekdays[i+weekday]];

        } else {
        
            
            [newWeekdays addObject:weekdays[i-(7-weekday)]];

        }
    
    }
    
    return [NSString stringWithFormat:@"%@ \n%@",newWeekdays[days - 1],[day substringFromIndex:5]];
    
}

@end

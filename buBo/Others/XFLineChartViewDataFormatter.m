//
//  XFLineChartViewDataFormatter.m
//  buBo
//
//  Created by mr.zhou on 2017/5/3.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFLineChartViewDataFormatter.h"
#import "XFGreatChartsDataManager.h"

@implementation XFLineChartViewDataFormatter
- (id)initForChart:(LineChartView *)chart Goal:(Goal *)goal Date:(NSDate *)date{

    if (self = [super init]) {
    
        _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _chartView = chart;
        
        _date = date;
        
        _goal = goal;
        
        XFGreatChartsDataManager *manager = [XFGreatChartsDataManager shareManager];
        
        [manager getMonthDataWithDate:_date Goal:_goal];
        
        _monthArr = manager.monthArr;
        
    }
    return self;
}

-(NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
    
    NSInteger day = (NSInteger)value;
    
    NSString *str = self.monthArr[day];
    
    NSString *subStr = [str substringFromIndex:5];
    
    NSInteger weekday = day%10;
    
    switch (weekday) {
        case 5:
            return subStr;
            
            break;
        case 0:
            return subStr;
            
            break;
        default:
            break;
    }
    
    return nil;
}

// 获取本月数据
-(NSDictionary *)getMonthDataWithDate:(NSDate *)date {
    
    NSDictionary *hoursDic = [NSJSONSerialization JSONObjectWithData:self.goal.times options:NSJSONReadingMutableContainers error:nil];
    
    NSDate *tempDate = nil;
    NSString *tempStr = nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSMutableArray *monthArr = [NSMutableArray array];
    
    NSMutableDictionary *monthDic = [NSMutableDictionary dictionary];
    
    for (int i = 29; i>=0 ;i++) {
    
        tempDate = [NSDate dateWithTimeInterval:- i*3600*24 sinceDate:date];
        tempStr = [formatter stringFromDate:tempDate];
        
        [monthArr addObject:tempStr];
        
        
        if ([[hoursDic allKeys] containsObject:tempStr]) {
            [monthDic setObject:[hoursDic objectForKey:tempStr] forKey:tempStr];
        } else {
        
            [monthDic setObject:[NSString stringWithFormat:@"%d",0] forKey:tempStr];
        }
    
    }
    
    self.monthArr = monthArr.copy;
    
    
    return monthDic;
}

@end

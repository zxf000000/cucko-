//
//  XFCalenderViewModel.m
//  buBo
//
//  Created by mr.zhou on 2017/5/5.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFCalenderViewModel.h"

@implementation XFCalenderViewModel

-(instancetype)initWithDate:(NSDate *)date {
    
    if (self = [super init]) {
        
        _calculator = [[XFCalendarCalculater alloc] init];
        
        _formatter = [[NSDateFormatter alloc] init];
        
        _formatter.dateFormat = @"yyyy-MM-dd";
    }
    return self;
    
}

+(instancetype)modelWithDate:(NSDate *)date {
    
    return [[self alloc] initWithDate:date];
}
// 获取按照周分组的数组
+(NSArray *)weekModels {
    
    // 初始化一个model
    XFCalenderViewModel *model = [[XFCalenderViewModel alloc] initWithDate:[NSDate date]];
    
    NSDate *minDate = [model.formatter dateFromString:@"1970-01-01"];
    // 多少个个月
    NSInteger weekCount = [model.calculator calculaterWeeksCount];
    
    NSMutableArray *allWeekArr = [NSMutableArray array];
    
    NSDate *tempDate = nil;
    
    for (NSInteger i = 0 ; i < weekCount ; i++) {
        
        tempDate = [model.calculator getNextWeekdayWithDays:i Date:minDate];
        
        [allWeekArr addObject:[model weekSectionArrayWithDate:tempDate]];
        
    }

    return allWeekArr.copy;
    
    
}

// 获取按照月分组的数组
+(NSArray *)monthModels {
    
    // 初始化一个model
    XFCalenderViewModel *model = [[XFCalenderViewModel alloc] initWithDate:[NSDate date]];
    
    NSDate *minDate = [model.formatter dateFromString:@"1970-01-01"];
    // 多少个个月
    NSInteger monthCount = [model.calculator calculateMonthCount];
    
    NSMutableArray *allMonthArr = [NSMutableArray array];
    
    NSDate *tempDate = nil;
    
    for (NSInteger i = 0 ; i < monthCount ; i++) {
        
        tempDate = [model.calculator getNextMonthDayWithMonth:i Date:minDate];
        
        [allMonthArr addObject:[model monthSectionArrayWithDate:tempDate]];
        
    }
    
    return allMonthArr.copy;
}

+(NSArray *)modelsWithDate:(NSDate *)date {
    
    // 获取一个月的数据
    // 确定这个月多少天
    NSRange days = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    
    // 确定当天的年月日信息
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *compents = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
    
    // 获取第一天
    NSDate *firstDay = [NSDate dateWithTimeInterval:-60*60*24*(compents.day-1) sinceDate:date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd";
    
    //    NSString *firstDayStr = [formatter stringFromDate:firstDay];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:firstDay];
    
    // 第一天是周几
    NSInteger firstWeekday = components.weekday - 1;
    // 本月多少天
    NSInteger monthDaysCount = days.length;
    // 本月多少行数据
    NSInteger travels = (monthDaysCount + firstWeekday-1)/7 + ((monthDaysCount + firstWeekday-1)%7==0?0:1);
    NSMutableArray *modelArr = [NSMutableArray array];
    NSDate *tempDate = nil;
    NSString *tempStr = nil;
    for (NSInteger i = -firstWeekday;i<travels * 7 - firstWeekday;i++) {
        
        tempDate = [NSDate dateWithTimeInterval:i * 60*60*24 sinceDate:firstDay];
        
        tempStr = [formatter stringFromDate:tempDate] ;
        
        [modelArr addObject:tempStr];
        
    }
    
    return  modelArr.copy;
}
// 按照周分组的组头
-(NSArray *)weekSectionHeaderArray {
    
    NSDate *minDate = [self.formatter dateFromString:@"1970-01-01"];
    // 多少周
    NSInteger weekCount = [self.calculator calculaterWeeksCount];
    NSMutableArray *weekHeaderArr = [NSMutableArray array];
    NSDate *tempDate = nil;
    
    for (NSInteger i = 0; i<weekCount; i++) {
        
        // 获取每周第一天日期
        tempDate  = [self.calculator getNextWeekdayWithDays:7*i Date:minDate];
        
        [weekHeaderArr addObject:[self.formatter stringFromDate:tempDate]];
    }
    return weekHeaderArr.copy;
}
// 获取按照月分组的组头
-(NSArray *)monthSectionHeaderArray {
    
    NSDate *minDate = [self.formatter dateFromString:@"1970-01-01"];
    
    // 多少个月
    NSInteger monthCount = [self.calculator calculateMonthCount];
    
    NSMutableArray *monthHeaderArr = [NSMutableArray array];
    
    NSDate *tempDate = nil;
    for (NSInteger i = 1; i<monthCount ; i++) {
        // 获取每个月第一天日期
        tempDate = [self.calculator getNextMonthDayWithMonth:i Date:minDate];
        
        [monthHeaderArr addObject:[self.formatter stringFromDate:tempDate]];
    }
    return tempDate.copy;
}
// 获取按照week分的每个组的数组
-(NSArray *)weekSectionArrayWithDate:(NSDate *)date {
    
    // 获取本周第一天的日期
    NSDate *firstDay = [self.calculator getFirstDayOfWeekWithDate:date];
    
    NSMutableArray *weekArr = [NSMutableArray array];
    
    for (int i = 0 ; i < 7 ; i ++) {
        
        NSString *day = [self.formatter stringFromDate:[NSDate dateWithTimeInterval:i*60*60*24 sinceDate:firstDay]];
        [weekArr addObject:day];
    }
    return weekArr.copy;
}
// 获取按照月分的每个组的数组
-(NSArray *)monthSectionArrayWithDate:(NSDate *)date {
    
    // 获取第一天日期
    NSDate *firstDay = [self.calculator getFirstDayWithDate:date];
    // 第一天是周几
    NSInteger firstDayWeekday = [self.calculator getFirstDayWeekdayWithDate:date];
    
    NSLog(@"%@------------%zd",firstDay,firstDayWeekday);
    
    // 总数是6行
    NSInteger travels = 6;
    NSMutableArray *modelArr = [NSMutableArray array];
    NSDate *tempDate = nil;
    NSString *tempStr = nil;
    for (NSInteger i = -firstDayWeekday;i<travels * 7 - firstDayWeekday;i++) {
        
        tempDate = [NSDate dateWithTimeInterval:i * 60*60*24 sinceDate:firstDay];
        
        tempStr = [self.formatter stringFromDate:tempDate] ;
        
        [modelArr addObject:tempStr];
        
    }
    return modelArr.copy;
}


@end

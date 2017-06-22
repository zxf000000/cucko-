//
//  XFCalendarCalculater.m
//  buBo
//
//  Created by mr.zhou on 2017/5/6.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFCalendarCalculater.h"

@interface XFCalendarCalculater()

@property (nonatomic,strong) NSCalendar *calendar;

@property (nonatomic,strong) NSDateFormatter *formatter;

@property (nonatomic,strong) NSDate *date;

@end

@implementation XFCalendarCalculater

-(instancetype)init {
    
    if (self = [super init]) {
        
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

        _calendar.minimumDaysInFirstWeek = 1;
        
        _formatter = [[NSDateFormatter alloc] init];
        
        _formatter.dateFormat = @"yyyy-MM-dd";
        
    }
    return self;
}

// 当天是周几----周日为1
-(NSInteger)getWeekdayForDate:(NSDate *)date {

    return [self.calendar component:NSCalendarUnitWeekday fromDate:date];
}

// 计算总的数据--1970/1/1--2099/12/31
-(NSInteger)calculateMonthCount {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd";
    
    // 获取总共多少月
    NSDateComponents *compsMonth = [self.calendar components:NSCalendarUnitMonth fromDate:[formatter dateFromString:@"1970-01-01"] toDate:[formatter dateFromString:@"2099-12-31"] options:NSCalendarWrapComponents];
    
    return compsMonth.month;
    
}
//计算总共多少周
-(NSInteger)calculaterWeeksCount {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd";
    // 获取总共多少周
    NSDateComponents *compsWeek = [self.calendar components:NSCalendarUnitWeekOfMonth fromDate:[formatter dateFromString:@"1970-01-01"] toDate:[formatter dateFromString:@"2099-12-31"] options:NSCalendarWrapComponents];
    
    return compsWeek.weekOfMonth;
    
}
// 计算下个月的今天/上个月的今天
-(NSDate *)getNextMonthDayWithMonth:(NSInteger)month Date:(NSDate *)date {
    
    // 获取下一个月的今天
    NSDateComponents *dateComp = [[NSDateComponents alloc] init];
    
    [dateComp setMonth:month];
    
    NSDate *nextMonthDate = [self.calendar dateByAddingComponents:dateComp toDate:date options:0];
    
    return nextMonthDate;
    
}
// 计算下周/上周的今天
-(NSDate *)getNextWeekdayWithDays:(NSInteger)days Date:(NSDate *)date {
    
    // 获取下一个月的今天
    NSDateComponents *dateComp = [[NSDateComponents alloc] init];
    
    [dateComp setDay:days];
    
    NSDate *nextWeekDate = [self.calendar dateByAddingComponents:dateComp toDate:date options:0];
    
    return nextWeekDate;
    
}

// 指定日期是多少组--week
-(NSInteger)getNumberOfWeekSectionWithDate:(NSDate *)date {
    // 获取指定日期从1970年开始的第几周
    NSDateComponents *compsWeek = [self.calendar components:NSCalendarUnitWeekOfMonth fromDate:[self.formatter dateFromString:@"1969-12-28"] toDate:date    options:NSCalendarWrapComponents];
    // 获取是周几
    //    NSInteger weekday = [self.calendar component:(NSCalendarUnitWeekday) fromDate:date];
    
    return compsWeek.weekOfMonth;
}
// 指定日期是多少组--month
-(NSInteger)getNumberOfMonthSectionWithDate:(NSDate *)date {
    // 获取指定日期从1970年开始的第几个月
    NSDateComponents *compsMonth = [self.calendar components:NSCalendarUnitMonth fromDate:[self.formatter dateFromString:@"1970-01-01"] toDate:date    options:NSCalendarWrapComponents];
    // 获取是第几天
    //    NSInteger weekday = [self.calendar component:(NSCalendarUnitWeekday) fromDate:date];
    // 第一天是周几
    
    return compsMonth.month;
}
// 获取当月第一天是周几
-(NSInteger)getFirstDayWeekdayWithDate:(NSDate *)date {
    
    // 获取当月第一天
    // 获取当天是几号
    NSInteger day = [self.calendar component:(NSCalendarUnitDay) fromDate:date];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    components.day = -day+1;
    // 获取1号
    NSDate *firstdate = [self.calendar dateByAddingComponents:components toDate:date options:NSCalendarMatchNextTime];
    
    // 获取1号是星期几
    
    NSInteger weekday = [self.calendar component:(NSCalendarUnitWeekday) fromDate:firstdate];
    
    return weekday;
}
// 获取当月第一天
-(NSDate *)getFirstDayWithDate:(NSDate *)date {
    
    // 获取当天是几号
    NSInteger day = [self.calendar component:(NSCalendarUnitDay) fromDate:date];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    components.day = -day+1;
    // 获取1号
    NSDate *firstdate = [self.calendar dateByAddingComponents:components toDate:date options:0];
    
    return firstdate;
    
}
// 获取本周的第一天的日期
-(NSDate *)getFirstDayOfWeekWithDate:(NSDate *)date {
    
    NSInteger weekday = [self.calendar component:(NSCalendarUnitWeekday) fromDate:date];
    
    // 星期日是几号
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    comp.day = -weekday+1;
    
    NSDate *firstWeekday = [self.calendar dateByAddingComponents:comp toDate:date options:0];
    
    return firstWeekday;
}
// 获取指定日期位于本组的index----从0开始
-(NSInteger)getIndexInMonthWithDate:(NSDate *)date {
    // 获取1号是周几
    NSInteger weekday = [self getFirstDayWeekdayWithDate:date];
    // 指定日
    NSString *today = [self.formatter stringFromDate:date];
    // 获取今天几号
    NSInteger dayNumber = [[today substringFromIndex:8] integerValue];
    
    // 位于第几组
    
    // 从0开始
    return dayNumber + weekday -2;
    
}
/**
 *  获取本周所有日期
 *
 *  @param date 指定日期
 *
 *  @return 本周日期数组
 */
-(NSArray *)getAllWeekdaysForDate:(NSDate *)date {

    // 获取今天是周几
    NSInteger weekday = [self.calendar component:(NSCalendarUnitWeekday) fromDate:date];
    
    // 获取周一
    NSDateComponents *component = [[NSDateComponents alloc] init];
    
    component.day = -weekday+1;
    
    NSDate *monday = [self.calendar dateByAddingComponents:component toDate:date options:NSCalendarWrapComponents];
    
    // 创建数组
    NSMutableArray *weekdays = [NSMutableArray array];
    
    for (NSInteger  i = 0; i< 7 ; i ++) {
    
        component.day = i;
        
        [weekdays addObject:[self.calendar dateByAddingComponents:component toDate:monday options:NSCalendarWrapComponents]];
    
    }
    
    
    
    return weekdays.copy;
}


// 获取当月多少天
-(NSInteger)getDaysCountOfMonthWithDate:(NSDate *)date {
    
    // 确定这个月多少天
    NSRange days = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    return days.length;
}

@end

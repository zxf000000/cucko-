//
//  XFTopViewCellModel.m
//  buBo
//
//  Created by mr.zhou on 2017/5/6.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFTopViewCellModel.h"
#import "XFCalendarCalculater.h"

@implementation XFTopViewCellModel
// 获取所有的month的第一天
+(NSArray *)dates {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    XFCalendarCalculater *calculator = [[XFCalendarCalculater alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *minDate = [formatter dateFromString:@"1970-01-01"];
    // 多少个个月
    NSInteger monthCount = [calculator calculateMonthCount];
    
    NSMutableArray *allMonthArr = [NSMutableArray array];
    
    NSDate *tempDate = nil;
    
    for (NSInteger i = 0 ; i < monthCount ; i++) {
        //获取每个月的第一天
        tempDate = [calculator getNextMonthDayWithMonth:i Date:minDate];
        
        [allMonthArr addObject:tempDate];
        
    }
    return allMonthArr.copy;
    
    
}
// 获取所有week的第一天
+(NSArray *)weekFirstDays {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    XFCalendarCalculater *calculator = [[XFCalendarCalculater alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *minDate = [formatter dateFromString:@"1969-12-28"];
    // 多少周
    NSInteger count = [calculator calculaterWeeksCount];
    
    NSMutableArray *allWeekArr = [NSMutableArray array];
    // 这一天是周六
//    NSDate *firstSunday = [calculator getFirstDayOfWeekWithDate:minDate];
    
//    NSDate *firstDay = [NSDate dateWithTimeInterval:60*60*24 sinceDate:firstSunday];
    
    NSDate *tempDate = nil;
    
    for (NSInteger i = 0 ; i < count ; i++) {
        //获取每个月的第一天
        tempDate = [calculator getNextWeekdayWithDays:7*i Date:minDate];
        
        
        [allWeekArr addObject:tempDate];
        
    }
    
    
    return allWeekArr.copy;
    
    
    
}

@end

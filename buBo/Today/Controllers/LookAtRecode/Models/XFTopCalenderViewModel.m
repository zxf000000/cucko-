//
//  XFTopCalenderViewModel.m
//  collectionViewTest
//
//  Created by mr.zhou on 2017/5/6.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//
// 根据日期获取当月的数据
#import "XFTopCalenderViewModel.h"
#import "XFCalendarCalculater.h"

@implementation XFTopCalenderViewModel

+(NSArray *)weekModelsWithDate:(NSDate *)date {
    
    // date即为第一天
    // 直接创建数组
    NSMutableArray *models = [NSMutableArray array];
    
    NSDate *tempDate = nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd";
    
    for (int i = 0 ;i < 7 ;i++) {
    
        tempDate = [NSDate dateWithTimeInterval:i*60*60*24 sinceDate:date];
        
        [models addObject:[formatter stringFromDate:tempDate]];
    
    }
    return models;
}

// 获取每个月的数据
+(NSArray *)modelsWithDate:(NSDate *)date {
    
    XFCalendarCalculater *calculator = [[XFCalendarCalculater alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd";
    
    // 获取第一天日期
    NSDate *firstDay = [calculator getFirstDayWithDate:date];
    // 第一天是周几
    NSInteger firstDayWeekday = [calculator getWeekdayForDate:firstDay];
    // 总数是6行
    NSInteger travels = 6;
    NSMutableArray *modelArr = [NSMutableArray array];
    NSDate *tempDate = nil;
    NSString *tempStr = nil;
    for (NSInteger i = -firstDayWeekday+1;i<travels * 7 - firstDayWeekday+1;i++) {
        
        tempDate = [NSDate dateWithTimeInterval:i * 60*60*24 sinceDate:firstDay];
        
        tempStr = [formatter stringFromDate:tempDate] ;
        
        [modelArr addObject:tempStr];
        
    }
    return modelArr.copy;

}


@end

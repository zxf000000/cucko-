//
//  XFGreatChartsDataManager.m
//  buBo
//
//  Created by mr.zhou on 2017/4/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFGreatChartsDataManager.h"
#import "buBo-Bridging-Header.h"
#import "buBo-Swift.h"

#import "Goal+CoreDataClass.h"
#import "XFCoreDataManager.h"

#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface XFGreatChartsDataManager ()

@property (nonatomic,assign) NSInteger weekday;

@property (nonatomic,strong) AppDelegate *appDelegate;

@end

@implementation XFGreatChartsDataManager

+(instancetype)shareManager {

    static XFGreatChartsDataManager *manager;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[XFGreatChartsDataManager alloc] init];
        
    });
    return manager;
}

// 获取今天是周几
+(NSInteger)getIndexsOfXAxisWithData:(NSDate *)date {

//    NSArray *weekdays = [NSArray arrayWithObjects:[NSNull null],@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone:timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *conpontent = [calendar components:calendarUnit fromDate:date];

    return conpontent.weekday - 1;
    
}

// 获取本周的日期
+(NSArray *)getWeekWithWeekday:(NSInteger)weekday {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *todayStr = [formatter stringFromDate:[NSDate date]];
    
    NSDate *today = [formatter dateFromString:todayStr];
    
    NSMutableArray *week = [NSMutableArray array];
    
    NSDate *tempDate = [NSDate date];
    
    for (int i = 6 ; i >=0 ; i --) {
        
        tempDate = [NSDate dateWithTimeInterval:-60*60*24*i  sinceDate:today];
        
        NSString *tempStr = [formatter stringFromDate:tempDate];
        
        [week addObject:tempStr];
        
    }
    
    
    return week.copy;
}

// 获取本周的数据
+(NSArray *)getHoursOfWeek:(NSArray *)week withGoalName:(NSString *)name{

    __block NSMutableDictionary *hoursDic = [NSMutableDictionary dictionary];
    
    // 筛选goal
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Goal" inManagedObjectContext:appdelegate.persistentContainer.viewContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity = entity;
    
    request.predicate = [NSPredicate predicateWithFormat:@"name like %@",name];
    
    NSArray *result = [appdelegate.persistentContainer.viewContext executeFetchRequest:request error:nil];
    
    Goal *goal = result[0];
    
    NSData *hoursData = goal.times;
    // 转换成字典
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:hoursData options:NSJSONReadingMutableContainers error:nil];
    __block NSMutableArray *tempArr = [NSMutableArray array];
    [tempDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        [tempArr addObject:key];
    }];
    // 枚举每天的日期
    for (NSString *day in week) {
        
        if ([tempArr containsObject:day]) {
            
            [hoursDic setObject:[tempDic objectForKey:day] forKey:day];
        } else {
        
        
            [hoursDic setObject:@"0" forKey:day];
        }
    }
    
    NSMutableArray *weekHours = [NSMutableArray array];
    
    for (int i = 0; i < week.count ;i ++) {
    
        [weekHours addObject:[hoursDic objectForKey:week[i]]];
    
    }
            
    return weekHours.copy;
}

// 获取一个月的数据
-(NSArray *)getMonthDataWithDate:(NSDate *)date  Goal:(Goal *)goal{
    
    // 获取所有时间数据
    NSDictionary *hoursDic = [NSJSONSerialization JSONObjectWithData:goal.beginAndEnd options:NSJSONReadingMutableContainers error:nil];
    
    NSDate *tempDate = nil;
    NSString *tempStr = nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSMutableArray *monthArr = [NSMutableArray array];
    
    NSMutableDictionary *monthDic = [NSMutableDictionary dictionary];
    
    NSMutableArray *timesArray = [NSMutableArray array];
    
    for (int i = 29; i>=0 ;i--) {

        [timesArray addObject:@"0"];
    }
    
    for (int i = 29; i>=0 ;i--) {
        
        tempDate = [NSDate dateWithTimeInterval:- i*3600*24 sinceDate:date];
        tempStr = [formatter stringFromDate:tempDate];
                
        [monthArr addObject:tempStr];
        
        [hoursDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
           
            NSString *dateStr = [key substringToIndex:10];
            
            if ([dateStr isEqualToString:tempStr]) {
            
                NSInteger second = [timesArray[i] integerValue];
                
                NSDate *beginTime = [[NSDateFormatter minuteDateFormatter] dateFromString:key];
                NSDate *endTime = [[NSDateFormatter minuteDateFormatter] dateFromString:obj];

                second += (NSInteger)[endTime timeIntervalSinceDate:beginTime];
            
                timesArray[i] = [NSString stringWithFormat:@"%zd",second];
            }
            
            
        }];
        
    }
    
    self.monthArr = monthArr.copy;

    return timesArray;

}

@end

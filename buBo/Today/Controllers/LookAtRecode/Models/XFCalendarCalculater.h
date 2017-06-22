//
//  XFCalendarCalculater.h
//  buBo
//
//  Created by mr.zhou on 2017/5/6.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFCalendarCalculater : NSObject
-(NSInteger)getWeekdayForDate:(NSDate *)date;
/**
 *  获取总的数据--1970-01-01-2099-12-31
 *
 *  @return 数量
 */
-(NSInteger)calculateMonthCount ;
/**
 *  计算总共多少周
 *
 *  @return 数量
 */
-(NSInteger)calculaterWeeksCount ;
/**
 *  计算下个月-上个月的今天
 *
 *  @param month 从本月起第几个月
 *  @param date  从哪天开始计算
 *
 *  @return 上个月,下个月的当天
 */
-(NSDate *)getNextMonthDayWithMonth:(NSInteger)month Date:(NSDate *)date ;
/**
 *  计算指定日期上周-下周的今天
 *
 *  @param days 间隔多少天
 *  @param date 指定提起
 *
 *  @return 获取的日期
 */
-(NSDate *)getNextWeekdayWithDays:(NSInteger)days Date:(NSDate *)date ;

/**
 *  指定日期是多少组(week分组)
 *
 *  @param date 指定日期
 *
 *  @return 组数
 */
-(NSInteger)getNumberOfWeekSectionWithDate:(NSDate *)date ;

/**
 *  指定日期是多少组-(month分组)
 *
 *  @param date 指定日期
 *
 *  @return 多少组
 */
-(NSInteger)getNumberOfMonthSectionWithDate:(NSDate *)date;
/**
 *  当月第一天是周几
 *
 *  @param date 指定日期
 *
 *  @return 周几----周日为1
 */
-(NSInteger)getFirstDayWeekdayWithDate:(NSDate *)date;
/**
 *  获取当月第一天
 *
 *  @param date 指定日期
 *
 *  @return 第一天的日期
 */
-(NSDate *)getFirstDayWithDate:(NSDate *)date;
/**
 *  获取本周的第一天的日期
 *
 *  @param date 指定日期
 *
 *  @return 第一天日期
 */
-(NSDate *)getFirstDayOfWeekWithDate:(NSDate *)date ;
/**
 *  获取指定日期位于组视图的第几个index
 *
 *  @param date 指定日期
 *
 *  @return index
 */
-(NSInteger)getIndexInMonthWithDate:(NSDate *)date;
/**
 *  获取当月多少天
 *
 *  @param date 指定日期
 *
 *  @return 天数
 */
-(NSInteger)getDaysCountOfMonthWithDate:(NSDate *)date;
/**
 *  获取本周所有日期
 */
-(NSArray *)getAllWeekdaysForDate:(NSDate *)date;
@end

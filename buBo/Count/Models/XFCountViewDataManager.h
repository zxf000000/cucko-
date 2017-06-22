//
//  XFCountViewDataManager.h
//  buBo
//
//  Created by mr.zhou on 2017/5/16.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFCountViewDataManager : NSObject
/**
 *  获取周一到周五的时间段
 *
 *  @return 时间段---NSDictionary
 */
-(NSArray *)getWeekdayTimeQuantum;

+(instancetype)shareManager;
/**
 *  获取最近12个月的shuju
 *
 *  @param date 指定日期
 *
 *  @return 数据的数组
 */
-(NSArray *)getMonthsDataWithDate:(NSDate *)date;

/**
 *  获取指定日期本周的数据
 *
 *  @param date 按指定日期
 *
 *  @return 每天的s
 */
-(NSArray *)getWeekDataFromDate:(NSDate *)date;
/**
 *  获取指定日期本周的数据
 *
 *  @param date 指定日期
 *
 *  @return 时间(s)
 */
-(NSInteger)getWeekDataWithDate:(NSDate *)date;

/**
 *  获取指定日期本月所有时间
 *
 *
 *  @param date                指定日期
 *
 *  @return 时间(s)
 */
-(NSInteger)getMonthDataWithDate:(NSDate *)date;

/**
 *  获取每天的times
 *
 *  @return 日期+times
 */
-(NSDictionary *)everydayTimes;


/**
 *  // 获取周一到周日的总数据
 *
 *  @return 每天的总数据
 */
-(NSArray *)getWeekdayTimeData;

// 计算坚持的天数----这个天数为有记录的时间
-(NSInteger)getInsistDays;
/**
 *  // 计算总时间
 
 *
 *  @return 所有坚持的时间(s)
*/
-(NSInteger) getAllinsistSeconds;
/**
 *  指定日期最近八周的数据
 *
 *  @param date 指定日期
 */
-(NSArray *)getWeeksDataWithDate:(NSDate *)date;

@end

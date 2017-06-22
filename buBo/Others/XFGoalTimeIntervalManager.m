//
//  XFGoalTimeIntervalManager.m
//  buBo
//
//  Created by mr.zhou on 2017/5/4.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFGoalTimeIntervalManager.h"
#import "Goal+CoreDataClass.h"
#import "AppDelegate.h"

@implementation XFGoalTimeIntervalManager

+(void)addBeginTimeWithGoal:(Goal *)goal time:(NSDate *)time {
    
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:goal.beginAndEnd options:NSJSONReadingMutableContainers error:nil];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";

    NSString *beginTime = [formatter stringFromDate:time];
    
    [dic setObject:@"0" forKey:beginTime];
    
    goal.beginAndEnd = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate saveContext];
}

+(void)addEndTimeWithGoal:(Goal *)goal time:(NSDate *)time {

    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:goal.beginAndEnd options:NSJSONReadingMutableContainers error:nil];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    
    
    formatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
    // 需要判断开始时间是哪一天,不是同一天,需要增加时间
    __block NSString *endTime = [formatter stringFromDate:time];
    
    NSInteger todayMonth = [[endTime substringWithRange:NSMakeRange(6, 2)] integerValue];
    
    NSInteger todayDay = [[endTime substringWithRange:NSMakeRange(9, 2)] integerValue];
    
    __block NSInteger startMonth = 0;
    __block NSInteger startDay = 0;
    
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([obj isEqualToString:@"0"]) {
            // 判断日期
            // 是今天的话直接添加结束时间
            
            if ([[endTime substringToIndex:10] isEqualToString:[key substringToIndex:10]]) {
            
                
                [dic setObject:endTime forKey:key];
                
                
                NSLog(@"%@----%@",endTime,key);

            
            } else {
            // 不是今天的话
                //计算时间差
                // 获取今天的月日和开始时间的月日
                startMonth = [[key substringWithRange:NSMakeRange(6, 2)] integerValue];
                
                startDay = [[key substringWithRange:NSMakeRange(9, 2)] integerValue];
                // 是不是同一个月
                if (startMonth == todayMonth) {
                    
                    // 相差几天
                    for (NSInteger i = 0; i<= todayDay - startDay;i++) {
                        // 为当天增加结束时间24:00
                        if (i == 0) {
                        
                            NSString *previousEndtime = [[key substringToIndex:10] stringByAppendingString:@"-24-00-00"];
                            // 添加数据
                            [dic setObject:previousEndtime forKey:key];
                            
                        } else if (i < todayDay - startDay){
                        
                            // 为之后相差的每天添加24小时的时间
                            // 获取日期
                            NSString *theDay = [NSString stringWithFormat:@"%@%zd",[key substringToIndex:9],startDay + i];
                            // 添加这个日期的数据
                            [dic setObject:[NSString stringWithFormat:@"%@%@",theDay,@"00-00-00"] forKey:[NSString stringWithFormat:@"%@%@",theDay,@"24-00-00"]];
                        } else if (i == todayDay-startDay) {
                        
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            
                            formatter.dateFormat = @"yyyy-MM-dd";
                            
                            NSString *todayStr = [formatter stringFromDate:[NSDate date]];
                            
                            // 添加数据
                            [dic setObject:endTime forKey:[NSString stringWithFormat:@"%@%@",todayStr,@"-00-00-00"]];
                            
                        
                        }
                    
                    }
                
                }
                
            }
        }
        
    }];
    // 保存属性
    goal.beginAndEnd = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [appDelegate saveContext];
}

@end

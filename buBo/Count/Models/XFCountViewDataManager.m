//
//  XFCountViewDataManager.m
//  buBo
//
//  Created by mr.zhou on 2017/5/16.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFCountViewDataManager.h"
#import "XFTopCalenderViewModel.h"
#import "AppDelegate.h"
#import "XFCalendarCalculater.h"
#import "NSDateFormatter+XFDateFormatter.h"
#import "Goal+CoreDataClass.h"

@interface XFCountViewDataManager ()

@property (nonatomic,strong) AppDelegate *appDelegate;

@property (nonatomic,strong) XFCalendarCalculater *calculater;

@end

@implementation XFCountViewDataManager

+(instancetype)shareManager {

    static dispatch_once_t onceToken;
    static XFCountViewDataManager *manager;
    dispatch_once(&onceToken, ^{
        
        manager = [[XFCountViewDataManager alloc] init];
        
        
    });
    return manager;
}

-(instancetype)init {

    if (self = [super init]) {
    
        _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        _calculater = [[XFCalendarCalculater alloc] init];
    
    }
    return self;
}

// 获取周一到周五每天的时间段
-(NSArray *)getWeekdayTimeQuantum {

    // 获取所有的时间段
    NSArray *times = [self getAllTimesData];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    
    NSMutableDictionary *monTimes = [NSMutableDictionary dictionary];
    NSMutableDictionary *tueTimes = [NSMutableDictionary dictionary];
    NSMutableDictionary *wenTimes = [NSMutableDictionary dictionary];
    NSMutableDictionary *thuTimes = [NSMutableDictionary dictionary];
    NSMutableDictionary *friTimes = [NSMutableDictionary dictionary];
    NSMutableDictionary *satTimes = [NSMutableDictionary dictionary];
    NSMutableDictionary *sunTimes = [NSMutableDictionary dictionary];
    
    
    for (NSDictionary *timeDic in times) {
    
        [timeDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            NSDate *beginTime = [[NSDateFormatter minuteDateFormatter] dateFromString:key];
            
            switch ([calendar component:(NSCalendarUnitWeekday) fromDate:beginTime]) {
                // 周日
                case 1:
                    
                    [sunTimes setObject:obj forKey:key];
                    
                    break;
                case 2:
                    [monTimes setObject:obj forKey:key];

                    break;
                case 3:
                    [tueTimes setObject:obj forKey:key];

                    break;
                case 4:
                    [wenTimes setObject:obj forKey:key];

                    break;
                case 5:
                    [thuTimes setObject:obj forKey:key];

                    break;
                case 6:
                    [friTimes setObject:obj forKey:key];

                    break;
                case 7:
                    [satTimes setObject:obj forKey:key];

                    break;
                default:
                    
                    break;
            
            }
            
            
            
        }];
    
    }
    
    NSMutableArray *timesArray = [NSMutableArray array];
    
    [timesArray addObject:sunTimes];
    [timesArray addObject:monTimes];
    [timesArray addObject:tueTimes];
    [timesArray addObject:wenTimes];
    [timesArray addObject:thuTimes];
    [timesArray addObject:friTimes];
    [timesArray addObject:satTimes];
    
    return timesArray.copy;

}

// 获取指定日期本周的数据
-(NSArray *)getWeekDataFromDate:(NSDate *)date {

    NSDictionary *times = [self everydayTimes];
    
    // 获取本周第一天日期
    
    NSDate *firstDate = [self.calculater getFirstDayOfWeekWithDate:date];
    
    
    NSMutableArray *weekArr = [NSMutableArray array];
    
    for (NSInteger i = 0 ; i < 7 ;i++) {
    
        NSDate *weekDate = [firstDate dateByAddingTimeInterval:60*60*24*i];
        
        [weekArr addObject:[[NSDateFormatter dayDateFormatter] stringFromDate:weekDate]];
    
    }
    
    // 创建时间数组
    __block NSMutableArray *secondsArray = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    
       
    for (NSInteger i = 0 ; i < weekArr.count ;i++) {
        
        [times enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            
            
                if ([key isEqualToString:weekArr[i]]) {
                
                    
                    secondsArray[i] = obj;
                    
                }
            
        }];

    }
    
    return secondsArray.copy;
}
// 获取指定日期最近十二个月的数据
-(NSArray *)getMonthsDataWithDate:(NSDate *)date {


    // 获取每个月的当天\

    NSMutableArray *monthsData = [NSMutableArray array];
    for (NSInteger i = 11; i >= 0;i --) {
    
        NSDate *tempDate = [self.calculater getNextMonthDayWithMonth:-i Date:date];
    
        // 获取当月的数据
        NSInteger monthSeconds = [self getMonthDataWithDate:tempDate];
    
        [monthsData addObject:[NSString stringWithFormat:@"%zd",monthSeconds]];
        
    }

    return monthsData.copy; 

}

// 获取指定日期最近八周的数据
-(NSArray *)getWeeksDataWithDate:(NSDate *)date {
    
    // 获取每周的当天
    
    NSMutableArray *weekdataArr = [NSMutableArray array];
    
    for (NSInteger i = 7 ; i >=0 ; i--) {
    
        NSDate *tempDate = [self.calculater getNextWeekdayWithDays:-7*i Date:date];

        // 获取当周的数据
        NSInteger weekSeconds = [self getWeekDataWithDate:tempDate];
        
        [weekdataArr addObject:[NSString stringWithFormat:@"%zd",weekSeconds]];
        
    }
    
    // 获取每周的总数据

    
    return weekdataArr.copy;
}

// 获取指定日期本周的数据
-(NSInteger)getWeekDataWithDate:(NSDate *)date {

    // 获取所有数据
    NSDictionary *times = [self everydayTimes];
    
    // 获取本周第一天
    [self.calculater getFirstDayOfWeekWithDate:date];
    
    // 获取本周所有日期
    NSArray *weekdays = [self.calculater getAllWeekdaysForDate:date];
    
    NSMutableArray *weekdayStrs = [NSMutableArray array];
    
    for ( NSInteger i = 0; i<weekdays.count; i++) {
        
        [weekdayStrs addObject:[[NSDateFormatter dayDateFormatter] stringFromDate:weekdays[i]]];
    }
    
    __block NSInteger seconds = 0;
    
    [times enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        

        if ([weekdayStrs containsObject:key]) {
        
            seconds += [obj integerValue];
        
        }
        
    }];
    
    
    return seconds;
}


// 获取指定日期本月的数据
-(NSInteger)getMonthDataWithDate:(NSDate *)date {

    // 获取所有数据
    NSDictionary *times = [self everydayTimes];
    
    // 获取本月第一天
    [self.calculater getFirstDayWithDate:date];
    
    //获取本月所有日期
    NSArray *dateArr = [XFTopCalenderViewModel modelsWithDate:date];
    
    __block NSInteger seconds = 0;
    
    // 获取本月所有数据之和
    [times enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
       
        if ([dateArr containsObject:key]) {
        
            seconds += [obj integerValue];
        
        }
        
    }];
    
    
    return seconds;

}
// 获取每天的times
-(NSDictionary *)everydayTimes {

    NSArray *times = [self getAllTimesData];
    
    __block NSMutableArray *alldays = [NSMutableArray array];
    
    __block NSMutableDictionary *allSeconds = [NSMutableDictionary dictionary];
    
    for (NSDictionary *timeDic in times) {
        
        [timeDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            NSDate *beginTime = [[NSDateFormatter minuteDateFormatter] dateFromString:key];
            
            NSDate *endTime = [[NSDateFormatter minuteDateFormatter] dateFromString:obj];
            
            NSString *day = [key substringToIndex:10];
            // 计算时间差
            NSInteger second = [endTime timeIntervalSinceDate:beginTime];
           // 是否已经有当天的记录
            if ([alldays containsObject:day]) {

                // 添加到字典
                // 获取之前累计的时间
                NSInteger oldSeconds = [[allSeconds objectForKey:day] integerValue];
                // 相加之后添加到字典
                [allSeconds setObject:[NSString stringWithFormat:@"%zd",second+oldSeconds] forKey:day];
                
            
            } else {
            
                // 不包含的话.直接添加到字典
                [allSeconds setObject:[NSString stringWithFormat:@"%zd",second] forKey:day];
                
                [alldays addObject:day];
            
            }
            
        }];
        
    }

    return allSeconds;


}


// 获取周一到周日的总数据
-(NSArray *)getWeekdayTimeData {

    NSArray *times = [self getAllTimesData];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    __block NSInteger monSeconds = 0;
    __block NSInteger tueSeconds = 0;
    __block NSInteger wenSeconds = 0;
    __block NSInteger thuSeconds = 0;
    __block NSInteger friSeconds = 0;
    __block NSInteger satSeconds = 0;
    __block NSInteger sunSeconds = 0;
    
    for (NSDictionary *timeDic in times) {
        
        [timeDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
           
            NSDate *beginTime = [[NSDateFormatter minuteDateFormatter] dateFromString:key];
            
            NSDate *endTime = [[NSDateFormatter minuteDateFormatter] dateFromString:obj];
            
            switch ([calendar component:(NSCalendarUnitWeekday) fromDate:beginTime]) {
                // 周日
                case 1:
                    sunSeconds += [endTime timeIntervalSinceDate:beginTime];
                    
                    break;
                // 周一
                case 2:
                    monSeconds += [endTime timeIntervalSinceDate:beginTime];
                    
                    break;
                // 周二
                case 3:
                    tueSeconds += [endTime timeIntervalSinceDate:beginTime];
                    
                    break;
                // 周三
                case 4:
                    wenSeconds += [endTime timeIntervalSinceDate:beginTime];
                    
                    break;
                // 周四
                case 5:
                    thuSeconds += [endTime timeIntervalSinceDate:beginTime];
                    
                    break;
                // 周五
                case 6:
                    friSeconds += [endTime timeIntervalSinceDate:beginTime];
                    
                    break;
                // 周六
                case 7:
                    satSeconds += [endTime timeIntervalSinceDate:beginTime];
                    
                    break;
                    
                default:
                    break;
            }
            
            
        }];
        
    }


    NSMutableArray *weekdaySecondsArr = [NSMutableArray array];
    
    [weekdaySecondsArr addObject:[NSString stringWithFormat:@"%zd",sunSeconds]];
    [weekdaySecondsArr addObject:[NSString stringWithFormat:@"%zd",monSeconds]];
    [weekdaySecondsArr addObject:[NSString stringWithFormat:@"%zd",tueSeconds]];
    [weekdaySecondsArr addObject:[NSString stringWithFormat:@"%zd",wenSeconds]];
    [weekdaySecondsArr addObject:[NSString stringWithFormat:@"%zd",thuSeconds]];
    [weekdaySecondsArr addObject:[NSString stringWithFormat:@"%zd",friSeconds]];
    [weekdaySecondsArr addObject:[NSString stringWithFormat:@"%zd",satSeconds]];

    return weekdaySecondsArr.copy;
}

// 计算坚持的天数----这个天数为有记录的时间
-(NSInteger)getInsistDays {
    // 所有目标中的时间数据
    NSArray *times = [self getAllTimesData];
    
    __block NSMutableArray *days = [NSMutableArray array];
    
    for (NSDictionary *timeDic in times) {
        
        [timeDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
           
            NSString *day = [key substringToIndex:10];
            
            if (![days containsObject:day]) {
                
                // 查询出来不重复的日期添加到数组
                [days addObject:day];
            
            }
            
        }];
        
    }
    
    return days.count;

}

// 计算总时间
-(NSInteger) getAllinsistSeconds {
    
    NSArray *times = [self getAllTimesData];
    
    __block NSDate *beginTime = nil;
    
    __block NSDate *endTime = nil;
    
    __block NSInteger totalSeconds = 0;
    
    for (NSDictionary *timeDic in times) {
        
        [timeDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            beginTime = [[NSDateFormatter minuteDateFormatter] dateFromString:key];
            
            endTime = [[NSDateFormatter minuteDateFormatter] dateFromString:obj];
        
            
            totalSeconds += [endTime timeIntervalSinceDate:beginTime];
                        
        }];
        
    }

    return totalSeconds;

}

-(NSArray *)getAllTimesData {

    NSArray *goals = [self getAllGoals];
    
    __block NSMutableArray *times = [NSMutableArray array];
    
    for (Goal *goal in goals) {
    
        NSDictionary *timeDic = [NSJSONSerialization JSONObjectWithData:goal.beginAndEnd options:NSJSONReadingMutableContainers error:nil];
        
        if (timeDic.count > 0) {
        
            [timeDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                [times addObject:[NSDictionary dictionaryWithObject:obj forKey:key]];
                
            }];
        
        }
        

        
    
    
    }
    // 所有的开始结束的时间
    return times.copy;

}

-(NSArray *)getAllGoals {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Goal" inManagedObjectContext:self.appDelegate.persistentContainer.viewContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity = entity;
    
    NSArray *result = [self.appDelegate.persistentContainer.viewContext executeFetchRequest:request error:nil];
    
    
    return result;

}

@end

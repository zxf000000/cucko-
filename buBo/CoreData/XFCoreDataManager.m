//
//  XFCoreDataManager.m
//  buBo
//
//  Created by mr.zhou on 2017/4/28.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFCoreDataManager.h"
#import "NSDateFormatter+XFDateFormatter.h"

@implementation XFCoreDataManager
+(instancetype)shareManager {
    
    static XFCoreDataManager *manage = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manage = [[self alloc] init];
    });
    return manage;
}

-(void)fetchData {

    self.appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Goal" inManagedObjectContext:self.appdelegate.persistentContainer.viewContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity = entity;
    
    NSArray *result = [self.appdelegate.persistentContainer.viewContext executeFetchRequest:request error:nil];
    
    self.goals = result;

}

- (void)changeGoalStatusWithStatus:(NSInteger)status Goal:(Goal *)goal{

    self.appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Goal" inManagedObjectContext:self.appdelegate.persistentContainer.viewContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity = entity;
    
    NSArray *result = [self.appdelegate.persistentContainer.viewContext executeFetchRequest:request error:nil];
    
    for (Goal *goalInData in result) {
    
        if (goalInData == goal) {
        
            goalInData.state = status;
            
            [self.appdelegate saveContext];
        
        }
    
    
    }

}

- (NSArray *)getLastSevenDaysTimesWithGoal:(Goal *)goal {
    // 获取时间字典
    NSDictionary *timesDic = [NSJSONSerialization JSONObjectWithData:goal.beginAndEnd options:NSJSONReadingMutableContainers error:nil];
    
    // 获取最近7天的日期
    NSMutableArray *dateArray = [NSMutableArray array];
    
    for (NSInteger i = 6; i>=0; i--) {
        
        NSDateFormatter *formatter = [NSDateFormatter dayDateFormatter];
        
        NSString *dateStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-i*3600*24]];
        
        [dateArray addObject:dateStr];
        
    }
    
    // 存放7天数据的数组
    NSMutableArray *timeArray = [NSMutableArray array];
    
    NSInteger firstTime = 0;
    
    NSInteger secondTime = 0;
    
    NSInteger thirdTime = 0;
    NSInteger fourthTime = 0;
    NSInteger fifthTime = 0;
    NSInteger sixthTime = 0;
    NSInteger sevenTime = 0;

    
    for(NSString *dateStr in [timesDic allKeys]) {
        
        NSString *date = [dateStr substringToIndex:10];
        
        if ([date isEqualToString:dateArray[0]]) {
            
            NSDate *beginTime = [[NSDateFormatter minuteDateFormatter] dateFromString:dateStr];
            
            NSDate *endTime = [[NSDateFormatter minuteDateFormatter] dateFromString:[timesDic objectForKey:dateStr]];
            
            NSTimeInterval timeInterval = [endTime timeIntervalSinceDate:beginTime];
            
            firstTime += (NSInteger)timeInterval;
            
        }
        
        if ([date isEqualToString:dateArray[1]]) {
            
            NSDate *beginTime = [[NSDateFormatter minuteDateFormatter] dateFromString:dateStr];
            
            NSDate *endTime = [[NSDateFormatter minuteDateFormatter] dateFromString:[timesDic objectForKey:dateStr]];
            
            NSTimeInterval timeInterval = [endTime timeIntervalSinceDate:beginTime];
            
            secondTime += (NSInteger)timeInterval;
            
        }
        
        if ([date isEqualToString:dateArray[2]]) {
            
            NSDate *beginTime = [[NSDateFormatter minuteDateFormatter] dateFromString:dateStr];
            
            NSDate *endTime = [[NSDateFormatter minuteDateFormatter] dateFromString:[timesDic objectForKey:dateStr]];
            
            NSTimeInterval timeInterval = [endTime timeIntervalSinceDate:beginTime];
            
            thirdTime += (NSInteger)timeInterval;
            
        }
        
        if ([date isEqualToString:dateArray[3]]) {
            
            NSDate *beginTime = [[NSDateFormatter minuteDateFormatter] dateFromString:dateStr];
            
            NSDate *endTime = [[NSDateFormatter minuteDateFormatter] dateFromString:[timesDic objectForKey:dateStr]];
            
            NSTimeInterval timeInterval = [endTime timeIntervalSinceDate:beginTime];
            
            fourthTime += (NSInteger)timeInterval;
            
        }
        
        if ([date isEqualToString:dateArray[4]]) {
            
            NSDate *beginTime = [[NSDateFormatter minuteDateFormatter] dateFromString:dateStr];
            
            NSDate *endTime = [[NSDateFormatter minuteDateFormatter] dateFromString:[timesDic objectForKey:dateStr]];
            
            NSTimeInterval timeInterval = [endTime timeIntervalSinceDate:beginTime];
            
            fifthTime += (NSInteger)timeInterval;
            
        }
        
        if ([date isEqualToString:dateArray[5]]) {
            
            NSDate *beginTime = [[NSDateFormatter minuteDateFormatter] dateFromString:dateStr];
            
            NSDate *endTime = [[NSDateFormatter minuteDateFormatter] dateFromString:[timesDic objectForKey:dateStr]];
            
            NSTimeInterval timeInterval = [endTime timeIntervalSinceDate:beginTime];
            
            sixthTime += (NSInteger)timeInterval;
            
        }
        
        if ([date isEqualToString:dateArray[6]]) {
            
            NSDate *beginTime = [[NSDateFormatter minuteDateFormatter] dateFromString:dateStr];
            
            NSDate *endTime = [[NSDateFormatter minuteDateFormatter] dateFromString:[timesDic objectForKey:dateStr]];
            
            NSTimeInterval timeInterval = [endTime timeIntervalSinceDate:beginTime];
            
            sevenTime += (NSInteger)timeInterval;
            
        }
    
    }
    
    [timeArray addObject:[NSString stringWithFormat:@"%zd",firstTime]];
    
    [timeArray addObject:[NSString stringWithFormat:@"%zd",secondTime]];
    [timeArray addObject:[NSString stringWithFormat:@"%zd",thirdTime]];
    [timeArray addObject:[NSString stringWithFormat:@"%zd",fourthTime]];
    [timeArray addObject:[NSString stringWithFormat:@"%zd",fifthTime]];
    [timeArray addObject:[NSString stringWithFormat:@"%zd",sixthTime]];
    [timeArray addObject:[NSString stringWithFormat:@"%zd",sevenTime]];

    
    return  timeArray.copy;

}

-(NSInteger )calculatorGoalsAllTimeWithGoal:(Goal *)goal {
    
    __block NSInteger allSeconds = 0;
    
    NSLog(@"%@--",goal);
    
    NSDictionary *timesDic = [NSJSONSerialization JSONObjectWithData:goal.beginAndEnd options:(NSJSONReadingMutableLeaves) error:nil];
            
    [timesDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
        NSTimeInterval timeInterval = [obj timeIntervalSinceDate:key];
                
        allSeconds += (NSInteger)timeInterval;
                
    }];
    
    return allSeconds;

}

-(NSArray *)allGoals {

    [self fetchData];
    
    return self.goals;

}

- (void)updateDataWithPropertyName:(NSString *)propertyName Value:(CGFloat)hours {
    // 创建要保存的字典
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *today = [formatter stringFromDate:[NSDate date]];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%f",hours] forKey:today];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Goal"];
    
    request.entity = [NSEntityDescription entityForName:@"Goal" inManagedObjectContext:self.appdelegate.persistentContainer.viewContext];
    
    request.predicate = [NSPredicate predicateWithFormat:@"name like %@",propertyName];
    
    NSError *error = nil;
    
    NSArray *result = [self.appdelegate.persistentContainer.viewContext executeFetchRequest:request error:&error];
    
    Goal *goal = result[0];
    // 获取模型的属性
    NSData *timesData = (NSData *)goal.times;
    
    NSMutableDictionary *timesDic = [NSJSONSerialization JSONObjectWithData:timesData options:NSJSONReadingMutableContainers error:nil];
    
    // 数据库目标中所有的key
    NSArray *keys = [timesDic allKeys];

    // 如果为空
    if (keys.count == 0 | timesDic == nil) {
        
        // 如果没有记录,添加进去
        // 转换回NSData
        
        NSData *newTimeData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        
        goal.times = newTimeData;
        
        [self.appdelegate saveContext];
        
    } else {
        
        
        if ([keys containsObject:today]) {
        
            NSString *hourStr = [timesDic valueForKey:today];
            
            CGFloat hour = [hourStr floatValue];
            
            hour =hour+hours;
            
            [timesDic setObject:[NSString stringWithFormat:@"%f",hour] forKey:today];
            // 添加进去
            NSData *newTimeData = [NSJSONSerialization dataWithJSONObject:timesDic options:NSJSONWritingPrettyPrinted error:nil];
            
            goal.times = newTimeData;
            
            [self.appdelegate saveContext];

        } else {
        
            // 如果当天没有记录,添加进去
            [timesDic setObject:[NSString stringWithFormat:@"%f",hours] forKey:today];
            
            NSData *newTimeData = [NSJSONSerialization dataWithJSONObject:timesDic options:NSJSONWritingPrettyPrinted error:nil];
            
            goal.times = newTimeData;
            
            [self.appdelegate saveContext];
        
        }
        
    }

}
// 获取首页时间条数据---当天所有投入时间综合
-(CGFloat)getIndexTimeViewData {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter dayDateFormatter];
    
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDateFormatter *minFormatter = [NSDateFormatter minuteDateFormatter];
        
    [self fetchData];
    
    // 当天的时间总数
    __block NSInteger second = 0;
    
    for (Goal *goal in self.goals) {
                
        if (goal.isWaste == NO) {
            
            NSData *hoursData = goal.beginAndEnd;
            
            NSDictionary *hoursDic = [NSJSONSerialization JSONObjectWithData:hoursData options:NSJSONReadingMutableContainers error:nil];
            
            [hoursDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
               
                // 获取今天的时间
                if ([[key substringToIndex:10] isEqualToString:dateStr]) {
                    
                    // 计算时间差
                    // 获取两个时间的date
                    NSDate *startTime = [minFormatter dateFromString:key];
                    NSDate *endTime = [minFormatter dateFromString:obj];
                    
                    NSInteger timeInterval = [endTime timeIntervalSinceDate:startTime];
                    // 所有秒数相加
                    second += timeInterval;
                    
                }
                
            }];
        
        }
    }
    
    CGFloat hours = second/3600.f;

    return hours;
}

@end

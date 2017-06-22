//
//  XFDayDataModel.m
//  buBo
//
//  Created by mr.zhou on 2017/5/12.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFDayDataModel.h"
#import "Goal+CoreDataClass.h"
#import "AppDelegate.h"
#import "NSDateFormatter+XFDateFormatter.h"

@implementation XFDayDataModel

-(instancetype)initWithName:(NSString *)name BeginAndEndTime:(NSDictionary *)beginEndTimes Color:(UIColor *)color Image:(UIImage *)image TotalTime:(NSString *)totalTimes {
    
    if (self = [super init]) {
    
        _name = name;
        _beginAndEndTime = beginEndTimes;
        _totalTime = totalTimes;
        _color = color;
        _image = image;
        
        
    }
    return self;

}

+(instancetype)modelWithName:(NSString *)name BeginAndEndTime:(NSDictionary *)beginEndTimes Color:(UIColor *)color Image:(UIImage *)image TotalTime:(NSString *)totalTimes {

    return [[XFDayDataModel alloc] initWithName:name BeginAndEndTime:beginEndTimes Color:color Image:image TotalTime:totalTimes];

}

+(NSArray *)modelsWithDate:(NSString *)date {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Goal" inManagedObjectContext:delegate.persistentContainer.viewContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity = entity;
    
    NSArray *result = [delegate.persistentContainer.viewContext executeFetchRequest:request error:nil];
    
    // 符合条件的结果集合
    __block NSMutableArray *arr = [NSMutableArray array];
    
    for (Goal *goal in result) {
    
        NSDictionary *beginAndEndTimeDic = [NSJSONSerialization JSONObjectWithData:goal.beginAndEnd options:NSJSONReadingMutableContainers error:nil];
        
        
        [beginAndEndTimeDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {

            NSString *day = [key substringToIndex:10];
            
            if ([day isEqualToString:date]) {
            
                //获取开始时间
                NSDate *startTime = [[NSDateFormatter minuteDateFormatter] dateFromString:key];;
                NSDate *endTime = [[NSDateFormatter minuteDateFormatter] dateFromString:obj];;
                // 获取总时间
                NSTimeInterval timeInterval = [endTime timeIntervalSinceDate:startTime];
                NSInteger hour = (NSInteger)timeInterval/3600;
                NSInteger min = ((NSInteger )timeInterval%3600)/60;
//                NSInteger second = ((NSInteger)timeInterval%3600)%60;
                //创建模型
                XFDayDataModel *model = [XFDayDataModel modelWithName:goal.name BeginAndEndTime:[NSDictionary dictionaryWithObject:obj forKey:key] Color:(UIColor *)goal.color Image:(UIImage *)goal.pic TotalTime:[NSString stringWithFormat:@"%zd时%zd分",hour,min]];
                
                [arr addObject:model];
                
                
            }
            
        }];
    
    }
    
    
    return arr.copy;
}

@end

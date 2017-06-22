//
//  XFAllDataModel.m
//  buBo
//
//  Created by mr.zhou on 2017/5/3.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFAllDataModel.h"
#import "XFGreatChartsDataManager.h"

@implementation XFAllDataModel

+(NSArray *)modelsWithDate:(NSDate *)date Goal:(Goal *)goal{
    
    XFGreatChartsDataManager *manager = [XFGreatChartsDataManager shareManager];
    
    NSArray *timesArray = [manager getMonthDataWithDate:date Goal:goal];
    
    NSMutableArray *modelArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i < timesArray.count; i++) {
        
        XFAllDataModel *model = [self modelWithName:manager.monthArr[timesArray.count -1 - i] time:timesArray[i]];
        [modelArr addObject:model];
        
    }
    return modelArr.copy;
}

+(instancetype)modelWithName:(NSString *)day time:(NSString *)time {

    return [[self alloc] initWithName:day time:time];

}

-(instancetype)initWithName:(NSString *)day time:(NSString *)time {

    if (self = [super init]) {
        
        _day = day;
        _time = time;
    }
    return self;
}


@end

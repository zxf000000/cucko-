//
//  XFBestTimeDataModel.m
//  buBo
//
//  Created by mr.zhou on 2017/6/2.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFBestTimeDataModel.h"
#import "XFCountViewDataManager.h"
@implementation XFBestTimeDataModel

-(instancetype)initWithWeekday:(NSString *)weekday AndPercent:(CGFloat)percent {

    if (self = [super init]) {
    
        _weekday = weekday;
        
        _percent = percent;
    
    }
    return self;
}

+(instancetype)modelWithWeekday:(NSString *)weekday AndPercent:(CGFloat)percent {

    return [[XFBestTimeDataModel alloc] initWithWeekday:weekday AndPercent:percent];

}

+(NSArray *)allData {

    NSArray *allDatas = [[XFCountViewDataManager shareManager] getWeekdayTimeData];
    
    NSArray *weekdays = [NSArray arrayWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    
    CGFloat totalSeconds = 0;
    
    for (NSInteger i = 0 ; i < allDatas.count ;i ++) {
    
        NSInteger second = [allDatas[i] integerValue];
        
        totalSeconds += (CGFloat)second;
    
    }
    
    NSMutableArray *models = [NSMutableArray array];
    
    for (NSInteger i = 0 ; i < allDatas.count;i++) {
    
        NSInteger second = [allDatas[i] integerValue];
        
        CGFloat percent = second/totalSeconds;
        
        XFBestTimeDataModel *model = [XFBestTimeDataModel modelWithWeekday:weekdays[i] AndPercent:second == 0?0:percent];
        
        [models addObject:model];
        
    }
    
    return models;
    
}



@end

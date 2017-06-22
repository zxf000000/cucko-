//
//  XFCountViewChartDateFormatter.m
//  buBo
//
//  Created by mr.zhou on 2017/5/17.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFCountViewChartDateFormatter.h"

@implementation XFCountViewChartDateFormatter


- (NSString * _Nonnull)stringForValue:(double)value axis:(ChartAxisBase * _Nullable)axis {

    NSArray *array = [NSArray arrayWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    
    
    switch (self.type) {
        case 1:{
            
            return [NSString stringWithFormat:@"%@\n%@",array[(NSInteger)value],[self.dayArray[(NSInteger)value] substringFromIndex:6]];
        
        }
            
            break;
        case 2:{
        
            return [NSString stringWithFormat:@"%@",self.weekArray[(NSInteger)value]];
        }
            
            break;
        case 3:{
        
            return [NSString stringWithFormat:@"%@",self.monthArray[(NSInteger)value]];

        }
            
            break;
        default:
            break;
    }


    return nil;
}



-(instancetype)initWithWeekArray:(NSArray *)weekArray {
    if (self = [super init]) {
    
        _weekArray = weekArray;
        
        _type = 2;
        
    }
    return self;
}
-(instancetype)initWithMonthArray:(NSArray *)monthArray {
    if (self = [super init]) {
        _monthArray = monthArray;
        _type = 3;
        
        
    }
    return self;

}
-(instancetype)initWithDayArray:(NSArray *)dayArray {

    if (self = [super init]) {
        _dayArray = dayArray;
        _type = 1;
        
    }
    return self;


}

@end

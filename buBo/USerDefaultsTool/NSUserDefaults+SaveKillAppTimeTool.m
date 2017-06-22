//
//  NSUserDefaults+SaveKillAppTimeTool.m
//  buBo
//
//  Created by mr.zhou on 2017/6/7.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "NSUserDefaults+SaveKillAppTimeTool.h"

@implementation NSUserDefaults (SaveKillAppTimeTool)

-(void)setStatusWithKey:(NSString *)key AndStatus:(BOOL)status{

    [self setBool:status forKey:key];
}


-(void)changeStatusWithKey:(NSString *)key{

    BOOL status = [self boolForKey:key];
    
    [self setBool:!status forKey:key];
    
    [self synchronize];
    
}

-(void)saveAppKillTimeWithSeconds:(NSInteger)seconds {

    if ([self boolForKey:kBeginStatusKey]) {
        
        [self setObject:[NSDate date] forKey:kDateForKilledKey];
        
        [self setInteger:seconds forKey:kSecondBeforeKilledKey];
        
        [self synchronize];
    }

}

-(NSDate *)getAppKillTime {

    return [self objectForKey:kDateForKilledKey];

}

/**
 *  保存开始时间
 */
-(void)saveBeginTimeWithTime:(NSDate *)beginTime {
    
    [self setObject:beginTime forKey:kTomatoBeginTimeKey];
    
    [self synchronize];
}
/**
 *  保存结束时间
 */
-(void)saveEndTimeWithTime:(NSDate *)endTime {

    [self setObject:endTime forKey:kTomatoEndTimeKey];
    [self synchronize];
}

@end

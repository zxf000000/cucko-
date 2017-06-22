//
//  NSUserDefaults+SaveKillAppTimeTool.h
//  buBo
//
//  Created by mr.zhou on 2017/6/7.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (SaveKillAppTimeTool)
/**
 *  初始化状态
 */
-(void)setStatusWithKey:(NSString *)key AndStatus:(BOOL)status;
/**
 *  更改timer是否正在计时的状态
 *
 *  @param key tomatoIsBegin/goalIsBegin
 */
-(void)changeStatusWithKey:(NSString *)key;
/**
 *  记录app杀死时间
 */
-(void)saveAppKillTimeWithSeconds:(NSInteger)seconds;
/**
 *  读取app杀死时间
 */
-(NSDate *)getAppKillTime;
/**
 *  保存开始时间
 */
-(void)saveBeginTimeWithTime:(NSDate *)beginTime;
/**
 *  保存结束时间
 */
-(void)saveEndTimeWithTime:(NSDate *)endTime;
@end

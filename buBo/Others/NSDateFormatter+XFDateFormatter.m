//
//  NSDateFormatter+XFDateFormatter.m
//  buBo
//
//  Created by mr.zhou on 2017/5/12.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "NSDateFormatter+XFDateFormatter.h"

@implementation NSDateFormatter (XFDateFormatter)

+(instancetype)dayDateFormatter {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd";
    
    return formatter;

}

+(instancetype)minuteDateFormatter {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
    
    return formatter;
    
}

+(instancetype)tomatoDateFormatter {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    return formatter;

}

@end

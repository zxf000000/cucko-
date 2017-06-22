//
//  XFLeftAxisDataFormatter.m
//  buBo
//
//  Created by mr.zhou on 2017/6/3.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFLeftAxisDataFormatter.h"

@implementation XFLeftAxisDataFormatter

- (NSString * _Nonnull)stringForValue:(double)value axis:(ChartAxisBase * _Nullable)axis SWIFT_WARN_UNUSED_RESULT {

    
    if (value <3600) {
    
        NSInteger minute = value/60;

        NSInteger second = value;
        
        return minute == 0?[NSString stringWithFormat:@"%zd sec",second]:[NSString stringWithFormat:@"%zd min",minute];

    
    } else {
    
        NSInteger hour = value/3600;
        
        return hour == 0?@"":[NSString stringWithFormat:@"%zd h",hour];
    
    }

}


@end

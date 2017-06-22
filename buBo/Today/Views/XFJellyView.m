//
//  XFJellyView.m
//  buBo
//
//  Created by mr.zhou on 2017/6/13.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFJellyView.h"

@implementation XFJellyView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    [kNavigationBarColor set];
    
    UIBezierPath *path= [UIBezierPath bezierPath];
    
    [path moveToPoint:(CGPointMake(10, 10))];
    
    

}


@end

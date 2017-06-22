//
//  XFLabel.m
//  buBo
//
//  Created by mr.zhou on 2017/6/9.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFLabel.h"

@implementation XFLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(1, 10, 1, 3))];
    

}


@end

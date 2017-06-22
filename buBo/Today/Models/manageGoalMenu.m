//
//  manageGoalMenu.m
//  buBo
//
//  Created by mr.zhou on 2017/4/20.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "manageGoalMenu.h"

@implementation manageGoalMenu

- (instancetype)initWithText:(NSString *)text Image:(UIImage *)image {
    
    if (self = [super init]) {
        
        _text = text;
        _image = image;
        
    }

    return  self;
}



@end

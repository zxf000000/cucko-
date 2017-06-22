//
//  manageGoalMenu.h
//  buBo
//
//  Created by mr.zhou on 2017/4/20.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface manageGoalMenu : NSObject

@property (nonatomic,copy) NSString *text;

@property (nonatomic,weak) UIImage *image;

- (instancetype)initWithText:(NSString *)text Image:(UIImage *)image;


@end

//
//  XFActionSheetModel.h
//  buBo
//
//  Created by mr.zhou on 2017/6/17.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFActionSheetModel : NSObject

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) UIImage *image;

+(NSArray *)models;

@end

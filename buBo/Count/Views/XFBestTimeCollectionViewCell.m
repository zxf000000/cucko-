//
//  XFBestTimeCollectionViewCell.m
//  buBo
//
//  Created by mr.zhou on 2017/6/2.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFBestTimeCollectionViewCell.h"

@implementation XFBestTimeCollectionViewCell

-(void)setModel:(XFBestTimeDataModel *)model {

    _model = model;
    
    _bgView.layer.cornerRadius = 7;
    
    _bgView.layer.masksToBounds = YES;

    _weekdayLabel.text = _model.weekday;
    
}

@end

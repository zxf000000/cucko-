//
//  XFLookAtRecodeCollectionViewCell.m
//  buBo
//
//  Created by mr.zhou on 2017/5/4.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFLookAtRecodeCollectionViewCell.h"
#import <POP.h>

@implementation XFLookAtRecodeCollectionViewCell

-(void)awakeFromNib {
    
    [super awakeFromNib];
    
    
}

-(void)setDateStr:(NSString *)dateStr {
    
    _dateStr = dateStr;
    _numberLabel.text = [dateStr substringFromIndex:8];
    
//    _numberLabel.textColor = [UIColor blackColor];
    
//    _backColorView.layer.cornerRadius = ([UIScreen mainScreen].bounds.size.width/7-30)/2;
//    _backColorView.layer.masksToBounds = YES;
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 30, 30))];
    
    view.backgroundColor = [UIColor grayColor];
    
    self.selectedBackgroundView = view;
    
    view.layer.cornerRadius = kDayCellDimeter/2;

}

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
}



@end

//
//  XFAllDataTableViewCell.m
//  buBo
//
//  Created by mr.zhou on 2017/5/3.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFAllDataTableViewCell.h"
#import <Masonry.h>
@interface XFAllDataTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *hoursColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *hoursView;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorViewWidthConstrains;

@end

@implementation XFAllDataTableViewCell

-(void)setModel:(XFAllDataModel *)model {

    _model = model;
    
    _timeLabel.text = [model.day substringFromIndex:5];
    
    CGFloat hours = [model.time integerValue]/3600.f;
    
    _hoursLabel.text = [model.time floatValue] == 0?@"无记录":[NSString stringWithFormat:@"%.2f h",hours];
    float viewWidth = [self.hoursLabel.text floatValue];
    
    _colorViewWidthConstrains.constant = viewWidth * ([UIScreen mainScreen].bounds.size.width - 80)/10.f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

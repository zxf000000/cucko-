//
//  XFLBigGoalSelectTableViewCell.m
//  buBo
//
//  Created by mr.zhou on 2017/4/26.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFLBigGoalSelectTableViewCell.h"
#import <Masonry.h>

@implementation XFLBigGoalSelectTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        UILabel *label = [[UILabel alloc] init];
        
        _titleLabel = label;
        
        [self.contentView addSubview:_titleLabel];
     
        [self setNeedsUpdateConstraints];
    }
    
    return self;

}
-(void)updateConstraints {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_offset(10);
        make.centerY.mas_offset(0);
        
    }];

    [super updateConstraints];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

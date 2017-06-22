//
//  XFMoreTableViewCell.m
//  buBo
//
//  Created by mr.zhou on 2017/6/18.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMoreTableViewCell.h"

@implementation XFMoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setModel:(XFActionSheetModel *)model {

    _model = model;
    
    _iconView.image = model.image;
    _nameLabel.text = model.title;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

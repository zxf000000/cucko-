//
//  manageGoalTableViewCell.m
//  buBo
//
//  Created by mr.zhou on 2017/4/20.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "manageGoalTableViewCell.h"
#import <Masonry.h>

@implementation manageGoalTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 左边文字button和右边图片button
        UIButton *textButton = [[UIButton alloc] init];
        UIButton *imageButton = [[UIButton alloc] init];
        
        _textButton = textButton;
        _imageButton = imageButton;
        
        [self.contentView addSubview:_textButton];
        [self.contentView addSubview:_imageButton];
        
        [_textButton setTitle:_menu.text forState:(UIControlStateNormal)];
        [_imageButton setBackgroundImage:_menu.image forState:(UIControlStateNormal)];
        
        
        _textButton.backgroundColor = [UIColor blueColor];
        _imageButton.backgroundColor = [UIColor blueColor];
        
        _imageButton.layer.cornerRadius = 15;
        
        [_imageButton addTarget:self action:@selector(onClickImageButton) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_imageButton addTarget:self action:@selector(onClickImageButton) forControlEvents:(UIControlEventTouchUpInside)];

        [self.contentView setBackgroundColor:[UIColor clearColor]];
        
        [self setNeedsUpdateConstraints];
        
    }
    return self;
}

- (void)onClickImageButton {

    [self.delegate manageGoalButtonDelegate:self.imageButton];


}

- (void)setNeedsUpdateConstraints {

    [self.imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_offset(0);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        
    }];
    [self.textButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.imageButton.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.contentView);

        
    }];
    
    [super setNeedsUpdateConstraints];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

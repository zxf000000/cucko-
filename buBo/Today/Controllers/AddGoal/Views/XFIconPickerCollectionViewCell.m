//
//  XFIconPickerCollectionViewCell.m
//  SHadowVIew
//
//  Created by mr.zhou on 2017/4/24.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFIconPickerCollectionViewCell.h"

@interface XFIconPickerCollectionViewCell ()



@end

@implementation XFIconPickerCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
    
        self.backgroundColor = [UIColor colorWithRed:70/255.0 green:177/255.0 blue:227/255.0 alpha:1];
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:(CGRectMake(10, 10, 20, 20))];
        
        _iconView = iconView;
        
        [self.contentView addSubview:iconView];
        
    }
    return self;
}

-(instancetype)init {
    
    if (self = [super init]) {
    
        self.backgroundColor = [UIColor colorWithRed:70 green:177 blue:227 alpha:1];
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:(CGRectMake(10, 10, 40, 40))];
        
        [self.contentView addSubview:iconView];
        
        self.contentView.backgroundColor = [UIColor blueColor];
        
    }
    return self;

}

-(void)awakeFromNib {
    
    [super awakeFromNib];

    self.backgroundColor = [UIColor colorWithRed:70 green:177 blue:227 alpha:1];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:(CGRectMake(5, 5, 20, 20))];
    
    [self.contentView addSubview:iconView];
    
    self.contentView.backgroundColor = [UIColor blueColor];
}

@end

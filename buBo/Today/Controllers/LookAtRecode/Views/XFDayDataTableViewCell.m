//
//  XFDayDataTableViewCell.m
//  buBo
//
//  Created by mr.zhou on 2017/5/12.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFDayDataTableViewCell.h"
#import "Goal+CoreDataClass.h"

@interface XFDayDataTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginLabel;

@property (weak, nonatomic) IBOutlet UIImageView *clockView;
@property (weak, nonatomic) IBOutlet UIImageView *iconColorView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation XFDayDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
    // Initialization code
}

-(void)setModel:(XFDayDataModel *)model {

    _model = model;
    
    __block NSString *startTime = nil;
    __block NSString *endTime = nil;
    
    [_model.beginAndEndTime enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
       
        startTime = key;
        endTime = obj;
        
    }];
    
    _beginLabel.text = [startTime substringWithRange:NSMakeRange(11, 5)];

    // 正在进行的goal还没有保存结束时间
    if (endTime.length>2) {
        
        _endLabel.text = [endTime substringWithRange:NSMakeRange(11, 5)];

        
    } else {
    
        _endLabel.text = @"正在进行";
    }
    
    
    _iconColorView.image = [UIImage imageNamed:@"icon_backGround"];
    
    _iconView.image = _model.image;
    
    _nameLabel.text = _model.name;
    
    _timeLabel.text = _model.totalTime;
    
    _iconColorView.layer.cornerRadius = 40/3;
    
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

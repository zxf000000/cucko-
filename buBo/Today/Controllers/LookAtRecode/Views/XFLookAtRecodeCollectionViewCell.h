//
//  XFLookAtRecodeCollectionViewCell.h
//  buBo
//
//  Created by mr.zhou on 2017/5/4.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface XFLookAtRecodeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UIImageView *dotView;
@property (nonatomic,copy) NSString *dateStr;

//@property (weak, nonatomic) IBOutlet UIView *colorView;


@end

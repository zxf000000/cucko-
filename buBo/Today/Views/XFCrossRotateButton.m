//
//  XFCrossRotateButton.m
//  buBo
//
//  Created by mr.zhou on 2017/6/19.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFCrossRotateButton.h"

@implementation XFCrossRotateButton

-(void)rotate {

    self.isOn = !self.isOn;
    
    if(self.isOn) {
    
        [self rotateOn];
    } else {
        [self totateBack];
    
    }

}

-(void)rotateOn {

    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D trans = CATransform3DMakeRotation(M_PI_4, 0, 0, 1);
    
    anima.toValue = [NSValue valueWithCATransform3D:trans];
    
    anima.removedOnCompletion = NO;
    anima.fillMode = kCAFillModeForwards;
    
    //    sender.layer.transform = trans;
    [self.layer addAnimation:anima forKey:@""];

}

-(void)totateBack {

    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D trans = CATransform3DMakeRotation(0, 0, 0, 1);
    
    anima.toValue = [NSValue valueWithCATransform3D:trans];
    
    anima.removedOnCompletion = NO;
    anima.fillMode = kCAFillModeForwards;
    
    //    sender.layer.transform = trans;
    [self.layer addAnimation:anima forKey:@""];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

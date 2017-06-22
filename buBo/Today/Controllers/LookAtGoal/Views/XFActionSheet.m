//
//  XFActionSheet.m
//  buBo
//
//  Created by mr.zhou on 2017/6/17.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFActionSheet.h"
#import "XFAlertViewTableViewCell.h"
#import "XFMoreTableViewCell.h"
#import "XFActionSheetModel.h"

#define kActionSheetWidth 130
#define kActionSheetHeight 175

#define kSheetX self.buttonFrame.origin.x + self.buttonFrame.size.width - kActionSheetWidth

#define kActionSheetTableViewCellIdentifier @"ActionSheetTableViewCell"

@implementation XFActionSheet

-(instancetype)initWithRightButtonFrame:(CGRect)frame {

    if (self = [super init]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _shadowView = [[UIView alloc] initWithFrame:(CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight))];
        
        _shadowView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.502];
        
        _shadowView.alpha = 0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShadowView)];
        
        [_shadowView addGestureRecognizer:tap];
        
        [[UIApplication sharedApplication].keyWindow addSubview:_shadowView];
        
        _buttonFrame = frame;
        
        CGFloat x = self.buttonFrame.origin.x;
//        CGFloat y = self.buttonFrame.origin.y;
        CGFloat width = self.buttonFrame.size.width;
//        CGFloat height = self.buttonFrame.size.height;
        // 计算alertSheet的frame
        
        CGFloat sheetX  = x + width - kActionSheetWidth;
        
        CGFloat sheetY = 64;
        
        CGFloat pointX = kActionSheetWidth - width/2 - 10;
        CGFloat pointY = 0;
        // 粗略计算三个点
        CGPoint topPoint = CGPointMake(pointX, pointY);
        
        CGPoint leftPoint = CGPointMake(kActionSheetWidth-width - 10, pointY + 15);
        CGPoint rightPoint = CGPointMake(kActionSheetWidth - 10, pointY + 15);

        
        // 两个控制点
        CGFloat radius = 5.f;
        
        CGFloat offset = radius/sqrt(2);
        
        CGPoint leftControlPoint = CGPointMake(topPoint.x - offset, topPoint.y + offset);
        
        CGPoint rightControlPoint = CGPointMake(topPoint.x + offset, leftControlPoint.y);

        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        path.lineJoinStyle = kCGLineJoinRound;
        
        [path moveToPoint:leftPoint];
        
        [path addLineToPoint:leftControlPoint];
        [path addQuadCurveToPoint:rightControlPoint controlPoint:topPoint];
        [path addLineToPoint:rightPoint];

        [path closePath];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        
        shapeLayer.path = path.CGPath;
        
        shapeLayer.lineCap = @"round";
        
        self.frame = CGRectMake(sheetX + kActionSheetWidth + 10, sheetY, 0, 0);
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
//        _topView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kActionSheetWidth, 20))];
        
        _topView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 0, 0))];
        
        _topView.backgroundColor = [UIColor whiteColor];
        
        _topView.layer.mask = shapeLayer;
        
        [self addSubview:_topView];
        
//        _tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, 20, kActionSheetWidth, 120))];
        
        _tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, 0, 0, 0))];

        
        _tableView.backgroundColor = [UIColor blueColor];
        
        [self addSubview:_tableView];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.bounces = NO;
        
        _tableView.layer.cornerRadius = 5;
        
        
    }
    return self;
}

-(void)tapShadowView {
    
    [self.delegate buttonRotateBackDelegte];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(kSheetX + kActionSheetWidth + 10, 64, 0, 0);
        
        self.tableView.frame = CGRectMake(0, 0, 0, 0);
        
        self.shadowView.alpha = 0;
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self.shadowView removeFromSuperview];
        [self removeFromSuperview];
    }];

}

-(void)show {

    CGFloat x = self.buttonFrame.origin.x;
//    CGFloat y = self.buttonFrame.origin.y;
    CGFloat width = self.buttonFrame.size.width;
//    CGFloat height = self.buttonFrame.size.height;
    // 计算alertSheet的frame
    
    CGFloat sheetX  = x + width - kActionSheetWidth + 10;
    
    CGFloat sheetY = 64;
    
    self.shadowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.shadowView.alpha = 1;
        
        _topView.frame = CGRectMake(0, 0, kActionSheetWidth, 15);
        
        _tableView.frame = CGRectMake(0, 15, kActionSheetWidth, 160);
        
        self.frame = CGRectMake(sheetX, sheetY, kActionSheetWidth, kActionSheetHeight);
        
    }];
    
//    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
//    
//    animation.toValue = [NSValue valueWithCGRect:(CGRectMake(sheetX, sheetY, kActionSheetWidth, kActionSheetHeight))];
//    
//    [self pop_addAnimation:animation forKey:@""];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


    if ([self.delegate respondsToSelector:@selector(actionSheetDelegateWithNumber:ActionSheet:)]) {
        
        [self.delegate actionSheetDelegateWithNumber:indexPath.row ActionSheet:self];

    }


}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 40;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    XFMoreTableViewCell *cell = (XFMoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kActionSheetTableViewCellIdentifier];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XFMoreTableViewCell" owner:nil options:nil] lastObject];
    }
    
    cell.model = self.models[indexPath.row];

    return cell;

}

-(NSArray *)models {

    if (_models == nil) {
        
        _models = [XFActionSheetModel models];
    
    }
    return _models;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

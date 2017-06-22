//
//  XFAddAlertView.h
//  buBo
//
//  Created by mr.zhou on 2017/6/12.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,XFAlertViewType) {
    
    XFAlertViewTypeTextField,
    
    XFAlertViewTypeDetail,
    
    XFAlertViewTypeSheet,
    
};

@protocol XFAddAlertViewDelegate <NSObject>


-(void)alertViewClickDoneButtonDelegateWithInputText:(NSArray *)inputTexts;


@end

@interface XFAddAlertView : UIView <UITextFieldDelegate>

@property (nonatomic,strong) id <XFAddAlertViewDelegate> delegate;

@property (nonatomic,strong) UIWindow *keyWindow;
/**
 *  遮罩层
 */
@property (nonatomic,strong) UIView *shadowView;
/**
 *  头部View
 */
@property (nonatomic,strong) UIView *topView;
/**
 *  titleLabel
 */
@property (nonatomic,strong) UILabel *titleLabel;
/**
 *  输入框
 */
@property (nonatomic,strong) UITextField *inputTextField;
/**
 *  确定按钮
 */
@property (nonatomic,strong) UIButton *doneButton;

/**
 *  自定义时间
 */
@property (nonatomic,strong) UITextField *inputTimeTextField;

- (instancetype)initWithXFAlertViewType:(XFAlertViewType)type;

- (void)show;

@end

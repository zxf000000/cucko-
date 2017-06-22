//
//  XFAddAlertView.m
//  buBo
//
//  Created by mr.zhou on 2017/6/12.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFAddAlertView.h"


#define kTextFieldAlertViewHeight 150
#define kAlertViewX (kScreenWidth - kAlertViewWidth)/2
#define kTextFieldAlertViewY (kScreenHeight - kTextFieldAlertViewHeight)/2

@implementation XFAddAlertView

- (instancetype)initWithXFAlertViewType:(XFAlertViewType)type {

    if (self = [super init]) {
        // 初始化window
        _keyWindow = [UIApplication sharedApplication].keyWindow;
        // 初始化遮罩层
        _shadowView = [[UIView alloc] initWithFrame:(CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight))];
        
        _shadowView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.610];
        
        [_keyWindow addSubview:_shadowView];
        
        _shadowView.alpha = 0;
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.cornerRadius = 10;
        
        self.layer.masksToBounds = YES;
        
        // 初始化自身frame
        // textField类型
        if (type == XFAlertViewTypeTextField) {
        
            self.frame = CGRectMake(kAlertViewX, -kTextFieldAlertViewY, kAlertViewWidth, kTextFieldAlertViewHeight);
            
            [_keyWindow addSubview:self];
        
            _topView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kAlertViewWidth, kAlertViewTopHeight))];
            
            _topView.backgroundColor = kNavigationBarColor;
            
            [self addSubview:_topView];
            
            _titleLabel = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, kAlertViewWidth, kAlertViewTopHeight))];
            
            _titleLabel.font = [UIFont systemFontOfSize:14];
            
            _titleLabel.textAlignment = UITextAlignmentCenter;
            
            _titleLabel.textColor = [UIColor whiteColor];
            
            [_topView addSubview:_titleLabel];
            
            _inputTextField = [[UITextField alloc] initWithFrame:(CGRectMake(10, kAlertViewTopHeight+10, kAlertViewWidth - 20, 30))];
            
            _inputTextField.font = [UIFont systemFontOfSize:13];
            
            _inputTextField.borderStyle = UITextBorderStyleLine;
            
            _inputTextField.delegate = self;
            
            [self addSubview:_inputTextField];
            
            _inputTimeTextField = [[UITextField alloc] initWithFrame:(CGRectMake(10, kAlertViewTopHeight+10 + 35, kAlertViewWidth - 20, 30))];
            
            _inputTimeTextField.font = [UIFont systemFontOfSize:13];
            
            _inputTimeTextField.borderStyle = UITextBorderStyleLine;
            
            _inputTimeTextField.delegate = self;
            
            [self addSubview:_inputTimeTextField];
            
            UIView *sepratorLine = [[UIView alloc] initWithFrame:(CGRectMake(0, kAlertViewTopHeight+10 + 35 + 30 + 8, kAlertViewWidth, 0.5))];
            
            sepratorLine.backgroundColor = [UIColor blackColor];
            
            [self addSubview:sepratorLine];
            
            _doneButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, kAlertViewTopHeight + 40 + 35 + 5, kAlertViewWidth, 30))];
            
            [_doneButton setTitle:@"确定" forState:(UIControlStateNormal)];
            
            [_doneButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
            
            [_doneButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            
            [self addSubview:_doneButton];
            
            [_doneButton addTarget:self action:@selector(clickDonebutton) forControlEvents:(UIControlEventTouchUpInside)];
        
            
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
    }
    
    return self;
    
}

- (void)keyBoardWillShow:(NSNotification *)notification {

    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect frame = self.frame;
    
    frame.origin.y =  (kScreenHeight - keyboardFrame.size.height - kTextFieldAlertViewHeight)/2;
    
    [UIView animateWithDuration:0.1 animations:^{
       
        self.frame = frame;
        
    }];

}

/**
 *  点击确定按钮
 */
- (void)clickDonebutton {
    // 判断输入是否为空
    if (self.inputTextField.text == nil || self.inputTextField.text.length == 0) {
    
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
        
        HUD.mode = MBProgressHUDModeText;
        
        HUD.detailsLabel.text = self.inputTextField.placeholder;
        
        [HUD hideAnimated:YES afterDelay:1];
     
    } else {
     
        if (self.inputTimeTextField.text == nil || self.inputTimeTextField.text.length == 0) {
        
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
            
            HUD.mode = MBProgressHUDModeText;
            
            HUD.detailsLabel.text = self.inputTimeTextField.placeholder;
            
            [HUD hideAnimated:YES afterDelay:1];
        
        } else {
        
        
            [UIView animateWithDuration:0.3 animations:^{
                
                self.alpha = 0;
                
                self.shadowView.alpha = 0;
                
            } completion:^(BOOL finished) {
                
                self.frame = CGRectMake(kAlertViewX, -kTextFieldAlertViewY, kAlertViewWidth, kTextFieldAlertViewHeight);
                
                self.shadowView.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight);
                
                [self.shadowView removeFromSuperview];
                
                [self removeFromSuperview];
            }];
            
            if ([self.delegate respondsToSelector:@selector(alertViewClickDoneButtonDelegateWithInputText:)]) {
                
                NSArray *array = [NSArray arrayWithObjects:self.inputTextField.text,self.inputTimeTextField.text,nil];
                
                [self.delegate alertViewClickDoneButtonDelegateWithInputText:array];
                
            }
            
            
            [self.inputTimeTextField resignFirstResponder];
            
            [self.inputTextField resignFirstResponder];
        
        }
        
    
    }
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {


}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    
    [self clickDonebutton];
    
    return YES;
}

- (void)show {

    self.shadowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    [UIView animateWithDuration:0.3 animations:^{
       
        self.shadowView.alpha = 1;
        
    }];
    
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    
    animation.springBounciness = 10;
    
    animation.toValue = [NSValue valueWithCGRect:(CGRectMake(kAlertViewX, kTextFieldAlertViewY, kAlertViewWidth, kTextFieldAlertViewHeight))];
    
    [self pop_addAnimation:animation forKey:@""];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

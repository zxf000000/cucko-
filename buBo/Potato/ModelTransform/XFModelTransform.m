//
//  XFModelTransform.m
//  buBo
//
//  Created by mr.zhou on 2017/6/5.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFModelTransform.h"

@implementation XFModelTransform

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    
    return 0.2;


}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {


    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewKey];
    UIView *containerView = transitionContext.containerView;
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    
    
}

@end

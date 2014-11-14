//
//  PresentDetailTransition.m
//  NMH
//
//  Created by Valentin Perez on 4/18/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import "PresentDetailTransition.h"

@implementation PresentDetailTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *detail = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView= [transitionContext containerView];
    
    CGRect frame = containerView.bounds;
    if (_moveFrame)
    {
        frame.origin.y += 20;
        frame.size.height -= 20;
    }
    detail.view.alpha = 0.0;
    detail.view.frame = frame;
    [containerView addSubview:detail.view];

    [UIView animateWithDuration:.4 animations:^{
        detail.view.alpha = 1;
    } completion:^(BOOL finished){
        [transitionContext completeTransition:YES];
        NSLog(@"FINISHED S");

        
    }];
    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return .4;
    
}
@end

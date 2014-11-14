//
//  PresentDetailTransition.h
//  NMH
//
//  Created by Valentin Perez on 4/18/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PresentDetailTransition : NSObject  <UIViewControllerAnimatedTransitioning>
@property (assign, nonatomic) BOOL moveFrame;
@end

//
//  JoinViewController.h
//  Join
//
//  Created by Valentin Perez on 6/5/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SemiCircleProfile.h"


@interface JoinViewController : UIViewController <SemiCircleProfileDelegate, UIGestureRecognizerDelegate>
- (IBAction)clickedBack:(id)sender;
- (IBAction)clickedDescribe:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *describeButton;
@property (weak, nonatomic) IBOutlet UILabel *joinWithLabel;
@property (weak, nonatomic) IBOutlet UIImageView *joinLogoImageView;

@end

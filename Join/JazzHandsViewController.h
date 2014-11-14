//
//  JazzHandsViewController.h
//  Join
//
//  Created by Valentin Perez on 8/13/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import "IFTTTAnimatedScrollViewController.h"
#import "IFTTTJazzHands.h"

@interface JazzHandsViewController : IFTTTAnimatedScrollViewController <IFTTTAnimatedScrollViewControllerDelegate>

- (IBAction)dismiss:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *dismissButton;
@property (assign, nonatomic) BOOL isLoggedIn;


@end

//
//  JoinNetworksViewController.h
//  Join
//
//  Created by Valentin Perez on 6/5/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AddUserNameViewController.h"

@interface JoinNetworksViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, AddUserNameViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) AddUserNameViewController *addUserNameViewController;
@end

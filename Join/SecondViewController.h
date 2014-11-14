//
//  SecondViewController.h
//  Join
//
//  Created by Valentin Perez on 6/4/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdjustSearchViewController.h"

@interface SecondViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, AdjustSearchViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIButton *groupButton;
@property (strong, nonatomic) IBOutlet UILabel *groupLabel;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) AdjustSearchViewController *adjustSearchViewController;


- (IBAction)tappedGroupButton:(id)sender;
- (IBAction)showSideMenu:(id)sender;
- (IBAction)tappedAdjust:(id)sender;

@end

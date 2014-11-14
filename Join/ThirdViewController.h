//
//  ThirdViewController.h
//  Join
//
//  Created by Valentin Perez on 6/4/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailNetworkViewController.h"

@interface ThirdViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, DetailNetworkViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *noContactsLabel;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)showSideMenu:(id)sender;
- (IBAction)tappedSearch:(id)sender;


@end

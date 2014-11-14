//
//  ThirdViewController.m
//  Join
//
//  Created by Valentin Perez on 6/4/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import "ThirdViewController.h"
#import "ViewController.h"
#import "JoinCell.h"
#import "SecondViewController.h"
#import "UIKit+AFNetworking.h"
#import "PresentDetailTransition.h"
#import "DismissDetailTransition.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>

static NSString *kCollectionViewCellID = @"joinCell";

@interface ThirdViewController () <UIViewControllerTransitioningDelegate>
{
    NSMutableArray *usersToDisplay;
    NSArray *totalUserContacts;
    int cellIndexSelected;
    PFUser *currentUser;
}
@end

@implementation ThirdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_searchBar setDelegate: self];
    //UIColor *joinBlue = [UIColor colorWithRed:(float)(3.0/255.0f) green:(float)(35.0/255.0f) blue:(float)(50.0/255.0f) alpha:1];
    
    //_searchBar.tintColor =joinBlue;
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:15]];
    [self setNeedsStatusBarAppearanceUpdate];
    usersToDisplay = [[NSMutableArray alloc] init];
    totalUserContacts = [[NSArray alloc] init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnScreen)];
    tap.numberOfTapsRequired = 1;
    [self getUserContacts];
    //[self.view addGestureRecognizer:tap];
}
- (void) viewWillAppear:(BOOL)animated
{
    NSLog(@"will appear");
  //  [self getUserContacts];

    /*for (int i = 0; i<10; i++)
    {
    [self getUserContacts];
    [self getUserContacts];
    [self getUserContacts];
    [self getUserContacts];
    [self getUserContacts];
    [self getUserContacts];
    [self getUserContacts];
    [self getUserContacts];
    [self getUserContacts];
    [self getUserContacts];
    [self getUserContacts];
    [self getUserContacts];
    }*/
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    
}
- (void) viewWillDisappear:(BOOL)animated
{
    NSLog(@"will disappear");
    
}
- (UIStatusBarStyle) preferredStatusBarStyle
{
    NSLog(@"hey black!");
    return UIStatusBarStyleDefault;
}

- (void) tappedOnScreen
{
    //[self.view endEditing:YES];
    NSLog(@"sensing");
}


- (void) getUserContacts
{
    //NSString *toSearch = [text lowercaseString];
    currentUser = [PFUser currentUser];

    NSLog(@"user contacts:: %@", currentUser[@"contactos"]);
    _noContactsLabel.hidden = !([currentUser[@"contactos"] count] <=0);
    //_searchButton.hidden = _noContactsLabel.hidden;

    totalUserContacts = currentUser[@"contactos"];

    usersToDisplay = [totalUserContacts mutableCopy];
    [_collectionView reloadData];
  
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}
# pragma mark - UISearchBar Delegate methods.
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    
    // [self getUsersForText:searchBar.text];
    
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (!_noContactsLabel.hidden)
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"If you want to find people, go to Search." delegate:self cancelButtonTitle:@"Got it." otherButtonTitles: nil] show];
    }
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar                   // called when keyboard search button pressed
{
    [searchBar resignFirstResponder];
   // [self getUsersForText:searchBar.text];
    [self updateUsersForText:searchBar.text];

    
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"cambiando");
    if ([searchText  isEqualToString:@""])
    {
        NSLog(@"NADA");
        usersToDisplay = [totalUserContacts mutableCopy];
        [_collectionView reloadData];
        return;
    }
    NSLog(@"last? %@", [searchText substringFromIndex:searchText.length-1]);
    if (searchText.length >0)
    {
        if ([[searchText substringFromIndex:searchText.length-1] isEqualToString:@" "])
        {
            
            
        }
        else
            [self updateUsersForText:searchText];
    }
}

- (void) updateUsersForText: (NSString *) text
{
    NSLog(@"updating users for text: %@", text);
    NSMutableArray *newUsers = [[NSMutableArray alloc] init];
    for (int i = 0; i<totalUserContacts.count; i++)
    {
        NSString *fName = totalUserContacts[i][@"firstName"];
        NSString *uName = totalUserContacts[i][@"username"];

        if ([fName rangeOfString:text options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
         //fName doesn't contain text
            NSLog(@"%@ contains %@", fName, text);
            [newUsers addObject:totalUserContacts[i]];
        }
        else
        {
            if ([uName rangeOfString:text options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                //uName doesn't contain text
                NSLog(@"%@ contains %@", uName, text);
                [newUsers addObject:totalUserContacts[i]];

                
            }
            else
            {
            }
        }
    }
    
    usersToDisplay = newUsers;
    [_collectionView reloadData];
    
}
# pragma mark - CollectionView methods.

- (NSInteger) collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    
    
    return usersToDisplay.count;
    //return 27;
}


/*
 * Return 1 for number of sections.
 */
- (NSInteger) collectionView:(UICollectionView *)view numberOfSection:(NSInteger)section
{
    return 1;
}

/*
 * Displays the cells of the collectionView
 */
- (UICollectionViewCell *) collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JoinCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellID forIndexPath:indexPath];
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
    cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2;
    cell.imageView.layer.masksToBounds = YES;
    
    if (usersToDisplay.count>0)
    {
       /// if (usersToDisplay[])
       
        //PFUser *realUser =
        NSString *name = [NSString stringWithFormat:@"%@ %@", usersToDisplay[indexPath.row][@"firstName"], usersToDisplay[indexPath.row][@"lastName"]];
        NSString *pictureURL =[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", usersToDisplay[indexPath.row][@"facebookID"]];
        pictureURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=170&height=170", usersToDisplay[indexPath.row][@"facebookID"]];
        
        [cell.imageView setImageWithURL: [NSURL URLWithString:pictureURL] placeholderImage:[UIImage imageNamed:@"joinIcon500.png"]];
        
        [cell.nameLabel setText:name];
        return cell;
        
    }
    else
        return nil;

    
}


/*
 * Handles the cell the user clicked in the collectionView.
 */
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_searchBar resignFirstResponder];
    
    NSLog(@"whattt");
    cellIndexSelected = (int) indexPath.row;
    
    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"showUserController"];
    PFQuery *query = [PFUser query];
    //[query whereKey:@"objectId" equalTo:usersToDisplay[indexPath.row][@"objectId"]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [query getObjectInBackgroundWithId:usersToDisplay[indexPath.row][@"objectId"] block:^(PFObject *object, NSError *error) {
        if (object)
        {
            vc.isOtherUser = YES;
            PFUser *userToPass = (PFUser *) object;
            vc.user = userToPass;
            vc.detailNetworkVCDelegate = self;
            vc.modalPresentationStyle = UIModalPresentationCustom;
            vc.transitioningDelegate = self;
            [hud hide:YES];

            [self presentViewController:vc animated:YES
                         completion:nil];
        }
        else
            [hud hide:YES];
    }];
    /*[query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object)
        {
            vc.isOtherUser = YES;
            PFUser *userToPass = (PFUser *) object;
            vc.user = userToPass;
            vc.modalPresentationStyle = UIModalPresentationCustom;
            vc.transitioningDelegate = self;
            [self presentViewController:vc animated:YES
                             completion:nil];
        }
        else
            NSLog(@"user doesn't exist");
    }];*/
    
   /* vc.isOtherUser = YES;
    
    vc.user = usersToDisplay[indexPath.row];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self;
    [self presentViewController:vc animated:YES
                     completion:nil];*/
    
}

#pragma mark - Helper Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch!!!");
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([_searchBar isFirstResponder] && ([touch view] != _searchBar || [touch view]== _collectionView))
        [_searchBar resignFirstResponder];
    
}
#pragma mark - Transitioning Delegate Methods
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[PresentDetailTransition alloc] init];
    
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[DismissDetailTransition alloc] init];
    
}

#pragma mark - DetailNetworkViewController Delegate Methods
- (void) contactsChanged
{
    NSLog(@"contacts Changed !!!!");
    [self getUserContacts];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)showSideMenu:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
     //[self.sideMenuViewController presentLeftMenuViewController];
}
- (IBAction)tappedSearch:(id)sender
{
    ///SecondViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"secondController"];
   //AppDelegate *app =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    //app.window.rootViewController = vc;
   // [self.sideMenuViewController presentViewController:vc animated:YES completion:nil];
    //[self presentViewController:vc animated:YES completion:nil];
    

}
@end

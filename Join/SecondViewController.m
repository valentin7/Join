//
//  SecondViewController.m
//  Join
//
//  Created by Valentin Perez on 6/4/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import "SecondViewController.h"
#import "ViewController.h"
#import "AdjustSearchViewController.h"
#import "JoinCell.h"
#import "UIKit+AFNetworking.h"
#import "PresentDetailTransition.h"
#import "DismissDetailTransition.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

static NSString *kCollectionViewCellID = @"joinCell";

@interface SecondViewController () <UIViewControllerTransitioningDelegate>
{
    NSArray *totalUsers;
    NSMutableArray *usersToDisplay;
    int cellIndexSelected;
    BOOL moveFrameToPresent;
    AppDelegate *app;
    PFUser *currentUser;
}
@end

@implementation SecondViewController

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
    
    if (!usersToDisplay)
        usersToDisplay = [[NSMutableArray alloc] init];
  
    NSLog(@"current usersToDisplay: %@", usersToDisplay);
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:15]];

    currentUser = [PFUser currentUser];
    app = (AppDelegate *) [UIApplication sharedApplication].delegate;
   [_collectionView setDelegate: self];
   [_collectionView setDataSource:self];
    [_searchBar setDelegate: self];
    _searchBar.tintColor = [UIColor whiteColor];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnScreen)];
    tap.numberOfTapsRequired = 1;
    //[self.view addGestureRecognizer:tap];
    if (app.groupToSearch)
       [ _groupButton setTitle:app.groupToSearch forState:UIControlStateNormal];
        //_groupLabel.text = app.groupToSearch;
    else
        [ _groupButton setTitle:@"Join" forState:UIControlStateNormal];
        //_groupLabel.text = @"Join";
}

- (void) viewDidAppear:(BOOL)animated
{
    NSLog(@"whatt");
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if (app.groupToSearch)
        [ _groupButton setTitle:app.groupToSearch forState:UIControlStateNormal];
    //_groupLabel.text = app.groupToSearch;
    else
        [ _groupButton setTitle:@"Join" forState:UIControlStateNormal];
    //_groupLabel.text = @"Join";
    
    NSLog(@"app group to search:: %@", app.groupToSearch);
    app.groupToSearch = _groupButton.titleLabel.text;
    if (app.groupTotalUsers)
    {
        usersToDisplay = [app.groupTotalUsers mutableCopy];
        totalUsers = app.groupTotalUsers;
    }
    NSLog(@"will appear current userstodisplay: %@", usersToDisplay);
    NSLog(@"will appear current totalUsers: %@", totalUsers);

    //app.groupToSearch = _groupLabel.text;
    
    
}
- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) tappedOnScreen
{
    //[self.view endEditing:YES];
    NSLog(@"sensing");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) findGroups
{
    NSString *graphPathForGroups = @"/me/groups";

    [FBRequestConnection startWithGraphPath:graphPathForGroups
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              
                              NSLog(@"result:: %@", result);
                              /* handle the result */
                              
                              //usersToDisplay = [result valueForKeyPath:@"data"];
                              //totalUsers = usersToDisplay;
                              // usersToDisplay = @{@"facebookID": [result valueForKeyPath:@"data.id"], @"name": [result valueForKeyPath:@"data.name"]};
                              //[_collectionView reloadData];
                              
                          }];

    
}

- (void) updateUsersForText: (NSString *) text
{
   // NSLog(@"updating users for text: %@", text);
   // NSLog(@"total users: %@", totalUsers);
    NSMutableArray *newUsers = [[NSMutableArray alloc] init];
    for (int i = 0; i<totalUsers.count; i++)
    {
        NSString *fName = totalUsers[i][@"firstName"];
        NSString *uName = [totalUsers[i] username];

        if (!fName)
            fName = totalUsers[i][@"name"];
        if (!uName)
            uName = @"";
        
        if ([fName rangeOfString:text options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            //fName doesn't contain text
           // NSLog(@"%@ contains %@", fName, text);
            [newUsers addObject:totalUsers[i]];
            
            
            
        }
        else
        {
            if ([uName rangeOfString:text options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                //uName doesn't contain text
                //NSLog(@"%@ contains %@", uName, text);
                [newUsers addObject:totalUsers[i]];
                
                
            }
            else
            {
            }
        }
    }
    
   // NSLog(@"RELOADINGG");
    usersToDisplay = newUsers;
    [_collectionView reloadData];
    
}
- (void) getEarlyUsersForText: (NSString *) text
{
    NSLog(@"getting early users");
    NSString *toSearch = [text lowercaseString];
    PFQuery *query = [PFUser query];//[PFQuery queryWithClassName:@"Todo"];
    [query whereKey:@"lowerFirstName" containsString: toSearch];
    PFQuery *queryUserName = [PFUser query];
    [queryUserName whereKey:@"username" containsString: toSearch];
    //[query whereKey:<#(NSString *)#> containsString:<#(NSString *)#>]
    // usersToDisplay = [query findObjects];
    
    PFQuery *queryMaster = [PFQuery orQueryWithSubqueries:@[query,queryUserName]];
    
    [queryMaster findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        totalUsers = results;
        usersToDisplay = [results mutableCopy];
        app.groupTotalUsers = totalUsers;
       // NSLog(@"users: %@", usersToDisplay);
        [_collectionView reloadData];
    }];
    
    
}
- (void) getUsersForText: (NSString *) text
{
    NSString *toSearch = [text lowercaseString];

    PFQuery *query = [PFUser query];//[PFQuery queryWithClassName:@"Todo"];
    [query whereKey:@"lowerFirstName" equalTo: toSearch];
    PFQuery *queryUserName = [PFUser query];
    [queryUserName whereKey:@"username" equalTo: toSearch];
    //[query whereKey:<#(NSString *)#> containsString:<#(NSString *)#>]
   // usersToDisplay = [query findObjects];

    PFQuery *queryMaster = [PFQuery orQueryWithSubqueries:@[query,queryUserName]];
    
    [queryMaster findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        usersToDisplay = [results mutableCopy];
        NSLog(@"users: %@", usersToDisplay);
        [_collectionView reloadData];
    }];
   
    
}

- (void) getUsersForGroupID: (NSString *)groupID
{
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([app.groupToSearch isEqualToString:@"Facebook friends"])
    {
        NSLog(@"Facebook friends!!!!");
        NSString *graphPathForFriends = @"/me/friends";
        //graphPathForFriends = @"/me/taggable_friends";
        
        [FBRequestConnection startWithGraphPath:graphPathForFriends
                                     parameters:nil
                                     HTTPMethod:@"GET"
                              completionHandler:^(
                                                  FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error
                                                  ) {
                                  
                                  NSLog(@"result:: %@", result);
                                  /* handle the result */
                                  
                                  [hud hide:YES];
                                  usersToDisplay = [result valueForKeyPath:@"data"];
                                  totalUsers = usersToDisplay;
                                  app.groupTotalUsers = totalUsers;
                                  [_collectionView reloadData];
                                  
                              }];
        
        
    }
    else if ([_groupLabel.text isEqualToString:@"Twitter following"])
    {
        usersToDisplay = nil;
        [hud hide:YES];
        
    }
    else if ([app.groupToSearch isEqualToString:@"Join"])
    {
        [hud hide:YES];
    }
    else if ([app.groupToSearch isEqualToString:@"Instagram following"])
    {
        [hud hide:YES];

    }
    // else it's a facebook group
    else
    {
        NSLog(@"came into fb group");
        NSString *graphPathForGroups = [NSString stringWithFormat:@"/%@/members", groupID];
        
        [FBRequestConnection startWithGraphPath:graphPathForGroups
                                     parameters:nil
                                     HTTPMethod:@"GET"
                              completionHandler:^(
                                                  FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error
                                                  ) {
                                  
                                  [hud hide:YES];
                                  NSLog(@"result:: %@", result);
                                  /* handle the result */
                                  usersToDisplay = [result valueForKeyPath:@"data"];
                                  totalUsers = usersToDisplay;
                                  app.groupTotalUsers = totalUsers;
                                  [_collectionView reloadData];
                                  
                              }];

        
        
    }
    [_collectionView reloadData];

    
}

#pragma mark - AdjustSearchViewController Delegate Methods
- (void) selectedGroupToSearch: (NSDictionary*) group
{
    app.groupToSearch = group[@"name"];
    NSLog(@"selected group: %@", group[@"name"]);
    [_groupButton setTitle:group[@"name"] forState:UIControlStateNormal];
    //_groupLabel.text = group[@"name"];
    
    [self getUsersForGroupID:group[@"id"]];
}



# pragma mark - UISearchBar Delegate methods.
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"ni madres");
    [_searchBar resignFirstResponder];

   // [self getUsersForText:searchBar.text];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar                   // called when keyboard search button pressed
{
    [searchBar resignFirstResponder];
    [self updateUsersForText:searchBar.text];
    //[self getUsersForText:searchBar.text];

   
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"cambiando");
  
    [self updateUsersForText:searchText];

    if ([searchText  isEqualToString:@""])
    {
        
        if ([app.groupToSearch isEqualToString:@"Join"])
        {
        usersToDisplay = nil;
        usersToDisplay = [[NSMutableArray alloc] init];
        }
        else
        {
            usersToDisplay = [totalUsers mutableCopy];
            
        }
            [_collectionView reloadData];
    }
    if ([app.groupToSearch isEqualToString:@"Join"])
    {
        if (searchText.length == 2)
        {
            NSLog(@"length 2");
            if ([app.groupToSearch isEqualToString:@"Join"])
                [self getEarlyUsersForText:searchText];
        }
        else if (searchText.length>=3)
        {
            if ([[searchText substringFromIndex:searchText.length-1] isEqualToString:@" "])
            {
                
                
            }
            else
                [self updateUsersForText:searchText];
            
        }
    }


}
# pragma mark - CollectionView methods.

- (NSInteger) collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return usersToDisplay.count;
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
   // UICollectionViewCell *cell = [[UICollectionViewCell alloc] init];
     JoinCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellID forIndexPath:indexPath];
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
    cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2;
    cell.imageView.layer.masksToBounds = YES;

    //[cell.imageView setImage:[UIImage imageNamed:@"Valentin Perez.png"]];
    if (usersToDisplay.count>0)
    {
        
        NSString *name;
        NSString *pictureURL;
        if ([app.groupToSearch isEqualToString:@"Facebook friends"] || usersToDisplay[indexPath.row][@"name"])
        {
            name = usersToDisplay[indexPath.row][@"name"];
             pictureURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=170&height=170&return_ssl_resources=1", usersToDisplay[indexPath.row][@"id"]];
        }
        else
        {
            name = [NSString stringWithFormat:@"%@ %@", usersToDisplay[indexPath.row][@"firstName"], usersToDisplay[indexPath.row][@"lastName"]];
             pictureURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=170&height=170&return_ssl_resources=1", usersToDisplay[indexPath.row][@"facebookID"]];
        }

   // =[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", usersToDisplay[indexPath.row][@"facebookID"]];
   

    
    [cell.imageView setImageWithURL: [NSURL URLWithString:pictureURL] placeholderImage:[UIImage imageNamed:@"joinIcon500.png"]];
    
    [cell.nameLabel setText:name];
        return cell;

    }
    else
        return nil;
    /*
     //cell.bounds = CGRectMake(0, 0, 102, 102);
     UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
     
     //UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 15)];
     //label.text = @"what";
     
     [imageView setImageWithURL: photoURLs[indexPath.row]];
     [imageView setContentMode:UIViewContentModeScaleAspectFill];
     // [imageView setImage:[UIImage imageNamed:@"nmhFullMoon"]];
     [cell addSubview:imageView];
     */
    
}


/*
 * Handles the cell the user clicked in the collectionView.
 */
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_searchBar resignFirstResponder];
    cellIndexSelected = (int) indexPath.row;
    PFQuery *query = [PFUser query];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"user selected: %@ ", usersToDisplay[indexPath.row]);
    
    if (![app.groupToSearch isEqualToString:@"Join"] && usersToDisplay[indexPath.row][@"id"])
    {
        NSLog(@"first one");

        [query whereKey:@"facebookID" equalTo: usersToDisplay[indexPath.row][@"id"]];
    }
    else
    {
        NSLog(@"second one");

        [query whereKey:@"facebookID" equalTo: usersToDisplay[indexPath.row][@"facebookID"]];

    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"if there was error: %@", error.description);
        
        [hud hide:YES];
        if (objects && objects.count>0)
        {
            //return  YES;
            NSLog(@"found at least %lu", (unsigned long)objects.count);//  return NO;

            ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"showUserController"];
            vc.isOtherUser = YES;
            vc.user = objects[0];
            vc.modalPresentationStyle = UIModalPresentationCustom;
            moveFrameToPresent = NO;
            vc.transitioningDelegate = self;
            [self presentViewController:vc animated:YES
                             completion:nil];
        }
        else
        {
            NSLog(@"ddint");//  return NO;
            
            // Check if the Facebook app is installed and we can present
            // the message dialog
            FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
            params.link = [NSURL URLWithString:@"https://www.joinprofile.com"];
            params.name = @"Simplify your life too";
            params.caption = @"Find people - and all their social networks";
            params.picture = [NSURL URLWithString:@"http://i.imgur.com/g3Qc1HN.png"];
            params.linkDescription = @"Get the Join app";
            
            // If the Facebook app is installed and we can present the share dialog
            if ([FBDialogs canPresentMessageDialogWithParams:params]) {
                // Enable button or other UI to initiate launch of the Message Dialog
            
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ hasn't joined yet",usersToDisplay[indexPath.row][@"name"]] message:@"Do you want to tell some friends about Join?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Of course ", nil];
                alert.tag = indexPath.row;
                [alert show];
                
                [[UIPasteboard generalPasteboard] setString:usersToDisplay[indexPath.row][@"name"]];
            }  else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ hasn't joined yet",usersToDisplay[indexPath.row][@"name"]] message:@"To let him know, Facebook needs you to have their messenger app. Do you want to get it?" delegate:self cancelButtonTitle:@"Not now" otherButtonTitles:@"Yes", nil];
                [alert show];
                // Disable button or other UI for Message Dialog
            }
            

            
            
        }
    }];
    // indexClicked = (int) indexPath.row;*/
    //[self performSegueWithIdentifier:@"showProfileSegue" sender:self];
}

#pragma mark - AlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    
    
    if([title isEqualToString:@"Of course "])
    {
        MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        
        hud.labelText = [NSString stringWithFormat:@"%@ copied to clipboard!", usersToDisplay[alertView.tag][@"name"]];
        hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:14];
        [hud hide:YES afterDelay:1.5];
        
        [self performSelector:@selector(presentFacebookMessageDialog) withObject:nil afterDelay:1.5];
        
    }
    else if([title isEqualToString:@"Of course"])
    {
        [self presentFacebookMessageDialog];
        
    }
    else if ([title isEqualToString:@"Yes"])
    {
        NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/en/app/facebook-messenger/id454638411?mt=8"];
        [[UIApplication sharedApplication] openURL:url];
        
    }
    
}
- (void) presentFacebookMessageDialog
{
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:@"https://www.joinprofile.com"];
    params.name = @"Simplify your life too";
    params.caption = @"Find people - and all their social networks";
    params.picture = [NSURL URLWithString:@"http://i.imgur.com/g3Qc1HN.png"];
    params.linkDescription = @"Get the Join app";
    
    
    
    [FBDialogs presentMessageDialogWithParams:params clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
        
        if(error) {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
            NSLog(@"%@",[NSString stringWithFormat:@"Error messaging link: %@", error.description]);
        } else {
            // Success
            NSLog(@"result %@", results);
        }
        
    }];

    
}
#pragma mark - Helper Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch!!!");
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([_searchBar isFirstResponder] && ([touch view] != _searchBar || [touch view]== _collectionView))
        [_searchBar resignFirstResponder];
    
}

- (BOOL) userInJoin: (NSDictionary *) userToCheck
{
    PFQuery *query = [PFUser query];
    
    [query whereKey:@"facebookID" equalTo:userToCheck[@"facebookID"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        if (objects && objects.count>0)
        {
           //return  YES;
        }
        else
            NSLog(@"ddint");//  return NO;
        
        
    }];
    return NO;
}

#pragma mark - Transitioning Delegate Methods
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    PresentDetailTransition *pT = [[PresentDetailTransition alloc] init];
    pT.moveFrame = moveFrameToPresent;
    return pT;
    
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[DismissDetailTransition alloc] init];
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ViewController *vc = [segue
                          destinationViewController];
    vc.isOtherUser = YES;
    vc.user = usersToDisplay[cellIndexSelected];
}


- (IBAction)tappedGroupButton:(id)sender
{
    if ([app.groupToSearch isEqualToString:@"Facebook friends"])
    {
        // Check if the Facebook app is installed and we can present
        // the message dialog
        FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
        params.link = [NSURL URLWithString:@"https://www.joinprofile.com"];
        params.name = @"Simplify your life too";
        params.caption = @"Find people - and all their social networks";
        params.picture = [NSURL URLWithString:@"http://i.imgur.com/g3Qc1HN.png"];
        params.linkDescription = @"Get the Join app";
        
        // If the Facebook app is installed and we can present the share dialog
        if ([FBDialogs canPresentMessageDialogWithParams:params]) {
            // Enable button or other UI to initiate launch of the Message Dialog
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Do you want to tell some other friends about Join?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Of course", nil];
            alert.tag = 3;
            [alert show];
            
            //[[UIPasteboard generalPasteboard] setString:usersToDisplay[indexPath.row][@"name"]];
        }  else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"To tell other friends about Join, Facebook needs you to have their messenger app. Do you want to get it?" delegate:self cancelButtonTitle:@"Not now" otherButtonTitles:@"Yes", nil];
            [alert show];
            // Disable button or other UI for Message Dialog
        }
    }

    /*
    
    //[_groupButton setTitle:@"Brown University" forState:UIControlStateNormal];
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        // Present the share dialog
        NSLog(@"can present");
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
        
    } else {
        // Present the feed dialog
        NSLog(@"can't presentt");
    }*/
    
}

- (IBAction)showSideMenu:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (IBAction)tappedAdjust:(id)sender
{
    NSLog(@"adjusting brah");
    AdjustSearchViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"adjustSearchController"];
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self;
    moveFrameToPresent = NO;
    [self presentViewController:vc animated:YES
                     completion:nil];
    
}
@end

//
//  AdjustSearchViewController.m
//  Join
//
//  Created by Valentin Perez on 8/2/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import "AdjustSearchViewController.h"
#import "SearchGroupCell.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@implementation AdjustSearchViewController
{
    NSMutableArray *titles;
    AppDelegate *app;
    NSMutableArray *facebookGroups;
    BOOL firstLoad;
    BOOL loadedFBGroups;
    int normalCellX;
}
- (void) viewDidLoad
{

     self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:.85];
    app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    titles = [[NSMutableArray alloc] initWithObjects:@{@"name":@"Join"},@{@"name":@"Facebook friends"}/*, @{@"name":@"Twitter following"}, @{@"name":@"Instagram following"}*/, nil];
    
    
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    // hide empty cells
    [self.tableView setTableFooterView:[UIView new]];
    
    [self findGroups];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnScreen)];
    tap.numberOfTapsRequired = 1;
    //[self.view addGestureRecognizer:tap];
    firstLoad = YES;
}

- (void) tappedOnScreen
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
-(void)viewWillDisappear:(BOOL)animated
{
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void) findGroups
{
    PFUser *currentUser = [PFUser currentUser];
    
    NSString *fbID = currentUser[@"facebookID"];
    if (!fbID)
    {
        NSLog(@"didn't have facebook ID!!!");
        return;
    }
    NSString *graphPathForGroups = [NSString stringWithFormat:@"/%@/groups", fbID];

    //MBProgressHUD
    /*MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;*/
    [FBRequestConnection startWithGraphPath:graphPathForGroups
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              
                             // [hud hide:YES];
                              if (error)
                                  NSLog(@"errorrr: %@", error.description);
                              
                              NSLog(@"facebook groups::: %@", result[@"data"]);
                              loadedFBGroups = YES;
                              
                              /* handle the result */
                              facebookGroups = result[@"data"];
                            
                           [facebookGroups sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                               return [obj1[@"bookmark_order"] intValue]>[obj2[@"bookmark_order"] intValue];
                           }];
                              
                              [_tableView reloadData];
                              
                          }];
    
    
}
# pragma mark TableView Delegate & DataSource Methods
- (NSInteger) numberOfSectionsInTableView:( UITableView *) tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // if (facebookGroups.count ==0)
     //   return 0;
    return titles.count+facebookGroups.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([self.delegate respondsToSelector:@selector(selectedGroupToSearch:)]) {
        if (indexPath.row < titles.count)
        {
            [self.delegate selectedGroupToSearch:titles[indexPath.row]];
            NSLog(@"selected group:: %@", titles[indexPath.row]);
        }
        else
        {
            [self.delegate selectedGroupToSearch:facebookGroups[indexPath.row-titles.count]];
        }

    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *) tableView:( UITableView *) tableView cellForRowAtIndexPath:( NSIndexPath *) indexPath
{
    //UITableViewCell *cell = [[UITableViewCell alloc] init];
    SearchGroupCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"searchGroupCell" forIndexPath:indexPath];
    if (indexPath.row >= titles.count+facebookGroups.count)
    {
        NSLog(@"GTFO");
        return nil;
    }
    if (indexPath.row < titles.count)
        cell.titleLabel.text = titles[indexPath.row][@"name"];
    else if (indexPath.row < facebookGroups.count+titles.count)
    {
        loadedFBGroups = NO;
        cell.titleLabel.text = facebookGroups[indexPath.row - titles.count][@"name"];
  
    }
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    int xplace =  cell.frame.origin.x;
    NSLog (@"cell x place: %d",xplace);
    return cell;
}

//This function is where all the magic happens
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row<titles.count && loadedFBGroups)
    {
        return;
        
    }
  /*if (indexPath.row<titles.count && firstLoad)
    {
        NSLog(@"not FIRSTLOAD");
        firstLoad = NO;
        return;
    }*/
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    
    //3. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.3];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch!!!");
    UITouch *touch = [[event allTouches] anyObject];
  
    if ([touch view] != _tableView)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}




- (IBAction)tappedClose:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end

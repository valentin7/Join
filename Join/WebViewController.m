//
//  WebViewController.m
//  Join
//
//  Created by Valentin Perez on 8/7/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import "WebViewController.h"
#import "MBProgressHUD.h"

@implementation WebViewController
{
    MBProgressHUD *hud;
    
}
- (void)viewDidLoad
{
    [_webView setDelegate:self];
    NSURL *url = [NSURL URLWithString:_link];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:req];
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    
    [hud hide:YES];
}
-(void) webViewDidStartLoad:(UIWebView *)webView
{
    hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [hud hide:YES];
    NSString *description;
    if ([_link isEqualToString:@"http://joinprofile.com"])
    {
        description = @"You can find the website at http://joinprofile.com";
    }
    else if ([_link isEqualToString:@"http://joinprofile.com/legal/terms.pdf"])
    {
       description = @"You can find the Terms Of Use at http://joinprofile.com/legal/terms";
        
    }
    else
    {
        description = @"You can find the Privacy Policy at http://joinprofile.com/legal/privacy.pdf";
        
    }
    [[[UIAlertView alloc] initWithTitle:@"Error loading" message:description delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    
}
- (IBAction)tappedBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

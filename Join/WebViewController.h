//
//  WebViewController.h
//  Join
//
//  Created by Valentin Perez on 8/7/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>
@property (assign, nonatomic) NSString *link;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)tappedBack:(id)sender;

@end

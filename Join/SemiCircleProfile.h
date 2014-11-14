//
//  SemiCircleProfile.h
//  Join
//
//  Created by Valentin Perez on 4/21/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//
// Inspired by:
//
//  AAShareBubbles.h
//  AAShareBubbles
//
//  Created by Almas Adilbek on 26/11/13.
//  Copyright (c) 2013 Almas Adilbek. All rights reserved.
//  https://github.com/mixdesign/AAShareBubbles
//

#import <UIKit/UIKit.h>

@protocol SemiCircleProfileDelegate;

typedef enum BubbleType : int {
    
    BubbleTypeFacebook = 0,
    BubbleTypeTwitter = 1,
    BubbleTypeInstagram = 2,
    BubbleTypeTumblr = 3,
    BubbleTypeMail = 4,
    BubbleTypeGooglePlus = 5,
    BubbleTypeLinkedIn = 6,
    BubbleTypePhone = 7,
    BubbleTypeYoutube = 8,
    BubbleTypeVimeo = 9,
    BubbleTypeReddit = 10,
    BubbleTypePinterest = 11,
    BubbleTypeVk = 12,
    BubbleTypeGithub = 13,
    BubbleTypeSnapchat = 14,
    BubbleTypeSpotify = 15,
    BubbleType8tracks = 16,
    BubbleTypeSoundCloud = 17,

    
    BubbleTypeJoin = 707
    
} BubbleType;

@interface SemiCircleProfile : UIView

@property (nonatomic, assign) id<SemiCircleProfileDelegate> delegate;

@property (nonatomic, assign) BOOL showFacebookBubble;
@property (nonatomic, assign) BOOL showTwitterBubble;
@property (nonatomic, assign) BOOL showMailBubble;
@property (nonatomic, assign) BOOL showGooglePlusBubble;
@property (nonatomic, assign) BOOL showTumblrBubble;
@property (nonatomic, assign) BOOL showVkBubble;
@property (nonatomic, assign) BOOL showLinkedInBubble;
@property (nonatomic, assign) BOOL showPinterestBubble;
@property (nonatomic, assign) BOOL showYoutubeBubble;
@property (nonatomic, assign) BOOL showVimeoBubble;
@property (nonatomic, assign) BOOL showRedditBubble;
@property (nonatomic, assign) BOOL showGithubBubble;
@property (nonatomic, assign) BOOL showSpotifyBubble;
@property (nonatomic, assign) BOOL showSnapchatBubble;
@property (nonatomic, assign) BOOL show8tracksBubble;
@property (nonatomic, assign) BOOL showInstagramBubble;
@property (nonatomic, assign) BOOL showPhoneBubble;
@property (nonatomic, assign) BOOL showSoundCloudBubble;


@property (nonatomic, assign) BOOL showJoinBubble;


@property (nonatomic, assign) BOOL isForJoining;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, assign) NSString *imageName;
@property (nonatomic, assign) NSString *profileName;
@property (nonatomic) BOOL showingBubbles;
@property (nonatomic) BOOL showingJoin;


@property (nonatomic, assign) int radius;
@property (nonatomic, assign) int bubbleRadius;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, weak) UIView *parentView;

@property (nonatomic, assign) int facebookBackgroundColorRGB;
@property (nonatomic, assign) int twitterBackgroundColorRGB;
@property (nonatomic, assign) int mailBackgroundColorRGB;
@property (nonatomic, assign) int googlePlusBackgroundColorRGB;
@property (nonatomic, assign) int tumblrBackgroundColorRGB;
@property (nonatomic, assign) int vkBackgroundColorRGB;
@property (nonatomic, assign) int linkedInBackgroundColorRGB;
@property (nonatomic, assign) int pinterestBackgroundColorRGB;
@property (nonatomic, assign) int youtubeBackgroundColorRGB;
@property (nonatomic, assign) int vimeoBackgroundColorRGB;
@property (nonatomic, assign) int redditBackgroundColorRGB;

@property (nonatomic, assign) NSString *profileImageURL;


- (id)initWithPoint:(CGPoint)point radius:(int)radiusValue inView:(UIView *)inView withImageURL: (NSString *) imageURL;

-(void)show;
-(void)hide;
-(void)showJoin;
-(void)hideJoin;

-(void) moveToRight;
-(void) moveToLeft;
-(void) moveToMiddle;

- (void) createProfileWithImage: (UIImage *) image;
- (void) createProfileWithImageString: (NSString *) imageString;


@end

@protocol SemiCircleProfileDelegate<NSObject>

@optional

// On buttons pressed
-(void)semiCircleProfile:(SemiCircleProfile *)SemiCircleProfile tappedBubbleWithType:(BubbleType)bubbleType;

// On profile tapped
-(void)tappedUserProfile;

//On bubbles show
- (void)semiCircleProfileBubblesDidShow;

// On bubbles hide
-(void)semiCircleProfileBubblesDidHide;

@end

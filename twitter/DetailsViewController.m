//
//  DetailsViewController.m
//  twitter
//
//  Created by Sophia Joy Wang on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Tweet.h"
#import "APIManager.h"


@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetBodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.nameLabel.text = self.tweet.user.name;
    
    //add "@" to screen name
    NSString *partialString = self.tweet.user.screenName;
    NSString *fullScreenName = [@"@" stringByAppendingString:partialString];
    self.screenNameLabel.text = fullScreenName;
    
    self.timeLabel.text = self.tweet.createdAtString;
    self.tweetBodyLabel.text = self.tweet.text;
    
    int likeCount = self.tweet.favoriteCount;
    NSString* likeCountString = [NSString stringWithFormat:@"%i", likeCount];
    if (self.tweet.favorited){
        //highlight the heart icon
        NSLog(@"Favorited Already");
        [self.favoriteButton setSelected:YES];
        [self.favoriteButton setTitle:likeCountString forState:UIControlStateSelected];
    } else {
        NSLog(@"Not Favorited yet");
        [self.favoriteButton setSelected:NO];
        [self.favoriteButton setTitle:likeCountString forState:UIControlStateNormal];
    }
    
    int retweetCount = self.tweet.retweetCount;
    NSString* retweetCountString = [NSString stringWithFormat:@"%i", retweetCount];
    if (self.tweet.retweeted){
        //highlight the retweet icon
        NSLog(@"Retweeted Already");
        [self.retweetButton setSelected:YES];
        [self.retweetButton setTitle:retweetCountString forState:UIControlStateSelected];
    } else {
        NSLog(@"Not Retweeted yet");
        [self.retweetButton setSelected:NO];
        [self.retweetButton setTitle:retweetCountString forState:UIControlStateNormal];
    }
    
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    self.profileView.image = nil; //reset last image
    [self.profileView setImageWithURL:url];
    
}

- (IBAction)didTapRetweet:(id)sender {
    
    if (!self.tweet.retweeted){
        // TODO: Update the local tweet model
        NSLog(@"tapped retweet");
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        
        // TODO: Update cell UI
        int retweetCount = self.tweet.retweetCount;
        NSString* retweetCountString = [NSString stringWithFormat:@"%i", retweetCount];
        [self.retweetButton setSelected:YES];
        [self.retweetButton setTitle:retweetCountString forState:UIControlStateSelected];
        
        NSLog(@"%@",self.tweet);
        
        // TODO: Send a POST request to the POST retweet endpoint
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    } else {
        // TODO: Update the local tweet model
        NSLog(@"tapped unretweet");
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        
        // TODO: Update cell UI
        int retweetCount = self.tweet.retweetCount;
        NSString* retweetCountString = [NSString stringWithFormat:@"%i", retweetCount];
        [self.retweetButton setSelected:NO];
        [self.retweetButton setTitle:retweetCountString forState:UIControlStateNormal];
        
        NSLog(@"%@",self.tweet);
        
        // TODO: Send a POST request to the POST retweet endpoint
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    
}

- (IBAction)didTapFavorite:(id)sender {
    
    if (!self.tweet.favorited){
        // TODO: Update the local tweet model
        NSLog(@"tapped favorite");
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        
        // TODO: Update cell UI
        int favoriteCount = self.tweet.favoriteCount;
        NSString* favoriteCountString = [NSString stringWithFormat:@"%i", favoriteCount];
        [self.favoriteButton setSelected:YES];
        [self.favoriteButton setTitle:favoriteCountString forState:UIControlStateSelected];
        NSLog(@"%@",self.tweet);
        
        // TODO: Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    } else {
        // TODO: Update the local tweet model
        NSLog(@"tapped unfavorite");
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        
        // TODO: Update cell UI
        int favoriteCount = self.tweet.favoriteCount;
        NSString* favoriteCountString = [NSString stringWithFormat:@"%i", favoriteCount];
        [self.favoriteButton setSelected:NO];
        [self.favoriteButton setTitle:favoriteCountString forState:UIControlStateNormal];
        NSLog(@"%@",self.tweet);
        
        // TODO: Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

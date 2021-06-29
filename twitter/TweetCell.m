//
//  TweetCell.m
//  twitter
//
//  Created by Sophia Joy Wang on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@implementation TweetCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
        [self.likeButton setSelected:YES];
        [self.likeButton setTitle:favoriteCountString forState:UIControlStateSelected];
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
        [self.likeButton setSelected:NO];
        [self.likeButton setTitle:favoriteCountString forState:UIControlStateNormal];
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

    
//    // TODO: Update the local tweet model
//    NSLog(@"tapped favorite");
//    self.tweet.favorited = YES;
//    self.tweet.favoriteCount += 1;
//
//    // TODO: Update cell UI
//    int favoriteCount = self.tweet.favoriteCount;
//    NSString* favoriteCountString = [NSString stringWithFormat:@"%i", favoriteCount];
//    [self.likeButton setSelected:YES];
//    [self.likeButton setTitle:favoriteCountString forState:UIControlStateSelected];
//    NSLog(@"%@",self.tweet);
//
//    // TODO: Send a POST request to the POST favorites/create endpoint
//    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
//        if(error){
//             NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
//        }
//        else{
//            NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
//        }
//    }];
        
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

    
    
    
    
//    // TODO: Update the local tweet model
//    NSLog(@"tapped retweet");
//    self.tweet.retweeted = YES;
//    self.tweet.retweetCount += 1;
//
//    // TODO: Update cell UI
//    int retweetCount = self.tweet.retweetCount;
//    NSString* retweetCountString = [NSString stringWithFormat:@"%i", retweetCount];
//    [self.retweetButton setSelected:YES];
//    [self.retweetButton setTitle:retweetCountString forState:UIControlStateSelected];
//
//    NSLog(@"%@",self.tweet);
//
//    // TODO: Send a POST request to the POST retweet endpoint
//    [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
//        if(error){
//             NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
//        }
//        else{
//            NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
//        }
//    }];
    
}

@end

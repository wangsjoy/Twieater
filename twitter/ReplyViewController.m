//
//  ReplyViewController.m
//  twitter
//
//  Created by Sophia Joy Wang on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ReplyViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "Tweet.h"
#import "TimelineViewController.h"

@interface ReplyViewController ()
@property (weak, nonatomic) IBOutlet UITextView *replyBodyView;

@end

@implementation ReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.replyBodyView.delegate = self;
    
    //initialize text in textView with @screen_name
    NSString *noAtScreenName = self.tweet.user.screenName;
    //add "@" to screen name
    NSString *screenName = [@"@" stringByAppendingString:noAtScreenName];
    self.replyBodyView.text = screenName;
}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)didTapReply:(id)sender {
    
    
    
    [[APIManager shared]postReplyWithText:self.replyBodyView.text forTweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            //move back to timeline view controller
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TimelineViewController *timelineViewController = [storyboard instantiateViewControllerWithIdentifier:@"TimelineViewController"];
            appDelegate.window.rootViewController = timelineViewController;
            NSLog(@"Reply Tweet Success!");
        }
    }];
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

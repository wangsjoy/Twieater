//
//  ComposeViewController.m
//  twitter
//
//  Created by Sophia Joy Wang on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "Tweet.h"
#import "TimelineViewController.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetBodyView;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //assign delegate
    self.tweetBodyView.delegate = self;

}
- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)didTapPost:(id)sender {
    
    //use APIManager to post composed tweet
    [[APIManager shared]postStatusWithText:self.tweetBodyView.text completion:^(Tweet *tweet, NSError *error) {
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
            NSLog(@"Compose Tweet Success!");
        }
    }];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // TODO: Check the proposed new text character count
    
    // TODO: Allow or disallow the new text
    
    // Set the max character limit
    int characterLimit = 280;

    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.tweetBodyView.text stringByReplacingCharactersInRange:range withString:text];

    // TODO: Update character count label
    NSString *lastURLString = @"/280 characters";
    NSString *characterCountString = [NSString stringWithFormat:@"%i", newText.length];
    NSString *fullString = [characterCountString stringByAppendingString:lastURLString];
    self.characterCountLabel.text = fullString;

    // Should the new text should be allowed? True/False
    NSLog(@"%d", newText.length < characterLimit);
    return newText.length < characterLimit;
    
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

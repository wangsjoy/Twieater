//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"
#import "ReplyViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //assign delegate and datasource
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self fetchTweets];
    
    self.refreshControl = [[UIRefreshControl alloc] init]; //instantiate refreshControl
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0]; //so that the refresh icon doesn't hover over any cells
    
}

- (void)didTweet:(Tweet *)tweet{
    [self.arrayOfTweets addObject:tweet];
    [self.tableView reloadData];
}

- (void)fetchTweets {
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.arrayOfTweets = tweets;
            [self.tableView reloadData];
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            [self.refreshControl endRefreshing]; //end refreshing
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTapLogout:(id)sender {
    NSLog(@"Entering On Tap");
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    //go to loginViewController
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ComposeSegue"]){
        NSLog(@"Entering Compose State");
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"DetailsSegue"]){
        NSLog(@"Entering Tweet Details");
        DetailsViewController *detailsViewController = [segue destinationViewController];
        UITableViewCell *tappedCell = sender; //sender is just table view cell that was tapped on
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell]; //grabs index path
        Tweet *tweet = self.arrayOfTweets[indexPath.row]; //right tweet associated with right row
        detailsViewController.tweet = tweet; //pass tweet to detailsViewController
    } else if ([segue.identifier isEqualToString:@"ReplySegue"]){
        //code
        UINavigationController *navigationController = [segue destinationViewController];
        ReplyViewController *replyViewController = (ReplyViewController*)navigationController.topViewController;
        replyViewController.delegate = self;
        UIButton *tappedButton = sender; //sender is just button that was tapped on
        Tweet *tweet = self.arrayOfTweets[tappedButton.tag];
        replyViewController.tweet = tweet; //pass tweet to replyViewController
    }
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.arrayOfTweets[indexPath.row]; //right tweet associated with right row
    
    //if favorited/retweeted, change the icon selection accordingly
    if (tweet.favorited){
        //highlight the heart icon
//        NSLog(@"Favorited Already");
        [cell.likeButton setSelected:YES];
    } else {
//        NSLog(@"Not Favorited yet");
        [cell.likeButton setSelected:NO];
    }
    if (tweet.retweeted){
        //highlight the retweet icon
//        NSLog(@"Retweeted Already");
        [cell.retweetButton setSelected:YES];
    } else {
//        NSLog(@"Not Retweeted yet");
        [cell.retweetButton setSelected:NO];
    }
    
    cell.usernameLabel.text = tweet.user.name;
    
    //add "@" to screen name
    NSString *partialString = tweet.user.screenName;
    NSString *fullScreenName = [@"@" stringByAppendingString:partialString];
    cell.screenNameLabel.text = fullScreenName;
    
    cell.timeStampLabel.text = tweet.createdAtString;

    cell.bodyLabel.text = tweet.text;
    cell.tweet = tweet;
        
    int retweetCount = tweet.retweetCount;
    NSString* retweetCountString = [NSString stringWithFormat:@"%i", retweetCount];
    [cell.retweetButton setTitle:retweetCountString forState:UIControlStateNormal];
    
    int likeCount = tweet.favoriteCount;
    NSString* likeCountString = [NSString stringWithFormat:@"%i", likeCount];
    [cell.likeButton setTitle:likeCountString forState:UIControlStateNormal];
    
    //assign button tag as index (for segue purposes - refer to prepareForSegue):
    cell.replyButton.tag = indexPath.row;
    
    //load in user photo
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    cell.profileView.image = nil; //reset last image
    [cell.profileView setImageWithURL:url];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}
 
 
@end

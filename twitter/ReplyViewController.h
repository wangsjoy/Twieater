//
//  ReplyViewController.h
//  twitter
//
//  Created by Sophia Joy Wang on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ReplyViewControllerDelegate

- (void)didTweet:(Tweet *)tweet;

@end

@interface ReplyViewController : UIViewController
@property (nonatomic, weak) id<ReplyViewControllerDelegate> delegate;
@property (nonatomic, strong) Tweet *tweet;

@end

NS_ASSUME_NONNULL_END

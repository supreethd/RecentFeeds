//
//  DetailViewController.h
//  RecentTweets
//
//  Created by Supreeth on 27/03/15.
//  Copyright (c) 2015 Supreeth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetFeed.h"
#import "TwitterManager.h"

@interface DetailViewController : UIViewController

@property (nonatomic , strong) TweetFeed *feed;


@end

//
//  TweetFeed.m
//  RecentTweets
//
//  Created by Supreeth on 27/03/15.
//  Copyright (c) 2015 Supreeth. All rights reserved.
//

#import "TweetFeed.h"

@implementation TweetFeed

+(TweetFeed *)initWithDictionary : (NSDictionary *)dict{
    
    TweetFeed *tweetFeed = [[TweetFeed alloc] init];
    tweetFeed.feedId = (NSString *)[dict valueForKey:@"id"];
    tweetFeed.feedText = (NSString *)[dict valueForKey:@"text"];
    tweetFeed.userName = (NSString *)[[dict valueForKey:@"user"] valueForKey:@"name"];
    tweetFeed.location = (NSString *)[[dict valueForKey:@"place"] valueForKey:@"name"];
    tweetFeed.createdDate = (NSString *)[dict valueForKey:@"created_at"];
    
    NSArray *coordinates =[[dict valueForKey:@"geo"] valueForKey:@"coordinates"];
    
    if (coordinates.count >= 1) {
        tweetFeed.latitude = [[coordinates objectAtIndex:0] floatValue];
    }
    
    if (coordinates.count >= 2) {
        tweetFeed.longitude = [[coordinates objectAtIndex:1] floatValue];
    }

    
    return tweetFeed;
    
}

@end

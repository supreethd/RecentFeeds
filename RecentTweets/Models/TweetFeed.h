//
//  TweetFeed.h
//  RecentTweets
//
//  Created by Supreeth on 27/03/15.
//  Copyright (c) 2015 Supreeth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetFeed : NSObject

@property (nonatomic,retain) NSString *feedId,*feedText,*userName,*location,*createdDate;
@property float latitude;
@property float longitude;

+(TweetFeed *)initWithDictionary : (NSDictionary *)dict;

@end

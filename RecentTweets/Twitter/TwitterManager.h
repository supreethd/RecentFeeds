//
//  TwitterManager.h
//  RecentTweets
//
//  Created by Supreeth on 26/03/15.
//  Copyright (c) 2015 Supreeth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterManager : NSObject

@property (nonatomic, copy) void (^completionHandler)(NSArray *feedObjects);

@property (nonatomic, copy) void (^completionHandlerWithError)(void);

@property (nonatomic, copy) void (^completionHandlerSuccess)(void);

- (void) fetchRecentTweetsWithLatitude:(float)latitude longitude:(float)longitude;
- (void) twitterRequestWithFeedId : (NSString *)feedId identifier : (NSString *)identifier;

@end

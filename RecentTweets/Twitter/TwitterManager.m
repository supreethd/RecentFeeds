//
//  TwitterManager.m
//  RecentTweets
//
//  Created by Supreeth on 26/03/15.
//  Copyright (c) 2015 Supreeth. All rights reserved.
//

#import "TwitterManager.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "TweetFeed.h"
#import "RecentTweetsConstants.h"

@implementation TwitterManager

//TODO : A method to be implemented for autherization check instead of implemeting in each method
//This method requests for recent feeds
- (void) fetchRecentTweetsWithLatitude:(float)latitude longitude:(float)longitude{
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    
    ACAccountType *accountType = [account
                                  accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType
                                     options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [account
                                         accountsWithAccountType:accountType];
             
             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                 
                 NSString *urlString = nil;
                 
                 if(latitude && longitude){
                     
                     urlString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/search/tweets.json?q=apple&geocode=%f%%2C%f%%2C1mi&result_type=recent&count=100",latitude,longitude];
                     
                 }else{
                     urlString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/search/tweets.json?q=apple&geocode=34.052235%%2C-118.243683%%2C1mi&result_type=recent&count=100"];
                     
                 }
                 
                 NSURL *requestURL = [NSURL URLWithString:urlString];
                 
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodGET
                                           URL:requestURL parameters:nil];
                 
                 [postRequest setAccount:twitterAccount];
                 
                 [postRequest performRequestWithHandler:
                  ^(NSData *responseData, NSHTTPURLResponse
                    *urlResponse, NSError *error)
                  {
                      
                      if ([urlResponse statusCode] != 200) {
                          return;
                      }
                      
                      NSDictionary *dataSource = [NSJSONSerialization
                                         JSONObjectWithData:responseData
                                         options:NSJSONReadingMutableLeaves
                                         error:&error];
                      
                      
                      if (dataSource.count != 0) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                             // NSLog(@"self.dataSource %@",self.dataSource);
                              NSArray *feedsObjects = [self parseRespose:dataSource];
                              
                              // call our delegate and tell it that feeds are ready for display
                              if (self.completionHandler && feedsObjects)
                              {
                                  self.completionHandler(feedsObjects);
                              }
                          });
                      }
                  }];
             }else{
                 dispatch_async(dispatch_get_main_queue(), ^{

                     if (self.completionHandlerWithError)
                     {
                         self.completionHandlerWithError();
                     }
                 });
             }
         } else {
             
             // Handle failure to get account access
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (self.completionHandlerWithError)
                 {
                     self.completionHandlerWithError();
                 }
             });
             
             NSLog(@"Error: %@", error.localizedDescription);
             return;
         }
     }];

}

//TODO : A method to be implemented for autherization check instead of implemeting in each method
//Method to requesting for retweet and add to favourite
- (void) twitterRequestWithFeedId : (NSString *)feedId identifier : (NSString *)identifier{
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    
    ACAccountType *accountType = [account
                                  accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType
                                     options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [account
                                         accountsWithAccountType:accountType];
             
             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                 
                 NSString *urlString = nil;
                 
                 if ([identifier isEqualToString:kRetweet]) {
                     
                     urlString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/retweet/%@.json",feedId];
                     
                 }else if([identifier isEqualToString:kAddtofavourites]){
                     urlString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/favorites/create.json?id=%@",feedId];
                 }
                 
                 SLRequest *requestURL = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:urlString] parameters:nil];
                 
                 [requestURL setAccount:twitterAccount];
                 
                 [requestURL performRequestWithHandler:
                  ^(NSData *responseData, NSHTTPURLResponse
                    *urlResponse, NSError *error)
                  {
                      
                      
                      if ([urlResponse statusCode] == 200) {
                      
                          dispatch_async(dispatch_get_main_queue(), ^{
                              if (self.completionHandlerSuccess)
                              {
                                  self.completionHandlerSuccess();
                              }
                          });
                      
                      }else  {
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                              if (self.completionHandlerWithError)
                              {
                                  self.completionHandlerWithError();
                              }
                          });
                      
                      }
                      
                  }];
             }else{
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         if (self.completionHandlerWithError)
                         {
                             self.completionHandlerWithError();
                         }
                     });
                 });
             }
         } else {
             
             // Handle failure to get account access
             dispatch_async(dispatch_get_main_queue(), ^{
                 
             });
             
             NSLog(@"Error: %@", error.localizedDescription);
             return;
         }
     }];

}


- (NSArray *) parseRespose : (NSDictionary *) response {
    
    NSMutableArray *feedsObjects = [[NSMutableArray alloc] init];
    
    if (response) {
        NSArray *feedsArray = [response valueForKey:@"statuses"];
        
        for (NSDictionary *dict in feedsArray) {
            TweetFeed *feed = [TweetFeed initWithDictionary:dict];
            
            if(dict){
                [feedsObjects addObject:feed];
            }
        }
    }
    
    return feedsObjects;
}

@end

//
//  DetailViewController.m
//  RecentTweets
//
//  Created by Supreeth on 27/03/15.
//  Copyright (c) 2015 Supreeth. All rights reserved.
//

#import "DetailViewController.h"
#import "RecentTweetsConstants.h"

@interface DetailViewController ()

@property (nonatomic , strong) TwitterManager *twitterManager;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *createdDate;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

- (IBAction)addToFavouriteButtonTapped:(id)sender;

- (IBAction)retweetButtonTapped:(id)sender;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.twitterManager = [[TwitterManager alloc] init];
    self.title = @"Detail Info";
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

# pragma mark - View Methods

- (void) setupView {
    
    if(self.feed.userName){
        
        self.userName.text = self.feed.userName;
    }
    
    if(self.feed.location){
        
        self.location.text = self.feed.location;
    }
    
    if(self.feed.createdDate){
        
        self.createdDate.text = self.feed.createdDate;
    }
    
    if(self.feed.feedText){
        
        self.tweetTextView.text = self.feed.feedText;
    }

}

# pragma mark - Event methods

- (IBAction)addToFavouriteButtonTapped:(id)sender {
    
    [self.twitterManager twitterRequestWithFeedId:self.feed.feedId identifier:kAddtofavourites];
    
    [self.twitterManager setCompletionHandlerSuccess: ^(void){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kAppName
                                                            message:@"Added to favourite successfully"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
    }];
    
    [self.twitterManager setCompletionHandlerWithError: ^(void){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kAppName
                                                            message:@"Something went wrong, Kindly try again later or Make sure twitter account has been configuered in device."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
    }];
    
}

- (IBAction)retweetButtonTapped:(id)sender {
    
    [self.twitterManager twitterRequestWithFeedId:self.feed.feedId identifier:kRetweet];
    
    [self.twitterManager setCompletionHandlerSuccess: ^(void){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kAppName
                                                            message:@"Retweet successful"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
    }];
    
    [self.twitterManager setCompletionHandlerWithError: ^(void){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kAppName
                                                            message:@"Something went wrong, Kindly try again later or Make sure twitter account has been configuered in device."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
    }];

}

@end

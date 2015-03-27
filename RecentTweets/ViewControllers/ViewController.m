//
//  ViewController.m
//  RecentTweets
//
//  Created by Supreeth on 26/03/15.
//  Copyright (c) 2015 Supreeth. All rights reserved.
//

#import "ViewController.h"
#import "TweetFeed.h"
#import "MapAnnotation.h"
#import "DetailViewController.h"
#import "RecentTweetsConstants.h"
#import "Helper.h"

@interface ViewController ()<CLLocationManagerDelegate>

@property (nonatomic , strong) CLLocationManager *locationManager;
@property (nonatomic , strong) NSMutableArray *feedObjects;
@property (nonatomic, strong) NSMutableArray *mapAnnotations;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.mapView.showsUserLocation = YES;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.feedObjects = [NSMutableArray array];
    
    self.title = kAppName;
    
    //Location will be updated on start
    //TO DO : updateLocation must be caled when app comes to foreground from background
    [self updateLocation];
    
    // create out annotations array
    self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:2];
}


- (void)updateLocation{
    
    if ([self.locationManager respondsToSelector:@selector
         (requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    
}


//Method to remove duplicate feeds when new response from twitter API is appended
- (void) removeDuplicates {
    
    NSMutableArray *uniqueArray = [NSMutableArray array];
    NSMutableSet *feedIds = [NSMutableSet set];
    for (TweetFeed *obj in self.feedObjects) {
        NSString *feedId = [obj feedId];
        if (![feedIds containsObject:feedId]) {
            [uniqueArray addObject:obj];
            [feedIds addObject:feedId];
        }
    }
    
    if(uniqueArray.count > 0){
        self.feedObjects = uniqueArray;
    }
    
    //Remove old tweets.
    if (self.feedObjects.count > 50) {
        [self.feedObjects removeObjectsInRange:NSMakeRange(50, self.feedObjects.count-50)];
    }
    
}

- (void) removeObjectsFrom : (NSMutableArray *) array IfObjectsMoreThan : (int) value {
    if (array.count > value) {
        [array removeObjectsInRange:NSMakeRange(value, array.count-value)];
    }
}

-(void)stopTimer
{
    if(_timer)
    {
        [_timer invalidate];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Methods


//Method to add annotataions on view
- (void) setupAnnotations{
    
    // remove any annotations that exist
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (self.feedObjects && self.feedObjects.count > 0) {
        
        for (TweetFeed *feed in self.feedObjects) {
            
            MapAnnotation *annotation = [[MapAnnotation alloc] init];
            annotation.feed = feed;
            [self.mapAnnotations addObject:annotation];
            
            // add just the city annotation
            [self.mapView addAnnotation:annotation];
            
        }
    }
}


#pragma mark - LocationDelegate

//This delegate will be called on location changed
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"MKUserLocation");
    
    //Zoom in to current location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 2000, 2000);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    [self.locationManager stopUpdatingLocation];
    
    //Stop timer before scheduling new one
    [self stopTimer];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:userLocation forKey:@"UserLocation"];
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:100.0f
                                                  target:self
                                                selector:@selector(fetchTweetsWithCordinateWithUserLocation:)
                                                userInfo:dict
                                                 repeats:YES];
        [_timer fire];
    }
    

    
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"didFailToLocateUserWithError");
   
}

#pragma mark - 

- (void) fetchTweetsWithCordinateWithUserLocation :(NSTimer *)timer{
    
    NSDictionary *dict = [timer userInfo];
   
    CLLocationCoordinate2D coordinate = [(MKUserLocation *)[dict objectForKey:@"UserLocation"] coordinate];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        TwitterManager *twitterManager = [[TwitterManager alloc] init];
        [twitterManager fetchRecentTweetsWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        
        [twitterManager setCompletionHandler: ^(NSArray *feedData){
            
            if(feedData){
                [self.feedObjects addObjectsFromArray:feedData];
            }
            [self removeDuplicates];
            [self setupAnnotations];
            
        }];
        
        [twitterManager setCompletionHandlerWithError: ^(void){
            
          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kAppName
                                                              message:@"Make sure Twitter account has been configured in device."
                                                             delegate:nil
                                                    cancelButtonTitle:@"Ok"
                                                    otherButtonTitles:nil, nil];
            [alertView show];
            
        }];

    });
    
}


#pragma mark - MKMapViewDelegate

// user tapped the disclosure button in the callout
//
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MapAnnotation class]])
    {
        
        DetailViewController *detailViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"DetailViewController"];
        
        detailViewController.feed = [(MapAnnotation *)annotation feed];
        
        [self.navigationController pushViewController:detailViewController animated:YES];
        
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *returnedAnnotationView = nil;
    
    // in case it's the user location, we already have an annotation, so just return nil
    if (![annotation isKindOfClass:[MKUserLocation class]])
    {
        if ([annotation isKindOfClass:[MapAnnotation class]]) // for Golden Gate Bridge
        {
            returnedAnnotationView = [MapAnnotation createViewAnnotationForMapView:self.mapView annotation:annotation];
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton setFrame:CGRectMake(0, 0, CGRectGetWidth(rightButton.frame)+10, CGRectGetHeight(rightButton.frame))];

            [rightButton setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];

            [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            ((MKPinAnnotationView *)returnedAnnotationView).rightCalloutAccessoryView = rightButton;
        }
    }
    
    return returnedAnnotationView;
}



@end

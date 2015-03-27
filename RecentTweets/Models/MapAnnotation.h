//
//  MapAnnotation.h
//  RecentTweets
//
//  Created by Supreeth on 27/03/15.
//  Copyright (c) 2015 Supreeth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "TweetFeed.h"

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic , strong) TweetFeed *feed;

+ (MKAnnotationView *)createViewAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation;

@end

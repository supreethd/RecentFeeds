//
//  ViewController.h
//  RecentTweets
//
//  Created by Supreeth on 26/03/15.
//  Copyright (c) 2015 Supreeth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterManager.h"
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate>
{
    NSTimer *_timer;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (void) removeDuplicates;
- (void) removeObjectsFrom : (NSMutableArray *) array IfObjectsMoreThan : (int) value;

@end


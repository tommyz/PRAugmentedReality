//
//  ViewController.h
//  PRAR-Simple
//
//  Created by Geoffroy Lesage on 3/27/14.
//  Copyright (c) 2014 Promet Solutions Inc,. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@class AppDelegate;

@interface ViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>
{
    AppDelegate *appDelegate;
    NSMutableArray *arData;
    NSMutableArray *annotations;
    BOOL isAdd;
}
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *userLoaction;
@property CLLocationDirection currentHeading;
@end

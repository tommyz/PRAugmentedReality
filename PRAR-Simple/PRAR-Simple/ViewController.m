//
//  ViewController.m
//  PRAR-Simple
//
//  Created by Geoffroy Lesage on 3/27/14.
//  Copyright (c) 2014 Promet Solutions Inc,. All rights reserved.
//

#import "ViewController.h"
#import "ARViewController.h"
#import "MyLocation.h"
#import "MKMapView+ZoomLevel.h"
#import "AppDelegate.h"
#import "ARGeoCoordinate.h"

@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _mapView = [MKMapView new];
    _mapView.frame = self.view.frame;
    _mapView.delegate = self;
    _mapView.showsBuildings = YES;
    _mapView.rotateEnabled = YES;
    [_mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
    _mapView.showsCompass = YES;
    [self.view addSubview:_mapView];
    
    if (![CLLocationManager locationServicesEnabled])
    {
        //提示用户无法进行定位操作
        NSLog(@"![CLLocationManager locationServicesEnabled]");
        //        _isUseAutoLocation = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postGPSErrorServices" object:nil];
    }
    else
    {
        NSLog(@"nnnnnn![CLLocationManager locationServicesEnabled]");
        
        NSLog(@"[CLLocationManager authorizationStatus]=%d",[CLLocationManager authorizationStatus]);
        if ([CLLocationManager authorizationStatus] == 2)
        {
            //            _isUseAutoLocation = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"postGPSErrorDenied" object:nil];
        }
        else
        {
            
            if (_locationManager == nil)
            {
                _locationManager = [[CLLocationManager alloc] init];
                _locationManager.delegate = self;
                _locationManager.distanceFilter = kCLDistanceFilterNone;
                _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            }
            
            // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
            if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [_locationManager requestWhenInUseAuthorization];
            }
            
            _mapView.showsUserLocation = YES;
            
            [_locationManager startUpdatingLocation];
            
            if ([CLLocationManager headingAvailable]) {
                _locationManager.headingFilter = 5;
                [_locationManager startUpdatingHeading];
            }
            
        }
    }
    
    UIButton *arButoon = [UIButton new];
    arButoon.frame = CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50);
    arButoon.backgroundColor = [UIColor redColor];
    [arButoon setTitle:@"AR1" forState:UIControlStateNormal];
    [arButoon addTarget:self action:@selector(showAR1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:arButoon];
    
    [self addLocationPoi];
    
}

-(void)addLocationPoi
{
    
    NSInteger toRemoveCount = _mapView.annotations.count;
    
    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:toRemoveCount];
    for (id annotation in _mapView.annotations)
    {
        if (annotation != _mapView.userLocation)
        {
            [toRemove addObject:annotation];
        }
    }
    
    [_mapView removeAnnotations:toRemove];
    
    if (arData == nil)
    {
        arData = [NSMutableArray new];
        annotations = [NSMutableArray new];
    }
    else
    {
        [arData removeAllObjects];
        [annotations removeAllObjects];
    }
    
    //    25.034054, 121.564411 101大樓
    //    25.057792, 121.532909 星巴克
    //    25.057223, 121.531561 時常在這裡
    //    25.056314, 121.532899 竹里館禪風茶趣
    //    25.057103, 121.536480 90 Night Club
//    25.051786, 121.533897 丼賞和食焼
//    NSDictionary *locatiomDic0 = @{
//                                   @"id" : [NSNumber numberWithInteger:0],
//                                   @"title" : @"101大樓",
//                                   @"lat" : [NSNumber numberWithDouble:25.034054],
//                                   @"lon" : [NSNumber numberWithDouble:121.564411]
//                                   };
    
    NSDictionary *locatiomDic0 = @{
                                   @"id" : [NSNumber numberWithInteger:0],
                                   @"title" : @"丼賞和食焼",
                                   @"lat" : [NSNumber numberWithDouble:25.051786],
                                   @"lon" : [NSNumber numberWithDouble:121.533897]
                                   };
    
    NSDictionary *locatiomDic1 = @{
                                   @"id" : [NSNumber numberWithInteger:1],
                                   @"title" : @"星巴克",
                                   @"lat" : [NSNumber numberWithDouble:25.057792],
                                   @"lon" : [NSNumber numberWithDouble:121.532909]
                                   };
    
    NSDictionary *locatiomDic2 = @{
                                   @"id" : [NSNumber numberWithInteger:2],
                                   @"title" : @"時常在這裡",
                                   @"lat" : [NSNumber numberWithDouble:25.057223],
                                   @"lon" : [NSNumber numberWithDouble:121.531561]
                                   };
    
    [arData addObject:locatiomDic0];
    [arData addObject:locatiomDic1];
    [arData addObject:locatiomDic2];
    
    
    /*
    NSDictionary *locatiomDic0 = @{
                                   @"id" : [NSNumber numberWithInteger:0],
                                   @"title" : @"Chicago",
                                   @"lat" : [NSNumber numberWithDouble:41.879535],
                                   @"lon" : [NSNumber numberWithDouble:-87.624333]
                                   };
    
    NSDictionary *locatiomDic1 = @{
                                   @"id" : [NSNumber numberWithInteger:1],
                                   @"title" : @"London",
                                   @"lat" : [NSNumber numberWithDouble:51.500152],
                                   @"lon" : [NSNumber numberWithDouble:-0.126236]
                                   };
    
    NSDictionary *locatiomDic2 = @{
                                   @"id" : [NSNumber numberWithInteger:2],
                                   @"title" : @"Paris",
                                   @"lat" : [NSNumber numberWithDouble:48.856667],
                                   @"lon" : [NSNumber numberWithDouble:2.350987]
                                   };
    
    NSDictionary *locatiomDic3 = @{
                                   @"id" : [NSNumber numberWithInteger:3],
                                   @"title" : @"Seattle",
                                   @"lat" : [NSNumber numberWithDouble:47.620973],
                                   @"lon" : [NSNumber numberWithDouble:-122.347276]
                                   };
    
    NSDictionary *locatiomDic4 = @{
                                   @"id" : [NSNumber numberWithInteger:4],
                                   @"title" : @"India",
                                   @"lat" : [NSNumber numberWithDouble:20.593684],
                                   @"lon" : [NSNumber numberWithDouble:78.96288]
                                   };
    
    NSDictionary *locatiomDic5 = @{
                                   @"id" : [NSNumber numberWithInteger:5],
                                   @"title" : @"Amsterdam",
                                   @"lat" : [NSNumber numberWithDouble:52.373801],
                                   @"lon" : [NSNumber numberWithDouble:4.890935]
                                   };
    
    NSDictionary *locatiomDic6 = @{
                                   @"id" : [NSNumber numberWithInteger:6],
                                   @"title" : @"Hawaii",
                                   @"lat" : [NSNumber numberWithDouble:19.611544],
                                   @"lon" : [NSNumber numberWithDouble:-155.665283]
                                   };
    
    NSDictionary *locatiomDic7 = @{
                                   @"id" : [NSNumber numberWithInteger:7],
                                   @"title" : @"New York City",
                                   @"lat" : [NSNumber numberWithDouble:40.756054],
                                   @"lon" : [NSNumber numberWithDouble:-73.986951]
                                   };
    
    NSDictionary *locatiomDic8 = @{
                                   @"id" : [NSNumber numberWithInteger:8],
                                   @"title" : @"Boston",
                                   @"lat" : [NSNumber numberWithDouble:42.35892],
                                   @"lon" : [NSNumber numberWithDouble:-71.05781]
                                   };
    
    NSDictionary *locatiomDic9 = @{
                                   @"id" : [NSNumber numberWithInteger:9],
                                   @"title" : @"Washington, DC",
                                   @"lat" : [NSNumber numberWithDouble:38.892091],
                                   @"lon" : [NSNumber numberWithDouble:-77.024055]
                                   };
    
    
    [arData addObject:locatiomDic0];
    [arData addObject:locatiomDic1];
    [arData addObject:locatiomDic2];
    [arData addObject:locatiomDic3];
    [arData addObject:locatiomDic4];
    [arData addObject:locatiomDic5];
    [arData addObject:locatiomDic6];
    [arData addObject:locatiomDic7];
    [arData addObject:locatiomDic8];
    [arData addObject:locatiomDic9];
    */
    for (NSInteger i = 0; i < arData.count; i++)
    {
        NSDictionary *somePlace = [arData objectAtIndex:i];
        NSInteger nid = [somePlace[@"id"] integerValue];
        NSString *arObjectName = somePlace[@"title"];
        
        CLLocationCoordinate2D coordinates;
        coordinates.latitude = [somePlace[@"lat"] doubleValue];
        coordinates.longitude = [somePlace[@"lon"] doubleValue];
        MyLocation *annotation = [[MyLocation alloc] initWithName:arObjectName coordinate:coordinates andId:nid] ;
        [_mapView addAnnotation:annotation];
        [annotations addObject:annotation];
    }
    
}

- (void)showAR1:(id)sender
{
    ARViewController *vc = [ARViewController new];
    vc.arData = arData;
    vc.userLoaction = _userLoaction;
    [self presentViewController:vc animated:YES completion:nil];
}

-(double)calculateDistanceFrom:(CLLocation*)userLocation withObjec:(CLLocation*)objectLocation
{
    return [objectLocation distanceFromLocation:userLocation];
}

-(void)setMapToUserLocation
{
    NSLog(@"setMapToUserLocation");
    if (!isCenterCoordinate)
    {
        isCenterCoordinate = YES;
        CLLocationCoordinate2D mapPin = { _userLoaction.coordinate.latitude, _userLoaction.coordinate.longitude};
        [_mapView setCenterCoordinate:mapPin zoomLevel:14 animated:YES];
    }
    
}

#pragma mark - Map View Delegate
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MyLocation class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
     
    return nil;
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"didUpdateLocations locations");
    CLLocation *currentLocation = [locations lastObject];
    NSTimeInterval eventInterval = [currentLocation.timestamp timeIntervalSinceNow];
    
    if (fabs(eventInterval) < 30 && fabs(eventInterval) >= 0)
    {
        if (currentLocation.horizontalAccuracy < 0)
        {
            return;
        }
        [self locationUpdate:currentLocation];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager didFailWithError");

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"didUpdateToLocation newLocation");
    // scroll to new location
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    if (newHeading.headingAccuracy < 0)
        return;
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(),^{
        if ([CLLocationManager locationServicesEnabled]) {
            if ([CLLocationManager headingAvailable]) {
                [_mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:NO];
            }else{
                [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:NO];
            }
        }else{
            [_mapView setUserTrackingMode:MKUserTrackingModeNone animated:NO];
        }
    });
}

- (void)locationUpdate:(CLLocation*)tempLoaction
{
    _userLoaction = tempLoaction;
    NSLog(@"_userLoaction.coordinate.latitude=%.5f",_userLoaction.coordinate.latitude);
    NSLog(@"_userLoaction.coordinate.longitude=%.5f",_userLoaction.coordinate.longitude);
    
    [self setMapToUserLocation];

}

@end

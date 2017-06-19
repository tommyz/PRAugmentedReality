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

#define LOC_REFRESH_TIMER   10  //seconds
#define MAP_SPAN            804 // The span of the map view

@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidAppear:(BOOL)animated // or wherever works for you
{
    [super viewDidAppear:animated];
    /*
    if ([_mapView respondsToSelector:@selector(camera)]) {
        MKMapCamera *newCamera = [[_mapView camera] copy];
        [newCamera setHeading:90.0]; // or newCamera.heading + 90.0 % 360.0
        [_mapView setCamera:newCamera animated:YES];
    }
     */
}

- (void)viewDidDisappear:(BOOL)animated // or wherever works for you
{
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = (AppDelegate  *)[[UIApplication sharedApplication] delegate];
    
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
    
    UIButton *aButton = [UIButton new];
    aButton.frame = CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50);
    aButton.backgroundColor = [UIColor redColor];
    [aButton setTitle:@"AR" forState:UIControlStateNormal];
    [aButton addTarget:self action:@selector(showAR:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aButton];
    
    
    [self addLocationPoi];
    
    
}

-(void)addLocationPoi
{
    NSLog(@"addLocationPoi");
    //	[google_mv removeAnnotations:google_mv.annotations];
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
    //    NSLog(@"[list_data count] is %d",[list_data count]);
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
    
    NSDictionary *locatiomDic0 = @{
                                   @"nid" : [NSNumber numberWithInteger:0],
                                   @"title" : @"101大樓",
                                   @"lat" : [NSNumber numberWithDouble:25.034054],
                                   @"lon" : [NSNumber numberWithDouble:121.564411]
                                   };
    
    NSDictionary *locatiomDic1 = @{
                                   @"nid" : [NSNumber numberWithInteger:1],
                                   @"title" : @"星巴克",
                                   @"lat" : [NSNumber numberWithDouble:25.057792],
                                   @"lon" : [NSNumber numberWithDouble:121.532909]
                                   };
    
    NSDictionary *locatiomDic2 = @{
                                   @"nid" : [NSNumber numberWithInteger:2],
                                   @"title" : @"時常在這裡",
                                   @"lat" : [NSNumber numberWithDouble:25.057223],
                                   @"lon" : [NSNumber numberWithDouble:121.531561]
                                   };
    
    [arData addObject:locatiomDic0];
    [arData addObject:locatiomDic1];
    [arData addObject:locatiomDic2];
    
    for (NSInteger i = 0; i < arData.count; i++)
    {
        NSDictionary *somePlace = [arData objectAtIndex:i];
        NSInteger nid = [somePlace[@"nid"] integerValue];
        NSString *arObjectName = somePlace[@"title"];
        
        CLLocationCoordinate2D coordinates;
        coordinates.latitude = [somePlace[@"lat"] doubleValue];
        coordinates.longitude = [somePlace[@"lon"] doubleValue];
        MyLocation *annotation = [[MyLocation alloc] initWithName:arObjectName coordinate:coordinates andId:nid] ;
        [_mapView addAnnotation:annotation];
        [annotations addObject:annotation];
    }
    
}

- (MKCoordinateRegion)regionFromLocations
{
    CLLocationCoordinate2D upper = [_userLoaction coordinate];
    CLLocationCoordinate2D lower = [_userLoaction coordinate];
    
    // FIND LIMITS
    for(MyLocation *eachLocation in annotations) {
        if([eachLocation coordinate].latitude > upper.latitude) upper.latitude = [eachLocation coordinate].latitude;
        if([eachLocation coordinate].latitude < lower.latitude) lower.latitude = [eachLocation coordinate].latitude;
        if([eachLocation coordinate].longitude > upper.longitude) upper.longitude = [eachLocation coordinate].longitude;
        if([eachLocation coordinate].longitude < lower.longitude) lower.longitude = [eachLocation coordinate].longitude;
    }
    
    // FIND REGION
    MKCoordinateSpan locationSpan;
    locationSpan.latitudeDelta = upper.latitude - lower.latitude;
    locationSpan.longitudeDelta = upper.longitude - lower.longitude;
    CLLocationCoordinate2D locationCenter;
    locationCenter.latitude = (upper.latitude + lower.latitude) / 2;
    locationCenter.longitude = (upper.longitude + lower.longitude) / 2;
    
    MKCoordinateRegion region = MKCoordinateRegionMake(locationCenter, locationSpan);
    return region;
}

- (MKMapRect)MKMapRectForCoordinateRegion:(MKCoordinateRegion)region
{
    MKMapPoint a = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
                                                                      region.center.latitude + region.span.latitudeDelta / 2,
                                                                      region.center.longitude - region.span.longitudeDelta / 2));
    MKMapPoint b = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
                                                                      region.center.latitude - region.span.latitudeDelta / 2,
                                                                      region.center.longitude + region.span.longitudeDelta / 2));
    return MKMapRectMake(MIN(a.x,b.x), MIN(a.y,b.y), ABS(a.x-b.x), ABS(a.y-b.y));
}

- (void)resetMapRect;
{
    NSLog(@"resetMapRect");
//    NSLog(@"annotations=%@",annotations);
    MKMapRect zoomRect = MKMapRectNull;
    zoomRect = [self MKMapRectForCoordinateRegion:[self regionFromLocations]];
    [_mapView setVisibleMapRect:zoomRect animated:YES];
    
}

- (void)showAR:(id)sender
{
    ARViewController *vc = [ARViewController new];
    vc.arData = arData;
    vc.userLoaction = _userLoaction;
    [self presentViewController:vc animated:YES completion:nil];
}




-(void)setMapToUserLocation
{
    NSLog(@"setMapToUserLocation");
    CLLocationCoordinate2D mapPin = { _userLoaction.coordinate.latitude, _userLoaction.coordinate.longitude};
    [_mapView setCenterCoordinate:mapPin zoomLevel:11 animated:YES];

//    [self resetMapRect];
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
    //    NSLog(@"locationManager didUpdateLocations");
    CLLocation *currentLocation = [locations lastObject];
    NSTimeInterval eventInterval = [currentLocation.timestamp timeIntervalSinceNow];
    
    if (fabs(eventInterval) < 30 && fabs(eventInterval) >= 0)
    {
        if (currentLocation.horizontalAccuracy < 0)
        {
            return;
        }
//        [_locationManager stopUpdatingLocation];
        
        [self locationUpdate:currentLocation];
        
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //    NSLog(@"locationManager didFailWithError");
    //    _isUseAutoLocation = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postGPSFirstError" object:nil];
    //    [[AlertProcessManager shareInstance] dismissLoadingAlert];
    NSLog(@"locationManager didFailWithError error.code=%ld",(long)error.code);
    if (error.code == kCLErrorDenied)
    {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"didUpdateToLocation");
    // scroll to new location
    /*
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 2000, 2000);
    [self.mapView setRegion:region animated:YES];
    
    // set position of "beam" to position of blue dot
    self.headingAngleView.center = [self.mapView convertCoordinate:newLocation.coordinate toPointToView:self.view];
    // slightly adjust position of beam
    self.headingAngleView.frameTop -= self.headingAngleView.frameHeight/2 + 8;
     */
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
//    NSLog(@"didUpdateHeading");
    
    if (newHeading.headingAccuracy < 0)
        return;
    
    // Use the true heading if it is valid.
    CLLocationDirection theHeading = ((newHeading.trueHeading > 0) ?
                                       newHeading.trueHeading : newHeading.magneticHeading);
    
    self.currentHeading = theHeading;
    [self updateHeadingDisplays];
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
    NSLog(@"didChangeUserTrackingMode");
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
    appDelegate.currentLocation = _userLoaction;
    //    NSLog(@"_userLoaction=%@",_userLoaction);
    [self setMapToUserLocation];
    /*
     MKMapCamera *camera = [MKMapCamera new];
     camera.centerCoordinate = _userLoaction.coordinate;
     camera.heading = 0;
     camera.pitch = 45;
     camera.altitude = 700;
     [self.mapView setCamera:camera animated:YES];
     */
}

- (void)updateHeadingDisplays
{
    
}
@end

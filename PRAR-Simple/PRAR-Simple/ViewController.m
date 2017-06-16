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

#define LOC_REFRESH_TIMER   10  //seconds
#define MAP_SPAN            804 // The span of the map view

@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mapView = [MKMapView new];
    _mapView.frame = self.view.frame;
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
            
        }
    }
    
    UIButton *aButton = [UIButton new];
    aButton.frame = CGRectMake(0, 20, self.view.frame.size.width, 50);
    aButton.backgroundColor = [UIColor redColor];
    [aButton setTitle:@"AR" forState:UIControlStateNormal];
    [aButton addTarget:self action:@selector(showAR:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aButton];
    
    
//    25.034054, 121.564411 101大樓
//    25.057792, 121.532909 星巴克
//    25.057223, 121.531561 時常在這裡
//    25.056314, 121.532899 竹里館禪風茶趣
//    25.057103, 121.536480 90 Night Club
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
    
    NSDictionary *locatiomDic = @{
                                  @"nid" : @"0",
                                  @"title" : @"101大樓",
                                  @"lat" : @"25.034054",
                                  @"lon" : @"121.564411"
                                  };
    
    [arData addObject:locatiomDic];
    
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
    
//
//    [self performSelector:@selector(resetMapRect) withObject:nil afterDelay:0.5f];
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
//    [_mapView showAnnotations:annotations animated:YES];
    /*
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in _mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [_mapView setVisibleMapRect:zoomRect animated:YES];
     */
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


#pragma mark - Map View Delegate

-(void)setMapToUserLocation
{
    NSLog(@"setMapToUserLocation");
    /*
    NSLog(@"_mapView.userLocation.location.coordinate.latitude=%.5f",_mapView.userLocation.location.coordinate.latitude);
    NSLog(@"_mapView.userLocation.location.coordinate.longitude=%.5f",_mapView.userLocation.location.coordinate.longitude);
    
    NSLog(@"_userLoaction.coordinate.latitude=%.5f",_userLoaction.coordinate.latitude);
    NSLog(@"_userLoaction.coordinate.longitude=%.5f",_userLoaction.coordinate.longitude);
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(_userLoaction.coordinate.latitude,
                                                                                                  _userLoaction.coordinate.longitude),
                                                                       MAP_SPAN,
                                                                       MAP_SPAN);
    [_mapView setRegion:[_mapView regionThatFits:viewRegion] animated:NO];
    */
    [self resetMapRect];
//    [UIView commitAnimations];
    
}

-(void)plotAllPlaces
{
    /*
    for (NSDictionary *place in arData) {
        [self plotPlace:place andId:[place[@"nid"] integerValue]];
    }
     */
}
-(void)plotPlace:(NSDictionary*)somePlace andId:(NSInteger)nid
{
    /*
    NSString *arObjectName = somePlace[@"title"];
    
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = [somePlace[@"lat"] doubleValue];
    coordinates.longitude = [somePlace[@"lon"] doubleValue];
    MyLocation *annotation = [[MyLocation alloc] initWithName:arObjectName coordinate:coordinates andId:nid] ;
    [_mapView addAnnotation:annotation];
     */
}

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

- (void)locationUpdate:(CLLocation*)tempLoaction
{
    _userLoaction = tempLoaction;
//    NSLog(@"_userLoaction=%@",_userLoaction);
    [self setMapToUserLocation];
}


@end

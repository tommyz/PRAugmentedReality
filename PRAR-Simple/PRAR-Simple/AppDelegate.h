//
//  AppDelegate.h
//  PRAR-Simple
//
//  Created by Geoffroy Lesage on 3/27/14.
//  Copyright (c) 2014 Promet Solutions Inc,. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) CLLocation *currentLocation;
@end

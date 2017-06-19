//
//  CLLocationExtensions.h
//  Radar
//
//  Created by Sundance RD on 2011/7/5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <math.h>

@interface CLLocation(Extensions)
- (CLLocationDirection)azimuthToLocation:(const CLLocation *)target;
@end

//
//  CLLocationExtensions.m
//  Radar
//
//  Created by Sundance RD on 2011/7/5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLLocationExtensions.h"

#define kEquatorialRadius 6378137 // 赤道半径

@implementation CLLocation(Extensions)

- (CLLocationDirection)azimuthToLocation:(const CLLocation *)target
{
    CLLocationDirection dx = kEquatorialRadius * (target.coordinate.latitude - self.coordinate.latitude) * cos(self.coordinate.longitude);
    CLLocationDirection dy = kEquatorialRadius * (target.coordinate.longitude - self.coordinate.longitude);
    return atan2(dy, dx);
}

@end

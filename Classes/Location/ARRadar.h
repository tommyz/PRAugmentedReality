//
//  ARRadar.h
//  PRAR-Example
//
//  Created by ANDREW KUCHARSKI on 8/29/13.
//  Copyright (c) 2013 Geoffroy Lesage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface ARRadar : UIView
{
    UIImageView *radarMV;
    UIImageView *radarBars;
    NSMutableDictionary *theSpots;
    NSArray *thePoints;
}

- (id)initWithFrame:(CGRect)frame withSpots:(NSArray*)spots;
- (id)initWithFrame:(CGRect)frame withSpots:(NSArray*)spots withLocation:(CLLocationCoordinate2D)location;

- (void)moveDots:(int)angle;

@end

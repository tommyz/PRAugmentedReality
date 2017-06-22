//
//  ARMarker.m
//  ARView
//
//  Created by Niels W Hansen on 19/12/2009.
//  Copyright 2009 Agilite Software. All rights reserved.
//  Modified by Alasdair Allan on 07/04/2010.
//  Modifications Copyright 2010 Babilim Light Industries. All rights reserved.
//

#import "ARMarker.h"
#import "ARGeoCoordinate.h"

#define origin_x 5

#define BOX_WIDTH 150
#define BOX_HEIGHT 100
#define btn_WIDTH 29

@implementation ARMarker

- (id)initForCoordinate:(ARGeoCoordinate *)coordinate {
	
	//CGRect theFrame = CGRectMake(0, 0, BOX_WIDTH, BOX_HEIGHT);
	//CGRect theFrame = CGRectMake(0, 0, BOX_WIDTH, BOX_HEIGHT/2);
	CGRect theFrame = CGRectMake(0, 6, BOX_WIDTH, 34);
	//NSLog( @"ARMarker:initForCoordinate: coordinate = %@", coordinate );
	
	if (self = [super initWithFrame:theFrame]) {
		
		UILabel *titleLabel	= [[UILabel alloc] initWithFrame:CGRectMake(origin_x, 4, BOX_WIDTH - btn_WIDTH - (origin_x * 2), 17.0)];
		
		//titleLabel.backgroundColor = [UIColor colorWithWhite:.3 alpha:.8];
		titleLabel.backgroundColor = [UIColor clearColor];
		//titleLabel.textColor = [UIColor whiteColor];
		titleLabel.textColor = [UIColor blackColor];
//		titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textAlignment = NSTextAlignmentLeft;
		titleLabel.text = coordinate.coordinateTitle;
		//[titleLabel sizeToFit];
		//[titleLabel setFrame: CGRectMake(BOX_WIDTH / 2.0 - titleLabel.bounds.size.width / 2.0 - 4.0, 0, titleLabel.bounds.size.width + 8.0, titleLabel.bounds.size.height + 8.0)];
		
		UILabel *disLabel = [[UILabel alloc] initWithFrame:CGRectMake(origin_x, 20, BOX_WIDTH - btn_WIDTH - (origin_x * 2), 14.0)];
		
		disLabel.backgroundColor = [UIColor clearColor];
//		disLabel.backgroundColor = [UIColor redColor];
		disLabel.textColor = [UIColor blackColor];
//		disLabel.textColor = [UIColor whiteColor];
//		disLabel.textAlignment = UITextAlignmentCenter;
        disLabel.textAlignment = NSTextAlignmentLeft;
        int line = [coordinate.distance intValue];
//        NSLog(@"coordinate.distance is %@",coordinate.distance);
//        NSLog(@"line is %d",line);
        if (line > 1000) {
            int ddd_line_km = (int)line / 1000.0f;
            disLabel.text = [NSString stringWithFormat:@"%dkm", ddd_line_km];
        }else {
            disLabel.text = [NSString stringWithFormat:@"%dm", line];
        }
//		disLabel.text = [NSString stringWithFormat:@"%@  m",coordinate.distance];
		//[disLabel sizeToFit];
		//[disLabel setFrame: CGRectMake(BOX_WIDTH / 2.0 - disLabel.bounds.size.width / 2.0 - 4.0, 20, disLabel.bounds.size.width + 8.0, disLabel.bounds.size.height + 8.0)];
		
		/*
		UIImageView *pointView	= [[UIImageView alloc] initWithFrame:CGRectZero];
		pointView.image = [UIImage imageNamed:@"point.png"];
		pointView.frame = CGRectMake((int)(BOX_WIDTH / 2.0 - pointView.image.size.width / 2.0), (int)(BOX_HEIGHT / 2.0 - pointView.image.size.height / 2.0), pointView.image.size.width, pointView.image.size.height);
		*/
		/*
		UIButton *buttonView = [UIButton buttonWithType:UIButtonTypeInfoLight];
		buttonView.frame = CGRectMake((int)(BOX_WIDTH / 2.0 + 20.0 - buttonView.bounds.size.width / 2.0), 
									  (int)(BOX_HEIGHT / 2.0 - buttonView.bounds.size.height/2.0), 
									  buttonView.bounds.size.width, 
									  buttonView.bounds.size.height );
		 */
		/*
		UIButton *buttonView = [UIButton buttonWithType:UIButtonTypeCustom];
		buttonView.frame = CGRectMake(0, 0, BOX_WIDTH, BOX_HEIGHT);
		[buttonView addTarget:self action:@selector(infoButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
		*/
		[self addSubview:titleLabel];
		//[self addSubview:pointView];
		[self addSubview:disLabel];
		//[self addSubview:buttonView];
		//[self setBackgroundColor:[UIColor clearColor]];
		[self setBackgroundColor:[UIColor whiteColor]];
//		[self setBackgroundColor:[UIColor colorWithRed:(float)204/256 green:(float)204/256 blue:(float)204/256 alpha:0.5]];
//        [self setBackgroundColor:[UIColor colorWithRed:(float)204/256 green:(float)204/256 blue:(float)204/256 alpha:0.5]];
		
		//NSLog( @"ARMarker:initForCoordinate: title = %@", coordinate.coordinateTitle );
		//NSLog( @"ARMarker:initForCoordinate: theFrame.size.width = %.3f, height = %.3f", theFrame.size.width, theFrame.size.height);
		//NSLog( @"ARMarker:initForCoordinate: titleLabel.frame.size.width = %.3f, height = %.3f", titleLabel.frame.size.width, titleLabel.frame.size.height);	
		//NSLog( @"ARMarker:initForCoordinate: pointView.frame.width = %.3f, height = %.3f", pointView.frame.size.width, pointView.frame.size.height);	
	}
	
	
    return self;
}

/*
-(void)infoButtonPushed:(id)notification {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Button Pushed" message:@"Pushed the button." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];  
    [alert show];  
    [alert release];  
}
*/



@end

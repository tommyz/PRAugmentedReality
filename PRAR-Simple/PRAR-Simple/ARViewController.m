//
//  ARViewController.m
//  PRAR-Simple
//
//  Created by tommy su on 2017/6/16.
//  Copyright © 2017年 GeoffroyLesage. All rights reserved.
//

#import "ARViewController.h"

#define NUMBER_OF_POINTS    20

@interface ARViewController ()

@property (nonatomic, strong) PRARManager *prARManager;

@end

@implementation ARViewController

-(void)viewDidAppear:(BOOL)animated
{
    // Initialize your current location as 0,0 (since it works with our randomly generated locations)
//    CLLocationCoordinate2D locationCoordinates = CLLocationCoordinate2DMake(0, 0);
    
    [self.prARManager startARWithData:[self getDummyData] forLocation:_userLoaction.coordinate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.prARManager = [[PRARManager alloc] initWithSize:self.view.frame.size delegate:self showRadar:YES];
    
    UIButton *aButton = [UIButton new];
    aButton.frame = CGRectMake(0, 20, self.view.frame.size.width, 50);
    aButton.backgroundColor = [UIColor redColor];
    [aButton setTitle:@"back" forState:UIControlStateNormal];
    [aButton addTarget:self action:@selector(backVC:) forControlEvents:UIControlEventTouchUpInside];
    aButton.tag = 999999;
    [self.view addSubview:aButton];
    [self.view bringSubviewToFront:aButton];
}

- (void)backVC:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Dummy AR Data

// Creates data for `NUMBER_OF_POINTS` AR Objects
-(NSArray*)getDummyData
{
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:NUMBER_OF_POINTS];
    
    srand48(time(0));
    for (int i=0; i<NUMBER_OF_POINTS; i++)
    {
        CLLocationCoordinate2D pointCoordinates = [self getRandomLocation];
        NSDictionary *point = [self createPointWithId:i at:pointCoordinates];
        [points addObject:point];
    }
    
    return [NSArray arrayWithArray:points];
}

// Returns a random location
-(CLLocationCoordinate2D)getRandomLocation
{
    double latRand = drand48() * 90.0;
    double lonRand = drand48() * 180.0;
    double latSign = drand48();
    double lonSign = drand48();
    
    CLLocationCoordinate2D locCoordinates = CLLocationCoordinate2DMake(latSign > 0.5 ? latRand : -latRand,
                                                                       lonSign > 0.5 ? lonRand*2 : -lonRand*2);
    return locCoordinates;
}

// Creates the Data for an AR Object at a given location
-(NSDictionary*)createPointWithId:(int)the_id at:(CLLocationCoordinate2D)locCoordinates
{
    NSDictionary *point = @{
                            @"id" : @(the_id),
                            @"title" : [NSString stringWithFormat:@"Place Num %d", the_id],
                            @"lon" : @(locCoordinates.longitude),
                            @"lat" : @(locCoordinates.latitude)
                            };
    return point;
}


#pragma mark - PRARManager Delegate

-(void)prarDidSetupAR:(UIView *)arView withCameraLayer:(AVCaptureVideoPreviewLayer *)cameraLayer andRadarView:(UIView *)radar
{
    NSLog(@"Finished displaying ARObjects");
    
    [self.view.layer addSublayer:cameraLayer];
    [self.view addSubview:arView];
    
    [self.view bringSubviewToFront:[self.view viewWithTag:AR_VIEW_TAG]];
    
    [self.view addSubview:radar];
    
    [self.view bringSubviewToFront:[self.view viewWithTag:999999]];
    
}

-(void)prarUpdateFrame:(CGRect)arViewFrame
{
    [[self.view viewWithTag:AR_VIEW_TAG] setFrame:arViewFrame];
}

-(void)prarGotProblem:(NSString *)problemTitle withDetails:(NSString *)problemDetails
{
    [self alert:problemTitle withDetails:problemDetails];
}


- (void)alert:(NSString*)title withDetails:(NSString*)details {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:details
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}
@end

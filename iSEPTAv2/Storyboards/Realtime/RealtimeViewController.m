//
//  RealtimeViewController.m
//  iSEPTA
//
//  Created by septa on 7/19/13.
//  Copyright (c) 2013 SEPTA. All rights reserved.
//

#import "RealtimeViewController.h"


@interface RealtimeViewController ()

@end

@implementation RealtimeViewController
{
    UIImageView *_backgroundImage;
    BOOL _startTest;
    int _counter;
    
    SecondMenuAlertImageCycle _loopState;
    UIView *_testView;
    
//    MMDrawerController *_drawerController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{

    [self.lblNextToArrive setAccessibilityElementsHidden:YES];
    [self.lblTrainView setAccessibilityElementsHidden:YES];
    
    Reachability *network = [Reachability reachabilityForInternetConnection];
    if ( ![network isReachable] )
    {
        // Disable realtime buttons if no internet connection is available
        
//        [self.btnNextToArrive setEnabled:NO];
//        [self.btnSystemStatus setEnabled:NO];
//        [self.btnTrainView setEnabled:NO];
//        [self.btnTransitView setEnabled:NO];
//        [self.btnFindNearestLocation setEnabled:NO];
        
    }

    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self changeOrientation:currentOrientation];
    
//    if ( _startTest )
//    {
//        [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(popTheVC) userInfo:nil repeats:NO];
//    }

    
    // Hold for 1 sec, transition for 1 sec.
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(loopImages) userInfo:nil repeats:YES];

    
}


-(void) popTheVC
{
    _counter++;
    NSLog(@"Transition: %d", _counter);
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MemoryTestStoryboard" bundle:nil];
//    MapMemoryTestViewController *tvVC = (MapMemoryTestViewController*)[storyboard instantiateInitialViewController];
//    [tvVC setCounter: _counter];
//    [self.navigationController pushViewController:tvVC animated:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TrainSlidingStoryboard" bundle:nil];
    TrainViewViewController *tvVC = (TrainViewViewController*)[storyboard instantiateInitialViewController];
    [self.navigationController pushViewController:tvVC animated:YES];

}

//-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    if ( !UIInterfaceOrientationIsLandscape(fromInterfaceOrientation) )
//    {
//        [_backgroundImage setTransform: CGAffineTransformMakeRotation( -0.5*M_PI )];
//        [_backgroundImage setFrame:CGRectMake(0, 0, 480, 300)];
//    }
//    else
//    {
//        [_backgroundImage setTransform: CGAffineTransformMakeRotation( 0 )];
//        [_backgroundImage setFrame:CGRectMake(0, 0, 320, 460)];
//    }
//}


//-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//
//    
//    if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
//    {
//        [_backgroundImage setTransform: CGAffineTransformMakeRotation( -0.5*M_PI )];
//        [_backgroundImage setFrame:CGRectMake(0, 0, 480, 300)];
//    }
//    else
//    {
//        [_backgroundImage setTransform: CGAffineTransformMakeRotation( 0 )];
//        [_backgroundImage setFrame:CGRectMake(0, 0, 320, 460)];
//    }
//
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _startTest = NO;
    _counter = 0;
    
    _loopState = kSecondMenuAlertImageNone;
    
    // Do any additional setup after loading the view.

//    [self.view setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainBackground.png"] ] ];  // Does not work
    
//    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainBackground.png"] ];
//    _backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BG_pattern.png"] ];
//    backgroundImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [backgroundImage setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [backgroundImage setFrame:CGRectMake(0, 0, 320, 460)];

//    [self.view addSubview:_backgroundImage];
//    [self.view sendSubviewToBack:_backgroundImage];
    
//    [[UINavigationBar appearance] setTintColor: [UIColor blackColor] ];
    
    
    // TabBar BS
//    UITabBarItem *tbi = self.tabBarController.tabBarItem;
//    [tbi setFinishedSelectedImage:[UIImage imageNamed:@"tabRealtimeIcon.png"] withFinishedUnselectedImage: [UIImage imageNamed:@"tabRealtimeIconSelected.png"] ];
    
    
//    [[[self tabBarController] tabBar] setSelectionIndicatorImage: [UIImage imageNamed:@"tabRealtimeIconSelected.png"] ];

    
//    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabMapIconSelected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabMapIcon.png"] ];
    
    
    NSString *version = [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    NSLog(@"Version #: %@", version);
    
    
    UIColor *backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"newBG_pattern.png"] ];
    [self.view setBackgroundColor: backgroundColor];
    
    
    UIImage *logo = [UIImage imageNamed:@"SEPTA_logo.png"];

    SEPTATitle *newView = [[SEPTATitle alloc] initWithFrame:CGRectMake(0, 0, logo.size.width, logo.size.height) andWithTitle:@"Realtime"];
    [newView setImage: logo];
    
    [self.navigationItem setTitleView: newView];
    [self.navigationItem.titleView setNeedsDisplay];
    
//    [self.view bringSubviewToFront:newView];
    
    
//    [[UITabBarItem appearance] setTitleTextAttributes:@{
//                                 UITextAttributeFont : [UIFont fontWithName:@"TrebuchetMS" size:40.0f],
//                            UITextAttributeTextColor : [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],}
//                                             forState:UIControlStateNormal];
//    
//    [[UINavigationBar appearance] setTitleTextAttributes:@{
//                                    UITextAttributeFont : [UIFont fontWithName:@"TrebuchetMS" size:20.0f],
//                               UITextAttributeTextColor : [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]}];

//    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:107.0/256.0 green:145.0/256.0 blue:35.0/256.0 alpha:1.0]];
    
//    [self setTitle:@"Realtime"];

    
    [self testImage];
    
}

-(void) loopImages
{
    
    
    
    switch (_loopState)
    {
        case kSecondMenuAlertImageAlert:

            break;
            
        case kSecondMenuAlertImageAdvisory:
            
            break;
            
        case kSecondMenuAlertImageDetour:
            
            break;
            
        default:
            break;
    }
    
    //    [UIView animateWithDuration:1.5f
    //                          delay:0.5f
    //                        options:UIViewAnimationCurveEaseInOut
    //                     animations:^{
    //                         [alertImg setAlpha:0.0f];
    //                         [advisoryImg setAlpha:1.0f];
    //                     }
    //                     completion:^(BOOL finished) {
    //
    //
    //                         [UIView animateWithDuration:1.5f
    //                                               delay:0.5f
    //                                             options: UIViewAnimationOptionOverrideInheritedCurve | UIViewAnimationOptionOverrideInheritedDuration | UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
    //                                          animations:^{
    //                                              [UIView setAnimationRepeatCount:2.5];
    //                                              [advisoryImg setAlpha:0.0f];
    //                                              [detourImg setAlpha:1.0f];
    //                                          }
    //                                          completion:^(BOOL finished) {
    //                                              NSLog(@"Animation complete");
    //                                          }];
    //                     }];

    
}

-(void) testImage
{
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"second-menu.png"] ];
//
////    [imageView setFrame:CGRectMake(0, self.view.frame.size.height - 60, imageView.frame.size.width, imageView.frame.size.height)];
//    
//    [self.view addSubview: imageView];
//    [self.view bringSubviewToFront: imageView];

//    [self.navigationItem.rightBarButtonItem setImage: [UIImage imageNamed:@"second-menu.png"] ];
    
    
    
//    _testView = [[UIView alloc] initWithFrame:CGRectMake(10, 260, 50, 37.5)];
//    
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 40, 30)];
//    imgView.image = [UIImage imageNamed:@"second-menu.png"];
//    imgView.contentMode = UIViewContentModeCenter;
//    
//    UIImageView *alertImg = [[UIImageView alloc] initWithFrame:CGRectMake(23, 0, 40/2.0f, 30/2.0f)];
//    [alertImg setImage: [UIImage imageNamed:@"system_status_alert.png"] ];
//    
//    UIImageView *advisoryImg = [[UIImageView alloc] initWithFrame:CGRectMake(23, 0, 40/2.0f, 30/2.0f)];
//    [advisoryImg setImage: [UIImage imageNamed:@"system_status_advisory.png"] ];
//    [advisoryImg setAlpha:0.0f];
//    
//    UIImageView *detourImg = [[UIImageView alloc] initWithFrame:CGRectMake(23, 0, 40/2.0f, 30/2.0f)];
//    [detourImg setImage: [UIImage imageNamed:@"system_status_detour.png"] ];
//    [detourImg setAlpha:0.0f];


    
//    MenuAlertsImageView *mView = [[MenuAlertsImageView alloc] initWithFrame: CGRectMake(10, 260, 50, 37.5)];
//    
//    [mView setBaseImage: [UIImage imageNamed:@"second-menu.png"] ];
//    
//    [mView addAlert: kMenuAlertsImageAlerts];
//    [mView addAlert: kMenuAlertsImageDetours];
//    [mView addAlert: kMenuAlertsImageAdvisories];
//    
//    [self.view addSubview: mView];
//    
//    [mView startLoop];

    
    
    /*
     
     ObjectView: UIImageView
     
     [object addAlert: kSecondMenuAlert];
     [object addAlert: kSecondMenuAdvisory];
     [object addAlert: kSecondMenuDetour];
     
     [object removeAllAlerts];
     [object removeAlert: kSecondMenuAlert];
     
     [object nextLoop];  // duration + delay, starts state machine
     [object stopLoop];  <-- cancel running animation block?, ends state machine
     
     [object setDuration: 1.5f];
     [object setDelay:    0.5f];
     
     [object setBaseImageView: (UIImageView*) image];
     [object setOverlayImageView: (UIImageView*) image];
     
     // One alert   - always on
     // Two+ alerts - cycle through
     
     // Circular linked list
     
     [p][data][n]
     
     data
       - image
       - ???
     
     */
    
//    [UIView animateWithDuration:1.5f
//                          delay:0.5f
//                        options: UIViewAnimationCurveEaseInOut
//                     animations:^{
//                         [alertImg setAlpha:0.0f];
//                         [advisoryImg setAlpha:1.0f];
//                     }
//                     completion:^(BOOL finished) {
//
//                         
//                         [UIView animateWithDuration:1.5f
//                                               delay:0.5f
//                                             options: UIViewAnimationOptionOverrideInheritedCurve | UIViewAnimationOptionOverrideInheritedDuration | UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
//                                          animations:^{
//                                              [UIView setAnimationRepeatCount:2.5];
//                                              [advisoryImg setAlpha:0.0f];
//                                              [detourImg setAlpha:1.0f];
//                                          }
//                                          completion:^(BOOL finished) {
//                                              NSLog(@"Animation complete");
//                                          }];
//                     }];
    
//    [self.view addSubview: imgView];
    
//    [_testView addSubview:imgView];
//    
//    [_testView addSubview:alertImg];
//    [_testView addSubview:advisoryImg];
//    [_testView addSubview:detourImg];
//    
//    [self.view addSubview: _testView];
    
    NSLog(@"RVC - Added Image");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    
    [self setBtnNextToArrive:nil];
    [self setBtnTrainView:nil];
    [self setBtnTransitView:nil];
    
    [self setBtnFindNearestLocation:nil];
    [self setBtnSystemStatus:nil];
    [self setBtnGuide:nil];
    
    [super viewDidUnload];
    
}


-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

//    [self changeOrientation:fromInterfaceOrientation];
    
}


-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{

    [self changeOrientation:toInterfaceOrientation];
    
//    if ( UIInterfaceOrientationIsLandscape( toInterfaceOrientation ) )
//    {
//        // Add more padding to the buttons
//    }
//    else
//    {
//        // Squish the buttons together
//    }
    
}


-(void) changeOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{

    CGFloat width;
    
    if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        width = [[UIScreen mainScreen] bounds].size.height;
    }
    else
    {
        width = [[UIScreen mainScreen] bounds].size.width;
    }
    

    int buttonWidth = 96;
    
    int padding = (width - buttonWidth*3)/4;
    
    // p = (w - 3*96) / 4
    
    CGRect btnNextToArriveRect = self.btnNextToArrive.frame;
    CGRect lblNextToArriveRect = self.lblNextToArrive.frame;
    
    btnNextToArriveRect.origin.x = padding;
    lblNextToArriveRect.origin.x = btnNextToArriveRect.origin.x;
    [self.btnNextToArrive setFrame: btnNextToArriveRect];
    [self.lblNextToArrive setFrame: lblNextToArriveRect];
    
    CGRect btnTrainViewRect = self.btnTrainView.frame;
    CGRect lblTrainViewRect = self.lblTrainView.frame;
    
    btnTrainViewRect.origin.x = 2*padding+buttonWidth;
    lblTrainViewRect.origin.x = btnTrainViewRect.origin.x;
    [self.btnTrainView setFrame: btnTrainViewRect];
    [self.lblTrainView setFrame: lblTrainViewRect];
    
    CGRect btnTransitViewRect = self.btnTransitView.frame;
    CGRect lblTransitViewRect = self.lblTransitView.frame;
    
    btnTransitViewRect.origin.x = 3*padding + 2*buttonWidth;
    lblTransitViewRect.origin.x = btnTransitViewRect.origin.x;
    [self.btnTransitView setFrame: btnTransitViewRect];
    [self.lblTransitView setFrame: lblTransitViewRect];
    
    
    CGRect btnSystemStatusRect = self.btnSystemStatus.frame;
    CGRect lblSystemStatusRect = self.lblSystemStatus.frame;
    btnSystemStatusRect.origin.x = padding;
    lblSystemStatusRect.origin.x = btnSystemStatusRect.origin.x;
    
    [self.btnSystemStatus setFrame: btnSystemStatusRect];
    [self.lblSystemStatus setFrame: lblSystemStatusRect];
    
    CGRect btnNearestLocationRect = self.btnFindNearestLocation.frame;
    CGRect lblFindNearestRect     = self.lblFindNeareset.frame;
    CGRect lblLocationRect        = self.lblLocations.frame;
    btnNearestLocationRect.origin.x = 2*padding+buttonWidth;
    lblFindNearestRect.origin.x = btnNearestLocationRect.origin.x;
    lblLocationRect.origin.x = btnNearestLocationRect.origin.x;
    
    [self.btnFindNearestLocation setFrame: btnNearestLocationRect];
    [self.lblFindNeareset setFrame: lblFindNearestRect];
    [self.lblLocations setFrame: lblLocationRect];
    
    
    CGRect btnGuideRect = self.btnGuide.frame;
    CGRect lblGuideRect = self.lblGuide.frame;
    
    btnGuideRect.origin.x = 3*padding+2*buttonWidth;
    lblGuideRect.origin.x = btnGuideRect.origin.x;
    [self.btnGuide setFrame: btnGuideRect];
    [self.lblGuide setFrame: lblGuideRect];
}



#pragma mark -= Button Presses
- (IBAction)btnNextToArrivePressed:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NextToArriveStoryboard" bundle:nil];
    NextToArriveTableViewController *ntaVC = (NextToArriveTableViewController*)[storyboard instantiateInitialViewController];
    
    [self.navigationController pushViewController:ntaVC animated:YES];
    
}

- (IBAction)btnTrainViewPressed:(id)sender
{

    
//    MMDrawerTestViewController *testVC = [[MMDrawerTestViewController alloc] init];
//    [self.navigationController pushViewController:testVC animated:YES];
    
    
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TrainViewStoryboard" bundle:nil];
//    TrainViewViewController *tvVC = (TrainViewViewController*)[storyboard instantiateInitialViewController];
//    [self.navigationController pushViewController:tvVC animated:YES];
//    
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MemoryTestStoryboard" bundle:nil];
//    MapMemoryTestViewController *tvVC = (MapMemoryTestViewController*)[storyboard instantiateInitialViewController];
//    _startTest = YES;
//    [tvVC setCounter: _counter];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TrainSlidingStoryboard" bundle:nil];
    TrainViewViewController *tvVC = (TrainViewViewController*)[storyboard instantiateInitialViewController];
    [self.navigationController pushViewController:tvVC animated:YES];
    

}


- (IBAction)btnTransitViewPress:(id)sender
{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TransitViewStoryboard" bundle:nil];
    TransitViewViewController *tvVC = (TransitViewViewController*)[storyboard instantiateInitialViewController];
    
//    [tvVC setTravelMode:@"Rail"];
    
    [self.navigationController pushViewController:tvVC animated:YES];

    
}

- (IBAction)btnSystemStatusPressed:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SystemStatusStoryboard" bundle:nil];
    SystemStatusViewController *ssVC = (SystemStatusViewController*)[storyboard instantiateInitialViewController];
    
    //    [tvVC setTravelMode:@"Rail"];
    
    [self.navigationController pushViewController:ssVC animated:YES];
}

- (IBAction)btnFindNearestLocationPressed:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NearestLocationStoryboard" bundle:nil];
    NearestLocationViewController *nlVC = (NearestLocationViewController*)[storyboard instantiateInitialViewController];
    
    //    [tvVC setTravelMode:@"Rail"];
    
    [self.navigationController pushViewController:nlVC animated:YES];
    
}


- (IBAction)btnGuidePressed:(id)sender
{
    
}






@end

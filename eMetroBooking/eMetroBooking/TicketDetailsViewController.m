//
//  TicketDetailsViewController.m
//  eMetroBooking
//
//  Created by Pushkraj on 10/09/17.
//  Copyright © 2017 Pushkraj. All rights reserved.
//

#import "TicketDetailsViewController.h"

#define GOOGLE_URL @"http://maps.google.com/maps/api/geocode/json?address=%@,Delhi"
#define REQUEST_TYPE_GET @"GET"

@interface TicketDetailsViewController () {
    MKPlacemark *destination;
    MKPlacemark *source;
    int count;
    CLLocationCoordinate2D sourceCoords, destinationCoords;
}
@end

@implementation TicketDetailsViewController
@synthesize sourceLocation, destinationLocation, dateTime, price;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    count = 0;
    
    labelFromLocation.text = sourceLocation;
    labelToLocation.text = destinationLocation;
    labelDateAndTime.text = dateTime;
    labelPrice.text = [NSString stringWithFormat:@"Rs. %@/-",price];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getCoordinatesFromLocationName:sourceLocation];
        [self getCoordinatesFromLocationName:destinationLocation];
    });
}

#pragma mark - Get Lattitude and Longitude from Location name

/**
 This method will be called to get lattitude longitude of location name. It will get called twice as we have source and destination location.

 @param locationName Location name will be parameter as we want lattitude longitude of same
 */
-(void) getCoordinatesFromLocationName:(NSString *)locationName {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSString *urlString = [NSString stringWithFormat:GOOGLE_URL,locationName];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:REQUEST_TYPE_GET];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *e = nil;
        id resposeDictionary = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableLeaves error: &e];
        float latitude = 0, longitude = 0;
        if([[resposeDictionary objectForKey:API_RESULTS]count] > 0) {
            float latVal = [[[[[[resposeDictionary objectForKey:API_RESULTS] objectAtIndex:0] objectForKey:API_GEOMETRY] objectForKey:API_LOCATION] valueForKey:API_LAT] floatValue];
            latitude = [[NSString stringWithFormat:@"%.6f",latVal] floatValue];
            float longVal = [[[[[[resposeDictionary objectForKey:API_RESULTS] objectAtIndex:0] objectForKey:API_GEOMETRY] objectForKey:API_LOCATION] valueForKey:API_LONG] floatValue];
            longitude = [[NSString stringWithFormat:@"%.6f",longVal] floatValue];;
        }
        if (count == 0) {
            sourceCoords = CLLocationCoordinate2DMake(latitude, longitude);
            count += 1;
        }
        else {
            destinationCoords = CLLocationCoordinate2DMake(latitude, longitude);
            [self showDirections:sourceCoords andDestinationCoords:destinationCoords];
        }
    }];
    [postDataTask resume];
}

#pragma mark - Create Route on 

/**
 This method will add annotation on map and will create two annotations once each for source and destination.

 @param sourceCOORDS Source lattitude longitude
 @param destinationsCOORDS Destination lattitude longitude
 */
-(void)showDirections:(CLLocationCoordinate2D) sourceCOORDS andDestinationCoords:(CLLocationCoordinate2D) destinationsCOORDS {
    CLLocationCoordinate2D scCoords = sourceCOORDS;
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    region.center = scCoords;
    span.latitudeDelta = 1;
    span.longitudeDelta = 1;
    region.span=span;
    [mapViewJourney setRegion:region animated:TRUE];
    
    MKPlacemark *sourcePlacemark  = [[MKPlacemark alloc] initWithCoordinate:scCoords addressDictionary:nil];
    
    MKPointAnnotation *sourceAnnotation = [[MKPointAnnotation alloc] init];
    sourceAnnotation.coordinate = scCoords;
    sourceAnnotation.title = sourceLocation;
    [mapViewJourney addAnnotation:sourceAnnotation];
    destination = sourcePlacemark;
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:destination];
    
    CLLocationCoordinate2D destCoords = destinationsCOORDS;
    MKPlacemark *destinationPlacemark  = [[MKPlacemark alloc] initWithCoordinate:destCoords addressDictionary:nil];
    MKPointAnnotation *destinationAnnotation = [[MKPointAnnotation alloc] init];
    destinationAnnotation.coordinate = destCoords;
    destinationAnnotation.title = destinationLocation;
    [mapViewJourney addAnnotation:destinationAnnotation];
    
    source = destinationPlacemark;
    
    MKMapItem *mapItem1 = [[MKMapItem alloc] initWithPlacemark:source];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = mapItem1;
    
    request.destination = mapItem;
    request.requestsAlternateRoutes = NO;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             NSLog(@"ERROR");
             NSLog(@"%@",[error localizedDescription]);
         } else {
             [self showRoute:response];
         }
     }];
}


/**
 This Method will show route on map between two locations.

 @param response Response received from above method.
 */
-(void)showRoute:(MKDirectionsResponse *)response {
    for (MKRoute *route in response.routes) {
        [mapViewJourney addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        
        for (MKRouteStep *step in route.steps) {
            NSLog(@"%@", step.instructions);
        }
    }
}

#pragma mark - MKMapViewDelegate methods

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 10.0;
    return  renderer;
}

#pragma mark - Button Tap Actions
// This will be called when you tap on Share Button and share activity controller will be opened. It will show all options installed on device.
- (IBAction)buttonShareTapped:(id)sender {
    NSString *title =[NSString stringWithFormat:@"I travelled from %@ to %@ in just %@",sourceLocation,destinationLocation,price];
    NSArray *dataToShare = @[title];
    UIActivityViewController* activityViewController =[[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
    [self presentViewController:activityViewController animated:YES completion:^{}];
}

// This will be called when you tap on Home Button. It will take you to home screen.
- (IBAction)buttonHomeTapped:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

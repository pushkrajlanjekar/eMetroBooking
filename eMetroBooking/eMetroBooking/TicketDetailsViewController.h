//
//  TicketDetailsViewController.h
//  eMetroBooking
//
//  Created by Pushkraj on 10/09/17.
//  Copyright © 2017 Pushkraj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TicketDetailsViewController : UIViewController<MKMapViewDelegate,NSURLSessionDelegate> {
    IBOutlet UILabel *labelFromLocation;
    IBOutlet UILabel *labelToLocation;
    IBOutlet UILabel *labelDateAndTime;
    IBOutlet UILabel *labelPrice;
    IBOutlet MKMapView *mapViewJourney;
}
@property (nonatomic,strong) NSString * sourceLocation;
@property (nonatomic,strong) NSString * destinationLocation;
@property (nonatomic,strong) NSString * dateTime;
@property (nonatomic,strong) NSString * price;
@end

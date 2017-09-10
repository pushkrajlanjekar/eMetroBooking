//
//  TicketDetails+CoreDataProperties.h
//  eMetroBooking
//
//  Created by Pushkraj on 10/09/17.
//  Copyright © 2017 Pushkraj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TicketDetails : NSManagedObject

@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *destination;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *source;
@property (nonatomic, retain) NSString *time;

@end

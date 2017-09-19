//
//  StationNode.h
//  eMetroBooking
//
//  Created by Pushkraj on 18/09/17.
//  Copyright © 2017 Pushkraj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StationNode : NSObject 

- (id)initWithStationId:(int)stID andStationValue:(NSString *) stValue ;
- (void)addAdjacentStation:(StationNode *)station;
- (NSArray *)getAdjacentStations;

@property (nonatomic, assign) int stationID;
@property (nonatomic, strong) NSString *stationName;

@end

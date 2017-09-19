//
//  StationNode.m
//  eMetroBooking
//
//  Created by Pushkraj on 18/09/17.
//  Copyright © 2017 Pushkraj. All rights reserved.
//

#import "StationNode.h"

@implementation StationNode{
    NSMutableArray *arrayAdjacentStations;
    NSString *stationName;
}
@synthesize stationID, stationName;

- (id)initWithStationId:(int)stID andStationValue:(NSString *) stValue {
    self = [self initWithStationId:stID andStationValue:stValue];
    if (self) {
        stationID = stID;
        stationName = stValue;
    }
    return self;
}

- (void)addAdjacentStation:(StationNode *)station {
    if (![arrayAdjacentStations containsObject:station])
        [arrayAdjacentStations addObject:station];
}

- (NSArray *)getAdjacentStations {
    return arrayAdjacentStations;
}

@end

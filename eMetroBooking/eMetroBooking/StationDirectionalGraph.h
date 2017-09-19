//
//  StationDirectionalGraph.h
//  eMetroBooking
//
//  Created by Pushkraj on 18/09/17.
//  Copyright © 2017 Pushkraj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StationDirectionalGraph : NSObject

- (void)addEdgeFromStation:(StationNode *)stationOne toStation:(StationNode *)stationTwo;

@end

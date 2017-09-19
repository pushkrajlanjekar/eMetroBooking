//
//  StationDirectionalGraph.m
//  eMetroBooking
//
//  Created by Pushkraj on 18/09/17.
//  Copyright © 2017 Pushkraj. All rights reserved.
//

#import "StationDirectionalGraph.h"

@implementation StationDirectionalGraph

-(void)addEdgeFromStation:(StationNode *)stationOne toStation:(StationNode *)stationTwo{
    [stationOne addAdjacentStation:stationTwo];
}

@end

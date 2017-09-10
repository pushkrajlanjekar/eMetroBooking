//
//  Constants.h
//  eMetroBooking
//
//  Created by Pushkraj on 10/09/17.
//  Copyright © 2017 Pushkraj. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#pragma mark - Locations List
#define ARRAY_LOCATIONS @[@"Karol Bagh",@"Jhande Walan",@"R. K. Ashram",@"Rajiv Chowk",@"New Delhi",@"Patel Chowk",@"INA",@"Barakhamba",@"Mandi House",@"Okhla"];

#pragma mark - Storyboard Indentifiers
#define STORY_BOARD [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]
#define ID_SELECT_PLACES_VC @"SelectPlacesViewController"
#define ID_TICKET_DETAILS_VC @"TicketDetailsViewController"
#define ID_HISTORY_LIST_VC @"HistoryListViewController"
#define ID_MAP_VC @"MapViewController"

#pragma mark - Alert View Strings
#define ALERT_TITLE @"Failed !!!"
#define BUTTON_OK @"Ok"
#define ALERT_MESSAGE_SELECT_SOURCE @"Please select source location."
#define ALERT_MESSAGE_SELECT_DESTINATION @"Please select destination location."
#define ALERT_MESSAGE_PLACES_SAME @"Source and destination locations should not be same."
#define ALERT_MESSAGE_NO_HISTORY @"There is no ticket history."

#pragma mark - API Constants and Dictionary Keys
#define API_LOCATION @"location"
#define API_RESULTS @"results"
#define API_GEOMETRY @"geometry"
#define API_LAT @"lat"
#define API_LONG @"lng"
#define KEY_DATE @"date"
#define KEY_TIME @"time"

#pragma mark - Core Data Constants
#define ENTITY_TICKET_DETAILS @"TicketDetails"
#define DB_DATE @"date"
#define DB_DESTINATION @"destination"
#define DB_PRICE @"price"
#define DB_SOURCE @"source"
#define DB_TIME @"time"

#endif /* Constants_h */

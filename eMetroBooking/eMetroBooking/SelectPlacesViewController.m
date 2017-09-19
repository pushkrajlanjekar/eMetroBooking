//
//  SelectPlacesViewController.m
//  eMetroBooking
//
//  Created by Pushkraj on 10/09/17.
//  Copyright © 2017 Pushkraj. All rights reserved.
//

#import "SelectPlacesViewController.h"
#import "HistoryListViewController.h"

@interface SelectPlacesViewController () {
    NSArray *arrayLocations;
    BOOL isSource;
    NSString *sourceLocation, *destinationLocation;
    NSArray *arrayPricesMatrix;
    NSUInteger sourceIndex, destinationIndex;
    
    StationNode *startStation, *endStation;
    StationDirectionalGraph *stationDirectionalGraph;
}
@end

@implementation SelectPlacesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pickerViewPlacesList.hidden = YES;
    arrayLocations = ARRAY_LOCATIONS;
    
    sourceLocation = @"";
    destinationLocation = @"";
    
    NSString * const placesTitle = @"Select Places";
    self.title = placesTitle;
    self.navigationItem.hidesBackButton = true;
    self.navigationController.navigationBarHidden = false;
    
    arrayPricesMatrix = [self getPriceMatrixArray];
}

-(void) generateGraph {
    StationNode *stA = [[StationNode alloc] initWithStationId:1 andStationValue:@"A"];
    StationNode *stB = [[StationNode alloc] initWithStationId:2 andStationValue:@"B"];
    StationNode *stC = [[StationNode alloc] initWithStationId:3 andStationValue:@"C"];
    StationNode *stD = [[StationNode alloc] initWithStationId:4 andStationValue:@"D"];
    StationNode *stE = [[StationNode alloc] initWithStationId:5 andStationValue:@"E"];
    StationNode *stF = [[StationNode alloc] initWithStationId:6 andStationValue:@"F"];
    StationNode *stG = [[StationNode alloc] initWithStationId:7 andStationValue:@"G"];
    StationNode *stH = [[StationNode alloc] initWithStationId:8 andStationValue:@"H"];
    StationNode *stI = [[StationNode alloc] initWithStationId:9 andStationValue:@"I"];
    StationNode *stJ = [[StationNode alloc] initWithStationId:10 andStationValue:@"I"];
    
    [stA addAdjacentStation:stB];
    
    [stB addAdjacentStation:stA];
    [stB addAdjacentStation:stC];
    
    [stC addAdjacentStation:stB];
    [stC addAdjacentStation:stD];
    
    [stD addAdjacentStation:stC];
    [stD addAdjacentStation:stH];
    [stD addAdjacentStation:stE];
    [stD addAdjacentStation:stI];
    
    [stH addAdjacentStation:stD];
    
    [stE addAdjacentStation:stD];
    [stE addAdjacentStation:stF];
    
    [stI addAdjacentStation:stD];
    [stI addAdjacentStation:stJ];
    
    [stJ addAdjacentStation:stI];
    
    [stF addAdjacentStation:stE];
    [stF addAdjacentStation:stG];
    
    [stG addAdjacentStation:stF];
}

/**
 This method will create array of price matrix from one location to another.

 @return Price matrix array will be returned for further use.
 */
-(NSArray *)getPriceMatrixArray {
    NSArray *arrayPrices = @[
                             @[@0,@2,@4,@9,@11,@16,@18,@11,@11,@13],
                             @[@2,@0,@2,@7,@9,@14,@16,@9,@9,@11],
                             @[@4,@2,@0,@5,@7,@12,@14,@7,@7,@9],
                             @[@6,@4,@2,@0,@2,@7,@9,@2,@2,@4],
                             @[@11,@9,@7,@5,@0,@5,@7,@7,@7,@9],
                             @[@13,@11,@9,@7,@2,@0,@2,@9,@9,@11],
                             @[@18,@16,@14,@12,@7,@5,@0,@14,@14,@16],
                             @[@11,@9,@7,@5,@7,@12,@14,@0,@9,@11],
                             @[@11,@9,@7,@5,@7,@12,@14,@7,@0,@12],
                             @[@13,@11,@9,@7,@9,@14,@16,@9,@2,@0]];
    return arrayPrices;
}

#pragma mark - Picker View Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return arrayLocations.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [arrayLocations objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 300;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (isSource) {
        sourceLocation = [arrayLocations objectAtIndex:row];
        buttonSource.titleLabel.text = sourceLocation;
        sourceIndex = row;
    }
    else {
        destinationLocation = [arrayLocations objectAtIndex:row];
        buttonDestination.titleLabel.text = destinationLocation;
        destinationIndex = row;
    }
    pickerViewPlacesList.hidden = YES;
}

#pragma mark - Button Tap Actions
// This will be called when you tap on Select Source Location Button and it will open picker view with options of all available locations.
- (IBAction)buttonSourceTapped:(id)sender {
    pickerViewPlacesList.hidden = NO;
    isSource = true;
    sourceLocation = @"";
}

// This will be called when you tap on Select Destination Location Button and it will open picker view with options of all available locations.
- (IBAction)buttonDestinationTapped:(id)sender {
    pickerViewPlacesList.hidden = NO;
    isSource = false;
    destinationLocation = @"";
}

/* This will be called when you tap on Book Ticket Button.
   First it will validate your form and then it will book your ticket. 
   After booking it will add entry to database so that you can view all tickets under history section.
 */
- (IBAction)buttonBookTicketTapped:(id)sender {
    UIAlertView *alertFailure = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:BUTTON_OK, nil];
    
    if ([sourceLocation isEqualToString:@""]) {
        alertFailure.message = ALERT_MESSAGE_SELECT_SOURCE;
        [alertFailure show];
    }
    else if ([destinationLocation isEqualToString:@""]) {
        alertFailure.message = ALERT_MESSAGE_SELECT_DESTINATION;
        [alertFailure show];
    }
    else if ([sourceLocation isEqualToString:destinationLocation]) {
        alertFailure.message = ALERT_MESSAGE_PLACES_SAME;
        [alertFailure show];
    }
    else {
        AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_TICKET_DETAILS inManagedObjectContext:context];
        NSError *error;
        [newManagedObject setValue:sourceLocation forKey:DB_SOURCE];
        [newManagedObject setValue:destinationLocation forKey:DB_DESTINATION];
        [newManagedObject setValue:[[self getCurrentDateAndTime] valueForKey:KEY_DATE] forKey:DB_DATE];
        [newManagedObject setValue:[[self getCurrentDateAndTime] valueForKey:KEY_TIME] forKey:DB_TIME];
        [newManagedObject setValue:[NSString stringWithFormat:@"%@",[[arrayPricesMatrix objectAtIndex:sourceIndex] objectAtIndex:destinationIndex]] forKey:DB_PRICE];
        
        if(![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        else {
            TicketDetailsViewController *ticketDetailsVC = [STORY_BOARD instantiateViewControllerWithIdentifier:ID_TICKET_DETAILS_VC];
            ticketDetailsVC.sourceLocation = sourceLocation;
            ticketDetailsVC.destinationLocation = destinationLocation;
            ticketDetailsVC.dateTime = [NSString stringWithFormat:@"%@ | %@",[[self getCurrentDateAndTime] valueForKey:KEY_DATE],[[self getCurrentDateAndTime] valueForKey:KEY_TIME]];
            ticketDetailsVC.price = [NSString stringWithFormat:@"%@",[[arrayPricesMatrix objectAtIndex:sourceIndex] objectAtIndex:destinationIndex]];
            [self.navigationController pushViewController:ticketDetailsVC animated:YES];
        }
    }
}

// This will be called when you tap on History Button and it will navigate you to History screen where you can see list of all tickets.
- (IBAction)buttonHistoryTapped:(id)sender {
    HistoryListViewController *historyListVC = [STORY_BOARD instantiateViewControllerWithIdentifier:ID_HISTORY_LIST_VC];
    [self.navigationController pushViewController:historyListVC animated:YES];
}

#pragma mark - Get Date

/**
 This method will be used to get current time and date to save in DB with ticket entry.

 @return Dictionary will be returned with 2 keys date and time and its value.
 */
-(NSDictionary *)getCurrentDateAndTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE dd,MMM yyyy"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"EN"]];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:MM"];
    [timeFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"EN"]];
    
    
    return @{KEY_DATE:[dateFormatter stringFromDate:[NSDate date]],
             KEY_TIME:[timeFormatter stringFromDate:[NSDate date]]};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

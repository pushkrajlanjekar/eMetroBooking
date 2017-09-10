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
}

#pragma mark UIPickerViewDelegate Methods

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
    }
    else {
        destinationLocation = [arrayLocations objectAtIndex:row];
        buttonDestination.titleLabel.text = destinationLocation;
    }
    pickerViewPlacesList.hidden = YES;
}

#pragma mark - Button Tap Actions
- (IBAction)buttonSourceTapped:(id)sender {
    pickerViewPlacesList.hidden = NO;
    isSource = true;
    sourceLocation = @"";
}

- (IBAction)buttonDestinationTapped:(id)sender {
    pickerViewPlacesList.hidden = NO;
    isSource = false;
    destinationLocation = @"";
}

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
        [newManagedObject setValue:@"10" forKey:DB_PRICE];
        
        if(![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        else {
            TicketDetailsViewController *ticketDetailsVC = [STORY_BOARD instantiateViewControllerWithIdentifier:ID_TICKET_DETAILS_VC];
            ticketDetailsVC.sourceLocation = sourceLocation;
            ticketDetailsVC.destinationLocation = destinationLocation;
            ticketDetailsVC.dateTime = [NSString stringWithFormat:@"%@ | %@",[[self getCurrentDateAndTime] valueForKey:KEY_DATE],[[self getCurrentDateAndTime] valueForKey:KEY_TIME]];
            ticketDetailsVC.price = @"Rs. 10/-";
            [self.navigationController pushViewController:ticketDetailsVC animated:YES];
        }
    }
}

- (IBAction)buttonHistoryTapped:(id)sender {
    HistoryListViewController *historyListVC = [STORY_BOARD instantiateViewControllerWithIdentifier:ID_HISTORY_LIST_VC];
    [self.navigationController pushViewController:historyListVC animated:YES];
}

#pragma mark - Get Date
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

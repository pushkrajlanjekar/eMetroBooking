//
//  HistoryListViewController.m
//  eMetroBooking
//
//  Created by Pushkraj on 10/09/17.
//  Copyright © 2017 Pushkraj. All rights reserved.
//

#import "HistoryListViewController.h"
#import "HistoryListTableViewCell.h"

#define ROW_HEIGHT 60

@interface HistoryListViewController () {
    NSArray *arrayTicketsList;
}
@end

@implementation HistoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayTicketsList = [self getAllTickets];
    if (arrayTicketsList.count > 0) {
        [tableViewTicketsList reloadData];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:ALERT_MESSAGE_NO_HISTORY delegate:self cancelButtonTitle:nil otherButtonTitles:BUTTON_OK, nil];
        [alertView show];
    }
}

-(NSArray *) getAllTickets {
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:ENTITY_TICKET_DETAILS];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    return results;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayTicketsList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    static NSString *reuseCellIdentifier = @"cell";
    HistoryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:ID_HISTORY_LIST_CELL bundle:nil] forCellReuseIdentifier:reuseCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:reuseCellIdentifier];
    }
    TicketDetails *ticketDetails = (TicketDetails *)[arrayTicketsList objectAtIndex:indexPath.row];
    cell.labelDetails.text = [NSString stringWithFormat:@"%@ to %@ at Rs. %@/-",ticketDetails.source, ticketDetails.destination, ticketDetails.price];
    cell.labelDateAndTime.text = [NSString stringWithFormat:@"On %@ at %@",ticketDetails.date, ticketDetails.time];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketDetails *ticketDetails = (TicketDetails *)[arrayTicketsList objectAtIndex:indexPath.row];
    TicketDetailsViewController *ticketDetailsVC = [STORY_BOARD instantiateViewControllerWithIdentifier:ID_TICKET_DETAILS_VC];
    ticketDetailsVC.sourceLocation = ticketDetails.source;
    ticketDetailsVC.destinationLocation = ticketDetails.destination;
    ticketDetailsVC.dateTime = [NSString stringWithFormat:@"%@ | %@",ticketDetails.date,ticketDetails.time];
    ticketDetailsVC.price = ticketDetails.price;
    [self.navigationController pushViewController:ticketDetailsVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

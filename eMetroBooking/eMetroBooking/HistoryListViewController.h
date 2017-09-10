//
//  HistoryListViewController.h
//  eMetroBooking
//
//  Created by Pushkraj on 10/09/17.
//  Copyright © 2017 Pushkraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *tableViewTicketsList;
}
@end

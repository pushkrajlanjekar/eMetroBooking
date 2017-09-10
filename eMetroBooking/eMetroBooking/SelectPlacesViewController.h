//
//  SelectPlacesViewController.h
//  eMetroBooking
//
//  Created by Pushkraj on 10/09/17.
//  Copyright © 2017 Pushkraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectPlacesViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource> {
    IBOutlet UIButton *buttonSource;
    IBOutlet UIButton *buttonDestination;
    IBOutlet UIPickerView *pickerViewPlacesList;
}
@end


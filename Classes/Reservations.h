//
//  Reservations.h
//  
//
//  Created by Sakthivel Muthusamy on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Reservations : UIViewController {
    
    IBOutlet UITableView *IBReservationTable;
	IBOutlet UIAlertView *megaAlert;
    
    //IBOutlet UIToolbar *reservationToolBar;
    //UISegmentedControl *segmentedReservations;
    
}
- (IBAction) viewReservations;

- (BOOL) getFormatedDataFromURL;
- (void) invokeMegaAnnoyingPopup;
- (void) dismissMegaAnnoyingPopup;


@property (nonatomic,retain)  IBOutlet UIAlertView *megaAlert;
//@property (nonatomic,retain)  IBOutlet UISegmentedControl *segmentedReservations;
//@property (nonatomic,retain)  IBOutlet UIToolbar *reservationToolBar;


@end
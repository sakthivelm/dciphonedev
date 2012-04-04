//
//  RestaurantReserve.h
//  
//
//  Created by Sakthivel Muthusamy on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RestaurantReserve : UIViewController <UIActionSheetDelegate>{

    IBOutlet UILabel *restaurantName;
    IBOutlet UITextField *reserveSeats;
    IBOutlet UITextField *reserveDuration;
    IBOutlet UITextField *reserveNotes;
    
    IBOutlet UIButton *btnSave;
    IBOutlet UIButton *btnDel;
    IBOutlet UIAlertView *megaAlert;
    IBOutlet UIButton *btnDate;
    IBOutlet UIDatePicker *reserveDate;
    IBOutlet UIDatePicker *datePicker;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (IBAction) initSave;

- (IBAction) delReservation;
- (IBAction) getDate;

- (void) displayDate;

- (BOOL) initDownloadDataFromURL;
- (void) invokeMegaAnnoyingPopup;
- (void) dismissMegaAnnoyingPopup;

@property (nonatomic,retain)  IBOutlet UIButton *btnSave;
@property (nonatomic,retain)  IBOutlet UIButton *btnDel;
@property (nonatomic,retain)  IBOutlet UIAlertView *megaAlert;


@end


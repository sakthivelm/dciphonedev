//
//  ViewOrders.h
//  
//
//  Created by Sakthivel Muthusamy on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewOrders : UIViewController <UIActionSheetDelegate>{

    IBOutlet UITableView *IBOrdersTable;
	IBOutlet UIAlertView *megaAlert;
    UIDatePicker *historyDate;
    
    IBOutlet UIToolbar *ordersToolBar;
    
    UISegmentedControl *segmentedControl;
    UIColor *selectedColor;
    
}
- (IBAction) viewCart;
- (IBAction) viewOrders;
- (IBAction) viewHistory;

- (IBAction) segmentedControlIndexChanged;
- (IBAction) showCalendar;

- (BOOL) getOrdersFromURL;
- (void) invokeMegaAnnoyingPopup;
- (void) dismissMegaAnnoyingPopup;
- (void) changeSelectedIndexColor:(int) selindex;


@property (nonatomic,retain)  IBOutlet UIAlertView *megaAlert;
@property (nonatomic,retain)  IBOutlet UISegmentedControl *segmentedControl;


@end


//
//  ViewOrdersDetails.h
//  
//
//  Created by Sakthivel Muthusamy on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewOrdersDetails : UIViewController <UIActionSheetDelegate> {
    
    
    IBOutlet UITableView *myRestaurantMenu;
	IBOutlet UIAlertView *megaAlert;
	IBOutlet UILabel *restaurantName;
    IBOutlet UILabel *orderDate;
    IBOutlet UIButton *checkOut;
    IBOutlet UIButton *btnScan;
    IBOutlet UIButton *btnCoupon;
    
    IBOutlet UILabel *DiscountAmount;
    IBOutlet UILabel *DiscountText;
    IBOutlet UILabel *OrderGrossTotal;
    IBOutlet UILabel *OrderTotal;

}
- (BOOL) getMenusFromURL;
- (IBAction) postCheckOut;
- (IBAction) postApplicableCoupons;
- (IBAction) viewRestaurantDetail;


- (void) invokeMegaAnnoyingPopup;
- (void) dismissMegaAnnoyingPopup;

@property (nonatomic,retain)  IBOutlet UIAlertView *megaAlert;


@end

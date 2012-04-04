//
//  Coupons.h
//  
//
//  Created by Sakthivel Muthusamy on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Coupons : UIViewController <UIActionSheetDelegate>
{
    
    IBOutlet UITableView *IBCouponsTable;
	IBOutlet UIAlertView *megaAlert;
        
    int applicableValue;
    NSString *coupId;
    
}
- (IBAction) viewCoupons;

- (BOOL) getOrdersFromURL;
- (void) invokeMegaAnnoyingPopup;
- (void) dismissMegaAnnoyingPopup;
- (void) setApplicable;
- (NSString *) getCouponId;



@property (nonatomic,retain)  IBOutlet UIAlertView *megaAlert;


@end
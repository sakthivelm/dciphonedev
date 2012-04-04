//
//  AddCoupon.h
//
//  Created by Sakthivel Muthusamy on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddCoupon : UIViewController <UIActionSheetDelegate>
{
    IBOutlet UITableView *IBCouponsTable;
	IBOutlet UIAlertView *megaAlert;
    
}
- (BOOL) getOrdersFromURL;
- (void) invokeMegaAnnoyingPopup;
- (void) dismissMegaAnnoyingPopup;


@property (nonatomic,retain)  IBOutlet UIAlertView *megaAlert;

@end
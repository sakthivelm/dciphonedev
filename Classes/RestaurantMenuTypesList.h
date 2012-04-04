//
//  RestaurantMenuTypesList.h
//  
//
//  Created by Sakthivel Muthusamy on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RestaurantMenuTypesList : UIViewController {
    IBOutlet UITableView *resmenuTypes;
	IBOutlet UIAlertView *megaAlert;
}

- (BOOL) getFormatedDataFromURL;
- (void) invokeMegaAnnoyingPopup;
- (void) dismissMegaAnnoyingPopup;

@property (nonatomic,retain)  IBOutlet UIAlertView *megaAlert;

@end

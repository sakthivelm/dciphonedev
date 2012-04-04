//
//  RestaurantMenu.h
//  
//
//  Created by Sakthivel Muthusamy on 2/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RestaurantMenu : UIViewController {
	
	IBOutlet UITableView *myRestaurantMenu;
	IBOutlet UIAlertView *megaAlert;
	IBOutlet UILabel *restaurantName;

}

- (BOOL) getMenusFromURL;
- (void) invokeMegaAnnoyingPopup;
- (void) dismissMegaAnnoyingPopup;

-(void) launchCart;

@property (nonatomic,retain)  IBOutlet UIAlertView *megaAlert;


@end


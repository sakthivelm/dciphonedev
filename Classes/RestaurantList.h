//
//  RestaurantList.h
//  
//
//  Created by Sakthivel Muthusamy on 1/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RestaurantList : UIViewController {
	
	IBOutlet UITableView *myTable;
	IBOutlet UIAlertView *megaAlert;
    NSString *strListEnd;
    int isMoreResults;

}

- (IBAction) goHome:(id) sender;
- (BOOL) getRestaurantFromURL;
- (void) invokeMegaAnnoyingPopup;
- (void)dismissMegaAnnoyingPopup;


@property (nonatomic,retain)  IBOutlet UIAlertView *megaAlert;
@property (nonatomic,retain)  NSString *strListEnd;

@end



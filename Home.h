//
//  MyController.h
//
//  Created by Sakthivel Muthusamy on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/*
@protocol CoreLocationControllerDelegate 
@required
- (void)locationUpdate:(CLLocation *)location; // Our location updates are sent here
- (void)locationError:(NSError *)error; // Any errors are sent here
@end
*/

@interface Home : UIViewController <CLLocationManagerDelegate> {
	
	//{Core location based
		CLLocationManager *locMgr;
		id delegate;
		//}
	
 	IBOutlet UITextField *textwhere;
	IBOutlet UITextField *textfood;
    IBOutlet UILabel *textLoginStatus;
    IBOutlet UIButton *setLocation;
    IBOutlet UIButton *setFavourites;
	IBOutlet UIButton *searchButton;
    IBOutlet UIButton *btnLoginStatus;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (BOOL) startGPSService;

- (IBAction) listCurrentLocation;
- (IBAction) listFavourites;
- (IBAction) listHistory;

- (IBAction) changeLoginState;

- (IBAction) searchRestaurant: (id) sender;

@property (nonatomic, retain) CLLocationManager *locMgr;
@property (nonatomic, assign) id delegate;
//@property (nonatomic, retain) CoreLocationController *CLController;

@end


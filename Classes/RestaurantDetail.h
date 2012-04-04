//
//  RestaurantDetail.h
//  
//
//  Created by Sakthivel Muthusamy on 1/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RestaurantDetail : UIViewController <UIActionSheetDelegate>{
	
	IBOutlet UITableView *myTableDetails;
	IBOutlet UIAlertView *megaAlertDetails;
	IBOutlet UITextView *resAddress;
    IBOutlet UITextView *resOpenHours;
    IBOutlet UIImageView *restLogoDownload;
	NSString *strPhone;
	NSString *strEmail;
	NSString *strWeb;
    NSString *strRestTypeFlag;
    int isSetFavourite;
    int isRatingAllowed;

	
	IBOutlet UIButton *btnMenu;
	IBOutlet UIButton *btnReserve;
	IBOutlet UIButton *btnCoupons;
    
    IBOutlet UILabel  *btnLabel;
    IBOutlet UIButton *btnRate1;
    IBOutlet UIButton *btnRate2;
    IBOutlet UIButton *btnRate3;
    IBOutlet UIButton *btnRate4;
    IBOutlet UIButton *btnRate5;
    IBOutlet UIButton *btnOpenClose;
    IBOutlet UIButton *btnFavouriteChange;
    IBOutlet UIButton *btnSetFavourite;
    
}

- (BOOL) getRestaurantFromURL:(int)Function:(int)Ratevalue;

- (void) invokeMegaAnnoyingPopup:(NSString *) msg;
- (void) dismissMegaAnnoyingPopup;
- (void) setFavouriteImage;

- (IBAction) launchMenu;

- (IBAction) launchReserve;

- (IBAction) launchCoupons;

- (IBAction) launchOpenHours;

- (IBAction) Rating1Pressed;
- (IBAction) Rating2Pressed;
- (IBAction) Rating3Pressed;
- (IBAction) Rating4Pressed;
- (IBAction) Rating5Pressed;
- (void) DisplayRating:(int) Rated;

- (IBAction) setFavourite; 


@property (nonatomic,retain)  IBOutlet UIAlertView *megaAlertDetails;
@property (nonatomic,retain)  NSString *strPhone;
@property (nonatomic,retain)  NSString *strEmail;
@property (nonatomic,retain)  NSString *strWeb;
@property (nonatomic,retain)  NSString *strRestTypeFlag;



@property (nonatomic,retain)  IBOutlet UIButton *btnMenu;
@property (nonatomic,retain)  IBOutlet UIButton *btnCoupons;
@property (nonatomic,retain)  IBOutlet UIButton *btnReserve;

@end



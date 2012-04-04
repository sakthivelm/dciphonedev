//
//  AppDelegate.h
//  
//
//  Created by Sakthivel Muthusamy on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UITabBarController *tabBarController;
	
	//Global
    NSString *globalMainUrl;
    NSString *globalAlternateUrl;
    
	CLLocation  *globalGPSLocation;	
	//NSNumber	*globalGPSRadious;
	//NSNumber	*globalMileSwitch;
    
	NSString *globalTextWhere;
	NSString *globalTextFood;
    
    //Restaurant details
    NSString *globalUserName;
    NSString *globalPassword;
    NSNumber *globalLoginStatus;
    
    NSString *globalRestaurantName;
    NSString *globalRestaurantId;
    
    NSString *globalMenuId;
    
    //Cart globals
    NSString *globalAddCartItemId;
    NSString *globalAddCartItemName;
    NSString *globalAddCartItemVariant;
    NSNumber *globalAddCartQty;
    NSNumber *globalAddCartRate;
    NSString *globalAddCartInstructions;
    NSString *globalAddCartInputtext;
    NSString *globalAddCartDate;
    NSString *globalAddCartTime;
    NSNumber *globalAddCartOption;
    NSNumber *globalAddCartPackSize;
    
    NSNumber *globalOrderListOption;
    
    NSNumber *globalActiveOrderPage;
    NSNumber *globalReservationOption;
    NSNumber *globalAddReserveOrEdit;
    
    NSString *globalReservationID;
    
    NSDate   *globalReservationDate;
   // NSDate   *globalReservationTime;
    
    NSString *globalReservationDuration;
    NSString *globalReservationSeats;
    NSString *globalReservationNotes;
    
    NSString *globalCouponId;
    
    NSString *globalAcceptedCouponId;
    
    NSString *globalOpenHours;
    
    //Delivery Address
    NSNumber *globaldeliveryoption;
    NSNumber *globaldeliveryleadtime;
    NSString *globaldeliveryaptno;
    NSString *globaldeliverystreetno;
    NSString *globaldeliverystreet;
    NSString *globaldeliverycity;
    NSString *globaldeliverystate;
    NSString *globaldeliveryzip;
    NSString *globaldeliveryperson;
    NSString *globaldeliveryphone;
    NSDate   *globaldeliverydate;
    
    UIColor *globalNavigationBarColor;

    //join now / address informations
    NSNumber *globalJoinNowUpdateFlag;
    NSString *globalLoginName;
    NSString *globalLoginUserName;
	NSString *globalLoginPassWord;
	NSString *globalLoginRetypePassword;
    NSString *globalLoginPhone;
    NSString *globalLoginAptNo;
    NSString *globalLoginStreetNo;
    NSString *globalLoginStreet;
    NSString *globalLoginCity;
    NSString *globalLogintZIP;
    NSString *globalLoginState;
    NSString *globalLoginCountry;
    NSString *globalLoginEmail;
    NSString *globalLoginBuzzer;   
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;


//Global variables
@property (nonatomic, retain) NSString *globalMainUrl;
@property (nonatomic, retain) NSString *globalAlternateUrl;
@property (nonatomic, retain) CLLocation *globalGPSLocation;
//@property (nonatomic, retain) NSNumber *globalGPSRadious;
//@property (nonatomic, retain) NSNumber *globalMileSwitch;
@property (nonatomic, retain) NSString *globalTextWhere;
@property (nonatomic, retain) NSString *globalTextFood;

@property (nonatomic, retain) NSString *globalRestaurantName;
@property (nonatomic, retain) NSString *globalRestaurantId;


@property (nonatomic, retain) NSString *globalUserName;
@property (nonatomic, retain) NSString *globalPassword;
@property (nonatomic, retain) NSNumber *globalLoginStatus;


@property (nonatomic, retain) NSString *globalMenuId;

@property (nonatomic, retain) NSString *globalAddCartItemId;
@property (nonatomic, retain) NSString *globalAddCartItemName;
@property (nonatomic, retain) NSString *globalAddCartItemVariant;
@property (nonatomic, retain) NSNumber *globalAddCartQty;
@property (nonatomic, retain) NSNumber *globalAddCartRate;
@property (nonatomic, retain) NSString *globalAddCartInstructions;
@property (nonatomic, retain) NSString *globalAddCartInputtext;
@property (nonatomic, retain) NSString *globalAddCartDate;
@property (nonatomic, retain) NSString *globalAddCartTime;
@property (nonatomic, retain) NSNumber *globalAddCartOption;
@property (nonatomic, retain) NSNumber *globalAddCartPackSize;  // small medium large


@property (nonatomic, retain) NSNumber *globalOrderListOption;

@property (nonatomic, retain) NSNumber *globalActiveOrderPage;

@property (nonatomic, retain) NSString *globalReservationID;
@property (nonatomic, retain) NSNumber *globalReservationOption;
@property (nonatomic, retain) NSNumber *globalAddReserveOrEdit;
@property (nonatomic, retain) NSDate *globalReservationDate;
//@property (nonatomic, retain) NSDate *globalReservationTime;
@property (nonatomic, retain) NSString *globalReservationDuration;
@property (nonatomic, retain) NSString *globalReservationSeats;
@property (nonatomic, retain) NSString *globalReservationNotes;

@property (nonatomic, retain) NSString *globalCouponId;
@property (nonatomic, retain) NSString *globalAcceptedCouponId;
@property (nonatomic, retain) NSString *globalOpenHours;

@property (nonatomic, retain) NSNumber *globaldeliveryoption;
@property (nonatomic, retain) NSNumber *globaldeliveryleadtime;
@property (nonatomic, retain) NSString *globaldeliveryaptno;
@property (nonatomic, retain) NSString *globaldeliverystreetno;
@property (nonatomic, retain) NSString *globaldeliverystreet;
@property (nonatomic, retain) NSString *globaldeliverycity;
@property (nonatomic, retain) NSString *globaldeliverystate;


@property (nonatomic, retain) NSString *globaldeliveryzip;
@property (nonatomic, retain) NSString *globaldeliveryperson;
@property (nonatomic, retain) NSString *globaldeliveryphone;
@property (nonatomic, retain) NSDate *globaldeliverydate;

@property (nonatomic, retain) UIColor *globalNavigationBarColor;

@property (nonatomic, retain) NSNumber *globalJoinNowUpdateFlag;
@property (nonatomic, retain) NSString *globalLoginName;
@property (nonatomic, retain) NSString *globalLoginUserName;
@property (nonatomic, retain) NSString *globalLoginPassWord;
@property (nonatomic, retain) NSString *globalLoginRetypePassword;
@property (nonatomic, retain) NSString *globalLoginPhone;
@property (nonatomic, retain) NSString *globalLoginAptNo;
@property (nonatomic, retain) NSString *globalLoginStreetNo;
@property (nonatomic, retain) NSString *globalLoginStreet;
@property (nonatomic, retain) NSString *globalLoginCity;
@property (nonatomic, retain) NSString *globalLogintZIP;
@property (nonatomic, retain) NSString *globalLoginState;
@property (nonatomic, retain) NSString *globalLoginCountry;
@property (nonatomic, retain) NSString *globalLoginEmail;
@property (nonatomic, retain) NSString *globalLoginBuzzer;

@end



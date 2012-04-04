//
//  AppDelegate.m
//  
//
//  Created by Sakthivel Muthusamy on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;
@synthesize tabBarController;
//@synthesize restID;


@synthesize globalGPSLocation;
//@synthesize globalGPSRadious;
//@synthesize globalMileSwitch;
@synthesize globalTextWhere;
@synthesize globalTextFood;

@synthesize globalRestaurantName;
@synthesize globalRestaurantId;

@synthesize globalPassword;
@synthesize globalUserName;
@synthesize globalLoginStatus;

@synthesize globalMainUrl;
@synthesize globalAlternateUrl;

@synthesize globalMenuId;

@synthesize globalAddCartItemId;
@synthesize globalAddCartItemVariant;
@synthesize globalAddCartItemName;
@synthesize globalAddCartQty;
@synthesize globalAddCartRate;
@synthesize globalAddCartInstructions;
@synthesize globalAddCartInputtext;
@synthesize globalAddCartDate;
@synthesize globalAddCartTime;
@synthesize globalAddCartOption;
@synthesize globalAddCartPackSize;
@synthesize globalActiveOrderPage;
@synthesize globalReservationOption;
@synthesize globalOrderListOption;

@synthesize globalAddReserveOrEdit;
@synthesize globalReservationID;
@synthesize globalReservationDate;
//@synthesize globalReservationTime;
@synthesize globalReservationDuration;
@synthesize globalReservationSeats;
@synthesize globalReservationNotes;

@synthesize globalCouponId;
@synthesize globalAcceptedCouponId;

@synthesize globalOpenHours;

@synthesize globaldeliveryoption;
@synthesize globaldeliveryleadtime;
@synthesize globaldeliveryaptno;
@synthesize globaldeliverystreetno;
@synthesize globaldeliverystreet;
@synthesize globaldeliverycity;
@synthesize globaldeliverystate;

@synthesize globaldeliveryzip;
@synthesize globaldeliveryperson;
@synthesize globaldeliveryphone;
@synthesize globaldeliverydate;
@synthesize globalNavigationBarColor;

//join now / address informations
@synthesize globalJoinNowUpdateFlag;
@synthesize globalLoginName;
@synthesize globalLoginUserName;
@synthesize globalLoginPassWord;
@synthesize globalLoginRetypePassword;
@synthesize globalLoginPhone;
@synthesize globalLoginAptNo;
@synthesize globalLoginStreetNo;
@synthesize globalLoginStreet;
@synthesize globalLoginCity;
@synthesize globalLogintZIP;
@synthesize globalLoginState;
@synthesize globalLoginCountry;
@synthesize globalLoginBuzzer;
@synthesize globalLoginEmail;

AppDelegate *mainDelegate;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {  
	
    mainDelegate.globalLoginStatus=0;

    mainDelegate.globalNavigationBarColor=[UIColor colorWithRed:41/255.0 green:116/255.0 blue:140/255.0 alpha:1];
   [window addSubview:tabBarController.view]; 
    // Override point for customization after application launch.
    
    [window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[tabBarController release];
    [window release];
    [super dealloc];
}


@end

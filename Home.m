//
//  MyController.m
//
//  Created by Sakthivel Muthusamy on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "home.h"
#import "RestaurantList.h"
#import "AppDelegate.h"
#import "Login.h"
#import "Favourites.h"


@implementation Home


@synthesize locMgr, delegate;

AppDelegate *mainDelegate ;



- (void)dealloc {
	[self.locMgr release];
	[super dealloc];
}

// eg. http://stackoverflow.com/questions/2449409/how-to-set-iphone-tab-bar-icon-in-code
// icons http://developer.apple.com/library/ios/#documentation/uikit/reference/UITabBarItem_Class/Reference/Reference.html
// image size 30x30   48x32

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSArray *tabs = self.tabBarController.viewControllers;

     mainDelegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
     //mainDelegate.globalMainUrl=@"http://www.mekro.in/dinerchoice/responses.asp";
    mainDelegate.globalMainUrl=@"http://diner-choice.com/mctlr";
    
	//{Set tab bar item-0  // home
		UIViewController *tab0 = [tabs objectAtIndex:0];	
		//tab0.tabBarItem= [[UITabBarItem alloc] initWithTitle:@"Test" image:[UIImage imageNamed:@"tabbar_1.png"] tag:2];
		//tab0.tabBarItem.title=@"Test";
		tab0.tabBarItem.image=[UIImage imageNamed:@"tabBtn_Home.png"];
		//}
 
	//{Set tab bar item-1  // View order
		UIViewController *tab1 = [tabs objectAtIndex:1];	
		tab1.tabBarItem.image=[UIImage imageNamed:@"tabBtn_ViewOrder.png"];
		//}
	
	//{Set tab bar item-2  // Coupons
		UIViewController *tab2 = [tabs objectAtIndex:2];	
		tab2.tabBarItem.image=[UIImage imageNamed:@"tabBtn_Coupans.png"];
		//}
	
	//{Set tab bar item-3  // Account
		UIViewController *tab3 = [tabs objectAtIndex:3];	
		tab3.tabBarItem.image=[UIImage imageNamed:@"tabBtn_Reservation.png"];
		//}
	 
	//{Set tab bar item-4  // More
		UIViewController *tab4 = [tabs objectAtIndex:4];	
        tab4.tabBarItem.image=[UIImage imageNamed:@"tabBtn_Account.png"];
		//}
    

    
    mainDelegate.globalNavigationBarColor=[UIColor colorWithRed:41/255.0 green:116/255.0 blue:140/255.0 alpha:1];
   
    self.navigationController.navigationBar.tintColor=mainDelegate.globalNavigationBarColor;
    
    
    //temporary set to login
    mainDelegate.globalLoginStatus=[NSNumber numberWithFloat: 1];
    mainDelegate.globalUserName=@"sekaran";
    mainDelegate.globalPassword=@"mekro";

    
    mainDelegate.globalAcceptedCouponId=@"";
    
	[self startGPSService];

    
    
}

-(void) viewWillAppear:(BOOL)animated{
  if ([mainDelegate.globalLoginStatus intValue] ==1)
    {
        //textLoginStatus.textColor=[UIColor colorWithRed:0xCD/255.0 green:0 blue:0 alpha:1];  //0x cd0000
        textLoginStatus.text=@"Signed in";
        [btnLoginStatus setTitle:@"Sign Out" forState:UIControlStateNormal];
        [btnLoginStatus setTitleColor:[UIColor colorWithRed:0xCD/255.0 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    }
    else
    {
        textLoginStatus.textColor=[UIColor colorWithRed:0 green:0xCC/255.0 blue:0x88/255.0 alpha:1]; //0x 00cc88
        textLoginStatus.text=@"Signed out";
        [btnLoginStatus setTitle:@"Sign In" forState:UIControlStateNormal];
        [btnLoginStatus setTitleColor:[UIColor colorWithRed:0 green:0xCC/255.0 blue:0x88/255.0 alpha:1] forState:UIControlStateNormal];
    }
}

- (IBAction) changeLoginState
{
    
    if ([mainDelegate.globalLoginStatus intValue] ==0)
    {
        Login* vclogin = [[Login alloc] initWithNibName:@"Login" bundle:nil]; 
        [[self navigationController] pushViewController:vclogin animated:YES];
        return;
    }
    else
    {
        mainDelegate.globalLoginStatus=[NSNumber numberWithFloat: 0];
        mainDelegate.globalUserName=@"";
        mainDelegate.globalUserName=@"";
        [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:nil];
        [self viewWillAppear:YES];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
	if (textField == textwhere)
	{
		[textwhere resignFirstResponder];
		[textfood becomeFirstResponder];
	}
	else {
		if (textField==textfood)
			[textfood resignFirstResponder];
		}
	return YES;
}

- (IBAction) searchRestaurant : (id) sender{
	[self.locMgr stopUpdatingLocation];
    [textwhere resignFirstResponder];
        //{store into global variables
        mainDelegate.globalTextWhere= [NSString stringWithFormat:@"%@",[textwhere.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        mainDelegate.globalTextFood= [NSString stringWithFormat:@"%@",[textfood.text  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        RestaurantList* vc = [[RestaurantList alloc] initWithNibName:@"RestaurantList" bundle:nil];
        [[self navigationController] pushViewController:vc animated:YES];
        [vc release];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	
	AppDelegate *mainDelegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
	mainDelegate.globalGPSLocation=newLocation;


}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	//if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {  // Check if the class assigning itself as the delegate conforms to our protocol.  If not, the message will go nowhere.  Not good.
		//[self.delegate locationError:error];
	//}
}

- (void)locationError:(NSError *)error {
	//locLabel.text = [error description];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL) startGPSService
{
    
	self.locMgr = [[[CLLocationManager alloc] init] autorelease]; // Create new instance of locMgr
	self.locMgr.delegate = self; // Set the delegate as self.
	[self.locMgr startUpdatingLocation];
    
	return true;
}

- (IBAction) listCurrentLocation
{
    if([ CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location services disabled" 
                                                        message:@"Please enable to use this search feature"
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
    }

	[textwhere resignFirstResponder];
    mainDelegate.globalTextWhere=@"Current%20Location";
    RestaurantList* vc = [[RestaurantList alloc] initWithNibName:@"RestaurantList" bundle:nil];
    [[self navigationController] pushViewController:vc animated:YES];
    [vc release];
}

-(IBAction) listHistory
{
    [textwhere resignFirstResponder];

    if ([mainDelegate.globalLoginStatus intValue] ==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please sign in" 
                                                        message:@""
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
    }
    else
    {
        Favourites* vc = [[Favourites alloc] initWithNibName:@"Favourites" bundle:nil];
        [[self navigationController] pushViewController:vc animated:YES];
        [vc release];
    }
}

-(IBAction) listFavourites
{
    [textwhere resignFirstResponder];
    
    if ([mainDelegate.globalLoginStatus intValue] ==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please sign in" 
                                                        message:@""
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];

        [alert show];
        [alert release];
        return;
    }
    else
    {
        [textwhere resignFirstResponder];
        mainDelegate.globalTextWhere=@"Favourites";
        RestaurantList* vc = [[RestaurantList alloc] initWithNibName:@"RestaurantList" bundle:nil];
        [[self navigationController] pushViewController:vc animated:YES];
        [vc release];
    }
 }

@end

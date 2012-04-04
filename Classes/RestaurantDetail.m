//
//  RestaurantDetail.m
//  
//
//  Created by Sakthivel Muthusamy on 1/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//http://iphonedevelopertips.com/cocoa/launching-other-apps-within-an-iphone-application.html


#import "RestaurantDetail.h"
#import	"AppDelegate.h"
#import	"RestaurantMenu.h"
#import "RestaurantReserve.h"
#import "AddCoupon.h"
#import "RestaurantOpenHours.h"
#import "RestaurantMenuTypesList.h"

@implementation RestaurantDetail

NSMutableArray *listOfOptions;		//Holds list of options on table view

NSMutableData *receivedData;		// holds url downloads

NSArray *urlListofRestaurants;		// holds line by line data of received data
NSArray *urlListofRows;

AppDelegate *mainDelegate;


@synthesize megaAlertDetails;		// for network progress view 
@synthesize strPhone;
@synthesize strEmail;
@synthesize strWeb;
@synthesize strRestTypeFlag;


@synthesize btnMenu;
@synthesize btnCoupons;
@synthesize btnReserve;

UIImage *imgStarRed;
UIImage *imgStarGray;
UIImage *imgStarWhite;

int serviceAvailable;
NSString *strServiceAvailable;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }

    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    serviceAvailable=0;
    
	//Initialize the array
	listOfOptions = [[NSMutableArray alloc] init];
	
	//Add list row items you required
    [listOfOptions addObject:@"Services available"];
	[listOfOptions addObject:@"Call"];
	[listOfOptions addObject:@"EMail"];	
	[listOfOptions addObject:@"Website"];
	
    mainDelegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
    imgStarRed=[UIImage imageNamed:@"btn_Star.png"];
    imgStarGray=[UIImage imageNamed:@"btn_StarGray.png"];
    imgStarWhite=[UIImage imageNamed:@"btn_StarWhite.png"];
    

	//{Restaurant details dependent parts
    isSetFavourite=0;
    isRatingAllowed=0;
    [self getRestaurantFromURL:0:0];
	
	
		//}
	
    //Set title for current view
    self.title=@"Detail";
    
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


//TABLE VIEW INIT STARTS HERE

#pragma mark UITableViewDataSource

// tell our table how many rows it will have, in our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [listOfOptions count];
}

// tell our table what kind of cell to use and its title for the given row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier =@"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	//{ set images for restaurant details
	UIImage	*imageService = [UIImage imageNamed:@"imgView_Service.png"];
	UIImage	*imagePhone = [UIImage imageNamed:@"imgView_Phone.png"];
	UIImage	*imageMail = [UIImage imageNamed:@"imgView_Mail.png"];
	UIImage	*imageWeb = [UIImage imageNamed:@"imgView_Web.png"];
	
			//}
	NSString *cellValue=[listOfOptions objectAtIndex:indexPath.row];
	cell.textLabel.text = cellValue;
	
	if([indexPath	row]==0)  // Services available
	{
        if ([strServiceAvailable length]==0)
            cell.detailTextLabel.text=@"No service";
        else
            cell.detailTextLabel.text = strServiceAvailable;
        
		[cell.imageView setImage:imageService];
	}
	if([indexPath	row]==1)  // phone
	{
		cell.detailTextLabel.text = self.strPhone;
		[cell.imageView setImage:imagePhone];
	}
	if([indexPath	row]==2)  // Email
	{
		cell.detailTextLabel.text = self.strEmail;
		[cell.imageView setImage:imageMail];
	}
	if([indexPath	row]==3)  // Website
	{
		cell.detailTextLabel.text = self.strWeb;
		[cell.imageView setImage:imageWeb];
	}
	return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection	: (NSInteger) section{
	return @"";
}


-(NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger *)section{
	return @"";
	
}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
	NSString *urltobeLaunch;
	
	if([indexPath row]==1)  // phone dialer
	{
		if ([self.strPhone length]>0)
		{
			urltobeLaunch = [[NSString alloc] initWithFormat:@"tel://%@",self.strPhone];
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urltobeLaunch]];
		}
	}
	if([indexPath row]==2)	// email
	{
			if ([self.strEmail length]>0)
			{
				urltobeLaunch = [[NSString alloc] initWithFormat:@"mailto://%@",self.strEmail];
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urltobeLaunch]];
			}
	}
	if([indexPath row]==3)	// webs
	{
		if ([self.strWeb length]>0)
		{
			urltobeLaunch = [[NSString alloc] initWithFormat:@"http://%@",self.strWeb];
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urltobeLaunch]];
		}
	}
}



//{GET URL DATA STARTS HERE


- (BOOL) getRestaurantFromURL:(int)Function:(int)Ratevalue
{	
    if (([mainDelegate.globalLoginStatus intValue] ==0)&&((Function==1)||(Function==2)))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please sign in" 
                                                        message:@""
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return true;
    }

    //{Invoke network progress monitor in status bar and another on in view
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (Function==0)
        [self invokeMegaAnnoyingPopup:@"Loading"];
    if (Function==1)
        [self invokeMegaAnnoyingPopup:@"Saving"];
    if (Function==2)
    {
        [self invokeMegaAnnoyingPopup:nil];
    }
        
    //}

	//{Compose url as per previous class resID
		AppDelegate *mainDelegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
			//}
    NSString *reqURL;
    if(Function==0) // rest details
        reqURL=[NSString stringWithFormat:@"%@?apiid=11020&usr=%@&restid=%@",mainDelegate.globalMainUrl, mainDelegate.globalUserName,mainDelegate.globalRestaurantId];
    if(Function==1) // rating submit
        reqURL=[NSString stringWithFormat:@"%@?apiid=11040&usr=%@&restid=%@&rate=%1d",mainDelegate.globalMainUrl, mainDelegate.globalUserName,mainDelegate.globalRestaurantId,Ratevalue];
    if(Function==2) // set,remove favourite
        reqURL=[NSString stringWithFormat:@"%@?apiid=11050&usr=%@&restid=%@",mainDelegate.globalMainUrl, mainDelegate.globalUserName,mainDelegate.globalRestaurantId];
	
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:reqURL]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:60.0];
	// create the connection with the request
	// and start loading the data
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		// Create the NSMutableData to hold the received data.
		// receivedData is an instance variable declared elsewhere.
		receivedData = [[NSMutableData data] retain];
		
	} 
	else
	{
		// Inform the user that the connection failed.
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failed !" 
														message:@"Retry"
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles: nil];
		
		[alert show];
		[alert release];
	}
	
	
	return FALSE;
	
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}



- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
	
	//{Dismiss network monitor in status bar and in view 
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self dismissMegaAnnoyingPopup];
	//}
	
	if (error!=NULL)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection failed" 
														message:@"Retry"
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles: nil];
		
		[alert show];
		[alert release];
		
	}

	
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //{Dismiss network monitor in status bar and in view 
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self dismissMegaAnnoyingPopup];
	//}

	NSString *strMsg = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	
    strServiceAvailable=@"";
	
	int strLen=0;
	int objPos=0;		// add object position increment
	NSString *strLine;  // hold one line of received data ie one restaurant's data
    int intApiReturnId;
    int intApiReturnStatus;
    urlListofRows=[strMsg componentsSeparatedByString:@"#"];
	urlListofRestaurants=[[urlListofRows objectAtIndex:1] componentsSeparatedByString:@"|"];
	
	if([urlListofRestaurants count]>=2)
    {
        //Validate the datas received
        intApiReturnId=[[urlListofRestaurants objectAtIndex:0] intValue];
        intApiReturnStatus=[[urlListofRestaurants objectAtIndex:1] intValue];
    }
    else
    {
        intApiReturnId=0;
        intApiReturnStatus=0;
    }
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[urlListofRestaurants objectAtIndex:0]
                                                    message:nil
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    
    [alert show];
    [alert release];
   */
    if(intApiReturnId==11020)  // REST DETAILS
    {
            strLine=[urlListofRestaurants objectAtIndex:3];			//1: restaurnat name
            self.strPhone=[urlListofRestaurants objectAtIndex:5];	//3: phone number
            self.strEmail=[urlListofRestaurants objectAtIndex:7];	//5: email
            self.strWeb=[urlListofRestaurants objectAtIndex:6];		//4: web
            self.strRestTypeFlag=[urlListofRestaurants objectAtIndex:16];	//16: Restaurant type Flag

            strLen=[strLine length];

          //Add the validated object into memory
            if(strLen>4)
            {
                objPos=objPos+1;
            }

        int enableMenu=0;
        int enableReserve=0;
        int enableCoupon=0;
        int openClose=0;
        NSString *resString=[[NSString alloc] initWithFormat: @"%@\n%@\n%@",
                       [urlListofRestaurants objectAtIndex:3], // name
                       [urlListofRestaurants objectAtIndex:4], // Address 
                       [urlListofRestaurants objectAtIndex:5]  // Phone
                       ];
        resAddress.text=resString;
        
        resOpenHours.text=[urlListofRestaurants objectAtIndex:13];
        mainDelegate.globalOpenHours=[urlListofRestaurants objectAtIndex:13];;

        //Disable the unwanted buttons
        enableMenu=0;
        enableReserve=0;
        enableCoupon=0;
        enableMenu=[[urlListofRestaurants objectAtIndex:8] intValue];
        enableReserve=[[urlListofRestaurants objectAtIndex:9] intValue];
        enableCoupon=[[urlListofRestaurants objectAtIndex:10] intValue];
        isSetFavourite=[[urlListofRestaurants objectAtIndex:11] intValue];
        openClose=[[urlListofRestaurants objectAtIndex:12] intValue];
        
        isRatingAllowed=[[urlListofRestaurants objectAtIndex:14] intValue];
        if (isRatingAllowed==1) 
        {
             [btnLabel setText:@"Rate ?"];
        }
        else
        {
            [btnLabel setText:@"Rating"];
        }
            
       
        
        if (enableMenu==0) btnMenu.hidden=TRUE;
        if (enableReserve==0) btnReserve.hidden=TRUE;
        if (enableCoupon==0) btnCoupons.hidden=TRUE;
        
        [self DisplayRating:[[urlListofRestaurants objectAtIndex:15] intValue]];
        serviceAvailable=[[urlListofRestaurants objectAtIndex:17] intValue];
        
        
        NSString *strAppDining=@"";
        NSString *strAppTakeout=@"";
        NSString *strAppDelivery=@"";
         if((serviceAvailable&0x01)==0x01)
        {
            strAppDining=@"Dinein";
        }
        if((serviceAvailable&0x02)==0x02)
        {
            strAppTakeout=@"Takeout";
        }
        if((serviceAvailable&0x04)==0x04)
        {
            strAppDelivery=@"Delivery";
        }
        strServiceAvailable= [[NSString alloc] initWithFormat: @"%@ %@ %@",
                                   strAppDining,strAppTakeout,strAppDelivery];
        
                
        // release the connection, and the data object    
        [myTableDetails reloadData];
        
        //{Load restuarant logo
        NSString *imgURL;
        //imgURL=[NSString stringWithFormat:@"http://diner-choice.com/mekro/images/%@.png",[urlListofRestaurants objectAtIndex:17]];
        imgURL=[NSString stringWithFormat:@"http://www.diner-choice.com/imgctlr?a=%@&logo=yes",[urlListofRestaurants objectAtIndex:2]];
        NSURL *url = [NSURL URLWithString:imgURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        restLogoDownload.image = [[UIImage alloc] initWithData:data];
        //}
    }
    
    int dispMsgFlag=0;
    NSString *dispMsg;
    if(intApiReturnId==11040) // RATE NOW
         {      
            switch (intApiReturnStatus) 
            {
                case 10:
                {
                    dispMsgFlag=0;
                    dispMsg=@"Rated";
               }
                    break;
                case 11:
                {
                    dispMsgFlag=1;
                    dispMsg=@"Rating failed !";
                }
                    break;
            } // End of switch
        }// End of login if
    
    if(intApiReturnId==11050) // ADD,REMOVE FAVOURITE
    {      
        switch (intApiReturnStatus) 
        {
            case 10:
            {
                dispMsgFlag=0;
                dispMsg=@"Changed";
                isSetFavourite=[[urlListofRestaurants objectAtIndex:2] intValue];
            }
                break;
            case 11:
            {
                dispMsgFlag=1;
                dispMsg=@"Failed !";
            }
                break;
        } // End of switch
       
    }// End of login if
     [self setFavouriteImage];
    
    //Handle warning and report levels
    if(dispMsgFlag==1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:dispMsg
                                                        message:nil
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        
        [alert show];
        [alert release];
    }
	

    [connection release];
    [receivedData release];
           
}

//GET URL DATA ENDS HERE




// {NETWORK PROGRESS VIEW START FROM HERE

-(void)invokeMegaAnnoyingPopup:(NSString *) msg
{
	self.megaAlertDetails = [[[UIAlertView alloc] initWithTitle:msg
												 message:nil delegate:self cancelButtonTitle:nil
									   otherButtonTitles: nil] autorelease];
	[self.megaAlertDetails show];
	
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]
										  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	indicator.center = CGPointMake(self.megaAlertDetails.bounds.size.width / 2,
								   self.megaAlertDetails.bounds.size.height - 45);
	[indicator startAnimating];
	[self.megaAlertDetails addSubview:indicator];
	[indicator release];
}

-(void)dismissMegaAnnoyingPopup
{
	[self.megaAlertDetails dismissWithClickedButtonIndex:0 animated:YES];
	self.megaAlertDetails = nil;
}

// NETWORK PROGRESS VIEW ENDS HERE

- (void)actionSheet:(UIActionSheet *)actionSheet 
didDismissWithButtonIndex:(NSInteger)buttonIndex 
{ 
    
        if (buttonIndex == [actionSheet destructiveButtonIndex]) 
        { 
            [self getRestaurantFromURL:2:0];   
        }     
} 

-(void) setFavouriteImage
{
    UIImage	*imageFavourite = [UIImage imageNamed:@"btn_NotFav.png"];

    if(isSetFavourite==1)
    {
        [btnFavouriteChange setImage:imageFavourite forState:UIControlStateNormal];
   }
    if(isSetFavourite==0)
    {
        [btnFavouriteChange setImage:nil forState:UIControlStateNormal];
    }

}

- (IBAction) launchMenu
{
    if([self.strRestTypeFlag isEqualToString:@"1"])
    {
        
        //{Push to next detail view
        RestaurantMenuTypesList* resvc1 = [[RestaurantMenuTypesList alloc] initWithNibName:@"RestaurantMenuTypesList" bundle:nil]; 
        [[self navigationController] pushViewController:resvc1 animated:YES];	
        //}
  }
    else
    {
        //{Push to next detail view
        RestaurantMenu* resvc2 = [[RestaurantMenu alloc] initWithNibName:@"RestaurantMenu" bundle:nil]; 
        
        [[self navigationController] pushViewController:resvc2 animated:YES];	
        //}
    }
	
}
- (IBAction) launchReserve
{
    mainDelegate.globalAddReserveOrEdit=[NSNumber numberWithInt:0];
    
  	//{Push to next detail view
	RestaurantReserve* resvc2 = [[RestaurantReserve alloc] initWithNibName:@"RestaurantReserve" bundle:nil]; 
	[[self navigationController] pushViewController:resvc2 animated:YES];	
	//}
}

- (IBAction) launchCoupons
{    
    //{Push to next detail view
	AddCoupon* resvc2 = [[AddCoupon alloc] initWithNibName:@"AddCoupon" bundle:nil]; 
	[[self navigationController] pushViewController:resvc2 animated:YES];
	//}
}

-(IBAction) launchOpenHours
{
    //{Push to next detail view
	RestaurantOpenHours* resvc2 = [[RestaurantOpenHours alloc] initWithNibName:@"RestaurantOpenHours" bundle:nil]; 
	[[self navigationController] pushViewController:resvc2 animated:YES];
	//}
}

-(IBAction) Rating1Pressed
{
    if (isRatingAllowed==0) return;
                           
    [btnRate1 setBackgroundImage:imgStarRed forState:UIControlStateNormal];
    [btnRate2 setBackgroundImage:imgStarWhite forState:UIControlStateNormal];
    [btnRate3 setBackgroundImage:imgStarWhite forState:UIControlStateNormal];
    [btnRate4 setBackgroundImage:imgStarWhite forState:UIControlStateNormal];
    [btnRate5 setBackgroundImage:imgStarWhite forState:UIControlStateNormal];
    [self getRestaurantFromURL:1:1];
}


-(void) DisplayRating:(int) Rated
{
    if(Rated>=1)
        [btnRate1 setBackgroundImage:imgStarRed forState:UIControlStateNormal];
    else 
        [btnRate1 setBackgroundImage:imgStarWhite forState:UIControlStateNormal];
    
    if(Rated>=2)
        [btnRate2 setBackgroundImage:imgStarRed forState:UIControlStateNormal];
    else 
        [btnRate2 setBackgroundImage:imgStarWhite forState:UIControlStateNormal];
    
    if(Rated>=3)
        [btnRate3 setBackgroundImage:imgStarRed forState:UIControlStateNormal];
    else 
        [btnRate3 setBackgroundImage:imgStarWhite forState:UIControlStateNormal];
    
    if(Rated>=4)
        [btnRate4 setBackgroundImage:imgStarRed forState:UIControlStateNormal];
    else 
        [btnRate4 setBackgroundImage:imgStarWhite forState:UIControlStateNormal];
    
    if(Rated>=5)
        [btnRate5 setBackgroundImage:imgStarRed forState:UIControlStateNormal];
    else 
        [btnRate5 setBackgroundImage:imgStarWhite forState:UIControlStateNormal];
     }

-(IBAction) Rating2Pressed
{
    if (isRatingAllowed==0) return;
    [btnRate1 setBackgroundImage:imgStarRed forState:UIControlStateNormal];
    [btnRate2 setBackgroundImage:imgStarRed forState:UIControlStateNormal];
    [btnRate3 setBackgroundImage:imgStarWhite forState:UIControlStateNormal];
    [btnRate4 setBackgroundImage:imgStarWhite forState:UIControlStateNormal];
    [btnRate5 setBackgroundImage:imgStarWhite forState:UIControlStateNormal];
    [self getRestaurantFromURL:1:2];
}
-(IBAction) Rating3Pressed
{
    if (isRatingAllowed==0) return;
    [btnRate1 setBackgroundImage:imgStarRed forState:UIControlStateNormal];
    [btnRate2 setBackgroundImage:imgStarRed forState:UIControlStateNormal];
    [btnRate3 setBackgroundImage:imgStarRed forState:UIControlStateNormal];
    [btnRate4 setBackgroundImage:imgStarWhite forState:UIControlStateNormal];
    [btnRate5 setBackgroundImage:imgStarWhite forState:UIControlStateNormal];
    [self getRestaurantFromURL:1:3];
}
-(IBAction) Rating4Pressed
{
    if (isRatingAllowed==0) return;
    [btnRate1 setBackgroundImage:imgStarRed forState:UIControlStateNormal];
    [btnRate2 setBackgroundImage:imgStarRed forState:UIControlStateNormal];
    [btnRate3 setBackgroundImage:imgStarRed forState:UIControlStateNormal];
    [btnRate4 setBackgroundImage:imgStarRed forState:UIControlStateNormal];
    [btnRate5 setBackgroundImage:imgStarWhite forState:UIControlStateNormal];
    [self getRestaurantFromURL:1:4];
}
-(IBAction) Rating5Pressed
{
    if (isRatingAllowed==0) return;
    [btnRate1 setBackgroundImage:imgStarRed forState:UIControlStateNormal];
    [btnRate2 setBackgroundImage:imgStarRed forState:UIControlStateNormal];
    [btnRate3 setBackgroundImage:imgStarRed forState:UIControlStateNormal];
    [btnRate4 setBackgroundImage:imgStarRed forState:UIControlStateNormal];
    [btnRate5 setBackgroundImage:imgStarRed forState:UIControlStateNormal];
    [self getRestaurantFromURL:1:5];
}


-(IBAction) setFavourite
{
    NSString *strFavAction=[NSString alloc];
    if(isSetFavourite==0)
        strFavAction=@"Add to bookmark";
    if(isSetFavourite==1)
        strFavAction=@"Remove from bookmark";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                  initWithTitle:@"What to do ?" 
                                  delegate:self 
                                  cancelButtonTitle:@"No" 
                                  destructiveButtonTitle:strFavAction 
                                  otherButtonTitles:nil]; 
    

    [actionSheet showInView:self.parentViewController.tabBarController.view];
    [actionSheet release];
    [self setFavouriteImage];
    
    
}

@end

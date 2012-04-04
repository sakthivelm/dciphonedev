//
//  Reservations.m
//  
//
//  Created by Sakthivel Muthusamy on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Reservations.h"
#import "AppDelegate.h" 
#import "Login.h"
#import "RestaurantReserve.h"


@implementation Reservations

NSMutableData *receivedData;		// holds url downloads

NSArray *urlListofRows;             // holds line by line data of received data
NSArray *urlListofColumns;			// holds spilited data of one restaurant



NSMutableArray *tableFinalList;     //Holds list of options on table view


AppDelegate *mainDelegate;

@synthesize megaAlert;				// for network progress view 
//@synthesize segmentedReservations;
//@synthesize reservationToolBar;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mainDelegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
    self.navigationController.navigationBar.tintColor=mainDelegate.globalNavigationBarColor;
    //reservationToolBar.tintColor=mainDelegate.globalNavigationBarColor;

    //{Push to login
    if ([mainDelegate.globalLoginStatus intValue] ==0)
    {
        Login* vclogin = [[Login alloc] initWithNibName:@"Login" bundle:nil]; 
        [[self navigationController] pushViewController:vclogin animated:YES];	
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void) viewWillAppear:(BOOL)animated{
    if ([mainDelegate.globalLoginStatus intValue] ==1)
    {
        [self viewReservations];
    }
    if ([mainDelegate.globalLoginStatus intValue] ==0)
    {
        Login* vclogin = [[Login alloc] initWithNibName:@"Login" bundle:nil]; 
        [[self navigationController] pushViewController:vclogin animated:YES];
        return;
    }

}

/*
- (IBAction) segmentedControlIndexChanged
{

    switch (self.segmentedReservations.selectedSegmentIndex) {
        case 0:
            mainDelegate.globalReservationOption=[NSNumber numberWithInt: 0];
            break;
        case 1:
            mainDelegate.globalReservationOption=[NSNumber numberWithInt: 1];
            break;
        default:
            break;
    }
    if ([mainDelegate.globalLoginStatus intValue] ==1)
    {
        [self viewReservations];
    }
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction) viewReservations
{
    [self getFormatedDataFromURL];
	
}



//TABLE INITIAL SETUP BEGINS HERE

// tell our table how many rows it will have, in our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableFinalList count];
    
}

// tell our table what kind of cell to use and its title for the given row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    NSString *cellValue=[tableFinalList objectAtIndex:indexPath.row];
    
    urlListofColumns=[cellValue componentsSeparatedByString:@"|"];
    
    //cell.textLabel.text = cellValue;
    //cell.detailTextLabel.text = strMsg;
    //[mainDelegate.globalReservationDate 
    
    NSString *titleCell=
    [[NSString alloc] initWithFormat: @"%@ (%@ mins)"
     ,[urlListofColumns	objectAtIndex:1]
     ,[urlListofColumns	objectAtIndex:2]
     ];   
    NSString *DescCell= [[NSString alloc] initWithFormat: @"%@-%@-%@ Seat(s)"
                         ,[urlListofColumns	objectAtIndex:3]
                         ,[urlListofColumns	objectAtIndex:5]
                         ,[urlListofColumns	objectAtIndex:4]
                         ];
    cell.textLabel.text =titleCell; 
    cell.detailTextLabel.text = DescCell;
    cell.detailTextLabel.textColor=[UIColor blueColor];
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
    int exceptionThrow=0;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    //[dateformater setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSLocale *USlocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateformater setLocale:USlocale];
   
    NSString *selectedRest=[tableFinalList objectAtIndex:indexPath.row];  
    
    @try {
         urlListofColumns=[selectedRest componentsSeparatedByString:@"|"];
        
        mainDelegate.globalReservationID=[urlListofColumns objectAtIndex:0];
        
       mainDelegate.globalReservationDate=[dateformater dateFromString:[urlListofColumns objectAtIndex:1]];
        mainDelegate.globalReservationDuration=[urlListofColumns objectAtIndex:2];
        mainDelegate.globalRestaurantName=[urlListofColumns objectAtIndex:3];
        mainDelegate.globalReservationSeats=[urlListofColumns objectAtIndex:4];
        mainDelegate.globalReservationNotes=[urlListofColumns objectAtIndex:6];

        mainDelegate.globalAddReserveOrEdit=[NSNumber numberWithInt:1];

    }
    @catch (NSException *e) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid data...!" 
														message:@"Try again"
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles: nil];
		
		[alert show];
		[alert release];
        exceptionThrow=1;
    }
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[mainDelegate.globalReservationDate description]
                                                    message:[urlListofColumns objectAtIndex:1]
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    
    [alert show];
    [alert release];
     */

    if(exceptionThrow==0)
    {
        //{Push to next detail view
        RestaurantReserve* resvc2 = [[RestaurantReserve alloc] initWithNibName:@"RestaurantReserve" bundle:nil]; 
        [[self navigationController] pushViewController:resvc2 animated:YES];	
        //}
    }
     
}
//TABLE INITIALIZATION ENDS HERE

//{GET URL DATA STARTS HERE


- (BOOL) getFormatedDataFromURL
{
    //{Invoke network progress monitor in status bar and another on in view
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self invokeMegaAnnoyingPopup];
    //}

    tableFinalList = [[NSMutableArray alloc] init];  
    
	NSString *reqURL;
    
    //if([mainDelegate.globalReservationOption intValue]==0)
       reqURL=[NSString stringWithFormat:@"%@?apiid=13020&usr=%@",mainDelegate.globalMainUrl, mainDelegate.globalUserName];
	
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:reqURL]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:60.0];
	// create the connection with the request
	// and start loading the data
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
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

    
    int intApiReturnId=0;
    int intApiReturnStatus=0;
    int dispMsgFlag=0;
    NSString *dispMsg;
	
 	NSString *strMsg = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	int strLen=0;
	int objPos=0;		// add object position increment
	NSString *strLine;  // hold one line of received data ie one restaurant's data

	
	urlListofRows=[strMsg componentsSeparatedByString:@"#"];
    urlListofColumns=[[urlListofRows objectAtIndex:1] componentsSeparatedByString:@"|"];

    
    if([urlListofColumns count]>=2)
    {
        intApiReturnId=[[urlListofColumns objectAtIndex:0] intValue];
        intApiReturnStatus=[[urlListofColumns objectAtIndex:1] intValue];
    }

    //LOGIN : Verification
    if((intApiReturnId==13020)||(intApiReturnId==13030))
    {      
        switch (intApiReturnStatus) 
        {
            case 10:
            {
                dispMsgFlag=0;
                dispMsg=@"Data found !";
            }
                break;
            case 11:
            {
                dispMsgFlag=1;
                dispMsg=@"Failed";
            }
                break;
            case 12:
            {
                dispMsgFlag=0;
                dispMsg=@"Not Logged in";
            }
                break;
        } // End of switch
    }// End of login if
    
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
        
        if(intApiReturnStatus==10)
        {
           // [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
 
    for(int i=2; i<[urlListofRows count];i++)
 	{
		//Validate the datas received
		strLine=[urlListofRows objectAtIndex:i];
		strLen=[strLine length];
		
		
		//Add the validated object into memory
		if(strLen>4)
		{
			[tableFinalList addObject:strLine];
			objPos=objPos+1;
            
		}		
	}
    
    
	//{Dismiss network monitor in status bar and in view 
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self dismissMegaAnnoyingPopup];
	//}
	
	
	if(objPos==0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No reservation found !" 
														message:nil
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles: nil];
		
		[alert show];
		[alert release];
	}
    // release the connection, and the data object
	
	[IBReservationTable reloadData];
	
    [connection release];
    [receivedData release];
}

//GET URL DATA ENDS HERE


// {NETWORK PROGRESS VIEW START FROM HERE

-(void)invokeMegaAnnoyingPopup
{
    self.megaAlert = [[[UIAlertView alloc] initWithTitle:@"Loading..."
                                                 message:nil delegate:self cancelButtonTitle:nil
                                       otherButtonTitles: nil] autorelease];
    
    [self.megaAlert show];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]
                                          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    indicator.center = CGPointMake(self.megaAlert.bounds.size.width / 2,
                                   self.megaAlert.bounds.size.height - 45);
    [indicator startAnimating];
    [self.megaAlert addSubview:indicator];
    [indicator release];
}

-(void)dismissMegaAnnoyingPopup
{
    [self.megaAlert dismissWithClickedButtonIndex:0 animated:YES];
    self.megaAlert = nil;
}

// NETWORK PROGRESS VIEW ENDS HERE



@end

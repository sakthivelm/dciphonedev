//
//  RestaurantReserve.m
//  
//
//  Created by Sakthivel Muthusamy on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RestaurantReserve.h"
#import "AppDelegate.h"
#import "Login.h"


@implementation RestaurantReserve

@synthesize btnSave;
@synthesize btnDel;

NSMutableData *receivedData;		// holds url downloads

NSArray *urlResponseStructures;     // spilited by #

NSArray *urlListofCmdRows;          // holds line by line data of received data
//NSArray *urlListofDataRows;         // holds line by line data of received data

NSArray *urlListofCols;				// holds spilited data of one Row

NSMutableArray *tableListofRows;	//Holds list of options on table view


@synthesize megaAlert;

AppDelegate *mainDelegate ;

int localDeleteCall;


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
    reserveDate=[[UIDatePicker alloc] init];

    // Do any additional setup after loading the view from its nib.
    //{Display restaurant name from global variable
	AppDelegate *mainDelegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
	//}
    if( mainDelegate.globalAddReserveOrEdit==[NSNumber numberWithInt:0]) // Add reservation
    {
        reserveSeats.text=@"1";
        reserveDuration.text=@"15";
        self.title=@"Reservation";
        reserveDate.date=[NSDate date];
    }
    else  // Edit reservations
    {
        reserveDate.date=mainDelegate.globalReservationDate;
        
        reserveDuration.text=mainDelegate.globalReservationDuration;
        reserveSeats.text=mainDelegate.globalReservationSeats;
        reserveNotes.text=mainDelegate.globalReservationNotes;

        self.title=@"Edit Reservation";
    }
    
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[mainDelegate.globalReservationDate description]
                                                    message:nil
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    
    [alert show];
    [alert release];
    */
    
    
    restaurantName.text=mainDelegate.globalRestaurantName;
    localDeleteCall=0;
    
    [self displayDate];
}

-(void) displayDate
{
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
    NSString *textDate=[NSString stringWithFormat:@"%@",[dateformat stringFromDate:reserveDate.date]];
    
    //btnDate.titleLabel.text=textDate;
    [btnDate setTitle:textDate forState:UIControlStateNormal];
}

- (void)actionSheet:(UIActionSheet *)actionSheet 
didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
    [self displayDate];
 } 

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
	if (textField == reserveSeats)
	{
		[reserveSeats resignFirstResponder];
		[reserveDuration becomeFirstResponder];
	}
	if (textField == reserveDuration)
	{
		[reserveDuration resignFirstResponder];
        [reserveNotes becomeFirstResponder];
	}
	if (textField == reserveNotes)
	{
		[reserveNotes resignFirstResponder];
	}
	return YES;
    
}

- (IBAction) initSave
{
    [self initDownloadDataFromURL];
}

- (IBAction) delReservation
{
    localDeleteCall=1;
    [self initDownloadDataFromURL];
}

- (IBAction) getDate
{
    NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                  initWithTitle:[NSString stringWithFormat:@"%@%@",title, NSLocalizedString(@"Set Date", @"")]
                                  delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    reserveDate.datePickerMode=UIDatePickerModeDateAndTime;
     reserveDate.minimumDate=[NSDate date];
    reserveDate.minuteInterval=5;
    [actionSheet addSubview:reserveDate];
    
    //[actionSheet showInView:self.view];
    [actionSheet showInView:self.parentViewController.tabBarController.view];
    
}

//GET URL CONNECTION

- (BOOL) initDownloadDataFromURL
{
    //{Invoke network progress monitor in status bar and another on in view
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[self invokeMegaAnnoyingPopup];
	//}

    
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"YYYYMMdd"];
    NSDateFormatter *timeformat = [[NSDateFormatter alloc] init];
    [timeformat setDateFormat:@"HH:mm"];
	NSString *reqURL;    
    NSString *textDate=[NSString stringWithFormat:@"%@",[dateformat stringFromDate:reserveDate.date]];
    NSString *textTime=[NSString stringWithFormat:@"%@",[timeformat stringFromDate:reserveDate.date]];

    if( mainDelegate.globalAddReserveOrEdit==[NSNumber numberWithInt:0]) // Add reservation
    {  
        reqURL=[NSString stringWithFormat:@"%@?apiid=13010&usr=%@&restid=%@&date=%@&time=%@&dura=%@&seats=%@&notes=%@",
            mainDelegate.globalMainUrl,mainDelegate.globalUserName,mainDelegate.globalRestaurantId,
            textDate,textTime,reserveDuration.text,reserveSeats.text,reserveNotes.text
            ];
    }
    if( mainDelegate.globalAddReserveOrEdit==[NSNumber numberWithInt:1]) // Add reservation
    {
        reqURL=[NSString stringWithFormat:@"%@?apiid=13040&usr=%@&rvid=%@&date=%@&time=%@&dura=%@&seats=%@&notes=%@",
                mainDelegate.globalMainUrl,mainDelegate.globalUserName,mainDelegate.globalReservationID,
                textDate,textTime,reserveDuration.text,reserveSeats.text,reserveNotes.text
                ];
   
    }
    if(localDeleteCall==1) // Add reservation
    {
        reqURL=[NSString stringWithFormat:@"%@?apiid=13050&usr=%@&rvid=%@",
                mainDelegate.globalMainUrl,mainDelegate.globalUserName,mainDelegate.globalReservationID
                ];
        
    }
	
    NSString *reqUrlEncoded;
    reqUrlEncoded=[NSString stringWithFormat:@"%@",[reqURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:reqUrlEncoded]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:60.0];
 

   /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: reqUrlEncoded
                                                    message:@"** DATE **"
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    
    [alert show];
    [alert release];
    */
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

    // receivedData is declared as a method instance elsewhere	
 	NSString *strMsg = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    int intApiReturnId=0;
    int intApiReturnStatus=0;
    
    int dispMsgFlag=0;
    NSString *dispMsg;
    
    //******Data parsing starts here
    urlResponseStructures = [strMsg componentsSeparatedByString:@"#"];  
    // Row1: Responses commands |
    // Row2: Datas seperated by |
    
    urlListofCmdRows=[[urlResponseStructures objectAtIndex:1] componentsSeparatedByString:@"|"];
    // Each row contains spilited data of command ids
    
    //urlListofDataRows=[[urlResponseStructures objectAtIndex:2] componentsSeparatedByString:@"|"];
    // Each row contains spilited data of datasets
    
    //******Dataprocessing starts here
    //Convert download status code to integer
    if([urlListofCmdRows count]>=2)
    {
        intApiReturnId=[[urlListofCmdRows objectAtIndex:0] intValue];
        intApiReturnStatus=[[urlListofCmdRows objectAtIndex:1] intValue];
    }
    //LOGIN : Verification
    if((intApiReturnId==13010)||(intApiReturnId==13040)||(intApiReturnId==13050))
    {      
        switch (intApiReturnStatus) 
        {
            case 10:
            {
                dispMsgFlag=1;
                if((intApiReturnId==13010)) dispMsg=@"Reserved Successfully";
                if((intApiReturnId==13040)) dispMsg=@"Modified Successfully";
                if((intApiReturnId==13050)) {dispMsg=@"Deleted Successfully";dispMsgFlag=0;}
            }
                break;
            case 11:
            {
                dispMsgFlag=1;
                if((intApiReturnId==13010)) dispMsg=@"Not Reserved, Try Again";
                if((intApiReturnId==13040)) dispMsg=@"Not Modified, Try Again";
                if((intApiReturnId==13050)) dispMsg=@"Not Deleted, Try Again";
            }
                break;
            case 12:
            {
                dispMsgFlag=1;
                if((intApiReturnId==13010)||(intApiReturnId==13040))
                {
                    dispMsg=[urlListofCmdRows objectAtIndex:2]; //Server Return Message
                }
            }
                break;
            case 13:
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
        
        
    }
        
    [connection release];
    [receivedData release];
    
    //if((intApiReturnStatus==13)||([mainDelegate.globalLoginStatus intValue] ==0))
    if(intApiReturnStatus==13)
    {
        Login* vclogin = [[Login alloc] initWithNibName:@"Login" bundle:nil]; 
        [[self navigationController] pushViewController:vclogin animated:YES];
    }
    if(intApiReturnStatus==10)
    {
        localDeleteCall=0;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//GET URL DATA ENDS HERE

// {NETWORK PROGRESS VIEW START FROM HERE

-(void)invokeMegaAnnoyingPopup
{
	self.megaAlert = [[[UIAlertView alloc] initWithTitle:@"Wait..."
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

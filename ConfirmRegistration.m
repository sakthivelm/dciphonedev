//
//  ConfirmRegistration.m
//  
//
//  Created by Sakthivel Muthusamy on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConfirmRegistration.h"
#import "AppDelegate.h"
#import "Home.h"

NSMutableData *receivedData;		// holds url downloads

NSArray *urlResponseStructures;     // spilited by #

NSArray *urlListofCmdRows;          // holds line by line data of received data
NSArray *urlListofDataRows;         // holds line by line data of received data

NSArray *urlListofCols;				// holds spilited data of one Row

NSMutableArray *tableListofRows;	//Holds list of options on table view

AppDelegate *mainDelegate ;


@implementation ConfirmRegistration

@synthesize megaAlert;

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

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
	if (textField == ConfirmCode)
	{
		[ConfirmCode resignFirstResponder];
		[btnConfirm becomeFirstResponder];
	}
	return YES;
    
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mainDelegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];

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


//{GET URL DATA STARTS HERE



-(IBAction) confirmAction
{
    [self initDownloadDataFromURL];  
    
}

- (BOOL) initDownloadDataFromURL
{
    //{Invoke network progress monitor in status bar and another on in view
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self invokeMegaAnnoyingPopup];
    //}

    tableListofRows = [[NSMutableArray alloc] init];  
    
	NSString *reqURL;
    
    
    reqURL=[NSString stringWithFormat:@"%@?apiid=10030&usr=%@&vcode=%@",mainDelegate.globalMainUrl, mainDelegate.globalUserName,ConfirmCode.text];
    
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
    
    urlListofDataRows=[[urlResponseStructures objectAtIndex:2] componentsSeparatedByString:@"|"];
    // Each row contains spilited data of datasets
    
    //******Dataprocessing starts here
    //Convert download status code to integer
    intApiReturnId=[[urlListofCmdRows objectAtIndex:0] intValue];
    intApiReturnStatus=[[urlListofCmdRows objectAtIndex:1] intValue];
    
    //LOGIN : Verification
    if(intApiReturnId==10030)
    {      
        switch (intApiReturnStatus) 
        {
            case 10:
            {
                dispMsgFlag=1;
                dispMsg=@"VERIFICATION SUCCESS";
                mainDelegate.globalLoginStatus=[NSNumber numberWithFloat: 1];
            }
                break;
            default:
                {
                dispMsgFlag=1;
                dispMsg=@"Verification failed, Retry with correct verification code!";
                }
                break;
        } // End of switch
    
    
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
        
        if(intApiReturnStatus==10)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }// End of login if
    
}

//GET URL DATA ENDS HERE

// {NETWORK PROGRESS VIEW START FROM HERE

-(void)invokeMegaAnnoyingPopup
{
	self.megaAlert = [[[UIAlertView alloc] initWithTitle:@"Wait.."
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

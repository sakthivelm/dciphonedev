//
//  Login.m
//  
//
//  Created by Sakthivel Muthusamy on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import	"AppDelegate.h"
#import "Login.h"
#include "Home.h"
#include "JoinNow.h"
#include "ConfirmRegistration.h"

@implementation Login


NSMutableData *receivedData;		// holds url downloads

NSArray *urlResponseStructures;     // spilited by #

NSArray *urlListofCmdRows;          // holds line by line data of received data
NSArray *urlListofDataRows;         // holds line by line data of received data

NSArray *urlListofCols;				// holds spilited data of one Row

NSMutableArray *tableListofRows;	//Holds list of options on table view

AppDelegate *mainDelegate ;

@synthesize megaAlert;


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
	if (textField == textUserName)
	{
		[textUserName resignFirstResponder];
		[textPassWord becomeFirstResponder];
	}
	else {
		if (textField==textPassWord)
			[textPassWord resignFirstResponder];
    }
	return YES;

 }


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    self.navigationItem.title=@"Login";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}



/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


-(void) viewWillAppear:(BOOL)animated{
    
    if ([mainDelegate.globalLoginStatus intValue] ==1)
    {
        [[self navigationController] popViewControllerAnimated:YES];
        return;
    }
    
    
}

- (IBAction) doLogin    
{
    [self initDownloadDataFromURL:1];
}


-(IBAction) doForgotPassword
{
    if ([textUserName.text length]>0)
    {
        [self initDownloadDataFromURL:2];   
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Forgot Password" 
														message:@"Please enter user ID then try !"
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles: nil];
		
		[alert show];
		[alert release];

    }
   
}


-(IBAction) doCreateAccount
{
    mainDelegate.globalJoinNowUpdateFlag=[NSNumber numberWithInt:0];
    JoinNow* vc = [[JoinNow alloc] initWithNibName:@"JoinNow" bundle:nil];
	[[self navigationController] pushViewController:vc animated:YES];
	[vc release];
}


//{GET URL DATA STARTS HERE

- (BOOL) initDownloadDataFromURL:(int)url
{
    //{Invoke network progress monitor in status bar and another on in view
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self invokeMegaAnnoyingPopup];
    //}
       
    tableListofRows = [[NSMutableArray alloc] init];  
	NSString *reqURL;
    
    if(url==1) // login
        reqURL=[NSString stringWithFormat:@"%@?apiid=10010&usr=%@&pwd=%@",mainDelegate.globalMainUrl, textUserName.text,textPassWord.text];
    if(url==2) // forgot password
        reqURL=[NSString stringWithFormat:@"%@?apiid=10040&usr=%@",mainDelegate.globalMainUrl,textUserName.text];
    
    mainDelegate.globalUserName=textUserName.text;
    mainDelegate.globalPassword=textPassWord.text;
	
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
    if(intApiReturnId==10010)
    {      
        switch (intApiReturnStatus) 
        {
            case 10:
                {
                    
                    [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:[urlListofCmdRows objectAtIndex:2]];
                    
                        dispMsgFlag=0;
                        dispMsg=@"SUCCESS";
                }
                break;
            case 11:
                {
                    dispMsgFlag=1;
                    dispMsg=@"NOT REGISTERED";
                }
                break;
            case 12:
                {
                    dispMsgFlag=1;
                    dispMsg=@"INVALID";
                }
                break;
            case 13:
                {
                    dispMsgFlag=0;
                    //dispMsg=@"NOT ACTIVATED";
                    [self verifyConfirmationCode];
                }
                break;
            case 14:
                {
                    dispMsgFlag=1;
                    dispMsg=@"EXPIRED";
                }
                break;
            default:
                break;
        } // End of switch
    }// End of login if
    
    //Forgot Password
    if(intApiReturnId==10040)
        {
            switch (intApiReturnStatus) 
            {
                case 10:
                {
                    dispMsgFlag=1;
                    dispMsg=@"Your password sent to your email";
                }
                    break;
                case 11:
                {
                    dispMsgFlag=1;
                    dispMsg=@"FAILED";
                }
                    break;
                default:
                    break;
            } // End of switch
        }//end of forgot password if
    
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


    if((intApiReturnId==10010)&&(intApiReturnStatus==10))
    {
        mainDelegate.globalLoginStatus=[NSNumber numberWithFloat: 1];
        [[self navigationController] popViewControllerAnimated:YES];
    }
    else
    {
        mainDelegate.globalLoginStatus=[NSNumber numberWithFloat: 0];
    }
 
}

//GET URL DATA ENDS HERE


-(BOOL) verifyConfirmationCode
{
    
    ConfirmRegistration* vc = [[ConfirmRegistration alloc] initWithNibName:@"ConfirmRegistration" bundle:nil];
	[[self navigationController] pushViewController:vc animated:YES];
	[vc release];
    
    return TRUE;
    
}

// {NETWORK PROGRESS VIEW START FROM HERE

-(void)invokeMegaAnnoyingPopup
{
	self.megaAlert = [[[UIAlertView alloc] initWithTitle:@""
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

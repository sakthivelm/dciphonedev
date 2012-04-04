//
//  JoinNow.m
//  
//
//  Created by Sakthivel Muthusamy on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JoinNow.h"
#import "AppDelegate.h"

NSMutableData *receivedData;		// holds url downloads

NSArray *urlResponseStructures;     // spilited by #

NSArray *urlListofCmdRows;          // holds line by line data of received data
NSArray *urlListofDataRows;         // holds line by line data of received data

NSArray *urlListofCols;				// holds spilited data of one Row

NSMutableArray *tableListofRows;	//Holds list of options on table view

AppDelegate *mainDelegate ;

@implementation JoinNow
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    svos = scrollview_Joinnow.contentOffset;
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:scrollview_Joinnow];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 30;
    [scrollview_Joinnow setContentOffset:pt animated:YES];           
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    
	if (textField == textName)
	{
		[textName resignFirstResponder];
		[textUserName becomeFirstResponder];
	}
	if (textField == textUserName)
	{
		[textUserName resignFirstResponder];
		[textPassWord becomeFirstResponder];
	}
 	if (textField == textPassWord)
	{
		[textPassWord resignFirstResponder];
		[textRetypePassword becomeFirstResponder];
	}
 	if (textField == textRetypePassword)
	{
		[textRetypePassword resignFirstResponder];
		[textPhone becomeFirstResponder];
	}
  	if (textField == textPhone)
	{
		[textPhone resignFirstResponder];
		[textEmail becomeFirstResponder];
	}
  	if (textField == textEmail)
	{
		[textEmail resignFirstResponder];
		[textAptNo becomeFirstResponder];
	}
    
  	if (textField == textAptNo)
	{
		[textAptNo resignFirstResponder];
		[textStreetNo becomeFirstResponder];
	}
  	if (textField == textStreetNo)
	{
		[textStreetNo resignFirstResponder];
		[textStreet becomeFirstResponder];
	}
  	if (textField == textStreet)
	{
		[textStreet resignFirstResponder];
		[textCity becomeFirstResponder];
	}
  	if (textField == textCity)
	{
		[textCity resignFirstResponder];
		[textZIP becomeFirstResponder];
	}
    if (textField == textZIP)
	{
		[textZIP resignFirstResponder];
		[textState becomeFirstResponder];
	}
    if (textField == textState)
	{
		[textState resignFirstResponder];
		[textCountry becomeFirstResponder];
	}
    
    if (textField == textCountry)
	{
		[textState resignFirstResponder];
		[textBuzzer becomeFirstResponder];
	}
    
	if (textField == textBuzzer)
	{
		[textBuzzer resignFirstResponder];
        //[btnLogin becomeFirstResponder];
        [scrollview_Joinnow setContentOffset:CGPointMake(0, 152) animated:YES];
 	}

    return YES;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mainDelegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
    scrollview_Joinnow.contentSize = CGSizeMake(320, 700);  // default 520
  
    if(mainDelegate.globalJoinNowUpdateFlag==[NSNumber numberWithInt:1])
    {
        textName.text=mainDelegate.globalLoginName;
        textUserName.text=mainDelegate.globalLoginUserName;
        textPassWord.text=mainDelegate.globalLoginPassWord;
        textRetypePassword.text=mainDelegate.globalLoginRetypePassword;
        textPhone.text=mainDelegate.globalLoginPhone;
        textAptNo.text=mainDelegate.globalLoginAptNo;
        textStreetNo.text=mainDelegate.globalLoginStreetNo;
        textStreet.text=mainDelegate.globalLoginStreet;
        textCity.text=mainDelegate.globalLoginCity;
        textZIP.text=mainDelegate.globalLogintZIP;
        textState.text=mainDelegate.globalLoginState;
        textCountry.text=mainDelegate.globalLoginCountry;
        textEmail.text=mainDelegate.globalLoginEmail;
        textBuzzer.text=mainDelegate.globalLoginBuzzer;

    }
    else
    {
        textName.text=@"";
        textUserName.text=@"";
        textPassWord.text=@"";
        textRetypePassword.text=@"";
        textPhone.text=@"";
        textAptNo.text=@"";
        textStreetNo.text=@"";
        textStreet.text=@"";
        textCity.text=@"";
        textZIP.text=@"";
        textState.text=@"";
        textCountry.text=@"";
        textBuzzer.text=@"";
        textEmail.text=@"";
    }
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
-(IBAction) doJoinNow
{
/*

    if ([textName.text length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Name Empty" 
                                                        message:@"Retry"
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
    }
    if ([textUserName.text length]<=6)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"User ID Empty ! (minimum 6 characters)" 
                                                        message:@"Retry"
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
    }
    if ([textPassWord.text length]<=6)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Empty ! (minimum 6 characters)" 
                                                        message:@"Retry"
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
                
    }
    if ([textPhone.text length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Phone Empty !" 
                                                        message:@"Retry"
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
    }*/
    mainDelegate.globalUserName=textUserName.text;
    mainDelegate.globalPassword=textPassWord.text;
   
    [self initDownloadDataFromURL];           


}

-(IBAction) openURLTermsConditions
{
    NSString *urltobeLaunch;
    urltobeLaunch = [[NSString alloc] initWithFormat:@"http://www.diner-choice.com/ctlr?a=forward&m=tc"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urltobeLaunch]];
}

//GET URL CONNECTION

- (BOOL) initDownloadDataFromURL
{
    //{Invoke network progress monitor in status bar and another on in view
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self invokeMegaAnnoyingPopup];
    //}

	NSString *reqURL;    
    
    reqURL=[NSString stringWithFormat:@"%@?apiid=10020&name=%@&usr=%@&pwd=%@&phone=%@&aptno=%@&streetno=%@&street=%@&city=%@&zip=%@&state=%@&country=%@&update=%@&email=%@&buzz=%@",mainDelegate.globalMainUrl, textName.text, textUserName.text, textPassWord.text,textPhone.text,textAptNo.text,textStreetNo.text,textStreet.text,textCity.text, textZIP.text, textState.text,textCountry.text,mainDelegate.globalJoinNowUpdateFlag,textEmail.text,textBuzzer.text];
	
    NSString *reqUrlEncoded;
    reqUrlEncoded=[NSString stringWithFormat:@"%@",[reqURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:reqUrlEncoded]
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
    if(intApiReturnId==10020)
    {      
        switch (intApiReturnStatus) 
        {
            case 10:
            {
                dispMsgFlag=1;
                if(mainDelegate.globalJoinNowUpdateFlag==[NSNumber numberWithInt:0])
                    dispMsg=@"Your Registration Completed";
                else
                    dispMsg=@"Saved Successfully";
            }
                break;
            case 11:
            {
                dispMsgFlag=1;
                dispMsg=@"Not registered, Try again !";
            }
                break;
            case 12:
            {
                dispMsgFlag=1;
                dispMsg=@"User ID already available, Retry";
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
    if(intApiReturnStatus==10)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

}

//GET URL DATA ENDS HERE
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

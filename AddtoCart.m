

//
//  AddtoCart.m
//  
//
//  Created by Sakthivel Muthusamy on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddtoCart.h"
#import "AppDelegate.h"
#import "Login.h"

@implementation AddtoCart

NSMutableData *receivedData;		// holds url downloads

NSArray *urlResponseStructures;     // spilited by #

NSArray *urlListofCmdRows;          // holds line by line data of received data
NSArray *urlListofDataRows;         // holds line by line data of received data

NSArray *urlListofCols;				// holds spilited data of one Row

NSMutableArray *tableListofRows;	//Holds list of options on table view
@synthesize megaAlert;				// for network progress view 

AppDelegate *mainDelegate;



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
    //self.title=mainDelegate.globalAddCartItemName;
    
    if(mainDelegate.globalOrderListOption>=[NSNumber numberWithInt:2])
    {
        //btnRemove.hidden=YES;
    }
    else
        btnRemove.hidden=NO;
    
    if([mainDelegate.globalAddCartOption intValue]==0)
    {
        self.title=@"Add to cart";
        btnRemove.titleLabel.text=@"Back";
    }
    
    if([mainDelegate.globalAddCartOption intValue]==1)
    {
        self.title=@"Edit Item";
        btnRemove.titleLabel.text=@"Remove";
    }
       
    textQty.text=[NSString stringWithFormat:@"%@",mainDelegate.globalAddCartQty] ;
    textRate.text=[NSString stringWithFormat:@"%@ $",mainDelegate.globalAddCartRate];
    textInstructions.text=mainDelegate.globalAddCartInstructions;
    resAddress.text=mainDelegate.globalAddCartItemName;
    textInput.text=mainDelegate.globalAddCartInputtext;

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
    
	if (textField == textQty)
	{
		[textQty resignFirstResponder];
		[textInput becomeFirstResponder];
	}
	if (textField == textInput)
	{
		[textInput resignFirstResponder];
        
	}
    
    return YES;
}

- (IBAction) initDownloadDataFromURLforDelete
{
    if([mainDelegate.globalAddCartOption intValue]==0)
    {
        //Function to go back
         [[self navigationController] popViewControllerAnimated:YES];
    }
    if([mainDelegate.globalAddCartOption intValue]==1)
    {
        //Function to delete request
        mainDelegate.globalAddCartOption=[NSNumber numberWithInt: 2];
        [self initDownloadDataFromURL];
    }

}

-(IBAction) addQuantity
{
    NSString *strValue;
    int intValue;
    intValue=[textQty.text intValue]+1;
    strValue=[[NSString alloc] initWithFormat:@"%d",intValue];
    textQty.text=strValue;
}

-(IBAction) lessQuantity
{
    NSString *strValue;
    int intValue;
    intValue=[textQty.text intValue]-1;
    if(intValue<=0) intValue=1;
    strValue=[[NSString alloc] initWithFormat:@"%d",intValue];
    textQty.text=strValue;
    
}

//GET URL CONNECTION

- (IBAction) initDownloadDataFromURL
{
    //{Invoke network progress monitor in status bar and another on in view
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[self invokeMegaAnnoyingPopup];
	//}

	NSString *reqURL;
    NSString *reqUrlEncoded;
    
    mainDelegate.globalAddCartQty=[NSNumber numberWithInt:[textQty.text intValue]];
    mainDelegate.globalAddCartInstructions=textInstructions.text;
    mainDelegate.globalAddCartInputtext=textInput.text;
    
    if([mainDelegate.globalAddCartOption intValue]==0) //item add to cart
    {
        
        reqURL=[NSString stringWithFormat:@"%@?apiid=12010&usr=%@&restid=%@&menuid=%@&item=%@&qty=%@&instru=%@&variant=%@&size=%@",
            mainDelegate.globalMainUrl,
            mainDelegate.globalUserName,
            mainDelegate.globalRestaurantId,
            mainDelegate.globalMenuId,
            mainDelegate.globalAddCartItemId,
            mainDelegate.globalAddCartQty,
            mainDelegate.globalAddCartInputtext,
            mainDelegate.globalAddCartItemVariant,
            mainDelegate.globalAddCartPackSize
            ];
    }
    if([mainDelegate.globalAddCartOption intValue]==1) //item edit in cart
    {
        reqURL=[NSString stringWithFormat:@"%@?apiid=12020&usr=%@&citem=%@&qty=%@&instru=%@&variant=%@",
                mainDelegate.globalMainUrl,
                mainDelegate.globalUserName,
                mainDelegate.globalAddCartItemId,
                mainDelegate.globalAddCartQty,
                mainDelegate.globalAddCartInputtext,
                mainDelegate.globalAddCartItemVariant
                ];
    }
    if([mainDelegate.globalAddCartOption intValue]==2) // item delete in cart
    {
        reqURL=[NSString stringWithFormat:@"%@?apiid=12030&usr=%@&citem=%@",
                mainDelegate.globalMainUrl,
                mainDelegate.globalUserName,
                mainDelegate.globalAddCartItemId
                ];
    }

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
    
    /*
    // Inform the user that the connection failed.
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"URL"
                                                    message:reqURL
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    
    [alert1 show];
    [alert1 release];
     */
    
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
    //if([mainDelegate.globalAddCartOption intValue]==2) mainDelegate.globalAddCartOption=[NSNumber numberWithInt: 1];
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
    if((intApiReturnId==12010)||(intApiReturnId==12020)||(intApiReturnId==12030))
    {      
        switch (intApiReturnStatus) 
        {
            case 10:
            {
                dispMsgFlag=0;
                if([mainDelegate.globalAddCartOption intValue]==0) dispMsg=@"Item Added";
                if([mainDelegate.globalAddCartOption intValue]==1) dispMsg=@"Item Saved";
                if([mainDelegate.globalAddCartOption intValue]==2) dispMsg=@"Item Deleted";
                
                if ((intApiReturnId==12010)||(intApiReturnId==12030))
                {
                    [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:[urlListofCmdRows objectAtIndex:2]];
                }
            }
                break;
            case 11:
            {
                dispMsgFlag=1;
                if([mainDelegate.globalAddCartOption intValue]==0) dispMsg=@"Item Not Added";
                if([mainDelegate.globalAddCartOption intValue]==1) dispMsg=@"Item Not modified";
                if([mainDelegate.globalAddCartOption intValue]==2) dispMsg=@"Item Not Deleted";
            }
                break;
            case 12:
            {
                dispMsgFlag=0;
                dispMsg=@"Not logged in";
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
   if(intApiReturnStatus==12)
      {
          Login* vclogin = [[Login alloc] initWithNibName:@"Login" bundle:nil]; 
          [[self navigationController] pushViewController:vclogin animated:YES];
   
      }    
    [connection release];
    [receivedData release];
    if(intApiReturnStatus==10)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

}

//GET URL DATA END HERE
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

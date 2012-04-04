//
//  AreaCoverageSetup.m
//  
//
//  Created by Sakthivel Muthusamy on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AreaCoverageSetup.h"
//#import <CoreLocation/CoreLocation.h>
#import	"AppDelegate.h"
#import "Login.h"
#import "JoinNow.h"

@implementation AreaCoverageSetup


@synthesize accuracyOptions;
@synthesize configureForTracking;

@synthesize delegate;
@synthesize setupInfo;

@synthesize radiousSlider;
@synthesize radiousSliderOutput;
@synthesize resultSlider;
@synthesize resultSliderOutput;
@synthesize archiveSlider;
@synthesize archiveSliderOutput;

@synthesize radiousInMileSwitch;

//CLLocation* receivedCL;
AppDelegate *mainDelegate;


NSMutableData *receivedData;		// holds url downloads

NSArray *urlResponseStructures;     // spilited by #

NSArray *urlListofCmdRows;          // holds line by line data of received data
NSArray *urlListofDataRows;         // holds line by line data of received data
NSArray *urlListofCountryRows;       // holds line by line data of received data
NSArray *urlListofUserInfo;

NSArray *urlListofCols;				// holds spilited data of one Row

NSMutableArray *tableListofRows;	//Holds list of options on table view

@synthesize megaAlert;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    /*
    UIBarButtonItem *rButton=[[UIBarButtonItem alloc] init];
    rButton.title=@"Refresh";
    [rButton setTarget:self];
    [rButton setAction:@selector(applyChanges)];
    self.navigationItem.rightBarButtonItem=rButton;
    */
	
    /*
	//{Verify the latituded langtitude are set
	AppDelegate *mainDelegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
	receivedCL=mainDelegate.globalGPSLocation;
	//}
     */
    self.navigationController.navigationBar.tintColor=mainDelegate.globalNavigationBarColor;

    [self setRadiousSlider];

}


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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([mainDelegate.globalLoginStatus intValue] ==0)
    {
        //self.view.hidden=YES;
        Login* vclogin = [[Login alloc] initWithNibName:@"Login" bundle:nil]; 
        [[self navigationController] pushViewController:vclogin animated:YES];	
    }
    else
    {
        [self initDownload];
    }
	
}

-(IBAction) applyChanges
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: nil
													message:@"Changes applied"
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles: nil];
	
	[alert show];
	[alert release];
    }

-(IBAction) setMileSwitchChanged
{
	/*
	//{Verify the latituded langtitude are set
	AppDelegate *mainDelegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
	mainDelegate.globalMileSwitch=[NSNumber numberWithInt: radiousInMileSwitch.on];
	//}
    [self setRadiousSlider];
     */
}

-(IBAction) setRadiousSlider
{
    /*
    float sliderValue;
    sliderValue=radiousSlider.value;
    
	//{Verify the latituded langtitude are set
	AppDelegate *mainDelegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
    
    mainDelegate.globalGPSRadious=[NSNumber numberWithFloat: sliderValue];
    
    if(radiousInMileSwitch.on==1)
    {
		radiousSliderOutput.text=[NSString stringWithFormat:@"%3.0f Mile", sliderValue];
    }
    else
    {
		radiousSliderOutput.text=[NSString stringWithFormat:@"%3.0f KM", sliderValue];
    }   
	//}
     */
}


-(IBAction) setResultSlider
{
    /*
        float sliderValue;
        sliderValue=roundf(resultSlider.value*10)*10;

		resultSliderOutput.text=[NSString stringWithFormat:@"%3.0f", sliderValue];
     */
}

-(IBAction) editJoinNow
{
    mainDelegate.globalJoinNowUpdateFlag=[NSNumber numberWithInt:1];
    //{Push to next detail view
    JoinNow* resvc2 = [[JoinNow alloc] initWithNibName:@"JoinNow" bundle:nil]; 
    
    [[self navigationController] pushViewController:resvc2 animated:YES];	
    //}
}


-(BOOL) initDownload
{
    [self initDownloadDataFromURL:1];
    return true;
}

-(IBAction) initUpload
{
    [self initDownloadDataFromURL:2];
}


//{GET URL DATA STARTS HERE

- (BOOL) initDownloadDataFromURL:(int) url
{
    int mileswitch;
    //{Invoke network progress monitor in status bar and another on in view
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self invokeMegaAnnoyingPopup];
    //}
    
    tableListofRows = [[NSMutableArray alloc] init];  
	NSString *reqURL,*reqUrlEncoded;
    
    if(url==1) // get data
        reqURL=[NSString stringWithFormat:@"%@?apiid=20010&usr=%@",mainDelegate.globalMainUrl, mainDelegate.globalUserName];
    if(url==2) // upload data
    {
        if ([radiousInMileSwitch isOn]) mileswitch=1;
        else mileswitch=0;
        reqURL=[NSString stringWithFormat:@"%@?apiid=20020&usr=%@&mile=%d&radius=%3.0f&resultsize=%3.0f&archive=%3.0f&country=CA",mainDelegate.globalMainUrl, mainDelegate.globalUserName,mileswitch,radiousSlider.value,resultSlider.value,archiveSlider.value];
    }//
    reqUrlEncoded=[NSString stringWithFormat:@"%@",[reqURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
   /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:reqUrlEncoded 
                                                    message:@"Response"
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    
    [alert show];
    [alert release];
*/
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
    @try {
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
    NSString *dispInfo;
    
/*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strMsg 
                                                    message:@"Response"
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    
    [alert show];
    [alert release];
*/
    //******Data parsing starts here
    urlResponseStructures = [strMsg componentsSeparatedByString:@"#"];  
    // Row1: Responses commands |
    // Row2: Datas seperated by |
    
    if([urlResponseStructures count]>=3)
    {
            urlListofCmdRows=[[urlResponseStructures objectAtIndex:1] componentsSeparatedByString:@"|"];
            // Each row contains spilited data of command ids
            
    }
    else return;
 
    //******Dataprocessing starts here
    //Convert download status code to integer
    intApiReturnId=[[urlListofCmdRows objectAtIndex:0] intValue];
    intApiReturnStatus=[[urlListofCmdRows objectAtIndex:1] intValue];
    //LOGIN : Verification
    if(intApiReturnId==20010)
    {      
        switch (intApiReturnStatus) 
        {
            case 10:
            {
                dispMsgFlag=0;
                dispMsg=@"SUCCESS";
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
        
        if(intApiReturnStatus==10)
        {
            urlListofDataRows=[[urlResponseStructures objectAtIndex:2] componentsSeparatedByString:@"|"];
            // Each row contains spilited data of datasets

            /*
            radiousInMileSwitch.on=[[urlListofDataRows objectAtIndex:0] intValue];
            radiousSlider.value=[[urlListofDataRows objectAtIndex:1] intValue];
            resultSlider.value=[[urlListofDataRows objectAtIndex:2] intValue];
            archiveSlider.value=[[urlListofDataRows objectAtIndex:3] intValue];
            [self setMileSwitchChanged];
            [self setRadiousSlider];
            [self setResultSlider];
            */
            
            urlListofCountryRows=[[urlResponseStructures objectAtIndex:3] componentsSeparatedByString:@"|"];
            
            urlListofUserInfo=[[urlResponseStructures objectAtIndex:4] componentsSeparatedByString:@"|"];
            
            mainDelegate.globalLoginName=[urlListofUserInfo objectAtIndex:0];
            mainDelegate.globalLoginUserName=[urlListofUserInfo objectAtIndex:1];
            mainDelegate.globalLoginPassWord=[urlListofUserInfo objectAtIndex:2];
            mainDelegate.globalLoginRetypePassword=[urlListofUserInfo objectAtIndex:2];
            mainDelegate.globalLoginPhone=[urlListofUserInfo objectAtIndex:3];
            mainDelegate.globalLoginAptNo=[urlListofUserInfo objectAtIndex:4];
            mainDelegate.globalLoginStreetNo=[urlListofUserInfo objectAtIndex:5];
            mainDelegate.globalLoginStreet=[urlListofUserInfo objectAtIndex:6];
            mainDelegate.globalLoginCity=[urlListofUserInfo objectAtIndex:7];
            mainDelegate.globalLogintZIP=[urlListofUserInfo objectAtIndex:8];
            mainDelegate.globalLoginState=[urlListofUserInfo objectAtIndex:9];
            mainDelegate.globalLoginCountry=[urlListofUserInfo objectAtIndex:10];
            mainDelegate.globalLoginEmail=[urlListofUserInfo objectAtIndex:11];
            mainDelegate.globalLoginBuzzer=[urlListofUserInfo objectAtIndex:12];
            
            dispInfo= [NSString stringWithFormat:@"Phone: %@\nEmail: %@ \n\n%@ %@\n%@-%@\n\n%@"
                       ,mainDelegate.globalLoginPhone
                       ,mainDelegate.globalLoginEmail
                       ,mainDelegate.globalLoginStreetNo,mainDelegate.globalLoginStreet
                       ,mainDelegate.globalLoginCity
                       ,mainDelegate.globalLogintZIP
                       ,[urlListofUserInfo objectAtIndex:15]
                       ];
            accInfo.text=dispInfo;
            accountHead.text=mainDelegate.globalLoginName;
        }
        // Each row contains spilited data of datasets
    }// End of login if
    
    //Forgot Password
    if(intApiReturnId==20020)
    {
        switch (intApiReturnStatus) 
        {
            case 10:
            {
                dispMsgFlag=0;
                dispMsg=@"Applied successfully";
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
    
    }
    @catch (NSException *e) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid data...!" 
                                                        message:@"Try again"
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        
        [alert show];
        [alert release];
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

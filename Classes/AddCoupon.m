//
//  AddCoupon.m
////
//  Created by Sakthivel Muthusamy on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddCoupon.h"
#import "AppDelegate.h"
#import "Login.h"

@implementation AddCoupon


NSMutableData *receivedData;		// holds url downloads

NSArray *urlListofRows;             // holds line by line data of received data
NSArray *urlListofCmdRows;          // holds line by line data of received data

NSArray *urlListofColumns;			// holds spilited data of one restaurant


NSMutableArray *tableFinalList;     //Holds list of options on table view
AppDelegate *mainDelegate;


int actionSheetOption;
int couponTypeFlag=0;
int actionSelectionFlag=0;
int commonCellHeight=1;

@synthesize megaAlert;				


/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/
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
    actionSheetOption=0;
    
    //Initialize the array
	tableFinalList = [[NSMutableArray alloc] init];
    
    mainDelegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];

}

- (void)viewDidUnload
{
    [super viewDidUnload];

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    actionSheetOption=0;
    self.title=@"Coupons";
    if ([mainDelegate.globalLoginStatus intValue] ==1)
    {
        [[self navigationController] setNavigationBarHidden:NO animated:NO];
        [self getOrdersFromURL];
    }
    
    if ([mainDelegate.globalLoginStatus intValue] ==0)
    {
        Login* vclogin = [[Login alloc] initWithNibName:@"Login" bundle:nil]; 
        [[self navigationController] pushViewController:vclogin animated:YES];
        [[self navigationController] setNavigationBarHidden:YES animated:NO];
        [vclogin release];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//TABLE INITIAL SETUP BEGINS HERE

// tell our table how many rows it will have, in our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableFinalList count];
    
}
-(CGFloat)tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //minimum height
    int height=60;
    
    //add required height for details
    height+=commonCellHeight*20;
    
    //add bottom margin
    height+=5;
    
    return height;
}

// tell our table what kind of cell to use and its title for the given row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    NSString *cellValue=[tableFinalList objectAtIndex:indexPath.row];
    urlListofColumns=[cellValue componentsSeparatedByString:@"|"];

    unsigned int dtdFlag=0;
    NSString *strAppDining=@"";
    NSString *strAppTakeout=@"";
    NSString *strAppDelivery=@"";
    
    NSString *DescCell= [[NSString alloc] initWithFormat: @"%@ %@",[urlListofColumns	objectAtIndex:3],[urlListofColumns	objectAtIndex:4]];
    
    dtdFlag=[[urlListofColumns	objectAtIndex:8] intValue];

    if((dtdFlag&0x01)==0x01)
    {
        strAppDining=@"Dinein";
    }
    if((dtdFlag&0x02)==0x02)
    {
        strAppTakeout=@"Takeout";
    }
    if((dtdFlag&0x04)==0x04)
    {
        strAppDelivery=@"Delivery";
    }
    NSString *applicableText= [[NSString alloc] initWithFormat: @"%@ %@ %@",
                               strAppDining,strAppTakeout,strAppDelivery];
 
    UILabel *coupon=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, 310, 40)];
            coupon.text=DescCell; 
            coupon.textAlignment=UITextAlignmentLeft;
            coupon.lineBreakMode=UILineBreakModeWordWrap;
            coupon.numberOfLines=2;
            coupon.textColor=[UIColor blackColor];
            coupon.font=[UIFont boldSystemFontOfSize:14];

      //Expiry Intimation
    UILabel *expiry=[[UILabel alloc] initWithFrame:CGRectMake(15, 40, 150, 20)];
            expiry.text=[urlListofColumns	objectAtIndex:5];
            expiry.textAlignment=UITextAlignmentLeft;
            expiry.lineBreakMode=UILineBreakModeWordWrap;
            expiry.numberOfLines=1;
            expiry.textColor=[UIColor colorWithRed:0xb2/255.0 green:0x6f/255.0  blue:0xf1/255.0  alpha:1];;
            expiry.font=[UIFont systemFontOfSize:14];
    
    
    //takeout / delivery / dinein
    UILabel *applicable=[[UILabel alloc] initWithFrame:CGRectMake(160, 40, 150, 20)];
            applicable.text=applicableText;
            applicable.textAlignment=UITextAlignmentRight;
            applicable.lineBreakMode=UILineBreakModeWordWrap;
            applicable.numberOfLines=1;
            applicable.textColor=[UIColor colorWithRed:0x03/255.0 green:0x8d/255.0  blue:0x8d/255.0  alpha:1];;
            applicable.font=[UIFont systemFontOfSize:14];
   
    UILabel *details=[[UILabel alloc] initWithFrame:CGRectMake(30, 60, 280, (commonCellHeight*20))];
            details.text=[urlListofColumns	objectAtIndex:7];
            details.textAlignment=UITextAlignmentLeft;
            details.numberOfLines=commonCellHeight;
            details.textColor=[UIColor grayColor];
            details.font=[UIFont systemFontOfSize:14];
               
     [cell.contentView addSubview:coupon];
    
     [cell.contentView addSubview:expiry];
         [cell.contentView addSubview:applicable];
    
     [cell.contentView addSubview:details];
    
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
    couponTypeFlag=0;
    //Sample : http://osbo.com/xcode/uiactionsheeet
    NSString *selectedCoupon=[tableFinalList objectAtIndex:indexPath.row];    
    urlListofColumns=[selectedCoupon componentsSeparatedByString:@"|"];
    
    if([urlListofColumns count]>=2)
    {
        mainDelegate.globalCouponId=[urlListofColumns objectAtIndex:2];
        couponTypeFlag=[[urlListofColumns objectAtIndex:8] intValue];
        
        UIActionSheet *actionSheet;
        
        if((couponTypeFlag&0x01)==0x01)
        {
            actionSheet= [[UIActionSheet alloc] 
                                      initWithTitle:@"What to do ?" 
                                      delegate:self 
                                      cancelButtonTitle:@"Cancel" 
                                      destructiveButtonTitle:nil 
                                      otherButtonTitles:@"Add",@"Redeem",nil]; 
            actionSelectionFlag=1;
        }
        else
        {
            actionSheet= [[UIActionSheet alloc] 
                      initWithTitle:@"What to do ?" 
                      delegate:self 
                      cancelButtonTitle:@"Cancel" 
                      destructiveButtonTitle:nil 
                      otherButtonTitles:@"Add",nil]; 
            
            actionSelectionFlag=2;
        }

       //[actionSheet showInView:self.view];
        [actionSheet showInView:self.parentViewController.tabBarController.view];
        [actionSheet release];
    }
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet 
didDismissWithButtonIndex:(NSInteger)buttonIndex 
{ 
 
    actionSheetOption=0;  // List
    
    if(actionSelectionFlag==1) // dinein only
    {
    
        if (buttonIndex == 0) 
        { 
            actionSheetOption=1;  // Add
            [self getOrdersFromURL];
        }
        if (buttonIndex == 1) 
        { 
            actionSheetOption=2;  // Redeem
            [self getOrdersFromURL];
        }
    }
    else  // takeout & delivery
    {
        if (buttonIndex == 0) 
        { 
            actionSheetOption=1;  // Add
            [self getOrdersFromURL];
        }
    }
    
    [IBCouponsTable reloadData];
} 


//TABLE INITIALIZATION ENDS HERE

//{GET URL DATA STARTS HERE
- (BOOL) getOrdersFromURL
{
    //{Invoke network progress monitor in status bar and another on in view
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self invokeMegaAnnoyingPopup];
    //}

    
	NSString *reqURL;
    
    // Get my coupon list
    if(actionSheetOption==0)
    {
        tableFinalList = [[NSMutableArray alloc] init];
        reqURL=[NSString stringWithFormat:@"%@?apiid=16010&usr=%@&restid=%@",mainDelegate.globalMainUrl, mainDelegate.globalUserName,mainDelegate.globalRestaurantId]; 
    }
    
    // add to my coupon list
    if(actionSheetOption==1)
        reqURL=[NSString stringWithFormat:@"%@?apiid=16020&usr=%@&coupid=%@",mainDelegate.globalMainUrl, mainDelegate.globalUserName,mainDelegate.globalCouponId]; 
    
    // redeem post
    if(actionSheetOption==2)
        reqURL=[NSString stringWithFormat:@"%@?apiid=16040&usr=%@&coupid=%@&applicable=2",mainDelegate.globalMainUrl, mainDelegate.globalUserName,mainDelegate.globalCouponId]; 
	
    
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
	
 	NSString *strMsg = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	int strLen=0;
	int objPos=0;		// add object position increment
	NSString *strLine;  // hold one line of received data ie one restaurant's data
    int intApiReturnId=0;
    int intApiReturnStatus=0;
    
    int dispMsgFlag=0;
    NSString *dispMsg;
    
    //******Data parsing starts here
    urlListofRows = [strMsg componentsSeparatedByString:@"#"];  
    // Row1: Responses commands |
    // Row2: Datas seperated by |
    
    urlListofCmdRows=[[urlListofRows objectAtIndex:1] componentsSeparatedByString:@"|"];
    // Each row contains splited data of command ids
    
    //******Dataprocessing starts here
    //Convert download status code to integer
    if([urlListofCmdRows count]>=2)
    {
        intApiReturnId=[[urlListofCmdRows objectAtIndex:0] intValue];
        intApiReturnStatus=[[urlListofCmdRows objectAtIndex:1] intValue];
    }
    else
    {
        intApiReturnId=0;intApiReturnStatus=0;
        dispMsg=@"Failed";
        dispMsgFlag=1;
    }
	
    
    //LOGIN : Verification
    if((intApiReturnId==16010)||(intApiReturnId==16020)||(intApiReturnId==16040))
    {      
        switch (intApiReturnStatus) 
        {
            //Success
            case 10:
            {
                dispMsgFlag=0;
                if(intApiReturnId==16010) 
                {
                    commonCellHeight=[[urlListofCmdRows objectAtIndex:4] intValue];
                    dispMsg=@"Success";
                }
                if(intApiReturnId==16020) {dispMsg=@"Added Successfully";dispMsgFlag=1;}
                
                //redeem
                if(intApiReturnId==16040) 
                {
                    dispMsgFlag=1;
                    dispMsg= [urlListofCmdRows objectAtIndex:2];
                }
            }
                break;
            
            //Failed
            case 11:
            {
                dispMsgFlag=1;
                if(intApiReturnId==16010) {dispMsg=@"Failed";dispMsgFlag=0;}
                if(intApiReturnId==16020) dispMsg=@"Failed to Add, Try Again";
                
                //redeem
                if(intApiReturnId==16040) 
                {
                    dispMsg= [urlListofCmdRows objectAtIndex:2];
                }
            }
                break;
            
            //Nopt Logged in
            case 12:
            {
                dispMsgFlag=0;
                dispMsg=@"Not Logged In";
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
    
    if(intApiReturnId==16010)
    {
        
        
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
        
        
        
        
        if(objPos==0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No data found!" 
                                                            message:nil
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles: nil];
            
            [alert show];
            [alert release];
        }
        // release the connection, and the data object
        
        [IBCouponsTable reloadData];
	}
    [connection release];
    [receivedData release];
    
    actionSheetOption=0;
     
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

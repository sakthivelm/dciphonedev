//
//  ViewOrders.m
//  
//
//  Created by Sakthivel Muthusamy on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewOrders.h"
#import "ViewOrdersDetails.h"
#import "GetAddress.h"
#import "AppDelegate.h"
#import "Login.h"

@implementation ViewOrders

NSMutableData *receivedData;		// holds url downloads

NSArray *urlListofOrders;			// holds line by line data of received data

NSArray *orderDetails;				// holds spilited data of one restaurant


NSMutableArray *tableListOfOrders;	//Holds list of options on table view

int OrderListType;
int previousLoginState;
int presentLoginState;

AppDelegate *mainDelegate;

@synthesize megaAlert;				// for network progress view 
@synthesize segmentedControl;



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
    //Initialize the array
	tableListOfOrders = [[NSMutableArray alloc] init];
    mainDelegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
    
    historyDate=[[UIDatePicker alloc] init];
    historyDate.date=[NSDate date];
    self.title=@"Cart";

    OrderListType=1;
    mainDelegate.globalActiveOrderPage=[NSNumber numberWithInt: 0];
    previousLoginState=[mainDelegate.globalLoginStatus intValue];
    
    
    self.navigationController.navigationBar.tintColor=mainDelegate.globalNavigationBarColor;
    ordersToolBar.tintColor=mainDelegate.globalNavigationBarColor;
    selectedColor=[UIColor colorWithRed:251/255.0 green:127/255.0 blue:5/255.0 alpha:1];
    segmentedControl.segmentedControlStyle=UISegmentedControlStyleBar;
    

    
}

-(void) viewWillAppear:(BOOL)animated{
    
    presentLoginState=[mainDelegate.globalLoginStatus intValue];
    if ((previousLoginState==0)&&(presentLoginState==1))
    {
        self.segmentedControl.selectedSegmentIndex=1;
        [self segmentedControlIndexChanged];
        previousLoginState=1;
    }
    
    if ([mainDelegate.globalLoginStatus intValue] ==1)  
        [self segmentedControlIndexChanged];
    
    if ([mainDelegate.globalLoginStatus intValue] ==0)
    {
        Login* vclogin = [[Login alloc] initWithNibName:@"Login" bundle:nil]; 
        [[self navigationController] pushViewController:vclogin animated:YES];
        return;
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

- (void)actionSheet:(UIActionSheet *)actionSheet 
didDismissWithButtonIndex:(NSInteger)buttonIndex 
{ 
    mainDelegate.globalActiveOrderPage=[NSNumber numberWithInt: 2];
    [self viewHistory];
} 

- (void) changeSelectedIndexColor:(int)selindex
{
    /*
    if(selindex==0)
        [[[segmentedControl subviews] objectAtIndex:0] setTintColor:selectedColor];
    else
        [[[segmentedControl subviews] objectAtIndex:0] setTintColor:mainDelegate.globalNavigationBarColor];    
    if(selindex==1)
        [[[segmentedControl subviews] objectAtIndex:1] setTintColor:selectedColor];
    else
        [[[segmentedControl subviews] objectAtIndex:1] setTintColor:mainDelegate.globalNavigationBarColor];    
    if(selindex==1)
        [[[segmentedControl subviews] objectAtIndex:2] setTintColor:selectedColor];
    else
        [[[segmentedControl subviews] objectAtIndex:2] setTintColor:mainDelegate.globalNavigationBarColor];    

    for( int i=1; i<=2; i++) //[[segmentedControl subviews] count]
    {
        [[[segmentedControl subviews] objectAtIndex:i] setTintColor:nil];
       if(selindex==i)
            [[[segmentedControl subviews] objectAtIndex:i] setTintColor:selectedColor];
        else
            [[[segmentedControl subviews] objectAtIndex:i] setTintColor:mainDelegate.globalNavigationBarColor];
    }
  */       
}

- (IBAction) segmentedControlIndexChanged
{
    NSInteger selidx=self.segmentedControl.selectedSegmentIndex;
    /*
    //[self changeSelectedIndexColor:selidx];
    [[[segmentedControl subviews] objectAtIndex:0] setTintColor:[UIColor grayColor]];
    [[[segmentedControl subviews] objectAtIndex:1] setTintColor:[UIColor grayColor]];
    [[[segmentedControl subviews] objectAtIndex:2] setTintColor:[UIColor grayColor]];
    [[[segmentedControl subviews] objectAtIndex:selidx] setTintColor:[UIColor orangeColor]];
    */
    //sleep(50);
    //NSDate *future = [NSDate dateWithTimeIntervalSinceNow: 5 ];
    //[NSThread sleepUntilDate:future];
    
    //IBOrdersTable.scrollsToTop=YES;
    
    switch (selidx) {
        case 0:
            mainDelegate.globalActiveOrderPage=[NSNumber numberWithInt: 0];
            self.title=@"Cart";
            [self viewCart];
            break;
        case 1:
            mainDelegate.globalActiveOrderPage=[NSNumber numberWithInt: 1];
            self.title=@"In Processing";
            [self viewOrders];
            break;
        case 2:
            mainDelegate.globalActiveOrderPage=[NSNumber numberWithInt: 2];
            self.title=@"Completed";
            [self viewHistory];
            break;
        default:
            break;
    }
}


- (IBAction) viewCart
{
    OrderListType=1;
    self.navigationItem.rightBarButtonItem=nil;
    [self getOrdersFromURL];
	
}

- (IBAction) viewOrders
{
    OrderListType=2;
    self.navigationItem.rightBarButtonItem=nil;
    [self getOrdersFromURL];
}
- (IBAction) viewHistory
{
    UIBarButtonItem *rightDateButton=[[UIBarButtonItem alloc] initWithTitle:@"Date" style:UIBarButtonSystemItemRewind target:self action:@selector(showCalendar)];
    
    OrderListType=3;
    self.navigationItem.rightBarButtonItem=rightDateButton;
    [self getOrdersFromURL];
}

-(IBAction) showCalendar
{
    NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                  initWithTitle:[NSString stringWithFormat:@"%@%@",title, NSLocalizedString(@"Set Date", @"")]
                                  delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    historyDate.datePickerMode= UIDatePickerModeDate;
    historyDate.minimumDate=[NSDate date];
    [actionSheet addSubview:historyDate];
    
    //[actionSheet showInView:self.view];
    [actionSheet showInView:self.parentViewController.tabBarController.view];
    
}

//TABLE INITIAL SETUP BEGINS HERE

// tell our table how many rows it will have, in our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableListOfOrders count];
    
}

// tell our table what kind of cell to use and its title for the given row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		//cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
	}
    else {
        NSArray *cellSubs = cell.contentView.subviews;
        for (int i = 0 ; i < [cellSubs count] ; i++) {
            [[cellSubs objectAtIndex:i] removeFromSuperview];
        }
    }	
    
    NSString *DescCell;
    NSString *HeadCell;
    NSString *StatusCell;
    NSString *RateCell;
    NSString *cellValue=[tableListOfOrders objectAtIndex:indexPath.row];    
    orderDetails=[cellValue componentsSeparatedByString:@"|"];
  
    UILabel *ordRate=[[UILabel alloc] initWithFrame:CGRectMake(265, 0, 50, 20)];
    RateCell=[[NSString alloc] initWithFormat:@"$ %@",[orderDetails	objectAtIndex:2]];        ordRate.textAlignment=UITextAlignmentRight;
        ordRate.lineBreakMode=UILineBreakModeWordWrap;
        ordRate.numberOfLines=1;
        ordRate.textColor=[UIColor redColor];
        ordRate.font=[UIFont systemFontOfSize:14];
    
    UILabel *ordStatus=[[UILabel alloc] initWithFrame:CGRectMake(185, 22, 130, 20)];
    StatusCell=[[NSString alloc] initWithFormat:@"%@-%@",[orderDetails	objectAtIndex:5],[orderDetails	objectAtIndex:6]];
        ordStatus.textAlignment=UITextAlignmentRight;
        ordStatus.lineBreakMode=UILineBreakModeWordWrap;
        ordStatus.numberOfLines=1;
        ordStatus.textColor=[UIColor blueColor];
        ordStatus.font=[UIFont systemFontOfSize:14];
    

    if(OrderListType==1)
    {
        cell.textLabel.text = [orderDetails	objectAtIndex:1];
        DescCell= [[NSString alloc] initWithFormat: @"%@",[orderDetails	objectAtIndex:0]];
        if([DescCell isEqualToString:@"Cart Empty"])
            cell.detailTextLabel.text =DescCell;
        else
            cell.detailTextLabel.text =@"";
            
        cell.detailTextLabel.textColor=[UIColor blueColor];
        ordRate.text=@"";
        ordStatus.text=@""; 
    }
    else
    {
        HeadCell=[[NSString alloc] initWithFormat:@"%@   %@",[orderDetails objectAtIndex:0],[orderDetails objectAtIndex:3],[orderDetails objectAtIndex:6]];
        cell.textLabel.text = HeadCell;
        
        DescCell= [[NSString alloc] initWithFormat: @"%@",[orderDetails	objectAtIndex:1]];
        cell.detailTextLabel.text = DescCell;
        cell.detailTextLabel.textColor=[UIColor blueColor];

        ordRate.text=RateCell; 
        ordStatus.text=StatusCell; 
        [cell.contentView addSubview:ordRate];
        [cell.contentView addSubview:ordStatus];
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
    
    NSString *selectedRes=[tableListOfOrders objectAtIndex:indexPath.row];
	
	orderDetails=[selectedRes componentsSeparatedByString:@"|"];

    
	//{Pass selected restaurant id to next class
    if ([orderDetails count]>=3)
    {
        mainDelegate.globalAddCartItemId=[orderDetails objectAtIndex:0];
        if(OrderListType==1)
        {
            mainDelegate.globalAddCartDate=@"-";
            mainDelegate.globalAddCartTime=@"-";
            mainDelegate.globaldeliveryleadtime=[orderDetails objectAtIndex:2];
        }
        else
        {
            mainDelegate.globaldeliveryleadtime=0;
            mainDelegate.globalAddCartDate=[orderDetails objectAtIndex:3];
            mainDelegate.globalAddCartTime=[orderDetails objectAtIndex:4];
        }
    }
    //}

    if((OrderListType==2)||(OrderListType==3))
    {            
        //{Push to next detail view
		ViewOrdersDetails* vc1 = [[ViewOrdersDetails alloc] initWithNibName:@"ViewOrdersDetails" bundle:nil]; 
		[[self navigationController] pushViewController:vc1 animated:YES];	
		//}
    }
    
    if(OrderListType==1)
    {

        if([mainDelegate.globalAddCartItemId isEqualToString:@"1"])
        {
            mainDelegate.globaldeliveryoption=[NSNumber numberWithInt: 1];
            /*
            //{Push to next detail view
            ViewOrdersDetails* vc1 = [[ViewOrdersDetails alloc] initWithNibName:@"ViewOrdersDetails" bundle:nil]; 
            [[self navigationController] pushViewController:vc1 animated:YES];	
            //}*/
            //{Push to next detail view
            GetAddress* vc1 = [[GetAddress alloc] initWithNibName:@"GetAddress" bundle:nil]; 
            [[self navigationController] pushViewController:vc1 animated:YES];	
            //}            

        }
        if([mainDelegate.globalAddCartItemId isEqualToString:@"2"])
        {
            mainDelegate.globaldeliveryoption=[NSNumber numberWithInt: 2];
            mainDelegate.globaldeliveryaptno=@"";
            mainDelegate.globaldeliverystreetno=@"";
            mainDelegate.globaldeliverystreet=@"";
            mainDelegate.globaldeliverystate=@"";
            mainDelegate.globaldeliverycity=@"";
            mainDelegate.globaldeliveryzip=@"";
            mainDelegate.globaldeliveryperson=@"";
            mainDelegate.globaldeliveryphone=@"";

            //{Push to next detail view
            GetAddress* vc1 = [[GetAddress alloc] initWithNibName:@"GetAddress" bundle:nil]; 
            [[self navigationController] pushViewController:vc1 animated:YES];	
            //}            
        }        
        if([mainDelegate.globalAddCartItemId isEqualToString:@"3"])
        {
            mainDelegate.globaldeliveryoption=[NSNumber numberWithInt: 3];
            //{Push to next detail view
            GetAddress* vc1 = [[GetAddress alloc] initWithNibName:@"GetAddress" bundle:nil]; 
            [[self navigationController] pushViewController:vc1 animated:YES];	
            //}            
        }
    }
 }

//TABLE INITIALIZATION ENDS HERE

//{GET URL DATA STARTS HERE


- (BOOL) getOrdersFromURL
{
    //{Invoke network progress monitor in status bar and another on in view
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self invokeMegaAnnoyingPopup];
    //}
    mainDelegate.globalOrderListOption=[NSNumber numberWithInt:OrderListType];
     
	NSString *reqURL;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"YYYYMMdd"];
    NSString *strDate=[dateformater stringFromDate:historyDate.date];
  
    if(OrderListType==1)
        reqURL=[NSString stringWithFormat:@"%@?apiid=15010&usr=%@",mainDelegate.globalMainUrl, mainDelegate.globalUserName];
    if(OrderListType==2)
        reqURL=[NSString stringWithFormat:@"%@?apiid=15020&usr=%@",mainDelegate.globalMainUrl, mainDelegate.globalUserName];
    if(OrderListType==3)
        reqURL=[NSString stringWithFormat:@"%@?apiid=15030&usr=%@&date=%@",mainDelegate.globalMainUrl, mainDelegate.globalUserName,strDate];
	
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
    //{Dismiss network monitor in status bar and in view 
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self dismissMegaAnnoyingPopup];
	//}


}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //{Dismiss network monitor in status bar and in view 
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self dismissMegaAnnoyingPopup];
	//}
    tableListOfOrders = [[NSMutableArray alloc] init];  

 	NSString *strMsg = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	int strLen=0;
	int objPos=0;		// add object position increment
	NSString *strLine;  // hold one line of received data ie one restaurant's data
	
	urlListofOrders=[strMsg componentsSeparatedByString:@"#"];

    NSArray *cmdRows;
    NSString *dispMsg;
    int dispMsgFlag=0;
    int intApiReturnId;
    int intApiReturnStatus;
    
    cmdRows=[[urlListofOrders objectAtIndex:1] componentsSeparatedByString:@"|"];
    //Convert download status code to integer
    intApiReturnId=[[cmdRows objectAtIndex:0] intValue];
    if((intApiReturnId==15010)||(intApiReturnId==15020)||(intApiReturnId==15030))
    {
        intApiReturnStatus=[[cmdRows objectAtIndex:1] intValue];
        
        if((intApiReturnStatus==10)&&([cmdRows count]>=8)&&(intApiReturnId==15010))
            {
                mainDelegate.globaldeliveryaptno=[cmdRows objectAtIndex:2];
                mainDelegate.globaldeliverystreetno=[cmdRows objectAtIndex:3];
                mainDelegate.globaldeliverystreet=[cmdRows objectAtIndex:4];
                
                mainDelegate.globaldeliverycity=[cmdRows objectAtIndex:5];
                mainDelegate.globaldeliveryzip=[cmdRows objectAtIndex:6];
                
                mainDelegate.globaldeliverystate=[cmdRows objectAtIndex:7];
                
                mainDelegate.globaldeliveryperson=[cmdRows objectAtIndex:8];
                mainDelegate.globaldeliveryphone=[cmdRows objectAtIndex:9];
            }

    }
    else
    {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid response ! "
                                                    message:@"Try Again"
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    
    [alert show];
    [alert release];
    }
    
    //Data : Verification
    if((intApiReturnId==15010)||(intApiReturnId==15020)||(intApiReturnId==15030))
    {      
        switch (intApiReturnStatus) 
        {
            case 10:
            {
                dispMsgFlag=0;
                dispMsg=@"Success";
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
    
	//{Dismiss network monitor in status bar and in view 
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self dismissMegaAnnoyingPopup];
	//}

    
    
if(intApiReturnStatus==10)
{
    for(int i=2; i<[urlListofOrders count];i++)
 	{
		//Validate the datas received
		strLine=[urlListofOrders objectAtIndex:i];
		strLen=[strLine length];
		
		
		//Add the validated object into memory
		if(strLen>4)
		{
			[tableListOfOrders addObject:strLine];
			objPos=objPos+1;
            
		}		
	}
    
	if(objPos==0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No orders found!" 
														message:nil
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles: nil];
		
		[alert show];
		[alert release];
	}
    // release the connection, and the data object
    
    //Store received address to global variable
    
    
}// data available if statment
	
	[IBOrdersTable reloadData];
	
    [connection release];
    [receivedData release];
    [self dismissMegaAnnoyingPopup];
    
    if(intApiReturnStatus==12)
    {
        Login* vclogin = [[Login alloc] initWithNibName:@"Login" bundle:nil]; 
        [[self navigationController] pushViewController:vclogin animated:YES];
    }
     
    [IBOrdersTable setScrollEnabled:YES];
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

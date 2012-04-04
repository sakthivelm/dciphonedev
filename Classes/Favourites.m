//
//  Favourites.m
//  
//
//  Created by Sakthivel Muthusamy on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Favourites.h"
#import "AppDelegate.h"
#import "Login.h"
#import "RestaurantList.h"

@implementation Favourites

NSMutableData *receivedData;		// holds url downloads

NSArray *urlListofRows;             // holds line by line data of received data
NSArray *urlListofCmdRows;          // holds line by line data of received data
NSArray *urlListofDataRows;
NSArray *urlListofColumns;			// holds spilited data of one restaurant


NSMutableArray *tableFinalList;     //Holds list of options on table view


AppDelegate *mainDelegate;

@synthesize megaAlert;				// for network progress view 


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
	tableFinalList = [[NSMutableArray alloc] init];
    mainDelegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];   
    self.navigationItem.title=@"Search History";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([mainDelegate.globalLoginStatus intValue] ==1)
    {
        [self getOrdersFromURL];
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
    cell.textLabel.text = cellValue;
    
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
    NSString *selectedCoupon=[tableFinalList objectAtIndex:indexPath.row];    
    urlListofColumns=[selectedCoupon componentsSeparatedByString:@"|"];
 
    
    //{store into global variables
    mainDelegate.globalTextWhere= [NSString stringWithFormat:@"%@",[[urlListofColumns objectAtIndex:0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    mainDelegate.globalTextFood=@"";
    
    RestaurantList* vc = [[RestaurantList alloc] initWithNibName:@"RestaurantList" bundle:nil];
    [[self navigationController] pushViewController:vc animated:YES];
    [vc release];

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
    tableFinalList = [[NSMutableArray alloc] init];
    reqURL=[NSString stringWithFormat:@"%@?apiid=11090&usr=%@",mainDelegate.globalMainUrl, mainDelegate.globalUserName]; // Get my coupon list

 /*   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:reqURL 
                                                    message:@"Url"
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    
    [alert show];
    [alert release];
	*/
    
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
 /*   
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strMsg 
                                                    message:@"Data"
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    
    [alert show];
    [alert release];
*/
    //******Data parsing starts here
    urlListofRows = [strMsg componentsSeparatedByString:@"#"];  
    // Row1: Responses commands |
    // Row2: Datas seperated by |
    
    urlListofCmdRows=[[urlListofRows objectAtIndex:1] componentsSeparatedByString:@"|"];
    
    // Each row contains spilited data of command ids
    urlListofDataRows=[[urlListofRows objectAtIndex:2] componentsSeparatedByString:@"|"];
    
    //******Dataprocessing starts here
    //Convert download status code to integer
    if([urlListofCmdRows count]==2)
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
    if((intApiReturnId==11090))
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
    
    if(intApiReturnId==11090)
    {
        for(int i=0; i<[urlListofDataRows count];i++)
        {
            //Validate the datas received
            strLine=[urlListofDataRows objectAtIndex:i];
            strLen=[strLine length];
            
            
            //Add the validated object into memory
            if(strLen>0)
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
        
        [IBFavouritesTable reloadData];
	}
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

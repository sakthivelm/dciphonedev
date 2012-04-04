//
//  RestaurantMenu.m
//  
//
//  Created by Sakthivel Muthusamy on 2/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RestaurantMenu.h"
#import "AppDelegate.h"
#import "AddtoCart.h"
#import "ViewOrders.h"

@implementation RestaurantMenu

NSMutableData *receivedData;		// holds url downloads

NSArray *urlListofMenus;			// holds line by line data of received data

NSArray *menuDetails;				// holds spilited data of one restaurant


NSMutableArray *tableListOfMenus;	//Holds list of options on table view


@synthesize megaAlert;				// for network progress view 

AppDelegate *mainDelegate;


int enableshowprice=0;
int enableaddtocart=0;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.title=@"Menus";
	//Initialize the array
	tableListOfMenus = [[NSMutableArray alloc] init];
    
    //{Display restaurant name from global variable
	mainDelegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
    restaurantName.text=mainDelegate.globalRestaurantName;
	//}
    
    mainDelegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
	
    UIBarButtonItem *rightDateButton=[[UIBarButtonItem alloc] initWithTitle:@"Cart" style:UIBarButtonSystemItemRewind target:self action:@selector(launchCart)];
    self.navigationItem.rightBarButtonItem=rightDateButton;

    
	[self getMenusFromURL];
}


-(void) launchCart
{
    //[self.tabBarController setSelectedIndex:1];
    //{Push to next detail view
    ViewOrders* vc1 = [[ViewOrders alloc] initWithNibName:@"ViewOrders" bundle:nil]; 
    [[self navigationController] pushViewController:vc1 animated:YES];	
    //}

}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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


//TABLE INITIAL SETUP BEGINS HERE

// tell our table how many rows it will have, in our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableListOfMenus count];
    
}
-(CGFloat)tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    if([[menuDetails	objectAtIndex:7] intValue]==1)
        return  15;
    else*/
        return 80;
}

// tell our table what kind of cell to use and its title for the given row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // UIImage	*imageWeb = [UIImage imageNamed:@"imgView_Rate.png"];

    int section;
    int rgbValue;
    
    NSString *cellValue=[tableListOfMenus objectAtIndex:indexPath.row];			
    menuDetails=[cellValue componentsSeparatedByString:@"|"];
    
    section=[[menuDetails	objectAtIndex:7] intValue];
    rgbValue=[[menuDetails	objectAtIndex:8] intValue];
    
    static NSString *CellIdentifier =@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        
            cell.accessoryType=UITableViewCellAccessoryNone;
        
    }
    else {
        NSArray *cellSubs = cell.contentView.subviews;
        for (int i = 0 ; i < [cellSubs count] ; i++) {
            [[cellSubs objectAtIndex:i] removeFromSuperview];
        }
    }	

    
    
    UIColor *sectioncolor=[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
   
    NSString *strRate=[[NSString alloc] initWithFormat:@"$ %8@ ",[menuDetails	objectAtIndex:5]];  
    
    
    //menu / section category name
    UILabel *menuName=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
        menuName.text=[menuDetails	objectAtIndex:2];    
        menuName.text=[NSString stringWithFormat:@"%@", [menuDetails	objectAtIndex:2]];
        if(section==1)
        {
            menuName.textAlignment=UITextAlignmentCenter;
            menuName.textColor=[UIColor whiteColor];
        }
        else
        {
            menuName.textAlignment=UITextAlignmentLeft;
            menuName.textColor=[UIColor blackColor];
        }
        
        menuName.lineBreakMode=UILineBreakModeWordWrap;
        menuName.numberOfLines=2;
        menuName.font=[UIFont boldSystemFontOfSize:18];
        if(section==1)
            menuName.backgroundColor=sectioncolor;
        else
            menuName.backgroundColor=[UIColor clearColor];
    
    //Rate Label
    UILabel *rateLabel=[[UILabel alloc] initWithFrame:CGRectMake(250, 0, 70, 40)];
        rateLabel.textAlignment=UITextAlignmentRight;
        rateLabel.textColor=[UIColor redColor];
        rateLabel.numberOfLines=1;
        rateLabel.font=[UIFont boldSystemFontOfSize:18];
        if(section==1)
        {
            rateLabel.text=@"";
            rateLabel.backgroundColor=sectioncolor;
        }
        else
        {
            rateLabel.text=strRate;
            rateLabel.backgroundColor=[UIColor clearColor];
        }
    
    //Details
    UILabel *menuDetail=[[UILabel alloc] initWithFrame:CGRectMake(5, 40, 310, 40)];
        menuDetail.text=[menuDetails	objectAtIndex:3];   
        if(section==1)
        {
            menuDetail.textAlignment=UITextAlignmentCenter;
            menuDetail.textColor=sectioncolor;
        }
        else
        {
            menuDetail.textAlignment=UITextAlignmentLeft;
            menuDetail.textColor=[UIColor grayColor];
        }
        menuDetail.lineBreakMode=UILineBreakModeWordWrap;
        menuDetail.numberOfLines=2;
        menuDetail.font=[UIFont systemFontOfSize:14];
    if(section==0)
    {
            switch ([[menuDetails	objectAtIndex:9] intValue])
            {
                case 0:     // normal category and item
                    menuName.text=[NSString stringWithFormat:@"%@", [menuDetails	objectAtIndex:2]];
                    menuName.textAlignment=UITextAlignmentLeft;
                    break;
                case 1:
                    menuName.text=[NSString stringWithFormat:@"%@ Small", [menuDetails	objectAtIndex:2]];
                    menuName.textAlignment=UITextAlignmentLeft;
                    break;
                case 2:
                    menuName.text=[NSString stringWithFormat:@"Medium"];
                    menuName.textAlignment=UITextAlignmentRight;
                    break;
                case 3:
                    menuName.text=[NSString stringWithFormat:@"Large"];
                    menuName.textAlignment=UITextAlignmentRight;
                    break;
            }

    }
   
    [cell.contentView addSubview:rateLabel];
    [cell.contentView addSubview:menuName];
    [cell.contentView addSubview:menuDetail];
  
    
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
    if(enableaddtocart!=1) return;
    
    NSString *selectedRes=[tableListOfMenus objectAtIndex:indexPath.row];
    menuDetails=[selectedRes componentsSeparatedByString:@"|"];
       
    if([[menuDetails	objectAtIndex:7] intValue]==1) return;

    
    if([menuDetails count]>=5)
    {
            mainDelegate.globalAddCartItemId =[menuDetails objectAtIndex:0];
            mainDelegate.globalAddCartItemName=[menuDetails objectAtIndex:2];    
            mainDelegate.globalAddCartInstructions=[menuDetails objectAtIndex:3];
            mainDelegate.globalAddCartItemVariant=[menuDetails objectAtIndex:4];
            mainDelegate.globalAddCartRate=[menuDetails objectAtIndex:5];
            mainDelegate.globalMenuId=[menuDetails objectAtIndex:0];
            mainDelegate.globalAddCartPackSize=[menuDetails objectAtIndex:9];
            
            
            //Assign default quantity to one
            mainDelegate.globalAddCartQty=[NSNumber numberWithInt:1];
            
            mainDelegate.globalAddCartOption=[NSNumber numberWithInt: 0];
            mainDelegate.globalOrderListOption=[NSNumber numberWithInt:0];

            //{Push to next detail view
            AddtoCart* vc1 = [[AddtoCart alloc] initWithNibName:@"AddtoCart" bundle:nil]; 
            [[self navigationController] pushViewController:vc1 animated:YES];	
            //}
    }
}
//TABLE INITIALIZATION ENDS HERE

//{GET URL DATA STARTS HERE


- (BOOL) getMenusFromURL
{
	
	//{Invoke network progress monitor in status bar and another on in view
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[self invokeMegaAnnoyingPopup];
	//}

	NSString *reqURL;
    
    reqURL=[NSString stringWithFormat:@"%@?apiid=11510&usr=%@&restid=%@&menuid=%@",mainDelegate.globalMainUrl, mainDelegate.globalUserName,mainDelegate.globalRestaurantId,mainDelegate.globalMenuId];
	
	
    //{Tracer
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:reqURL 
                                                    message:@"URL"
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    
    [alert show];
    [alert release];
     */
    //} End of tracer

    
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
	
	urlListofMenus=[strMsg componentsSeparatedByString:@"#"];
    if ([urlListofMenus count]<2) 
    {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strMsg
         message:@"Data Error !"
         delegate:nil 
         cancelButtonTitle:@"OK" 
         otherButtonTitles: nil];
         
         [alert show];
         [alert release];
        return;
      }
     /* Tracer
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Received Data!" 
                                                 message:strMsg
                                                 delegate:nil 
                                                 cancelButtonTitle:@"OK" 
                                                 otherButtonTitles: nil];
     
     [alert show];
     [alert release];
     */

    NSArray *cmdRows;
    NSString *dispMsg;
    NSString *strRow;
    int dispMsgFlag=0;
    int intApiReturnId;
    int intApiReturnStatus;
    
    strRow=[urlListofMenus objectAtIndex:1];
    cmdRows=[strRow componentsSeparatedByString:@"|"];
    //Convert download status code to integer
    intApiReturnId=[[cmdRows objectAtIndex:0] intValue];
    if((intApiReturnId==11510))
    {
        intApiReturnStatus=[[cmdRows objectAtIndex:1] intValue];
        
        if(intApiReturnStatus==10)
        {
            enableaddtocart=[[cmdRows objectAtIndex:3] intValue];
            enableshowprice=[[cmdRows objectAtIndex:4] intValue];
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
    if(intApiReturnId==11510)
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

    if(intApiReturnStatus==10)
    {
            for(int i=2; i<[urlListofMenus count];i++)
            {
                //Validate the datas received
                strLine=[urlListofMenus objectAtIndex:i];
                strLen=[strLine length];
                
                
                //Add the validated object into memory
                if(strLen>4)
                {
                    [tableListOfMenus addObject:strLine];
                    objPos=objPos+1;
                }		
            }
        [myRestaurantMenu reloadData];
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

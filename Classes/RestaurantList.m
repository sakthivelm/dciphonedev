//
//  RestaurantList.m
//  
//
//  Created by Sakthivel Muthusamy on 1/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//URL ref: www.devx.com/wireless/Article/43134/1954
//http://www.vellios.com/2010/08/16/core-location-gps-tutorial/  gps data reading tutorials

#import "RestaurantList.h"
#import "RestaurantDetail.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>


@implementation RestaurantList

NSMutableData *receivedData;		// holds url downloads

NSArray *urlListofRestaurants;		// holds line by line data of received data

NSArray *RestaurantDetails;			// holds spilited data of one restaurant


NSMutableArray *tableListofRestaurants;  // holds tableview data

CLLocation* receivedCL;

UIImage *imgStar;

//{store into global variables
AppDelegate *mainDelegate; 
//}	


@synthesize megaAlert;				// for network progress view 
@synthesize strListEnd;

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
	
    self.title=@"Restaurants";
    if([mainDelegate.globalTextWhere isEqualToString:@"Favourites"])
            self.title=@"Favourite";
    if([mainDelegate.globalTextWhere isEqualToString:@"Current%20Location"])
            self.title=@"Near By";
        
	//Initialize the array
	tableListofRestaurants = [[NSMutableArray alloc] init];

	//{Invoke network progress monitor in status bar and another on in view
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[self invokeMegaAnnoyingPopup];
		//}
	
	//{Verify the latituded langtitude are set
	mainDelegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
	receivedCL=mainDelegate.globalGPSLocation;
	//}
	
    imgStar=[UIImage imageNamed:@"btn_Star.png"];

	
	
}

-(void) viewWillAppear:(BOOL)animated
{
    //if([mainDelegate.globalTextWhere isEqualToString:@"Favourites"])
    
  	[self getRestaurantFromURL];
  
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
}


- (void)dealloc {
	[tableListofRestaurants release];
    [super dealloc];
}

- (IBAction) goHome : (id) sender{
	
	
}

#pragma mark UITableViewDataSource

// tell our table how many rows it will have, in our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [tableListofRestaurants count];

}

-(CGFloat)tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 82;
}

// tell our table what kind of cell to use and its title for the given row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	static NSString *CellIdentifier =@"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
	NSString *cellValue=[tableListofRestaurants objectAtIndex:indexPath.row];
	RestaurantDetails=[cellValue componentsSeparatedByString:@"|"];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
	}
    else {
        NSArray *cellSubs = cell.contentView.subviews;
        for (int i = 0 ; i < [cellSubs count] ; i++) {
            [[cellSubs objectAtIndex:i] removeFromSuperview];
        }
    }	

	//cell.textLabel.text = cellValue;
    //cell.detailTextLabel.text = strMsg;

    NSString *HeadCell= [[NSString alloc] initWithFormat: @"%@",[RestaurantDetails	objectAtIndex:1]];
	NSString *DescCell= [[NSString alloc] initWithFormat: @"%@",[RestaurantDetails	objectAtIndex:2]];
	NSString *StarCell= [[NSString alloc] initWithFormat: @"%@",[RestaurantDetails	objectAtIndex:3]];
	NSString *InfoCell= [[NSString alloc] initWithFormat: @"%@",[RestaurantDetails	objectAtIndex:5]];
    int starValue=[StarCell intValue];
    /*
	cell.textLabel.text = [RestaurantDetails	objectAtIndex:1];
    cell.detailTextLabel.text = DescCell;
    cell.detailTextLabel.numberOfLines=2;
    if(indexPath.row==0)
        cell.imageView.image=imgFav;
    else
        cell.imageView.image=imgGps;
*/
    //cell.backgroundColor=[UIColor groupTableViewBackgroundColor];
    //HeadCell=[RestaurantDetails	objectAtIndex:1];
    
    UILabel *restName=[[UILabel alloc] initWithFrame:CGRectMake(7, 0, 320, 20)];
        restName.text=HeadCell;//[NSString substringToIndex:30];    
        restName.textAlignment=UITextAlignmentLeft;
        restName.lineBreakMode=UILineBreakModeWordWrap;
        //restName.textColor=[UIColor blueColor];
        restName.numberOfLines=1;
        //[restName setFont:[UIFont fontWithName:@"Arial Black" size:18]];
        restName.font=[UIFont boldSystemFontOfSize:18];
        //restName.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    UILabel *restDetail=[[UILabel alloc] initWithFrame:CGRectMake(7, 20, 320, 20)];
        restDetail.text=DescCell;//[NSString substringToIndex:30];    
        restDetail.textAlignment=UITextAlignmentLeft;
        restDetail.lineBreakMode=UILineBreakModeWordWrap;
        restDetail.numberOfLines=1;
        restDetail.textColor=[UIColor grayColor];
        restDetail.font=[UIFont systemFontOfSize:14];
        //restDetail.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    UILabel *restInfo=[[UILabel alloc] initWithFrame:CGRectMake(7, 40, 320, 20)];
        restInfo.text=InfoCell;//[NSString substringToIndex:30];    
        restInfo.textAlignment=UITextAlignmentLeft;
        restInfo.lineBreakMode=UILineBreakModeWordWrap;
        restInfo.numberOfLines=1;
        restInfo.textColor=[UIColor grayColor];
        restInfo.font=[UIFont systemFontOfSize:11];

    /*
    UIButton *starsBtn=[[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        starsBtn.frame=CGRectMake(10, 40, 20, 20);
        [starsBtn setTitle:@"Play2" forState:UIControlStateNormal];*/
    
    //starValue=indexPath.row;
    if (starValue>=5) starValue=5;
    int i=21;
    int j=1;
    int row=60;
    UIImageView *starsImg1=[[UIImageView alloc] initWithImage:imgStar];
        starsImg1.frame=CGRectMake(i*j, row, 15, 15);
        //starsImg1.backgroundColor=[UIColor groupTableViewBackgroundColor];
        j++;
        //[starsImg1 setAlpha:1];
    UIImageView *starsImg2=[[UIImageView alloc] initWithImage:imgStar];
        starsImg2.frame=CGRectMake(i*j, row, 15, 15);
        //starsImg2.backgroundColor=[UIColor groupTableViewBackgroundColor];
        j++;
        //[starsImg2 setAlpha:1];
    UIImageView *starsImg3=[[UIImageView alloc] initWithImage:imgStar];
        starsImg3.frame=CGRectMake(i*j, row, 15, 15);
        //starsImg3.backgroundColor=[UIColor groupTableViewBackgroundColor];
        j++;
        //[starsImg3 setAlpha:1];
    UIImageView *starsImg4=[[UIImageView alloc] initWithImage:imgStar];
        starsImg4.frame=CGRectMake(i*j, row, 15, 15);
        //starsImg4.backgroundColor=[UIColor groupTableViewBackgroundColor];
        j++;
        //[starsImg4 setAlpha:1];
    UIImageView *starsImg5=[[UIImageView alloc] initWithImage:imgStar];
        starsImg5.frame=CGRectMake(i*j, row, 15, 15);
        //starsImg5.backgroundColor=[UIColor groupTableViewBackgroundColor];
        j++;
        //[starsImg5 setAlpha:1];
    
    [cell.contentView addSubview:restName];
    [cell.contentView addSubview:restDetail];
    [cell.contentView addSubview:restInfo];
    
   
    if (starValue>=1) [cell.contentView addSubview:starsImg1];
    if (starValue>=2) [cell.contentView addSubview:starsImg2];
    if (starValue>=3) [cell.contentView addSubview:starsImg3];
    if (starValue>=4) [cell.contentView addSubview:starsImg4];
    if (starValue>=5) [cell.contentView addSubview:starsImg5];
 
    [cell.contentView sizeToFit];
    cell.contentView.autoresizesSubviews=YES;
    
	[restName release];
    [starsImg1 release];
    [starsImg2 release];
    [starsImg3 release];
    [starsImg4 release];
    [starsImg5 release];
	return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection	: (NSInteger) section{
 return @"List of restaurants";
}


-(NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger *)section{
	return @"";

}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    NSString *selectedRes=[tableListofRestaurants objectAtIndex:indexPath.row];
	
	RestaurantDetails=[selectedRes componentsSeparatedByString:@"|"];

    if ([RestaurantDetails count]>=2) 
    {
        //{Pass selected restaurant id to next class
        mainDelegate.globalRestaurantId=[RestaurantDetails objectAtIndex:0];
        mainDelegate.globalRestaurantName=[RestaurantDetails objectAtIndex:1];
        //}
        

        //{Push to next detail view
            RestaurantDetail* vc1 = [[RestaurantDetail alloc] initWithNibName:@"RestaurantDetail" bundle:nil];
            [[self navigationController] pushViewController:vc1 animated:YES];	
            //}
    }


}



//{GET URL DATA STARTS HERE


- (BOOL) getRestaurantFromURL
{
    tableListofRestaurants = [[NSMutableArray alloc] init];


	NSString *reqURL;	
	
    //Link for current gps
    reqURL=[NSString stringWithFormat:@"%@?apiid=11010&usr=%@&food=%@&lat=0&lon=0&query=%@",mainDelegate.globalMainUrl, mainDelegate.globalUserName,mainDelegate.globalTextFood,mainDelegate.globalTextWhere];

    
    //URL for current location
    if([mainDelegate.globalTextWhere isEqualToString:@"Current%20Location"])
        reqURL=[NSString stringWithFormat:@"%@?apiid=11010&usr=%@&food=all&lat=%f&lon=%f&query=%@",mainDelegate.globalMainUrl, mainDelegate.globalUserName,[receivedCL coordinate].latitude,[receivedCL coordinate].longitude,mainDelegate.globalTextWhere];
    
    //URL for bookmarked
    if([mainDelegate.globalTextWhere isEqualToString:@"Favourites"])
        reqURL=[NSString stringWithFormat:@"%@?apiid=11010&usr=%@&food=all&lat=0&lon=0&query=%@",mainDelegate.globalMainUrl, mainDelegate.globalUserName,mainDelegate.globalTextWhere];
    
	
	NSURLRequest *theRequest=[NSURLRequest requestWithURL: [NSURL URLWithString:reqURL]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:20.0];
	// create the connection with the request
	// and start loading the data
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		// Create the NSMutableData to hold the received data.
		// receivedData is an instance variable declared elsewhere.
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
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    //	NSString *strMsg = [[NSString alloc] initWithFormat: @"Suceeded Bytes %d",[receivedData length]];
 	NSString *strMsg = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	int strLen=0;
	int objPos=0;		// add object position increment
	NSString *strLine;  // hold one line of received data ie one restaurant's data

	urlListofRestaurants=[strMsg componentsSeparatedByString:@"#"];
	
	
	for(int i=0; i<[urlListofRestaurants count];i++)
	{
		//Validate the datas received
		strLine=[urlListofRestaurants objectAtIndex:i];
		strLen=[strLine length];
		
		
		//Add the validated object into memory
		if(strLen>0)
		{
            
            RestaurantDetails=[strLine componentsSeparatedByString:@"|"];
            isMoreResults=[[RestaurantDetails	objectAtIndex:0] intValue];
            if(isMoreResults==0)
            {
                strListEnd=[RestaurantDetails	objectAtIndex:1];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                                message:strListEnd
                                                               delegate:nil 
                                                      cancelButtonTitle:@"OK" 
                                                      otherButtonTitles: nil];
                
                [alert show];
                [alert release];

                break;
            }
            else
            {
                [tableListofRestaurants addObject:strLine];
                objPos=objPos+1;
            }
		}
	}

	
	if(objPos==0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No restaurant found!" 
														message:@""
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles: nil];
		
		[alert show];
		[alert release];
	}
    // release the connection, and the data object
	
	[myTable reloadData];
	[connection release];
    [receivedData release];
  
    
	//{Dismiss network monitor in status bar and in view 
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self dismissMegaAnnoyingPopup];
	//}

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



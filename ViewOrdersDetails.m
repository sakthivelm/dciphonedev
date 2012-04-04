//
//  ViewOrdersDetails.m
//  
//
//  Created by Sakthivel Muthusamy on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewOrdersDetails.h"
#import "AppDelegate.h"
#import "AddtoCart.h"
#import "RestaurantDetail.h"
#import "Coupons.h"


NSMutableData *receivedData;		// holds url downloads

NSArray *urlListofMenus;			// holds line by line data of received data

NSArray *menuDetails;				// holds spilited data of one restaurant
NSArray *responseReceived;


NSMutableArray *tableListOfItems;	//Holds list of options on table view
NSMutableArray *testArray;

AppDelegate *mainDelegate;
int urlResponse=0;
int urlCartCopyMode=0;

int noOfItems;




@implementation ViewOrdersDetails

@synthesize megaAlert;				// for network progress view 


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    noOfItems=0;
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
    
    tableListOfItems = [[NSMutableArray alloc] init];
    
    //orderDate.text=mainDelegate.globalAddCartDate;
    //orderTime.text=mainDelegate.globalAddCartTime;
    
    orderDate.text=[mainDelegate.globaldeliverydate description];
    


    if ([mainDelegate.globalActiveOrderPage intValue]==0) 
    {
        checkOut.hidden= FALSE; 
        [checkOut setTitle:@"Send Order" forState:UIControlStateNormal];
        urlCartCopyMode=0;
    }
    if ([mainDelegate.globalActiveOrderPage intValue]==1) 
    {
        checkOut.hidden= FALSE; 
        [checkOut setTitle:@"Copy to Cart" forState:UIControlStateNormal];
        urlCartCopyMode=1;
    }
    if ([mainDelegate.globalActiveOrderPage intValue]==2) 
    {
        checkOut.hidden= FALSE; 
        [checkOut setTitle:@"Copy to Cart" forState:UIControlStateNormal];
        urlCartCopyMode=1;
    }
    
    //View restaurant details
    //UIBarButtonItem *rightDateButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(viewRestaurantDetail)];
    UIBarButtonItem *rightDateButton=[[UIBarButtonItem alloc] initWithTitle:@"Restaurant" style:UIBarButtonSystemItemCompose target:self action:@selector(viewRestaurantDetail)];
    self.navigationItem.rightBarButtonItem=rightDateButton;
    //}

    
    urlResponse=0;
    if ([mainDelegate.globalActiveOrderPage intValue]>=1)
        [self getMenusFromURL];
}

- (IBAction) viewRestaurantDetail
{
    //{Push to next detail view
    RestaurantDetail* vc1 = [[RestaurantDetail alloc] initWithNibName:@"RestaurantDetail" bundle:nil];
    [[self navigationController] pushViewController:vc1 animated:YES];	
    //}
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewWillAppear:(BOOL)animated{
    if ([mainDelegate.globalActiveOrderPage intValue]==0)
    {
        [self getMenusFromURL];
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
    return [tableListOfItems count];
    
}

-(CGFloat)tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row>=noOfItems)
        return  40;
    else
        return 62;
}

// tell our table what kind of cell to use and its title for the given row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSString *cellValue=[tableListOfItems objectAtIndex:indexPath.row];			
    menuDetails=[cellValue componentsSeparatedByString:@"|"];

    static NSString *CellIdentifier =@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //CGRect viewFrame = cell.contentView.frame;
    //viewFrame.size.height=20;
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    else {
        NSArray *cellSubs = cell.contentView.subviews;
        for (int i = 0 ; i < [cellSubs count] ; i++) {
            [[cellSubs objectAtIndex:i] removeFromSuperview];
        }
    }	
   
    NSString *ItemName= [[NSString alloc] initWithFormat: @"%@",[menuDetails objectAtIndex:2]];
	NSString *ItemDesc= [[NSString alloc] initWithFormat: @"%@ %@",[menuDetails objectAtIndex:3],[menuDetails objectAtIndex:4]];
    //NSString *ItemVari= [[NSString alloc] initWithFormat: @"%@",[menuDetails objectAtIndex:4]];
	NSString *ItemRate= [[NSString alloc] initWithFormat: @"%@",[menuDetails objectAtIndex:5]];
	NSString *ItemQty= [[NSString alloc] initWithFormat: @"%@",[menuDetails objectAtIndex:7]];
	NSString *ItemAmnt= [[NSString alloc] initWithFormat: @"%@",[menuDetails objectAtIndex:8]];
    
    int nQty=0;
    int nRate=0;
    nRate=[[menuDetails	objectAtIndex:5] intValue];
    nQty=[[menuDetails	objectAtIndex:7] intValue];
    
    if ((nQty==0)&&(nRate==0))
        {
            UILabel *totalText=[[UILabel alloc] initWithFrame:CGRectMake(5, 3, 240, 20)];
            totalText.text=ItemDesc;   // 3
            totalText.textAlignment=UITextAlignmentLeft;
            totalText.lineBreakMode=UILineBreakModeWordWrap;
            totalText.textColor=[UIColor colorWithRed:0x10/255.0 green:0x10/255.0  blue:0x10/255.0  alpha:1];
            
            totalText.numberOfLines=2;
            //totalText.font=[UIFont boldSystemFontOfSize:18];
            totalText.font=[UIFont systemFontOfSize:18];
            totalText.backgroundColor=[UIColor whiteColor];

            UILabel *totalAmt=[[UILabel alloc] initWithFrame:CGRectMake(252, 3, 50, 20)];
            totalAmt.text=ItemAmnt;   // 8 
            totalAmt.textAlignment=UITextAlignmentRight;
            totalAmt.lineBreakMode=UILineBreakModeWordWrap;
            totalAmt.numberOfLines=1;
            totalAmt.textColor=[UIColor colorWithRed:0x10/255.0 green:0x10/255.0  blue:0x10/255.0  alpha:1];
            totalAmt.font=[UIFont systemFontOfSize:18];
            
            
            [cell.contentView addSubview:totalText];
            [cell.contentView addSubview:totalAmt];
            
            [totalText release];
            [totalAmt release];
            
        }
    else
        {
                UILabel *itemName=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 320, 20)];
                    itemName.text=ItemName;   
                    itemName.textAlignment=UITextAlignmentLeft;
                    itemName.lineBreakMode=UILineBreakModeWordWrap;
                    //restName.textColor=[UIColor blueColor];
                    itemName.numberOfLines=1;
                    //[restName setFont:[UIFont fontWithName:@"Arial Black" size:18]];
                    itemName.font=[UIFont boldSystemFontOfSize:18];
                    itemName.backgroundColor=[UIColor whiteColor];
                   
                
                UILabel *itemDetail=[[UILabel alloc] initWithFrame:CGRectMake(5, 20, 320, 20)];
                    itemDetail.text=ItemDesc;
                    itemDetail.textAlignment=UITextAlignmentLeft;
                    itemDetail.textColor=[UIColor grayColor];

                    
                    itemDetail.lineBreakMode=UILineBreakModeWordWrap;
                    itemDetail.numberOfLines=1;

                    itemDetail.font=[UIFont systemFontOfSize:14];
                    //itemDetail.backgroundColor=[UIColor groupTableViewBackgroundColor];

                UILabel *itemRate=[[UILabel alloc] initWithFrame:CGRectMake(126, 40, 50, 20)];
                    itemRate.text=ItemRate;    
                    itemRate.textAlignment=UITextAlignmentRight;
                    itemRate.lineBreakMode=UILineBreakModeWordWrap;
                    itemRate.numberOfLines=1;
                    itemRate.textColor=[UIColor redColor];
                    itemRate.font=[UIFont systemFontOfSize:17];
                    //itemRate.backgroundColor=[UIColor groupTableViewBackgroundColor];
                
                UILabel *itemQty=[[UILabel alloc] initWithFrame:CGRectMake(175, 40, 50, 20)];
                    itemQty.text=ItemQty;    
                    itemQty.textAlignment=UITextAlignmentRight;
                    itemQty.lineBreakMode=UILineBreakModeWordWrap;
                    itemQty.numberOfLines=1;
                    itemQty.textColor=[UIColor redColor];
                    itemQty.font=[UIFont systemFontOfSize:17];
                    //itemQty.backgroundColor=[UIColor groupTableViewBackgroundColor];

                UILabel *itemAmt=[[UILabel alloc] initWithFrame:CGRectMake(252, 40, 50, 20)];
                    itemAmt.text=ItemAmnt;    
                    itemAmt.textAlignment=UITextAlignmentRight;
                    itemAmt.lineBreakMode=UILineBreakModeWordWrap;
                    itemAmt.numberOfLines=1;
                    itemAmt.textColor=[UIColor redColor];
                    itemAmt.font=[UIFont systemFontOfSize:17];
                    //itemAmt.backgroundColor=[UIColor groupTableViewBackgroundColor];

                    [cell.contentView addSubview:itemName];
                    [cell.contentView addSubview:itemDetail];
                    [cell.contentView addSubview:itemRate];
                    [cell.contentView addSubview:itemQty];
                    [cell.contentView addSubview:itemAmt];
            
            [itemName release];
            [itemDetail release];
            [itemRate release];
            [itemQty release];
            [itemAmt release];
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
    if ([mainDelegate.globalActiveOrderPage intValue]!=0) return;
    
    NSString *selectedRes=[tableListOfItems objectAtIndex:indexPath.row];
    
    menuDetails=[selectedRes componentsSeparatedByString:@"|"];
    
    mainDelegate.globalAddCartItemId =[menuDetails objectAtIndex:0];
    mainDelegate.globalAddCartItemName=[menuDetails objectAtIndex:2];    
    mainDelegate.globalAddCartInstructions=[menuDetails objectAtIndex:3];
    mainDelegate.globalAddCartItemVariant=[menuDetails objectAtIndex:4];
    mainDelegate.globalAddCartRate=[menuDetails objectAtIndex:5]; 
    mainDelegate.globalAddCartQty=[menuDetails objectAtIndex:7];
    mainDelegate.globalAddCartInputtext=[menuDetails objectAtIndex:9];
    
    
    mainDelegate.globalAddCartOption=[NSNumber numberWithInt: 1];
    //{Push to next detail view
    AddtoCart* vc1 = [[AddtoCart alloc] initWithNibName:@"AddtoCart" bundle:nil]; 
    [[self navigationController] pushViewController:vc1 animated:YES];	
    //}

        
}
//TABLE INITIALIZATION ENDS HERE


- (IBAction) postCheckOut
{
    urlResponse=6;
    //[self getMenusFromURL]; 
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                  initWithTitle:@"Confirm ?" 
                                  delegate:self 
                                  cancelButtonTitle:@"No!" 
                                  destructiveButtonTitle:@"Yes" 
                                  otherButtonTitles:nil]; 
    //[actionSheet showInView:self.view]; 
    [actionSheet showInView:self.parentViewController.tabBarController.view];
    [actionSheet release];
}

- (IBAction) postApplicableCoupons
{

    Coupons* vcCoupon;

    vcCoupon= [[Coupons alloc] initWithNibName:@"Coupons" bundle:nil]; 
    [vcCoupon setApplicable];

    [[self navigationController] pushViewController:vcCoupon animated:YES];
    
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[vcCoupon getCouponId] 
                                                    message:@"Retry"
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    
    [alert show];
    [alert release];
     */

}

- (void)actionSheet:(UIActionSheet *)actionSheet 
didDismissWithButtonIndex:(NSInteger)buttonIndex 
{ 
 
    if (buttonIndex == [actionSheet destructiveButtonIndex]) 
    { 
        [self getMenusFromURL];
    } 
} 




//{GET URL DATA STARTS HERE



- (BOOL) getMenusFromURL
{
    //{Invoke network progress monitor in status bar and another on in view
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self invokeMegaAnnoyingPopup];
    //}
    
    NSString *strdeliveryDate;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"YYYYMMdd HH:MM"];
    strdeliveryDate=[dateformater stringFromDate:mainDelegate.globaldeliverydate];

	NSString *reqURL;
    NSString *reqUrlEncoded;
    
    if(urlResponse==0)
    {
        if ([mainDelegate.globalActiveOrderPage intValue]==0)
            reqURL=[NSString stringWithFormat:@"%@?apiid=15060&usr=%@&coupon=%d",mainDelegate.globalMainUrl, mainDelegate.globalUserName,[mainDelegate.globalAcceptedCouponId intValue]
                    ];
        if ([mainDelegate.globalActiveOrderPage intValue]==1)
            reqURL=[NSString stringWithFormat:@"%@?apiid=15070&usr=%@&ordid=%@",mainDelegate.globalMainUrl, mainDelegate.globalUserName,mainDelegate.globalAddCartItemId];
        if ([mainDelegate.globalActiveOrderPage intValue]==2)
            reqURL=[NSString stringWithFormat:@"%@?apiid=15080&usr=%@&ordid=%@",mainDelegate.globalMainUrl, mainDelegate.globalUserName,mainDelegate.globalAddCartItemId];

    }
    
    if(urlResponse==6)
    {
        if(urlCartCopyMode==0)
            reqURL=[NSString stringWithFormat:@"%@?apiid=15090&usr=%@&aptno=%@&streetno=%@&street=%@&city=%@&state=%@&zip=%@&person=%@&phone=%@&date=%@&ordtype=%@&coupon=%@&lat=%f&lon=%f",mainDelegate.globalMainUrl, mainDelegate.globalUserName,
            mainDelegate.globaldeliveryaptno,
            mainDelegate.globaldeliverystreetno,
            mainDelegate.globaldeliverystreet,
            mainDelegate.globaldeliverycity,
            mainDelegate.globaldeliverystate,
            mainDelegate.globaldeliveryzip,
            mainDelegate.globaldeliveryperson,
            mainDelegate.globaldeliveryphone,
            strdeliveryDate,
            mainDelegate.globalAddCartItemId,
            mainDelegate.globalAcceptedCouponId,
            [mainDelegate.globalGPSLocation coordinate].latitude,
            [mainDelegate.globalGPSLocation coordinate].longitude        
                    ];
        else
            reqURL=[NSString stringWithFormat:@"%@?apiid=15095&usr=%@&ordid=%@",mainDelegate.globalMainUrl, mainDelegate.globalUserName,mainDelegate.globalAddCartItemId
                     ];
    }
    
     /*
      //TRACER
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:reqURL 
     message:@"Retry"
     delegate:nil 
     cancelButtonTitle:@"OK" 
     otherButtonTitles: nil];
     
     [alert show];
     [alert release];
     */

        
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
	
 	NSString *strMsg = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	int strLen=0;
	int objPos=0;		// add object position increment
	NSString *strLine;  // hold one line of received data ie one restaurant's data
    int apiResponseId=0;
    int apiResponseCode=0;
    int dispMsgFlag=0;
    NSString *dispMsg;
    NSString *coupBtnText=@"";
    tableListOfItems = [[NSMutableArray alloc] init];
    noOfItems=0;
    
    btnCoupon.titleLabel.text=@"Coupon";

    //Tracer
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strMsg
                                                    message:nil
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    
    [alert show];
    [alert release];
    return;
     */
    //}
    
    dispMsg=@"";
    
	urlListofMenus=[strMsg componentsSeparatedByString:@"#"];
        NSString *selectedRes=[urlListofMenus objectAtIndex:1];
        
        responseReceived=[selectedRes componentsSeparatedByString:@"|"];
        if([responseReceived count]>=2)
        {
            apiResponseId=[[responseReceived objectAtIndex:0] intValue];
            apiResponseCode=[[responseReceived objectAtIndex:1] intValue];
            
            //status text returns when failed
            if(apiResponseId==15090)
                dispMsg=[responseReceived objectAtIndex:2];
        }
    
    //{Spilit Totals
    if(((apiResponseId==15060)||(apiResponseId==15070)||(apiResponseId==15080))&&
        ([responseReceived count]>=9))
        {
            noOfItems=[[responseReceived objectAtIndex:2] intValue];
            orderDate.text=[responseReceived objectAtIndex:3];
            //OrderGrossTotal.text=[responseReceived objectAtIndex:3];
            OrderTotal.text=[responseReceived objectAtIndex:4];
            DiscountText.text=[responseReceived objectAtIndex:5];
            DiscountAmount.text=[responseReceived objectAtIndex:6];
            
            mainDelegate.globalRestaurantId=[responseReceived objectAtIndex:7];
            mainDelegate.globalRestaurantName=[responseReceived objectAtIndex:8];
            self.title=mainDelegate.globalRestaurantName;
        }
        //}
            
        if((apiResponseId==15060)||(apiResponseId==15070)||(apiResponseId==15080)||(apiResponseId==15090)||(apiResponseId==15095))
        {
            switch (apiResponseCode) 
                {
                    case 10:
                    {
                        dispMsgFlag=1;
                        if (apiResponseId==15060) 
                        {
                            dispMsg=@"Success";
                            dispMsgFlag=0;
                            
                            coupBtnText=[NSString stringWithFormat:@"Coupon(%@)",
                                         [responseReceived objectAtIndex:9]];
                            btnCoupon.titleLabel.text=coupBtnText;
                            
                          }
                        if (apiResponseId==15070) {dispMsg=@"Success";dispMsgFlag=0;}
                        if (apiResponseId==15080) {dispMsg=@"Success";dispMsgFlag=0;}
                        
                        if (apiResponseId==15090) 
                            {
                                 //Clear badge value when checkout
                                [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:nil];
                            }
                        //copy to cart
                        if(apiResponseId==15095)
                        {
                            [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:[responseReceived objectAtIndex:2]];
                      }

                    }
                        break;
                    case 11:
                    {
                        
                        if (apiResponseId==15060) 
                            {dispMsgFlag=0;dispMsg=@"Failed";}
                        if (apiResponseId==15070) 
                            {dispMsgFlag=0;dispMsg=@"Failed";}
                        if (apiResponseId==15080) 
                            {dispMsgFlag=0;dispMsg=@"Failed";}
                        if (apiResponseId==15090) 
                            {dispMsgFlag=1;dispMsg=@"Order failed, Try again";}
                        if (apiResponseId==15095) 
                            {dispMsgFlag=1;dispMsg=@"Failed";}
                    }
                        break;
                        
                    case 12:
                    case 13:
                    {
                        dispMsgFlag=1;
                        //dispMsg message comes from server data
                    }
                        break;
                        
                    default:
                    {
                        dispMsgFlag=0;
                        dispMsg=@"Invalid response";
                    }
                        break;
                } // End of switch
            }// end of if
    
    
    if((dispMsgFlag==1)&&([dispMsg length]>0))
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:dispMsg
                                                            message:nil
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles: nil];
            
            [alert show];
            [alert release];
        }
    
    NSString *cellValue;
    NSString *strRate;
    if(urlResponse==0)
    {
          for(int i=2; i<[urlListofMenus count];i++)
        {
            //Validate the datas received
            strLine=[urlListofMenus objectAtIndex:i];
            strLen=[strLine length];
            
            
            //Add the validated object into memory
            if(strLen>4)
            {
                [tableListOfItems addObject:strLine];
                cellValue=[tableListOfItems objectAtIndex: objPos];			
                menuDetails=[cellValue componentsSeparatedByString:@"|"];
                if([menuDetails count]>=5)
                    strRate=[[NSString alloc] initWithFormat:@"%@",[menuDetails	objectAtIndex:5]];
                else
                    strRate=0;

                objPos=objPos+1;
            }		
        }
        
    }
	
	if((objPos==0)&&(urlResponse==0))
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No cart item found!" 
														message:nil
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles: nil];
		
		[alert show];
		[alert release];
	}
    
    // release the connection, and the data object
	[myRestaurantMenu reloadData];
    [connection release];
    [receivedData release];
    if(urlResponse==6)
    {
        if((apiResponseId==15090)&&(apiResponseCode==10))
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
            [[self navigationController] popViewControllerAnimated:YES];
    }

}



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

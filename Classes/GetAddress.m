//
//  GetAddress.m
//  
//
//  Created by Sakthivel Muthusamy on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GetAddress.h"
#import "AppDelegate.h"
#import "ViewOrdersDetails.h"

@implementation GetAddress


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
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    getAddressPoint = scrollview_GetAddress.contentOffset;
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:scrollview_GetAddress];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 30;
    [scrollview_GetAddress setContentOffset:pt animated:YES];           
}


- (void)actionSheet:(UIActionSheet *)actionSheet 
didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
    [self displayDate];
} 

- (IBAction) getDate
{
    NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                  initWithTitle:[NSString stringWithFormat:@"%@%@",title, NSLocalizedString(@"Set Date", @"")]
                                  delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    expecteddate.datePickerMode=UIDatePickerModeDateAndTime;
    expecteddate.minimumDate=expecteddate.date;//[NSDate date];
    expecteddate.minuteInterval=5;
    
    
    [actionSheet addSubview:expecteddate];
    [actionSheet showInView:self.parentViewController.tabBarController.view];
   
}

-(void) displayDate
{
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"YYYY-MM-dd hh:mm a"]; 
    NSString *textDate=[NSString stringWithFormat:@"%@",[dateformat stringFromDate:expecteddate.date]];
    
    //btnDate.titleLabel.text=textDate;
    [dateTime setTitle:textDate forState:UIControlStateNormal];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
	if (textField == aptno)
	{
		[aptno resignFirstResponder];
		[streetno becomeFirstResponder];
	}
	if (textField == streetno)
	{
		[streetno resignFirstResponder];
		[street becomeFirstResponder];
	}
	if (textField == street)
	{
		[street resignFirstResponder];
		[city becomeFirstResponder];
	}
    
    
 	if (textField == city)
	{
		[city resignFirstResponder];
		[state becomeFirstResponder];
	}
   
    
	if (textField == state)
	{
		[state resignFirstResponder];
		[zip becomeFirstResponder];
	}
    
	if (textField == zip)
	{
		[zip resignFirstResponder];
		[person becomeFirstResponder];
	}
	if (textField == person)
	{
		[person resignFirstResponder];
		[phone becomeFirstResponder];
	}
	if (textField == phone)
	{
		[phone resignFirstResponder];
	}
	return YES;
}

-(IBAction) continuePressed
{
    mainDelegate.globaldeliveryaptno=aptno.text;
    mainDelegate.globaldeliverystreetno=streetno.text;
    mainDelegate.globaldeliverystreet=street.text;
    mainDelegate.globaldeliverycity=city.text;
    mainDelegate.globaldeliverystate=state.text;
    mainDelegate.globaldeliveryzip=zip.text;
    mainDelegate.globaldeliveryperson=person.text;
    mainDelegate.globaldeliveryphone=phone.text;
    mainDelegate.globaldeliverydate=expecteddate.date;
    
    //{Push to next detail view
    ViewOrdersDetails* vc1 = [[ViewOrdersDetails alloc] initWithNibName:@"ViewOrdersDetails" bundle:nil]; 
    [[self navigationController] pushViewController:vc1 animated:YES];	
    //}

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollview_GetAddress.contentSize = CGSizeMake(320, 500);  // default 520

    
    expecteddate=[[UIDatePicker alloc] init];

    if(mainDelegate.globaldeliveryoption==[NSNumber numberWithInt: 1])
    {
        labelaptno.hidden=YES;
        aptno.hidden=YES;
        
        labelstreetno.hidden=YES;
        streetno.hidden=YES;
       
        labestreet.hidden=YES;
        street.hidden=YES;
        
        labelcity.hidden=YES;
        city.hidden=YES;
        
        labelstate.hidden=YES;
        state.hidden=YES;
        
        labelzip.hidden=YES;
        zip.hidden=YES;
        
        labelperson.hidden=YES;
        person.hidden=YES;
        
        labelphone.hidden=YES;
        phone.hidden=YES;
        
        labeldate.text=@"Pickup Time";
        
        [labeldate setFrame:CGRectMake(17, 91, 85, 21)];
        [dateTime setFrame:CGRectMake(120, 86, 180, 31)];
        [btnContinue setFrame:CGRectMake(150, 130, 100, 31)];
        
    }
   //expecteddate.hidden=YES;

    
    // Do any additional setup after loading the view from its nib.
    mainDelegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
    aptno.text=mainDelegate.globaldeliveryaptno;
    streetno.text=mainDelegate.globaldeliverystreetno;
    street.text=mainDelegate.globaldeliverystreet;
    state.text=mainDelegate.globaldeliverystate;
    city.text=mainDelegate.globaldeliverycity;
    zip.text=mainDelegate.globaldeliveryzip;
    person.text=mainDelegate.globaldeliveryperson;
    phone.text=mainDelegate.globaldeliveryphone;
    
    //{ Round of minute to next 5
        NSDate *today=[NSDate alloc];
        today=[NSDate date];
    
        NSDateComponents *currentTime=[[NSCalendar currentCalendar] components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:today];
        NSInteger minutes=[currentTime minute];
        float newminutes=(ceil((float)minutes/5.0))*5;
        if(minutes>newminutes)
            minutes=newminutes+5.0;
        else
            minutes=newminutes;
        minutes+=[mainDelegate.globaldeliveryleadtime intValue];
        [currentTime setMinute:minutes];
        today=[[NSCalendar currentCalendar] dateFromComponents:currentTime];
    //}
    
    [expecteddate setDate:today];
    mainDelegate.globaldeliverydate=[expecteddate date];
    
    [self displayDate];
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

@end

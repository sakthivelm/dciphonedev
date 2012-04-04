//
//  GetAddress.h
//
//  Created by Sakthivel Muthusamy on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GetAddress : UIViewController <UIActionSheetDelegate>{
    
    IBOutlet UIScrollView *scrollview_GetAddress;
    CGPoint getAddressPoint;

    IBOutlet UILabel *labelaptno;
    IBOutlet UITextField *aptno;
    
    IBOutlet UILabel *labelstreetno;
    IBOutlet UITextField *streetno;
    
    IBOutlet UILabel *labestreet;
    IBOutlet UITextField *street;
    
    IBOutlet UILabel *labelcity;
    IBOutlet UITextField *city;
    
    IBOutlet UILabel *labelstate;
    IBOutlet UITextField *state;
    
    IBOutlet UILabel *labelzip;
    IBOutlet UITextField *zip;
    
    IBOutlet UILabel *labelperson;
    IBOutlet UITextField *person;
    
    IBOutlet UILabel *labelphone;
    IBOutlet UITextField *phone;
    
    IBOutlet UILabel *labeldate;    
    IBOutlet UIButton *dateTime;
    
    IBOutlet UIButton *btnContinue;
    
    UIDatePicker *expecteddate;

}


-(IBAction) continuePressed;
-(IBAction) getDate;
-(void) displayDate;

@end

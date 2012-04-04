//
//  JoinNow.h
//  
//
//  Created by Sakthivel Muthusamy on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JoinNow : UIViewController {
    
    IBOutlet UIScrollView *scrollview_Joinnow;
    
    //UI IBoutlets
    IBOutlet UITextField *textName;
    IBOutlet UITextField *textUserName;
	IBOutlet UITextField *textPassWord;
	IBOutlet UITextField *textRetypePassword;
    IBOutlet UITextField *textPhone;
    IBOutlet UITextField *textEmail;
    IBOutlet UITextField *textAptNo;
    IBOutlet UITextField *textStreetNo;
    IBOutlet UITextField *textStreet;
    IBOutlet UITextField *textCity;
    IBOutlet UITextField *textZIP;
    IBOutlet UITextField *textState;
    IBOutlet UITextField *textCountry;
    IBOutlet UITextField *textBuzzer;
    IBOutlet UIButton *btnLogin;
    
    IBOutlet UIAlertView *megaAlert;
    CGPoint svos;
    
    int updateflag;

    
}

- (IBAction) doJoinNow;
- (IBAction) openURLTermsConditions;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (BOOL) initDownloadDataFromURL;
- (void) invokeMegaAnnoyingPopup;
- (void) dismissMegaAnnoyingPopup;

@property (nonatomic,retain)  IBOutlet UIAlertView *megaAlert;

@end

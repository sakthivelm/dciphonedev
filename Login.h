//
//  Login.h
//  
//
//  Created by Sakthivel Muthusamy on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Login : UIViewController {
        
    IBOutlet UITextField *textUserName;
	IBOutlet UITextField *textPassWord;
	IBOutlet UIButton *textGoButton;
    
    IBOutlet UIAlertView *megaAlert;
}
- (IBAction) doForgotPassword;
- (IBAction) doCreateAccount;
- (IBAction) doLogin;

- (BOOL) initDownloadDataFromURL:(int)url ;
- (BOOL) verifyConfirmationCode;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

- (void) invokeMegaAnnoyingPopup;
- (void) dismissMegaAnnoyingPopup;

@property (nonatomic,retain)  IBOutlet UIAlertView *megaAlert;

@end







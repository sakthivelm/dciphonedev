//
//  ConfirmRegistration.h
//  
//
//  Created by Sakthivel Muthusamy on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ConfirmRegistration : UIViewController {
    
    IBOutlet UITextField *ConfirmCode;
    IBOutlet UIButton *btnConfirm;
    IBOutlet UIAlertView *megaAlert;
    
}
- (IBAction) confirmAction;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (BOOL) initDownloadDataFromURL;
- (void) invokeMegaAnnoyingPopup;
- (void) dismissMegaAnnoyingPopup;


@property (nonatomic,retain)  IBOutlet UIAlertView *megaAlert;


@end


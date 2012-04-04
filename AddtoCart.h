//
//  AddtoCart.h
//  
//
//  Created by Sakthivel Muthusamy on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddtoCart : UIViewController {
    
    IBOutlet UITextField *textQty;
    IBOutlet UITextField *textInput;
    
    IBOutlet UITextView *textInstructions;
    
    IBOutlet UITextView *resAddress;
    IBOutlet UILabel *textRate;
    IBOutlet UIButton *btnAddCart;
    IBOutlet UIButton *btnRemove;
    IBOutlet UIAlertView *megaAlert;
  
}
- (IBAction) initDownloadDataFromURL;
- (IBAction) initDownloadDataFromURLforDelete;
- (IBAction) addQuantity;
- (IBAction) lessQuantity;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void) invokeMegaAnnoyingPopup;
- (void) dismissMegaAnnoyingPopup;


@property (nonatomic,retain)  IBOutlet UIAlertView *megaAlert;

@end

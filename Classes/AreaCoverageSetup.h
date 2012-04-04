//
//  AreaCoverageSetup.h
//  
//
//  Created by Sakthivel Muthusamy on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKReverseGeocoder.h>
//#import <CoreLocation/CoreLocation.h>


// Keys for the dictionary provided to the delegate.
extern NSString * const kSetupInfoKeyAccuracy;
extern NSString * const kSetupInfoKeyDistanceFilter;
extern NSString * const kSetupInfoKeyTimeout;


@class AreaCoverageSetup;


@protocol AreaCoverageSetupDelegate <NSObject>

@optional

- (void)setupViewController:(AreaCoverageSetup *)controller didFinishSetupWithInfo:(NSDictionary *)setupInfo;

@end

@interface AreaCoverageSetup : UIViewController <UIPickerViewDelegate, UIActionSheetDelegate>{
	
	//id <AreaCoverageSetupDelegate> delegate;
    
	NSMutableDictionary *setupInfo;
    //UIPickerView *accuracyPicker;
	UISwitch *radiousInMileSwitch;
	UISlider *radiousSlider;
	UILabel *radiousSliderOutput;
	UISlider *resultSlider;
	UILabel *resultSliderOutput;
    
    IBOutlet UILabel *accountHead;
    IBOutlet UITextView *accInfo;
    
	
	//IBOutlet MKMapView *mapView; 
	
	NSArray *accuracyOptions;
    BOOL configureForTracking;

	
}
-(IBAction) setMileSwitchChanged;
-(IBAction) setRadiousSlider;
-(IBAction) setResultSlider;

-(IBAction) applyChanges; // right navigation bar action

-(IBAction) editJoinNow;


- (BOOL) initDownload;
- (IBAction) initUpload;
- (BOOL) initDownloadDataFromURL:(int)url ;

- (void) invokeMegaAnnoyingPopup;
- (void) dismissMegaAnnoyingPopup;


@property (nonatomic,assign) id <AreaCoverageSetupDelegate> delegate;
@property (nonatomic,retain) NSMutableDictionary *setupInfo;
//@property (nonatomic,retain)  IBOutlet UIPickerView *accuracyPicker;

@property (nonatomic,retain) IBOutlet UISlider *radiousSlider;
@property (nonatomic,retain) IBOutlet UILabel *radiousSliderOutput;
@property (nonatomic,retain) IBOutlet UISlider *resultSlider;
@property (nonatomic,retain) IBOutlet UILabel *resultSliderOutput;
@property (nonatomic,retain) IBOutlet UISlider *archiveSlider;
@property (nonatomic,retain) IBOutlet UILabel *archiveSliderOutput;


@property (nonatomic,retain) IBOutlet UISwitch *radiousInMileSwitch;
@property (nonatomic,retain)  IBOutlet UIAlertView *megaAlert;

@property (nonatomic, retain) NSArray *accuracyOptions;
@property (nonatomic, assign) BOOL configureForTracking;


@end






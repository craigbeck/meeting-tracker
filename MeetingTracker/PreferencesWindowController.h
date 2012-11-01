//
//  PreferencesWindowController.h
//  MeetingTracker
//
//  Created by Craig Beck on 10/28/12.
//  Copyright (c) 2012 Craig Beck. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define DefaultNameKey @"defaultName"
#define DefaultHourlyRateKey @"defaultHourlyRate"


@interface PreferencesWindowController : NSWindowController
{
    IBOutlet NSTextField *defaultNameField;
    IBOutlet NSTextField *defaultHourlyRateField;
    NSString *_defaultName;
    double _defaultHourlyRate;
    double _hourlyRate;
}

- (IBAction)changeDefaultName:(id)sender;
- (IBAction)changeDefaultHourlyRate:(id)sender;

@end

//
//  PreferencesWindowController.m
//  MeetingTracker
//
//  Created by Craig Beck on 10/28/12.
//  Copyright (c) 2012 Craig Beck. All rights reserved.
//

#import "PreferencesWindowController.h"

@interface PreferencesWindowController ()

@end

@implementation PreferencesWindowController

- (id)init
{
    self = [super initWithWindowNibName:@"Preferences"];
    return self;
}

//- (id)initWithWindow:(NSWindow *)window
//{
//    self = [super initWithWindow:window];
//    if (self) {
//        // Initialization code here.
//    }
//    
//    return self;
//}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark - Preference Methods

- (IBAction)changeDefaultName:(id)sender
{
    LogMethod();
}

- (IBAction)changeDefaultHourlyRate:(id)sender
{
    LogMethod();
}

@end

//
//  PreferencesWindowController.m
//  MeetingTracker
//
//  Created by Craig Beck on 10/28/12.
//  Copyright (c) 2012 Craig Beck. All rights reserved.
//

#import "PreferencesWindowController.h"

//NSString * const DefaultNameKey = @"defaultName";
//NSString * const DefaultHoulyRateKey = @"defaultHourlyRate";

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaultNameField setStringValue:[defaults stringForKey:DefaultNameKey]];
    [defaultHourlyRateField setStringValue:[NSNumber numberWithFloat:[defaults floatForKey:DefaultHourlyRateKey]]];
}

#pragma mark - Preference Methods

- (IBAction)changeDefaultName:(id)sender
{
    Log(@"new default name: %@", [sender stringValue]);
    [[NSUserDefaults standardUserDefaults] setObject:[defaultNameField stringValue] forKey:DefaultNameKey];
}

- (IBAction)changeDefaultHourlyRate:(id)sender
{
    Log(@"%@", sender);
//    [[NSUserDefaults standardUserDefaults] setFloat:[defaultHourlyRateField stringValue] forKey:DefaultHourlyRateKey];
}

@end

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

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaultNameField setStringValue:[defaults stringForKey:DefaultNameKey]];
    [self setHourlyRate:[defaults doubleForKey:DefaultHourlyRateKey]];
}

#pragma mark - Preference Methods

- (IBAction)changeDefaultName:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:[defaultNameField stringValue] forKey:DefaultNameKey];
}

- (IBAction)changeDefaultHourlyRate:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setDouble:[self hourlyRate] forKey:DefaultHourlyRateKey];
}

- (double)hourlyRate
{
    return _hourlyRate;
}

- (void)setHourlyRate:(double)rate
{
    _hourlyRate = rate;
}

@end

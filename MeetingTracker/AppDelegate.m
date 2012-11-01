//
//  AppDelegate.m
//  MeetingTracker
//
//  Created by Craig Beck on 10/28/12.
//  Copyright (c) 2012 Craig Beck. All rights reserved.
//

#import "AppDelegate.h"
#import "PreferencesWindowController.h"

@implementation AppDelegate

- (id)init
{
    self = [super init];
    _documentCount = 0;
    return self;
}

+ (void)initialize
{
    NSDictionary *defaultValues = @{ DefaultNameKey: @"Employee", DefaultHourlyRateKey: [NSNumber numberWithFloat:25.50] };
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    NSDockTile *tile = [NSApp dockTile];
    [tile setBadgeLabel:@""];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(meetingStarted:)
                                                 name:@"meeting.started"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(meetingStopped:)
                                                 name:@"meeting.stopped"
                                               object:nil];
}

- (void)meetingStarted:(NSNotification *)notification
{
    _documentCount = _documentCount + 1;
    [[NSApp dockTile] setBadgeLabel:[NSString stringWithFormat:@"%li", _documentCount]];
}

- (void)meetingStopped:(NSNotification *)notification
{
    _documentCount = _documentCount - 1;
    if (_documentCount)
    {
        [[NSApp dockTile] setBadgeLabel:[NSString stringWithFormat:@"%li", _documentCount]];
    }
    else
    {
        [[NSApp dockTile] setBadgeLabel:@""];
    }
}

- (IBAction)showPreferencesWindow:(id)sender
{
    if (!preferencesController)
    {
        preferencesController = [[PreferencesWindowController alloc] init];
    }
    [preferencesController showWindow:self];
}

@end

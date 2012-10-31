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

- (IBAction)showPreferencesWindow:(id)sender
{
    if (!preferencesController)
    {
        preferencesController = [[PreferencesWindowController alloc] init];
    }
    [preferencesController showWindow:self];
}

@end

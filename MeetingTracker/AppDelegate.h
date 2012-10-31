//
//  AppDelegate.h
//  MeetingTracker
//
//  Created by Craig Beck on 10/28/12.
//  Copyright (c) 2012 Craig Beck. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PreferencesWindowController;

@interface AppDelegate : NSObject
{
    PreferencesWindowController *preferencesController;
}

- (IBAction)showPreferencesWindow:(id)sender;

@end

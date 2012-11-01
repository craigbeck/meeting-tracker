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
    Log(@"registered defaults: %@", defaultValues);
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    NSDockTile *tile = [NSApp dockTile];
    [tile setBadgeLabel:@""];
    NSDocumentController *docController = [NSDocumentController sharedDocumentController];
    _documentCount = [[docController documents] count];
    [docController addObserver:self forKeyPath:@"documents" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    if (_documentCount)
    {
        [tile setBadgeLabel:[NSString stringWithFormat:@"%lu", _documentCount]];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (keyPath == @"documents")
    {
        switch ([[change objectForKey:@"kind"] intValue])
        {
            case 2:
                // add
                NSLog(@"add document:%@", object);
                break;
            case 3:
                // remove
                NSLog(@"remove document:%@", object);
            default:
                break;
        }
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

//
//  Document.h
//  MeetingTracker
//
//  Created by Craig Beck on 10/15/12.
//  Copyright (c) 2012 Craig Beck. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Meeting;

@interface Document : NSDocument {
    NSTimer *_timer;
    Meeting *_meeting; 
}

@property (assign) IBOutlet NSTextField *currentTimeLabel;
@property (assign) IBOutlet NSDateFormatter *currentTimeFormatter;

- (Meeting *)meeting;
- (void)setMeeting:(Meeting *)aMeeting;
- (IBAction)logMeeting:(id)sender;
- (IBAction)logParticipants:(id)sender;
- (void)updateUI:(NSTimer *)timer;

- (NSTimer *)timer;
- (void)setTimer:(NSTimer *)timer;

@end

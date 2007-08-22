//
//  Server.h
//  iPhoneChat
//
//  Created by Chris on 8/15/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Channel : NSObject {
	NSString *name;
	NSString *title;
	NSMutableArray *users;
	NSMutableArray *messages;
}


- (id)init;

//accessors
- (NSString *)name;
- (NSString *)title;
- (int)msgCount;
- (NSString *)messageForRow:(int)row;
- (int)userCount;
- (NSString *)usernameForRow:(int)row;

- (void)newMessage:(NSString *)theMessage from:(NSString *)aPerson;
- (void)newJoin:(NSString *)aPerson;

//mutators
- (void)setChannelName:(NSString *)newName;
- (void)setTitle:(NSString *)newTitle;
- (void)queueMsg:(NSString *)newMsg;


- (void)dealloc;

@end

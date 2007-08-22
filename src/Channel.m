//
//  Server.m
//  iPhoneChat
//
//  Created by Chris on 8/15/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "Channel.h"
#import "iRCMobileApp.h"

@implementation Channel

- (id)init
{	
	messages = [[NSMutableArray alloc] init];
	users = [[NSMutableArray alloc] init];
	[self setChannelName:@"#testname"];
	[self setTitle:@"this is a title!!!"];
	//[self setPort:6667];
	//connected = NO;
	return self;
}


//accessors
- (NSString *)name
{
	return name;
}
- (NSString *)title
{
	return title;
}

- (int)msgCount
{
	NSLog(@"inside channel %@, returning message count: %i", name, [messages count]);
	return [messages count];
}
- (NSString *)messageForRow:(int)row
{	
	return [messages objectAtIndex: row];
}
- (int)userCount
{
	return [users count];
}
- (NSString *)usernameForRow:(int)row
{
	return [users objectAtIndex: row];
}


//mutators

- (void)newMessage:(NSString *)theMessage from:(NSString *)aPerson
{
	NSLog(@"got new mesage: %@", theMessage);
	//this is where we will add messages to the screen.  Now... for now we will just generate a string and put it here, but in the future we might want to look at
	//making a message structure so we can do cool Adium or iChat like effects for the cells.
	if([messages count] > 30)
	{
		[messages removeObjectAtIndex: 0];
	}
	
	[messages addObject:[NSString stringWithFormat:@"<%@> %@", aPerson, theMessage]];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"iRCMChannelDidChangeNotification" object:nil];
}

- (void)newJoin:(NSString *)aPerson
{
	[messages addObject:[NSString stringWithFormat:@"*** %@ has joined %@", aPerson, name]];
}


- (void)setChannelName:(NSString *)newName
{
	newName = [newName copy];
	[name release];
	name = newName;
}

- (void)setTitle:(NSString *)newTitle
{
	newTitle = [newTitle copy];
	[title release];
	title = newTitle;
}
- (void)queueMsg:(NSString *)newMsg
{
	if([messages count] > 30)
	{
		[messages removeObjectAtIndex:0];
	}
	[messages addObject: [newMsg copy]];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"iRCMChannelDidChangeNotification" object:[[self name] copy]];
}


- (void)dealloc
{
	[name release];
	[title release];
	
	[super dealloc];
}


@end

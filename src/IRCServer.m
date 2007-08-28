//
//  Server.m
//  iPhoneChat
//
//  Created by Chris on 8/15/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//
#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Message/DataScanner.h>

#import "IRCServer.h"
#import "Channel.h"
#import "iRCMobileApp.h"

@implementation IRCServer

- (id)init
{	
	[self setDescription:@"OSX86 Server"];
	[self setHostname:@"irc.osx86.hu"];
	[self setNickname:@"yourNickHere"];
	[self setUsername:@"iRCm"];
	[self setPort:6667];
	_OutgoingData = @"";
	_InputBuffer = @"";
	channels = [[NSMutableArray alloc] init];
	connected = NO;
	return self;
}

//connect with socket
- (void)connect
{
	if(connected == NO)
	{
		NSLog(@"started to initialize stream");
		NSHost *host = [NSHost hostWithName:hostname];
		[NSStream getStreamsToHost:host port:port inputStream:&iStream outputStream:&oStream];
		
		[iStream retain];
		[oStream retain];
		[iStream setDelegate:self];
		[oStream setDelegate:self];
		[iStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		[oStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		[iStream open];
		[oStream open];
		NSLog(@"end initialize stream");
	} else
	{
		NSLog(@"Already Connected.");
	}
}

// Both streams call this when events happen
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    if (aStream == iStream) {
        [self handleInputStreamEvent:eventCode];
    } else if (aStream == oStream) {
        [self handleOutputStreamEvent:eventCode];
    }
}

- (void)handleOutputStreamEvent:(NSStreamEvent)eventCode
{
	switch (eventCode) {
        case NSStreamEventHasSpaceAvailable:
        {
			NSLog(@"Has Space Avail");
			
			if([_OutgoingData length] > 0)
			{
				const uint8_t * rawstring = (const uint8_t *)[_OutgoingData UTF8String];
				[oStream write:rawstring maxLength:strlen(rawstring)];
				_OutgoingData = @"";
			}
			
			break;
        }
		case NSStreamEventOpenCompleted:
			connected = YES;
            NSLog(@"Output Open Completed");
            break;
        default:
        case NSStreamEventErrorOccurred:
			connected = NO;
            NSLog(@"An error occurred on the output stream.");
            break;
	}
}

- (void)handleInputStreamEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
        case NSStreamEventHasBytesAvailable:
            [self readBytes];
            break;
        case NSStreamEventOpenCompleted:
			connected=YES;
			NSLog(@"Input Open Completed");
            // Do Something
			_OutgoingData = [NSString stringWithFormat:@"NICK %@\r\n\r\n", [self nickname]] ;
			_OutgoingData = [_OutgoingData stringByAppendingString: [NSString stringWithFormat:@"USER %@ 8 * : %@ iPhone\r\n\r\n", [self username], [self username]]];
            break;
        default:
        case NSStreamEventErrorOccurred:
            NSLog(@"An error occurred on the input stream.");
			connected=NO;
            break;
    }
}

- (NSString *)getLastDataReceived
{
	return LastDataReceived;
}

- (void)sendMessage:(NSString* )message
{
	if([message length] > 0)
	{
		//make sure we save this crap
		_OutgoingData = [_OutgoingData stringByAppendingString: message];
		if(connected == YES)
		{
			if([oStream hasSpaceAvailable])
			{
				const uint8_t * rawstring = (const uint8_t *)[_OutgoingData UTF8String];
				[oStream write:rawstring maxLength:strlen(rawstring)];
				_OutgoingData = @"";
			}//else its currently full and we'll wait until it has space available again...
		}
	}
}


- (void)readBytes
{
	uint8_t buffer[128];
	int len;
	
	while ([iStream hasBytesAvailable])
	{
		len = [iStream read:buffer maxLength:sizeof(buffer)];
		if (len > 0)
		{
			NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
			if (nil != output)
			{
				//write the string here
				//[[iRCMobileApp sharedInstance] setMessage: output];
				//output = [output copy];
				
				_InputBuffer = [_InputBuffer stringByAppendingString: output];
				
				//scan input buffer for crlf??
				NSData *data = [[_InputBuffer copy] dataUsingEncoding:NSASCIIStringEncoding] ;
				const char *bytes = [data bytes];
				unsigned int length = [data length];
				BOOL hasCRLFAtEnd = NO;
				
				if(length > 2)
				{
					if(bytes[length - 1] == 10 && bytes[length - 2] == 13)
					{
						hasCRLFAtEnd = YES;
					}
				}
				
				/*
				if (bytes) {
					while (length > 0) {
						
						if(bytes[0] == 13)
						{
							if(bytes[1] == 10)
							{
								hasCRLFAtEnd = YES;
								break;
							}
						}

						bytes++;
						length--;
					}
				}*/
				
				if(hasCRLFAtEnd == YES)
				{
					LastDataReceived = [_InputBuffer copy];
					_InputBuffer = @"";
					[self ParseString: LastDataReceived];
					[[NSNotificationCenter defaultCenter] postNotificationName:@"iRCMServerHasDataNotification" object:nil];
				}
				
				
				//[temp release];
				
				//[output release];
			}
		}
	}
}

- (void)ParseString:(NSString *)longString
{
	NSLog(@" --- inside parser --- ");
	int i = 0;
	NSArray *listItems = [longString componentsSeparatedByString:@"\r\n"];
	for(i = 0; i < [listItems count]; i++)
	{
		//ok. from this point on we know we have a full "message". We can now dig "deeper" into the strings and parse them out more.
		//message types to look for:
		NSLog(@" --- inside item: %@ --- ", [listItems objectAtIndex:i]);
		
		NSArray *spacedItems = [ [[listItems objectAtIndex:i] copy] componentsSeparatedByString:@" "];
		int spacedItemCount = [spacedItems count];
		//NSLog(@"item count: %d", spacedItemCount);
		if(spacedItemCount > 1)
		{
			
			//---- PING
			if([spacedItems count] == 2 && [[spacedItems objectAtIndex:0] compare: @"PING"] == 0)
			{
				NSLog(@"!!!!!!!!!!WE FOUND A PING FROM %@ ZOMG.", [spacedItems objectAtIndex:1]);
				[self sendMessage:[NSString stringWithFormat:@"PONG %@\r\n",  [spacedItems objectAtIndex:1]]  ];
				NSLog(@"pongers!!!!");
			}
			
			//---- JOIN
			else if([spacedItems count] == 3 && [[spacedItems objectAtIndex:1] compare: @"JOIN"] == 0)
			{
				//some sorta join is taking place. We must now search to see who is joining what.
				NSArray *userJoin = [[spacedItems objectAtIndex:0] componentsSeparatedByString:@"!"];
				NSString *nickJoined = [[userJoin objectAtIndex:0] substringFromIndex:1];
				NSString *chanJoined = [[spacedItems objectAtIndex:2] substringFromIndex:1];
				if( [nickJoined compare: [self nickname]] == 0)
				{
					//it is us joining a channel
					NSLog(@" WE JOINED A CHANNEL!!!");
					
					Channel *newChan = [[Channel alloc] init];
					[newChan setChannelName: chanJoined];
					[self addNewChannel: newChan];
					
					
				} else
				{
					//it is someone else joining a channel
					int chanNum = [self getNumberForChannel: chanJoined];
	
					[[channels objectAtIndex:chanNum] newJoin:nickJoined];
					
					NSLog(@"%@ joined %@", nickJoined, chanJoined);
					LastDataReceived = [NSString stringWithFormat:@"%@ joined %@", nickJoined, chanJoined];
				}
			}
			
			//---- PRIVMSG
			else if([[spacedItems objectAtIndex:1] compare: @"PRIVMSG"] == 0)
			{
				NSLog(@"we detected a private message");
				NSString *msgTo = [spacedItems objectAtIndex:2];
				if( [msgTo compare: [self nickname]] == 0)
				{
					//the private msg was to us. lets see if we have a pm window open.
					NSLog(@"the private msg was to us!!!");
				}else
				{
					NSLog(@"the private msg was to a channel: %@", msgTo);
					//the private msg was to a channel. lets find the channel
					int chanNum = [self getNumberForChannel: msgTo];
					if(chanNum >= 0)
					{
						//this guarantees that we're joined...incase of a weird problem (or the person has a #xxxx as their name)
						//now lets build the message back up!
						int lengthOfUser = [[spacedItems objectAtIndex:0] length];
						int lengthOfPRIVMSG = [[spacedItems objectAtIndex:1] length]; //always 7
						int lengthOfChanName = [[spacedItems objectAtIndex:2] length]; 
						int total = lengthOfUser + lengthOfPRIVMSG + lengthOfChanName + 4;
						NSString *thePrivMsg = [longString substringFromIndex:total];
						//now lets get their nickname
						NSArray *userJoin = [[spacedItems objectAtIndex:0] componentsSeparatedByString:@"!"];
						NSString *nickJoined = [[userJoin objectAtIndex:0] substringFromIndex:1];
						
						[[channels objectAtIndex:chanNum] newMessage: thePrivMsg from:nickJoined];
						
					}
				} 							
			} else
			{
				NSLog(@"We dont know what this is:");
				//list items for debug:
				int j = 0;
				for(j = 0; j < spacedItemCount; j++)
				{
					NSLog(@"    %d: %@", j, [spacedItems objectAtIndex:j]);
				}
			}
			
			
			
		} else
		{
			//NSLog(@"Only one item: %@", [listItems objectAtIndex:i]);
		}
		
		
		
		//---- MODE
		//---- TOPIC
		//---- PRIVMSG
		
		//---- PART
		
		
		
		
	}
}




//disconnect socket
- (void)disconnect
{
	
}


- (IRCServer *)copy
{
	IRCServer *newServer =  [[IRCServer alloc] init];
	[newServer setDescription: [self description]];
	[newServer setHostname: [self hostname]];
	[newServer setPort: [self port]];
	
	return newServer;
}

- (NSString *)description
{
	return description;
}
- (void)setDescription:(NSString *)aDescription
{
	aDescription = [aDescription copy];
	[description release];
	description = aDescription;
}


- (NSString *)hostname
{
	return hostname;
}
- (void)setHostname:(NSString *)aHostname
{
	aHostname = [aHostname copy];
	[hostname release];
	hostname = aHostname;
}

- (int)port
{
	return port;
}
- (void)setPort:(int)aPort
{
	port = aPort;
}

- (NSString *)nickname
{
	return nickname;
}
- (void)setNickname:(NSString *)aNickname
{
	aNickname = [aNickname copy];
	[nickname release];
	nickname = aNickname;
}

- (NSString *)username
{
	return username;
}
- (void)setUsername:(NSString *)aUsername
{
	aUsername = [aUsername copy];
	[username release];
	username = aUsername;
}

// ----- channel related stuff ----

- (int)getNumberForChannel:(NSString *)channelName
{
	int chanNum = -1;
	int i = 0;
	for(i = 0; i < [channels count]; i++)
	{
		if([[[channels objectAtIndex: i] name] compare: channelName] == 0)
		{
			//we found the channel name, lets return i;
			return i;
		}
	}
	return chanNum;
}

- (void)joinChannel:(NSString *)channelToJoin
{
	NSLog(@"%@ got call to join channel %@", description, channelToJoin);
	if(connected == YES)
	{
		NSLog(@"im connected...so lets try joining");
		[self sendMessage:[NSString stringWithFormat:@"JOIN %@\r\n\r\n", channelToJoin]];
	}
}

- (void)sendCurrentChannelPM:(NSString *)message
{
	NSLog(@"%i", currentChannel);
	NSString *currentChan = [[channels objectAtIndex: currentChannel] name];
	NSLog(@"currentChannel : %@", currentChan);
	[self sendPM: currentChan withMessage: message];
	[[channels objectAtIndex:currentChannel] newMessage: message from:nickname];
}

- (void)sendPM:(NSString *)object withMessage:(NSString *)message
{
	[self sendMessage:[NSString stringWithFormat:@"PRIVMSG %@ :%@\r\n\r\n", object, message]];
	//make it show up in the channel window
	//[[channels objectAtIndex:object] newMessage: message from:nickname];
}

- (void)addNewChannel:(Channel *)newChannel
{
	[channels addObject:newChannel];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"iRCMServerHasDataNotification" object:nil];
	
	NSLog(@"Added new channel. New Count: %d", [channels count]);
}
- (int)currentChannel
{
	return currentChannel;
}
- (void)setCurrentChannel:(int)aChannel
{
	currentChannel = aChannel;
}
- (int)getJoinedChannelCount
{
	return [channels count];
}



- (NSString *)getNameForChannel: (int)aChannel
{
	return [[channels objectAtIndex: aChannel] name];
}
- (void)setChannelName:(NSString *)aName forChannel:(int)aChannel
{
	[[channels objectAtIndex:aChannel] setChannelName: aName];
}
- (NSString *)getTitleForChannel:(int)aChannel
{
	return [[channels objectAtIndex: aChannel] title];
}
- (void)setChannelTitle:(NSString *)aTitle forChannel:(int)aChannel
{
	[[channels objectAtIndex: aChannel] setTitle: aTitle];
}

- (int)getMsgCountForChannel:(int)aChannel
{
	NSLog(@"inside Server getMsgCountForChannel");
	return [[channels objectAtIndex:aChannel] msgCount];
}
- (NSString *)messageForRow:(int)row forChannel:(int)aChannel
{
	NSLog(@"inside IRCServer messageForRow");
	return [[channels objectAtIndex:aChannel] messageForRow: row];
}
- (int)getUserCountForChannel:(int)aChannel
{
	return [[channels objectAtIndex:aChannel] userCount];
}
- (NSString *)usernameForRow:(int)row forChannel:(int)aChannel
{
	return [[channels objectAtIndex:aChannel] usernameForRow: row];
}



- (BOOL)isConnected
{
	return connected;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:description forKey:@"description"];
	[coder encodeObject:hostname forKey:@"hostname"];
	[coder encodeInt:port forKey:@"port"];
	[coder encodeObject:nickname forKey:@"nickname"];
	[coder encodeObject:username forKey:@"username"];
}
- (id)initWithCoder:(NSCoder *)coder
{	
	self = [super init];
	
	[self setDescription:[coder decodeObjectForKey:@"description"]];
	[self setHostname:[coder decodeObjectForKey:@"hostname"]];
	[self setPort:[coder decodeIntForKey:@"port"]];
	[self setNickname:[coder decodeObjectForKey:@"nickname"]];
	[self setUsername:[coder decodeObjectForKey:@"username"]];
	_OutgoingData = @"";
	_InputBuffer = @"";
	channels = [[NSMutableArray alloc] init];
	connected = NO;
	return self;
}


- (void)dealloc
{
	[description release];
	[hostname release];
	
	[super dealloc];
}


@end

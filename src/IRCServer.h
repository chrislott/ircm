//
//  Server.h
//  iPhoneChat
//
//  Created by Chris on 8/15/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Channel.h"

@interface IRCServer : NSObject {
	NSString *description;
	NSString *hostname;
	int port;
	NSString *nickname;
	NSString *username;
	
	BOOL connected;
	NSInputStream *iStream;
	NSOutputStream *oStream;
	NSMutableData *_IncomingData;
	NSString *_OutgoingData;
	
	NSString *_InputBuffer;
	NSString *LastDataReceived;
	NSMutableArray *channels;
	int currentChannel;
}


- (id)init;

- (void)connect;
- (void)disconnect;
- (void)handleOutputStreamEvent:(NSStreamEvent)eventCode;
- (void)handleInputStreamEvent:(NSStreamEvent)eventCode;
- (void)readBytes;
- (void)sendMessage:(NSString *)message;
- (void)sendCurrentChannelPM:(NSString *)message;
- (NSString *)getLastDataReceived;

- (void)ParseString:(NSString *)longString;

- (IRCServer *)copy;
- (NSString *)description;
- (void)setDescription:(NSString *)aDescription;

- (NSString *)hostname;
- (void)setHostname:(NSString *)aHostname;

- (int)port;
- (void)setPort:(int)aPort;

- (NSString *)nickname;
- (void)setNickname:(NSString *)aNickname;

- (NSString *)username;
- (void)setUsername:(NSString *)aUsername;


//channel shit
- (void)joinChannel:(NSString *)channelToJoin;
- (void)addNewChannel:(Channel *)newChannel;
- (int)currentChannel;
- (void)setCurrentChannel:(int)aChannel;
- (NSString *)getNameForChannel: (int)aChannel;
- (void)setChannelName:(NSString *)aName forChannel:(int)aChannel;
- (NSString *)getTitleForChannel:(int)aChannel;
- (void)setChannelTitle:(NSString *)aTitle forChannel:(int)aChannel;
- (int)getJoinedChannelCount;

- (int)getNumberForChannel:(NSString *)channelName;

- (int)getMsgCountForChannel:(int)aChannel;
- (NSString *)messageForRow:(int)row forChannel:(int)aChannel;
- (int)getUserCountForChannel:(int)aChannel;
- (NSString *)usernameForRow:(int)row forChannel:(int)aChannel;


- (BOOL)isConnected;

- (void)encodeWithCoder:(NSCoder *)coder;
- (id)initWithCoder:(NSCoder *)coder;

- (void)dealloc;

@end

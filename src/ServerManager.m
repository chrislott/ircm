
#import "ServerManager.h"
#import "IRCServer.h"

static ServerManager *servMgr;

@implementation ServerManager

+ (ServerManager *)sharedServerManager
{
	if (!servMgr)
		servMgr = [[ServerManager alloc] init];
	
	return servMgr;
}

- (NSMutableArray *)servers
{
	return servers;
}

- (int)addServer:(IRCServer *)aServer
{
	[servers addObject:[aServer copy]];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"iRCMServersDidChangeNotification" object:self];
	return [self numberOfServers];
}
- (void)removeServer:(int)aServer
{
	if([[servers objectAtIndex:aServer] isConnected] == NO)
	{
		[servers removeObjectAtIndex:aServer];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"iRCMServersDidChangeNotification" object:self];
	} else
	{
		//message them??
	}
	
}

- (int)currentServer
{
	return currentServer;
}

- (NSString *)currentServerDesc
{
	NSLog(@"inside server manager..getting current server");
	IRCServer* server = [servers objectAtIndex:currentServer];
	NSLog(@"done getting current server, returning description: %@", [server description]);
	return [server description];
}
- (NSString *)currentServerHostname
{
	return [[servers objectAtIndex:currentServer] hostname];
}

- (int)currentServerPort
{
	return [(IRCServer*)[servers objectAtIndex:currentServer] port];
}

- (NSString *)currentServerNick
{
	return [[servers objectAtIndex:currentServer] nickname];
}

- (BOOL)isServerConnected:(int)aServer
{
	return [[servers objectAtIndex:aServer] isConnected];
}


- (void)dealloc
{
	[super dealloc];
}

- (id)init
{
	self = [super init];
	
	servMgr = self;
	
	servers = [[NSMutableArray alloc] init];
			
	IRCServer *server1 = [[IRCServer alloc] init];
	//IRCServer *server2 = [[IRCServer alloc] init];
	//[server2 setDescription: @"irc.efnet.net"];
	[servers addObject: server1];
	//[servers addObject: server2]; 
	
	currentServer = 0;
	currentChannel = 0;
	return self;
}

- (id)initWithContentsOfFile:(NSString *)aFile
{
	self = [self init];
	
	servMgr = self;
	NSLog(@"checking to see if file exists");
	//Check to see if a transactions file exists or accounts file
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:aFile]) {
		NSLog(@"the file exists! lets open it");
		NSMutableArray *temp = [NSKeyedUnarchiver unarchiveObjectWithFile:aFile];
		
		if ([[temp objectAtIndex:0] class] == [IRCServer class]) {
			[self setServers:temp];
			NSLog(@"Just set the servers to temp");
		} 
		
		
	} else
	{
		NSLog(@"no file exists.");
	}
	currentServer = 0;
	currentChannel = 0;
		
	return self;
}

- (NSString *)descOfServer:(int)aServer
{
	return [[servers objectAtIndex:aServer] description];
}

- (int)numberOfServers
{
	return [servers count];
}

- (int)numberOfChannelsForServer:(int)aServer
{
	return [[servers objectAtIndex:aServer] getJoinedChannelCount];
}
- (NSString *)channelNameForChannel:(int)chanNumber forServer:(int)aServer
{
	return [[servers objectAtIndex:aServer] getNameForChannel:chanNumber];
}

- (int)numberOfPrivMsgsForServer:(int)aServer
{
	// --------  FIX  ME   LATER  ---------
	//return [[[accounts objectAtIndex:aAccount] transactions] count];
	return 0;
}

- (void)tryToConnect:(int)aServer
{
	[[servers objectAtIndex:aServer] connect];
}
- (void)tryToJoin:(NSString *)aChannel forServer:(int)aServer
{
	[[servers objectAtIndex:aServer] joinChannel: aChannel];
}

- (void)sendCurrentChannelPM:(NSString *)message
{
	[[servers objectAtIndex:currentServer] sendCurrentChannelPM: message];
}

- (void)sendRawMessage:(NSString *)message forServer:(int)aServer
{
	NSString *withCRLF = [NSString stringWithFormat:@"%@\r\n\r\n", message];
	[[servers objectAtIndex:aServer] sendMessage:withCRLF];
}

- (void)setServers:(NSMutableArray *)aServers
{
	aServers = [aServers mutableCopy];
	[servers release];
	servers = aServers;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"iRCMServersDidChangeNotification" object:self];
}

- (void)setCurrentServer:(int)aCurrentServer
{
	currentServer = aCurrentServer;
	currentChannel = 0;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"iRCMCurrentServerDidChangeNotification" object:self];
}

- (void)setDescription:(NSString *)aDescription forServer:(int)aServer
{
	NSLog(@"Inside set Description for server# :%i", aServer);
	[[servers objectAtIndex:aServer] setDescription:aDescription];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"iRCMServersDidChangeNotification" object:self];
}

- (void)setHostname:(NSString *)aHostname forServer:(int)aServer
{
	[[servers objectAtIndex:aServer] setHostname:aHostname];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"iRCMServersDidChangeNotification" object:self];
}

- (void)setNickname:(NSString *)aNick forServer:(int)aServer
{
	[[servers objectAtIndex:aServer] setNickname:aNick];
	if([[servers objectAtIndex:aServer] isConnected] == YES)
	{
		NSString *compiledMsg = [NSString stringWithFormat:@"NICK %@\r\n\r\n", aNick];
		[[servers objectAtIndex:aServer] sendMessage:compiledMsg];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:@"iRCMServersDidChangeNotification" object:self];
}

- (void)setCurrentChannelModeString:(NSString *)aModeStr forServer:(int)aServer
{
	if([[servers objectAtIndex:aServer] isConnected] == YES)
	{
		NSString *compiledMsg = [NSString stringWithFormat:@"MODE %@ %@\r\n\r\n", [[servers objectAtIndex:aServer] getCurrentChannelName], aModeStr];
		[[servers objectAtIndex:aServer] sendMessage:compiledMsg];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:@"iRCMServersDidChangeNotification" object:self];
}

- (void)setCurrentChannelTopic:(NSString *)aTopic forServer:(int)aServer
{
	if([[servers objectAtIndex:aServer] isConnected] == YES)
	{
		NSString *compiledMsg = [NSString stringWithFormat:@"TOPIC %@ :%@\r\n\r\n", [[servers objectAtIndex:aServer] getCurrentChannelName], aTopic];
		[[servers objectAtIndex:aServer] sendMessage:compiledMsg];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:@"iRCMServersDidChangeNotification" object:self];
}

- (void)kickUserFromCurrentChannel:(NSString *)aUser withReason:(NSString *)aReason forServer:(int)aServer
{
	if([[servers objectAtIndex:aServer] isConnected] == YES)
	{
		NSString *compiledMsg = [NSString stringWithFormat:@"KICK %@ %@ :%@\r\n\r\n", [[servers objectAtIndex:aServer] getCurrentChannelName], aUser, aReason];
		[[servers objectAtIndex:aServer] sendMessage:compiledMsg];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:@"iRCMServersDidChangeNotification" object:self];
}

- (void)setPort:(int)aPort forServer:(int)aServer
{
	[[servers objectAtIndex:aServer] setPort:aPort];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"iRCMServersDidChangeNotification" object:self];
}


- (void)setCurrentChannel:(int)aChannel
{
	NSLog(@"current channel set to: %i, %@", aChannel, [[servers objectAtIndex:currentServer] getNameForChannel: aChannel]);
	currentChannel = aChannel;
	[[servers objectAtIndex:currentServer] setCurrentChannel: aChannel];
}

- (int)currentChannel
{
	return currentChannel;
}

- (NSString *)getCurrentChannelMessage:(int)msgNum
{
	NSLog(@"inside ServerMnager GetCurrentChannelMessage");
	return [[servers objectAtIndex:currentServer] messageForRow:msgNum forChannel:currentChannel];
}

- (NSString *)getCurrentChannelName
{
	if([[servers objectAtIndex:currentServer] isConnected] == YES)
	{
		return [[servers objectAtIndex:currentServer]getNameForChannel: currentChannel];
	} else return @"not connected";
}

- (int)getCurrentChannelMessageCount
{
	NSLog(@"inside getCurrentChannelMessageCount, current server %i", currentServer);
	if([[servers objectAtIndex:currentServer] isConnected] == YES)
	{
		return [[servers objectAtIndex:currentServer] getMsgCountForChannel: currentChannel];
	} else
	{
		NSLog(@"current server is not connected???");
		return 0;
	}
	
}

- (NSString *)getLastDataForServer:(int)aServer
{
	return [[servers objectAtIndex:aServer] getLastDataReceived];
}

- (NSString *)getDescriptionForServer:(int)aServer
{
	return [[servers objectAtIndex:aServer] description];
}
- (NSString *)getHostnameForServer:(int)aServer
{
	return [[servers objectAtIndex:aServer] hostname];
}
- (int)getPortForServer:(int)aServer
{
	return [(IRCServer *)[servers objectAtIndex:aServer] port];
}


- (void)writeToFile:(NSString *)aFile
{
	[NSKeyedArchiver archiveRootObject:servers toFile:aFile];
}

@end
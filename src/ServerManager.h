#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIPreferencesTableCell.h>

#import "IRCServer.h"

@interface ServerManager : NSObject {
	NSMutableArray *servers;
	
	int currentServer;
	int currentChannel;
}

+ (ServerManager *)sharedServerManager;

- (id)init;
- (id)initWithContentsOfFile:(NSString *)aFile;
- (void)dealloc;
- (NSMutableArray *)servers;
- (int)addServer:(IRCServer *)aServer;

- (int)currentServer;
- (NSString *)currentServerDesc;
- (NSString *)currentServerHostname;
- (int)currentServerPort;
- (NSString *)currentServerNick;

- (NSString *)descOfServer:(int)aServer;
- (int)numberOfServers;
- (int)numberOfChannelsForServer:(int)aServer;
- (NSString *)channelNameForChannel:(int)chanNumber forServer:(int)aServer;
- (BOOL)isServerConnected:(int)aServer;
- (int)numberOfPrivMsgsForServer:(int)aServer;
- (void)removeServer:(int)aServer;

- (void)tryToConnect:(int)aServer;
- (void)tryToJoin:(NSString *)aChannel forServer:(int)aServer;
- (void)setServers:(NSMutableArray *)aServers;
- (void)setCurrentServer:(int)aCurrentServer;
- (void)setDescription:(NSString *)aDescription forServer:(int)aServer;
- (void)setHostname:(NSString *)aHostname forServer:(int)aServer;
- (void)setPort:(int)aPort forServer:(int)aServer;
- (void)setNickname:(NSString *)aNick forServer:(int)aServer;

- (void)setCurrentChannel:(int)aChannel;
- (NSString *)getCurrentChannelMessage:(int)msgNum;
- (int)getCurrentChannelMessageCount;
- (NSString *)getCurrentChannelName;
- (void)sendCurrentChannelPM:(NSString *)message;
- (void)sendRawMessage:(NSString *)message forServer:(int)aServer;

- (NSString *)getLastDataForServer:(int)aServer;
- (NSString *)getDescriptionForServer:(int)aServer;
- (NSString *)getHostnameForServer:(int)aServer;
- (int)getPortForServer:(int)aServer;

- (void)writeToFile:(NSString *)aFile;

@end

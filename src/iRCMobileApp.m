#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#import <UIKit/CDStructures.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UIThreePartButton.h>
#import <UIKit/UINavigationBar.h>
#import <UIKit/UIWindow.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UITable.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UITableColumn.h>
#import <UIKit/UITransitionView.h>
#import <UIKit/UIView.h>
#import <UIKit/UINavigationItem.h>
#import "IRCServer.h"
#import "iRCMobileApp.h"
#import "ServerPrefsView.h"
#import "iRCMKeyboard.h"

//#import "libIRC.h"

NSMutableArray* servers;

BOOL keyboardIsOut;

//IRCClient client;
	
static iRCMobileApp *sharedInstance;

@implementation iRCMobileApp

+ (iRCMobileApp *)sharedInstance
{
	if (!sharedInstance)
	{
		sharedInstance = [[iRCMobileApp alloc] init];
	}
	
	return sharedInstance;
}



- (void)alertSheet:(UIAlertSheet *)sheet buttonClicked:(int)button 
{
	[sheet dismiss];
}

- (BOOL)keyboardIsOut
{
	return keyboardIsOut;
}

- (void)setKeyboardIsOut:(BOOL)value
{
	keyboardIsOut = value;
}

- (iRCMKeyboard *)keyboard
{
	return mainKeyboard;
}

- (UIView *)getServerList
{
	return serverListView;
}
- (UIView *)prefView
{
	return prefView;
}
- (UIView *)mainView
{
	return mainView;
}

- (ChannelView *)channelView
{
	return channelView;
}

- (UIWindow *)mainWindow
{
	return mainWindow;
}

- (UIView *)currentView
{
	return currentView;
}

- (void)transitionToChannelViewWithTransition:(int) trans
{
	[transitionView transition:trans toView:channelView];
	currentView = channelView;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"iRCMChannelDidChangeNotification" object:nil];
}

- (void)transitionToServerViewWithTransition:(int) trans
{
	[transitionView transition:trans toView:serverView];
	currentView = serverView;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"iRCMServerHasDataNotification" object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"iRCMChannelDidChangeNotification" object:nil];
}


- (void)transitionToServerListWithTransition:(int) trans
{
	NSLog(@"inside transToMain");
	[[iRCMobileApp sharedInstance] setKeyboardIsOut: NO];
	[transitionView transition:trans toView:serverListView];
	currentView = serverListView;
	[serverTable reloadData];
	//[serverTable reloadData];
	NSLog(@"done transition");
}

- (void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)button
{
	if(bar == mainNavBar)
	{
		if(button == 0)
		{
			NSLog(@"button 0");
			//connect!!!
			//[self createNewServer];
			@try
			{
			
				if([sm isServerConnected:[serverTable selectedRow]] == NO)
				{
					//THIS ERRORS
					//[self showProgressHUD:@"Connecting..." withView:serverListView withRect:CGRectMake(0.0f, 100.0f, 320.0f, 50.0f)];
					
					//tried a sheet..still broke
					/*
					connectingSheet = [[UIAlertSheet alloc] initWithFrame: CGRectMake(0, 220, 320, 220)];
					[connectingSheet setTitle:@"iRC Mobile"];
					[connectingSheet setBodyText:@"Connecting..."];
					[connectingSheet setDelegate: [iRCMobileApp sharedInstance]];
					[connectingSheet presentSheetFromAboveView: [[iRCMobileApp sharedInstance] currentView]];		*/
					
					//try to force it to draw the hud
					//[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
					
					[sm tryToConnect: [serverTable selectedRow]];
					NSLog(@"done with tryToConnect");
				}
				//[self showServerView:[serverTable selectedRow]];
			}
			@catch (NSException *e) {
			}@finally {
			} 
		}
		if(button == 1)
		{
			//preferences
			NSLog(@"button 1");
			@try {
				 [self showServerPrefs:[serverTable selectedRow]];
			}
			@catch ( NSException *e ) {
				 //dealWithTheException;
			}
			@finally {
				 //cleanUp;
			}

		}
		
	} else
	{
		NSLog(@"inside main button pressed!?");

	}
}


- (void)tableRowSelected:(NSNotification *)notification
{
	if ([notification object] == serverTable)
	{
		//NSLog([NSString stringWithFormat:@"%i", [serverTable selectedRow]]);
		if([serverTable selectedRow] == [sm numberOfServers])
		{
			[self createNewServer];
		} else if([sm isServerConnected:[serverTable selectedRow]] == YES)
		{
			[self showServerView:[serverTable selectedRow]];
		}
		
	}
}

- (UITableCell *)table:(UITable *)table cellForRow:(int)row column:(int)col
{
	//get transparent color for background
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		float transparentComponents[4] = {0, 0, 0, 0};
		float grayComponents[4] = {0, 0, 0, 0.4};
		float greenComponents[4] = {0, 0, 1, 1};

	if(row < [sm numberOfServers])
	{
		
		NSLog(@"inside row delegate for row: %i", row);
		
			
		/*
		//Create description label
		UITextLabel *descriptionLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(5.0f, 3.0f, 210.0f, 40.0f)];
		[descriptionLabel setText:[sm getDescriptionForServer: row]];
		[descriptionLabel setWrapsText:YES];
		[descriptionLabel setBackgroundColor:CGColorCreate(colorSpace, transparentComponents)];

		

		UITableCell *cell = [[UITableCell alloc] init];
		[cell addSubview:descriptionLabel];
		[cell setShowDisclosure:YES];
		NSLog(@"returning cell"); */


		UIImageAndTextTableCell *cell = [[UIImageAndTextTableCell alloc] init];
		[cell setTitle: [sm getDescriptionForServer: row]];
		[cell setShowDisclosure:YES];
		
		UITextLabel *activeLabel	=	[[UITextLabel alloc] initWithFrame:CGRectMake(220.0f, 5.0f, 210.0f, 30.0f)];
		[activeLabel setWrapsText:YES];
		[activeLabel setBackgroundColor:CGColorCreate(colorSpace, transparentComponents)];
		
		if([sm isServerConnected:row] == YES)
		{
			[activeLabel setText:@"Conn."];
			[activeLabel setColor:CGColorCreate(colorSpace, greenComponents)];
			[cell setImage:[UIImage applicationImageNamed: @"aim.png"]];
		} else
		{	
			[activeLabel setText:@"Disc."];
			[activeLabel setColor:CGColorCreate(colorSpace, grayComponents)];
		} 
		[cell addSubview: activeLabel];
		return cell;
	}
	else
	{
		UITextLabel *descriptionLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(5.0f, 3.0f, 210.0f, 40.0f)];
		[descriptionLabel setText:@"Add Server..."];
		[descriptionLabel setWrapsText:YES];
		[descriptionLabel setColor:CGColorCreate(colorSpace, grayComponents)];
		[descriptionLabel setBackgroundColor:CGColorCreate(colorSpace, transparentComponents)];

		UITableCell *cell = [[UITableCell alloc] init];
		[cell addSubview:descriptionLabel];
		[cell setShowDisclosure:NO];
		return cell;
	}
}
- (void)reloadData
{
	NSLog(@"reloading data in serverlistview");
	[serverTable reloadData];
}

- (int)numberOfRowsInTable:(UITable *)table
{
	return ([sm numberOfServers] + 1);
}

- (void)showServerView:(int) serverID
{
	NSLog(@"inside showServerView");
	[sm setCurrentServer: serverID];
	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0.0f;
	serverView = [[ServerView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
	[transitionView transition:1 toView:serverView];
}

- (void)showServerPrefs:(int) serverID
{
	[sm setCurrentServer: serverID];
	NSLog(@"inside ShowServer with id: %i", [sm currentServer]);
	
	//if (!prefView)
	//{
		struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
		rect.origin.x = rect.origin.y = 0.0f;
	
		prefView = [[ServerPrefsView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
	//}
	
	[transitionView transition:1 toView:prefView];
	NSLog(@"done transition");
}
		
- (void)createNewServer
{
	NSLog(@"inside create new server");
	IRCServer *newServer = [[IRCServer alloc] init];
	[newServer setDescription:@""];
	[newServer setHostname:@""];
	[newServer setPort:6667];
	
	int count = [sm addServer:newServer];
	
	[self showServerPrefs:(count - 1)];
}

- (void)showProgressHUD:(NSString *)label  withView:(UIView *)v withRect:(struct CGRect)rect
{
	NSLog(@"inside show hud");
	progress = [[UIProgressHUD alloc] initWithWindow: mainWindow];
	[progress setText: label];
	[progress drawRect: rect];
	[progress show: YES];
	
	[v addSubview:progress];
}

- (void)hideProgressHUD
{
	NSLog(@"inside hide hud");
	//[progress show: NO];
	//[progress removeFromSuperview];
}


- (void)reloadTableData
{
	NSLog(@"Got the message to reload table data");
	[serverTable reloadData];
}

- (void)serverConnectedNotifier
{
	NSLog(@"inside server connected notifier");
	
	//try to force it to draw the hud
	//[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
	
	//[self hideProgressHUD];
	//[connectingSheet dismiss];
	
	[self showServerView:[serverTable selectedRow]];
}

- (void)serverErrorNotifier
{
	NSLog(@"inside server error notifier");
	if([sm isServerConnected:[sm currentServer]] == NO)
	{
		[self transitionToServerListWithTransition:2 ];
	}
}

- (void)applicationWillSuspend
{
	[[ServerManager sharedServerManager] writeToFile:filePath];
}

- (void) applicationDidFinishLaunching: (id) unused
{
	sharedInstance = self;
	
	//get bundle
	NSBundle *bundle = [NSBundle mainBundle];

	
	//Get full screen app rect
	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0.0f;
	
   dirPath = @"/var/root/Library/iRCM";
   filePath = @"/var/root/Library/iRCM/servers.mms";

	//Check to see if directory exists
	if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath])
	{
		NSLog(@"had to create directory.");
		[[NSFileManager defaultManager] createDirectoryAtPath:dirPath attributes:nil];
	}
	
	
	//initialize server manager
	//sm = [[ServerManager alloc] init];
	sm = [[ServerManager alloc] initWithContentsOfFile:filePath];

	
   
	//initialize nav bar
    mainNavBar = [[UINavigationBar alloc] init];
	[mainNavBar setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 45.0f)];
    [mainNavBar showLeftButton:@"Edit Server" withStyle:0 rightButton:@"Connect" withStyle:0];
	[mainNavBar setDelegate:self];
	[mainNavBar setBarStyle: 2];
	
	UINavigationItem *iRCMTitle = [[UINavigationItem alloc] initWithTitle:@"iRCm"];
	[mainNavBar pushNavigationItem:iRCMTitle];

	
	//setup background
	NSString *backgroundPath = [bundle pathForResource:@"Background" ofType:@"png"];
    UIImage *theDefault = [[UIImage alloc]initWithContentsOfFile:backgroundPath];
	UIImageView *workaround = [[UIImageView alloc] init];
	[workaround setImage:theDefault];
	
	//setup server table
	serverTable = [[UITable alloc] initWithFrame:CGRectMake(rect.origin.x, 45.0f, rect.size.width, rect.size.height - 45.0f)];
	UITableColumn *col = [[UITableColumn alloc] initWithTitle:@"Servers" identifier:@"servers" width:rect.size.width];
	[serverTable addTableColumn:col];
	[serverTable setSeparatorStyle:1];
	[serverTable setRowHeight:45];
	[serverTable setDataSource:self];
	[serverTable setDelegate:self];
	[serverTable reloadData];
	

	//setup server view
	//serverView = [[UIView alloc] initWithFrame: rect];
	
	channelView = [[ChannelView alloc] initWithFrame: rect];
	
	//setup serverListView
	serverListView = [[UIView alloc] initWithFrame: rect];
	[serverListView addSubview: workaround];
    [serverListView addSubview: mainNavBar]; 
	[serverListView addSubview: serverTable];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(reloadTableData)
												 name:@"iRCMServersDidChangeNotification"
											   object:nil];
											   
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(serverConnectedNotifier)
												 name:@"iRCMServerConnectedNotification"
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(serverConnectedNotifier)
												 name:@"iRCMServerConnectedNotification"
											   object:nil];
											   
[[NSNotificationCenter defaultCenter] postNotificationName:@"iRCMServerErrorNotification" object:nil];


	//setup transitionview
	transitionView = [[UITransitionView alloc] initWithFrame:rect];
  
	//setup mainview
	mainView = [[UIView alloc] initWithFrame: rect];
	[mainView addSubview: transitionView];

		
	//setup window
    mainWindow = [[UIWindow alloc] initWithContentRect: [UIHardware fullScreenApplicationContentRect]];
	[mainWindow orderFront: self];
	[mainWindow makeKey: self];
	[mainWindow _setHidden: NO];
    [mainWindow setContentView: mainView]; 
	
	
	
	[transitionView transition:1 toView:serverListView];
	
	currentView = serverListView;
	
	mainKeyboard =  [[iRCMKeyboard alloc] initWithFrame:CGRectMake(0.0f, 480.0, 320.0f, 480.0f)];
	//[mainKeyboard setTapDelegate:this];
}

- (void)setKeyboard: (iRCMKeyboard *)keybd
{
	mainKeyboard = keybd;
}




@end

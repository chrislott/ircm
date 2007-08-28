//
//  ServerPrefsView.m
//  
//
//  Created by Chris on 8/16/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "iRCMobileApp.h"
#import "ServerView.h"
#import <UIKit/UIPreferencesTableCell.h>
#import <UIKit/UIPreferencesTextTableCell.h>
#import <UIKit/UINavigationItem.h>

@implementation ServerView



- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		frame.origin.x = frame.origin.y = 0;
		//Colors
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		float whiteComponents[4] = {1, 1, 1, 1};
		//float transparentComponents[4] = {0, 0, 0, 0};
		
		//setup nav bar
		serverBar = [[UINavigationBar alloc] init];
		[serverBar setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 45.0f)];
		[serverBar showLeftButton:@"Back" withStyle:1 rightButton:@"Join Chan" withStyle:0];
		[serverBar setBarStyle: 2];	
		[serverBar setDelegate: self];
		
		serverTitle = [[UINavigationItem alloc] initWithTitle:@""];
		[serverBar pushNavigationItem:serverTitle];
		[serverTitle release];
		
				
		//setup message table
		channelTable = [[UITable alloc] initWithFrame:CGRectMake(frame.origin.x, 45.0f, frame.size.width, frame.size.height - 145.0f)];
		UITableColumn *col = [[UITableColumn alloc] initWithTitle:@"Channels" identifier:@"channels" width:frame.size.width];
		[channelTable addTableColumn:col];
		[channelTable setSeparatorStyle:1];
		[channelTable setRowHeight:45];
		[channelTable setDataSource:self];
		[channelTable setDelegate:self];
		[channelTable reloadData];
		
		messageView = [[UITextView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.size.height-100, frame.size.width, 100)];
		[messageView setText:@""];
		[messageView setEditable:NO]; // don't mess up my pretty output
		[messageView setAllowsRubberBanding:YES];
		[messageView displayScrollerIndicators];
		[messageView setOpaque:NO];
		[messageView setTextSize:12];
		[messageView setTextFont:@"CourierNewBold"];
		
		//get keyboard
		keyboard = [[iRCMobileApp sharedInstance] keyboard];
		if (!keyboard)  
		{
			NSLog(@"have to make new keyboard??");
		}
		
		[[iRCMobileApp sharedInstance] setKeyboardIsOut: NO];
		
		[self setBackgroundColor:CGColorCreate(colorSpace, whiteComponents)];
		
		[self addSubview:serverBar];
		[self addSubview:channelTable];
		[self addSubview:messageView];
		//[self addSubview:keyboard];
		
		
		
		//register self
			[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(getLastData)
												 name:@"iRCMServerHasDataNotification"
											   object:nil];
		
		
    }
    return self;
}

- (void)getLastData
{
	NSLog(@"got new data");
	
	NSString *currServDesc =  [[ServerManager sharedServerManager] currentServerDesc];
	[serverTitle setTitle:	[currServDesc copy]];
	
	[messageView setText: [[ [ServerManager sharedServerManager] getLastDataForServer:[ [ServerManager sharedServerManager] currentServer]] copy]];
	[channelTable reloadData];
}

- (void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)button
{
	if(button == 0)
	{
		//table??
		NSLog(@"0 btn pressed");
		//[[iRCMobileApp sharedInstance] transitionToView: [[iRCMobileApp sharedInstance] getServerList] transition: 2];
		[[ServerManager sharedServerManager] tryToJoin:@"#iphone" forServer: [[ServerManager sharedServerManager] currentServer]];
	}
	if(button == 1)
	{
		//back -- save the server!!
		//NSLog(@"1 btn pressed");
		
		[[iRCMobileApp sharedInstance] transitionToServerListWithTransition:2];
	}
}

- (void)tableRowSelected:(NSNotification *)notification
{
	if ([notification object] == channelTable)
	{
		NSLog([NSString stringWithFormat:@"%i", [channelTable selectedRow]]);
		
		[[ServerManager sharedServerManager] setCurrentChannel: [channelTable selectedRow]];
		
		[[iRCMobileApp sharedInstance] transitionToChannelViewWithTransition:1];
		
		//[self showServer:[serverTable selectedRow]];
	}
}

- (UITableCell *)table:(UITable *)table cellForRow:(int)row column:(int)col
{
	NSLog(@"inside row delegate for row: %i", row);
	
	//get transparent color for background
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	float transparentComponents[4] = {0, 0, 0, 0};

	
	
	//Create description label
	UITextLabel *descriptionLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(5.0f, 3.0f, 210.0f, 40.0f)];
	[descriptionLabel setText:[[ServerManager sharedServerManager] channelNameForChannel: row forServer:[[ServerManager sharedServerManager] currentServer] ]];
	[descriptionLabel setWrapsText:YES];
	[descriptionLabel setBackgroundColor:CGColorCreate(colorSpace, transparentComponents)];
	
	UITableCell *cell = [[UITableCell alloc] init];
	[cell addSubview:descriptionLabel];
	[cell setShowDisclosure:YES];
	NSLog(@"returning cell");

	return cell;
}

- (int)numberOfRowsInTable:(UITable *)table
{
	int rowcount = [[ServerManager sharedServerManager] numberOfChannelsForServer:[[ServerManager sharedServerManager] currentServer]];
	NSLog(@"got number of channels for server: %i", rowcount);
	return rowcount;
}





- (void)drawRect:(CGRect)rect {
    // Drawing code here.
	[super drawRect:rect];
}

- (void)dealloc
{
	[ super dealloc ];
}


@end

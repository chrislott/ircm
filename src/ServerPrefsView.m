//
//  ServerPrefsView.m
//  
//
//  Created by Chris on 8/16/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "iRCMobileApp.h"
#import "ServerManager.h"
#import "ServerPrefTable.h"
#import <UIKit/UIPreferencesTableCell.h>
#import <UIKit/UIPreferencesTextTableCell.h>

@implementation ServerPrefsView




- (void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)button
{
	if(button == 0)
	{
		//connect
		//NSLog(@"0 btn pressed");
		[[iRCMobileApp sharedInstance] transitionToServerListWithTransition: 2];
		int currentServer = [[ServerManager sharedServerManager] currentServer];
		[[ServerManager sharedServerManager] removeServer: currentServer];
	}
	if(button == 1)
	{
		//back -- save the server!!
		//NSLog(@"1 btn pressed");
		//we have to make it new or else it gets screwed up.
		ServerManager *sm = [ServerManager sharedServerManager];
		
		NSLog(@"getting server manager.");
		int currentServer = [sm currentServer];
		NSLog(@"saving server.");
		
		[sm setDescription: [nameField text] forServer:currentServer];
		[sm setHostname: [hostField text] forServer:currentServer];
		[sm setPort: [[portField text] intValue] forServer:currentServer];
		
		NSLog(@"Saving nickname: %@", [NSString stringWithFormat:@"%@", [nickField text]]);
		
		[sm setNickname: [nickField text] forServer:currentServer];
		
		[[iRCMobileApp sharedInstance] transitionToServerListWithTransition:2];
	}
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		frame.origin.x = frame.origin.y = 0;
		//Colors
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		float whiteComponents[4] = {1, 1, 1, 1};
		float transparentComponents[4] = {0, 0, 0, 0};
		
		//get current server information		
		ServerManager *sm = [ServerManager sharedServerManager];

			
		
		//setup nav bar
		serverPrefBar = [[UINavigationBar alloc] init];
		[serverPrefBar setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 45.0f)];
		[serverPrefBar showLeftButton:@"Back" withStyle:1 rightButton:@"Delete" withStyle:0];
		[serverPrefBar setBarStyle: 2];	
		[serverPrefBar setDelegate: self];
				
				
		//setup ui components
		UITextLabel *nameTitle = [[UITextLabel alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 200.0f, 20.0f)];
		[nameTitle setText:@"Server Name: "];
		[nameTitle setBackgroundColor:CGColorCreate(colorSpace, transparentComponents)];
		nameField = [[iRCMTextView alloc] initWithFrame:CGRectMake(5.0f, 28.0f, 310.0f, 35.0f)];
		[nameField setTextSize:18.0f];
			
		[nameField setText: [sm currentServerDesc]];
	
	
		
		UITextLabel *hostTitle = [[UITextLabel alloc] initWithFrame:CGRectMake(5.0f, 80.0f, 200.0f, 20.0f)];
		[hostTitle setText:@"Hostname: "];
		[hostTitle setBackgroundColor:CGColorCreate(colorSpace, transparentComponents)];
		hostField = [[iRCMTextView alloc] initWithFrame:CGRectMake(5.0f, 100.0f, 310.0f, 35.0f)];
		[hostField setTextSize:18.0f];
		[hostField setText: [sm currentServerHostname]];
		
		UITextLabel *portTitle = [[UITextLabel alloc] initWithFrame:CGRectMake(5.0f, 160.0f, 50.0f, 20.0f)];
		[portTitle setText:@"Port: "];
		[portTitle setBackgroundColor:CGColorCreate(colorSpace, transparentComponents)];
		portField = [[iRCMTextView alloc] initWithFrame:CGRectMake(55.0f, 152.0f, 130.0f, 35.0f)];
		[portField setTextSize:18.0f];
		[portField setText: [NSString stringWithFormat:@"%i", [sm currentServerPort]]];

		UITextLabel *nickTitle = [[UITextLabel alloc] initWithFrame:CGRectMake(5.0f, 200.0f,100.0f, 20.0f)];
		[nickTitle setText:@"Nickname: "];
		[nickTitle setBackgroundColor:CGColorCreate(colorSpace, transparentComponents)];
		nickField = [[iRCMTextView alloc] initWithFrame:CGRectMake(100.0f, 192.0f, 210.0f, 35.0f)];
		[nickField setTextSize:18.0f];
		[nickField setText: [sm currentServerNick]];
		
		/*
		typeSelection = [[UISegmentedControl alloc] initWithFrame:CGRectMake(75.0f, 180.0f, 170.0f, 50.0f)];
		[typeSelection insertSegment:0 withTitle:@"Debit" animated:NO];
		[typeSelection insertSegment:1 withTitle:@"Credit" animated:NO];
		
		dateLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 300.0f, 40.0f)];
		[dateLabel setBackgroundColor:CGColorCreate(colorSpace, transparentComponents)];
		[dateLabel setCentersHorizontally:YES];
		
		UIValueButton *dateButton = [[UIValueButton alloc] initWithFrame:CGRectMake(5.0f, 240.0f, 310.0f, 50.0f)];
		[dateButton addSubview:dateLabel]; */
		
		
		ServerPrefTable *table = [[ServerPrefTable alloc] initWithFrame:CGRectMake(0.0f, 45.0f, 320.0f, 480.0f)];
		[table addSubview:nameTitle];
		[table addSubview:nameField];
		[table addSubview:hostTitle];
		[table addSubview:hostField];
		[table addSubview:portTitle];
		[table addSubview:portField];
		[table addSubview:nickTitle];
		[table addSubview:nickField];

		//[table addSubview:dateButton];
		
		//if (!keyboard) keyboard = [[MMKeyboard alloc] initWithFrame:CGRectMake(0.0f, 480.0, 320.0f, 480.0f)];
		//keyboardIsOut = false;
		
		//get keyboard
		prefKeyboard = [[iRCMobileApp sharedInstance] keyboard];
		
		if (!prefKeyboard)  
		{
			NSLog(@"have to make new keyboard??");
		}
		[[iRCMobileApp sharedInstance] setKeyboardIsOut: NO];
		
		[self setBackgroundColor:CGColorCreate(colorSpace, whiteComponents)];
		
		[self addSubview:serverPrefBar];
		[self addSubview:table];
		[self addSubview:prefKeyboard];
		
    }
    return self;
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

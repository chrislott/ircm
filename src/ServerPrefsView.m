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
#import "iRCMTextTableCell.h"
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
		
		[sm setDescription: [[table cellAtRow:1 column:0] value] forServer:currentServer];
		[sm setHostname: [[table cellAtRow:2 column:0] value] forServer:currentServer];
		[sm setPort: [[[table cellAtRow:3 column:0] value] intValue] forServer:currentServer];
		
		//[sm setDescription: [nameField text] forServer:currentServer];
		//[sm setHostname: [hostField text] forServer:currentServer];
		//[sm setPort: [[portField text] intValue] forServer:currentServer];
		
		NSLog(@"Saving nickname: %@", [NSString stringWithFormat:@"%@", [[table cellAtRow:3 column:0] value]]);
		
		[sm setNickname: [[table cellAtRow:4 column:0] value]  forServer:currentServer];
		
		[[iRCMobileApp sharedInstance] transitionToServerListWithTransition:2];
	}
}


#pragma mark ----------Datasource Methods-----------

- (int)numberOfGroupsInPreferencesTable:(UIPreferencesTable *)table
{
	return 1;
}

- (int)preferencesTable:(UIPreferencesTable *)table numberOfRowsInGroup:(int)group
{
	return 5;
}

- (UIPreferencesTableCell *)preferencesTable:(UIPreferencesTable *)table cellForGroup:(int)group
{
	UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
	
	return [cell autorelease];
}

- (UIPreferencesTableCell *)preferencesTable:(UIPreferencesTable *)table cellForRow:(int)row inGroup:(int)group
{
	UIPreferencesTextTableCell *cell;
	ServerManager *sm = [ServerManager sharedServerManager];
	
	if (row == 0)
	{
		cell = [[UIPreferencesTextTableCell alloc] init];
		//NSLog(@"%@", [UITextField defaultEditingDelegate]);
		//[[cell textField] setDelegate:self];
		[cell setTitle:@"Server Name"];
		[cell setValue: [sm currentServerDesc]];
		[cell setShowDisclosure:NO];
		//cell = descriptionCell;
	} else if (row == 1)
	{
		cell = [[UIPreferencesTextTableCell alloc] init];
		//NSLog(@"%@", [UITextField defaultEditingDelegate]);
		//[[cell textField] setDelegate:self];
		[cell setTitle:@"Host Name"];
		[cell setValue: [sm currentServerHostname]];
		[cell setShowDisclosure:NO];
		//cell = descriptionCell;
	} else if (row == 2) {
		cell = [[iRCMTextTableCell alloc] init];
		//[[cell textField] poseAsClass:[UITextField class]];
		[cell setTitle:@"Port"];
		
		[cell setValue:[NSString stringWithFormat:@"%i", [sm currentServerPort]]];
		[cell setShowDisclosure:NO];
		//cell = amountCell;
	} else if (row == 3)
	{
		cell = [[UIPreferencesTextTableCell alloc] init];
		//NSLog(@"%@", [UITextField defaultEditingDelegate]);
		//[[cell textField] setDelegate:self];
		[cell setTitle:@"Nick Name"];
		[cell setValue: [sm currentServerNick]];
		[cell setShowDisclosure:NO];
		//cell = descriptionCell;
	} else {
		cell = [[UIPreferencesTableCell alloc] init];
		[cell setTitle:@"User Name"];
		[cell setValue: [sm currentServerUsername]];
		[cell setShowDisclosure:NO];
		//cell = typeCell;
	}
	
	return [cell autorelease];
}



- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		frame.origin.x = frame.origin.y = 0;
		//Colors
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		float whiteComponents[4] = {1, 1, 1, 1};
		float transparentComponents[4] = {0, 0, 0, 0};
				
		//setup nav bar
		serverPrefBar = [[UINavigationBar alloc] init];
		[serverPrefBar setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 45.0f)];
		[serverPrefBar showLeftButton:@"Back" withStyle:1 rightButton:@"Delete" withStyle:0];
		[serverPrefBar setBarStyle: 2];	
		[serverPrefBar setDelegate: self];
				
				
		//setup ui components
		/*
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
		
		
		*/
		/*
		typeSelection = [[UISegmentedControl alloc] initWithFrame:CGRectMake(75.0f, 180.0f, 170.0f, 50.0f)];
		[typeSelection insertSegment:0 withTitle:@"Debit" animated:NO];
		[typeSelection insertSegment:1 withTitle:@"Credit" animated:NO];
		
		dateLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 300.0f, 40.0f)];
		[dateLabel setBackgroundColor:CGColorCreate(colorSpace, transparentComponents)];
		[dateLabel setCentersHorizontally:YES];
		
		UIValueButton *dateButton = [[UIValueButton alloc] initWithFrame:CGRectMake(5.0f, 240.0f, 310.0f, 50.0f)];
		[dateButton addSubview:dateLabel]; */
		
		
		table = [[UIPreferencesTable alloc] initWithFrame:CGRectMake(0.0f, 45.0f, 320.0f, 415.0f)];
		[table setDataSource:self];
		[table setDelegate:self];
		[table reloadData];

		/*
		[table addSubview:nameTitle];
		[table addSubview:nameField];
		[table addSubview:hostTitle];
		[table addSubview:hostField];
		[table addSubview:portTitle];
		[table addSubview:portField];
		[table addSubview:nickTitle];
		[table addSubview:nickField];
		*/

		//[table addSubview:dateButton];
		
		//if (!keyboard) keyboard = [[MMKeyboard alloc] initWithFrame:CGRectMake(0.0f, 480.0, 320.0f, 480.0f)];
		//keyboardIsOut = false;
		
		//get keyboard
		/*
		prefKeyboard = [[iRCMobileApp sharedInstance] keyboard];
		
		if (!prefKeyboard)  
		{
			NSLog(@"have to make new keyboard??");
		}
		[[iRCMobileApp sharedInstance] setKeyboardIsOut: NO];*/
		
		[self setBackgroundColor:CGColorCreate(colorSpace, whiteComponents)];
		
		[self addSubview:serverPrefBar];
		[self addSubview:table];
		//[self addSubview:prefKeyboard];
		
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


@implementation iRCMTextTableCell

- (void)_textFieldStartEditing:(id)fp8
{
	NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.01
													  target:self
													selector:@selector(showKeyboardWithStyle:)
													userInfo:[NSArray arrayWithObject:[NSNumber numberWithInt:1]]
													 repeats:NO];
	
	[super _textFieldStartEditing:fp8];
}

- (void)_textFieldEndEditing:(id)fp8
{
	NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.01
													  target:self
													selector:@selector(showKeyboardWithStyle:)
													userInfo:[NSArray arrayWithObject:[NSNumber numberWithInt:0]]
													 repeats:NO];
	
	[super _textFieldEndEditing:fp8];
}

- (void)showKeyboardWithStyle:(NSTimer *)aTimer
{
	int style = [[[aTimer userInfo] objectAtIndex:0] intValue];
	
	UIKeyboard *keyboard = [UIKeyboard activeKeyboard];
	[keyboard setPreferredKeyboardType:style];
	[keyboard showPreferredLayout];
}

@end

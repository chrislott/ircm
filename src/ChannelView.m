 //
//  ServerPrefsView.m
//  
//
//  Created by Chris on 8/16/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "iRCMobileApp.h"
#import "ServerPrefTable.h"
#import "ChannelView.h"
#import <UIKit/UIPreferencesTableCell.h>
#import <UIKit/UIPreferencesTextTableCell.h>
#import <WebCore/WebFontCache.h>

@implementation ChannelView



- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		frame.origin.x = frame.origin.y = 0;
		//Colors
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		float whiteComponents[4] = {1, 1, 1, 1};
		float transparentComponents[4] = {0, 0, 0, 0};
		
		NSBundle *bundle = [NSBundle mainBundle];
		NSString *backgroundPath = [bundle pathForResource:@"textbar" ofType:@"png"];
		UIImage *theDefault = [[UIImage alloc]initWithContentsOfFile:backgroundPath];
		UIImageView *workaround = [[UIImageView alloc] init];
		[workaround setImage:theDefault];
		
		//setup nav bar
		channelBar = [[UINavigationBar alloc] init];
		[channelBar setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 35.0f)];
		[channelBar showLeftButton:@"Back" withStyle:1 rightButton:@"Users" withStyle:0];
		[channelBar setBarStyle: 2];	
		[channelBar setDelegate: self];
				
		//setup message table
		
		messageTable = [[iRCMUITable alloc] initWithFrame:CGRectMake(frame.origin.x, 35.0f, frame.size.width, frame.size.height - 180.0f - 105.0f)];
		UITableColumn *col = [[UITableColumn alloc] initWithTitle:@"Messages" identifier:@"messages" width:frame.size.width];
		[messageTable addTableColumn:col];
		[messageTable setSeparatorStyle:0];
		[messageTable setDataSource:self];
		[messageTable setDelegate:self];
		[messageTable reloadData]; 
		[messageTable setTapDelegate:self];
		
				
		//title = [[UITextLabel alloc] init];
		//[title setColor:CGColorCreate(colorSpace, whiteComponents)];
		
		//[channelBar addSubview: title];
		/*
		//stolen from apolloim:
		convoView = [[UITextView alloc]initWithFrame:CGRectMake(frame.origin.x,frame.origin.y, frame.size.width, 380.0f)];
		[convoView setEditable:NO];
		[convoView setAllowsRubberBanding:YES];
		[convoView setOpaque:NO];
		[convoView setTextSize:12];
		
		[self addSubview:convoView];			
		_msgBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(frame.origin.x, 380.0f, frame.size.width, 50.0f)];			
		sendField = [[UITextField alloc] initWithFrame:CGRectMake(0,0,frame.size.width,30.0f)];			
		[_msgBar addSubview:sendField];
		[self addSubview:_msgBar];			
		*/

		ServerPrefTable *table = [[ServerPrefTable alloc] initWithFrame:CGRectMake(0.0f,  frame.size.height - 250.0f, 320.0f, 40.0f)];
		
		
		textField = [[MessageTextView alloc] initWithFrame:CGRectMake(5.0f,  5.0f, 310.0f, 25.0f)];
		[textField setTextSize:15.0f];
		[textField setText: @"Enter your text here."];
		[textField setBackgroundColor:CGColorCreate(colorSpace, transparentComponents)];
		
		[table addSubview:workaround];
		[table addSubview: textField];
		
		//get keyboard
		//chanKeyboard = [[iRCMobileApp sharedInstance] keyboard];
		//if (!chanKeyboard)  
		//{
			//chanKeyboard = [[iRCMobileApp sharedInstance] keyboard];
			chanKeyboard  =  [[UIKeyboard alloc] initWithFrame:CGRectMake(0.0f, 245.0, 320.0f, 480.0f)];
			//NSLog(@"have to make new keyboard??");
			//[[iRCMobileApp sharedInstance] setKeyboard:chanKeyboard];
		//}
		
		
		[self setBackgroundColor:CGColorCreate(colorSpace, whiteComponents)];
		
		
		[self addSubview:channelBar];
		[self addSubview:messageTable];
		
		[self addSubview:table];
				

		[self addSubview:chanKeyboard];
		[self becomeFirstResponder];
		
		
		//register self
			[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(getData)
												 name:@"iRCMChannelDidChangeNotification"
											   object:nil];
    }
    return self;
}

- (void)getData
{
	
	NSString *nameForChannel = [[ServerManager sharedServerManager] getCurrentChannelName];
	[channelBar setPrompt: nameForChannel];
	//[channelBar setTitle: nameForChannel];

	//[title setText: nameForChannel];
	//get last message received
	/*
	int row = [[ServerManager sharedServerManager] getCurrentChannelMessageCount] - 1;
	NSString *lastMsg = [[ServerManager sharedServerManager] getCurrentChannelMessage: row];
	NSLog(@"got last channel message: %@", lastMsg); */


	NSLog(@"channel view >> Reloading data");
	[messageTable reloadData];
	
	if([messageTable numberOfRows] > 0)
	{
		[messageTable scrollRowToVisible: ([messageTable numberOfRows] - 1)];
	}
}

- (void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)button
{
	if(button == 0)
	{
		//table??
		NSLog(@"Users Btn Pressed");
		//[[iRCMobileApp sharedInstance] transitionToView: [[iRCMobileApp sharedInstance] getServerList] transition: 2];
	}
	if(button == 1)
	{
		//NSLog(@"1 btn pressed");
		[[iRCMobileApp sharedInstance] transitionToServerViewWithTransition:2];
	}
}


- (void)mouseUp:(struct __GSEvent *)fp8
{
  if ([messageTable isScrolling]) {
    // Ignore mouse events that cause scrolling
  } else{
    // NSLog(@"MouseUp: not scrolling\n");
	//[[[iRCMobileApp sharedInstance] keyboard] showKeyboardForView:[[iRCMobileApp sharedInstance] channelView]];
  }
  [super mouseUp:fp8];
}


- (void)tableRowSelected:(NSNotification *)notification
{
	if ([notification object] == messageTable)
	{
		NSLog([NSString stringWithFormat:@"%i", [messageTable selectedRow]]);
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
	UITextLabel *descriptionLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(5.0f, 3.0f, 320.0f, 40.0f)];
	NSString *theMsg = [[ServerManager sharedServerManager] getCurrentChannelMessage: row];
	//struct __GSFont *font = [WebFontCache createFontWithFamily:@"Helvetica" traits:2 size:12.0];
	
	//[descriptionLabel setFont:font];
	[descriptionLabel setText:theMsg];
	[descriptionLabel setWrapsText:YES];
	[descriptionLabel setBackgroundColor:CGColorCreate(colorSpace, transparentComponents)];


	UITableCell *cell = [[UITableCell alloc] init];
	[cell addSubview:descriptionLabel];
	NSLog(@"returning cell");

	return cell;
}

- (int)numberOfRowsInTable:(UITable *)table
{
	NSLog(@"Channel View >> get number rows in table");
	int rowcount = [[ServerManager sharedServerManager] getCurrentChannelMessageCount];
	NSLog(@"Channel View >> End rows in table result  : %i", rowcount);
	return rowcount;
} 

- (void)sendMessage:(NSString *)messageToSend
{
	[[ServerManager sharedServerManager] sendCurrentChannelPM: messageToSend];
}


// keyboard shit





- (void)drawRect:(CGRect)rect {
    // Drawing code here.
	[super drawRect:rect];
}

- (void)dealloc
{
	[ super dealloc ];
}


@end

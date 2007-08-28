//
//  ServerPrefsView.h
//  
//
//  Created by Chris on 8/16/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIKit.h>
#import <UIKit/UITextField.h>
#import <UIKit/UITextView.h>
#import <UIKit/UIPreferencesTable.h>
#import <UIKit/UIPreferencesTableCell.h>
#import <UIKit/UIPreferencesTextTableCell.h>

#import "IRCServer.h"
#import "iRCMTextView.h"
#import "iRCMKeyboard.h"

@interface ServerPrefsView : UIView
{
	UINavigationBar *serverPrefBar;
	//iRCMTextView *nameField;
	//iRCMTextView *hostField;
	//iRCMTextView *portField;
	//iRCMTextView *nickField;
	//iRCMTextView *usernameField;
	//iRCMTextView *realnameField; 
	
	//iRCMKeyboard *prefKeyboard;
	
	UIPreferencesTable *table;
	
}


- (id)initWithFrame: (CGRect)frame;
- (void)dealloc;
- (void)drawRect:(CGRect)frame;

- (void)reloadTableData;

//Delegate Methods
- (void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)button;

//- (void)tableRowSelected:(NSNotification *)notification;

//DataSource Methods
- (int)numberOfGroupsInPreferencesTable:(UIPreferencesTable *)table;
- (int)preferencesTable:(UIPreferencesTable *)table numberOfRowsInGroup:(int)group;
- (UIPreferencesTableCell *)preferencesTable:(UIPreferencesTable *)table cellForGroup:(int)group;
- (UIPreferencesTableCell *)preferencesTable:(UIPreferencesTable *)table cellForRow:(int)row inGroup:(int)group;

@end

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
#import <UIKit/UIKeyboard.h>
#import "IRCServer.h"
#import "iRCMKeyboard.h"
#import "iRCMUITable.h"
#import "MessageTextView.h"

@interface ChannelView : UIView
{
	UINavigationBar *channelBar;
	
	iRCMUITable *messageTable;
	UITextView *messageView;
	
	//iRCMKeyboard* chanKeyboard;
	
	
	iRCMKeyboard* chanKeyboard;
	
	UITextLabel *title;
	UITextView* convoView;

	UINavigationBar *_msgBar;
	MessageTextView *textField;
}

- (id)initWithFrame: (CGRect)frame;
- (void)dealloc;
- (void)drawRect:(CGRect)frame;
@end

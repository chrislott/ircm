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

@interface ServerView : UIView
{
	UINavigationBar *serverBar;
	UITable *channelTable;
	UITextView *messageView;
	
	iRCMKeyboard* keyboard;
}


- (id)initWithFrame: (CGRect)frame;
- (void)dealloc;
- (void)drawRect:(CGRect)frame;
@end

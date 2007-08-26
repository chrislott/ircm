
#import <UIKit/UIKit.h>
//#import <WebCore/WebFontCache.h>
#import "IRCServer.h"
#import "ServerPrefsView.h"
#import "ServerManager.h"
#import "ServerView.h"
#import "ChannelView.h"
#import "iRCMKeyboard.h"
#import "iRCMUITable.h"


@class UIWindow, UIView, UITextView, UITextLabel, UITransitionView, UISegmentedControl, UINavigationBar, UIDatePicker;

@interface iRCMobileApp : UIApplication {
	UIWindow *mainWindow;
	UINavigationBar *mainNavBar;
	UIView *mainView;
	UITable *serverTable;

	UITransitionView *transitionView;
	iRCMKeyboard *mainKeyboard;
	UIView *serverListView;
	ServerPrefsView *prefView;
	ServerView *serverView;
	ChannelView *channelView;
	ServerManager *sm;
	
	
}

+ (iRCMobileApp *)sharedInstance;
- (void)reloadData;
- (BOOL)keyboardIsOut;
- (void)setKeyboardIsOut:(BOOL)value;
- (void)setKeyboard: (iRCMKeyboard *)keybd;

- (iRCMKeyboard *)keyboard;
- (UIView *)getServerList;
- (UIView *)prefView;
- (UIView *)channelView;
- (void)transitionToChannelViewWithTransition:(int) trans;
- (void)transitionToServerViewWithTransition:(int) trans;
- (void)transitionToServerListWithTransition:(int) trans;
- (void)showServerView:(int) serverID;
- (void)showServerPrefs:(int)serverID;
- (void)createNewServer;

@end 

#import <UIKit/UIKit.h>

#import <UIKit/UIProgressHUD.h>
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
	
	UIProgressHUD *progress;
	
	UITransitionView *transitionView;
	iRCMKeyboard *mainKeyboard;
	UIView *serverListView;
	ServerPrefsView *prefView;
	ServerView *serverView;
	ChannelView *channelView;
	ServerManager *sm;
	
	UIView *currentView;
	UIAlertSheet *connectingSheet; 
		
	NSString *dirPath;
	NSString *filePath;
}


- (void)applicationWillSuspend;
+ (iRCMobileApp *)sharedInstance;
- (void)reloadData;
- (BOOL)keyboardIsOut;
- (void)setKeyboardIsOut:(BOOL)value;
- (void)setKeyboard: (iRCMKeyboard *)keybd;
- (UIWindow *)mainWindow;
- (iRCMKeyboard *)keyboard;
- (UIView *)getServerList;
- (UIView *)prefView;
- (UIView *)mainView;
- (ChannelView *)channelView;
- (UIView *)currentView;
- (void)transitionToChannelViewWithTransition:(int) trans;
- (void)transitionToServerViewWithTransition:(int) trans;
- (void)transitionToServerListWithTransition:(int) trans;
- (void)showServerView:(int) serverID;
- (void)showServerPrefs:(int)serverID;
- (void)createNewServer;
- (void)showProgressHUD:(NSString *)label withView:(UIView *)v withRect:(struct CGRect)rect;
- (void)hideProgressHUD;
- (void)alertSheet:(UIAlertSheet *)sheet buttonClicked:(int)button;
@end 
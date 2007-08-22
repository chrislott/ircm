#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIKeyboard.h>
#import <UIKit/UIView.h>

@interface iRCMKeyboard : UIKeyboard {
	
}
- (void)showKeyboardForView:(UIView *)view;
- (void)hideKeyboardForView:(UIView *)view;
- (BOOL)toggleKeyboardForView:(UIView *)view;

@end
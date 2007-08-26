#import "iRCMKeyboard.h"

#import <UIKit/UIAnimator.h>
#import <UIKit/UITransformAnimation.h>
#import <UIKit/UIView.h>

#import "iRCMobileApp.h"

@implementation iRCMKeyboard

- (void)showKeyboardForView:(UIView *)view
{
	iRCMobileApp *iRCM = [iRCMobileApp sharedInstance];
	
	if (![iRCM keyboardIsOut])
	{
		NSLog(@"showing keyboard out");
		[self setTransform:CGAffineTransformMake(1,0,0,1,0,0)];
		[self setFrame:CGRectMake(0.0f, 480.0, 320.0f, 480.0f)];
		
		struct CGAffineTransform trans = CGAffineTransformMakeTranslation(0, -235);
		UITransformAnimation *translate = [[UITransformAnimation alloc] initWithTarget:self];
		[translate setStartTransform: CGAffineTransformMake(1,0,0,1,0,0)];
		[translate setEndTransform: trans];
		[[[UIAnimator alloc] init] addAnimation:translate withDuration:.5 start:YES];
		
		[iRCM setKeyboardIsOut:YES];
	}
}
- (void)hideKeyboardForView:(UIView *)view
{
	iRCMobileApp *iRCM = [iRCMobileApp sharedInstance];
	
	if ([iRCM keyboardIsOut])
	{
		NSLog(@"hiding keyboard in");
		struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
		rect.origin.x = rect.origin.y = 0.0f;
		
		[self setTransform:CGAffineTransformMake(1,0,0,1,0,0)];
		[self setFrame:CGRectMake(0.0f, 245.0, 320.0f, 480.0f)];
		
		struct CGAffineTransform trans = CGAffineTransformMakeTranslation(0, 235);
		UITransformAnimation *translate = [[UITransformAnimation alloc] initWithTarget: self];
		[translate setStartTransform: CGAffineTransformMake(1,0,0,1,0,0)];
		[translate setEndTransform: trans];
		[[[UIAnimator alloc] init] addAnimation:translate withDuration:.5 start:YES];
		
		[iRCM setKeyboardIsOut:NO];
	}
}

- (BOOL)toggleKeyboardForView:(UIView *)view
{

	NSLog(@"inside toggle keyboard");
	iRCMobileApp *iRCM = [iRCMobileApp sharedInstance];
	
    ([iRCM keyboardIsOut]) ? [self hideKeyboardForView:view] : [self showKeyboardForView:view];
	
    return [iRCM keyboardIsOut];
}

@end
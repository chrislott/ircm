#import "iRCMTextView.h"

#import "iRCMobileApp.h"

@implementation iRCMTextView

- (void)mouseUp:(struct __GSEvent *)fp8
{
	NSLog(@"inside mouseUp");
	[[[iRCMobileApp sharedInstance] keyboard] showKeyboardForView:[[iRCMobileApp sharedInstance] prefView]];
	
	[super mouseUp:fp8];
}

@end
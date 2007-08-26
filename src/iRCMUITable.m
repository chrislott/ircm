#import "iRCMUITable.h"

#import "iRCMobileApp.h"

@implementation iRCMUITable

- (void)mouseUp:(struct __GSEvent *)fp8
{
	NSLog(@"inside table mouseUp");
	[[[iRCMobileApp sharedInstance] keyboard] showKeyboardForView:[[iRCMobileApp sharedInstance] prefView]];
	
	[super mouseUp:fp8];
}

@end
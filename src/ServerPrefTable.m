#import "ServerPrefTable.h"
#import "iRCMobileApp.h"

@implementation ServerPrefTable

- (void)mouseUp:(struct __GSEvent *)fp8
{
	[[[iRCMobileApp sharedInstance] keyboard] hideKeyboardForView:[[iRCMobileApp sharedInstance] prefView]];
	
	[super mouseUp:fp8];
}

@end
#import "iRCMTextView.h"

#import "iRCMobileApp.h"

@implementation iRCMTextView

- (void)mouseUp:(struct __GSEvent *)fp8
{
	NSLog(@"inside  uitext view mouseUp");
	[[[iRCMobileApp sharedInstance] keyboard] showKeyboardForView:[[iRCMobileApp sharedInstance] channelView]];
	
	[super mouseUp:fp8];
}

@end